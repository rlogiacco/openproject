module IFCModelsHelper
  def attachment_content_url(attachment)
    API::V3::Utilities::PathHelper::ApiV3Path.attachment_content(attachment.id)
  end
end