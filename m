Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37446 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753256AbdFPJQ4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 05:16:56 -0400
Date: Fri, 16 Jun 2017 12:16:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] ov6650: convert to standalone v4l2 subdevice
Message-ID: <20170616091621.GK12407@valkosipuli.retiisi.org.uk>
References: <20170615225243.12528-1-jmkrzyszt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170615225243.12528-1-jmkrzyszt@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Janusz,

Thanks for the patch. A few comments below.

On Fri, Jun 16, 2017 at 12:52:43AM +0200, Janusz Krzysztofik wrote:
> Remove the soc_camera dependencies.
> 
> Lost features, fortunately not used or not critical on test platform:
> - soc_camera power on/off callback - replaced with clock enable/disable
>   only, no support for platform provided regulators nor power callback,
> - soc_camera sense request - replaced with arbitrarily selected default
>   master clock rate and pixel clock limit, no support for platform
>   requested values,
> - soc_camera board flags - no support for platform requested mbus config
>   tweaks.
> 
> Created against linux-4.12-rc2.
> Tested on Amstrad Delta with now out of tree but still locally
> maintained omap1_camera host driver.
> 
> Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
> ---
>  drivers/media/i2c/soc_camera/ov6650.c | 75 ++++++++++-------------------------
>  1 file changed, 22 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
> index dbd6d92..20defcb88 100644
> --- a/drivers/media/i2c/soc_camera/ov6650.c
> +++ b/drivers/media/i2c/soc_camera/ov6650.c
> @@ -31,9 +31,9 @@
>  #include <linux/v4l2-mediabus.h>
>  #include <linux/module.h>
>  
> -#include <media/soc_camera.h>
>  #include <media/v4l2-clk.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
>  
>  /* Register definitions */
>  #define REG_GAIN		0x00	/* range 00 - 3F */
> @@ -426,10 +426,15 @@ static int ov6650_set_register(struct v4l2_subdev *sd,
>  static int ov6650_s_power(struct v4l2_subdev *sd, int on)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>  	struct ov6650 *priv = to_ov6650(client);
> +	int ret = 0;
>  
> -	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
> +	if (on)
> +		ret = v4l2_clk_enable(priv->clk);
> +	else
> +		v4l2_clk_disable(priv->clk);

It'd be nicer to use the clock framework. Although I'm certainly fine with
v4l2_clk for now, one thing at a time...

> +
> +	return ret;
>  }
>  
>  static int ov6650_get_selection(struct v4l2_subdev *sd,
> @@ -471,14 +476,13 @@ static int ov6650_set_selection(struct v4l2_subdev *sd,
>  	    sel->target != V4L2_SEL_TGT_CROP)
>  		return -EINVAL;
>  
> -	rect.left   = ALIGN(rect.left,   2);
> -	rect.width  = ALIGN(rect.width,  2);
> -	rect.top    = ALIGN(rect.top,    2);
> -	rect.height = ALIGN(rect.height, 2);
> -	soc_camera_limit_side(&rect.left, &rect.width,
> -			DEF_HSTRT << 1, 2, W_CIF);
> -	soc_camera_limit_side(&rect.top, &rect.height,
> -			DEF_VSTRT << 1, 2, H_CIF);
> +	v4l_bound_align_image(&rect.width, 2, W_CIF, 1,
> +			      &rect.height, 2, H_CIF, 1, 0);
> +	v4l_bound_align_image(&rect.left, DEF_HSTRT << 1,
> +			      (DEF_HSTRT << 1) + W_CIF - (__s32)rect.width, 1,
> +			      &rect.top, DEF_VSTRT << 1,
> +			      (DEF_VSTRT << 1) + H_CIF - (__s32)rect.height, 1,
> +			      0);
>  
>  	ret = ov6650_reg_write(client, REG_HSTRT, rect.left >> 1);
>  	if (!ret) {
> @@ -547,8 +551,6 @@ static u8 to_clkrc(struct v4l2_fract *timeperframe,
>  static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct soc_camera_device *icd = v4l2_get_subdev_hostdata(sd);
> -	struct soc_camera_sense *sense = icd->sense;
>  	struct ov6650 *priv = to_ov6650(client);
>  	bool half_scale = !is_unscaled_ok(mf->width, mf->height, &priv->rect);
>  	struct v4l2_subdev_selection sel = {
> @@ -640,32 +642,10 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
>  	}
>  	priv->half_scale = half_scale;
>  
> -	if (sense) {
> -		if (sense->master_clock == 8000000) {
> -			dev_dbg(&client->dev, "8MHz input clock\n");
> -			clkrc = CLKRC_6MHz;
> -		} else if (sense->master_clock == 12000000) {
> -			dev_dbg(&client->dev, "12MHz input clock\n");
> -			clkrc = CLKRC_12MHz;
> -		} else if (sense->master_clock == 16000000) {
> -			dev_dbg(&client->dev, "16MHz input clock\n");
> -			clkrc = CLKRC_16MHz;
> -		} else if (sense->master_clock == 24000000) {
> -			dev_dbg(&client->dev, "24MHz input clock\n");
> -			clkrc = CLKRC_24MHz;
> -		} else {
> -			dev_err(&client->dev,
> -				"unsupported input clock, check platform data\n");
> -			return -EINVAL;
> -		}
> -		mclk = sense->master_clock;
> -		priv->pclk_limit = sense->pixel_clock_max;
> -	} else {
> -		clkrc = CLKRC_24MHz;
> -		mclk = 24000000;
> -		priv->pclk_limit = 0;
> -		dev_dbg(&client->dev, "using default 24MHz input clock\n");
> -	}
> +	clkrc = CLKRC_12MHz;
> +	mclk = 12000000;
> +	priv->pclk_limit = 1334000;
> +	dev_dbg(&client->dev, "using 12MHz input clock\n");
>  
>  	clkrc |= to_clkrc(&priv->tpf, priv->pclk_limit, priv->pclk_max);
>  
> @@ -897,8 +877,6 @@ static const struct v4l2_subdev_core_ops ov6650_core_ops = {
>  static int ov6650_g_mbus_config(struct v4l2_subdev *sd,
>  				struct v4l2_mbus_config *cfg)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>  
>  	cfg->flags = V4L2_MBUS_MASTER |
>  		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
> @@ -906,7 +884,6 @@ static int ov6650_g_mbus_config(struct v4l2_subdev *sd,
>  		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW |
>  		V4L2_MBUS_DATA_ACTIVE_HIGH;
>  	cfg->type = V4L2_MBUS_PARALLEL;
> -	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
>  
>  	return 0;
>  }
> @@ -916,25 +893,23 @@ static int ov6650_s_mbus_config(struct v4l2_subdev *sd,
>  				const struct v4l2_mbus_config *cfg)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
> -	unsigned long flags = soc_camera_apply_board_flags(ssdd, cfg);
>  	int ret;
>  
> -	if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
> +	if (cfg->flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
>  		ret = ov6650_reg_rmw(client, REG_COMJ, COMJ_PCLK_RISING, 0);
>  	else
>  		ret = ov6650_reg_rmw(client, REG_COMJ, 0, COMJ_PCLK_RISING);
>  	if (ret)
>  		return ret;
>  
> -	if (flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
> +	if (cfg->flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
>  		ret = ov6650_reg_rmw(client, REG_COMF, COMF_HREF_LOW, 0);
>  	else
>  		ret = ov6650_reg_rmw(client, REG_COMF, 0, COMF_HREF_LOW);
>  	if (ret)
>  		return ret;
>  
> -	if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> +	if (cfg->flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
>  		ret = ov6650_reg_rmw(client, REG_COMJ, COMJ_VSYNC_HIGH, 0);
>  	else
>  		ret = ov6650_reg_rmw(client, REG_COMJ, 0, COMJ_VSYNC_HIGH);
> @@ -971,14 +946,8 @@ static int ov6650_probe(struct i2c_client *client,
>  			const struct i2c_device_id *did)
>  {
>  	struct ov6650 *priv;
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>  	int ret;
>  
> -	if (!ssdd) {
> -		dev_err(&client->dev, "Missing platform_data for driver\n");
> -		return -EINVAL;
> -	}
> -
>  	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv) {
>  		dev_err(&client->dev,

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
