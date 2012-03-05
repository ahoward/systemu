
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
