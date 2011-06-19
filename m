Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab1FSMut (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 08:50:49 -0400
Message-ID: <4DFDF0A5.9030207@redhat.com>
Date: Sun, 19 Jun 2011 09:50:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: change in build .sh due to Pulseaudio device removal /
References: <4DFBB431.60101@redhat.com> <4DFCDE6D.8090008@hoogenraad.net> <4DFDE849.8030404@redhat.com> <4DFDEE23.1070106@hoogenraad.net>
In-Reply-To: <4DFDEE23.1070106@hoogenraad.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-06-2011 09:40, Jan Hoogenraad escreveu:
> Mauro:
> 
> You are completely right. Getting the packages automatically is very user-friendly. Furthermore, this will make media_build a great place to start of users stuck with older kernels.

Automatic install is good, but I think that providing a command line to the user
is better, as he may want to install things on a different way. For example, on
Mandriva, there are 2 or 3 different options to install package. I think that 
Debian/Ubuntu also provides at least 3 different ways (apt-get, aptitude, yum).

> 
> 
> On Ubuntu, the package name is  libproc-processtable-perl
> the command to install it is (on Ubuntu, usually no root user is used, but rather per command invokation).
> 
> The command for installation will be:
> 
>  sudo apt-get install libproc-processtable-perl
> 
> There is no
> /etc/system-release
> on my system
> 
> However, there is a file /etc/lsb-release
> cat /etc/lsb-release
> DISTRIB_ID=Ubuntu
> DISTRIB_RELEASE=10.04
> DISTRIB_CODENAME=lucid
> DISTRIB_DESCRIPTION="Ubuntu 10.04.2 LTS"
> 
> I will make an updated script in the next week.

OK. I just added a logic that works with RHEL/Fedora. There's no
/etc/lsb-release on RHEL 6.1 or Fedora 15, but it shouldn't be hard
to do support the Ubuntu way with:

 my $system_release = qx(cat /etc/system-release);
 $system_release = qx(cat /etc/redhat-release) if !$system_release;
+$system_release = qx(grep DISTRIB_ID /etc/lsb-release) if !$system_release;

Cheers,
Mauro
