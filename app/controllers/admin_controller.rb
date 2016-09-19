class AdminController  < BaseController
# layout false

  def mail_test
    
  end
  
  def mail_send
    @message = "<p>Testing MSG</p>".html_safe
    
    HubMailer.welcome_email(params[:email], params[:name], @message).deliver_now 
    
  end
  
  def article_view
    @ArticleList = Article.joins(:article_type,:status)
    .select("articles.id as article_id, articles.title as article_title, 
            article_types.name as type_name, articles.updated_at as updated_time, 
            statuses.name as status_name, articles.journal as journal
            , articles.year as year, articles.volume as volume
            , articles.number as number, articles.month as month
            , articles.pages as pages, articles.isbn as isbn
            , articles.doi as doi, articles.url as url
            , articles.keyword as keyword, articles.abstract as abstract")
    .where("article_types.is_active = true and articles.is_active = false")
    
  end
  
  def article_quality_check
    
    articleItem = Article.find(params[:articleId])
    
    
    if params[:isAccepted] 
      @statusId = Status.find_by name: "Accepted"
      
      articleItem.status = @statusId
      articleItem.is_active = true
      
      @user = User.find(articleItem.user_id)
      
      @subject = "Congratulations"
      
       @message = "<p><b>Congratulations!</b></p>
                  <p>We are informed that the following article has been accepted by Serler:</p>
                  <p><i>#{articleItem.title}</i></p>
                   <p>Thank you so much for using Serler</p>
                   ".html_safe
       
       HubMailer.moderator_confirmation_email(@user, @subject, @message).deliver_now 
       
       @windowMessage =  "<h1>Acceptance email sent</h1>
                  <h3>An acceptance email has sent to #{@user.first_name} #{@user.last_name} at #{@user.email}</h3>".html_safe
    else
      
      @statusId = Status.find_by name: "Rejected"
      articleItem.status = @statusId
      
      @user = User.find(articleItem.user_id)
      
      @subject = "Article rejected"
      
      @message = "<p>Thank you very much for your interesting articles</p>
                  <p>However, we are sorry that the following article has been rejected by Serler:</p>
                  <p><i>#{articleItem.title}</i></p>
                  <p>Please review the following rejection reasons:</p>
                  <ul>".html_safe + 
                  (articleItem.peer_reviewed == false ? "<li>The article has not been peer reviewed yet</li>".html_safe : "".html_safe) +
                  (articleItem.relevance == false ? "<li>The article is not relevant</li>".html_safe : "".html_safe) +
                  (articleItem.not_duplicate == false ? "<li>The article is duplicate</li>".html_safe : "".html_safe) +
                  "</ul>
                  <p>Please double check your article again and contact us if you have any questions</p>
                   ".html_safe
       
      HubMailer.moderator_confirmation_email(@user, @subject, @message).deliver_now 
      
      @windowMessage =  "<h1>Rejection email sent</h1>
                  <h3>A rejection email has sent to #{@user.first_name} #{@user.last_name} at #{@user.email}</h3>".html_safe
    end
    
    articleItem.save
  end
  
  def article_detail
    @article = Article.joins(:article_type,:status)
    .select("articles.peer_reviewed ", "articles.relevance ", "articles.not_duplicate")
    .where("article_types.is_active = true", "articles.is_active = flase", "statuses.is_active = true").find(params[:articleId])
      
    respond_to do |format|
      format.json { render json: {values: @article, operators: @operators} }
    end
  end
  
  def criteria_change
    articleItem = Article.find(params[:articleId])
    articleItem.peer_reviewed = params[:peer_reviewed]
    articleItem.relevance = params[:relevance]
    articleItem.not_duplicate = params[:not_duplicate]
    articleItem.save
  end
  

  def add_dev_method
    @ArticleList = Article.joins(:article_type,:status)
                       .select("articles.id as article_id, articles.title as article_title,
            article_types.name as type_name, articles.updated_at as updated_time,
            statuses.name as status_name, articles.journal as journal
            , articles.year as year, articles.volume as volume
            , articles.number as number, articles.month as month
            , articles.pages as pages, articles.isbn as isbn
            , articles.doi as doi, articles.url as url
            , articles.keyword as keyword, articles.abstract as abstract")
                       .where("article_types.is_active = true and articles.is_active = true")

    #NewArticleDevMethod = articles_dev_method.new(:article_id => , :dev_method_id=> )
    #NewArticleDevMethod.save

  end

  def add_dev_method_page
    @articleid = Article.find(params[:articleid])
    @ArticleList = Article.joins(:article_type,:status)
                       .select("articles.id as article_id, articles.title as article_title,
            article_types.name as type_name, articles.updated_at as updated_time,
            statuses.name as status_name, articles.journal as journal
            , articles.year as year, articles.volume as volume
            , articles.number as number, articles.month as month
            , articles.pages as pages, articles.isbn as isbn
            , articles.doi as doi, articles.url as url
            , articles.keyword as keyword, articles.abstract as abstract")
                       .where("article_types.is_active = true and articles.is_active = true and articles.id = ?",params[:articleid])
  end

  #adds a record to the methodology table and adds a relation to articles methodology table

  def update_methodology

    @name = params[:name]
    @description = params[:description]
    @articleid = params[:articleid]
    # create a record in the methodology  table and add a relation in articles methodology table.
    @m = Methodology.create(:name=> @name, :description=> @description)
    @last_record_save_id=Methodology.last.id
    @am = ArticlesMethodology.create(:article_id => @articleid,:methodology_id => @last_record_save_id,:is_active => true)

  end

  end
