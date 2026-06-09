require 'spec_helper'

describe 'baseapp::subid' do
  let(:title) { 'ferrogate' }
  let(:facts) { { os: { family: 'RedHat', name: 'Rocky', release: { major: '9', full: '9.3' } } } }
  let(:params) { { subid: 655_425_536, count: 65_536 } }

  it { is_expected.to compile }

  it 'declares the subuid concat targets' do
    is_expected.to contain_concat('/etc/subuid')
    is_expected.to contain_concat('/etc/subgid')
  end

  it 'adds a fragment to each file' do
    is_expected.to contain_concat__fragment('baseapp-subuid-ferrogate').with(
      target:  '/etc/subuid',
      content: 'ferrogate:655425536:65536',
    )
    is_expected.to contain_concat__fragment('baseapp-subgid-ferrogate').with(
      target:  '/etc/subgid',
      content: 'ferrogate:655425536:65536',
    )
  end
end
