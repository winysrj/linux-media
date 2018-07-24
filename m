Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:57912 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388554AbeGXP3I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 11:29:08 -0400
Date: Tue, 24 Jul 2018 17:22:22 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Luca Ceresoli <luca@lucaceresoli.net>
Cc: linux-media@vger.kernel.org, Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] media: imx274: add cropping support via SELECTION
 API
Message-ID: <20180724142222.zhiq4iqskiex6tuf@paasikivi.fi.intel.com>
References: <1530801489-29953-1-git-send-email-luca@lucaceresoli.net>
 <1530801489-29953-3-git-send-email-luca@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530801489-29953-3-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luca,

On Thu, Jul 05, 2018 at 04:38:09PM +0200, Luca Ceresoli wrote:
> Currently this driver does not support cropping. The supported modes
> are the following, all capturing the entire area:
> 
>  - 3840x2160, 1:1 binning (native sensor resolution)
>  - 1920x1080, 2:1 binning
>  - 1280x720,  3:1 binning
> 
> The VIDIOC_SUBDEV_S_FMT ioctl chooses among these 3 configurations the
> one that matches the requested format.
> 
> Add cropping support via VIDIOC_SUBDEV_S_SELECTION: with target
> V4L2_SEL_TGT_CROP to choose the captured area, with
> V4L2_SEL_TGT_COMPOSE to choose the output resolution.
> 
> To maintain backward compatibility we also allow setting the compose
> format via VIDIOC_SUBDEV_S_FMT. To obtain this, compose rect and
> output format are computed in the common helper function
> __imx274_change_compose(), which sets both to the same width/height
> values.
> 
> Cropping also calls __imx274_change_compose() whenever cropping rect
> size changes in order to reset the compose rect (and output format
> size) for 1:1 binning.
> 
> Also rename enum imx274_mode to imx274_binning (and its values from
> IMX274_MODE_BINNING_* to IMX274_BINNING_*). Without cropping, the two
> naming are equivalent. With cropping, the resolution could be
> different, e.g. using 2:1 binning mode to crop 1200x960 and output a
> 600x480 format. Using binning in the names avoids any
> misunderstanding. For the same reason, replace the 'size' field in
> struct imx274_frmfmt with 'bin_ratio'.
> 
> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> ---
> Changed v4 -> v5:
>  - use imx274_write_mbreg, not prepare_reg (it doesn't exist in v5)
>  - order #includes alphabetically (Sakari)
>  - rename imx274_mode to imx274_binning and
>    IMX274_MODE_BINNING_* to IMX274_BINNING_* (Sakari)
>  - fix doc syntax (Sakari)
>  - remove debug prints that should not be in individual drivers (Sakari)
>  - honor the GE/LE selection flags (algorithm inspired to smiapp) (Sakari)
>  - remove the compose rect from struct stimx274; it duplicates info
>    that we already store in stimx274.format
>  - minor cleanups
> 
> Changed v3 -> v4:
>  - Set the binning via the SELECTION API (COMPOSE rect), but still
>    allow using VIDIOC_SUBDEV_S_FMT for backward compatibility.
>  - rename imx274_set_trimming -> imx274_apply_trimming for clarity
> 
> Changed v2 -> v3:
>  - Remove hard-coded HMAX reg setting from all modes, not only the
>    first one. HMAX is always computed and set in s_stream now.
>  - Reword commit log message.
> 
> Changed v1 -> v2:
>  - add "media: " prefix to commit message
> ---
>  drivers/media/i2c/imx274.c | 466 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 375 insertions(+), 91 deletions(-)
> 
> diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
> index 6e24479c4344..0388800af943 100644
> --- a/drivers/media/i2c/imx274.c
> +++ b/drivers/media/i2c/imx274.c
> @@ -5,6 +5,7 @@
>   *
>   * Leon Luo <leonl@leopardimaging.com>
>   * Edwin Zou <edwinz@leopardimaging.com>
> + * Luca Ceresoli <luca@lucaceresoli.net>
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms and conditions of the GNU General Public License,
> @@ -25,6 +26,7 @@
>  #include <linux/gpio/consumer.h>
>  #include <linux/i2c.h>
>  #include <linux/init.h>
> +#include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/of_gpio.h>
>  #include <linux/regmap.h>
> @@ -74,7 +76,7 @@
>   */
>  #define IMX274_MIN_EXPOSURE_TIME		(4 * 260 / 72)
>  
> -#define IMX274_DEFAULT_MODE			IMX274_MODE_3840X2160
> +#define IMX274_DEFAULT_MODE			IMX274_BINNING_OFF
>  #define IMX274_MAX_WIDTH			(3840)
>  #define IMX274_MAX_HEIGHT			(2160)
>  #define IMX274_MAX_FRAME_RATE			(120)
> @@ -111,6 +113,20 @@
>  #define IMX274_SHR_REG_LSB			0x300C /* SHR */
>  #define IMX274_SVR_REG_MSB			0x300F /* SVR */
>  #define IMX274_SVR_REG_LSB			0x300E /* SVR */
> +#define IMX274_HTRIM_EN_REG			0x3037
> +#define IMX274_HTRIM_START_REG_LSB		0x3038
> +#define IMX274_HTRIM_START_REG_MSB		0x3039
> +#define IMX274_HTRIM_END_REG_LSB		0x303A
> +#define IMX274_HTRIM_END_REG_MSB		0x303B
> +#define IMX274_VWIDCUTEN_REG			0x30DD
> +#define IMX274_VWIDCUT_REG_LSB			0x30DE
> +#define IMX274_VWIDCUT_REG_MSB			0x30DF
> +#define IMX274_VWINPOS_REG_LSB			0x30E0
> +#define IMX274_VWINPOS_REG_MSB			0x30E1
> +#define IMX274_WRITE_VSIZE_REG_LSB		0x3130
> +#define IMX274_WRITE_VSIZE_REG_MSB		0x3131
> +#define IMX274_Y_OUT_SIZE_REG_LSB		0x3132
> +#define IMX274_Y_OUT_SIZE_REG_MSB		0x3133
>  #define IMX274_VMAX_REG_1			0x30FA /* VMAX, MSB */
>  #define IMX274_VMAX_REG_2			0x30F9 /* VMAX */
>  #define IMX274_VMAX_REG_3			0x30F8 /* VMAX, LSB */
> @@ -140,10 +156,10 @@ static const struct regmap_config imx274_regmap_config = {
>  	.cache_type = REGCACHE_RBTREE,
>  };
>  
> -enum imx274_mode {
> -	IMX274_MODE_3840X2160,
> -	IMX274_MODE_1920X1080,
> -	IMX274_MODE_1280X720,
> +enum imx274_binning {
> +	IMX274_BINNING_OFF,
> +	IMX274_BINNING_2_1,
> +	IMX274_BINNING_3_1,
>  };
>  
>  /*
> @@ -152,8 +168,8 @@ enum imx274_mode {
>   * These are the values to configure the sensor in one of the
>   * implemented modes.
>   *
> - * @size: recommended recording pixels
>   * @init_regs: registers to initialize the mode
> + * @bin_ratio: downscale factor (e.g. 3 for 3:1 binning)
>   * @min_frame_len: Minimum frame length for each mode (see "Frame Rate
>   *                 Adjustment (CSI-2)" in the datasheet)
>   * @min_SHR: Minimum SHR register value (see "Shutter Setting (CSI-2)" in the
> @@ -163,8 +179,8 @@ enum imx274_mode {
>   *           in Each Readout Drive Mode (CSI-2)" in the datasheet)
>   */
>  struct imx274_frmfmt {
> -	struct v4l2_frmsize_discrete size;
>  	const struct reg_8 *init_regs;
> +	unsigned int bin_ratio;
>  	int min_frame_len;
>  	int min_SHR;
>  	int max_fps;
> @@ -215,31 +231,14 @@ static const struct reg_8 imx274_mode1_3840x2160_raw10[] = {
>  	{0x3004, 0x01},
>  	{0x3005, 0x01},
>  	{0x3006, 0x00},
> -	{0x3007, 0x02},
> +	{0x3007, 0xa2},
>  
>  	{0x3018, 0xA2}, /* output XVS, HVS */
>  
>  	{0x306B, 0x05},
>  	{0x30E2, 0x01},
> -	{0x30F6, 0x07}, /* HMAX, 263 */
> -	{0x30F7, 0x01}, /* HMAX */
> -
> -	{0x30dd, 0x01}, /* crop to 2160 */
> -	{0x30de, 0x06},
> -	{0x30df, 0x00},
> -	{0x30e0, 0x12},
> -	{0x30e1, 0x00},
> -	{0x3037, 0x01}, /* to crop to 3840 */
> -	{0x3038, 0x0c},
> -	{0x3039, 0x00},
> -	{0x303a, 0x0c},
> -	{0x303b, 0x0f},
>  
>  	{0x30EE, 0x01},
> -	{0x3130, 0x86},
> -	{0x3131, 0x08},
> -	{0x3132, 0x7E},
> -	{0x3133, 0x08},
>  	{0x3342, 0x0A},
>  	{0x3343, 0x00},
>  	{0x3344, 0x16},
> @@ -273,32 +272,14 @@ static const struct reg_8 imx274_mode3_1920x1080_raw10[] = {
>  	{0x3004, 0x02},
>  	{0x3005, 0x21},
>  	{0x3006, 0x00},
> -	{0x3007, 0x11},
> +	{0x3007, 0xb1},
>  
>  	{0x3018, 0xA2}, /* output XVS, HVS */
>  
>  	{0x306B, 0x05},
>  	{0x30E2, 0x02},
>  
> -	{0x30F6, 0x04}, /* HMAX, 260 */
> -	{0x30F7, 0x01}, /* HMAX */
> -
> -	{0x30dd, 0x01}, /* to crop to 1920x1080 */
> -	{0x30de, 0x05},
> -	{0x30df, 0x00},
> -	{0x30e0, 0x04},
> -	{0x30e1, 0x00},
> -	{0x3037, 0x01},
> -	{0x3038, 0x0c},
> -	{0x3039, 0x00},
> -	{0x303a, 0x0c},
> -	{0x303b, 0x0f},
> -
>  	{0x30EE, 0x01},
> -	{0x3130, 0x4E},
> -	{0x3131, 0x04},
> -	{0x3132, 0x46},
> -	{0x3133, 0x04},
>  	{0x3342, 0x0A},
>  	{0x3343, 0x00},
>  	{0x3344, 0x1A},
> @@ -331,31 +312,14 @@ static const struct reg_8 imx274_mode5_1280x720_raw10[] = {
>  	{0x3004, 0x03},
>  	{0x3005, 0x31},
>  	{0x3006, 0x00},
> -	{0x3007, 0x09},
> +	{0x3007, 0xa9},
>  
>  	{0x3018, 0xA2}, /* output XVS, HVS */
>  
>  	{0x306B, 0x05},
>  	{0x30E2, 0x03},
>  
> -	{0x30F6, 0x04}, /* HMAX, 260 */
> -	{0x30F7, 0x01}, /* HMAX */
> -
> -	{0x30DD, 0x01},
> -	{0x30DE, 0x07},
> -	{0x30DF, 0x00},
> -	{0x40E0, 0x04},
> -	{0x30E1, 0x00},
> -	{0x3030, 0xD4},
> -	{0x3031, 0x02},
> -	{0x3032, 0xD0},
> -	{0x3033, 0x02},
> -
>  	{0x30EE, 0x01},
> -	{0x3130, 0xE2},
> -	{0x3131, 0x02},
> -	{0x3132, 0xDE},
> -	{0x3133, 0x02},
>  	{0x3342, 0x0A},
>  	{0x3343, 0x00},
>  	{0x3344, 0x1B},
> @@ -498,7 +462,7 @@ static const struct reg_8 imx274_tp_regs[] = {
>  static const struct imx274_frmfmt imx274_formats[] = {
>  	{
>  		/* mode 1, 4K */
> -		.size = {3840, 2160},
> +		.bin_ratio = 1,
>  		.init_regs = imx274_mode1_3840x2160_raw10,
>  		.min_frame_len = 4550,
>  		.min_SHR = 12,
> @@ -507,7 +471,7 @@ static const struct imx274_frmfmt imx274_formats[] = {
>  	},
>  	{
>  		/* mode 3, 1080p */
> -		.size = {1920, 1080},
> +		.bin_ratio = 2,
>  		.init_regs = imx274_mode3_1920x1080_raw10,
>  		.min_frame_len = 2310,
>  		.min_SHR = 8,
> @@ -516,7 +480,7 @@ static const struct imx274_frmfmt imx274_formats[] = {
>  	},
>  	{
>  		/* mode 5, 720p */
> -		.size = {1280, 720},
> +		.bin_ratio = 3,
>  		.init_regs = imx274_mode5_1280x720_raw10,
>  		.min_frame_len = 2310,
>  		.min_SHR = 8,
> @@ -547,7 +511,10 @@ struct imx274_ctrls {
>   * @pad: Media pad structure
>   * @client: Pointer to I2C client
>   * @ctrls: imx274 control structure
> + * @crop: rect to be captured
> + * @compose: compose rect, i.e. output resolution
>   * @format: V4L2 media bus frame format structure
> + *          (width and height are in sync with the compose rect)
>   * @frame_rate: V4L2 frame rate structure
>   * @regmap: Pointer to regmap structure
>   * @reset_gpio: Pointer to reset gpio
> @@ -559,6 +526,7 @@ struct stimx274 {
>  	struct media_pad pad;
>  	struct i2c_client *client;
>  	struct imx274_ctrls ctrls;
> +	struct v4l2_rect crop;
>  	struct v4l2_mbus_framefmt format;
>  	struct v4l2_fract frame_interval;
>  	struct regmap *regmap;
> @@ -567,6 +535,13 @@ struct stimx274 {
>  	const struct imx274_frmfmt *mode;
>  };
>  
> +#define IMX274_ROUND(dim, step, flags)			\
> +	((flags) & V4L2_SEL_FLAG_GE			\
> +	 ? roundup((dim), (step))			\
> +	 : ((flags) & V4L2_SEL_FLAG_LE			\
> +	    ? rounddown((dim), (step))			\
> +	    : rounddown((dim) + (step) / 2, (step))))
> +
>  /*
>   * Function declaration
>   */
> @@ -840,6 +815,113 @@ static int imx274_s_ctrl(struct v4l2_ctrl *ctrl)
>  	return ret;
>  }
>  
> +static int imx274_binning_goodness(struct stimx274 *imx274,
> +				   int w, int ask_w,
> +				   int h, int ask_h, u32 flags)
> +{
> +	struct device *dev = &imx274->client->dev;
> +	const int goodness = 100000;
> +	int val = 0;
> +
> +	if (flags & V4L2_SEL_FLAG_GE) {
> +		if (w < ask_w)
> +			val -= goodness;
> +		if (h < ask_h)
> +			val -= goodness;
> +	}
> +
> +	if (flags & V4L2_SEL_FLAG_LE) {
> +		if (w > ask_w)
> +			val -= goodness;
> +		if (h > ask_h)
> +			val -= goodness;
> +	}
> +
> +	val -= abs(w - ask_w);
> +	val -= abs(h - ask_h);
> +
> +	dev_dbg(dev, "%s: ask %dx%d, size %dx%d, goodness %d\n",
> +		__func__, ask_w, ask_h, w, h, val);
> +
> +	return val;
> +}
> +
> +/**
> + * Helper function to change binning and set both compose and format.
> + *
> + * We have two entry points to change binning: set_fmt and
> + * set_selection(COMPOSE). Both have to compute the new output size
> + * and set it in both the compose rect and the frame format size. We
> + * also need to do the same things after setting cropping to restore
> + * 1:1 binning.
> + *
> + * This function contains the common code for these three cases, it
> + * has many arguments in order to accomodate the needs of all of them.
> + *
> + * Must be called with imx274->lock locked.
> + *
> + * @imx274: The device object
> + * @cfg:    The pad config we are editing for TRY requests
> + * @which:  V4L2_SUBDEV_FORMAT_ACTIVE or V4L2_SUBDEV_FORMAT_TRY from the caller
> + * @width:  Input-output parameter: set to the desired width before
> + *          the call, contains the chosen value after returning successfully
> + * @height: Input-output parameter for height (see @width)
> + * @flags:  Selection flags from struct v4l2_subdev_selection, or 0 if not
> + *          available (when called from set_fmt)
> + */
> +static int __imx274_change_compose(struct stimx274 *imx274,
> +				   struct v4l2_subdev_pad_config *cfg,
> +				   u32 which,
> +				   u32 *width,
> +				   u32 *height,
> +				   u32 flags)
> +{
> +	struct device *dev = &imx274->client->dev;
> +	const struct v4l2_rect *cur_crop;
> +	struct v4l2_mbus_framefmt *tgt_fmt;
> +	unsigned int i;
> +	const struct imx274_frmfmt *best_mode = &imx274_formats[0];
> +	int best_goodness = INT_MIN;
> +
> +	if (which == V4L2_SUBDEV_FORMAT_TRY) {
> +		cur_crop = &cfg->try_crop;
> +		tgt_fmt = &cfg->try_fmt;
> +	} else {
> +		cur_crop = &imx274->crop;
> +		tgt_fmt = &imx274->format;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(imx274_formats); i++) {
> +		unsigned int ratio = imx274_formats[i].bin_ratio;
> +
> +		int goodness = imx274_binning_goodness(
> +			imx274,
> +			cur_crop->width / ratio, *width,
> +			cur_crop->height / ratio, *height,
> +			flags);
> +
> +		if (goodness >= best_goodness) {
> +			best_goodness = goodness;
> +			best_mode = &imx274_formats[i];
> +		}
> +	}
> +
> +	*width = cur_crop->width / best_mode->bin_ratio;
> +	*height = cur_crop->height / best_mode->bin_ratio;
> +
> +	if (which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		imx274->mode = best_mode;
> +
> +	dev_dbg(dev, "%s: selected %u:1 binning\n",
> +		__func__, best_mode->bin_ratio);
> +
> +	tgt_fmt->width = *width;
> +	tgt_fmt->height = *height;
> +	tgt_fmt->field = V4L2_FIELD_NONE;
> +
> +	return 0;
> +}
> +
>  /**
>   * imx274_get_fmt - Get the pad format
>   * @sd: Pointer to V4L2 Sub device structure
> @@ -878,45 +960,239 @@ static int imx274_set_fmt(struct v4l2_subdev *sd,
>  {
>  	struct v4l2_mbus_framefmt *fmt = &format->format;
>  	struct stimx274 *imx274 = to_imx274(sd);
> -	struct i2c_client *client = imx274->client;
> -	int index;
> -
> -	dev_dbg(&client->dev,
> -		"%s: width = %d height = %d code = %d\n",
> -		__func__, fmt->width, fmt->height, fmt->code);
> +	int err = 0;
>  
>  	mutex_lock(&imx274->lock);
>  
> -	for (index = 0; index < ARRAY_SIZE(imx274_formats); index++) {
> -		if (imx274_formats[index].size.width == fmt->width &&
> -		    imx274_formats[index].size.height == fmt->height)
> -			break;
> -	}
> -
> -	if (index >= ARRAY_SIZE(imx274_formats)) {
> -		/* default to first format */
> -		index = 0;
> -	}
> +	err = __imx274_change_compose(imx274, cfg, format->which,
> +				      &fmt->width, &fmt->height, 0);
>  
> -	imx274->mode = &imx274_formats[index];
> +	if (err)
> +		goto out;
>  
> -	if (fmt->width > IMX274_MAX_WIDTH)
> -		fmt->width = IMX274_MAX_WIDTH;
> -	if (fmt->height > IMX274_MAX_HEIGHT)
> -		fmt->height = IMX274_MAX_HEIGHT;
> -	fmt->width = fmt->width & (~IMX274_MASK_LSB_2_BITS);
> -	fmt->height = fmt->height & (~IMX274_MASK_LSB_2_BITS);
> +	/*
> +	 * __imx274_change_compose already set width and height in the
> +	 * applicable format, but we need to keep all other format
> +	 * values, so do a full copy here
> +	 */
>  	fmt->field = V4L2_FIELD_NONE;
> -
>  	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
>  		cfg->try_fmt = *fmt;
>  	else
>  		imx274->format = *fmt;
>  
> +out:
> +	mutex_unlock(&imx274->lock);
> +
> +	return err;
> +}
> +
> +static int imx274_get_selection(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_pad_config *cfg,
> +				struct v4l2_subdev_selection *sel)
> +{
> +	struct stimx274 *imx274 = to_imx274(sd);
> +	const struct v4l2_rect *src_crop;
> +	const struct v4l2_mbus_framefmt *src_fmt;
> +	int ret = 0;
> +
> +	if (sel->pad != 0)
> +		return -EINVAL;
> +
> +	if (sel->target == V4L2_SEL_TGT_CROP_BOUNDS) {
> +		sel->r.left = 0;
> +		sel->r.top = 0;
> +		sel->r.width = IMX274_MAX_WIDTH;
> +		sel->r.height = IMX274_MAX_HEIGHT;
> +		return 0;
> +	}
> +
> +	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		src_crop = &cfg->try_crop;
> +		src_fmt = &cfg->try_fmt;
> +	} else {
> +		src_crop = &imx274->crop;
> +		src_fmt = &imx274->format;
> +	}
> +
> +	mutex_lock(&imx274->lock);
> +
> +	switch (sel->target) {
> +	case V4L2_SEL_TGT_CROP:
> +		sel->r = *src_crop;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +		sel->r.top = 0;
> +		sel->r.left = 0;
> +		sel->r.width = src_crop->width;
> +		sel->r.height = src_crop->height;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		sel->r.top = 0;
> +		sel->r.left = 0;
> +		sel->r.width = src_fmt->width;
> +		sel->r.height = src_fmt->height;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	mutex_unlock(&imx274->lock);
> +
> +	return ret;
> +}
> +
> +static int imx274_set_selection_crop(struct stimx274 *imx274,
> +				     struct v4l2_subdev_pad_config *cfg,
> +				     struct v4l2_subdev_selection *sel)
> +{
> +	struct device *dev = &imx274->client->dev;
> +	struct v4l2_rect *tgt_crop;
> +	struct v4l2_rect new_crop;
> +	bool size_changed;
> +
> +	/*
> +	 * h_step could be 12 or 24 depending on the binning. But we
> +	 * won't know the binning until we choose the mode later in
> +	 * __imx274_change_compose(). Thus let's be safe and use the
> +	 * most conservative value in all cases.
> +	 */
> +	const u32 h_step = 24;
> +
> +	new_crop.width = min_t(u32,
> +			       IMX274_ROUND(sel->r.width, h_step, sel->flags),
> +			       IMX274_MAX_WIDTH);
> +
> +	/* Constraint: HTRIMMING_END - HTRIMMING_START >= 144 */
> +	if (new_crop.width < 144)
> +		new_crop.width = 144;
> +
> +	new_crop.left = min_t(u32,
> +			      IMX274_ROUND(sel->r.left, h_step, 0),
> +			      IMX274_MAX_WIDTH - new_crop.width);
> +
> +	new_crop.height = min_t(u32,
> +				IMX274_ROUND(sel->r.height, 2, sel->flags),
> +				IMX274_MAX_HEIGHT);
> +
> +	new_crop.top = min_t(u32, IMX274_ROUND(sel->r.top, 2, 0),
> +			     IMX274_MAX_HEIGHT - new_crop.height);
> +
> +	sel->r = new_crop;
> +
> +	if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
> +		tgt_crop = &cfg->try_crop;
> +	else
> +		tgt_crop = &imx274->crop;
> +
> +	mutex_lock(&imx274->lock);
> +
> +	size_changed = (new_crop.width != tgt_crop->width ||
> +			new_crop.height != tgt_crop->height);
> +
> +	/* __imx274_change_compose needs the new size in *tgt_crop */
> +	*tgt_crop = new_crop;
> +
> +	/* if crop size changed then reset the output image size */
> +	if (size_changed)
> +		__imx274_change_compose(imx274, cfg, sel->which,
> +					&new_crop.width, &new_crop.height,
> +					sel->flags);
> +
>  	mutex_unlock(&imx274->lock);
> +
>  	return 0;
>  }
>  
> +static int imx274_set_selection(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_pad_config *cfg,
> +				struct v4l2_subdev_selection *sel)
> +{
> +	struct stimx274 *imx274 = to_imx274(sd);
> +
> +	if (sel->pad != 0)
> +		return -EINVAL;
> +
> +	if (sel->target == V4L2_SEL_TGT_CROP)
> +		return imx274_set_selection_crop(imx274, cfg, sel);
> +
> +	if (sel->target == V4L2_SEL_TGT_COMPOSE) {
> +		int err;
> +
> +		mutex_lock(&imx274->lock);
> +		err =  __imx274_change_compose(imx274, cfg, sel->which,
> +					       &sel->r.width, &sel->r.height,
> +					       sel->flags);
> +		mutex_unlock(&imx274->lock);
> +
> +		/*
> +		 * __imx274_change_compose already set width and
> +		 * height in set->r, we still need to set top-left
> +		 */
> +		if (!err) {
> +			sel->r.top = 0;
> +			sel->r.left = 0;
> +		}
> +
> +		return err;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int imx274_apply_trimming(struct stimx274 *imx274)
> +{
> +	u32 h_start;
> +	u32 h_end;
> +	u32 hmax;
> +	u32 v_cut;
> +	s32 v_pos;
> +	u32 write_v_size;
> +	u32 y_out_size;
> +	int err;
> +
> +	h_start = imx274->crop.left + 12;
> +	h_end = h_start + imx274->crop.width;
> +
> +	/* Use the minimum allowed value of HMAX */
> +	/* Note: except in mode 1, (width / 16 + 23) is always < hmax_min */
> +	/* Note: 260 is the minimum HMAX in all implemented modes */
> +	hmax = max_t(u32, 260, (imx274->crop.width) / 16 + 23);
> +
> +	/* invert v_pos if VFLIP */
> +	v_pos = imx274->ctrls.vflip->cur.val ?
> +		(-imx274->crop.top / 2) : (imx274->crop.top / 2);
> +	v_cut = (IMX274_MAX_HEIGHT - imx274->crop.height) / 2;
> +	write_v_size = imx274->crop.height + 22;
> +	y_out_size   = imx274->crop.height + 14;
> +
> +	err = imx274_write_mbreg(imx274, IMX274_HMAX_REG_LSB, hmax, 2);
> +	if (!err)
> +		err = imx274_write_mbreg(imx274, IMX274_HTRIM_EN_REG, 1, 1);
> +	if (!err)
> +		err = imx274_write_mbreg(imx274, IMX274_HTRIM_START_REG_LSB,
> +					 h_start, 2);
> +	if (!err)
> +		err = imx274_write_mbreg(imx274, IMX274_HTRIM_END_REG_LSB,
> +					 h_end, 2);
> +	if (!err)
> +		err = imx274_write_mbreg(imx274, IMX274_VWIDCUTEN_REG, 1, 1);
> +	if (!err)
> +		err = imx274_write_mbreg(imx274, IMX274_VWIDCUT_REG_LSB,
> +					 v_cut, 2);
> +	if (!err)
> +		err = imx274_write_mbreg(imx274, IMX274_VWINPOS_REG_LSB,
> +					 v_pos, 2);
> +	if (!err)
> +		err = imx274_write_mbreg(imx274, IMX274_WRITE_VSIZE_REG_LSB,
> +					 write_v_size, 2);
> +	if (!err)
> +		err = imx274_write_mbreg(imx274, IMX274_Y_OUT_SIZE_REG_LSB,
> +					 y_out_size, 2);

return imx274_write_mbreg(...);

> +
> +	return err;
> +}
> +
>  /**
>   * imx274_g_frame_interval - Get the frame interval
>   * @sd: Pointer to V4L2 Sub device structure
> @@ -1057,6 +1333,10 @@ static int imx274_s_stream(struct v4l2_subdev *sd, int on)
>  		if (ret)
>  			goto fail;
>  
> +		ret = imx274_apply_trimming(imx274);
> +		if (ret)
> +			goto fail;
> +
>  		/*
>  		 * update frame rate & expsoure. if the last mode is different,
>  		 * HMAX could be changed. As the result, frame rate & exposure
> @@ -1544,6 +1824,8 @@ static int imx274_set_frame_interval(struct stimx274 *priv,
>  static const struct v4l2_subdev_pad_ops imx274_pad_ops = {
>  	.get_fmt = imx274_get_fmt,
>  	.set_fmt = imx274_set_fmt,
> +	.get_selection = imx274_get_selection,
> +	.set_selection = imx274_set_selection,
>  };
>  
>  static const struct v4l2_subdev_video_ops imx274_video_ops = {
> @@ -1589,8 +1871,10 @@ static int imx274_probe(struct i2c_client *client,
>  
>  	/* initialize format */
>  	imx274->mode = &imx274_formats[IMX274_DEFAULT_MODE];
> -	imx274->format.width = imx274->mode->size.width;
> -	imx274->format.height = imx274->mode->size.height;
> +	imx274->crop.width = IMX274_MAX_WIDTH;
> +	imx274->crop.height = IMX274_MAX_HEIGHT;
> +	imx274->format.width = imx274->crop.width / imx274->mode->bin_ratio;
> +	imx274->format.height = imx274->crop.height / imx274->mode->bin_ratio;
>  	imx274->format.field = V4L2_FIELD_NONE;
>  	imx274->format.code = MEDIA_BUS_FMT_SRGGB10_1X10;
>  	imx274->format.colorspace = V4L2_COLORSPACE_SRGB;

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
