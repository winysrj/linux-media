Return-path: <mchehab@pedra>
Received: from psmtp31.wxs.nl ([195.121.247.33]:37833 "EHLO psmtp31.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab0HXUEb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 16:04:31 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp31.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L7O00DY0AFFTR@psmtp31.wxs.nl> for linux-media@vger.kernel.org;
 Tue, 24 Aug 2010 22:04:28 +0200 (CEST)
Date: Tue, 24 Aug 2010 22:04:25 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: V4L hg tree fails to compile against kernel 2.6.28
In-reply-to: <AANLkTik7sWGM+x0uOr734=M=Ux1KsXQ9JJNqF98oN7-t@mail.gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Cc: VDR User <user.vdr@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4C7425C9.1010908@hoogenraad.net>
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
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Douglas:

On compiling with  Linux  2.6.28-19-generic #62-Ubuntu

I now get:

dvb_demux.c: In function 'dvbdmx_write':
dvb_demux.c:1137: error: implicit declaration of function 'memdup_user'
dvb_demux.c:1137: warning: assignment makes pointer from integer without 
a cast

This is probably due to changeset 2ceef3d75547

which introduced the use of this function:
http://linuxtv.org/hg/v4l-dvb/diff/2ceef3d75547/linux/drivers/media/dvb/dvb-core/dvb_demux.c

This function is not available in linux/string.h in kernel 2.6.29 and lower.

http://lxr.free-electrons.com/source/include/linux/string.h?v=2.6.28

Could you please advise me on what to do ?


Douglas Schilling Landgraf wrote:
> Hello Derek,
> 
> On Sun, Aug 15, 2010 at 2:22 AM, Douglas Schilling Landgraf
> <dougsland@gmail.com> wrote:
>> Hello Derek,
>>
>> On Sat, Aug 14, 2010 at 12:46 PM, VDR User <user.vdr@gmail.com> wrote:
>>> On Wed, Aug 4, 2010 at 10:19 PM, Douglas Schilling Landgraf
>>> <dougsland@gmail.com> wrote:
>>>> I am already working to give a full update to hg tree. Sorry this problem.
>>> Hi Douglas.  Any estimate when this will be fixed?  Was hoping it was
>>> already since new stable kernel 2.6.35.2 is out now but still the same
>>> problem when I tried just now.
>> I am already working on it this weekend. I will reply this thread when finished.
> 
> 2.6.35 should be working, let me know if not. Now, I need to backport
> the changes to old kernels
> and commit other patches in my pending list.
> 
> Cheers
> Douglas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
