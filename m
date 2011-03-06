Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54842 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1CFLxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 06:53:13 -0500
Received: by wyg36 with SMTP id 36so3426571wyg.19
        for <linux-media@vger.kernel.org>; Sun, 06 Mar 2011 03:53:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110305164309.1796daad@grobi>
References: <4D31A520.2050703@helmutauer.de>
	<4D333AF2.8070806@redhat.com>
	<20110305164309.1796daad@grobi>
Date: Sun, 6 Mar 2011 17:23:11 +0530
Message-ID: <AANLkTi=2fN-qWN9zovwGwcNqfA0ogA1u3KCr7oD9CZMg@mail.gmail.com>
Subject: Re: Patches an media build tree
From: Manu Abraham <abraham.manu@gmail.com>
To: Steffen Barszus <steffenbpunkt@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Helmut Auer <vdr@helmutauer.de>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Steffen,

On Sat, Mar 5, 2011 at 9:13 PM, Steffen Barszus
<steffenbpunkt@googlemail.com> wrote:
> On Sun, 16 Jan 2011 16:37:38 -0200
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>
>> Em 15-01-2011 11:46, Helmut Auer escreveu:
>> > Hello List
>> >
>> > How long does it usually take til patches are integrated into the
>> > media build tree ( after posting these here ) ? I'm just wondering
>> > because I miss some patches posted here.
>>
>> It takes as much it needs for the driver maintainer to look into it,
>> and for me to have time to handle them.
>>
>> The pending patches are always at:
>>
>>       https://patchwork.kernel.org/project/linux-media/list/
>>
>> Please note that, by default, Patchwork filters the patches to
>> display only the ones marked as New or Under Review. If you want to
>> see all patches, you need to change the state filter to show all
>> patches:
>> https://patchwork.kernel.org/project/linux-media/list/?state=*
>>
>> If the patch you're waiting are marked as Under Review, you should
>> ping the driver maintainer, as I'm waiting for his review. If it is
>> new, that means that I didn't have time yet to dig into it.
>
> Can you please check these patches ?
> What is missing ? Something to be corrected ?
>
> What happens to orphaned drivers ? Manu are you still working on this ?
>
> Manu , Mauro please comment ! Thanks !
>
> Avoid unnecessary data copying inside dvb_dmx_swfilter_204() function
>        2010-08-07      Marko Ristola           Under Review
> Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt
>        2010-08-07      Marko Ristola           Under Review


I had tried this patch a while back, but due to some reason it was
causing a complete freeze at my side: it could have been due to a
different version of the bridge or so, But it wasn't really easy on my
side to ascertain that. That time looking at the patch it wasn't easy
to identify the reason as well. I need to retry the same again, with a
cooler head as to see what happens.


> [v2] V4L/DVB: faster DVB-S lock for mantis cards using stb0899 demod
>        2010-10-10      Tuxoholic               Under Review
>

I was under the assumption that this issue was fixed in the right way,
with the fix being applied to the stb6100 driver sometime back. Was
your test with that fix in ?


Best Regards,
Manu
