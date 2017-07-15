module PostAPI
  extend ActiveSupport::Concern

  def to_api
    {
      id: id,
      title: title,
      description: description,
      image: image,
      creatorId: user_id,
    }
  end

  module ClassMethods
    def find_for_api(id)
      post_attrs = find(id).to_api
      API::Post.new(post_attrs)
    end

    def from_api(attrs)
      new(
        id: attrs[:id] || attrs["id"],
        title: attrs[:title] || attrs["title"],
        description: attrs[:description] || attrs["description"],
        image: attrs[:image] || attrs["image"],
        user_id: attrs[:creatorId] || attrs["creatorId"]
      )
    end
  end
end