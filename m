Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57416 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdLKOry (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 09:47:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 08/10] media: i2c: ov772x: Remove soc_camera dependencies
Date: Mon, 11 Dec 2017 16:47:55 +0200
Message-ID: <2078986.UahPtJ6YpD@avalon>
In-Reply-To: <1510743363-25798-9-git-send-email-jacopo+renesas@jmondi.org>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org> <1510743363-25798-9-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Wednesday, 15 November 2017 12:56:01 EET Jacopo Mondi wrote:
> Remove soc_camera framework dependencies from ov772x sensor driver.
> - Handle clock directly
> - Register async subdevice
> - Add platform specific enable/disable functions
> - Adjust build system
> 
> This commit does not remove the original soc_camera based driver.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/Kconfig  | 12 +++++++
>  drivers/media/i2c/Makefile |  1 +
>  drivers/media/i2c/ov772x.c | 88 ++++++++++++++++++++++++++++---------------
>  include/media/i2c/ov772x.h |  3 ++
>  4 files changed, 76 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 9415389..ff251ce 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -629,6 +629,18 @@ config VIDEO_OV5670
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called ov5670.
> 
> +config VIDEO_OV772X
> +	tristate "OmniVision OV772x sensor support"
> +	depends on I2C && VIDEO_V4L2
> +	depends on MEDIA_CAMERA_SUPPORT
> +	---help---
> +	  This is a Video4Linux2 sensor-level driver for the OmniVision
> +	  OV772x camera.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called ov772x.
> +
> +

A single blank line is enough.

>  config VIDEO_OV7640
>  	tristate "OmniVision OV7640 sensor support"
>  	depends on I2C && VIDEO_V4L2
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index f104650..b2459a1 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -66,6 +66,7 @@ obj-$(CONFIG_VIDEO_OV5645) += ov5645.o
>  obj-$(CONFIG_VIDEO_OV5647) += ov5647.o
>  obj-$(CONFIG_VIDEO_OV5670) += ov5670.o
>  obj-$(CONFIG_VIDEO_OV6650) += ov6650.o
> +obj-$(CONFIG_VIDEO_OV772X) += ov772x.o
>  obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
>  obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
>  obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 8063835..9be7e4e 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c

[snip]

> @@ -650,13 +651,36 @@ static int ov772x_s_register(struct v4l2_subdev *sd,
>  }
>  #endif
> 
> +static int ov772x_power_on(struct ov772x_priv *priv)
> +{
> +	int ret;
> +
> +	if (priv->info->platform_enable) {
> +		ret = priv->info->platform_enable();
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/*  drivers/sh/clk/core.c returns -EINVAL if clk is NULL */
> +	return clk_enable(priv->clk) <= 0 ? 0 : 1;

Then please don't call clk_enable() if priv->clk is NULL, and propagate errors 
from clk_enable() back to the caller.

And shouldn't you call clk_prepare_enable() (and clk_disable_unprepare() 
below) ?

> +}
> +
> +static int ov772x_power_off(struct ov772x_priv *priv)
> +{
> +	if (priv->info->platform_enable)
> +		priv->info->platform_disable();
> +
> +	clk_disable(priv->clk);
> +
> +	return 0;
> +}

[snip]

> @@ -1073,21 +1092,33 @@ static int ov772x_probe(struct i2c_client *client,
>  	if (priv->hdl.error)
>  		return priv->hdl.error;
> 
> -	priv->clk = v4l2_clk_get(&client->dev, "mclk");
> -	if (IS_ERR(priv->clk)) {
> +	priv->clk = clk_get(&client->dev, "mclk");
> +	if (PTR_ERR(priv->clk) == -ENOENT) {
> +		priv->clk = NULL;
> +	} else if (IS_ERR(priv->clk)) {
> +		dev_err(&client->dev, "Unable to get mclk clock\n");
>  		ret = PTR_ERR(priv->clk);
> -		goto eclkget;

You need a priv->clk = NULL here otherwise the error path will oops.

> +		goto error_clk_enable;
>  	}
> 
>  	ret = ov772x_video_probe(priv);
> -	if (ret < 0) {
> -		v4l2_clk_put(priv->clk);
> -eclkget:
> -		v4l2_ctrl_handler_free(&priv->hdl);
> -	} else {
> -		priv->cfmt = &ov772x_cfmts[0];
> -		priv->win = &ov772x_win_sizes[0];
> -	}
> +	if (ret < 0)
> +		goto error_video_probe;
> +
> +	priv->cfmt = &ov772x_cfmts[0];
> +	priv->win = &ov772x_win_sizes[0];
> +
> +	ret = v4l2_async_register_subdev(&priv->subdev);
> +	if (ret)
> +		goto error_video_probe;
> +
> +	return 0;
> +
> +error_video_probe:
> +	if (priv->clk)
> +		clk_put(priv->clk);

clk_put() accepts a NULL clock, you don't have to check the pointer first.

> +error_clk_enable:
> +	v4l2_ctrl_handler_free(&priv->hdl);
> 
>  	return ret;
>  }
> @@ -1096,7 +1127,8 @@ static int ov772x_remove(struct i2c_client *client)
>  {
>  	struct ov772x_priv *priv = to_ov772x(i2c_get_clientdata(client));
> 
> -	v4l2_clk_put(priv->clk);
> +	if (priv->clk)
> +		clk_put(priv->clk);

Same here.

>  	v4l2_device_unregister_subdev(&priv->subdev);
>  	v4l2_ctrl_handler_free(&priv->hdl);
>  	return 0;
> diff --git a/include/media/i2c/ov772x.h b/include/media/i2c/ov772x.h
> index 00dbb7c..5896dff 100644
> --- a/include/media/i2c/ov772x.h
> +++ b/include/media/i2c/ov772x.h
> @@ -54,6 +54,9 @@ struct ov772x_edge_ctrl {
>  struct ov772x_camera_info {
>  	unsigned long		flags;
>  	struct ov772x_edge_ctrl	edgectrl;
> +
> +	int (*platform_enable)(void);
> +	void (*platform_disable)(void);
>  };
> 
>  #endif /* __OV772X_H__ */

-- 
Regards,

Laurent Pinchart
