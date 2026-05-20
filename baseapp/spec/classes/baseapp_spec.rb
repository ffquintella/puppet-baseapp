require 'spec_helper'

describe 'baseapp' do
  shared_examples 'a baseapp install' do
    context 'with default parameters' do
      it { is_expected.to compile }

      it do
        is_expected.to contain_file('/srv').with(
          ensure: 'directory',
          owner:  'root',
          group:  'root',
          mode:   '0755',
        )
      end

      ['/srv/application-config',
       '/srv/application-data',
       '/srv/application-logs',
       '/srv/scripts'].each do |dir|
        it "manages #{dir} with default ownership" do
          is_expected.to contain_file(dir).with(
            ensure: 'directory',
            owner:  'root',
            group:  'root',
            mode:   '0755',
          )
        end
      end
    end

    context 'with custom owner, group and mode' do
      let(:params) do
        {
          owner: 'myapp',
          group: 'myapp',
          mode:  '0750',
        }
      end

      it { is_expected.to compile }

      ['/srv/application-config',
       '/srv/application-data',
       '/srv/application-logs',
       '/srv/scripts'].each do |dir|
        it "applies custom ownership to #{dir}" do
          is_expected.to contain_file(dir).with(
            owner: 'myapp',
            group: 'myapp',
            mode:  '0750',
          )
        end
      end

      it 'still owns /srv as root' do
        is_expected.to contain_file('/srv').with(
          owner: 'root',
          group: 'root',
        )
      end
    end

    context 'with a custom srv_mode' do
      let(:params) { { srv_mode: '0750' } }

      it { is_expected.to contain_file('/srv').with(mode: '0750') }
    end
  end

  context 'on RedHat 9' do
    let(:facts) do
      {
        os: {
          family:  'RedHat',
          name:    'RedHat',
          release: { major: '9', full: '9.0' },
        },
      }
    end

    include_examples 'a baseapp install'
  end

  context 'on Debian 12' do
    let(:facts) do
      {
        os: {
          family:  'Debian',
          name:    'Debian',
          release: { major: '12', full: '12.0' },
        },
      }
    end

    include_examples 'a baseapp install'
  end

  context 'on Ubuntu 22.04' do
    let(:facts) do
      {
        os: {
          family:  'Debian',
          name:    'Ubuntu',
          release: { major: '22.04', full: '22.04' },
        },
      }
    end

    include_examples 'a baseapp install'
  end
end
