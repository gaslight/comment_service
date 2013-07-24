class DisqusController < ApplicationController

  def index
    api_key = ENV.fetch('DISQUS_API_KEY')
    forum_id = Disqus::Api.get_forum_list({api_key:api_key})["message"][0]["id"]
    forum_api_key = Disqus::Api.get_forum_api_key({api_key:api_key,forum_id:forum_id})["message"] unless forum_api_key

    thread_list   = Disqus::Api.get_thread_list({forum_api_key:forum_api_key,forum_id:forum_id})["message"]
    thread_ids    = thread_list.collect {|thread| thread["id"]}
    thread_posts  = Disqus::Api.get_num_posts(thread_ids:thread_ids,forum_api_key:forum_api_key)["message"]

    thread_list.each do |thread|
      thread["num_comments"] = thread_posts[thread["id"]][1]
    end

    render json: thread_list
  end
end
