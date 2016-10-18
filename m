Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:40581 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932810AbcJRG4p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 02:56:45 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] media: platform: pxa_camera: add missing sensor power on
References: <1474656100-7415-1-git-send-email-robert.jarzmik@free.fr>
Date: Tue, 18 Oct 2016 08:56:42 +0200
In-Reply-To: <1474656100-7415-1-git-send-email-robert.jarzmik@free.fr> (Robert
        Jarzmik's message of "Fri, 23 Sep 2016 20:41:39 +0200")
Message-ID: <874m4a5emt.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> During sensors binding, there is a window where the sensor is switched
> off, while there is a call it to set a new format, which can end up in
> an access to the sensor, especially an I2C based sensor.
>
> Remove this window by activating the sensor.
Hi guys,

I can't remember if I have review issues I have to address for this serie or
not. My mailer seems to tell no, but let's check again.

This serie is adding back the "power on" of the sensors through the generic
regulator API, and is my prequisite for pxa submitted changes, which were
formerly a "hook" in soc_camera_link structure, see:
         https://www.spinics.net/lists/kernel/msg2350167.html

Cheers.

--
Robert

[1] Remaining of the patch for reference

> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/platform/pxa_camera.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
> index 2978cd6efa63..794c41d24d9f 100644
> --- a/drivers/media/platform/pxa_camera.c
> +++ b/drivers/media/platform/pxa_camera.c
> @@ -2128,17 +2128,22 @@ static int pxa_camera_sensor_bound(struct v4l2_async_notifier *notifier,
>  				    pix->bytesperline, pix->height);
>  	pix->pixelformat = pcdev->current_fmt->host_fmt->fourcc;
>  	v4l2_fill_mbus_format(mf, pix, pcdev->current_fmt->code);
> -	err = sensor_call(pcdev, pad, set_fmt, NULL, &format);
> +
> +	err = sensor_call(pcdev, core, s_power, 1);
>  	if (err)
>  		goto out;
>  
> +	err = sensor_call(pcdev, pad, set_fmt, NULL, &format);
> +	if (err)
> +		goto out_sensor_poweroff;
> +
>  	v4l2_fill_pix_format(pix, mf);
>  	pr_info("%s(): colorspace=0x%x pixfmt=0x%x\n",
>  		__func__, pix->colorspace, pix->pixelformat);
>  
>  	err = pxa_camera_init_videobuf2(pcdev);
>  	if (err)
> -		goto out;
> +		goto out_sensor_poweroff;
>  
>  	err = video_register_device(&pcdev->vdev, VFL_TYPE_GRABBER, -1);
>  	if (err) {
> @@ -2149,6 +2154,9 @@ static int pxa_camera_sensor_bound(struct v4l2_async_notifier *notifier,
>  			 "PXA Camera driver attached to camera %s\n",
>  			 subdev->name);
>  	}
> +
> +out_sensor_poweroff:
> +	err = sensor_call(pcdev, core, s_power, 0);
>  out:
>  	mutex_unlock(&pcdev->mlock);
>  	return err;

-- 
Robert
