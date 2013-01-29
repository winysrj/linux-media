Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:44811 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3A2RvG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 12:51:06 -0500
Received: by mail-ea0-f172.google.com with SMTP id f13so314240eaa.17
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2013 09:51:04 -0800 (PST)
Message-ID: <51080C32.40601@googlemail.com>
Date: Tue, 29 Jan 2013 18:51:46 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [RFC PATCH] em28xx: fix bytesperline calculation in TRY_FMT
References: <201301291049.58085.hverkuil@xs4all.nl>
In-Reply-To: <201301291049.58085.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 29.01.2013 10:49, schrieb Hans Verkuil:
> This was part of my original em28xx patch series. That particular patch
> combined two things: this fix and the change where TRY_FMT would no
> longer return -EINVAL for unsupported pixelformats. The latter change was
> rejected (correctly), but we all forgot about the second part of the patch
> which fixed a real bug. I'm reposting just that fix.
>
> Regards,
>
> 	Hans
>
> The bytesperline calculation was incorrect: it used the old width instead
> of the provided width, and it miscalculated the bytesperline value for the
> depth == 12 case.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/em28xx/em28xx-video.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 2eabf2a..070506d 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -906,7 +906,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  	f->fmt.pix.width = width;
>  	f->fmt.pix.height = height;
>  	f->fmt.pix.pixelformat = fmt->fourcc;
> -	f->fmt.pix.bytesperline = (dev->width * fmt->depth + 7) >> 3;
> +	f->fmt.pix.bytesperline = width * ((fmt->depth + 7) >> 3);
>  	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * height;
>  	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>  	if (dev->progressive)

Hmm... how are 12 bit pixels stored ? Are padding bits used so that 2
bytes per pixel are needed ?
I wonder if V4L2_PIX_FMT_YUV411P has ever been tested (libv4lconvert
doesn't support it)...

While we are at it, we should check and fix the other size calculations,
too.
For example, in em28xx-video.c we have in

vidioc_g_fmt_vid_cap():
f->fmt.pix.bytesperline = (dev->width * dev->format->depth + 7) >> 3;

queue_setup():
size = (dev->width * dev->height * dev->format->depth + 7) >> 3;

buffer_prepare():
size = (dev->width * dev->height * dev->format->depth + 7) >> 3;

em28xx_copy_video():
int bytesperline = dev->width << 1;

and there are probably more places...


Regards,
Frank


