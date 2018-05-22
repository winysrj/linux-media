Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:57333 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751342AbeEVUIz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 16:08:55 -0400
Date: Tue, 22 May 2018 22:08:48 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: bingbu.cao@intel.com
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        bingbu.cao@linux.intel.com, tian.shu.qiu@linux.intel.com,
        rajmohan.mani@intel.com, mchehab@kernel.org
Subject: Re: [PATCH v3] media: imx319: Add imx319 camera sensor driver
Message-ID: <20180522200848.GB15035@w540>
References: <1526886658-14417-1-git-send-email-bingbu.cao@intel.com>
 <1526963581-28655-1-git-send-email-bingbu.cao@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <1526963581-28655-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello Bingbu,
   thanks for the patch

On Tue, May 22, 2018 at 12:33:01PM +0800, bingbu.cao@intel.com wrote:
> From: Bingbu Cao <bingbu.cao@intel.com>
>
> Add a V4L2 sub-device driver for the Sony IMX319 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.

Could you please provide a changelog between versions? Also, I know
using the --in-reply-to option is tempting to keep all patch version
in a single thread, but most people finds it confusing and I rarely
see that.

>
> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> ---
>  MAINTAINERS                |    7 +
>  drivers/media/i2c/Kconfig  |   11 +
>  drivers/media/i2c/Makefile |    1 +
>  drivers/media/i2c/imx319.c | 2434 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 2453 insertions(+)
>  create mode 100644 drivers/media/i2c/imx319.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e73a55a6a855..87b6c338d827 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13084,6 +13084,13 @@ S:	Maintained
>  F:	drivers/media/i2c/imx274.c
>  F:	Documentation/devicetree/bindings/media/i2c/imx274.txt
>
> +SONY IMX319 SENSOR DRIVER
> +M:	Bingbu Cao <bingbu.cao@intel.com>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Maintained
> +F:	drivers/media/i2c/imx319.c
> +
>  SONY MEMORYSTICK CARD SUPPORT
>  M:	Alex Dubov <oakad@yahoo.com>
>  W:	http://tifmxx.berlios.de/
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 1f9d7c6aa31a..c3d279cc293e 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -604,6 +604,17 @@ config VIDEO_IMX274
>  	  This is a V4L2 sensor-level driver for the Sony IMX274
>  	  CMOS image sensor.
>
> +config VIDEO_IMX319
> +	tristate "Sony IMX319 sensor support"
> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	depends on MEDIA_CAMERA_SUPPORT
> +	help
> +	  This is a Video4Linux2 sensor driver for the Sony
> +	  IMX319 camera.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called imx319.
> +
>  config VIDEO_OV2640
>  	tristate "OmniVision OV2640 sensor support"
>  	depends on VIDEO_V4L2 && I2C
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index 16fc34eda5cc..3adb3be4a486 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -104,5 +104,6 @@ obj-$(CONFIG_VIDEO_OV2659)	+= ov2659.o
>  obj-$(CONFIG_VIDEO_TC358743)	+= tc358743.o
>  obj-$(CONFIG_VIDEO_IMX258)	+= imx258.o
>  obj-$(CONFIG_VIDEO_IMX274)	+= imx274.o
> +obj-$(CONFIG_VIDEO_IMX319)	+= imx319.o
>
>  obj-$(CONFIG_SDR_MAX2175) += max2175.o

This hunk does not apply nor on media tree master nor on Linus'
master. Could you please mention on which branch the patch is meant to
be applied in the cover letter? Maybe it's obvious for most people here,
but I failed to find it.

