Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64667 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab1FJIxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 04:53:14 -0400
Received: by gxk21 with SMTP id 21so1544016gxk.19
        for <linux-media@vger.kernel.org>; Fri, 10 Jun 2011 01:53:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110609164731.0b91b9f8@bike.lwn.net>
References: <1307530660-25464-1-git-send-email-ygli@marvell.com>
	<20110609164731.0b91b9f8@bike.lwn.net>
Date: Fri, 10 Jun 2011 16:53:13 +0800
Message-ID: <BANLkTin277sk4pD00L-CHD21Zq7NOuHbjw@mail.gmail.com>
Subject: Re: [PATCH] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC
From: Kassey Lee <kassey1216@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Kassey Lee <ygli@marvell.com>, g.liakhovetski@gmx.de,
	linux-media@vger.kernel.org, ytang5@marvell.com, qingx@marvell.com,
	jwan@marvell.com, leiwen@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jun 10, 2011 at 6:47 AM, Jonathan Corbet <corbet@lwn.net> wrote:
> Hi, Kassey,
>
> I've been looking at the driver some to understand how you're using the
> hardware.  One quick question:
>
>> The driver is based on soc-camera + videobuf2 frame
>> work, and only USERPTR is supported.
>
> Since you're limited to contiguous DMA (does the PXA910 even support
> scatter/gather mode?),

     PXA910 supports scatter/gather mode, but we did not use that.

 USERPTR is going to be very limiting.  Is the
> application mapping I/O memory elsewhere in the system with the
> expectation of having the video frames go directly there?  Could you tell
> me how that works?  I'd like to understand the use case here.
>
USERPTR is popular on Android Camera HAL implementation..

we alloc memory in user space by PMEM, and QBUF to driver,
once DMA finished the buffer, we DQBUF and send the buffer address to
display DMA directly.
or doing encode.


MMAP can not offer big size memory, for 720P resolution, when running Android.

> FWIW, I believe that videobuf2 would support the MMAP mode with no
> additional effort on your part; any reason why you haven't enabled that?
>
you are right.
I just enabled it on videobuf, and I will try to enable it on videobuf2, too.
thanks.

> Thanks,
>
> jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Best regards
Kassey
Application Processor Systems Engineering, Marvell Technology Group Ltd.
Shanghai, China.
