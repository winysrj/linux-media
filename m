Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32866 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640Ab0FJJVK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jun 2010 05:21:10 -0400
Received: by wyb40 with SMTP id 40so808519wyb.19
        for <linux-media@vger.kernel.org>; Thu, 10 Jun 2010 02:21:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100610095338.35d46e1c@tele>
References: <loom.20100610T052202-829@post.gmane.org>
	<20100610095338.35d46e1c@tele>
Date: Thu, 10 Jun 2010 10:20:58 +0100
Message-ID: <AANLkTinoHhuPRV8m7vf38lKiwOXV7WNFd36MmBmuRhNQ@mail.gmail.com>
Subject: Re: V4L Camera frame timestamp question
From: Paulo Assis <pj.assis@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: jiajun <zhujiajun@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/6/10 Jean-Francois Moine <moinejf@free.fr>:
> On Thu, 10 Jun 2010 03:24:05 +0000 (UTC)
> jiajun <zhujiajun@gmail.com> wrote:
>
>> I'm currently using the V4L-DVB driver to control a few logitech
>> webcams and playstation eye cameras on a Gubuntu system.
>>
>> Everything works just fine except one thing:  the buffer timestamp
>> value seems wrong.
>        [snip]
>> this should be the timestamp of when the image is taken (similar to
>> gettimeofday() function)
>> but the value I got is something way smaller (e.g. 75000) than what
>> it should be (e.g. 1275931384)
>>
>> Is this a known problem?
>
> Hi,
>
> No, I did not know it! Thank you. I will try to fix it for the kernel
> 2.6.35.
>

You can't use gettimeofday for timestamps or you will have big
problems if your clock changes when you are grabbing video.
You must use a monotonic clock, this is what gspca and uvc are doing,
they now use ktime, a monotonic highres clock.
This prevents time shifts that can break the video stream playback,
also gettimeofday as problems in multicore cpus since for most
processors
the internal cpus are not exactly in sync.

So PLEASE leave it like it is now, also other drivers should really
move into using ktime nad not gettimeofday.

You are converting the timestamp to seconds this will produce a
smaller value, you should really convert it to ms, then you would get
a value closer to what you want.

Best Regards,
Paulo

> Best regards.
>
> --
> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
