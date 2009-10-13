Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54352 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933561AbZJMIGS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 04:06:18 -0400
Date: Tue, 13 Oct 2009 10:05:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/5] soc-camera: tw9910: Add output pin control.
In-Reply-To: <ueip7kfmg.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0910130940590.5089@axis700.grange>
References: <ueip7kfmg.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 13 Oct 2009, Kuninori Morimoto wrote:

> tw9910 can select output pin width and vs/hs pin feature.
> This patch add new flags definition to control it.
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/tw9910.c |   72 ++++++++++++++++--------------------------
>  include/media/tw9910.h       |   21 +++++++++++-
>  2 files changed, 47 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
> index 8bda689..bdabc9a 100644
> --- a/drivers/media/video/tw9910.c
> +++ b/drivers/media/video/tw9910.c
> @@ -201,12 +201,6 @@
>  /*
>   * structure
>   */
> -
> -struct regval_list {
> -	unsigned char reg_num;
> -	unsigned char value;
> -};
> -
>  struct tw9910_scale_ctrl {
>  	char           *name;
>  	unsigned short  width;
> @@ -229,18 +223,6 @@ struct tw9910_priv {
>  	int rev;
>  };
>  
> -/*
> - * register settings
> - */
> -
> -#define ENDMARKER { 0xff, 0xff }
> -
> -static const struct regval_list tw9910_default_regs[] =
> -{
> -	{ OUTCTR1, VSP_LO | VSSL_VVALID | HSP_HI | HSSL_HSYNC },
> -	ENDMARKER,
> -};
> -
>  static const struct soc_camera_data_format tw9910_color_fmt[] = {
>  	{
>  		.name       = "VYUY",
> @@ -442,20 +424,6 @@ static int tw9910_set_hsync(struct i2c_client *client,
>  	return ret;
>  }
>  
> -static int tw9910_write_array(struct i2c_client *client,
> -			      const struct regval_list *vals)
> -{
> -	while (vals->reg_num != 0xff) {
> -		int ret = i2c_smbus_write_byte_data(client,
> -						    vals->reg_num,
> -						    vals->value);
> -		if (ret < 0)
> -			return ret;
> -		vals++;
> -	}
> -	return 0;
> -}
> -
>  static int tw9910_mask_set(struct i2c_client *client, u8 command,
>  			   u8 mask, u8 set)
>  {
> @@ -469,6 +437,24 @@ static int tw9910_mask_set(struct i2c_client *client, u8 command,
>  	return i2c_smbus_write_byte_data(client, command, val);
>  }
>  
> +static int tw9910_set_outputcontrol(struct i2c_client *client)
> +{
> +	struct tw9910_priv *priv = to_tw9910(client);
> +	u32 flags = priv->info->flags;
> +	u8 val = 0;
> +
> +	if (flags & TW9910_FLG_VS_ACTIVE_HIGH)
> +		val |= (1 << 7);
> +
> +	if (flags & TW9910_FLG_HS_ACTIVE_HIGH)
> +		val |= (1 << 3);
> +
> +	val |= ((flags & TW9910_FLG_VS_MASK) >> TW9910_FLG_VS_SHIFT) << 4;
> +	val |= ((flags & TW9910_FLG_HS_MASK) >> TW9910_FLG_HS_SHIFT) << 0;
> +
> +	return tw9910_mask_set(client, OUTCTR1, 0xff, val);
> +}
> +
>  static void tw9910_reset(struct i2c_client *client)
>  {
>  	i2c_smbus_write_byte_data(client, ACNTL1, SRESET);
> @@ -513,7 +499,7 @@ static int tw9910_s_stream(struct v4l2_subdev *sd, int enable)
>  {
>  	struct i2c_client *client = sd->priv;
>  	struct tw9910_priv *priv = to_tw9910(client);
> -	u8 val;
> +	u8 val = OEN;
>  
>  	if (!enable) {
>  		switch (priv->rev) {
> @@ -556,7 +542,12 @@ static unsigned long tw9910_query_bus_param(struct soc_camera_device *icd)
>  	struct soc_camera_link *icl = to_soc_camera_link(icd);
>  	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
>  		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
> -		SOCAM_DATA_ACTIVE_HIGH | priv->info->buswidth;
> +		SOCAM_DATA_ACTIVE_HIGH;
> +
> +	if (TW9910_FLG_DATAWIDTH_16 & priv->info->flags)
> +		flags |= SOCAM_DATAWIDTH_16;
> +	else
> +		flags |= SOCAM_DATAWIDTH_8;
>  
>  	return soc_camera_apply_sensor_flags(icl, flags);
>  }
> @@ -648,7 +639,7 @@ static int tw9910_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	 * reset hardware
>  	 */
>  	tw9910_reset(client);
> -	ret = tw9910_write_array(client, tw9910_default_regs);
> +	ret = tw9910_set_outputcontrol(client);
>  	if (ret < 0)
>  		goto tw9910_set_fmt_error;
>  
> @@ -656,7 +647,7 @@ static int tw9910_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	 * set bus width
>  	 */
>  	val = 0x00;
> -	if (SOCAM_DATAWIDTH_16 == priv->info->buswidth)
> +	if (TW9910_FLG_DATAWIDTH_16 & priv->info->flags)
>  		val = LEN;
>  
>  	ret = tw9910_mask_set(client, OPFORM, LEN, val);
> @@ -888,15 +879,6 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
>  	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
>  		return -ENODEV;
>  
> -	/*
> -	 * tw9910 only use 8 or 16 bit bus width
> -	 */
> -	if (SOCAM_DATAWIDTH_16 != priv->info->buswidth &&
> -	    SOCAM_DATAWIDTH_8  != priv->info->buswidth) {
> -		dev_err(&client->dev, "bus width error\n");
> -		return -ENODEV;
> -	}
> -
>  	icd->formats     = tw9910_color_fmt;
>  	icd->num_formats = ARRAY_SIZE(tw9910_color_fmt);
>  
> diff --git a/include/media/tw9910.h b/include/media/tw9910.h
> index 6ddb654..494ac53 100644
> --- a/include/media/tw9910.h
> +++ b/include/media/tw9910.h
> @@ -18,6 +18,25 @@
>  
>  #include <media/soc_camera.h>
>  
> +#define TW9910_FLG_DATAWIDTH_16		(1 << 0) /* default 8 */
> +#define TW9910_FLG_VS_ACTIVE_HIGH	(1 << 1) /* default Low */
> +#define TW9910_FLG_HS_ACTIVE_HIGH	(1 << 2) /* default Low */
> +
> +#define TW9910_FLG_VS_SHIFT		(4)

No parenthesis needed around this one.

> +#define TW9910_FLG_VS_MASK		(0xF << TW9910_FLG_VS_SHIFT)
> +#define TW9910_FLG_VS_VSYNC		(0 << TW9910_FLG_VS_SHIFT)
> +#define TW9910_FLG_VS_VACT		(1 << TW9910_FLG_VS_SHIFT)
> +#define TW9910_FLG_VS_FIELD		(2 << TW9910_FLG_VS_SHIFT)
> +#define TW9910_FLG_VS_VVALID		(3 << TW9910_FLG_VS_SHIFT)
> +
> +#define TW9910_FLG_HS_SHIFT		(8)

Ditto.

> +#define TW9910_FLG_HS_MASK		(0xF << TW9910_FLG_HS_SHIFT)
> +#define TW9910_FLG_HS_HACT		(0 << TW9910_FLG_HS_SHIFT)
> +#define TW9910_FLG_HS_HSYNC		(1 << TW9910_FLG_HS_SHIFT)
> +#define TW9910_FLG_HS_DVALID		(2 << TW9910_FLG_HS_SHIFT)
> +#define TW9910_FLG_HS_HLOCK		(3 << TW9910_FLG_HS_SHIFT)
> +#define TW9910_FLG_HS_ASYNCW		(4 << TW9910_FLG_HS_SHIFT)
> +
>  enum tw9910_mpout_pin {
>  	TW9910_MPO_VLOSS,
>  	TW9910_MPO_HLOCK,
> @@ -30,7 +49,7 @@ enum tw9910_mpout_pin {
>  };
>  
>  struct tw9910_video_info {
> -	unsigned long          buswidth;
> +	u32          flags;
>  	enum tw9910_mpout_pin  mpout;
>  	struct soc_camera_link link;
>  	u16 start_offset;

Hm, I am not convinced I liked all this. Do we understand what these 
configuration options are doing? Datasheet is not very verbose on that 
occasion. Is this configuration really platform-specific? What values have 
you found meaningful in which cases?

> -- 
> 1.6.0.4

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
