class KanbanPane::BacklogPane < KanbanPane
  def get_issues(options={})
    return {} if missing_settings('backlog')

    for_option = options.delete(:for)
    user = options.delete(:user)
    user_id = user ? user.id : nil
    exclude_ids = options.delete(:exclude_ids)
    limit = options[:limit] || settings['panes']['backlog']['limit']
    restrict_to_project_ids = options[:project_ids] || nil

    conditions = ''
    conditions << " #{Issue.table_name}.status_id IN (:status)"
    conditions << " AND #{Issue.table_name}.id NOT IN (:excluded_ids)" unless exclude_ids.empty?
    conditions = merge_for_option_conditions(conditions, for_option) if user.present?
    conditions << " AND #{Issue.table_name}.project_id IN (:project_ids) " if restrict_to_project_ids.present?
    conditions << " AND #{Project.table_name}.status = 1"

    issues = Issue.visible.where({
                                     :status => settings['panes']['backlog']['status'],
                                     :excluded_ids => exclude_ids,
                                     :assigned_to_id => user_id,
                                     :project_id => restrict_to_project_ids
                                 }).limit(limit).
                               order("#{RedmineKanban::KanbanCompatibility::IssuePriority.klass.table_name}.position ASC, #{Issue.table_name}.created_on ASC").
                               includes([:priority, :project, :watchers]).
                               references([:priority, :project, :watchers])


  end
  
end

