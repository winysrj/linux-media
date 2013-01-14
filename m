Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:4128 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab3ANJUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 04:20:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [PATCH] em28xx: return -ENOTTY for tuner + frequency ioctls if the device has no tuner
Date: Mon, 14 Jan 2013 10:20:24 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	hans.verkuil@cisco.com
References: <1358081450-5705-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1358081450-5705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301141020.24697.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun January 13 2013 13:50:50 Frank Schäfer wrote:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-video.c |    8 ++++++++
>  1 Datei geändert, 8 Zeilen hinzugefügt(+)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 2eabf2a..4a7f73c 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -1204,6 +1204,8 @@ static int vidioc_g_tuner(struct file *file, void *priv,
>  	struct em28xx         *dev = fh->dev;
>  	int                   rc;
>  
> +	if (dev->tuner_type == TUNER_ABSENT)
> +		return -ENOTTY;
>  	rc = check_dev(dev);
>  	if (rc < 0)
>  		return rc;
> @@ -1224,6 +1226,8 @@ static int vidioc_s_tuner(struct file *file, void *priv,
>  	struct em28xx         *dev = fh->dev;
>  	int                   rc;
>  
> +	if (dev->tuner_type == TUNER_ABSENT)
> +		return -ENOTTY;
>  	rc = check_dev(dev);
>  	if (rc < 0)
>  		return rc;
> @@ -1241,6 +1245,8 @@ static int vidioc_g_frequency(struct file *file, void *priv,
>  	struct em28xx_fh      *fh  = priv;
>  	struct em28xx         *dev = fh->dev;
>  
> +	if (dev->tuner_type == TUNER_ABSENT)
> +		return -ENOTTY;
>  	if (0 != f->tuner)
>  		return -EINVAL;
>  
> @@ -1255,6 +1261,8 @@ static int vidioc_s_frequency(struct file *file, void *priv,
>  	struct em28xx         *dev = fh->dev;
>  	int                   rc;
>  
> +	if (dev->tuner_type == TUNER_ABSENT)
> +		return -ENOTTY;
>  	rc = check_dev(dev);
>  	if (rc < 0)
>  		return rc;
> 

Rather than doing this in each ioctl, I recommend using v4l2_disable_ioctl
instead. See for example drivers/media/pci/ivtv/ivtv-streams.c.

Regards,

	Hans
