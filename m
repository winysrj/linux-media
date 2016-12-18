Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48478 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753752AbcLRWIn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Dec 2016 17:08:43 -0500
Date: Mon, 19 Dec 2016 00:08:09 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 02/15] ov7670: call v4l2_async_register_subdev
Message-ID: <20161218220809.GV16630@valkosipuli.retiisi.org.uk>
References: <20161212155520.41375-1-hverkuil@xs4all.nl>
 <20161212155520.41375-3-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161212155520.41375-3-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 12, 2016 at 04:55:07PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add v4l2-async support for this driver.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/ov7670.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index b0315bb..3f0522f 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -1641,18 +1641,15 @@ static int ov7670_probe(struct i2c_client *client,
>  	if (info->hdl.error) {
>  		int err = info->hdl.error;
>  
> -		v4l2_ctrl_handler_free(&info->hdl);
> -		return err;
> +		goto fail;
>  	}
>  
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	info->pad.flags = MEDIA_PAD_FL_SOURCE;
>  	info->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>  	ret = media_entity_pads_init(&info->sd.entity, 1, &info->pad);
> -	if (ret < 0) {
> -		v4l2_ctrl_handler_free(&info->hdl);
> -		return ret;
> -	}
> +	if (ret < 0)
> +		goto fail;
>  #endif
>  	/*
>  	 * We have checked empirically that hw allows to read back the gain
> @@ -1664,7 +1661,19 @@ static int ov7670_probe(struct i2c_client *client,
>  	v4l2_ctrl_cluster(2, &info->saturation);
>  	v4l2_ctrl_handler_setup(&info->hdl);
>  
> +	ret = v4l2_async_register_subdev(&info->sd);
> +	if (ret < 0) {
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +		media_entity_cleanup(&info->sd.entity);

I think it'd be cleaner if you added another label for this. Up to you.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +#endif
> +		goto fail;
> +	}
> +
>  	return 0;
> +
> +fail:
> +	v4l2_ctrl_handler_free(&info->hdl);
> +	return ret;
>  }
>  
>  

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
