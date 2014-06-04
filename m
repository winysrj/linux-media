Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56524 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaFDPnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 11:43:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v2 5/5] [media] mt9v032: use regmap
Date: Wed, 04 Jun 2014 17:44:04 +0200
Message-ID: <2116541.LBf4Vp52ig@avalon>
In-Reply-To: <1401788155-3690-6-git-send-email-p.zabel@pengutronix.de>
References: <1401788155-3690-1-git-send-email-p.zabel@pengutronix.de> <1401788155-3690-6-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Tuesday 03 June 2014 11:35:55 Philipp Zabel wrote:
> This switches all register accesses to use regmap. It allows to
> use the regmap cache, tracing, and debug register dump facilities,
> and removes the need to open code read-modify-writes.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

This looks good to me, but I have two small questions:

- How does regmap handle endianness ? It seems to hardcode a big endian byte 
order, which is fortunately what we need here. I suppose you've successfully 
tested this patch :-)

- How does regmap handle the register cache ? Will it try to populate it when 
initialized, or will it only read registers on demand due to a read or an 
update bits operation ?

> ---
> This patch was not included before.
> ---
>  drivers/media/i2c/Kconfig   |   1 +
>  drivers/media/i2c/mt9v032.c | 112 +++++++++++++++++------------------------
>  2 files changed, 46 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 441053b..f40b4cf 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -551,6 +551,7 @@ config VIDEO_MT9V032
>  	tristate "Micron MT9V032 sensor support"
>  	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>  	depends on MEDIA_CAMERA_SUPPORT
> +	select REGMAP_I2C
>  	---help---
>  	  This is a Video4Linux2 sensor-level driver for the Micron
>  	  MT9V032 752x480 CMOS sensor.
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index cb7c6df..e756d50 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -17,6 +17,7 @@
>  #include <linux/i2c.h>
>  #include <linux/log2.h>
>  #include <linux/mutex.h>
> +#include <linux/regmap.h>
>  #include <linux/slab.h>
>  #include <linux/videodev2.h>
>  #include <linux/v4l2-mediabus.h>
> @@ -245,6 +246,7 @@ struct mt9v032 {
>  	struct mutex power_lock;
>  	int power_count;
> 
> +	struct regmap *regmap;
>  	struct clk *clk;
> 
>  	struct mt9v032_platform_data *pdata;
> @@ -252,7 +254,6 @@ struct mt9v032 {
>  	const struct mt9v032_model_version *version;
> 
>  	u32 sysclk;
> -	u16 chip_control;
>  	u16 aec_agc;
>  	u16 hblank;
>  	struct {
> @@ -266,40 +267,10 @@ static struct mt9v032 *to_mt9v032(struct v4l2_subdev
> *sd) return container_of(sd, struct mt9v032, subdev);
>  }
> 
> -static int mt9v032_read(struct i2c_client *client, const u8 reg)
> -{
> -	s32 data = i2c_smbus_read_word_swapped(client, reg);
> -	dev_dbg(&client->dev, "%s: read 0x%04x from 0x%02x\n", __func__,
> -		data, reg);
> -	return data;
> -}
> -
> -static int mt9v032_write(struct i2c_client *client, const u8 reg,
> -			 const u16 data)
> -{
> -	dev_dbg(&client->dev, "%s: writing 0x%04x to 0x%02x\n", __func__,
> -		data, reg);
> -	return i2c_smbus_write_word_swapped(client, reg, data);
> -}
> -
> -static int mt9v032_set_chip_control(struct mt9v032 *mt9v032, u16 clear, u16
> set) -{
> -	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
> -	u16 value = (mt9v032->chip_control & ~clear) | set;
> -	int ret;
> -
> -	ret = mt9v032_write(client, MT9V032_CHIP_CONTROL, value);
> -	if (ret < 0)
> -		return ret;
> -
> -	mt9v032->chip_control = value;
> -	return 0;
> -}
> -
>  static int
>  mt9v032_update_aec_agc(struct mt9v032 *mt9v032, u16 which, int enable)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
> +	struct regmap *map = mt9v032->regmap;
>  	u16 value = mt9v032->aec_agc;
>  	int ret;
> 
> @@ -308,7 +279,7 @@ mt9v032_update_aec_agc(struct mt9v032 *mt9v032, u16
> which, int enable) else
>  		value &= ~which;
> 
> -	ret = mt9v032_write(client, MT9V032_AEC_AGC_ENABLE, value);
> +	ret = regmap_write(map, MT9V032_AEC_AGC_ENABLE, value);
>  	if (ret < 0)
>  		return ret;
> 
> @@ -319,7 +290,6 @@ mt9v032_update_aec_agc(struct mt9v032 *mt9v032, u16
> which, int enable) static int
>  mt9v032_update_hblank(struct mt9v032 *mt9v032)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
>  	struct v4l2_rect *crop = &mt9v032->crop;
>  	unsigned int min_hblank = mt9v032->model->data->min_hblank;
>  	unsigned int hblank;
> @@ -330,12 +300,13 @@ mt9v032_update_hblank(struct mt9v032 *mt9v032)
>  			   min_hblank);
>  	hblank = max_t(unsigned int, mt9v032->hblank, min_hblank);
> 
> -	return mt9v032_write(client, MT9V032_HORIZONTAL_BLANKING, hblank);
> +	return regmap_write(mt9v032->regmap, MT9V032_HORIZONTAL_BLANKING,
> +			    hblank);
>  }
> 
>  static int mt9v032_power_on(struct mt9v032 *mt9v032)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
> +	struct regmap *map = mt9v032->regmap;
>  	unsigned long rate;
>  	int ret;
> 
> @@ -350,7 +321,7 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
>  	udelay(1);
> 
>  	/* Reset the chip and stop data read out */
> -	ret = mt9v032_write(client, MT9V032_RESET, 1);
> +	ret = regmap_write(map, MT9V032_RESET, 1);
>  	if (ret < 0)
>  		return ret;
> 
> @@ -358,7 +329,7 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
>  	rate = clk_get_rate(mt9v032->clk);
>  	ndelay(DIV_ROUND_UP(15 * 125000000, rate >> 3));
> 
> -	return mt9v032_write(client, MT9V032_CHIP_CONTROL, 0);
> +	return regmap_write(map, MT9V032_CHIP_CONTROL, 0);
>  }
> 
>  static void mt9v032_power_off(struct mt9v032 *mt9v032)
> @@ -368,7 +339,7 @@ static void mt9v032_power_off(struct mt9v032 *mt9v032)
> 
>  static int __mt9v032_set_power(struct mt9v032 *mt9v032, bool on)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
> +	struct regmap *map = mt9v032->regmap;
>  	int ret;
> 
>  	if (!on) {
> @@ -382,14 +353,14 @@ static int __mt9v032_set_power(struct mt9v032
> *mt9v032, bool on)
> 
>  	/* Configure the pixel clock polarity */
>  	if (mt9v032->pdata && mt9v032->pdata->clk_pol) {
> -		ret = mt9v032_write(client, mt9v032->model->data->pclk_reg,
> +		ret = regmap_write(map, mt9v032->model->data->pclk_reg,
>  				MT9V032_PIXEL_CLOCK_INV_PXL_CLK);
>  		if (ret < 0)
>  			return ret;
>  	}
> 
>  	/* Disable the noise correction algorithm and restore the controls. */
> -	ret = mt9v032_write(client, MT9V032_ROW_NOISE_CORR_CONTROL, 0);
> +	ret = regmap_write(map, MT9V032_ROW_NOISE_CORR_CONTROL, 0);
>  	if (ret < 0)
>  		return ret;
> 
> @@ -433,43 +404,39 @@ static int mt9v032_s_stream(struct v4l2_subdev
> *subdev, int enable) const u16 mode = MT9V032_CHIP_CONTROL_MASTER_MODE
> 
>  		       | MT9V032_CHIP_CONTROL_DOUT_ENABLE
>  		       | MT9V032_CHIP_CONTROL_SEQUENTIAL;
> 
> -	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>  	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
>  	struct v4l2_rect *crop = &mt9v032->crop;
> -	unsigned int read_mode;
> +	struct regmap *map = mt9v032->regmap;
>  	unsigned int hbin;
>  	unsigned int vbin;
>  	int ret;
> 
>  	if (!enable)
> -		return mt9v032_set_chip_control(mt9v032, mode, 0);
> +		return regmap_update_bits(map, MT9V032_CHIP_CONTROL, mode, 0);
> 
>  	/* Configure the window size and row/column bin */
>  	hbin = fls(mt9v032->hratio) - 1;
>  	vbin = fls(mt9v032->vratio) - 1;
> -	read_mode = mt9v032_read(client, MT9V032_READ_MODE);
> -	if (read_mode < 0)
> -		return read_mode;
> -	read_mode &= MT9V032_READ_MODE_RESERVED;
> -	read_mode |= hbin << MT9V032_READ_MODE_COLUMN_BIN_SHIFT |
> -		     vbin << MT9V032_READ_MODE_ROW_BIN_SHIFT;
> -	ret = mt9v032_write(client, MT9V032_READ_MODE, read_mode);
> +	ret = regmap_update_bits(map, MT9V032_READ_MODE,
> +				 ~MT9V032_READ_MODE_RESERVED,
> +				 hbin << MT9V032_READ_MODE_COLUMN_BIN_SHIFT |
> +				 vbin << MT9V032_READ_MODE_ROW_BIN_SHIFT);
>  	if (ret < 0)
>  		return ret;
> 
> -	ret = mt9v032_write(client, MT9V032_COLUMN_START, crop->left);
> +	ret = regmap_write(map, MT9V032_COLUMN_START, crop->left);
>  	if (ret < 0)
>  		return ret;
> 
> -	ret = mt9v032_write(client, MT9V032_ROW_START, crop->top);
> +	ret = regmap_write(map, MT9V032_ROW_START, crop->top);
>  	if (ret < 0)
>  		return ret;
> 
> -	ret = mt9v032_write(client, MT9V032_WINDOW_WIDTH, crop->width);
> +	ret = regmap_write(map, MT9V032_WINDOW_WIDTH, crop->width);
>  	if (ret < 0)
>  		return ret;
> 
> -	ret = mt9v032_write(client, MT9V032_WINDOW_HEIGHT, crop->height);
> +	ret = regmap_write(map, MT9V032_WINDOW_HEIGHT, crop->height);
>  	if (ret < 0)
>  		return ret;
> 
> @@ -478,7 +445,7 @@ static int mt9v032_s_stream(struct v4l2_subdev *subdev,
> int enable) return ret;
> 
>  	/* Switch to master "normal" mode */
> -	return mt9v032_set_chip_control(mt9v032, 0, mode);
> +	return regmap_update_bits(map, MT9V032_CHIP_CONTROL, mode, mode);
>  }
> 
>  static int mt9v032_enum_mbus_code(struct v4l2_subdev *subdev,
> @@ -660,7 +627,7 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct mt9v032 *mt9v032 =
>  			container_of(ctrl->handler, struct mt9v032, ctrls);
> -	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
> +	struct regmap *map = mt9v032->regmap;
>  	u32 freq;
>  	u16 data;
> 
> @@ -670,23 +637,23 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
>  					      ctrl->val);
> 
>  	case V4L2_CID_GAIN:
> -		return mt9v032_write(client, MT9V032_ANALOG_GAIN, ctrl->val);
> +		return regmap_write(map, MT9V032_ANALOG_GAIN, ctrl->val);
> 
>  	case V4L2_CID_EXPOSURE_AUTO:
>  		return mt9v032_update_aec_agc(mt9v032, MT9V032_AEC_ENABLE,
>  					      !ctrl->val);
> 
>  	case V4L2_CID_EXPOSURE:
> -		return mt9v032_write(client, MT9V032_TOTAL_SHUTTER_WIDTH,
> -				     ctrl->val);
> +		return regmap_write(map, MT9V032_TOTAL_SHUTTER_WIDTH,
> +				    ctrl->val);
> 
>  	case V4L2_CID_HBLANK:
>  		mt9v032->hblank = ctrl->val;
>  		return mt9v032_update_hblank(mt9v032);
> 
>  	case V4L2_CID_VBLANK:
> -		return mt9v032_write(client, MT9V032_VERTICAL_BLANKING,
> -				     ctrl->val);
> +		return regmap_write(map, MT9V032_VERTICAL_BLANKING,
> +				    ctrl->val);
> 
>  	case V4L2_CID_PIXEL_RATE:
>  	case V4L2_CID_LINK_FREQ:
> @@ -723,7 +690,7 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
> 
>  			     | MT9V032_TEST_PATTERN_FLIP;
> 
>  			break;
>  		}
> -		return mt9v032_write(client, MT9V032_TEST_PATTERN, data);
> +		return regmap_write(map, MT9V032_TEST_PATTERN, data);
>  	}
> 
>  	return 0;
> @@ -791,7 +758,7 @@ static int mt9v032_registered(struct v4l2_subdev
> *subdev) struct i2c_client *client = v4l2_get_subdevdata(subdev);
>  	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
>  	unsigned int i;
> -	s32 version;
> +	u32 version;
>  	int ret;
> 
>  	dev_info(&client->dev, "Probing MT9V032 at address 0x%02x\n",
> @@ -804,10 +771,10 @@ static int mt9v032_registered(struct v4l2_subdev
> *subdev) }
> 
>  	/* Read and check the sensor version */
> -	version = mt9v032_read(client, MT9V032_CHIP_VERSION);
> -	if (version < 0) {
> +	ret = regmap_read(mt9v032->regmap, MT9V032_CHIP_VERSION, &version);
> +	if (ret < 0) {
>  		dev_err(&client->dev, "Failed reading chip version\n");
> -		return version;
> +		return ret;
>  	}
> 
>  	for (i = 0; i < ARRAY_SIZE(mt9v032_versions); ++i) {
> @@ -894,6 +861,13 @@ static const struct v4l2_subdev_internal_ops
> mt9v032_subdev_internal_ops = { .close = mt9v032_close,
>  };
> 
> +static const struct regmap_config mt9v032_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 16,
> +	.max_register = 0xff,
> +	.cache_type = REGCACHE_RBTREE,
> +};
> +
>  /*
> ---------------------------------------------------------------------------
> -- * Driver initialization and probing
>   */
> @@ -917,6 +891,10 @@ static int mt9v032_probe(struct i2c_client *client,
>  	if (!mt9v032)
>  		return -ENOMEM;
> 
> +	mt9v032->regmap = devm_regmap_init_i2c(client, &mt9v032_regmap_config);
> +	if (IS_ERR(mt9v032->regmap))
> +		return PTR_ERR(mt9v032->regmap);
> +
>  	mt9v032->clk = devm_clk_get(&client->dev, NULL);
>  	if (IS_ERR(mt9v032->clk))
>  		return PTR_ERR(mt9v032->clk);

-- 
Regards,

Laurent Pinchart

