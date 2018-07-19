Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:32847 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbeGSIag (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 04:30:36 -0400
Date: Thu, 19 Jul 2018 09:47:36 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v4 2/3] media: ov772x: use SCCB regmap
Message-ID: <20180719074736.GA6784@w540>
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
 <1531756070-8560-3-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <1531756070-8560-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello Mita-San,
   thanks for keep pushing on this SCCB issue

Only one veryt minor nit, please see below..

On Tue, Jul 17, 2018 at 12:47:49AM +0900, Akinobu Mita wrote:
> Convert ov772x register access to use SCCB regmap.
>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Peter Rosin <peda@axentia.se>
> Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/i2c/Kconfig  |   1 +
>  drivers/media/i2c/ov772x.c | 192 +++++++++++++++++++--------------------------
>  2 files changed, 82 insertions(+), 111 deletions(-)
>
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 341452f..b923a51 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -715,6 +715,7 @@ config VIDEO_OV772X
>  	tristate "OmniVision OV772x sensor support"
>  	depends on I2C && VIDEO_V4L2
>  	depends on MEDIA_CAMERA_SUPPORT
> +	select REGMAP_SCCB
>  	---help---
>  	  This is a Video4Linux2 sensor-level driver for the OmniVision
>  	  OV772x camera.
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 7158c31..0d3ed23 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -21,6 +21,7 @@
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/regmap.h>
>  #include <linux/slab.h>
>  #include <linux/v4l2-mediabus.h>
>  #include <linux/videodev2.h>
> @@ -414,6 +415,7 @@ struct ov772x_priv {
>  	struct v4l2_subdev                subdev;
>  	struct v4l2_ctrl_handler	  hdl;
>  	struct clk			 *clk;
> +	struct regmap			 *regmap;
>  	struct ov772x_camera_info        *info;
>  	struct gpio_desc		 *pwdn_gpio;
>  	struct gpio_desc		 *rstb_gpio;
> @@ -549,51 +551,18 @@ static struct ov772x_priv *to_ov772x(struct v4l2_subdev *sd)
>  	return container_of(sd, struct ov772x_priv, subdev);
>  }
>
> -static int ov772x_read(struct i2c_client *client, u8 addr)
> -{
> -	int ret;
> -	u8 val;
> -
> -	ret = i2c_master_send(client, &addr, 1);
> -	if (ret < 0)
> -		return ret;
> -	ret = i2c_master_recv(client, &val, 1);
> -	if (ret < 0)
> -		return ret;
> -
> -	return val;
> -}
> -
> -static inline int ov772x_write(struct i2c_client *client, u8 addr, u8 value)
> -{
> -	return i2c_smbus_write_byte_data(client, addr, value);
> -}
> -
> -static int ov772x_mask_set(struct i2c_client *client, u8  command, u8  mask,
> -			   u8  set)
> -{
> -	s32 val = ov772x_read(client, command);
> -
> -	if (val < 0)
> -		return val;
> -
> -	val &= ~mask;
> -	val |= set & mask;
> -
> -	return ov772x_write(client, command, val);
> -}
> -

If I were you I would have kept these functions and wrapped the regmap
operations there. This is not an issue though if you prefer it this
way :)

