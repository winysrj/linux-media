Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4826 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaE1JJY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 05:09:24 -0400
Message-ID: <5385A798.8060707@xs4all.nl>
Date: Wed, 28 May 2014 11:08:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] smiapp: Implement the test pattern control
References: <1401194628-31679-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1401194628-31679-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/27/14 14:43, Sakari Ailus wrote:
> Add support for the V4L2_CID_TEST_PATTERN control. When the solid colour
> mode is selected, additional controls become available for setting the
> solid four solid colour components.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 120 +++++++++++++++++++++++++++++++--
>  drivers/media/i2c/smiapp/smiapp.h      |   4 ++
>  2 files changed, 120 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index 446c82c..025342c 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -32,6 +32,7 @@
>  #include <linux/gpio.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> +#include <linux/smiapp.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/v4l2-mediabus.h>
>  #include <media/v4l2-device.h>
> @@ -404,6 +405,52 @@ static void smiapp_update_mbus_formats(struct smiapp_sensor *sensor)
>  		pixel_order_str[pixel_order]);
>  }
>  
> +static const char * const smiapp_test_patterns[] = {
> +	"Disabled",
> +	"Solid colour",
> +	"Eight vertical colour bars",
> +	"Colour bars with fade to grey",
> +	"Pseudorandom sequence (PN9)",
> +};

Capitalize the strings (same rules as are used for book titles in english).

> +
> +static const struct v4l2_ctrl_ops smiapp_ctrl_ops;
> +
> +static struct v4l2_ctrl_config
> +smiapp_test_pattern_colours[SMIAPP_COLOUR_COMPONENTS] = {
> +	{
> +		&smiapp_ctrl_ops,
> +		V4L2_CID_SMIAPP_TEST_PATTERN_RED,
> +		"Solid red pixel value",
> +		V4L2_CTRL_TYPE_INTEGER,
> +		0, 0, 1, 0,
> +		V4L2_CTRL_FLAG_INACTIVE, 0, NULL, NULL, 0
> +	},
> +	{
> +		&smiapp_ctrl_ops,
> +		V4L2_CID_SMIAPP_TEST_PATTERN_GREENR,
> +		"Solid green (red) pixel value",
> +		V4L2_CTRL_TYPE_INTEGER,
> +		0, 0, 1, 0,
> +		V4L2_CTRL_FLAG_INACTIVE, 0, NULL, NULL, 0
> +	},
> +	{
> +		&smiapp_ctrl_ops,
> +		V4L2_CID_SMIAPP_TEST_PATTERN_BLUE,
> +		"Solid blue pixel value",
> +		V4L2_CTRL_TYPE_INTEGER,
> +		0, 0, 1, 0,
> +		V4L2_CTRL_FLAG_INACTIVE, 0, NULL, NULL, 0
> +	},
> +	{
> +		&smiapp_ctrl_ops,
> +		V4L2_CID_SMIAPP_TEST_PATTERN_GREENB,
> +		"Solid green (blue) pixel value",
> +		V4L2_CTRL_TYPE_INTEGER,
> +		0, 0, 1, 0,
> +		V4L2_CTRL_FLAG_INACTIVE, 0, NULL, NULL, 0
> +	},
> +};

Ditto for the control names.