> diff --git a/drivers/media/i2c/imx319.c b/drivers/media/i2c/imx319.c
> new file mode 100644
> index 000000000000..706bbafc75ec
> --- /dev/null
> +++ b/drivers/media/i2c/imx319.c
> @@ -0,0 +1,2434 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2018 Intel Corporation
> +
> +#include <asm/unaligned.h>
> +#include <linux/acpi.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +
> +#define IMX319_REG_MODE_SELECT		0x0100
> +#define IMX319_MODE_STANDBY		0x00
> +#define IMX319_MODE_STREAMING		0x01
> +
> +/* Chip ID */
> +#define IMX319_REG_CHIP_ID		0x0016
> +#define IMX319_CHIP_ID			0x0319
> +
> +/* V_TIMING internal */
> +#define IMX319_REG_FLL			0x0340
> +#define IMX319_FLL_MAX			0xffff
> +
> +/* Exposure control */
> +#define IMX319_REG_EXPOSURE		0x0202
> +#define IMX319_EXPOSURE_MIN		1
> +#define IMX319_EXPOSURE_STEP		1
> +#define IMX319_EXPOSURE_DEFAULT		0x04ee
> +
> +/* Analog gain control */
> +#define IMX319_REG_ANALOG_GAIN		0x0204
> +#define IMX319_ANA_GAIN_MIN		0
> +#define IMX319_ANA_GAIN_MAX		960
> +#define IMX319_ANA_GAIN_STEP		1
> +#define IMX319_ANA_GAIN_DEFAULT		0
> +
> +/* Digital gain control */
> +#define IMX319_REG_DPGA_USE_GLOBAL_GAIN	0x3ff9
> +#define IMX319_REG_DIG_GAIN_GLOBAL	0x020e
> +#define IMX319_DGTL_GAIN_MIN		256
> +#define IMX319_DGTL_GAIN_MAX		4095
> +#define IMX319_DGTL_GAIN_STEP		1
> +#define IMX319_DGTL_GAIN_DEFAULT	256
> +
> +/* Test Pattern Control */
> +#define IMX319_REG_TEST_PATTERN		0x0600
> +#define IMX319_TEST_PATTERN_DISABLED		0
> +#define IMX319_TEST_PATTERN_SOLID_COLOR		1
> +#define IMX319_TEST_PATTERN_COLOR_BARS		2
> +#define IMX319_TEST_PATTERN_GRAY_COLOR_BARS	3
> +#define IMX319_TEST_PATTERN_PN9			4
> +
> +/* Flip Control */
> +#define IMX319_REG_ORIENTATION		0x0101
> +
> +struct imx319_reg {
> +	u16 address;
> +	u8 val;
> +};
> +
> +struct imx319_reg_list {
> +	u32 num_of_regs;
> +	const struct imx319_reg *regs;
> +};
> +
> +/* Mode : resolution and related config&values */
> +struct imx319_mode {
> +	/* Frame width */
> +	u32 width;
> +	/* Frame height */
> +	u32 height;
> +
> +	/* V-timing */
> +	u32 fll_def;
> +	u32 fll_min;
> +
> +	/* H-timing */
> +	u32 llp;
> +
> +	/* Default register values */
> +	struct imx319_reg_list reg_list;
> +};
> +
> +struct imx319 {
> +	struct v4l2_subdev sd;
> +	struct media_pad pad;
> +
> +	struct v4l2_ctrl_handler ctrl_handler;
> +	/* V4L2 Controls */
> +	struct v4l2_ctrl *link_freq;
> +	struct v4l2_ctrl *pixel_rate;
> +	struct v4l2_ctrl *vblank;
> +	struct v4l2_ctrl *hblank;
> +	struct v4l2_ctrl *exposure;
> +	struct v4l2_ctrl *vflip;
> +	struct v4l2_ctrl *hflip;
> +
> +	/* Current mode */
> +	const struct imx319_mode *cur_mode;
> +
> +	/*
> +	 * Mutex for serialized access:
> +	 * Protect sensor set pad format and start/stop streaming safely.
> +	 * Protect access to sensor v4l2 controls.
> +	 */
> +	struct mutex mutex;
> +
> +	/* Streaming on/off */
> +	bool streaming;
> +};
> +

[snip] Long tables of registers

> +/* Configurations for supported link frequencies */
> +/* Menu items for LINK_FREQ V4L2 control */
> +static const s64 link_freq_menu_items[] = {
> +	360000000,
> +};
> +
> +/* Mode configs */

