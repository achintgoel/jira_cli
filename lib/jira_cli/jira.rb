require 'jira'

module JiraCli
  class Jira

    TRANSITION_IDS = {
      to_do: 11,
      in_progress: 21,
      done: 31,
      in_review: 41,
      landed: 51,
      triage: 61,
      needs_spec: 71
    }

    attr_accessor :projects, :username, :password, :client
    def config_file
      @config_file ||= "#{ENV['HOME']}/.jira"
    end

    def setup_complete?
      File.exists?(config_file)
    end

    def setup(username, password, project_keys)
      username = username.strip
      password = password.strip

      File.open(config_file, 'w') do |file|
        file.puts(username)
        file.puts(password)
        file.puts(project_keys)
      end
    end

    def load_client
      File.open(config_file, 'r') do |file|
        lines = file.readlines
        @username   = lines[0].strip
        @password   = lines[1].strip
        project_ids = lines[2].split(',').map(&:strip)

        options = {
          :username => @username,
          :password => @password,
          :site => 'https://zenpayroll.atlassian.net',
          :auth_type => :basic,
          :context_path => ''
        }

        @client = JIRA::Client.new(options)
        @projects = project_ids.map { |project_key| @client.Project.find(project_key) }

      end
    end

    def my_issues_per_project
      projects.map do |project|
        issues = @client.Issue.jql("project = '#{project.key}' AND assignee = '#{@username}'")
        [project.id, project.name, issues]
      end
    end

    def find_issue(issue_key)
      issue = @client.Issue.find(issue_key) if issue_key
      issue
    end

    def create_issue(summary, description, project_id)
      issue = @client.Issue.build
      issue.save({"fields"=>{"summary" => summary, "assignee" => {"name" => @username},
                  "project" => {"id" => project_id}, "issuetype"=> {"id"=>"3"}}})

      issue.fetch
      issue
    end

    def in_progress(issue)
      transition = issue.transitions.build
      transition.save!("transition" => {"id" => TRANSITION_IDS[:in_progress]})
    end

    def in_review(issue)
      transition = issue.transitions.build
      transition.save!("transition" => {"id" => TRANSITION_IDS[:in_review]})
    end

    def landed(issue)
      transition = issue.transitions.build
      transition.save!("transition" => {"id" => TRANSITION_IDS[:landed]})
    end
  end
end
