Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33819 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaE1Lmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 07:42:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] [media] mt9v032: Add support for mt9v022 and mt9v024
Date: Wed, 28 May 2014 13:43:12 +0200
Message-ID: <1867770.8O19CuciQj@avalon>
In-Reply-To: <1401112985-32338-1-git-send-email-p.zabel@pengutronix.de>
References: <1401112985-32338-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Monday 26 May 2014 16:03:05 Philipp Zabel wrote:
> From the looks of it, mt9v022 and mt9v032 are very similar,
> as are mt9v024 and mt9v034. With minimal changes it is possible
> to support mt9v02[24] with the same driver.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/i2c/mt9v032.c | 56 ++++++++++++++++++++++++++++++------------
>  1 file changed, 42 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 052e754..617b77f 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -1,5 +1,5 @@
>  /*
> - * Driver for MT9V032 CMOS Image Sensor from Micron
> + * Driver for MT9V022, MT9V024, MT9V032, and MT9V034 CMOS Image Sensors
>   *
>   * Copyright (C) 2010, Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> *
> @@ -68,6 +68,7 @@
>  #define		MT9V032_CHIP_CONTROL_MASTER_MODE	(1 << 3)
>  #define		MT9V032_CHIP_CONTROL_DOUT_ENABLE	(1 << 7)
>  #define		MT9V032_CHIP_CONTROL_SEQUENTIAL		(1 << 8)
> +#define		MT9V024_CHIP_CONTROL_DEF_PIX_CORRECT	(1 << 9)
>  #define MT9V032_SHUTTER_WIDTH1				0x08
>  #define MT9V032_SHUTTER_WIDTH2				0x09
>  #define MT9V032_SHUTTER_WIDTH_CONTROL			0x0a
> @@ -133,8 +134,12 @@
>  #define MT9V032_THERMAL_INFO				0xc1
> 
>  enum mt9v032_model {
> -	MT9V032_MODEL_V032_COLOR,
> -	MT9V032_MODEL_V032_MONO,
> +	MT9V032_MODEL_V022_COLOR,	/* MT9V022IX7ATC */
> +	MT9V032_MODEL_V022_MONO,	/* MT9V022IX7ATM */
> +	MT9V032_MODEL_V024_COLOR,	/* MT9V024IA7XTC */
> +	MT9V032_MODEL_V024_MONO,	/* MT9V024IA7XTM */
> +	MT9V032_MODEL_V032_COLOR,	/* MT9V032C12STM */
> +	MT9V032_MODEL_V032_MONO,	/* MT9V032C12STC */
>  	MT9V032_MODEL_V034_COLOR,
>  	MT9V032_MODEL_V034_MONO,
>  };
> @@ -160,14 +165,14 @@ struct mt9v032_model_info {
>  };
> 
>  static const struct mt9v032_model_version mt9v032_versions[] = {
> -	{ MT9V032_CHIP_ID_REV1, "MT9V032 rev1/2" },
> -	{ MT9V032_CHIP_ID_REV3, "MT9V032 rev3" },
> -	{ MT9V034_CHIP_ID_REV1, "MT9V034 rev1" },
> +	{ MT9V032_CHIP_ID_REV1, "MT9V022/MT9V032 rev1/2" },
> +	{ MT9V032_CHIP_ID_REV3, "MT9V022/MT9V032 rev3" },
> +	{ MT9V034_CHIP_ID_REV1, "MT9V024/MT9V034 rev1" },
>  };
> 
>  static const struct mt9v032_model_data mt9v032_model_data[] = {
>  	{
> -		/* MT9V032 revisions 1/2/3 */
> +		/* MT9V022, MT9V032 revisions 1/2/3 */
>  		.min_row_time = 660,
>  		.min_hblank = MT9V032_HORIZONTAL_BLANKING_MIN,
>  		.min_vblank = MT9V032_VERTICAL_BLANKING_MIN,
> @@ -176,7 +181,7 @@ static const struct mt9v032_model_data
> mt9v032_model_data[] = { .max_shutter = MT9V032_TOTAL_SHUTTER_WIDTH_MAX,
>  		.pclk_reg = MT9V032_PIXEL_CLOCK,
>  	}, {
> -		/* MT9V034 */
> +		/* MT9V024, MT9V034 */
>  		.min_row_time = 690,
>  		.min_hblank = MT9V034_HORIZONTAL_BLANKING_MIN,
>  		.min_vblank = MT9V034_VERTICAL_BLANKING_MIN,
> @@ -188,6 +193,22 @@ static const struct mt9v032_model_data
> mt9v032_model_data[] = { };
> 
>  static const struct mt9v032_model_info mt9v032_models[] = {
> +	[MT9V032_MODEL_V022_COLOR] = {
> +		.data = &mt9v032_model_data[0],
> +		.color = true,
> +	},
> +	[MT9V032_MODEL_V022_MONO] = {
> +		.data = &mt9v032_model_data[0],
> +		.color = false,
> +	},
> +	[MT9V032_MODEL_V024_COLOR] = {
> +		.data = &mt9v032_model_data[1],
> +		.color = true,
> +	},
> +	[MT9V032_MODEL_V024_MONO] = {
> +		.data = &mt9v032_model_data[1],
> +		.color = false,
> +	},
>  	[MT9V032_MODEL_V032_COLOR] = {
>  		.data = &mt9v032_model_data[0],
>  		.color = true,
> @@ -415,7 +436,6 @@ static int mt9v032_s_stream(struct v4l2_subdev *subdev,
> int enable) struct i2c_client *client = v4l2_get_subdevdata(subdev);
>  	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
>  	struct v4l2_rect *crop = &mt9v032->crop;
> -	unsigned int read_mode;
>  	unsigned int hbin;
>  	unsigned int vbin;
>  	int ret;
> @@ -426,11 +446,9 @@ static int mt9v032_s_stream(struct v4l2_subdev *subdev,
> int enable) /* Configure the window size and row/column bin */
>  	hbin = fls(mt9v032->hratio) - 1;
>  	vbin = fls(mt9v032->vratio) - 1;
> -	read_mode = mt9v032_read(client, MT9V032_READ_MODE);
> -	read_mode &= ~0xff; /* bits 0x300 are reserved, on MT9V024 */
> -	read_mode |= hbin << MT9V032_READ_MODE_COLUMN_BIN_SHIFT |
> -		     vbin << MT9V032_READ_MODE_ROW_BIN_SHIFT;
> -	ret = mt9v032_write(client, MT9V032_READ_MODE, read_mode);
> +	ret = mt9v032_write(client, MT9V032_READ_MODE,
> +			    hbin << MT9V032_READ_MODE_COLUMN_BIN_SHIFT |
> +			    vbin << MT9V032_READ_MODE_ROW_BIN_SHIFT);

Doesn't this change completely reverse one of your previous patches ? Is it 
needed, or is it included here by mistake ?

>  	if (ret < 0)
>  		return ret;
> 
> @@ -902,6 +920,12 @@ static int mt9v032_probe(struct i2c_client *client,
>  	mt9v032->pdata = pdata;
>  	mt9v032->model = (const void *)did->driver_data;
> 
> +	/* Keep defective pixel correction enabled on MT9V024 */
> +	ret = mt9v032_read(client, MT9V032_CHIP_CONTROL);
> +	if (ret < 0)
> +		return ret;
> +	mt9v032->chip_control = ret & MT9V024_CHIP_CONTROL_DEF_PIX_CORRECT;

On the MT9V034 bit 9 is marked as reserved according to revision A of the 
datasheet, defaults to 1 after power-up and must be written to 0 for proper 
operation. This could thus break operation on the MT9V034. I don't have a copy 
of the MT9V022 register reference manual to check what happens on that chip 
though.

> +
>  	v4l2_ctrl_handler_init(&mt9v032->ctrls, 10);
> 
>  	v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
> @@ -1015,6 +1039,10 @@ static int mt9v032_remove(struct i2c_client *client)
>  }
> 
>  static const struct i2c_device_id mt9v032_id[] = {
> +	{ "mt9v022", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V022_COLOR] },
> +	{ "mt9v022m", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V022_MONO] },
> +	{ "mt9v024", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V024_COLOR] },
> +	{ "mt9v024m", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V024_MONO] },
>  	{ "mt9v032", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V032_COLOR] },
>  	{ "mt9v032m", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V032_MONO] },
>  	{ "mt9v034", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V034_COLOR] },

-- 
Regards,

Laurent Pinchart

