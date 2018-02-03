class GraphqlController < ApplicationController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      session: session,
      current_user: current_user,
    }
    result = GraphqlTutorialSchema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )
    render json: result
  end

  private

  def current_user
    return unless session[:token]

    crypt = ActiveSupport::MessageEncryptor.new(
      # TODO This byteslice call happens multiple places. DRY it?
      Rails.application.secrets.secret_key_base.byteslice(1..31)
    )
    token = crypt.decrypt_and_verify_session session[:token]
    user_id = token.gsub('user-id:', '').to_i
    User.find_by user_id
  rescue ActiveSupport::MessageVerifer::InvalidSignature
    # TODO Log?
    nil
  end

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end
end
