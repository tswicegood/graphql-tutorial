Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :createLink, function: Resolvers::CreateLink.new
  field :createUser, function: Resolvers::CreateUser.new
  field :signInUser, function: Resolvers::SignInUser.new

  # TODO: Remove me
  field :testField, types.String do
    description "An example field added by the generator"
    resolve ->(obj, args, ctx) {
      "Hello World!"
    }
  end
end
