# Fact: :syslog_package
#
# Purpose: retrieve installed rsyslog version
#

Facter.add(:rsyslog_version) do
    setcode do
        osfamily = Facter.value('osfamily')
        case osfamily
        when "Debian"
            command='/usr/bin/dpkg-query -f \'${Status};${Version};\' -W rsyslog 2>/dev/null'
            version = Facter::Util::Resolution.exec(command)
            if version =~ /.*[install|hold] ok installed;([^;]+);.*/
                $1
            else
                nil
            end
        when "RedHat", "Suse"
            command='rpm -qa --qf "%{VERSION}" "rsyslog"'
            version = Facter::Util::Resolution.exec(command)
            if version =~ /^(.+)$/
                $1
            else
                nil
            end
        when "FreeBSD"
          command='pkg query %v rsyslog'
          version = Facter::Util::Resolution.exec(command)
          if version =~ /^(.+)$/
            $1
          else
            nil
          end
        when "Solaris"
          command='pkg info rsyslog 2>/dev/null| grep Version:'
          version = Facter::Util::Resolution.exec(command).strip.split[1]
          if version =~ /^([\d.]+)$/
            $1
          else
            nil
          end
        else
            nil
        end
    end
end
