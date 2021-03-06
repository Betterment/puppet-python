require "spec_helper"

describe "python::version" do
  let(:facts) { default_test_facts }
  let(:title) { "2.7.6" }

  context "ensure => present" do
    context "default params" do
      it do
        should include_class("python")

        should contain_exec("python-install-2.7.6").with({
          :command  => "/test/boxen/pyenv/bin/pyenv install 2.7.6",
          :cwd      => '/test/boxen/pyenv/versions',
          :provider => 'shell',
          :timeout  => 0,
          :creates  => '/test/boxen/pyenv/versions/2.7.6'
        })
      end
    end

    context "when env is default" do
      it do
        should contain_exec("python-install-2.7.6").with_environment([
          "CC=/usr/bin/cc",
          "CFLAGS=-I/test/boxen/homebrew/include -I/opt/X11/include",
          "LDFLAGS=-L/test/boxen/homebrew/lib -L/opt/X11/lib",
          "PYENV_ROOT=/test/boxen/pyenv"
        ])
      end
    end

    context "when env is not nil" do
      let(:params) do
        {
          :env => {'SOME_VAR' => 'foobar'}
        }
      end

      it do
        should contain_exec("python-install-2.7.6").with_environment([
          "CC=/usr/bin/cc",
          "CFLAGS=-I/test/boxen/homebrew/include -I/opt/X11/include",
          "LDFLAGS=-L/test/boxen/homebrew/lib -L/opt/X11/lib",
          "PYENV_ROOT=/test/boxen/pyenv",
          "SOME_VAR=foobar",
        ])
      end
    end
  end

  context "ensure => absent" do
    let(:params) do
      {
        :ensure => 'absent'
      }
    end

    it do
      should contain_file('/test/boxen/pyenv/versions/2.7.6').with({
        :ensure => 'absent',
        :force  => true,
      })
    end
  end
end
