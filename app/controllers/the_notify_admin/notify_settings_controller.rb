class TheNotifyAdmin::NotifySettingsController < TheNotifyAdmin::BaseController
  before_action :set_notify_setting, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:columns] #todo removed

  def index
    q_params = {}
    q_params.merge! params.fetch(:q, {}).permit!
    @notify_settings = NotifySetting.default_where(q_params).page(params[:page])
  end

  def new
    @notify_setting = NotifySetting.new
  end

  def create
    @notify_setting = NotifySetting.new(notify_setting_params)

    if @notify_setting.save
      redirect_to admin_notify_settings_url, notice: 'Notify setting was successfully created.'
    else
      render :new
    end
  end

  def columns
    @notify_setting = NotifySetting.new
    if params[:notifiable_type].present?
      @columns = params[:notifiable_type].constantize.column_names
    else
      @columns = []
    end
  end

  def show
  end

  def edit
    @columns = @notify_setting.notifiable_type.constantize.column_names
  end

  def update
    if @notify_setting.update(notify_setting_params)
      redirect_to admin_notify_settings_url, notice: 'Notify setting was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @notify_setting.destroy
    redirect_to admin_notify_settings_url, notice: 'Notify setting was successfully destroyed.'
  end

  private
  def set_notify_setting
    @notify_setting = NotifySetting.find(params[:id])
  end

  def notify_setting_params
    result = params.fetch(:notify_setting, {}).permit(
      :notifiable_type,
      :notify_mailer,
      :notify_method,
      only_verbose_columns: [],
      except_verbose_columns: [],
      cc_emails: []
    )
    result[:only_verbose_columns].reject! { |i| i.blank? }
    result[:except_verbose_columns].reject! { |i| i.blank? }
    result
  end

end