Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:20158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746Ab1FSMPJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 08:15:09 -0400
Message-ID: <4DFDE849.8030404@redhat.com>
Date: Sun, 19 Jun 2011 09:15:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-verisign@hoogenraad.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: change in build .sh due to Pulseaudio device removal /
References: <4DFBB431.60101@redhat.com> <4DFCDE6D.8090008@hoogenraad.net>
In-Reply-To: <4DFCDE6D.8090008@hoogenraad.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 18-06-2011 14:20, Jan Hoogenraad escreveu:
> Mauro:
> 
> The change in build.sh
> http://git.linuxtv.org/media_build.git?a=commitdiff;h=16cf0606fd59484236356e400a89c083e76da64b
> 
> now requires installation of a Perl package Proc::ProcessTable  that is not present in standard Ubuntu systems.
> 
> I needed to run
>  sudo aptitude install libproc-processtable-perl
> before I could continue after the change.
> 
> Is there a way around this ?

The media_build requires several packages that may not be present on some
installation. The build.sh script has a logic to detect the missing parts
and to output what's the missing requirements:

echo "Checking if the needed tools are present"
run ./check_needs.pl

(I moved right now the perl-specific checks into check_needs.pl script)

Unfortunately, package names are distro-specific. So, as I use only Fedora/RHEL
here, the only hints it have are for them. From my experiences, between the
rpm-based distros, the package names are either equal or very close, so such
hints probably are probably good enough for Suse and Mandriva users.

>From what I understand, the standard Ubuntu repositories already provide a package
for Proc::ProcessTable. So, the only thing that it is not ok is the package name hint.

Could you please provide us a patch adding the Ubuntu (and likely Debian) package
name?

IMHO, the better would be to modify the check logic, in order to check what's the
system, and provide a hint based on it. If the OS type is not found, then fall back
to some default.

I think that the LSB default to get the distribution is by reading /etc/system-release.
Those are provided on RHEL6 and Fedora (plus, the old way: /etc/redhat-release).

So, IMHO, all we need to do is to write a logic for the error report part of the check,
that opens /etc/system-release, identify what's the distro, and provide the package
name and some instructions on how to install the missing parts to the userspace.

The right way for adding such logic would be to install the OS's on some VM with the
minimum install, run the script and add the missing parts on it.

Cheers,
Mauro.
