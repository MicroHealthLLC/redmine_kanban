class KanbanPane::IncomingPane < KanbanPane
  def get_issues(options={})
    return [] if missing_settings('incoming')
    for_option = options.delete(:for)
    user = options.delete(:user)
    user_id = user ? user.id : nil
    exclude_ids = options.delete(:exclude_ids) || []
    limit = options[:limit] || settings['panes']['incoming']['limit']

    conditions = ''
    conditions << "status_id = :status"
    conditions << " AND #{Issue.table_name}.id NOT IN (:excluded_ids)" unless exclude_ids.empty?
    conditions = merge_for_option_conditions(conditions, for_option) if user.present?
    conditions << " AND #{Project.table_name}.status = 1"
    
    Issue.visible.
        where(conditions, {
            :status => settings['panes']['incoming']['status'],
            :excluded_ids => exclude_ids,
            :user => user_id
        }).limit(limit).
        order("#{Issue.table_name}.created_on ASC").
        includes([:watchers, :project]).
        references([:watchers, :project])
  end

end

