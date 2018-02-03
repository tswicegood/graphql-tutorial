Types::LinkType = GraphQL::ObjectType.define do
  name 'Link'
  description 'Links represent the core of this application'

  field :id, !types.ID, description: 'Auto generated'
  field :url, !types.String, description: 'URL, yo'
  field :description, !types.String, description: 'Pithy and 100% description'

  field :postedBy, -> { Types::UserType }, property: :user
end
