module ApplicationHelper
  def resource_avatar(resource)
    if resource.avatar.attached?
      image_tag(resource.avatar_thumbnail)
    else
      image('assets/images/default_avatar.png', style: 'width:50px;, height:50px;')
    end
  end
end
