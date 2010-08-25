Return-path: <mchehab@pedra>
Received: from psmtp13.wxs.nl ([195.121.247.25]:58024 "EHLO psmtp13.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab0HYG0X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 02:26:23 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp13.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L7P003QG37WG6@psmtp13.wxs.nl> for linux-media@vger.kernel.org;
 Wed, 25 Aug 2010 08:26:21 +0200 (MEST)
Date: Wed, 25 Aug 2010 08:26:19 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: V4L hg tree fails to compile against kernel 2.6.28
In-reply-to: <AANLkTinA1r87W+4J=MRV5i6M6BD-c+KTWnYqyBd7WCQA@mail.gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	VDR User <user.vdr@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4C74B78B.3020101@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <AANLkTi=-ai2mZHiEmiEpKq9A-CifSPQDagrE03gDqpHv@mail.gmail.com>
 <AANLkTikZD32LC12bT9wPBQ5+uO3Msd8Sw5Cwkq5y3bkB@mail.gmail.com>
 <4C581BB6.7000303@redhat.com>
 <AANLkTi=i57wxwOEEEm4dXydpmePrhS11MYqVCW+nz=XB@mail.gmail.com>
 <AANLkTikMHF6pjqznLi5qWHtc9kFk7jb1G1KmeKsvfLKg@mail.gmail.com>
 <AANLkTim=ggkFgLZPqAKOzUv54NCMzxXYCropm_2XYXeX@mail.gmail.com>
 <AANLkTik7sWGM+x0uOr734=M=Ux1KsXQ9JJNqF98oN7-t@mail.gmail.com>
 <4C7425C9.1010908@hoogenraad.net>
 <AANLkTinA1r87W+4J=MRV5i6M6BD-c+KTWnYqyBd7WCQA@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Thanks for your help. I pulled the code

Actually, now the function definition in compat.h causes a compilation 
error: see first text below.

I fixed that by inserting
#include <linux/err.h>
at line 38 in compat.h in my local branch

After that, compilation succeeds.

Now, the device will not install, as dvb_usb cannot install anymore.
see second text below.

Therefore, I have replaced the __kmalloc_track_caller with kmalloc (as 
it was in dvb_demux.c before the change 2ceef3d75547 at line 49

can you make both changes in the hg branch ?
-----

make[2]: Entering directory `/usr/src/linux-headers-2.6.28-19-generic'
   CC [M]  tuner-xc2028.o
In file included from tuner-xc2028.c:19:
compat.h: In function 'memdup_user':
compat.h:50: error: implicit declaration of function 'ERR_PTR'
compat.h:50: warning: return makes pointer from integer without a cast
compat.h:54: warning: return makes pointer from integer without a cast
In file included from include/linux/fs.h:1891,
                  from include/linux/poll.h:11,
                  from dvbdev.h:27,
                  from dvb_frontend.h:43,
                  from tuner-xc2028.h:10,
                  from tuner-xc2028.c:22:
include/linux/err.h: At top level:
include/linux/err.h:22: error: conflicting types for 'ERR_PTR'
----
sudo modprobe dvb-usb-rtl2831u ir_protocol=2
WARNING: Error inserting dvb_usb 
(/lib/modules/2.6.28-19-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting dvb_usb_dibusb_common 
(/lib/modules/2.6.28-19-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dibusb-common.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting dvb_usb_rtl2831u 
(/lib/modules/2.6.28-19-generic/kernel/drivers/media/dvb/rtl2831/dvb-usb-rtl2831u.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)

in the system log, I find:

dvb_core: Unknown symbol __kmalloc_track_caller
dvb_core: Unknown symbol __kmalloc_track_caller




Douglas Schilling Landgraf wrote:
> Hello Jan,
> 
> On Tue, Aug 24, 2010 at 5:04 PM, Jan Hoogenraad
> <jan-conceptronic@hoogenraad.net> wrote:
>> Douglas:
>>
>> On compiling with  Linux  2.6.28-19-generic #62-Ubuntu
>>
>> I now get:
>>
>> dvb_demux.c: In function 'dvbdmx_write':
>> dvb_demux.c:1137: error: implicit declaration of function 'memdup_user'
>> dvb_demux.c:1137: warning: assignment makes pointer from integer without a
>> cast
>>
>> This is probably due to changeset 2ceef3d75547
>>
>> which introduced the use of this function:
>> http://linuxtv.org/hg/v4l-dvb/diff/2ceef3d75547/linux/drivers/media/dvb/dvb-core/dvb_demux.c
>>
>> This function is not available in linux/string.h in kernel 2.6.29 and lower.
>>
>> http://lxr.free-electrons.com/source/include/linux/string.h?v=2.6.28
>>
>> Could you please advise me on what to do ?
> 
> For this issue, I have fixed right now, please try again with a
> updated repository. But since I have commited several patches
> yesterday,
> we have another one that probably will reach your compilantion (the
> kfifo one). I will work to fix this one too.
> 
> Thanks for the report.
> 
> Cheers
> Douglas
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