> -static int ov772x_reset(struct i2c_client *client)
> +static int ov772x_reset(struct ov772x_priv *priv)
>  {
>  	int ret;
>
> -	ret = ov772x_write(client, COM7, SCCB_RESET);
> +	ret = regmap_write(priv->regmap, COM7, SCCB_RESET);
>  	if (ret < 0)
>  		return ret;
>
>  	usleep_range(1000, 5000);
>
> -	return ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, SOFT_SLEEP_MODE);
> +	return regmap_update_bits(priv->regmap, COM2, SOFT_SLEEP_MODE,
> +				  SOFT_SLEEP_MODE);
>  }
>
>  /*
> @@ -611,8 +580,8 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
>  	if (priv->streaming == enable)
>  		goto done;
>
> -	ret = ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE,
> -			      enable ? 0 : SOFT_SLEEP_MODE);
> +	ret = regmap_update_bits(priv->regmap, COM2, SOFT_SLEEP_MODE,
> +				 enable ? 0 : SOFT_SLEEP_MODE);
>  	if (ret)
>  		goto done;
>
> @@ -657,7 +626,6 @@ static int ov772x_set_frame_rate(struct ov772x_priv *priv,
>  				 const struct ov772x_color_format *cfmt,
>  				 const struct ov772x_win_size *win)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
>  	unsigned long fin = clk_get_rate(priv->clk);
>  	unsigned int best_diff;
>  	unsigned int fsize;
> @@ -723,11 +691,11 @@ static int ov772x_set_frame_rate(struct ov772x_priv *priv,
>  		}
>  	}
>
> -	ret = ov772x_write(client, COM4, com4 | COM4_RESERVED);
> +	ret = regmap_write(priv->regmap, COM4, com4 | COM4_RESERVED);
>  	if (ret < 0)
>  		return ret;
>
> -	ret = ov772x_write(client, CLKRC, clkrc | CLKRC_RESERVED);
> +	ret = regmap_write(priv->regmap, CLKRC, clkrc | CLKRC_RESERVED);
>  	if (ret < 0)
>  		return ret;
>
> @@ -788,8 +756,7 @@ static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct ov772x_priv *priv = container_of(ctrl->handler,
>  						struct ov772x_priv, hdl);
> -	struct v4l2_subdev *sd = &priv->subdev;
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct regmap *regmap = priv->regmap;
>  	int ret = 0;
>  	u8 val;
>
> @@ -808,27 +775,27 @@ static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
>  		val = ctrl->val ? VFLIP_IMG : 0x00;
>  		if (priv->info && (priv->info->flags & OV772X_FLAG_VFLIP))
>  			val ^= VFLIP_IMG;
> -		return ov772x_mask_set(client, COM3, VFLIP_IMG, val);
> +		return regmap_update_bits(regmap, COM3, VFLIP_IMG, val);
>  	case V4L2_CID_HFLIP:
>  		val = ctrl->val ? HFLIP_IMG : 0x00;
>  		if (priv->info && (priv->info->flags & OV772X_FLAG_HFLIP))
>  			val ^= HFLIP_IMG;
> -		return ov772x_mask_set(client, COM3, HFLIP_IMG, val);
> +		return regmap_update_bits(regmap, COM3, HFLIP_IMG, val);
>  	case V4L2_CID_BAND_STOP_FILTER:
>  		if (!ctrl->val) {
>  			/* Switch the filter off, it is on now */
> -			ret = ov772x_mask_set(client, BDBASE, 0xff, 0xff);
> +			ret = regmap_update_bits(regmap, BDBASE, 0xff, 0xff);
>  			if (!ret)
> -				ret = ov772x_mask_set(client, COM8,
> -						      BNDF_ON_OFF, 0);
> +				ret = regmap_update_bits(regmap, COM8,
> +							 BNDF_ON_OFF, 0);
>  		} else {
>  			/* Switch the filter on, set AEC low limit */
>  			val = 256 - ctrl->val;
> -			ret = ov772x_mask_set(client, COM8,
> -					      BNDF_ON_OFF, BNDF_ON_OFF);
> +			ret = regmap_update_bits(regmap, COM8,
> +						 BNDF_ON_OFF, BNDF_ON_OFF);
>  			if (!ret)
> -				ret = ov772x_mask_set(client, BDBASE,
> -						      0xff, val);
> +				ret = regmap_update_bits(regmap, BDBASE,
> +							 0xff, val);
>  		}
>
>  		return ret;
> @@ -841,18 +808,19 @@ static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
>  static int ov772x_g_register(struct v4l2_subdev *sd,
>  			     struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct ov772x_priv *priv = to_ov772x(sd);
>  	int ret;
> +	unsigned int val;

Nit: please keep variables sorted (move 'val' declaration one line
up).

Apart from that, for the ov772x driver:
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>

Thanks
   j

>
>  	reg->size = 1;
>  	if (reg->reg > 0xff)
>  		return -EINVAL;
>
> -	ret = ov772x_read(client, reg->reg);
> +	ret = regmap_read(priv->regmap, reg->reg, &val);
>  	if (ret < 0)
>  		return ret;
>
> -	reg->val = (__u64)ret;
> +	reg->val = (__u64)val;
>
>  	return 0;
>  }
> @@ -860,13 +828,13 @@ static int ov772x_g_register(struct v4l2_subdev *sd,
>  static int ov772x_s_register(struct v4l2_subdev *sd,
>  			     const struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct ov772x_priv *priv = to_ov772x(sd);
>
>  	if (reg->reg > 0xff ||
>  	    reg->val > 0xff)
>  		return -EINVAL;
>
> -	return ov772x_write(client, reg->reg, reg->val);
> +	return regmap_write(priv->regmap, reg->reg, reg->val);
>  }
>  #endif
>
> @@ -1004,7 +972,7 @@ static void ov772x_select_params(const struct v4l2_mbus_framefmt *mf,
>
>  static int ov772x_edgectrl(struct ov772x_priv *priv)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
> +	struct regmap *regmap = priv->regmap;
>  	int ret;
>
>  	if (!priv->info)
> @@ -1018,19 +986,19 @@ static int ov772x_edgectrl(struct ov772x_priv *priv)
>  		 * Remove it when manual mode.
>  		 */
>
> -		ret = ov772x_mask_set(client, DSPAUTO, EDGE_ACTRL, 0x00);
> +		ret = regmap_update_bits(regmap, DSPAUTO, EDGE_ACTRL, 0x00);
>  		if (ret < 0)
>  			return ret;
>
> -		ret = ov772x_mask_set(client,
> -				      EDGE_TRSHLD, OV772X_EDGE_THRESHOLD_MASK,
> -				      priv->info->edgectrl.threshold);
> +		ret = regmap_update_bits(regmap, EDGE_TRSHLD,
> +					 OV772X_EDGE_THRESHOLD_MASK,
> +					 priv->info->edgectrl.threshold);
>  		if (ret < 0)
>  			return ret;
>
> -		ret = ov772x_mask_set(client,
> -				      EDGE_STRNGT, OV772X_EDGE_STRENGTH_MASK,
> -				      priv->info->edgectrl.strength);
> +		ret = regmap_update_bits(regmap, EDGE_STRNGT,
> +					 OV772X_EDGE_STRENGTH_MASK,
> +					 priv->info->edgectrl.strength);
>  		if (ret < 0)
>  			return ret;
>
> @@ -1040,15 +1008,15 @@ static int ov772x_edgectrl(struct ov772x_priv *priv)
>  		 *
>  		 * Set upper and lower limit.
>  		 */
> -		ret = ov772x_mask_set(client,
> -				      EDGE_UPPER, OV772X_EDGE_UPPER_MASK,
> -				      priv->info->edgectrl.upper);
> +		ret = regmap_update_bits(regmap, EDGE_UPPER,
> +					 OV772X_EDGE_UPPER_MASK,
> +					 priv->info->edgectrl.upper);
>  		if (ret < 0)
>  			return ret;
>
> -		ret = ov772x_mask_set(client,
> -				      EDGE_LOWER, OV772X_EDGE_LOWER_MASK,
> -				      priv->info->edgectrl.lower);
> +		ret = regmap_update_bits(regmap, EDGE_LOWER,
> +					 OV772X_EDGE_LOWER_MASK,
> +					 priv->info->edgectrl.lower);
>  		if (ret < 0)
>  			return ret;
>  	}
> @@ -1060,12 +1028,11 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>  			     const struct ov772x_color_format *cfmt,
>  			     const struct ov772x_win_size *win)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
>  	int ret;
>  	u8  val;
>
>  	/* Reset hardware. */
> -	ov772x_reset(client);
> +	ov772x_reset(priv);
>
>  	/* Edge Ctrl. */
>  	ret = ov772x_edgectrl(priv);
> @@ -1073,32 +1040,32 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>  		return ret;
>
>  	/* Format and window size. */
> -	ret = ov772x_write(client, HSTART, win->rect.left >> 2);
> +	ret = regmap_write(priv->regmap, HSTART, win->rect.left >> 2);
>  	if (ret < 0)
>  		goto ov772x_set_fmt_error;
> -	ret = ov772x_write(client, HSIZE, win->rect.width >> 2);
> +	ret = regmap_write(priv->regmap, HSIZE, win->rect.width >> 2);
>  	if (ret < 0)
>  		goto ov772x_set_fmt_error;
> -	ret = ov772x_write(client, VSTART, win->rect.top >> 1);
> +	ret = regmap_write(priv->regmap, VSTART, win->rect.top >> 1);
>  	if (ret < 0)
>  		goto ov772x_set_fmt_error;
> -	ret = ov772x_write(client, VSIZE, win->rect.height >> 1);
> +	ret = regmap_write(priv->regmap, VSIZE, win->rect.height >> 1);
>  	if (ret < 0)
>  		goto ov772x_set_fmt_error;
> -	ret = ov772x_write(client, HOUTSIZE, win->rect.width >> 2);
> +	ret = regmap_write(priv->regmap, HOUTSIZE, win->rect.width >> 2);
>  	if (ret < 0)
>  		goto ov772x_set_fmt_error;
> -	ret = ov772x_write(client, VOUTSIZE, win->rect.height >> 1);
> +	ret = regmap_write(priv->regmap, VOUTSIZE, win->rect.height >> 1);
>  	if (ret < 0)
>  		goto ov772x_set_fmt_error;
> -	ret = ov772x_write(client, HREF,
> +	ret = regmap_write(priv->regmap, HREF,
>  			   ((win->rect.top & 1) << HREF_VSTART_SHIFT) |
>  			   ((win->rect.left & 3) << HREF_HSTART_SHIFT) |
>  			   ((win->rect.height & 1) << HREF_VSIZE_SHIFT) |
>  			   ((win->rect.width & 3) << HREF_HSIZE_SHIFT));
>  	if (ret < 0)
>  		goto ov772x_set_fmt_error;
> -	ret = ov772x_write(client, EXHCH,
> +	ret = regmap_write(priv->regmap, EXHCH,
>  			   ((win->rect.height & 1) << EXHCH_VSIZE_SHIFT) |
>  			   ((win->rect.width & 3) << EXHCH_HSIZE_SHIFT));
>  	if (ret < 0)
> @@ -1107,15 +1074,14 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>  	/* Set DSP_CTRL3. */
>  	val = cfmt->dsp3;
>  	if (val) {
> -		ret = ov772x_mask_set(client,
> -				      DSP_CTRL3, UV_MASK, val);
> +		ret = regmap_update_bits(priv->regmap, DSP_CTRL3, UV_MASK, val);
>  		if (ret < 0)
>  			goto ov772x_set_fmt_error;
>  	}
>
>  	/* DSP_CTRL4: AEC reference point and DSP output format. */
>  	if (cfmt->dsp4) {
> -		ret = ov772x_write(client, DSP_CTRL4, cfmt->dsp4);
> +		ret = regmap_write(priv->regmap, DSP_CTRL4, cfmt->dsp4);
>  		if (ret < 0)
>  			goto ov772x_set_fmt_error;
>  	}
> @@ -1131,13 +1097,12 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>  	if (priv->hflip_ctrl->val)
>  		val ^= HFLIP_IMG;
>
> -	ret = ov772x_mask_set(client,
> -			      COM3, SWAP_MASK | IMG_MASK, val);
> +	ret = regmap_update_bits(priv->regmap, COM3, SWAP_MASK | IMG_MASK, val);
>  	if (ret < 0)
>  		goto ov772x_set_fmt_error;
>
>  	/* COM7: Sensor resolution and output format control. */
> -	ret = ov772x_write(client, COM7, win->com7_bit | cfmt->com7);
> +	ret = regmap_write(priv->regmap, COM7, win->com7_bit | cfmt->com7);
>  	if (ret < 0)
>  		goto ov772x_set_fmt_error;
>
> @@ -1150,10 +1115,11 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>  	if (priv->band_filter_ctrl->val) {
>  		unsigned short band_filter = priv->band_filter_ctrl->val;
>
> -		ret = ov772x_mask_set(client, COM8, BNDF_ON_OFF, BNDF_ON_OFF);
> +		ret = regmap_update_bits(priv->regmap, COM8,
> +					 BNDF_ON_OFF, BNDF_ON_OFF);
>  		if (!ret)
> -			ret = ov772x_mask_set(client, BDBASE,
> -					      0xff, 256 - band_filter);
> +			ret = regmap_update_bits(priv->regmap, BDBASE,
> +						 0xff, 256 - band_filter);
>  		if (ret < 0)
>  			goto ov772x_set_fmt_error;
>  	}
> @@ -1162,7 +1128,7 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>
>  ov772x_set_fmt_error:
>
> -	ov772x_reset(client);
> +	ov772x_reset(priv);
>
>  	return ret;
>  }
> @@ -1276,12 +1242,12 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
>  		return ret;
>
>  	/* Check and show product ID and manufacturer ID. */
> -	pid = ov772x_read(client, PID);
> -	if (pid < 0)
> -		return pid;
> -	ver = ov772x_read(client, VER);
> -	if (ver < 0)
> -		return ver;
> +	ret = regmap_read(priv->regmap, PID, &pid);
> +	if (ret < 0)
> +		return ret;
> +	ret = regmap_read(priv->regmap, VER, &ver);
> +	if (ret < 0)
> +		return ret;
>
>  	switch (VERSION(pid, ver)) {
>  	case OV7720:
> @@ -1297,12 +1263,12 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
>  		goto done;
>  	}
>
> -	midh = ov772x_read(client, MIDH);
> -	if (midh < 0)
> -		return midh;
> -	midl = ov772x_read(client, MIDL);
> -	if (midl < 0)
> -		return midl;
> +	ret = regmap_read(priv->regmap, MIDH, &midh);
> +	if (ret < 0)
> +		return ret;
> +	ret = regmap_read(priv->regmap, MIDL, &midl);
> +	if (ret < 0)
> +		return ret;
>
>  	dev_info(&client->dev,
>  		 "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
> @@ -1386,8 +1352,12 @@ static int ov772x_probe(struct i2c_client *client,
>  			const struct i2c_device_id *did)
>  {
>  	struct ov772x_priv	*priv;
> -	struct i2c_adapter	*adapter = client->adapter;
>  	int			ret;
> +	static const struct regmap_config ov772x_regmap_config = {
> +		.reg_bits = 8,
> +		.val_bits = 8,
> +		.max_register = DSPAUTO,
> +	};
>
>  	if (!client->dev.of_node && !client->dev.platform_data) {
>  		dev_err(&client->dev,
> @@ -1395,16 +1365,16 @@ static int ov772x_probe(struct i2c_client *client,
>  		return -EINVAL;
>  	}
>
> -	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
> -		dev_err(&adapter->dev,
> -			"I2C-Adapter doesn't support SMBUS_BYTE_DATA\n");
> -		return -EIO;
> -	}
> -
>  	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
>
> +	priv->regmap = devm_regmap_init_sccb(client, &ov772x_regmap_config);
> +	if (IS_ERR(priv->regmap)) {
> +		dev_err(&client->dev, "Failed to allocate register map\n");
> +		return PTR_ERR(priv->regmap);
> +	}
> +
>  	priv->info = client->dev.platform_data;
>  	mutex_init(&priv->lock);
>
> --
> 2.7.4
>

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbUEIXAAoJEHI0Bo8WoVY8eYoP+gOhQlHYvI0god8DWiwV9O8K
uAf3Q+jEPIvzce3dyYjQV70EAf7JavoDIdfiQZl2GUkAC6sVHN+fFTDKE6NXr5m9
NFfOa1dY9HC/VqA3f0g9BO5pv7FQLPQHMSn38T7fXh0g2h28T2GLN4AQP5SjinLz
WlOj5tbnYKT3Vb56wKRP1swmGFstFllnzeooBLXmtYio871nXkvFx6eJ3wuEbSjY
NInpFfygGdofldnctg+ViEH7DTG4coCnvr00LEYUbdeUTmgSjYny2pASocD88g5Q
LOTkAr1420xe2f/9fuunR7qCM2E2pTB644uPA7MeFjRD8lm7m5JrpKobc8hf5Hmk
L/tdcaRKpK2foVtuz0vqIz1PFHA6nMQUikL9XIHx2A2n3ySraoRob81rkPpLFpPL
hovlVwYo6DF+jI5s7GXg9tJ84qBsXDUhsbAl2fFMbuqLDSW8Bx0bHMDsr2FQpS8a
tWKtDXmYyOekp7R4dzyKk1arJfGDCbT14/vIg3XKLoZHYDR0nSi5UXHSGl06k3RL
G+7/pc/QiJOqJYjnRtoMpi6YCbcbQDgqhu71QS1iOBVU9+C/dICEHhYt0aJX1nuz
RRmSuje12PSyzWZuYyEJE1JtL4MUIsGKEg4wz2sfeNn6UBgUEmUR7b8kOJTKzzSF
NtT95663Xm64IT7jBICk
=GVRK
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
