module StepActualisationHelper

  def self.get_business_items(step_id)
    ODataRequestHelper.request("ProcedureStep('#{step_id}')/ProcedureStepHasBusinessItem")["value"]
  end

  def self.actualised_data(step_id, business_item)
    business_item_id = business_item['LocalId']

    work_package_id = get_work_package_id(step_id, business_item_id)
    if work_package_id
      work_packageable_thing_name = get_work_packageable_thing_name(step_id, business_item_id, work_package_id)
    else
      work_packageable_thing_name = nil
    end

    return work_package_id, work_packageable_thing_name
  end

  # @return Either work package id or nil
  def self.get_work_package_id(step_id, business_item_id)
    work_package = ODataRequestHelper.request("ProcedureStep('#{step_id}')/ProcedureStepHasBusinessItem('#{business_item_id}')/BusinessItemHasWorkPackage")["value"]
    work_package.any? ? work_package.first['LocalId'] : nil
  end

  # @return Either work packageable thing step name or nil
  def self.get_work_packageable_thing_name(step_id, business_item_id, work_package_id)
    work_packageable_thing = ODataRequestHelper.request("ProcedureStep('#{step_id}')/ProcedureStepHasBusinessItem('#{business_item_id}')/BusinessItemHasWorkPackage('#{work_package_id}')/WorkPackageHasWorkPackageableThing")
    work_packageable_thing['WorkPackageableThingName']
  end


  # @return Either step name or nil
  def self.get_procedure_step_name(step_id)
    ODataRequestHelper.request("ProcedureStep('#{step_id}')")["value"].first['ProcedureStepName']
  end
end
