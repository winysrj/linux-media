Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:39597 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbcH3P5W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Aug 2016 11:57:22 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jiri Kosina <trivial@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v5 01/13] media: mt9m111: make a standalone v4l2 subdevice
References: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
        <1472493358-24618-2-git-send-email-robert.jarzmik@free.fr>
        <Pine.LNX.4.64.1608301048460.10858@axis700.grange>
Date: Tue, 30 Aug 2016 17:57:17 +0200
In-Reply-To: <Pine.LNX.4.64.1608301048460.10858@axis700.grange> (Guennadi
        Liakhovetski's message of "Tue, 30 Aug 2016 10:55:31 +0200 (CEST)")
Message-ID: <87shtmckrm.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hi Robert,
>
> On Mon, 29 Aug 2016, Robert Jarzmik wrote:
>
>> Remove the soc_camera adherence. Mostly the change removes the power
>> manipulation provided by soc_camera, and instead :
>>  - powers on the sensor when the s_power control is activated
>>  - powers on the sensor in initial probe
>>  - enables and disables the MCLK provided to it in power on/off
>
> Your patch also drops support for inverters on synchronisation and clock 
> lines, I guess, your board doesn't use any. I assume, if any board ever 
> needs such inverters, support for them can be added in the future.
Ah yeah, that would deserve a notice in the commit message.

It's a bit a pity to respin the whole serie for it, but you've got a fair
point. Maybe Hans would agree to apply 4/13 to 13/13 (if there is no comment
remaining), and let me respin the 3 patches around mtm9111.

> Also, as I mentioned in my reply to your other patch, maybe good to join this
> with #3. Otherwise and with that in mind
I'd like to keep the move separate from the remaining part. And yes, I should
have used the "-M" option ... I added it to my submission script so that I don't
forget it again :)

Thanks for the Ack, and cheers.

--
Robert
