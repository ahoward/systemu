
Testing SystemU do

##
#
  testing 'that simple usage works' do
    status, stdout, stderr = assert{ systemu :bin/:ls }
    assert{ status == 0 }
    assert{ stdout['lib'] }
    assert{ stderr.strip.empty? }
  end

  testing 'program with stdin' do
    stdin = '42'
    status, stdout, stderr = assert{ systemu :bin/:cat, :stdin => stdin }
    assert{ status == 0 }
    assert{ stdout == stdin } 
  end

  testing 'silly hostnames' do
    host = SystemU.instance_variable_get('@host')
    silly_hostname = "silly's hostname with spaces"
    begin
      SystemU.instance_variable_set('@host', silly_hostname)
      assert{ SystemU.instance_variable_get('@host') == silly_hostname }
      stdin = '42'
      status, stdout, stderr = assert{ systemu :bin/:cat, :stdin => stdin }
      assert{ status == 0 }
    ensure
      assert{ SystemU.instance_variable_set('@host', host) }
    end
  end

  testing 'invoke systemu with a block' do
    res = systemu("sleep 0.1") { puts('Waiting') }
    assert { res[1].instance_of?(String) }
    assert { res[2].instance_of?(String) }
    res = res[0]
    assert { (res & 0xFFFF) == 0 }
    assert { res == 0 }
    assert { res.exited? }
    assert { res.exitstatus == 0 }
    assert { res.pid.instance_of?(Integer) }
    assert { !res.signaled? }
    assert { res.success? }
    assert { res.to_i == 0 }
    assert { res.to_s =~ /^pid \d+ exit 0$/ }
  end
end





BEGIN {

# silly hax to build commands we can shell out to on any platform.  since
# tests might run on windoze we assume only that 'ruby' is available and build
# other command-line programs from it.
#
  module Kernel
  private
    def bin(which, options = {}, &block)
      case which.to_s
        when 'ls'
          %| ruby -e'puts Dir.glob("*").sort' |

        when 'cat'
          %| ruby -e'STDOUT.write(ARGF.read)' |

        when 'find'
          %| ruby -e'puts Dir.glob("**/**").sort' |
      end
    end
  end

# just let's us write:   :bin/:ls
#
  class Symbol
    def / other, options = {}, &block
      eval "#{ self }(:#{ other }, options, &block)"
    end
  end

  testdir = File.dirname(File.expand_path(__FILE__))
  rootdir = File.dirname(testdir)
  libdir = File.join(rootdir, 'lib')
  require File.join(libdir, 'systemu')
  require File.join(testdir, 'testing')


  Dir.chdir(rootdir)
}
