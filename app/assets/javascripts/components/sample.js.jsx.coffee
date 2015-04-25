## Tutorial 1

# $ ->
#   # create a virtualDOM
#   CommentBox = React.createClass
#     render: ->
#       `<div className="CommentBox">Hello, react.js! I am a CommentBox.</div>`
#
#   # rendering virtualDOM to div#container
#   React.render `<CommentBox />`, $('#container')[0]

## Tutorial 2

# $ ->
#
#   # markdown parser
#   converter = new Showdown.converter()
#
#   # create a virtualDOM
#   Comment = React.createClass
#     render: ->
#       rawMarkup = converter.makeHtml @props.children.toString()
#       `<div className="comment">
#          <h2 className="commentAuthor">{ this.props.author }</h2>
#          <span dangerouslySetInnerHTML={ { __html: rawMarkup } }></span>
#        </div>`
#
#   CommentList = React.createClass
#     render: ->
#       commentNodes = @props.data.map (comment) ->
#         `<Comment author={ comment.author }>{ comment.text }</Comment>`
#       `<div className="commentList">{ commentNodes }</div>`
#
#   CommentForm = React.createClass
#     render: ->
#       `<div className="commentForm">
#          Hello world! I am a CommentForm.
#        </div>`
#
#   CommentBox = React.createClass
#     render: ->
#       `<div className="commentBox">
#          <h1>Comment</h1>
#          <CommentList data={ this.props.data } />
#          <CommentForm />
#        </div>`
#
#   data = [
#     { author: 'Pete Hunt', text: 'This is one comment.' }
#     { author: 'Jorden Walke', text: 'This is *another* comment.' }
#   ]
#
#   React.render `<CommentBox data={ data } />`, $('#container')[0]

## Tutorial 3

# $ ->
#
#   converter = new Showdown.converter()
#
#   CommentBox = React.createClass
#     # 1
#     loadCommentsFromServer: ->
#       $.ajax
#         url: @props.url
#         dataType: 'json'
#       .done (data) =>
#         @setState(data: data)
#       .fail (xhr, status, err) =>
#         console.error @props.url, status, err.toString()
#
#     # 2
#     getInitialState: -> data: []
#
#     # 3
#     componentDidMount: ->
#       @loadCommentsFromServer()
#       setInterval @loadCommentsFromServer, @props.pollInterval
#
#     render: ->
#       # 4
#       `<div className="commentBox">
#          <h1>Comment</h1>
#          <CommentList data={ this.state.data } />
#          <CommentForm />
#        </div>`
#
#   CommentList = React.createClass
#     render: ->
#       commentNodes = @props.data.map (comment) ->
#         `<Comment author={ comment.author }>{ comment.text }</Comment>`
#       `<div className="commentList">{ commentNodes }</div>`
#
#   CommentForm = React.createClass
#     render: ->
#       `<div className="commentForm">
#          Hello world! I am a CommentForm.
#        </div>`
#
#   Comment = React.createClass
#     render: ->
#       rawMarkup = converter.makeHtml @props.children.toString()
#       `<div className="comment">
#          <h2 className="commentAuthor">{ this.props.author }</h2>
#          <span dangerouslySetInnerHTML={ { __html: rawMarkup } }></span>
#        </div>`
#
#   # 5
#   React.render(
#     `<CommentBox url="/api/v1/comments" pollInterval={ 2000 } />`,
#     $('#container')[0]
#   )

## Tutorial 4

$ ->

  converter = new Showdown.converter()

  CommentBox = React.createClass
    loadCommentsFromServer: ->
      $.ajax
        url: @props.url
        dataType: 'json'
      .done (data) =>
        @setState(data: data)
      .fail (xhr, status, err) =>
        console.error @props.url, status, err.toString()

    componentDidMount: ->
      @loadCommentsFromServer()
      setInterval @loadCommentsFromServer, @props.pollInterval
    handleCommentSubmit: (comment) ->
      # ajax通信していたらラグがあるので先に描画
      comments = @state.data
      newComments = comments.concat([comment])
      @setState(data: newComments)

      $.ajax
        url: @props.url
        dataType: 'json'
        type: 'POST'
        data: comment: comment
      .done (data) =>
        @setState(data: data)
      .fail (xhr, status, err) =>
        console.error @props.url, status, err.toString()

    getInitialState: -> data: []

    render: ->
      `<div className="commentBox">
         <h1>Comment</h1>
         <CommentList data={ this.state.data } />
         <CommentForm onCommentSubmit={ this.handleCommentSubmit } />
       </div>`

  CommentList = React.createClass
    render: ->
      commentNodes = @props.data.map (comment) ->
        `<Comment author={ comment.author }>{ comment.text }</Comment>`
      `<div className="commentList">{ commentNodes }</div>`

  CommentForm = React.createClass
    handleSubmit: (e) ->
      e.preventDefault()
      author = @refs.author.getDOMNode().value.trim()
      text = @refs.text.getDOMNode().value.trim()
      return unless author and text
      @props.onCommentSubmit(author: author, text: text)
      @refs.author.getDOMNode().value = ''
      @refs.text.getDOMNode().value = ''

    render: ->
      `<form className="commentForm" onSubmit={ this.handleSubmit }>
         <input type="text" placeholder="Your name" ref="author" />
         <input type="text" placeholder="Say something..." ref="text" />
         <input type="submit" value="Post" />
       </form>`

  Comment = React.createClass
    render: ->
      rawMarkup = converter.makeHtml @props.children.toString()
      `<div className="comment">
         <h2 className="commentAuthor">{ this.props.author }</h2>
         <span dangerouslySetInnerHTML={ { __html: rawMarkup } }></span>
       </div>`

  React.render(
    `<CommentBox url="/api/v1/comments" pollInterval={ 2000 } />`,
    $('#container')[0]
  )
