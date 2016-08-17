Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44825 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbcHQMZg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 08:25:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Songjun Wu <songjun.wu@microchip.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/7] ov7670: add media controller support
Date: Wed, 17 Aug 2016 15:25:50 +0300
Message-ID: <8975048.xlTtpRAV5u@avalon>
In-Reply-To: <1471415383-38531-2-git-send-email-hverkuil@xs4all.nl>
References: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl> <1471415383-38531-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Wednesday 17 Aug 2016 08:29:37 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add media controller support.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/ov7670.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index 56cfb5c..25f46c7 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -210,6 +210,7 @@ struct ov7670_devtype {
>  struct ov7670_format_struct;  /* coming later */
>  struct ov7670_info {
>  	struct v4l2_subdev sd;
> +	struct media_pad pad;

You could guard this with #if defined(CONFIG_MEDIA_CONTROLLER) as well. I'm 
wondering, however, whether we shouldn't start making CONFIG_MEDIA_CONTROLLER 
mandatory for I2C sensors.

>  	struct v4l2_ctrl_handler hdl;
>  	struct {
>  		/* gain cluster */
> @@ -1641,6 +1642,16 @@ static int ov7670_probe(struct i2c_client *client,
>  		v4l2_ctrl_handler_free(&info->hdl);
>  		return err;
>  	}
> +
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	info->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	info->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> +	ret = media_entity_pads_init(&info->sd.entity, 1, &info->pad);
> +	if (ret < 0) {
> +		v4l2_ctrl_handler_free(&info->hdl);
> +		return ret;
> +	}
> +#endif
>  	/*
>  	 * We have checked empirically that hw allows to read back the gain
>  	 * value chosen by auto gain but that's not the case for auto 
exposure.
> @@ -1662,6 +1673,9 @@ static int ov7670_remove(struct i2c_client *client)
> 
>  	v4l2_device_unregister_subdev(sd);
>  	v4l2_ctrl_handler_free(&info->hdl);
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	media_entity_cleanup(&sd->entity);
> +#endif
>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart

