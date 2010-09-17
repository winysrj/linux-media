Return-path: <mchehab@pedra>
Received: from psmtp12.wxs.nl ([195.121.247.24]:37477 "EHLO psmtp12.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab0IQLIC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 07:08:02 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp12.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L8W001AF1LCFN@psmtp12.wxs.nl> for linux-media@vger.kernel.org;
 Fri, 17 Sep 2010 13:08:01 +0200 (MEST)
Date: Fri, 17 Sep 2010 13:08:00 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: Trouble building v4l-dvb
In-reply-to: <4C934806.7050503@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: "Ole W. Saastad" <olewsaa@online.no>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Message-id: <4C934C10.2060801@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <1284493110.1801.57.camel@sofia> <4C924EB8.9070500@hoogenraad.net>
 <4C93364C.3040606@hoogenraad.net> <4C934806.7050503@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks !

Indeed, the hack so that
make allyesmod
not select firedtv would be very helpful.

that way, it is also clear that firedtv will not work on debian-like 
distros.

Is there a way I cen help with that ?
I have no experience with Kconfig, so it would be a learning experience 
for me.


Mauro Carvalho Chehab wrote:
> Em 17-09-2010 06:35, Jan Hoogenraad escreveu:
>> I see that the build now succeeded.
>>
>> Ole: this is something that should have been fixed a long time ago, but isn't.
>> make allyesmod
>> should set only those divers that do actually compile.
>> Unfortunately, the FIREDTV driver has bugs for as long as I remember.
> 
> The problem are not related to bugs at firedtv driver, but, instead, due to the fact
> that the provided firewire drivers and fw-core don't match the drivers that are shipped
> with the distro kernel. In order words, at Ubuntu (and some other deb-based distros),
> they're shipping the wrong include files at /lib/modules/`uname -r`/build/. So, there's
> no way to build and run any module based on that wrong broken headers.
> 
> Up to a certain amount, the same happens with -alsa files on Ubuntu: although they
> will compile [1], as the provided headers at /lib/modules/`uname -r`/build/ are from a different
> version than the alsa modules provided with Ubuntu, the drivers that depend on -alsa will 
> generally compile, but they generally won't load (and, if they load, they'll can cause
> an OOPS and some other random troubles), as the symbol dependency will not match.
> 
> While a hack might be added at v4l-dvb -hg tree to make firedtv to compile against a broken
> header, the firedtv driver will not work anyway.
> 
> The only real solution for it is to fix this issue at the distro.
> 
> Cheers,
> Mauro
> 
> [1] The v4l-dvb is smart enough to adapt to -alsa API changes that are backported into
> an older kernel, since it checks for the API symbols that changed, instead of just looking
> for the kernel version. This works fine with all distros (like Fedora, RHEL, SUSE, OpenSUSE,
> Mandriva, ...) where the include files for alsa are at the right place:
> /lib/modules/`uname -r`/build/).
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
