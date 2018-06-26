module StepActualisationHelper

  def self.get_business_items(step_id)
    ODataRequestHelper.request("ProcedureStep('#{step_id}')/ProcedureStepHasBusinessItem")["value"]
  end

  def self.actualised_data(step_id, business_item)
    business_item_id = business_item['LocalId']

    work_package_id = get_work_package_id
    work_packageable_thing_name = get_work_packageable_thing_name

    return work_package_id, work_packageable_thing_name
  end

  def self.get_work_package_id(step_id, business_item_id)
    work_package = ODataRequestHelper.request("ProcedureStep('#{step_id}')/ProcedureStepHasBusinessItem('#{business_item_id}')/BusinessItemHasWorkPackage")["value"].first
    work_package['LocalId']
  end

  def self.get_work_packageable_thing_name(step_id, business_item_id, work_package_id)
    work_packageable_thing = ODataRequestHelper.request("ProcedureStep('#{step_id}')/ProcedureStepHasBusinessItem('#{business_item_id}')/BusinessItemHasWorkPackage('#{work_package_id}')/WorkPackageHasWorkPackageableThing")
    work_packageable_thing['WorkPackageableThingName']
  end

  def self.get_procedure_step_name(step_id)
    ODataRequestHelper.request("ProcedureStep('#{step_id}')")["value"].first['ProcedureStepName']
  end
end
