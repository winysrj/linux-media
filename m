Return-path: <mchehab@pedra>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:51204 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753805Ab1FSMkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 08:40:10 -0400
Message-ID: <4DFDEE23.1070106@hoogenraad.net>
Date: Sun, 19 Jun 2011 14:40:03 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: change in build .sh due to Pulseaudio device removal /
References: <4DFBB431.60101@redhat.com> <4DFCDE6D.8090008@hoogenraad.net> <4DFDE849.8030404@redhat.com>
In-Reply-To: <4DFDE849.8030404@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro:

You are completely right. Getting the packages automatically is very 
user-friendly. Furthermore, this will make media_build a great place to 
start of users stuck with older kernels.


On Ubuntu, the package name is  libproc-processtable-perl
the command to install it is (on Ubuntu, usually no root user is used, 
but rather per command invokation).

The command for installation will be:

  sudo apt-get install libproc-processtable-perl

There is no
/etc/system-release
on my system

However, there is a file /etc/lsb-release
cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=10.04
DISTRIB_CODENAME=lucid
DISTRIB_DESCRIPTION="Ubuntu 10.04.2 LTS"

I will make an updated script in the next week.

Mauro Carvalho Chehab wrote:
> Em 18-06-2011 14:20, Jan Hoogenraad escreveu:
>> Mauro:
>>
>> The change in build.sh
>> http://git.linuxtv.org/media_build.git?a=commitdiff;h=16cf0606fd59484236356e400a89c083e76da64b
>>
>> now requires installation of a Perl package Proc::ProcessTable  that is not present in standard Ubuntu systems.
>>
>> I needed to run
>>   sudo aptitude install libproc-processtable-perl
>> before I could continue after the change.
>>
>> Is there a way around this ?
>
> The media_build requires several packages that may not be present on some
> installation. The build.sh script has a logic to detect the missing parts
> and to output what's the missing requirements:
>
> echo "Checking if the needed tools are present"
> run ./check_needs.pl
>
> (I moved right now the perl-specific checks into check_needs.pl script)
>
> Unfortunately, package names are distro-specific. So, as I use only Fedora/RHEL
> here, the only hints it have are for them. From my experiences, between the
> rpm-based distros, the package names are either equal or very close, so such
> hints probably are probably good enough for Suse and Mandriva users.
>
>> From what I understand, the standard Ubuntu repositories already provide a package
> for Proc::ProcessTable. So, the only thing that it is not ok is the package name hint.
>
> Could you please provide us a patch adding the Ubuntu (and likely Debian) package
> name?
>
> IMHO, the better would be to modify the check logic, in order to check what's the
> system, and provide a hint based on it. If the OS type is not found, then fall back
> to some default.
>
> I think that the LSB default to get the distribution is by reading /etc/system-release.
> Those are provided on RHEL6 and Fedora (plus, the old way: /etc/redhat-release).
>
> So, IMHO, all we need to do is to write a logic for the error report part of the check,
> that opens /etc/system-release, identify what's the distro, and provide the package
> name and some instructions on how to install the missing parts to the userspace.
>
> The right way for adding such logic would be to install the OS's on some VM with the
> minimum install, run the script and add the missing parts on it.
>
> Cheers,
> Mauro.
>


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