After that you can add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> +
>  static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct smiapp_sensor *sensor =
> @@ -477,6 +524,35 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
>  
>  		return smiapp_pll_update(sensor);
>  
> +	case V4L2_CID_TEST_PATTERN: {
> +		unsigned int i;
> +
> +		for (i = 0; i < ARRAY_SIZE(smiapp_test_pattern_colours); i++)
> +			v4l2_ctrl_activate(
> +				sensor->test_data[i],
> +				ctrl->val ==
> +				V4L2_SMIAPP_TEST_PATTERN_MODE_SOLID_COLOUR);
> +
> +		return smiapp_write(
> +			sensor, SMIAPP_REG_U16_TEST_PATTERN_MODE, ctrl->val);
> +	}
> +
> +	case V4L2_CID_SMIAPP_TEST_PATTERN_RED:
> +		return smiapp_write(
> +			sensor, SMIAPP_REG_U16_TEST_DATA_RED, ctrl->val);
> +
> +	case V4L2_CID_SMIAPP_TEST_PATTERN_GREENR:
> +		return smiapp_write(
> +			sensor, SMIAPP_REG_U16_TEST_DATA_GREENR, ctrl->val);
> +
> +	case V4L2_CID_SMIAPP_TEST_PATTERN_BLUE:
> +		return smiapp_write(
> +			sensor, SMIAPP_REG_U16_TEST_DATA_BLUE, ctrl->val);
> +
> +	case V4L2_CID_SMIAPP_TEST_PATTERN_GREENB:
> +		return smiapp_write(
> +			sensor, SMIAPP_REG_U16_TEST_DATA_GREENB, ctrl->val);
> +
>  	default:
>  		return -EINVAL;
>  	}
> @@ -489,10 +565,10 @@ static const struct v4l2_ctrl_ops smiapp_ctrl_ops = {
>  static int smiapp_init_controls(struct smiapp_sensor *sensor)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> -	unsigned int max;
> +	unsigned int max, i;
>  	int rval;
>  
> -	rval = v4l2_ctrl_handler_init(&sensor->pixel_array->ctrl_handler, 7);
> +	rval = v4l2_ctrl_handler_init(&sensor->pixel_array->ctrl_handler, 12);
>  	if (rval)
>  		return rval;
>  	sensor->pixel_array->ctrl_handler.lock = &sensor->mutex;
> @@ -535,6 +611,17 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
>  		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
>  		V4L2_CID_PIXEL_RATE, 0, 0, 1, 0);
>  
> +	v4l2_ctrl_new_std_menu_items(&sensor->pixel_array->ctrl_handler,
> +				     &smiapp_ctrl_ops, V4L2_CID_TEST_PATTERN,
> +				     ARRAY_SIZE(smiapp_test_patterns) - 1,
> +				     0, 0, smiapp_test_patterns);
> +
> +	for (i = 0; i < ARRAY_SIZE(smiapp_test_pattern_colours); i++)
> +		sensor->test_data[i] =
> +			v4l2_ctrl_new_custom(&sensor->pixel_array->ctrl_handler,
> +					     &smiapp_test_pattern_colours[i],
> +					     NULL);
> +
>  	if (sensor->pixel_array->ctrl_handler.error) {
>  		dev_err(&client->dev,
>  			"pixel array controls initialization failed (%d)\n",
> @@ -543,6 +630,14 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
>  		goto error;
>  	}
>  
> +	for (i = 0; i < ARRAY_SIZE(smiapp_test_pattern_colours); i++) {
> +		struct v4l2_ctrl *ctrl = sensor->test_data[i];
> +
> +		ctrl->maximum =
> +			ctrl->default_value =
> +			ctrl->cur.val = (1 << sensor->csi_format->width) - 1;
> +	}
> +
>  	sensor->pixel_array->sd.ctrl_handler =
>  		&sensor->pixel_array->ctrl_handler;
>  
> @@ -1670,17 +1765,34 @@ static int smiapp_set_format(struct v4l2_subdev *subdev,
>  	if (fmt->pad == ssd->source_pad) {
>  		u32 code = fmt->format.code;
>  		int rval = __smiapp_get_format(subdev, fh, fmt);
> +		bool range_changed = false;
> +		unsigned int i;
>  
>  		if (!rval && subdev == &sensor->src->sd) {
>  			const struct smiapp_csi_data_format *csi_format =
>  				smiapp_validate_csi_data_format(sensor, code);
> -			if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +
> +			if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +				if (csi_format->width !=
> +				    sensor->csi_format->width)
> +					range_changed = true;
> +
>  				sensor->csi_format = csi_format;
> +			}
> +
>  			fmt->format.code = csi_format->code;
>  		}
>  
>  		mutex_unlock(&sensor->mutex);
> -		return rval;
> +		if (rval || !range_changed)
> +			return rval;
> +
> +		for (i = 0; i < ARRAY_SIZE(smiapp_test_pattern_colours); i++)
> +			v4l2_ctrl_modify_range(
> +				sensor->test_data[i],
> +				0, (1 << sensor->csi_format->width) - 1, 1, 0);
> +
> +		return 0;
>  	}
>  
>  	/* Sink pad. Width and height are changeable here. */
> diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
> index 7cc5aae..874b49f 100644
> --- a/drivers/media/i2c/smiapp/smiapp.h
> +++ b/drivers/media/i2c/smiapp/smiapp.h
> @@ -54,6 +54,8 @@
>  	(1000 +	(SMIAPP_RESET_DELAY_CLOCKS * 1000	\
>  		 + (clk) / 1000 - 1) / ((clk) / 1000))
>  
> +#define SMIAPP_COLOUR_COMPONENTS	4
> +
>  #include "smiapp-limits.h"
>  
>  struct smiapp_quirk;
> @@ -241,6 +243,8 @@ struct smiapp_sensor {
>  	/* src controls */
>  	struct v4l2_ctrl *link_freq;
>  	struct v4l2_ctrl *pixel_rate_csi;
> +	/* test pattern colour components */
> +	struct v4l2_ctrl *test_data[SMIAPP_COLOUR_COMPONENTS];
>  };
>  
>  #define to_smiapp_subdev(_sd)				\
> 

