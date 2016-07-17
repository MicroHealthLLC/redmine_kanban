class KanbanPane::QuickPane < KanbanPane
  def get_issues(options={})
    return {} if missing_settings('quick-tasks', :skip_status => true) || missing_settings('backlog')

    conditions = Issue.visible.where ["status_id = ?", settings['panes']['backlog']['status']]
    conditions = conditions.where "estimated_hours IS null or estimated_hours <= 2"

    issues = conditions.where("#{Project.table_name}.status = 1").
        includes([:priority, :project]).references([:priority, :project]).
        limit(settings['panes']['quick-tasks']['limit']).
        order("#{RedmineKanban::KanbanCompatibility::IssuePriority.klass.table_name}.position ASC,
#{Issue.table_name}.created_on ASC")


    return group_by_priority_position(issues)
  end

  def self.pane_name
    'quick-tasks'
  end

  # QuickPane uses different configuration logic since it requires the
  # backlog pane and doesn't have it's own status
  def self.configured?
    KanbanPane::BacklogPane.configured? &&
      settings['panes']['quick-tasks']['limit'].present? &&
      settings['panes']['quick-tasks']['limit'].to_i > 0
  end
  
end