[snip] Long list of modes

> +
> +static inline struct imx319 *to_imx319(struct v4l2_subdev *_sd)
> +{
> +	return container_of(_sd, struct imx319, sd);
> +}
> +
> +/* Get bayer order based on flip setting. */
> +static __u32 imx319_get_format_code(struct imx319 *imx319)
> +{
> +	/*
> +	 * Only one bayer order is supported.
> +	 * It depends on the flip settings.
> +	 */
> +	static const __u32 codes[2][2] = {
> +		{ MEDIA_BUS_FMT_SRGGB10_1X10, MEDIA_BUS_FMT_SGRBG10_1X10, },
> +		{ MEDIA_BUS_FMT_SGBRG10_1X10, MEDIA_BUS_FMT_SBGGR10_1X10, },
> +	};
> +
> +	return codes[imx319->vflip->val][imx319->hflip->val];
> +}

I don't have any major comment actually, this is pretty good for a
first submission.

This worries me a bit though. The media bus format depends on the
V/HFLIP value, I assume this is an hardware limitation. But if
changing the flip changes the reported media bus format, you could
trigger a -EPIPE error during pipeline format validation between two
streaming sessions with different flip settings. Isn't this a bit
dangerous?

Below some minor comments.

> +
> +/* Read registers up to 4 at a time */
> +static int imx319_read_reg(struct imx319 *imx319, u16 reg, u32 len, u32 *val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +	struct i2c_msg msgs[2];
> +	u8 addr_buf[2];
> +	u8 data_buf[4] = { 0 };
> +	int ret;
> +
> +	if (len > 4)
> +		return -EINVAL;
> +
> +	put_unaligned_be16(reg, addr_buf);
> +	/* Write register address */
> +	msgs[0].addr = client->addr;
> +	msgs[0].flags = 0;
> +	msgs[0].len = ARRAY_SIZE(addr_buf);
> +	msgs[0].buf = addr_buf;
> +
> +	/* Read data from register */
> +	msgs[1].addr = client->addr;
> +	msgs[1].flags = I2C_M_RD;
> +	msgs[1].len = len;
> +	msgs[1].buf = &data_buf[4 - len];
> +
> +	ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
> +	if (ret != ARRAY_SIZE(msgs))
> +		return -EIO;
> +
> +	*val = get_unaligned_be32(data_buf);
> +
> +	return 0;
> +}
> +
> +/* Write registers up to 4 at a time */
> +static int imx319_write_reg(struct imx319 *imx319, u16 reg, u32 len, u32 val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +	u8 buf[6];
> +
> +	if (len > 4)
> +		return -EINVAL;
> +
> +	put_unaligned_be16(reg, buf);
> +	put_unaligned_be32(val << (8 * (4 - len)), buf + 2);
> +	if (i2c_master_send(client, buf, len + 2) != len + 2)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +/* Write a list of registers */
> +static int imx319_write_regs(struct imx319 *imx319,
> +			      const struct imx319_reg *regs, u32 len)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +	int ret;
> +	u32 i;
> +
> +	for (i = 0; i < len; i++) {
> +		ret = imx319_write_reg(imx319, regs[i].address, 1,
> +					regs[i].val);

Unaligned to open parenthesis

> +		if (ret) {
> +			dev_err_ratelimited(
> +				&client->dev,
> +				"Failed to write reg 0x%4.4x. error = %d\n",
> +				regs[i].address, ret);

No need to break line, align to open parenthesis, please.

> +
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/* Open sub-device */
> +static int imx319_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	struct imx319 *imx319 = to_imx319(sd);
> +	struct v4l2_mbus_framefmt *try_fmt =
> +		v4l2_subdev_get_try_format(sd, fh->pad, 0);
> +
> +	mutex_lock(&imx319->mutex);
> +
> +	/* Initialize try_fmt */
> +	try_fmt->width = imx319->cur_mode->width;
> +	try_fmt->height = imx319->cur_mode->height;
> +	try_fmt->code = imx319_get_format_code(imx319);
> +	try_fmt->field = V4L2_FIELD_NONE;
> +
> +	mutex_unlock(&imx319->mutex);
> +
> +	return 0;
> +}
> +
> +static int imx319_update_digital_gain(struct imx319 *imx319, u32 d_gain)
> +{
> +	int ret;
> +
> +	ret = imx319_write_reg(imx319, IMX319_REG_DPGA_USE_GLOBAL_GAIN, 1, 1);
> +	if (ret)
> +		return ret;
> +
> +	/* Digital gain = (d_gain & 0xFF00) + (d_gain & 0xFF)/256 times */
> +	return imx319_write_reg(imx319, IMX319_REG_DIG_GAIN_GLOBAL, 2, d_gain);
> +}
> +
> +static int imx319_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct imx319 *imx319 = container_of(ctrl->handler,
> +					     struct imx319, ctrl_handler);
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +	s64 max;
> +	int ret;
> +
> +	/* Propagate change of current control to all related controls */
> +	switch (ctrl->id) {
> +	case V4L2_CID_VBLANK:
> +		/* Update max exposure while meeting expected vblanking */
> +		max = imx319->cur_mode->height + ctrl->val - 18;
> +		__v4l2_ctrl_modify_range(imx319->exposure,
> +					 imx319->exposure->minimum,
> +					 max, imx319->exposure->step, max);
> +		break;
> +	}
> +
> +	/*
> +	 * Applying V4L2 control value only happens
> +	 * when power is up for streaming
> +	 */
> +	if (pm_runtime_get_if_in_use(&client->dev) == 0)
> +		return 0;

I assume powering is handled through ACPI somehow, I know nothing
about that, but I wonder why setting controls should be enabled only
when streaming. I would have expected runtime_pm_get/put in subdevices
node open/close functions not only when streaming. Am I missing something?

> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_ANALOGUE_GAIN:
> +		/* Analog gain = 1024/(1024 - ctrl->val) times */
> +		ret = imx319_write_reg(imx319, IMX319_REG_ANALOG_GAIN,
> +				       2, ctrl->val);
> +		break;
> +	case V4L2_CID_DIGITAL_GAIN:
> +		ret = imx319_update_digital_gain(imx319, ctrl->val);
> +		break;
> +	case V4L2_CID_EXPOSURE:
> +		ret = imx319_write_reg(imx319, IMX319_REG_EXPOSURE,
> +				       2, ctrl->val);
> +		break;
> +	case V4L2_CID_VBLANK:
> +		/* Update FLL that meets expected vertical blanking */
> +		ret = imx319_write_reg(imx319, IMX319_REG_FLL, 2,
> +				       imx319->cur_mode->height + ctrl->val);
> +		break;
> +	case V4L2_CID_TEST_PATTERN:
> +		ret = imx319_write_reg(imx319, IMX319_REG_TEST_PATTERN,
> +				       2, imx319_test_pattern_val[ctrl->val]);
> +		break;
> +	case V4L2_CID_HFLIP:
> +	case V4L2_CID_VFLIP:
> +		ret = imx319_write_reg(imx319, IMX319_REG_ORIENTATION, 1,
> +				       imx319->hflip->val |
> +				       imx319->vflip->val << 1);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		dev_info(&client->dev,
> +			 "ctrl(id:0x%x,val:0x%x) is not handled\n",
> +			 ctrl->id, ctrl->val);
> +		break;
> +	}
> +
> +	pm_runtime_put(&client->dev);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops imx319_ctrl_ops = {
> +	.s_ctrl = imx319_set_ctrl,
> +};
> +
> +static int imx319_enum_mbus_code(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	struct imx319 *imx319 = to_imx319(sd);
> +
> +	if (code->index > 0)
> +		return -EINVAL;
> +
> +	code->code = imx319_get_format_code(imx319);
> +
> +	return 0;
> +}
> +
> +static int imx319_enum_frame_size(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_pad_config *cfg,
> +				   struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	struct imx319 *imx319 = to_imx319(sd);
> +
> +	if (fse->index >= ARRAY_SIZE(supported_modes))
> +		return -EINVAL;
> +
> +	if (fse->code != imx319_get_format_code(imx319))
> +		return -EINVAL;
> +
> +	fse->min_width = supported_modes[fse->index].width;
> +	fse->max_width = fse->min_width;
> +	fse->min_height = supported_modes[fse->index].height;
> +	fse->max_height = fse->min_height;
> +
> +	return 0;
> +}
> +
> +static void imx319_update_pad_format(struct imx319 *imx319,
> +				     const struct imx319_mode *mode,
> +				     struct v4l2_subdev_format *fmt)
> +{
> +	fmt->format.width = mode->width;
> +	fmt->format.height = mode->height;
> +	fmt->format.code = imx319_get_format_code(imx319);
> +	fmt->format.field = V4L2_FIELD_NONE;
> +}
> +
> +static int imx319_do_get_pad_format(struct imx319 *imx319,
> +				     struct v4l2_subdev_pad_config *cfg,
> +				     struct v4l2_subdev_format *fmt)
> +{
> +	struct v4l2_mbus_framefmt *framefmt;
> +	struct v4l2_subdev *sd = &imx319->sd;
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> +		fmt->format = *framefmt;
> +	} else {
> +		imx319_update_pad_format(imx319, imx319->cur_mode, fmt);
> +	}
> +
> +	return 0;
> +}
> +
> +static int imx319_get_pad_format(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_format *fmt)
> +{
> +	struct imx319 *imx319 = to_imx319(sd);
> +	int ret;
> +
> +	mutex_lock(&imx319->mutex);
> +	ret = imx319_do_get_pad_format(imx319, cfg, fmt);
> +	mutex_unlock(&imx319->mutex);
> +
> +	return ret;
> +}
> +
> +static int
> +imx319_set_pad_format(struct v4l2_subdev *sd,
> +		       struct v4l2_subdev_pad_config *cfg,
> +		       struct v4l2_subdev_format *fmt)
> +{
> +	struct imx319 *imx319 = to_imx319(sd);
> +	const struct imx319_mode *mode;
> +	struct v4l2_mbus_framefmt *framefmt;
> +	s32 vblank_def;
> +	s32 vblank_min;
> +	s64 h_blank;
> +	s64 pixel_rate;
> +
> +	mutex_lock(&imx319->mutex);
> +
> +	/*
> +	 * Only one bayer order is supported.
> +	 * It depends on the flip settings.
> +	 */
> +	fmt->format.code = imx319_get_format_code(imx319);
> +
> +	mode = v4l2_find_nearest_size(supported_modes,
> +		ARRAY_SIZE(supported_modes), width, height,
> +		fmt->format.width, fmt->format.height);
> +	imx319_update_pad_format(imx319, mode, fmt);
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> +		*framefmt = fmt->format;
> +	} else {
> +		imx319->cur_mode = mode;
> +		pixel_rate =
> +		(link_freq_menu_items[0] * 2 * 4) / 10;

This assumes a fixed link frequency and a fixed number of data lanes,
and a fixed bpp value (but this is ok, as all the formats you have are
10bpp). In OF world those parameters come from DT, what about ACPI?

(also, no need to break line here)

> +		__v4l2_ctrl_s_ctrl_int64(imx319->pixel_rate, pixel_rate);
> +		/* Update limits and set FPS to default */
> +		vblank_def = imx319->cur_mode->fll_def -
> +			     imx319->cur_mode->height;
> +		vblank_min = imx319->cur_mode->fll_min -
> +			     imx319->cur_mode->height;
> +		__v4l2_ctrl_modify_range(
> +			imx319->vblank, vblank_min,
> +			IMX319_FLL_MAX - imx319->cur_mode->height, 1,
> +			vblank_def);

No need to line break, align to open parenthesis please, here and in
other places below here.

> +		__v4l2_ctrl_s_ctrl(imx319->vblank, vblank_def);
> +		h_blank = mode->llp - imx319->cur_mode->width;
> +		/*
> +		 * Currently hblank is not changeable.
> +		 * So FPS control is done only by vblank.
> +		 */
> +		__v4l2_ctrl_modify_range(imx319->hblank, h_blank,
> +					 h_blank, 1, h_blank);
> +	}
> +
> +	mutex_unlock(&imx319->mutex);
> +
> +	return 0;
> +}
> +
> +/* Start streaming */
> +static int imx319_start_streaming(struct imx319 *imx319)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +	const struct imx319_reg_list *reg_list;
> +	int ret;
> +
> +	/* Global Setting */
> +	reg_list = &imx319_global_setting;
> +	ret = imx319_write_regs(imx319, reg_list->regs, reg_list->num_of_regs);
> +	if (ret) {
> +		dev_err(&client->dev, "%s failed to set global settings\n",
> +			__func__);
> +		return ret;
> +	}
> +
> +	/* Apply default values of current mode */
> +	reg_list = &imx319->cur_mode->reg_list;
> +	ret = imx319_write_regs(imx319, reg_list->regs, reg_list->num_of_regs);
> +	if (ret) {
> +		dev_err(&client->dev, "%s failed to set mode\n", __func__);
> +		return ret;
> +	}
> +
> +	/* Apply customized values from user */
> +	ret =  __v4l2_ctrl_handler_setup(imx319->sd.ctrl_handler);
> +	if (ret)
> +		return ret;
> +
> +	return imx319_write_reg(imx319, IMX319_REG_MODE_SELECT,
> +				1, IMX319_MODE_STREAMING);
> +}
> +
> +/* Stop streaming */
> +static int imx319_stop_streaming(struct imx319 *imx319)
> +{
> +	return imx319_write_reg(imx319, IMX319_REG_MODE_SELECT,
> +				1, IMX319_MODE_STANDBY);
> +}
> +
> +static int imx319_set_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct imx319 *imx319 = to_imx319(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int ret = 0;
> +
> +	mutex_lock(&imx319->mutex);
> +	if (imx319->streaming == enable) {
> +		mutex_unlock(&imx319->mutex);
> +		return 0;
> +	}
> +
> +	if (enable) {
> +		ret = pm_runtime_get_sync(&client->dev);
> +		if (ret < 0) {
> +			pm_runtime_put_noidle(&client->dev);
> +			goto err_unlock;
> +		}
> +
> +		/*
> +		 * Apply default & customized values
> +		 * and then start streaming.
> +		 */
> +		ret = imx319_start_streaming(imx319);
> +		if (ret)
> +			goto err_rpm_put;
> +	} else {
> +		imx319_stop_streaming(imx319);
> +		pm_runtime_put(&client->dev);
> +	}
> +
> +	imx319->streaming = enable;
> +	mutex_unlock(&imx319->mutex);
> +
> +	return ret;
> +
> +err_rpm_put:
> +	pm_runtime_put(&client->dev);
> +err_unlock:
> +	mutex_unlock(&imx319->mutex);
> +
> +	return ret;
> +}
> +
> +static int __maybe_unused imx319_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct imx319 *imx319 = to_imx319(sd);
> +
> +	if (imx319->streaming)
> +		imx319_stop_streaming(imx319);
> +
> +	return 0;
> +}
> +
> +static int __maybe_unused imx319_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct imx319 *imx319 = to_imx319(sd);
> +	int ret;
> +
> +	if (imx319->streaming) {
> +		ret = imx319_start_streaming(imx319);
> +		if (ret)
> +			goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	imx319_stop_streaming(imx319);
> +	imx319->streaming = 0;
> +	return ret;
> +}
> +
> +/* Verify chip ID */
> +static int imx319_identify_module(struct imx319 *imx319)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +	int ret;
> +	u32 val;
> +
> +	ret = imx319_read_reg(imx319, IMX319_REG_CHIP_ID, 2, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val != IMX319_CHIP_ID) {
> +		dev_err(&client->dev, "chip id mismatch: %x!=%x\n",
> +			IMX319_CHIP_ID, val);
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_video_ops imx319_video_ops = {
> +	.s_stream = imx319_set_stream,
> +};
> +
> +static const struct v4l2_subdev_pad_ops imx319_pad_ops = {
> +	.enum_mbus_code = imx319_enum_mbus_code,
> +	.get_fmt = imx319_get_pad_format,
> +	.set_fmt = imx319_set_pad_format,
> +	.enum_frame_size = imx319_enum_frame_size,
> +};
> +
> +static const struct v4l2_subdev_ops imx319_subdev_ops = {
> +	.video = &imx319_video_ops,
> +	.pad = &imx319_pad_ops,
> +};
> +
> +static const struct media_entity_operations imx319_subdev_entity_ops = {
> +	.link_validate = v4l2_subdev_link_validate,
> +};
> +
> +static const struct v4l2_subdev_internal_ops imx319_internal_ops = {
> +	.open = imx319_open,
> +};
> +
> +/* Initialize control handlers */
> +static int imx319_init_controls(struct imx319 *imx319)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +	struct v4l2_ctrl_handler *ctrl_hdlr;
> +	s64 exposure_max;
> +	s64 vblank_def;
> +	s64 vblank_min;
> +	s64 hblank;
> +	s64 pixel_rate;
> +	const struct imx319_mode *mode;
> +	int ret;
> +
> +	ctrl_hdlr = &imx319->ctrl_handler;
> +	ret = v4l2_ctrl_handler_init(ctrl_hdlr, 10);
> +	if (ret)
> +		return ret;
> +
> +	ctrl_hdlr->lock = &imx319->mutex;
> +	imx319->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr,
> +				&imx319_ctrl_ops,
> +				V4L2_CID_LINK_FREQ,
> +				0,
> +				0,
> +				link_freq_menu_items);

