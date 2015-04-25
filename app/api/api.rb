class API < Grape::API
  version 'v1', using: :path
  format :json
  default_format :json
  prefix :api

  helpers do
    def comment_params
      ActionController::Parameters.new(params[:comment]).permit(:author, :text)
    end
  end

  resource :comments do
    desc 'GET /api/v1/comments'
    get do
      Comment.all
    end

    desc 'POST /api/v1/comments'
    post do
      Comment.create!(comment_params)
      Comment.all
    end

    params do
      requires :id, type: Integer, desc: 'Comment id'
    end
    route_param :id do
      desc 'GET /api/v1/comments/[:id]'
      get do
        Comment.find(params[:id])
      end
    end
  end
end
