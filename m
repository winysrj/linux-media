Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:45663 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752343AbeBZLJ4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 06:09:56 -0500
Subject: Re: [PATCH v3] media: radio: Critical v4l2 registration bugfix for
 si470x over i2c
To: Douglas Fischer <fischerdouglasc@gmail.com>,
        linux-media@vger.kernel.org
References: <20180225212506.7ba4a314@Constantine>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <067f751c-8129-f88b-f91e-8b10bc803754@xs4all.nl>
Date: Mon, 26 Feb 2018 12:09:52 +0100
MIME-Version: 1.0
In-Reply-To: <20180225212506.7ba4a314@Constantine>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/26/2018 03:25 AM, Douglas Fischer wrote:
> Added the call to v4l2_device_register() required to add a new radio
> device. Without this patch, it is impossible for the driver to load.
> This does not affect USB devices.
> 
> Fixed cleanup order from v2.
> 
> Signed-off-by: Douglas Fischer <fischerdouglasc@gmail.com>
> ---
> 
> diff -uprN linux.orig/drivers/media/radio/si470x/radio-si470x-i2c.c
> linux/drivers/media/radio/si470x/radio-si470x-i2c.c ---
> linux.orig/drivers/media/radio/si470x/radio-si470x-i2c.c
> 2018-01-15 21:58:10.675620432 -0500 +++
> linux/drivers/media/radio/si470x/radio-si470x-i2c.c	2018-02-25
> 19:19:13.796927568 -0500 @@ -43,7 +43,6 @@ static const struct
> i2c_device_id si470x MODULE_DEVICE_TABLE(i2c, si470x_i2c_id); 

This patch is still corrupt (wrap around). The other two are fine though.

Can you repost this one?

Regards,

	Hans

> -
>  /**************************************************************************
>   * Module Parameters
>   **************************************************************************/
> @@ -362,22 +361,43 @@ static int si470x_i2c_probe(struct i2c_c
>  	mutex_init(&radio->lock);
>  	init_completion(&radio->completion);
>  
> +	retval = v4l2_device_register(&client->dev, &radio->v4l2_dev);
> +	if (retval < 0) {
> +		dev_err(&client->dev, "couldn't register
> v4l2_device\n");
> +		goto err_radio;
> +	}
> +
> +	v4l2_ctrl_handler_init(&radio->hdl, 2);
> +	v4l2_ctrl_new_std(&radio->hdl, &si470x_ctrl_ops,
> +			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
> +	v4l2_ctrl_new_std(&radio->hdl, &si470x_ctrl_ops,
> +			V4L2_CID_AUDIO_VOLUME, 0, 15, 1, 15);
> +	if (radio->hdl.error) {
> +		retval = radio->hdl.error;
> +		dev_err(&client->dev, "couldn't register control\n");
> +		goto err_dev;
> +	}
> +
>  	/* video device initialization */
>  	radio->videodev = si470x_viddev_template;
> +	radio->videodev.ctrl_handler = &radio->hdl;
> +	radio->videodev.lock = &radio->lock;
> +	radio->videodev.v4l2_dev = &radio->v4l2_dev;
> +	radio->videodev.release = video_device_release_empty;
>  	video_set_drvdata(&radio->videodev, radio);
>  
>  	/* power up : need 110ms */
>  	radio->registers[POWERCFG] = POWERCFG_ENABLE;
>  	if (si470x_set_register(radio, POWERCFG) < 0) {
>  		retval = -EIO;
> -		goto err_radio;
> +		goto err_ctrl;
>  	}
>  	msleep(110);
>  
>  	/* get device and chip versions */
>  	if (si470x_get_all_registers(radio) < 0) {
>  		retval = -EIO;
> -		goto err_radio;
> +		goto err_ctrl;
>  	}
>  	dev_info(&client->dev, "DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
>  			radio->registers[DEVICEID],
> radio->registers[SI_CHIPID]); @@ -407,7 +427,7 @@ static int
> si470x_i2c_probe(struct i2c_c radio->buffer = kmalloc(radio->buf_size,
> GFP_KERNEL); if (!radio->buffer) {
>  		retval = -EIO;
> -		goto err_radio;
> +		goto err_ctrl;
>  	}
>  
>  	/* rds buffer configuration */
> @@ -437,6 +457,10 @@ err_all:
>  	free_irq(client->irq, radio);
>  err_rds:
>  	kfree(radio->buffer);
> +err_ctrl:
> +	v4l2_ctrl_handler_free(&radio->hdl);
> +err_dev:
> +	v4l2_device_unregister(&radio->v4l2_dev);
>  err_radio:
>  	kfree(radio);
>  err_initial:
> 
