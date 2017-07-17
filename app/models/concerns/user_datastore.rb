module UserDatastore
  extend ActiveSupport::Concern

  def regenerate_authentication_token!
    # Datastore::User::NewAuthToken.call(id: id).authentication_token
    # self[:authentication_token] = SecureRandom.base58(24)
  end

  module ClassMethods
    def find(uuid)
      find_by(uuid: Types::UUID[uuid]) if uuid.present?
    end

    def create(args)
      user_attrs = to_datastore(args)
      create_user = Datastore::User.create(user_attrs)
      if create_user[:errors].present?
        OpenStruct.new(create_user.to_h)
      else
        from_datastore create_user
      end
    end

    def where(params)
      Datastore::User.where(params).map do |user_record|
        from_datastore user_record
      end
    end

    def find_by(params)
      if user = Datastore::User.find_by(params)
        from_datastore(user)
      end
    end

    def delete_all
      Datastore::User.delete_all
    end

    def all
      Datastore::User.all.map do |user_record|
        from_datastore user_record
      end
    end

    def to_datastore(attrs)
      Hash[
        attrs.map do |k, v|
          key = k.to_sym
          if key == :id
            [:uuid, v]
          elsif key == :role
            [key, User::ROLES[v.to_s]]
          elsif key == :firstName
            [:first_name, v]
          elsif key == :lastName
            [:last_name, v]
          else
            [key, v]
          end
        end
      ]
    end

    def from_datastore(attrs={})
      attrs = attrs.symbolize_keys
      new(
        id: attrs[:uuid],
        first_name: attrs[:first_name],
        last_name: attrs[:last_name],
        email: attrs[:email],
        role: attrs[:role] ? User::ROLES.keys[attrs[:role]] : nil,
        authentication_token: attrs[:authentication_token],
        password_digest: attrs[:password_digest],
        password: nil,
        errors: attrs[:errors] || {}
      )
    end
  end
end