Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:36657 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305Ab3BFPjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 10:39:06 -0500
Received: by mail-ea0-f176.google.com with SMTP id a13so702848eaa.35
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 07:39:05 -0800 (PST)
Message-ID: <51127947.1070602@googlemail.com>
Date: Wed, 06 Feb 2013 16:39:51 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH] em28xx: fix bytesperline calculation in TRY_FMT
References: <1360152887-4503-1-git-send-email-hverkuil@xs4all.nl> <0ecef7fe376d8e8f932f2d8903d54b894fa87abf.1360152758.git.hans.verkuil@cisco.com>
In-Reply-To: <0ecef7fe376d8e8f932f2d8903d54b894fa87abf.1360152758.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 06.02.2013 13:14, schrieb Hans Verkuil:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The bytesperline calculation was incorrect: it used the old width instead of
> the provided width. Fixed.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/em28xx/em28xx-video.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 2eabf2a..32bd7de 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -906,7 +906,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  	f->fmt.pix.width = width;
>  	f->fmt.pix.height = height;
>  	f->fmt.pix.pixelformat = fmt->fourcc;
> -	f->fmt.pix.bytesperline = (dev->width * fmt->depth + 7) >> 3;
> +	f->fmt.pix.bytesperline = (width * fmt->depth + 7) >> 3;
>  	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * height;
>  	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>  	if (dev->progressive)

Acked-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Also Cc: stable@kernel.org ?

Regards,
Frank

