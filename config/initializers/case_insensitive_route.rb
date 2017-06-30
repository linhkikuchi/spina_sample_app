module CaseInsensitiveRoute
  def page_by_locale(locale)
    if rails_api_theme?
      Spina::Page.with_translations(locale).find_by!(materialized_path: spina_request_path.downcase)
    else
      super
    end
  end

  def rails_api_theme?
    current_theme.name == "rails_api"
  end
end

Spina::Frontend.send(:prepend, CaseInsensitiveRoute)