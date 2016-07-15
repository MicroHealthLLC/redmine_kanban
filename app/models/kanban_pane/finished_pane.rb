class KanbanPane::FinishedPane < KanbanPane
  def get_issues(options={})
    return {} if missing_settings('finished')
    for_option = options.delete(:for)
    user = options.delete(:user)
    user_id = user ? user.id : nil

    status_id = settings['panes']['finished']['status']
    days = settings['panes']['finished']['limit'] || 7

    conditions = ''
    conditions << " #{Issue.table_name}.status_id = :status"
    conditions << " AND #{Issue.table_name}.updated_on > :days"
    conditions = merge_for_option_conditions(conditions, for_option) if user.present?

    Issue.visible.includes(:assigned_to, :watchers).
        references(:assigned_to, :watchers).
        order("#{Issue.table_name}.updated_on DESC").
        where(conditions, {
            :status => status_id,
            :days => days.to_f.days.ago,
            :user => user_id
        })
  end

end

