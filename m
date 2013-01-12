Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:55792 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab3ALSJs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Jan 2013 13:09:48 -0500
Received: by mail-bk0-f42.google.com with SMTP id ji2so1385006bkc.29
        for <linux-media@vger.kernel.org>; Sat, 12 Jan 2013 10:09:47 -0800 (PST)
Message-ID: <50F1A70A.5080600@googlemail.com>
Date: Sat, 12 Jan 2013 19:10:18 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: mchehab@redhat.com, linux-media@vger.kernel.org,
	hans.verkuil@cisco.com
Subject: Re: [PATCH] em28xx: return -ENOTTY for tuner + frequency + VBI-format
 ioctls if the device is a webcam
References: <1358013084-5748-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1358013084-5748-1-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 12.01.2013 18:51, schrieb Frank Schäfer:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-video.c |   14 ++++++++++++++
>  1 Datei geändert, 14 Zeilen hinzugefügt(+)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 2eabf2a..1d1ef68 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -1204,6 +1204,8 @@ static int vidioc_g_tuner(struct file *file, void *priv,
>  	struct em28xx         *dev = fh->dev;
>  	int                   rc;
>  
> +	if (dev->board.is_webcam)
> +		return -ENOTTY;
>  	rc = check_dev(dev);
>  	if (rc < 0)
>  		return rc;
> @@ -1224,6 +1226,8 @@ static int vidioc_s_tuner(struct file *file, void *priv,
>  	struct em28xx         *dev = fh->dev;
>  	int                   rc;
>  
> +	if (dev->board.is_webcam)
> +		return -ENOTTY;
>  	rc = check_dev(dev);
>  	if (rc < 0)
>  		return rc;
> @@ -1241,6 +1245,8 @@ static int vidioc_g_frequency(struct file *file, void *priv,
>  	struct em28xx_fh      *fh  = priv;
>  	struct em28xx         *dev = fh->dev;
>  
> +	if (dev->board.is_webcam)
> +		return -ENOTTY;
>  	if (0 != f->tuner)
>  		return -EINVAL;
>  
> @@ -1255,6 +1261,8 @@ static int vidioc_s_frequency(struct file *file, void *priv,
>  	struct em28xx         *dev = fh->dev;
>  	int                   rc;
>  
> +	if (dev->board.is_webcam)
> +		return -ENOTTY;
>  	rc = check_dev(dev);
>  	if (rc < 0)
>  		return rc;
> @@ -1499,6 +1507,9 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
>  	struct em28xx_fh      *fh  = priv;
>  	struct em28xx         *dev = fh->dev;
>  
> +	if (dev->board.is_webcam)
> +		return -ENOTTY;
> +
>  	format->fmt.vbi.samples_per_line = dev->vbi_width;
>  	format->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
>  	format->fmt.vbi.offset = 0;
> @@ -1528,6 +1539,9 @@ static int vidioc_s_fmt_vbi_cap(struct file *file, void *priv,
>  	struct em28xx_fh      *fh  = priv;
>  	struct em28xx         *dev = fh->dev;
>  
> +	if (dev->board.is_webcam)
> +		return -ENOTTY;
> +
>  	format->fmt.vbi.samples_per_line = dev->vbi_width;
>  	format->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
>  	format->fmt.vbi.offset = 0;

Please disregard this patch, I will send a better one tomorrow.

Regards,
Frank

