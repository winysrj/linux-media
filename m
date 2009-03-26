Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1960 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZCZHDs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 03:03:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH v3] v4l2-subdev: ADV7343 video encoder driver
Date: Thu, 26 Mar 2009 08:03:35 +0100
Cc: Chaithrika U S <chaithrika@ti.com>, linux-media@vger.kernel.org
References: <1238038788-31363-1-git-send-email-chaithrika@ti.com>
In-Reply-To: <1238038788-31363-1-git-send-email-chaithrika@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903260803.35696.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 26 March 2009 04:39:48 Chaithrika U S wrote:
> Analog Devices ADV7343 video encoder driver
>
> Add ADV7343 I2C based video encoder driver. This follows the v4l2-subdev
> framework.This driver has been tested on TI DM646x EVM. It has been
> tested for Composite and Component outputs.
>
> In this verision of the patch, review comments have been incorporated.
> The querystd implementation has been removed. A note regarding the
> hardware not supporting SECAM has been added.
>
> Signed-off-by: Chaithrika U S <chaithrika@ti.com>

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Thanks! This looks very nice.

Regards,

	Hans

> ---
>  drivers/media/video/Kconfig        |    9 +
>  drivers/media/video/Makefile       |    1 +
>  drivers/media/video/adv7343.c      |  531
> ++++++++++++++++++++++++++++++++++++ drivers/media/video/adv7343_regs.h |
>  188 +++++++++++++
>  include/media/adv7343.h            |   23 ++
>  include/media/v4l2-chip-ident.h    |    3 +
>  6 files changed, 755 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/adv7343.c
>  create mode 100644 drivers/media/video/adv7343_regs.h
>  create mode 100644 include/media/adv7343.h
>
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 114bf04..49ff639 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -426,6 +426,15 @@ config VIDEO_ADV7175
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called adv7175.
>
> +config VIDEO_ADV7343
> +        tristate "ADV7343 video encoder"
> +        depends on I2C
> +        help
> +          Support for Analog Devices I2C bus based ADV7343 encoder.
> +
> +          To compile this driver as a module, choose M here: the
> +          module will be called adv7343.
> +
>  comment "Video improvement chips"
>
>  config VIDEO_UPD64031A
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 08765d8..eaa5a49 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -49,6 +49,7 @@ obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
>  obj-$(CONFIG_VIDEO_SAA7191) += saa7191.o
>  obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
>  obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
> +obj-$(CONFIG_VIDEO_ADV7343) += adv7343.o
>  obj-$(CONFIG_VIDEO_VPX3220) += vpx3220.o
>  obj-$(CONFIG_VIDEO_BT819) += bt819.o
>  obj-$(CONFIG_VIDEO_BT856) += bt856.o
> diff --git a/drivers/media/video/adv7343.c
> b/drivers/media/video/adv7343.c new file mode 100644
> index 0000000..a31aad4
> --- /dev/null
> +++ b/drivers/media/video/adv7343.c
> @@ -0,0 +1,531 @@
> +/*
> + * adv7343 - ADV7343 Video Encoder Driver
> + *
> + * The encoder hardware does not support SECAM.
> + *
> + * Copyright (C) 2009 Texas Instruments Incorporated -
> http://www.ti.com/ + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed .as is. WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/ctype.h>
> +#include <linux/i2c.h>
> +#include <linux/device.h>
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include <linux/videodev2.h>
> +#include <linux/uaccess.h>
> +#include <linux/version.h>
> +
> +#include <media/adv7343.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-chip-ident.h>
> +
> +#include "adv7343_regs.h"
> +
> +MODULE_DESCRIPTION("ADV7343 video encoder driver");
> +MODULE_LICENSE("GPL");
> +
> +static int debug;
> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "Debug level 0-1");
> +
> +struct adv7343_state {
> +	struct v4l2_subdev sd;
> +	u8 reg00;
> +	u8 reg01;
> +	u8 reg02;
> +	u8 reg35;
> +	u8 reg80;
> +	u8 reg82;
> +	int bright;
> +	int hue;
> +	int gain;
> +	u32 output;
> +	v4l2_std_id std;
> +};
> +
> +static inline struct adv7343_state *to_state(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct adv7343_state, sd);
> +}
> +
> +static inline int adv7343_write(struct v4l2_subdev *sd, u8 reg, u8
> value) +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	return i2c_smbus_write_byte_data(client, reg, value);
> +}
> +
> +static const u8 adv7343_init_reg_val[] = {
> +	ADV7343_SOFT_RESET, ADV7343_SOFT_RESET_DEFAULT,
> +	ADV7343_POWER_MODE_REG, ADV7343_POWER_MODE_REG_DEFAULT,
> +
> +	ADV7343_HD_MODE_REG1, ADV7343_HD_MODE_REG1_DEFAULT,
> +	ADV7343_HD_MODE_REG2, ADV7343_HD_MODE_REG2_DEFAULT,
> +	ADV7343_HD_MODE_REG3, ADV7343_HD_MODE_REG3_DEFAULT,
> +	ADV7343_HD_MODE_REG4, ADV7343_HD_MODE_REG4_DEFAULT,
> +	ADV7343_HD_MODE_REG5, ADV7343_HD_MODE_REG5_DEFAULT,
> +	ADV7343_HD_MODE_REG6, ADV7343_HD_MODE_REG6_DEFAULT,
> +	ADV7343_HD_MODE_REG7, ADV7343_HD_MODE_REG7_DEFAULT,
> +
> +	ADV7343_SD_MODE_REG1, ADV7343_SD_MODE_REG1_DEFAULT,
> +	ADV7343_SD_MODE_REG2, ADV7343_SD_MODE_REG2_DEFAULT,
> +	ADV7343_SD_MODE_REG3, ADV7343_SD_MODE_REG3_DEFAULT,
> +	ADV7343_SD_MODE_REG4, ADV7343_SD_MODE_REG4_DEFAULT,
> +	ADV7343_SD_MODE_REG5, ADV7343_SD_MODE_REG5_DEFAULT,
> +	ADV7343_SD_MODE_REG6, ADV7343_SD_MODE_REG6_DEFAULT,
> +	ADV7343_SD_MODE_REG7, ADV7343_SD_MODE_REG7_DEFAULT,
> +	ADV7343_SD_MODE_REG8, ADV7343_SD_MODE_REG8_DEFAULT,
> +
> +	ADV7343_SD_HUE_REG, ADV7343_SD_HUE_REG_DEFAULT,
> +	ADV7343_SD_CGMS_WSS0, ADV7343_SD_CGMS_WSS0_DEFAULT,
> +	ADV7343_SD_BRIGHTNESS_WSS, ADV7343_SD_BRIGHTNESS_WSS_DEFAULT,
> +};
> +
> +static const struct adv7343_std_info
> +	adv7343_composite_std_info[] = {
> +	{
> +		SD_STD_NTSC, 0x1F, 0x7C, 0xF0, 0x21, V4L2_STD_NTSC,
> +	},
> +	{
> +		SD_STD_PAL_BDGHI, 0xCB, 0x8A, 0x09, 0x2A, V4L2_STD_PAL,
> +	},
> +};
> +
> +static const struct adv7343_std_info
> +	adv7343_component_std_info[] = {
> +	{
> +		SD_STD_NTSC, 0x1F, 0x7C, 0xF0, 0x21, V4L2_STD_NTSC,
> +	},
> +	{
> +		SD_STD_PAL_BDGHI, 0x1F, 0x7C, 0xF0, 0x21, V4L2_STD_PAL,
> +	},
> +};
> +
> +static int adv7343_setstd(struct v4l2_subdev *sd, v4l2_std_id std)
> +{
> +	struct adv7343_state *state = to_state(sd);
> +	struct adv7343_std_info *std_info;
> +	int output_idx, num_std;
> +	char *fsc_ptr;
> +	u8 reg, val;
> +	int err = 0;
> +	int i = 0;
> +
> +	output_idx = state->output;
> +
> +	if (output_idx == ADV7343_COMPONENT_ID) {
> +		std_info = (struct adv7343_std_info *)
> +					adv7343_component_std_info;
> +		num_std = ARRAY_SIZE(adv7343_component_std_info);
> +	} else {
> +		std_info = (struct adv7343_std_info *)
> +					adv7343_composite_std_info;
> +		num_std = ARRAY_SIZE(adv7343_composite_std_info);
> +	}
> +
> +	for (i = 0; i < num_std; i++) {
> +		if (std_info[i].stdid & std)
> +			break;
> +	}
> +
> +	if (i == num_std) {
> +		v4l2_dbg(1, debug, sd,
> +				"Invalid std or std is not supported: %llx\n",
> +						(unsigned long long)std);
> +		return -EINVAL;
> +	}
> +
> +	/* Set the standard */
> +	val = state->reg80 & (~(SD_STD_MASK));
> +	val |= std_info[i].standard_val3;
> +	err = adv7343_write(sd, ADV7343_SD_MODE_REG1, val);
> +	if (err < 0)
> +		goto setstd_exit;
> +
> +	state->reg80 = val;
> +
> +	/* Configure the input mode register */
> +	val = state->reg01 & (~((u8) INPUT_MODE_MASK));
> +	val |= SD_INPUT_MODE;
> +	err = adv7343_write(sd, ADV7343_MODE_SELECT_REG, val);
> +	if (err < 0)
> +		goto setstd_exit;
> +
> +	state->reg01 = val;
> +
> +	/* Program the sub carrier frequency registers */
> +	fsc_ptr = &std_info[i].fsc0_val;
> +	reg =  ADV7343_FSC_REG0;
> +	for (i = 0; i < 4; i++, reg++, fsc_ptr++) {
> +		err = adv7343_write(sd, reg, *fsc_ptr);
> +		if (err < 0)
> +			goto setstd_exit;
> +	}
> +
> +	val = state->reg80;
> +
> +	/* Filter settings */
> +	if (std & V4L2_STD_NTSC)
> +		val &= 0x03;
> +	else if (std &  V4L2_STD_PAL)
> +		val |= 0x04;
> +
> +	err = adv7343_write(sd, ADV7343_SD_MODE_REG1, val);
> +	if (err < 0)
> +		goto setstd_exit;
> +
> +	state->reg80 = val;
> +
> +setstd_exit:
> +	if (err != 0)
> +		v4l2_err(sd, "Error setting std, write failed\n");
> +
> +	return err;
> +}
> +
> +static int adv7343_setoutput(struct v4l2_subdev *sd, u32 output_type)
> +{
> +	struct adv7343_state *state = to_state(sd);
> +	unsigned char val;
> +	int err = 0;
> +
> +	if (output_type > ADV7343_SVIDEO_ID) {
> +		v4l2_dbg(1, debug, sd,
> +			"Invalid output type or output type not supported:%d\n",
> +								output_type);
> +		return -EINVAL;
> +	}
> +
> +	/* Enable Appropriate DAC */
> +	val = state->reg00 & 0x03;
> +
> +	if (output_type == ADV7343_COMPOSITE_ID)
> +		val |= ADV7343_COMPOSITE_POWER_VALUE;
> +	else if (output_type == ADV7343_COMPONENT_ID)
> +		val |= ADV7343_COMPONENT_POWER_VALUE;
> +	else
> +		val |= ADV7343_SVIDEO_POWER_VALUE;
> +
> +	err = adv7343_write(sd, ADV7343_POWER_MODE_REG, val);
> +	if (err < 0)
> +		goto setoutput_exit;
> +
> +	state->reg00 = val;
> +
> +	/* Enable YUV output */
> +	val = state->reg02 | YUV_OUTPUT_SELECT;
> +	err = adv7343_write(sd, ADV7343_MODE_REG0, val);
> +	if (err < 0)
> +		goto setoutput_exit;
> +
> +	state->reg02 = val;
> +
> +	/* configure SD DAC Output 2 and SD DAC Output 1 bit to zero */
> +	val = state->reg82 & (SD_DAC_1_DI & SD_DAC_2_DI);
> +	err = adv7343_write(sd, ADV7343_SD_MODE_REG2, val);
> +	if (err < 0)
> +		goto setoutput_exit;
> +
> +	state->reg82 = val;
> +
> +	/* configure ED/HD Color DAC Swap and ED/HD RGB Input Enable bit to
> +	 * zero */
> +	val = state->reg35 & (HD_RGB_INPUT_DI & HD_DAC_SWAP_DI);
> +	err = adv7343_write(sd, ADV7343_HD_MODE_REG6, val);
> +	if (err < 0)
> +		goto setoutput_exit;
> +
> +	state->reg35 = val;
> +
> +setoutput_exit:
> +	if (err != 0)
> +		v4l2_err(sd, "Error setting output, write failed\n");
> +
> +	return err;
> +}
> +
> +static int adv7343_log_status(struct v4l2_subdev *sd)
> +{
> +	struct adv7343_state *state = to_state(sd);
> +
> +	v4l2_info(sd, "Standard: %llx\n", (unsigned long long)state->std);
> +	v4l2_info(sd, "Output: %s\n", (state->output == 0) ? "Composite" :
> +			((state->output == 1) ? "Component" : "S-Video"));
> +	return 0;
> +}
> +
> +static int adv7343_queryctrl(struct v4l2_subdev *sd, struct
> v4l2_queryctrl *qc) +{
> +	switch (qc->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		return v4l2_ctrl_query_fill(qc, ADV7343_BRIGHTNESS_MIN,
> +						ADV7343_BRIGHTNESS_MAX, 1,
> +						ADV7343_BRIGHTNESS_DEF);
> +	case V4L2_CID_HUE:
> +		return v4l2_ctrl_query_fill(qc, ADV7343_HUE_MIN,
> +						ADV7343_HUE_MAX, 1 ,
> +						ADV7343_HUE_DEF);
> +	case V4L2_CID_GAIN:
> +		return v4l2_ctrl_query_fill(qc, ADV7343_GAIN_MIN,
> +						ADV7343_GAIN_MAX, 1,
> +						ADV7343_GAIN_DEF);
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int adv7343_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control
> *ctrl) +{
> +	struct adv7343_state *state = to_state(sd);
> +	int err = 0;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		if (ctrl->value < ADV7343_BRIGHTNESS_MIN ||
> +					ctrl->value > ADV7343_BRIGHTNESS_MAX) {
> +			v4l2_dbg(1, debug, sd,
> +					"invalid brightness settings %d\n",
> +								ctrl->value);
> +			return -ERANGE;
> +		}
> +
> +		state->bright = ctrl->value;
> +		err = adv7343_write(sd, ADV7343_SD_BRIGHTNESS_WSS,
> +					state->bright);
> +		break;
> +
> +	case V4L2_CID_HUE:
> +		if (ctrl->value < ADV7343_HUE_MIN ||
> +					ctrl->value > ADV7343_HUE_MAX) {
> +			v4l2_dbg(1, debug, sd, "invalid hue settings %d\n",
> +								ctrl->value);
> +			return -ERANGE;
> +		}
> +
> +		state->hue = ctrl->value;
> +		err = adv7343_write(sd, ADV7343_SD_HUE_REG, state->hue);
> +		break;
> +
> +	case V4L2_CID_GAIN:
> +		if (ctrl->value < ADV7343_GAIN_MIN ||
> +					ctrl->value > ADV7343_GAIN_MAX) {
> +			v4l2_dbg(1, debug, sd, "invalid gain settings %d\n",
> +								ctrl->value);
> +			return -ERANGE;
> +		}
> +
> +		if ((ctrl->value > POSITIVE_GAIN_MAX) &&
> +			(ctrl->value < NEGATIVE_GAIN_MIN)) {
> +			v4l2_dbg(1, debug, sd,
> +				"gain settings not within the specified range\n");
> +			return -ERANGE;
> +		}
> +
> +		state->gain = ctrl->value;
> +		err = adv7343_write(sd, ADV7343_DAC2_OUTPUT_LEVEL, state->gain);
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (err < 0)
> +		v4l2_err(sd, "Failed to set the encoder controls\n");
> +
> +	return err;
> +}
> +
> +static int adv7343_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control
> *ctrl) +{
> +	struct adv7343_state *state = to_state(sd);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		ctrl->value = state->bright;
> +		break;
> +
> +	case V4L2_CID_HUE:
> +		ctrl->value = state->hue;
> +		break;
> +
> +	case V4L2_CID_GAIN:
> +		ctrl->value = state->gain;
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int adv7343_g_chip_ident(struct v4l2_subdev *sd,
> +				struct v4l2_dbg_chip_ident *chip)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7343, 0);
> +}
> +
> +static const struct v4l2_subdev_core_ops adv7343_core_ops = {
> +	.log_status	= adv7343_log_status,
> +	.g_chip_ident	= adv7343_g_chip_ident,
> +	.g_ctrl		= adv7343_g_ctrl,
> +	.s_ctrl		= adv7343_s_ctrl,
> +	.queryctrl	= adv7343_queryctrl,
> +};
> +
> +static int adv7343_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
> +{
> +	struct adv7343_state *state = to_state(sd);
> +	int err = 0;
> +
> +	if (state->std == std)
> +		return 0;
> +
> +	err = adv7343_setstd(sd, std);
> +	if (!err)
> +		state->std = std;
> +
> +	return err;
> +}
> +
> +static int adv7343_s_routing(struct v4l2_subdev *sd,
> +				const struct v4l2_routing *route)
> +{
> +	struct adv7343_state *state = to_state(sd);
> +	int err = 0;
> +
> +	if (state->output == route->output)
> +		return 0;
> +
> +	err = adv7343_setoutput(sd, route->output);
> +	if (!err)
> +		state->output = route->output;
> +
> +	return err;
> +}
> +
> +static const struct v4l2_subdev_video_ops adv7343_video_ops = {
> +	.s_std_output	= adv7343_s_std_output,
> +	.s_routing	= adv7343_s_routing,
> +};
> +
> +static const struct v4l2_subdev_ops adv7343_ops = {
> +	.core	= &adv7343_core_ops,
> +	.video	= &adv7343_video_ops,
> +};
> +
> +static int adv7343_initialize(struct v4l2_subdev *sd)
> +{
> +	struct adv7343_state *state = to_state(sd);
> +	int err = 0;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(adv7343_init_reg_val); i += 2) {
> +
> +		err = adv7343_write(sd, adv7343_init_reg_val[i],
> +					adv7343_init_reg_val[i+1]);
> +		if (err) {
> +			v4l2_err(sd, "Error initializing\n");
> +			return err;
> +		}
> +	}
> +
> +	/* Configure for default video standard */
> +	err = adv7343_setoutput(sd, state->output);
> +	if (err < 0) {
> +		v4l2_err(sd, "Error setting output during init\n");
> +		return -EINVAL;
> +	}
> +
> +	err = adv7343_setstd(sd, state->std);
> +	if (err < 0) {
> +		v4l2_err(sd, "Error setting std during init\n");
> +		return -EINVAL;
> +	}
> +
> +	return err;
> +}
> +
> +static int adv7343_probe(struct i2c_client *client,
> +				const struct i2c_device_id *id)
> +{
> +	struct adv7343_state *state;
> +
> +	if (!i2c_check_functionality(client->adapter,
> I2C_FUNC_SMBUS_BYTE_DATA)) +		return -ENODEV;
> +
> +	v4l_info(client, "chip found @ 0x%x (%s)\n",
> +			client->addr << 1, client->adapter->name);
> +
> +	state = kzalloc(sizeof(struct adv7343_state), GFP_KERNEL);
> +	if (state == NULL)
> +		return -ENOMEM;
> +
> +	state->reg00	= 0x80;
> +	state->reg01	= 0x00;
> +	state->reg02	= 0x20;
> +	state->reg35	= 0x00;
> +	state->reg80	= ADV7343_SD_MODE_REG1_DEFAULT;
> +	state->reg82	= ADV7343_SD_MODE_REG2_DEFAULT;
> +
> +	state->output = ADV7343_COMPOSITE_ID;
> +	state->std = V4L2_STD_NTSC;
> +
> +	v4l2_i2c_subdev_init(&state->sd, client, &adv7343_ops);
> +	return adv7343_initialize(&state->sd);
> +}
> +
> +static int adv7343_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	kfree(to_state(sd));
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id adv7343_id[] = {
> +	{"adv7343", 0},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, adv7343_id);
> +
> +static struct i2c_driver adv7343_driver = {
> +	.driver = {
> +		.owner	= THIS_MODULE,
> +		.name	= "adv7343",
> +	},
> +	.probe		= adv7343_probe,
> +	.remove		= adv7343_remove,
> +	.id_table	= adv7343_id,
> +};
> +
> +static __init int init_adv7343(void)
> +{
> +	return i2c_add_driver(&adv7343_driver);
> +}
> +
> +static __exit void exit_adv7343(void)
> +{
> +	i2c_del_driver(&adv7343_driver);
> +}
> +
> +module_init(init_adv7343);
> +module_exit(exit_adv7343);
> diff --git a/drivers/media/video/adv7343_regs.h
> b/drivers/media/video/adv7343_regs.h new file mode 100644
> index 0000000..57572d9
> --- /dev/null
> +++ b/drivers/media/video/adv7343_regs.h
> @@ -0,0 +1,188 @@
> +/*
> + * ADV7343 encoder related structure and register definitions
> + *
> + * Copyright (C) 2009 Texas Instruments Incorporated -
> http://www.ti.com/ + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed .as is. WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef ADV7343_REG_H
> +#define ADV7343_REGS_H
> +
> +struct adv7343_std_info {
> +	u32 standard_val3;
> +	u8 fsc0_val;
> +	u8 fsc1_val;
> +	u8 fsc2_val;
> +	u8 fsc3_val;
> +	v4l2_std_id stdid;
> +};
> +
> +/* Register offset macros */
> +#define ADV7343_POWER_MODE_REG		(0x00)
> +#define ADV7343_MODE_SELECT_REG		(0x01)
> +#define ADV7343_MODE_REG0		(0x02)
> +
> +#define ADV7343_DAC2_OUTPUT_LEVEL	(0x0b)
> +
> +#define ADV7343_SOFT_RESET		(0x17)
> +
> +#define ADV7343_HD_MODE_REG1		(0x30)
> +#define ADV7343_HD_MODE_REG2		(0x31)
> +#define ADV7343_HD_MODE_REG3		(0x32)
> +#define ADV7343_HD_MODE_REG4		(0x33)
> +#define ADV7343_HD_MODE_REG5		(0x34)
> +#define ADV7343_HD_MODE_REG6		(0x35)
> +
> +#define ADV7343_HD_MODE_REG7		(0x39)
> +
> +#define ADV7343_SD_MODE_REG1		(0x80)
> +#define ADV7343_SD_MODE_REG2		(0x82)
> +#define ADV7343_SD_MODE_REG3		(0x83)
> +#define ADV7343_SD_MODE_REG4		(0x84)
> +#define ADV7343_SD_MODE_REG5		(0x86)
> +#define ADV7343_SD_MODE_REG6		(0x87)
> +#define ADV7343_SD_MODE_REG7		(0x88)
> +#define ADV7343_SD_MODE_REG8		(0x89)
> +
> +#define ADV7343_FSC_REG0		(0x8C)
> +#define ADV7343_FSC_REG1		(0x8D)
> +#define ADV7343_FSC_REG2		(0x8E)
> +#define ADV7343_FSC_REG3		(0x8F)
> +
> +#define ADV7343_SD_CGMS_WSS0		(0x99)
> +
> +#define ADV7343_SD_HUE_REG		(0xA0)
> +#define ADV7343_SD_BRIGHTNESS_WSS	(0xA1)
> +
> +/* Default values for the registers */
> +#define ADV7343_POWER_MODE_REG_DEFAULT		(0x10)
> +#define ADV7343_HD_MODE_REG1_DEFAULT		(0x3C)	/* Changed Default
> +							   720p EAVSAV code*/
> +#define ADV7343_HD_MODE_REG2_DEFAULT		(0x01)	/* Changed Pixel data
> +							   valid */
> +#define ADV7343_HD_MODE_REG3_DEFAULT		(0x00)	/* Color delay 0 clks */
> +#define ADV7343_HD_MODE_REG4_DEFAULT		(0xE8)	/* Changed */
> +#define ADV7343_HD_MODE_REG5_DEFAULT		(0x08)
> +#define ADV7343_HD_MODE_REG6_DEFAULT		(0x00)
> +#define ADV7343_HD_MODE_REG7_DEFAULT		(0x00)
> +#define ADV7343_SD_MODE_REG8_DEFAULT		(0x00)
> +#define ADV7343_SOFT_RESET_DEFAULT		(0x02)
> +#define ADV7343_COMPOSITE_POWER_VALUE		(0x80)
> +#define ADV7343_COMPONENT_POWER_VALUE		(0x1C)
> +#define ADV7343_SVIDEO_POWER_VALUE		(0x60)
> +#define ADV7343_SD_HUE_REG_DEFAULT		(127)
> +#define ADV7343_SD_BRIGHTNESS_WSS_DEFAULT	(0x03)
> +
> +#define ADV7343_SD_CGMS_WSS0_DEFAULT		(0x10)
> +
> +#define ADV7343_SD_MODE_REG1_DEFAULT		(0x00)
> +#define ADV7343_SD_MODE_REG2_DEFAULT		(0xC9)
> +#define ADV7343_SD_MODE_REG3_DEFAULT		(0x10)
> +#define ADV7343_SD_MODE_REG4_DEFAULT		(0x01)
> +#define ADV7343_SD_MODE_REG5_DEFAULT		(0x02)
> +#define ADV7343_SD_MODE_REG6_DEFAULT		(0x0C)
> +#define ADV7343_SD_MODE_REG7_DEFAULT		(0x04)
> +#define ADV7343_SD_MODE_REG8_DEFAULT		(0x00)
> +
> +/* Bit masks for Mode Select Register */
> +#define INPUT_MODE_MASK			(0x70)
> +#define SD_INPUT_MODE			(0x00)
> +#define HD_720P_INPUT_MODE		(0x10)
> +#define HD_1080I_INPUT_MODE		(0x10)
> +
> +/* Bit masks for Mode Register 0 */
> +#define TEST_PATTERN_BLACK_BAR_EN	(0x04)
> +#define YUV_OUTPUT_SELECT		(0x20)
> +#define RGB_OUTPUT_SELECT		(0xDF)
> +
> +/* Bit masks for DAC output levels */
> +#define DAC_OUTPUT_LEVEL_MASK		(0xFF)
> +#define POSITIVE_GAIN_MAX		(0x40)
> +#define POSITIVE_GAIN_MIN		(0x00)
> +#define NEGATIVE_GAIN_MAX		(0xFF)
> +#define NEGATIVE_GAIN_MIN		(0xC0)
> +
> +/* Bit masks for soft reset register */
> +#define SOFT_RESET			(0x02)
> +
> +/* Bit masks for HD Mode Register 1 */
> +#define OUTPUT_STD_MASK		(0x03)
> +#define OUTPUT_STD_SHIFT	(0)
> +#define OUTPUT_STD_EIA0_2	(0x00)
> +#define OUTPUT_STD_EIA0_1	(0x01)
> +#define OUTPUT_STD_FULL		(0x02)
> +#define EMBEDDED_SYNC		(0x04)
> +#define EXTERNAL_SYNC		(0xFB)
> +#define STD_MODE_SHIFT		(3)
> +#define STD_MODE_MASK		(0x1F)
> +#define STD_MODE_720P		(0x05)
> +#define STD_MODE_720P_25	(0x08)
> +#define STD_MODE_720P_30	(0x07)
> +#define STD_MODE_720P_50	(0x06)
> +#define STD_MODE_1080I		(0x0D)
> +#define STD_MODE_1080I_25fps	(0x0E)
> +#define STD_MODE_1080P_24	(0x12)
> +#define STD_MODE_1080P_25	(0x10)
> +#define STD_MODE_1080P_30	(0x0F)
> +#define STD_MODE_525P		(0x00)
> +#define STD_MODE_625P		(0x03)
> +
> +/* Bit masks for SD Mode Register 1 */
> +#define SD_STD_MASK		(0x03)
> +#define SD_STD_NTSC		(0x00)
> +#define SD_STD_PAL_BDGHI	(0x01)
> +#define SD_STD_PAL_M		(0x02)
> +#define SD_STD_PAL_N		(0x03)
> +#define SD_LUMA_FLTR_MASK	(0x7)
> +#define SD_LUMA_FLTR_SHIFT	(0x2)
> +#define SD_CHROMA_FLTR_MASK	(0x7)
> +#define SD_CHROMA_FLTR_SHIFT	(0x5)
> +
> +/* Bit masks for SD Mode Register 2 */
> +#define SD_PBPR_SSAF_EN		(0x01)
> +#define SD_PBPR_SSAF_DI		(0xFE)
> +#define SD_DAC_1_DI		(0xFD)
> +#define SD_DAC_2_DI		(0xFB)
> +#define SD_PEDESTAL_EN		(0x08)
> +#define SD_PEDESTAL_DI		(0xF7)
> +#define SD_SQUARE_PIXEL_EN	(0x10)
> +#define SD_SQUARE_PIXEL_DI	(0xEF)
> +#define SD_PIXEL_DATA_VALID	(0x40)
> +#define SD_ACTIVE_EDGE_EN	(0x80)
> +#define SD_ACTIVE_EDGE_DI	(0x7F)
> +
> +/* Bit masks for HD Mode Register 6 */
> +#define HD_RGB_INPUT_EN		(0x02)
> +#define HD_RGB_INPUT_DI		(0xFD)
> +#define HD_PBPR_SYNC_EN		(0x04)
> +#define HD_PBPR_SYNC_DI		(0xFB)
> +#define HD_DAC_SWAP_EN		(0x08)
> +#define HD_DAC_SWAP_DI		(0xF7)
> +#define HD_GAMMA_CURVE_A	(0xEF)
> +#define HD_GAMMA_CURVE_B	(0x10)
> +#define HD_GAMMA_EN		(0x20)
> +#define HD_GAMMA_DI		(0xDF)
> +#define HD_ADPT_FLTR_MODEB	(0x40)
> +#define HD_ADPT_FLTR_MODEA	(0xBF)
> +#define HD_ADPT_FLTR_EN		(0x80)
> +#define HD_ADPT_FLTR_DI		(0x7F)
> +
> +#define ADV7343_BRIGHTNESS_MAX	(127)
> +#define ADV7343_BRIGHTNESS_MIN	(0)
> +#define ADV7343_BRIGHTNESS_DEF	(3)
> +#define ADV7343_HUE_MAX		(255)
> +#define ADV7343_HUE_MIN		(0)
> +#define ADV7343_HUE_DEF		(127)
> +#define ADV7343_GAIN_MAX	(255)
> +#define ADV7343_GAIN_MIN	(0)
> +#define ADV7343_GAIN_DEF	(0)
> +
> +#endif
> diff --git a/include/media/adv7343.h b/include/media/adv7343.h
> new file mode 100644
> index 0000000..d6f8a4e
> --- /dev/null
> +++ b/include/media/adv7343.h
> @@ -0,0 +1,23 @@
> +/*
> + * ADV7343 header file
> + *
> + * Copyright (C) 2009 Texas Instruments Incorporated -
> http://www.ti.com/ + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed .as is. WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef ADV7343_H
> +#define ADV7343_H
> +
> +#define ADV7343_COMPOSITE_ID	(0)
> +#define ADV7343_COMPONENT_ID	(1)
> +#define ADV7343_SVIDEO_ID	(2)
> +
> +#endif				/* End of #ifndef ADV7343_H */
> diff --git a/include/media/v4l2-chip-ident.h
> b/include/media/v4l2-chip-ident.h index 1be461a..66cd877 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -137,6 +137,9 @@ enum {
>  	/* module saa7191: just ident 7191 */
>  	V4L2_IDENT_SAA7191 = 7191,
>
> +	/* module adv7343: just ident 7343 */
> +	V4L2_IDENT_ADV7343 = 7343,
> +
>  	/* module wm8739: just ident 8739 */
>  	V4L2_IDENT_WM8739 = 8739,



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
