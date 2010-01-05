Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44560 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753903Ab0AEIVF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jan 2010 03:21:05 -0500
Date: Tue, 5 Jan 2010 09:21:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Paul Mundt <lethal@linux-sh.org>,
	Linux-V4L2 <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc-camera: ov772x: Add buswidth selection flags for
 platform
In-Reply-To: <u8wcdf9r8.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.1001050848140.5259@axis700.grange>
References: <u8wcdf9r8.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Morimoto-san

On Tue, 5 Jan 2010, Kuninori Morimoto wrote:

> This patch remove "buswidth" struct member and add new flags for ov772x_camera_info.
> And it also modify ap325rxa/migor setup.c

Can you explain a bit why this patch is needed? Apart from a slight 
stylistic improvement and a saving of 4 bytes of platform data per camera 
instance? Is it going to be needed for some future changes?

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  arch/sh/boards/mach-ap325rxa/setup.c |    4 ++--
>  arch/sh/boards/mach-migor/setup.c    |    2 +-
>  drivers/media/video/ov772x.c         |   28 ++++++++++++----------------
>  include/media/ov772x.h               |    7 ++++---
>  4 files changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
> index 1f5fa5c..71f556f 100644
> --- a/arch/sh/boards/mach-ap325rxa/setup.c
> +++ b/arch/sh/boards/mach-ap325rxa/setup.c
> @@ -471,8 +471,8 @@ static struct i2c_board_info ap325rxa_i2c_camera[] = {
>  };
>  
>  static struct ov772x_camera_info ov7725_info = {
> -	.buswidth	= SOCAM_DATAWIDTH_8,
> -	.flags		= OV772X_FLAG_VFLIP | OV772X_FLAG_HFLIP,
> +	.flags		= OV772X_FLAG_VFLIP | OV772X_FLAG_HFLIP | \
> +			  OV772X_FLAG_8BIT,
>  	.edgectrl	= OV772X_AUTO_EDGECTRL(0xf, 0),
>  };
>  
> diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
> index 507c77b..9b4676f 100644
> --- a/arch/sh/boards/mach-migor/setup.c
> +++ b/arch/sh/boards/mach-migor/setup.c
> @@ -431,7 +431,7 @@ static struct i2c_board_info migor_i2c_camera[] = {
>  };
>  
>  static struct ov772x_camera_info ov7725_info = {
> -	.buswidth	= SOCAM_DATAWIDTH_8,
> +	.flags		= OV772X_FLAG_8BIT,
>  };
>  
>  static struct soc_camera_link ov7725_link = {
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 3a45e94..12cb66f 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -547,7 +547,6 @@ static const struct v4l2_queryctrl ov772x_controls[] = {
>  	},
>  };
>  
> -
>  /*
>   * general function
>   */
> @@ -634,9 +633,18 @@ static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
>  	struct soc_camera_link *icl = to_soc_camera_link(icd);
>  	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
>  		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
> -		SOCAM_DATA_ACTIVE_HIGH | priv->info->buswidth;
> +		SOCAM_DATA_ACTIVE_HIGH;
> +
> +	if (priv->info->flags & OV772X_FLAG_8BIT)
> +		flags |= SOCAM_DATAWIDTH_8;
> +
> +	if (priv->info->flags & OV772X_FLAG_10BIT)
> +		flags |= SOCAM_DATAWIDTH_10;

At the moment ov7722's .set_bus_param() method does nothing and just 
returns success. To me this means, that it cannot dynamically switch 
between various bus configurations, also not using platform provided 
methods. Therefore the test, that the current driver version performs 
whether one and only one bus width flag is set in ov772x_video_probe() 
makes sense. With this patch you're removing that test below and now 
silently accepting any bus-width parameter configuration from the 
platform. Wouldn't a test like

	if (!is_power_of_2(priv->info->flags & (OV772X_FLAG_8BIT | OV772X_FLAG_10BIT)))
		return 0;

