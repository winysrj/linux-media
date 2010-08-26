Return-path: <mchehab@pedra>
Received: from psmtp31.wxs.nl ([195.121.247.33]:57811 "EHLO psmtp31.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab0HZFnm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 01:43:42 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp31.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L7Q00A5RVWSQX@psmtp31.wxs.nl> for linux-media@vger.kernel.org;
 Thu, 26 Aug 2010 07:43:41 +0200 (CEST)
Date: Thu, 26 Aug 2010 07:43:39 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: V4L hg tree fails to compile against kernel 2.6.28
In-reply-to: <AANLkTim3bq6h-oFY+TKoog-TKOzQ-w4MR0CVdcL4OjcD@mail.gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	VDR User <user.vdr@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4C75FF0B.3060500@hoogenraad.net>
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
 <4C74B78B.3020101@hoogenraad.net>
 <AANLkTim3bq6h-oFY+TKoog-TKOzQ-w4MR0CVdcL4OjcD@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

__kmalloc_track_caller is not avaiable in
2.6.28-19-generic #62-Ubuntu
which just passes your cut at 2.6.26.

Apparently, the code __kmalloc_track_caller is in the source archive for 
2.6.28, but the kernel options were not such that the symbol is available.
My guess is that it was changed in 2.6.30, where memory management was 
changed.

Thus, 2.6.28, it needs to stay kmalloc.

Douglas Schilling Landgraf wrote:
> Hello Jan,
> 
> On Wed, Aug 25, 2010 at 3:26 AM, Jan Hoogenraad
> <jan-conceptronic@hoogenraad.net> wrote:
>> Thanks for your help. I pulled the code
>>
>> Actually, now the function definition in compat.h causes a compilation
>> error: see first text below.
>>
>> I fixed that by inserting
>> #include <linux/err.h>
>> at line 38 in compat.h in my local branch
>>
>> After that, compilation succeeds.
> 
> 
> Thanks, applied.
> 
>> Now, the device will not install, as dvb_usb cannot install anymore.
>> see second text below.
>>
>> Therefore, I have replaced the __kmalloc_track_caller with kmalloc (as it
>> was in dvb_demux.c before the change 2ceef3d75547 at line 49
>>
>> can you make both changes in the hg branch ?
> 
> This one won't be required because the idea is support until kernel 2.6.26.
> Please check my next email about hg x announcement.
> 
> Thanks for checking it, your help is appreciate.
> 
> Cheers
> Douglas
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
