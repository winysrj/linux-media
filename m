Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40621 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab1GVUHB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 16:07:01 -0400
MIME-Version: 1.0
In-Reply-To: <201107222200.55834.linux@rainbow-software.org>
References: <201107222200.55834.linux@rainbow-software.org>
Date: Fri, 22 Jul 2011 16:06:59 -0400
Message-ID: <CAGoCfiwqzs70A26WgN2pJJvz2aDzY9siOcTuOCkYm3nDHB=J1Q@mail.gmail.com>
Subject: Re: [PATCH] [resend] usbvision: disable scaling for Nogatech MicroCam
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Joerg Heckenbach <joerg@heckenbach-aw.de>,
	Dwaine Garden <dwainegarden@rogers.com>,
	linux-media@vger.kernel.org,
	Kernel development list <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 22, 2011 at 4:00 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> Scaling causes bad artifacts (horizontal lines) with compression at least
> with Nogatech MicroCam so disable it (for this HW).
>
> This also fixes messed up image with some programs (Cheese with 160x120,
> Adobe Flash). HW seems to support only image widths that are multiple of 64
> but the driver does not account that in vidioc_try_fmt_vid_cap(). Cheese
> calls try_fmt with 160x120, succeeds and then assumes that it really gets
> data in that resolution - but it gets 128x120 instead. Don't know if this
> affects other usbvision devices, it would be great if someone could test it.
>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>
> diff -urp linux-2.6.39-rc2-/drivers/media/video/usbvision//usbvision-video.c linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-video.c
> --- linux-2.6.39-rc2-/drivers/media/video/usbvision//usbvision-video.c �2011-07-16 16:42:35.000000000 +0200
> +++ linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-video.c � �2011-07-16 16:36:43.000000000 +0200
> @@ -924,6 +924,11 @@ static int vidioc_try_fmt_vid_cap(struct
> � � � �RESTRICT_TO_RANGE(vf->fmt.pix.width, MIN_FRAME_WIDTH, MAX_FRAME_WIDTH);
> � � � �RESTRICT_TO_RANGE(vf->fmt.pix.height, MIN_FRAME_HEIGHT, MAX_FRAME_HEIGHT);
>
> + � � � if (usbvision_device_data[usbvision->dev_model].codec == CODEC_WEBCAM) {
> + � � � � � � � vf->fmt.pix.width = MAX_FRAME_WIDTH;
> + � � � � � � � vf->fmt.pix.height = MAX_FRAME_HEIGHT;
> + � � � }
> +
> � � � �vf->fmt.pix.bytesperline = vf->fmt.pix.width*
> � � � � � � � �usbvision->palette.bytes_per_pixel;
> � � � �vf->fmt.pix.sizeimage = vf->fmt.pix.bytesperline*vf->fmt.pix.height;
> @@ -952,6 +957,11 @@ static int vidioc_s_fmt_vid_cap(struct f
>
> � � � �usbvision->cur_frame = NULL;
>
> + � � � if (usbvision_device_data[usbvision->dev_model].codec == CODEC_WEBCAM) {
> + � � � � � � � vf->fmt.pix.width = MAX_FRAME_WIDTH;
> + � � � � � � � vf->fmt.pix.height = MAX_FRAME_HEIGHT;
> + � � � }
> +
> � � � �/* by now we are committed to the new data... */
> � � � �usbvision_set_output(usbvision, vf->fmt.pix.width, vf->fmt.pix.height);
>
>
> --
> Ondrej Zary

Hello Ondrej,

Drivers are permitted to return a different resolution than what the
application provided in the S_FMT call.  It is the responsibility of
the application to look at the struct after the ioctl() call and if
the values are not what it expects to then accommodate the change.

In other words, this sounds like a bug in Cheese.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
