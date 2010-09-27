Return-path: <mchehab@pedra>
Received: from psmtp04.wxs.nl ([195.121.247.13]:64113 "EHLO psmtp04.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271Ab0I0Sle (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 14:41:34 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp04.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L9F00BTD591PV@psmtp04.wxs.nl> for linux-media@vger.kernel.org;
 Mon, 27 Sep 2010 20:41:26 +0200 (MEST)
Date: Mon, 27 Sep 2010 20:41:24 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: updated make_kconfig.pl for Ubuntu
In-reply-to: <4CA018C4.9000507@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: "Ole W. Saastad" <olewsaa@online.no>, linux-media@vger.kernel.org
Message-id: <4CA0E554.40406@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <1284493110.1801.57.camel@sofia> <4C924EB8.9070500@hoogenraad.net>
 <4C93364C.3040606@hoogenraad.net> <4C934806.7050503@gmail.com>
 <4C934C10.2060801@hoogenraad.net> <4C93800B.8070902@gmail.com>
 <4C9F7267.7000707@hoogenraad.net> <4CA018C4.9000507@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I have updated launchpad bug

https://bugs.launchpad.net/ubuntu/+source/linux-kernel-headers/+bug/134222

I also created an updated make_kconfig.pl

http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2/file/cb34ee1c29fc/v4l/scripts/make_kconfig.pl

Unfortunately, I forgot to commit changes to the main archive the first 
time. I do not know how to make a patch file for this one file, without 
have all other changes in the two commits as well.
I cannot find a hg export command to make a patch for this one file 
between versions spanning two commits.

Douglas: can you help ?

Mauro Carvalho Chehab wrote:
> Em 26-09-2010 13:18, Jan Hoogenraad escreveu:
>> On
>> Linux 2.6.28-19-generic
>> the problem is tackled already:
>> DVB_FIREDTV_IEEE1394: Requires at least kernel 2.6.30
>>
>> On newer linux versions (I have tried Linux 2.6.32-24-generic) the problem is NOT that the modules dma is not present, it is just that the required header files are not present in
>> /usr/include
>>
>> Another location mighte have been:
>> ls -l /usr/src/linux-headers-2.6.28-19-generic/include/config/ieee1394
>
> This is the right place is whatever pointed on your kernel source alias, like:
>
> $ ls -la /lib/modules/2.6.35+/source
> lrwxrwxrwx. 1 root root 23 Set 26 21:51 /lib/modules/2.6.35+/source ->  /home/v4l/v4l/patchwork
>
>
>>
>> but that only contains:
>> -rw-r--r-- 1 root root    0 2010-09-16 18:25 dv1394.h
>> drwxr-xr-x 3 root root 4096 2010-06-15 20:12 eth1394
>> -rw-r--r-- 1 root root    0 2010-09-16 18:25 eth1394.h
>> -rw-r--r-- 1 root root    0 2010-09-16 18:25 ohci1394.h
>> -rw-r--r-- 1 root root    0 2010-09-16 18:25 pcilynx.h
>> -rw-r--r-- 1 root root    0 2010-09-16 18:25 rawio.h
>> -rw-r--r-- 1 root root    0 2010-09-16 18:25 sbp2.h
>> -rw-r--r-- 1 root root    0 2010-09-16 18:25 video1394.h
>>
>> Can you indicate where following files  should be located ?
>> dma.h
>> csr1212.h
>> highlevel.h
>
> All of them are at the same place:
>
> /lib/modules/2.6.35+/source/drivers/ieee1394/dma.h
> /lib/modules/2.6.35+/source/drivers/ieee1394/csr1212.h
> /lib/modules/2.6.35+/source/drivers/ieee1394/highlevel.h
>
>>
>> In that case checking if the dma.h file is present might be the best way forward.
>>
>> I'll also file an ubuntu bug once I know what is missing where.
>> I could not find an entry in launchpad on this issue yet.
>
> This is probably the best thing. A check for dma.h may also work. If you want,
> do a patch for it and submit to Douglas.
>
> Cheers,
> Mauro
>


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
