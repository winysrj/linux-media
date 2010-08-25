Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46567 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab0HYFV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 01:21:29 -0400
Received: by iwn5 with SMTP id 5so275353iwn.19
        for <linux-media@vger.kernel.org>; Tue, 24 Aug 2010 22:21:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinA1r87W+4J=MRV5i6M6BD-c+KTWnYqyBd7WCQA@mail.gmail.com>
References: <AANLkTi=-ai2mZHiEmiEpKq9A-CifSPQDagrE03gDqpHv@mail.gmail.com>
	<AANLkTikZD32LC12bT9wPBQ5+uO3Msd8Sw5Cwkq5y3bkB@mail.gmail.com>
	<4C581BB6.7000303@redhat.com>
	<AANLkTi=i57wxwOEEEm4dXydpmePrhS11MYqVCW+nz=XB@mail.gmail.com>
	<AANLkTikMHF6pjqznLi5qWHtc9kFk7jb1G1KmeKsvfLKg@mail.gmail.com>
	<AANLkTim=ggkFgLZPqAKOzUv54NCMzxXYCropm_2XYXeX@mail.gmail.com>
	<AANLkTik7sWGM+x0uOr734=M=Ux1KsXQ9JJNqF98oN7-t@mail.gmail.com>
	<4C7425C9.1010908@hoogenraad.net>
	<AANLkTinA1r87W+4J=MRV5i6M6BD-c+KTWnYqyBd7WCQA@mail.gmail.com>
Date: Wed, 25 Aug 2010 01:21:29 -0400
Message-ID: <AANLkTimwWj0sw0NKgaGBJmpKzjvwM1-U16+vToOg_Pyc@mail.gmail.com>
Subject: Re: V4L hg tree fails to compile against kernel 2.6.28
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Cc: linux-media <linux-media@vger.kernel.org>,
	VDR User <user.vdr@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

On Tue, Aug 24, 2010 at 11:45 PM, Douglas Schilling Landgraf
<dougsland@gmail.com> wrote:
> Hello Jan,
>
> On Tue, Aug 24, 2010 at 5:04 PM, Jan Hoogenraad
> <jan-conceptronic@hoogenraad.net> wrote:
>> Douglas:
>>
>> On compiling with  Linux  2.6.28-19-generic #62-Ubuntu
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


Ok, should be working right now, I have made the backports
needed/adjusts to compile agains 2.6.29. Let me know if you have any
problem.
Tomorrow I will continue commiting patches to get hg synced with git.

Thanks
Douglas
