Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42656 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753438AbZASHyn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 02:54:43 -0500
Date: Mon, 19 Jan 2009 08:54:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ov772x: Add image flip support
In-Reply-To: <u63kbpxm9.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0901190844330.4142@axis700.grange>
References: <u63kbpxm9.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 19 Jan 2009, Kuninori Morimoto wrote:

> o ov772x_camera_info :: flags supports default image flip.
> o V4L2_CID_VFLIP/HFLIP supports image flip on user side.
> Thank Magnus for advice.
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/ov772x.c |   97 ++++++++++++++++++++++++++++++++++++++++--
>  include/media/ov772x.h       |    5 ++
>  2 files changed, 98 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 3341857..ca0cf3c 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -218,9 +218,10 @@
>  
>  /* COM3 */
>  #define SWAP_MASK       0x38
> +#define IMG_MASK        0xC0
>  
> -#define VFIMG_ON_OFF    0x80	/* Vertical flip image ON/OFF selection */
> -#define HMIMG_ON_OFF    0x40	/* Horizontal mirror image ON/OFF selection */
> +#define VFLIP_IMG       0x80	/* Vertical flip image ON/OFF selection */
> +#define HFLIP_IMG       0x40	/* Horizontal mirror image ON/OFF selection */
>  #define SWAP_RGB        0x20	/* Swap B/R  output sequence in RGB mode */
>  #define SWAP_YUV        0x10	/* Swap Y/UV output sequence in YUV mode */
>  #define SWAP_ML         0x08	/* Swap output MSB/LSB */

Please, put SWAP_MASK and IMG_MASK below single bit defines and define 
them as

#define SWAP_MASK	(SWAP_RGB | SWAP_YUV | SWAP_ML)
#define IMG_MASK	(VFLIP_IMG | HFLIP_IMG)

> @@ -540,6 +541,27 @@ static const struct ov772x_win_size ov772x_win_qvga = {
>  	.regs     = ov772x_qvga_regs,
>  };
>  
> +static const struct v4l2_queryctrl ov772x_controls[] = {
> +	{
> +		.id		= V4L2_CID_VFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Vertically",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	},
> +	{
> +		.id		= V4L2_CID_HFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Horizontally",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	},
> +};
> +
>  
>  /*
>   * general function
> @@ -650,6 +672,60 @@ static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
>  	return soc_camera_apply_sensor_flags(icl, flags);
>  }
>  
> +static int ov772x_get_control(struct soc_camera_device *icd,
> +			      struct v4l2_control *ctrl)
> +{
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +	s32 val;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_VFLIP:
> +		val = i2c_smbus_read_byte_data(priv->client, COM3);
> +		if (val < 0)
> +			return val;
> +		if (priv->info->flags & OV772X_FLAG_VFLIP)
> +			val ^= VFLIP_IMG;
> +		val &= VFLIP_IMG;
> +		ctrl->value = !!val;
> +		break;
> +	case V4L2_CID_HFLIP:
> +		val = i2c_smbus_read_byte_data(priv->client, COM3);
> +		if (val < 0)
> +			return val;
> +		if (priv->info->flags & OV772X_FLAG_HFLIP)
> +			val ^= HFLIP_IMG;
> +		val &= HFLIP_IMG;
> +		ctrl->value = !!val;
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int ov772x_set_control(struct soc_camera_device *icd,
> +			      struct v4l2_control *ctrl)
> +{
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +	int ret = 0;
> +	u8 val;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_VFLIP:
> +		val = (ctrl->value) ? VFLIP_IMG : 0x00;

Superfluous parenthesis

> +		if (priv->info->flags & OV772X_FLAG_VFLIP)
> +			val ^= VFLIP_IMG;
> +		ret = ov772x_mask_set(priv->client, COM3, VFLIP_IMG, val);
> +		break;
> +	case V4L2_CID_HFLIP:
> +		val = (ctrl->value) ? HFLIP_IMG : 0x00;

ditto

> +		if (priv->info->flags & OV772X_FLAG_HFLIP)
> +			val ^= HFLIP_IMG;
> +		ret = ov772x_mask_set(priv->client, COM3, HFLIP_IMG, val);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  static int ov772x_get_chip_id(struct soc_camera_device *icd,
>  			      struct v4l2_dbg_chip_ident   *id)
>  {
> @@ -720,7 +796,7 @@ static int ov772x_set_fmt(struct soc_camera_device *icd,
>  {
>  	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
>  	int ret = -EINVAL;
> -	u8  val;
> +	u8  val, mask;
>  	int i;
>  
>  	/*
> @@ -768,8 +844,17 @@ static int ov772x_set_fmt(struct soc_camera_device *icd,
>  	 * set COM3
>  	 */
>  	val = priv->fmt->com3;
> +	if (priv->info->flags & OV772X_FLAG_VFLIP)
> +		val |= VFLIP_IMG;
> +	if (priv->info->flags & OV772X_FLAG_HFLIP)
> +		val |= HFLIP_IMG;
> +
> +	mask = SWAP_MASK;
> +	if (IMG_MASK & val)
> +		mask |= IMG_MASK;
> +
>  	ret = ov772x_mask_set(priv->client,
> -			      COM3, SWAP_MASK, val);
> +			      COM3, mask, val);

Do I understand it right, that this throws away any flip control settings 
performed before S_FMT? You probably want to set priv->fmt->com3 in your 
set_control and XOR instead of an OR here as well. Or was this 
intentional?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
