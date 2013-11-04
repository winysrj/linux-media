Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:57793 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3KDXVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 18:21:18 -0500
Received: by mail-we0-f175.google.com with SMTP id t61so2745746wes.20
        for <linux-media@vger.kernel.org>; Mon, 04 Nov 2013 15:21:16 -0800 (PST)
Message-ID: <52782BE9.7080203@gmail.com>
Date: Tue, 05 Nov 2013 00:21:13 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	John Sheu <sheu@google.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.chehab@samsung.com,
	Kamil Debski <k.debski@samsung.com>, pawel@osciak.com
Subject: Re: Fwd: [PATCH 3/6] [media] s5p-mfc: add support for VIDIOC_{G,S}_CROP
 to encoder
References: <1381362589-32237-1-git-send-email-sheu@google.com> <1381362589-32237-4-git-send-email-sheu@google.com> <52564DE6.6090709@xs4all.nl> <CAErgknA-3bk1BoYa6KJAfO+863DBTi_5U8i_hh7F8O+mXfyNWg@mail.gmail.com> <CAErgknA-ZgSzeeaaEuYKFZ0zonCt=10tBX7FeOT16-yQLZVnZw@mail.gmail.com> <52590184.5030806@xs4all.nl> <CAErgknAXZzbBMm0JeASOVzsXNNyu7Af32hd0t_fR8VkPeVrx4A@mail.gmail.com> <526001DF.9040309@samsung.com> <CAErgknCu2UeEQeY+taSXAbC6F4i=FMTz8t=MhSLUdfQRZXQgAg@mail.gmail.com> <CAErgknDhiSg0v_4KvMuoTX4Xcy9t+d2=+QWJu0riM1B0kQVMcg@mail.gmail.com> <52606AB7.7020200@gmail.com> <CAErgknBEJmVwjG6xs8Es3C8ZkjuDgnM6NUUx07me+Rf2bKdzZg@mail.gmail.com> <52777D9B.9000308@xs4all.nl> <52778515.6070204@samsung.com> <52778E17.1040503@xs4all.nl>
In-Reply-To: <52778E17.1040503@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 11/04/2013 01:07 PM, Hans Verkuil wrote:
> Let me be precise as to what should happen, and you can check whether that's
> what is actually done in the fimc and g2d drivers.
>
> For V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>
> Say that the mem2mem hardware creates a 640x480 picture. If VIDIOC_S_CROP was
> called for V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE with a rectangle of 320x240@160x120,
> then the DMA engine will only transfer the center 320x240 rectangle to memory.
> This means that S_FMT needs to provide a buffer size large enough to accomodate
> a 320x240 image.
>
> So: VIDIOC_S_CROP(CAPTURE) == S_SELECTION(CAPTURE, V4L2_SEL_TGT_CROP).

Unfortunately it's not how it currently works at these drivers. For 
VIDIOC_S_CROP
called with V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE and a rectangle of 
320x240@160x120
the hardware would scale and compose full 640x480 image onto 320x240 
rectangle
in the output memory buffer at position 160x120.
IIRC the g2d device cannot scale so it would not allow to select DMA output
rectangle smaller than 640x480. But looking at the code it doesn't do 
any crop
parameters validation...

So VIDIOC_S_CROP(CAPTURE) is actually being abused on m2m as 
S_SELECTION(CAPTURE,
V4L2_SEL_TGT_COMPOSE).

> For V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>
> Say that the image in memory is a 640x480 picture. If VIDIOC_S_CROP was called
> for V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE with a rectangle of 320x240@160x120 then
> this would mean that the full 640x480 image is DMAed to the hardware, is scaled
> down to 320x240 and composed at position (160x120) in a canvas of at least 480x360.
>
> In other words, S_CROP behaves as composition for output devices:
> VIDIOC_S_CROP(OUTPUT) == S_SELECTION(OUTPUT, V4L2_SEL_TGT_COMPOSE).

No, in case of these devices VIDIOC_S_CROP(OUTPUT) does what it actually 
means -
the DMA would read only 320x240 rectangle at position 160x120.

> The last operation in particular is almost certainly not what you want for
> m2m devices. Instead, you want to select (crop) part of the image in memory and
> DMA that to the device. This is S_SELECTION(OUTPUT, V4L2_SEL_TGT_CROP) and cannot
> be translated to an S_CROP ioctl.

Yeah, I didn't come yet across a video mem-to-mem hardware that would 
support steps
as in your first description of crop on V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE.
S_SELECTION(OUTPUT, V4L2_SEL_TGT_CROP) seems to have been redefined on 
mem-to-mem
devices to do what it actually says. But it's not written anywhere in 
the spec
yet, so I guess we could keep the crop ioctls in those drivers, in order 
to not
break existing user space, and implement the selection API ioctls after 
documenting
its semantics for mem-to-mem devices.

> What's more: in order to implement S_SELECTION(OUTPUT, V4L2_SEL_TGT_COMPOSE) you
> would need some way of setting the 'canvas' size of the m2m device, and there is
> no API today to do this (this was discussed during the v4l/dvb mini-summit).
>
> Regarding the capture side of an m2m device: it is not clear to me what these
> drivers implement: S_SELECTION(CAPTURE, V4L2_SEL_TGT_CROP) or
>S_SELECTION(CAPTURE, V4L2_SEL_TGT_COMPOSE).
>
> If it is the latter, then again S_CROP cannot be used and you have to use
>S_SELECTION.

It's equivalent of S_SELECTION(CAPTURE, V4L2_SEL_TGT_COMPOSE). Note that 
the
fimc and mfc drivers were written long before the selection API was 
introduced.

Presumably the crop ioctls should just be deprecated (however handlers 
left for
backward compatibility) in those drivers, once there is complete 
definition of
the selections API for the m2m video devices.
It's probably worth to avoid adding any translation layer of such behaviour
(which doesn't match your definitions above) to the v4l2-core.

--
Regards,
Sylwester
