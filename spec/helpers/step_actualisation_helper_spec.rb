require 'rails_helper'

RSpec.describe 'StepActualisationHelper' do
  let(:valid_odata_response) {
    {
      "@odata.context": "https://api.parliament.uk/odata/$someMetaData",
      "WorkPackageableThingName": "Equine Identification (England) Regulations 2018",
      "value": [
        {
          "LocalId": "e9G2vHbc",
          "ProcedureStepName": "Considered by the Joint Committee on Statutory Instruments (JCSI)"
        }.stringify_keys
      ]
    }.stringify_keys
  }

  let(:empty_odata_response) {
    {
      "@odata.context": "https://api.parliament.uk/odata/$someMetaData",
      "value": []
    }.stringify_keys
  }

  let(:valid_business_item) {
    {
      "LocalId": "c5tH8nfB"
    }.stringify_keys
  }

  let(:invalid_business_item) { {} }

  describe '#get_business_items' do
    context 'making requests' do
      it 'calls ODataRequestHelper' do
        allow(ODataRequestHelper).to receive(:request).and_return(valid_odata_response)
        expect(ODataRequestHelper).to receive(:request)
        StepActualisationHelper.get_business_items('asdfzxcv')
      end
    end
  end

  describe '#get_work_package_id' do
    context 'when work package exists' do
      it 'returns work package id' do
        allow(ODataRequestHelper).to receive(:request).and_return(valid_odata_response)
        expect(StepActualisationHelper.get_work_package_id('step_id', 'business_item_id')).to eq('e9G2vHbc')
      end
    end

    context 'when no work packages exist' do
      it 'returns nil' do
        allow(ODataRequestHelper).to receive(:request).and_return(empty_odata_response)
        expect(StepActualisationHelper.get_work_package_id('step_id', 'business_item_id')).to eq(nil)
      end
    end
  end

  describe '#get_work_packageable_thing_name' do
    context 'when work packageable thing name exists' do
      it 'returns work package id' do
        allow(ODataRequestHelper).to receive(:request).and_return(valid_odata_response)
        expect(StepActualisationHelper.get_work_packageable_thing_name('step_id', 'business_item_id', 'work_package_id')).to eq('Equine Identification (England) Regulations 2018')
      end
    end

    context 'when no work packageable thing name does not exist' do
      it 'returns nil' do
        allow(ODataRequestHelper).to receive(:request).and_return(empty_odata_response)
        expect(StepActualisationHelper.get_work_packageable_thing_name('step_id', 'business_item_id', 'work_package_id')).to eq(nil)
      end
    end
  end

  describe '#get_procedure_step_name' do
    context 'when procedure step name exists' do
      it 'returns work package id' do
        allow(ODataRequestHelper).to receive(:request).and_return(valid_odata_response)
        expect(StepActualisationHelper.get_procedure_step_name('step_id')).to eq('Considered by the Joint Committee on Statutory Instruments (JCSI)')
      end
    end

    context 'when no procedure step name does exists' do
      it 'returns nil' do
        allow(ODataRequestHelper).to receive(:request).and_return(empty_odata_response)
        expect(StepActualisationHelper.get_procedure_step_name('step_id')).to eq(nil)
      end
    end
  end

  describe '#get_business_item_id' do
    context 'when business item id exists' do
      it 'returns work package id' do
        expect(StepActualisationHelper.get_business_item_id(valid_business_item)).to eq('c5tH8nfB')
      end
    end

    context 'when no business item id exists' do
      it 'returns nil' do
        expect(StepActualisationHelper.get_business_item_id(invalid_business_item)).to eq(nil)
      end
    end
  end

  describe '#actualised_data' do
    context 'when all data exists' do
      it 'returns work package id and work packageable thing name' do
        allow(StepActualisationHelper).to receive(:get_business_item_id).and_return('business_item_id')
        allow(StepActualisationHelper).to receive(:get_work_package_id).and_return('work_package_id')
        allow(StepActualisationHelper).to receive(:get_work_packageable_thing_name).and_return('work_packageable_thing_name')

        expect(StepActualisationHelper.actualised_data('step_id', valid_business_item)).to eq(['work_package_id', 'work_packageable_thing_name'])
      end
    end

    context 'when not all data exists' do
      context 'when business item id does not exist' do
        it 'returns nil' do
          allow(StepActualisationHelper).to receive(:get_business_item_id).and_return(nil)
          expect(StepActualisationHelper.actualised_data('step_id', invalid_business_item)).to eq([nil, nil])
        end
      end

      context 'when business item id exists but work package id does not' do
        it 'returns nil' do
          allow(StepActualisationHelper).to receive(:get_business_item_id).and_return('business_item_id')
          allow(StepActualisationHelper).to receive(:get_work_package_id).and_return(nil)
          expect(StepActualisationHelper.actualised_data('step_id', valid_business_item)).to eq([nil, nil])
        end
      end

      context 'when business item id and work package id exists but work packageable thing name does not' do
        it 'returns work package id, nil' do
          allow(StepActualisationHelper).to receive(:get_business_item_id).and_return('business_item_id')
          allow(StepActualisationHelper).to receive(:get_work_package_id).and_return('work_package_id')
          allow(StepActualisationHelper).to receive(:get_work_packageable_thing_name).and_return(nil)
          expect(StepActualisationHelper.actualised_data('step_id', valid_business_item)).to eq(['work_package_id', nil])
        end
      end
    end
  end
end
