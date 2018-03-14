Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:25158 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750779AbeCNWar (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 18:30:47 -0400
Date: Thu, 15 Mar 2018 00:30:43 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Andy Yeh <andy.yeh@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        jasonx.z.chen@intel.com, alanx.chiang@intel.com, jim.lai@intel.com
Subject: Re: [PATCH v8] media: imx258: Add imx258 camera sensor driver
Message-ID: <20180314223042.4t2thym5tspxfio3@kekkonen.localdomain>
References: <1521044659-12598-1-git-send-email-andy.yeh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1521044659-12598-1-git-send-email-andy.yeh@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thanks for the update. Two minor comments below.

On Thu, Mar 15, 2018 at 12:24:19AM +0800, Andy Yeh wrote:
...
> +static int imx258_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct imx258 *imx258 =
> +		container_of(ctrl->handler, struct imx258, ctrl_handler);
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
> +	int ret = 0;
> +
> +	/*
> +	 * Applying V4L2 control value only happens
> +	 * when power is up for streaming
> +	 */
> +	if (pm_runtime_get_if_in_use(&client->dev) == 0)
> +		return 0;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_ANALOGUE_GAIN:
> +		ret = imx258_write_reg(imx258, IMX258_REG_ANALOG_GAIN,
> +				IMX258_REG_VALUE_16BIT,
> +				ctrl->val);
> +		break;
> +	case V4L2_CID_EXPOSURE:
> +		ret = imx258_write_reg(imx258, IMX258_REG_EXPOSURE,
> +				IMX258_REG_VALUE_16BIT,
> +				ctrl->val);
> +		break;
> +	case V4L2_CID_DIGITAL_GAIN:
> +		ret = imx258_update_digital_gain(imx258, IMX258_REG_VALUE_16BIT,
> +				ctrl->val);
> +		break;
> +	case V4L2_CID_VBLANK:
> +		/*
> +		 * Auto Frame Length Line Control is enabled by default.
> +		 * Not need control Vblank Register.
> +		 */
> +		break;
> +	default:
> +		dev_info(&client->dev,
> +			 "ctrl(id:0x%x,val:0x%x) is not handled\n",
> +			 ctrl->id, ctrl->val);

As this is an error, I'd set ret to e.g. -EINVAL here.

> +		break;
> +	}
> +
> +	pm_runtime_put(&client->dev);
> +
> +	return ret;
> +}

...

> +/* Initialize control handlers */
> +static int imx258_init_controls(struct imx258 *imx258)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
> +	struct v4l2_ctrl_handler *ctrl_hdlr;
> +	s64 exposure_max;
> +	s64 vblank_def;
> +	s64 vblank_min;
> +	s64 pixel_rate_min;
> +	s64 pixel_rate_max;
> +	int ret;
> +
> +	ctrl_hdlr = &imx258->ctrl_handler;
> +	ret = v4l2_ctrl_handler_init(ctrl_hdlr, 8);
> +	if (ret)
> +		return ret;
> +
> +	mutex_init(&imx258->mutex);
> +	ctrl_hdlr->lock = &imx258->mutex;
> +	imx258->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr,
> +				&imx258_ctrl_ops,
> +				V4L2_CID_LINK_FREQ,
> +				ARRAY_SIZE(link_freq_menu_items) - 1,
> +				0,
> +				link_freq_menu_items);
> +
> +	if (imx258->link_freq)
> +		imx258->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> +
> +	pixel_rate_max = link_freq_to_pixel_rate(link_freq_menu_items[0]);
> +	pixel_rate_min = link_freq_to_pixel_rate(link_freq_menu_items[1]);
> +	/* By default, PIXEL_RATE is read only */
> +	imx258->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &imx258_ctrl_ops,
> +					V4L2_CID_PIXEL_RATE,
> +					pixel_rate_min, pixel_rate_max,
> +					1, pixel_rate_max);
> +
> +
> +	vblank_def = imx258->cur_mode->vts_def - imx258->cur_mode->height;
> +	vblank_min = imx258->cur_mode->vts_min - imx258->cur_mode->height;
> +	imx258->vblank = v4l2_ctrl_new_std(
> +				ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_VBLANK,
> +				vblank_min,
> +				IMX258_VTS_MAX - imx258->cur_mode->height, 1,
> +				vblank_def);
> +
> +	imx258->hblank = v4l2_ctrl_new_std(
> +				ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_HBLANK,
> +				IMX258_PPL_DEFAULT - imx258->cur_mode->width,
> +				IMX258_PPL_DEFAULT - imx258->cur_mode->width,
> +				1,
> +				IMX258_PPL_DEFAULT - imx258->cur_mode->width);
> +
> +	if (!imx258->hblank) {

Could you align handling for NULL hblank control with NULL link_freq above?

> +		ret = -EINVAL;
> +		goto error;
> +	}
> +
> +	imx258->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> +
> +	exposure_max = imx258->cur_mode->vts_def - 8;
> +	imx258->exposure = v4l2_ctrl_new_std(
> +				ctrl_hdlr, &imx258_ctrl_ops,
> +				V4L2_CID_EXPOSURE, IMX258_EXPOSURE_MIN,
> +				IMX258_EXPOSURE_MAX, IMX258_EXPOSURE_STEP,
> +				IMX258_EXPOSURE_DEFAULT);
> +
> +	v4l2_ctrl_new_std(ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
> +				IMX258_ANA_GAIN_MIN, IMX258_ANA_GAIN_MAX,
> +				IMX258_ANA_GAIN_STEP, IMX258_ANA_GAIN_DEFAULT);
> +
> +	v4l2_ctrl_new_std(ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_DIGITAL_GAIN,
> +				IMX258_DGTL_GAIN_MIN, IMX258_DGTL_GAIN_MAX,
> +				IMX258_DGTL_GAIN_STEP,
> +				IMX258_DGTL_GAIN_DEFAULT);
> +
> +	v4l2_ctrl_new_std_menu_items(ctrl_hdlr, &imx258_ctrl_ops,
> +				     V4L2_CID_TEST_PATTERN,
> +				     ARRAY_SIZE(imx258_test_pattern_menu) - 1,
> +				     0, 0, imx258_test_pattern_menu);
> +
> +	if (ctrl_hdlr->error) {
> +		ret = ctrl_hdlr->error;
> +		dev_err(&client->dev, "%s control init failed (%d)\n",
> +			__func__, ret);
> +		goto error;
> +	}
> +
> +	imx258->sd.ctrl_handler = ctrl_hdlr;
> +
> +	return 0;
> +
> +error:
> +	v4l2_ctrl_handler_free(ctrl_hdlr);
> +	mutex_destroy(&imx258->mutex);
> +
> +	return ret;
> +}

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
