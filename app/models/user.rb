class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
                    
  has_many :favorites
  has_many :likings, through: :favorites, source: :micropost
  has_many :reverses_of_favorite, class_name: 'Favorite', foreign_key: 'micropost_id'
  has_many :likes, through: :reverses_of_favorite, source: :user

  def favorite(micropost)
    self.favorites.find_or_create_by(micropost_id: micropost.id)
  end

  def unfavorite(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  
  def likes?(micropost)
    self.likings.include?(micropost)
  end
  
end
