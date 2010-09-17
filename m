Return-path: <mchehab@pedra>
Received: from psmtp31.wxs.nl ([195.121.247.33]:47953 "EHLO psmtp31.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab0IQP1Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 11:27:25 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp31.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L8W00H7YDL95D@psmtp31.wxs.nl> for linux-media@vger.kernel.org;
 Fri, 17 Sep 2010 17:27:09 +0200 (CEST)
Date: Fri, 17 Sep 2010 17:27:08 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: Trouble building v4l-dvb
In-reply-to: <4C93800B.8070902@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: "Ole W. Saastad" <olewsaa@online.no>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Message-id: <4C9388CC.1010402@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <1284493110.1801.57.camel@sofia> <4C924EB8.9070500@hoogenraad.net>
 <4C93364C.3040606@hoogenraad.net> <4C934806.7050503@gmail.com>
 <4C934C10.2060801@hoogenraad.net> <4C93800B.8070902@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Really, the only thing I would do is disable the ones that break 
compilation. this is ONLY firedtv.

I doubt if anyone would read the messages during compilation.
I'll have a look at the logic.

Mauro Carvalho Chehab wrote:
> Em 17-09-2010 08:08, Jan Hoogenraad escreveu:
>> Thanks !
>>
>> Indeed, the hack so that
>> make allyesmod
>> not select firedtv would be very helpful.
>>
>> that way, it is also clear that firedtv will not work on debian-like distros.
>>
>> Is there a way I cen help with that ?
>> I have no experience with Kconfig, so it would be a learning experience for me.
> 
> You don't need to look at Kconfig. there are some scripts under v4l/scripts
> that will deal with Kconfig dependencies. They are meant to identify kernel versions
> and features. Those scripts are, mainly:
> 
> 	v4l/scripts/make_config_compat.pl - Checks for "backported" features, enabling workarounds at v4l/compat.h
> 	v4l/scripts/make_kconfig.pl - Generates a .config file that will compile with an older kernel
> 	v4l/scripts/make_makefile.pl - Generates a Makefile that will build/install/remove the kernel modules
> 
> Basically, you need to add some intelligence to one of the above scripts (likely make_kconfig)
> to identify that the kernel has broken firewire headers, and disable its compilation, printing
> a warning message to the user.
> 
> You'll find a logic at make_makefile.pl to detect an Ubuntu broken kernel that stores the in-kernel
> drivers at the wrong install place. I'm not sure if all Ubuntu kernels/versions do the same
> thing, nor if this is broken for all distro-variants.
> 
> Perhaps you may use this logic at make_kconfig.pl. The logic assumes that broken distros
> are the ones that store V4L/DVB files at /lib/modules/\$(KERNELRELEASE)/ubuntu/media. 
> This is probably not true for all broken distros (as Ubuntu clones - and maybe Debian - could
> have the same problem, but storing the media files on a different place), so you may
> need to generalize that logic, in order to cover any other distros that don't compile
> firewire.
> 
> While you're there, the better is to also disable CONFIG_ALSA on Ubuntu, as the drivers
> won't work anyway.
> 
> As we don't want to have complains from users about "why driver foo is not compiling for me",
> IMO, it should be printing a warning message saying that compilation of ALSA/FIREWIRE drivers with
> that specific kernel version is not possible, due to the back packaging of kernel headers,
> recommending to the user to get a vanilla upstream kernel, if he needs one of the disabled
> drivers.
> 
> Cheers,
> Mauro
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
