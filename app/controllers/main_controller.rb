class MainController < ApplicationController

  def index
    url = params[:url]
    feed = Feedjira::Feed.fetch_and_parse([url])[url]

    if !feed.is_a? Fixnum
      render json: {
        title: feed.title,
        url: feed.url,
        description: feed.description,
        entries: feed.entries.to_a.map do |e|
          {
            title: e.title,
            url: e.url,
            summary: e.summary,
            entry_id: e.entry_id,
            published: e.published,
            author: e.author,
            content: e.content,
            image: e.image,
            links: (e.links rescue []),
            categories: e.categories,
            # e: e
          }
        end
      }
    elsif [200, 301, 302].include?(feed)
      render json: {
        feeds: Feedbag.find(url)
      }
    else [200, 301, 302].includes? feed
      render json: {status: 'NOT A FEED'}
    end

  end
end
