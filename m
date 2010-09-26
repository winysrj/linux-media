Return-path: <mchehab@pedra>
Received: from psmtp31.wxs.nl ([195.121.247.33]:63805 "EHLO psmtp31.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab0IZQSu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 12:18:50 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp31.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L9D00KQJ3ZC98@psmtp31.wxs.nl> for linux-media@vger.kernel.org;
 Sun, 26 Sep 2010 18:18:49 +0200 (CEST)
Date: Sun, 26 Sep 2010 18:18:47 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: Trouble building v4l-dvb
In-reply-to: <4C93800B.8070902@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: "Ole W. Saastad" <olewsaa@online.no>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Message-id: <4C9F7267.7000707@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <1284493110.1801.57.camel@sofia> <4C924EB8.9070500@hoogenraad.net>
 <4C93364C.3040606@hoogenraad.net> <4C934806.7050503@gmail.com>
 <4C934C10.2060801@hoogenraad.net> <4C93800B.8070902@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On
Linux 2.6.28-19-generic
the problem is tackled already:
DVB_FIREDTV_IEEE1394: Requires at least kernel 2.6.30

On newer linux versions (I have tried Linux 2.6.32-24-generic) the 
problem is NOT that the modules dma is not present, it is just that the 
required header files are not present in
/usr/include

Another location mighte have been:
ls -l /usr/src/linux-headers-2.6.28-19-generic/include/config/ieee1394

but that only contains:
-rw-r--r-- 1 root root    0 2010-09-16 18:25 dv1394.h
drwxr-xr-x 3 root root 4096 2010-06-15 20:12 eth1394
-rw-r--r-- 1 root root    0 2010-09-16 18:25 eth1394.h
-rw-r--r-- 1 root root    0 2010-09-16 18:25 ohci1394.h
-rw-r--r-- 1 root root    0 2010-09-16 18:25 pcilynx.h
-rw-r--r-- 1 root root    0 2010-09-16 18:25 rawio.h
-rw-r--r-- 1 root root    0 2010-09-16 18:25 sbp2.h
-rw-r--r-- 1 root root    0 2010-09-16 18:25 video1394.h

Can you indicate where following files  should be located ?
dma.h
csr1212.h
highlevel.h

In that case checking if the dma.h file is present might be the best way 
forward.

I'll also file an ubuntu bug once I know what is missing where.
I could not find an entry in launchpad on this issue yet.

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
