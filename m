Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37634 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933763AbdCJLQI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 06:16:08 -0500
Date: Fri, 10 Mar 2017 13:15:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv4 12/15] ov2640: add MC support
Message-ID: <20170310111531.GE3220@valkosipuli.retiisi.org.uk>
References: <20170310102614.20922-1-hverkuil@xs4all.nl>
 <20170310102614.20922-13-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170310102614.20922-13-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Mar 10, 2017 at 11:26:11AM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The MC support is needed by the em28xx driver.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/ov2640.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
> index 0445963c5fae..00df042fd6f1 100644
> --- a/drivers/media/i2c/ov2640.c
> +++ b/drivers/media/i2c/ov2640.c
> @@ -282,6 +282,9 @@ struct ov2640_win_size {
>  
>  struct ov2640_priv {
>  	struct v4l2_subdev		subdev;
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	struct media_pad pad;
> +#endif
>  	struct v4l2_ctrl_handler	hdl;
>  	u32	cfmt_code;
>  	struct clk			*clk;
> @@ -1073,19 +1076,30 @@ static int ov2640_probe(struct i2c_client *client,
>  		ret = priv->hdl.error;
>  		goto err_hdl;
>  	}

As this is a sensor the format etc. should be accessible from the user
space, shouldn't you have V4L2_SUBDEV_FL_HAS_DEVNODE flag for the
sub-device as well?

The device node isn't exposed unless v4l2_device_register_subdev_nodes() is
called anyway.

> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	priv->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> +	ret = media_entity_pads_init(&priv->subdev.entity, 1, &priv->pad);
> +	if (ret < 0)
> +		goto err_hdl;
> +#endif
>  
>  	ret = ov2640_video_probe(client);
>  	if (ret < 0)
> -		goto err_hdl;
> +		goto err_videoprobe;
>  
>  	ret = v4l2_async_register_subdev(&priv->subdev);
>  	if (ret < 0)
> -		goto err_hdl;
> +		goto err_videoprobe;
>  
>  	dev_info(&adapter->dev, "OV2640 Probed\n");
>  
>  	return 0;
>  
> +err_videoprobe:
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	media_entity_cleanup(&priv->subdev.entity);

I believe you can call media_entity_cleanup() as the function does nothing
right now. In general, we should provide nop variants if MC is disabled.

> +#endif
>  err_hdl:
>  	v4l2_ctrl_handler_free(&priv->hdl);
>  err_clk:
> @@ -1099,6 +1113,9 @@ static int ov2640_remove(struct i2c_client *client)
>  
>  	v4l2_async_unregister_subdev(&priv->subdev);
>  	v4l2_ctrl_handler_free(&priv->hdl);
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	media_entity_cleanup(&priv->subdev.entity);
> +#endif
>  	v4l2_device_unregister_subdev(&priv->subdev);
>  	clk_disable_unprepare(priv->clk);
>  	return 0;

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
