Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45661 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab1FIIqt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2011 04:46:49 -0400
Received: by ywe9 with SMTP id 9so633407ywe.19
        for <linux-media@vger.kernel.org>; Thu, 09 Jun 2011 01:46:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1106091042100.17738@axis700.grange>
References: <1307530660-25464-1-git-send-email-ygli@marvell.com>
	<Pine.LNX.4.64.1106081322590.24274@axis700.grange>
	<BANLkTikS1nhSnrvQv=s4Xe2_Juf1i-xwfg@mail.gmail.com>
	<Pine.LNX.4.64.1106091042100.17738@axis700.grange>
Date: Thu, 9 Jun 2011 16:46:47 +0800
Message-ID: <BANLkTikbN87Yja-MxA4eu1z=1HJ6wU=-kA@mail.gmail.com>
Subject: Re: [PATCH] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC
From: Kassey Lee <kassey1216@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Kassey Lee <ygli@marvell.com>, linux-media@vger.kernel.org,
	ytang5@marvell.com, corbet@lwn.net, qingx@marvell.com,
	jwan@marvell.com, leiwen@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jun 9, 2011 at 4:42 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Thu, 9 Jun 2011, Kassey Lee wrote:
>
>> Guennadi, Jon:
>>        thanks!
>>        we hope to work out a common ccic core, and then re base the code.
>
> ok, so, we agree, that I don't review your last version, ok?
>
Guennadi, Jon
        your comments are always welcome and valuable for us.
        As Jon will convert cafe_ccic.c to videobuf2 too, I wish He
can review this driver too, if it is useful for him.
        and find the common ccic core. Just Mark it.

Thanks

> Thanks
> Guennadi
>
>> :
>> On Wed, Jun 8, 2011 at 7:30 PM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > Hi Kassey
>> >
>> > Thanks for the new version, but, IIUC, you agreed to reimplement your
>> > driver on top of a common ccic core, which means, a lot of code will
>> > change. So, it doesn't really make much sense now to make and review new
>> > stand-alone versions of your driver, right? So, shall we wait until Jon's
>> > CCIC code stabilises a bit and you rebase your driver on top of it? Of
>> > course, you can also work together with Jon on the drivers to get them
>> > faster in shape and in a way, suitable fou you both.
>> >
>> > Thanks
>> > Guennadi
>> > ---
>> > Guennadi Liakhovetski, Ph.D.
>> > Freelance Open-Source Software Developer
>> > http://www.open-technology.de/
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>>
>>
>> --
>> Best regards
>> Kassey
>> Application Processor Systems Engineering, Marvell Technology Group Ltd.
>> Shanghai, China.
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>



-- 
Best regards
Kassey
Application Processor Systems Engineering, Marvell Technology Group Ltd.
Shanghai, China.
