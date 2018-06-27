module StepActualisationHelper

  def self.get_business_items(step_id)
    ODataRequestHelper.request("ProcedureStep('#{step_id}')/ProcedureStepHasBusinessItem")["value"]
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
    step_name = ODataRequestHelper.request("ProcedureStep('#{step_id}')")["value"]
    step_name.any? ? step_name.first['ProcedureStepName'] : nil
  end

  # @return Either business item id or nil
  def self.get_business_item_id(business_item)
    business_item_id = business_item['LocalId']
  end

  def self.actualised_data(step_id, business_item)
    # Exit if there is no business id
    business_item_id = get_business_item_id(business_item)
    return nil, nil unless business_item_id

    # Exit if there is no work package id
    work_package_id = get_work_package_id(step_id, business_item_id)
    return nil, nil unless work_package_id

    work_packageable_thing_name = get_work_packageable_thing_name(step_id, business_item_id, work_package_id)

    return work_package_id, work_packageable_thing_name
  end
end
