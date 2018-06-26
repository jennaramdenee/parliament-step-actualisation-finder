class StepsController < ApplicationController

  def index
    @steps = ODataRequestHelper.request('ProcedureStep')
  end

  def create
    # json_params = JSON.parse(params[:step])
    # @step_id = json_params[0]
    # @step_name = json_params[1]
    step_id = params[:step_id]
    redirect_to action: 'show', id: step_id
  end

  def show
    @step_id = params[:id]
    @step_name = StepActualisationHelper.get_procedure_step_name(@step_id)
    @business_items = StepActualisationHelper.get_business_items(@step_id)
  end

end

# https://api.parliament.uk/Staging/odata/ProcedureStep('e9G2vHbc')
# /ProcedureStepHasBusinessItem('lrMF8S6U')
# /BusinessItemHasWorkPackage('CERw4sxU')
# /WorkPackageHasWorkPackageableThing?$select=WorkPackageableThingName,LocalId


# Parameters: {"utf8"=>"✓", "authenticity_token"=>"b0oKC1b1v63ZI4wG7HjvhncRmi+kZkOottjRIxCF0w5pfy0iicgkiic/84W1doWurItcaRR6AxHGGq637u1R8w==", "Select step"=>"j7oLnCke", "commit"=>"Get step"}
# <ActionController::Parameters {"utf8"=>"✓", "authenticity_token"=>"b0oKC1b1v63ZI4wG7HjvhncRmi+kZkOottjRIxCF0w5pfy0iicgkiic/84W1doWurItcaRR6AxHGGq637u1R8w==", "Select step"=>"j7oLnCke", "commit"=>"Get step", "controller"=>"steps", "action"=>"create"} permitted: false>