In this function seems like you lost alignment and are breaking lines
when not necessary. Could you please have a look?

Seems like apart a few questions, I only have minor comments then...

Thanks
   j


--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbBHjQAAoJEHI0Bo8WoVY8NSAQAJGsQLdP/6kO2u5f8Hh3gVdv
S3F06dMTE+S60MLVclRnCTSOoT936GwNpnIfauceaovu/6gr7AyRou8Q1SWv7/q+
wZoy225tbuseiqGlRbhgc0Eqb7bN3KcQ6tiDD68ZgQRpbC9JwLDYN/WcJFeiZL/L
Z02bBdFZShbFdzMt9te21BtsFgh1lGM6MDnwGbPaoZW6WoYVe8Nr/qy+BbnFVaU2
fvQLEz+iS/1Yzi0x5PbbR4yoBJPWDMS0Zxjg+p+W9Yqb0Vc0ODifhSOuYc6OD+cO
rlXcjMDgbWhDKo/+B34ab11/HJ20sugE5iZrA/vo+j/tpuFPaEHzIoA5xAOWe5nj
ujve9fvEci2XEdig3ldCKbkPGBGxfaE4vDlzpOuML92flNoEE8o9cxNalW2jSY99
C91d7QKeOzpks035yWXvIQYARSwFUlWXTnrjCxAvttZblGKtXKTolgcOTq5ID0qZ
OamU8AOcgT9HOK38+LqSD0RKljpJRf8KcaU/sy1UyFtDNJcjn1vPWxp0us3ItTqE
ZKvqzRV5ToDhxH4Wu32+AhGmlCPcbBpJDGcJun+krRQyYnSwZ+IrsG0bFA6PC+ol
Omk6jFi/6Y8n6u81U/5drakuZ6zbV7Gr+vv7gBszn+mjT4rhwT6KEe9/LNtR5+vr
hs2SD+Iy1Fde02xj5ep7
=tiTE
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