make sense here? Or even just modify your tests above to

	switch (priv->info->flags & (OV772X_FLAG_8BIT | OV772X_FLAG_10BIT)) {
	case OV772X_FLAG_8BIT:
		flags |= SOCAM_DATAWIDTH_8;
		break;
	case OV772X_FLAG_10BIT:
		flags |= SOCAM_DATAWIDTH_10;
		break;
	}

Adding a "default:" case just above the "case OV772X_FLAG_10BIT:" line 
would seem like a good idea to me too.

>  
> -	return soc_camera_apply_sensor_flags(icl, flags);
> +	if (flags & SOCAM_DATAWIDTH_MASK)
> +		return soc_camera_apply_sensor_flags(icl, flags);
> +
> +	return 0;

Why do you need this fail path? If any flags are missing the soc-camera 
core will catch that anyway.

>  }
>  
>  static int ov772x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> @@ -1040,15 +1048,6 @@ static int ov772x_video_probe(struct soc_camera_device *icd,
>  		return -ENODEV;
>  
>  	/*
> -	 * ov772x only use 8 or 10 bit bus width
> -	 */
> -	if (SOCAM_DATAWIDTH_10 != priv->info->buswidth &&
> -	    SOCAM_DATAWIDTH_8  != priv->info->buswidth) {
> -		dev_err(&client->dev, "bus width error\n");
> -		return -ENODEV;
> -	}

This is the test, that you're removing, that I meant above.

> -
> -	/*
>  	 * check and show product ID and manufacturer ID
>  	 */
>  	pid = i2c_smbus_read_byte_data(client, PID);
> @@ -1130,7 +1129,6 @@ static int ov772x_probe(struct i2c_client *client,
>  			const struct i2c_device_id *did)
>  {
>  	struct ov772x_priv        *priv;
> -	struct ov772x_camera_info *info;
>  	struct soc_camera_device  *icd = client->dev.platform_data;
>  	struct i2c_adapter        *adapter = to_i2c_adapter(client->dev.parent);
>  	struct soc_camera_link    *icl;
> @@ -1145,8 +1143,6 @@ static int ov772x_probe(struct i2c_client *client,
>  	if (!icl || !icl->priv)
>  		return -EINVAL;
>  
> -	info = icl->priv;
> -
>  	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
>  		dev_err(&adapter->dev,
>  			"I2C-Adapter doesn't support "
> @@ -1158,7 +1154,7 @@ static int ov772x_probe(struct i2c_client *client,
>  	if (!priv)
>  		return -ENOMEM;
>  
> -	priv->info = info;
> +	priv->info = icl->priv;
>  
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
>  
> diff --git a/include/media/ov772x.h b/include/media/ov772x.h
> index 14c77ef..7e83745 100644
> --- a/include/media/ov772x.h
> +++ b/include/media/ov772x.h
> @@ -15,8 +15,10 @@
>  #include <media/soc_camera.h>
>  
>  /* for flags */
> -#define OV772X_FLAG_VFLIP     0x00000001 /* Vertical flip image */
> -#define OV772X_FLAG_HFLIP     0x00000002 /* Horizontal flip image */
> +#define OV772X_FLAG_VFLIP	(1 << 0) /* Vertical flip image */
> +#define OV772X_FLAG_HFLIP	(1 << 1) /* Horizontal flip image */
> +#define OV772X_FLAG_8BIT	(1 << 2) /*  8bit buswidth */
> +#define OV772X_FLAG_10BIT	(1 << 3) /* 10bit buswidth */
>  
>  /*
>   * for Edge ctrl
> @@ -53,7 +55,6 @@ struct ov772x_edge_ctrl {
>   * ov772x camera info
>   */
>  struct ov772x_camera_info {
> -	unsigned long          buswidth;
>  	unsigned long          flags;
>  	struct ov772x_edge_ctrl edgectrl;
>  };

While at it, could you also replace spaces in the above indentation with 
TABs?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
