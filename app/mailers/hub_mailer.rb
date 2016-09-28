class HubMailer < ApplicationMailer
  
  layout 'welcome_email'
  def welcome_email(email, name, message)
    
    @name = name
    @message = message
    # @url  = 'http://example.com/login'
    attachments.inline['SerlerLogo_Black.png'] = File.read(Rails.root.join('app/assets/images/SerlerLogo_Black.png'))
    mail(to: email, subject: 'Welcome to Serler') do |format|
      format.html { render layout: 'welcome_email' }
    end
  end
  
  
  def moderator_confirmation_email(user, subject, message)
    
    @fullName = user.first_name + " " + user.last_name
    @message = message
    
    # Add logo
    attachments.inline['SerlerLogo_Black.png'] = File.read(Rails.root.join('app/assets/images/SerlerLogo_Black.png'))
    mail(to: user.email, subject: subject) do |format|
      format.html { render layout: 'moderator_confirmation_email' }
    end
  end

  def new_article_email(article_id)

    article_name = Article.find(article_id)
    @article_title = article_name.title

    @moderator_email = User.joins(:users_roles).select("users.email as mod_email").where("users_roles.role_id = '7'")
    #@moderator_email = @moderator_email1.mod_email

    # Add logo
    attachments.inline['SerlerLogo_Black.png'] = File.read(Rails.root.join('app/assets/images/SerlerLogo_Black.png'))

    @moderator_email.each do |mod|

      @article_list_today = Article.where("created_at >= ?", Time.zone.now.beginning_of_day)

      mail(to: mod.mod_email, subject: 'New Article Submitted') do |format|
        format.html { render layout: 'new_article_email' }
      end
    end
  end
  
end