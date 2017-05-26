Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:52580 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1948809AbdEZWxh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 18:53:37 -0400
From: "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Subject: RE: [PATCH 1/1] [media] i2c: add support for OV13858 sensor
Date: Fri, 26 May 2017 22:53:30 +0000
Message-ID: <7A4F467111FEF64486F40DFE7DF3500A03E998E5@ORSMSX111.amr.corp.intel.com>
References: <1495583908-2479-1-git-send-email-hyungwoo.yang@intel.com>
 <20170524125111.GJ29527@valkosipuli.retiisi.org.uk>
 <7A4F467111FEF64486F40DFE7DF3500A03E99242@ORSMSX111.amr.corp.intel.com>
 <20170526215003.GS29527@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170526215003.GS29527@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

I've submitted V2 yesterday. If possible, can you review that one also ?
I'm learning many things from your review comments.

I think in V2, I've addressed most of comments except raw bayer format.

For ray bayer format, for now, I intentionally don't support crop since it requires more complexity to meet request from _set_pad_format() while keeping FOV for the resolutions with the same ratio(4:3 or 16:9).
Yes, it is hacky but I thought it's OK unless there's a need to support crop. Hm..... I'm thinking drop "bayer order change" since it is not that meaningful. Should I ?

For VBLANK, I realized I made wrong comments just after I send it. Yeas, it shouldn't be read-only. So you can see that VBLANK I added in V2 is NOT read-only. 

Thanks,
Hyungwoo


> Hi Hyungwoo,
> 
> On Wed, May 24, 2017 at 11:13:50PM +0000, Yang, Hyungwoo wrote:
> ...
> > > > +static inline int ov13858_write_reg_list(struct ov13858 *ov13858,
> > > 
> > > I'd drop inline.
> > 
> > if it's not mandatory for upstream, I prefer to keep inline for people 
> > who want to port this with a not-good-compiler. Is it mandatory ?
> 
> I don't think you'd really lose anything if the compiler didn't inline it.
> It's a non-issue anyway.
> 
> ...
> 
> > > > +/*
> > > > + * Change the bayer order to meet the requested one.
> > > > + */
> > > > +static int ov13858_apply_bayer_order(struct ov13858 *ov13858) {
> > > > +	int ret;
> > > > +
> > > > +	switch (ov13858->cur_bayer_format) {
> > > > +	case MEDIA_BUS_FMT_SGRBG10_1X10:
> > > > +		break;
> > > > +	case MEDIA_BUS_FMT_SRGGB10_1X10:
> > > > +		return ov13858_increase_offset(ov13858, OV13858_REG_H_OFFSET);
> > > > +	case MEDIA_BUS_FMT_SGBRG10_1X10:
> > > > +		ret = ov13858_increase_offset(ov13858, OV13858_REG_H_OFFSET);
> > > 
> > > The bayer pixel order is defined by cropping the pixel array. If the sensor can do that, you should implement support for the crop selection rectangle instead.
> > 
> > Sorry, I'm new to imaging world but, as you can see, bayer order in 
> > this sensor IS DEFINED by both cropping and offset(where you start to 
> > read). Is there a strict (implicit or explicit) rule or specific 
> > reason that we should use only crop to apply expected bayer order, 
> > even though the bayer order in the sensor is defined by both crop and offset ?
> > 
> > Anyway, I changed H_/V_OFFSET(0x3810, 0x3812) to 
> > H_/V_CROP_START(0x3800,
> > 0x3802) with no changes in initial values.
> 
> The CROP selection rectangle is the interface to configure crop an area from the parent rectangle (NATIVE_SIZE in this case). Using the format to change cropping in pre-defined ways is quite hackish.
> 
> ...
> 
> > > > +/* Exposure control */
> > > > +static int ov13858_update_exposure(struct ov13858 *ov13858,
> > > > +				   struct v4l2_ctrl *ctrl)
> > > > +{
> > > > +	int ret;
> > > > +	u32 exposure, new_vts = 0;
> > > > +
> > > > +	exposure = ctrl->val;
> > > > +	if (exposure > ov13858->cur_mode->vts - 8)
> > > > +		new_vts = exposure + 8;
> > > > +	else
> > > > +		new_vts = ov13858->cur_mode->vts;
> > > 
> > > Instead of changing the vertical blanking interval implicitly, could 
> > > you do it explicitly though the VBLANK control instead?
> > > 
> > > As you do already control the vertical sync and provide the pixel 
> > > rate control, how about adding a HBLANK control as well? I suppose 
> > > it could be added later on as well. And presumably will be read only.
> > 
> > I'll introduce VBLANK control with READ ONLY and the value of the 
> > control will be updated here.
> 
> HBLANK would be read-only since the register list that you have might contain dependencies to the horizontal blanking so you can't change that.
> The VBLANK control, instead, should not be read-only to allow controlling the frame rate and also controlling the exposure without affecting the frame rate.
> 
> > 
> > > 
> > > > +
> > > > +	ret = ov13858_group_hold_start(ov13858, 0);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	ret = ov13858_write_reg(ov13858, OV13858_REG_VTS,
> > > > +				OV13858_REG_VALUE_16BIT, new_vts);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > 
> > > If you want group hold for that, too, we need a new callback (or 
> > > two) for the control handler I believe.
> > 
> > I don't understand wht this means. Can you give me detail ?
> 
> The V4L2 control framework calls the s_ctrl() callback in the driver to set control values. The driver however doesn't know how many controls there will be to set or when the last control of the set would be conveyed to the driver. To use the grouped parameter hold meaningfully this information is needed.
> 
> ...
> 
> > > > +	/* Values of V4L2 controls will be applied only when power is up */
> > > > +	if (atomic_read(&client->dev.power.usage_count) == 0)
> > > 
> > > I wonder if using pm_runtime_active() would work for this. Checking 
> > > the usage_count directly does not look like something a driver 
> > > should be doing.
> > 
> > Agree, I really wanted to use any helper(accesor) method for this but 
> > when I checked the pm_runtime_active() it wasn't good enough. Anyway I 
> > just found better one for this case. I'll not use using usage_count 
> > and instread of using pm_runtime_get_sync, I'll use 
> > pm_runtime_get_if_in_use()
> 
> Ah, that seems much better indeed!
> 
> > 
> > > 
> > > > +		return 0;
> > > > +
> > > > +	ret = pm_runtime_get_sync(&client->dev);
> > > > +	if (ret < 0) {
> > > > +		pm_runtime_put_noidle(&client->dev);
> > > > +		return ret;
> > > > +	}
> > > > +
> > > > +	ret = 0;
> > > > +	switch (ctrl->id) {
> > > > +	case V4L2_CID_ANALOGUE_GAIN:
> > > > +		ret = ov13858_update_analog_gain(ov13858, ctrl);
> > > > +		break;
> > > > +	case V4L2_CID_EXPOSURE:
> > > > +		ret = ov13858_update_exposure(ov13858, ctrl);
> > > > +		break;
> > > > +	default:
> > > > +		dev_info(&client->dev,
> > > > +			 "ctrl(id:0x%x,val:0x%x) is not handled\n",
> > > > +			 ctrl->id, ctrl->val);
> > > > +		break;
> > > > +	};
> > > > +
> > > > +	pm_runtime_put(&client->dev);
> > > > +
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static const struct v4l2_ctrl_ops ov13858_ctrl_ops = {
> > > > +	.s_ctrl = ov13858_set_ctrl,
> > > > +};
> > > > +
> > > > +/* Initialize control handlers */ static int 
> > > > +ov13858_init_controls(struct ov13858 *ov13858) {
> > > > +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> > > > +	struct v4l2_ctrl_handler *ctrl_hdlr;
> > > > +	int ret;
> > > > +
> > > > +	ctrl_hdlr = &ov13858->ctrl_handler;
> > > > +	ret = v4l2_ctrl_handler_init(ctrl_hdlr, 4);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	ctrl_hdlr->lock = &ov13858->mutex;
> > > > +	ov13858->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr,
> > > > +				&ov13858_ctrl_ops,
> > > > +				V4L2_CID_LINK_FREQ,
> > > > +				OV13858_NUM_OF_LINK_FREQS - 1,
> > > > +				0,
> > > > +				link_freq_menu_items);
> > > > +	ov13858->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> > > > +
> > > > +	/* By default, PIXEL_RATE is read only */
> > > > +	ov13858->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &ov13858_ctrl_ops,
> > > > +					V4L2_CID_PIXEL_RATE, 0,
> > > > +					OV13858_GET_PIXEL_RATE(0), 1,
> > > > +					OV13858_GET_PIXEL_RATE(0));
> > > > +
> > > > +	v4l2_ctrl_new_std(ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
> > > > +			  OV13858_ANA_GAIN_MIN, OV13858_ANA_GAIN_MAX,
> > > > +			  OV13858_ANA_GAIN_STEP, OV13858_ANA_GAIN_DEFAULT);
> > > > +
> > > > +	v4l2_ctrl_new_std(ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_EXPOSURE,
> > > > +			  OV13858_EXP_GAIN_MIN, OV13858_EXP_GAIN_MAX,
> > > > +			  OV13858_EXP_GAIN_STEP, OV13858_EXP_GAIN_DEFAULT);
> > > 
> > > Are the minimum and maximum values dependent on the register list chosen?
> > 
> > We are going to use the same HTS for all reolutions.
> > The supports 4 lines as minimum and MAX_VTS - 8 as maximum.
> > 
> > > 
> > > > +	if (ctrl_hdlr->error) {
> > > > +		ret = ctrl_hdlr->error;
> > > > +		dev_err(&client->dev, "%s control init failed (%d)\n",
> > > > +			__func__, ret);
> > > > +		goto error;
> > > > +	}
> > > > +
> > > > +	ov13858->sd.ctrl_handler = ctrl_hdlr;
> > > > +
> > > > +	return 0;
> > > > +
> > > > +error:
> > > > +	v4l2_ctrl_handler_free(ctrl_hdlr);
> > > > +
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static void ov13858_update_pad_format(struct ov13858 *ov13858,
> > > > +				      const struct ov13858_mode *mode,
> > > > +				      struct v4l2_subdev_format *fmt) {
> > > > +	fmt->format.width = mode->width;
> > > > +	fmt->format.height = mode->height;
> > > > +	fmt->format.code = ov13858->cur_bayer_format;
> > > > +	fmt->format.field = V4L2_FIELD_NONE; }
> > > > +
> > > > +static int ov13858_do_get_pad_format(struct ov13858 *ov13858,
> > > > +				     struct v4l2_subdev_pad_config *cfg,
> > > > +				     struct v4l2_subdev_format *fmt) {
> > > > +	struct v4l2_mbus_framefmt *framefmt;
> > > > +	struct v4l2_subdev *sd = &ov13858->sd;
> > > > +
> > > > +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> > > > +		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> > > > +		fmt->format = *framefmt;
> > > 
> > > You could write this as :
> > > 
> > > fmt->format = *v4l2_subdev_get_try_format(&ov13858->sd, cfg, 
> > > fmt->fmt->pad);
> > > 
> > 
> > Personally I don't like this since I believe readablity of this kind 
> > of code is not good. If there's no stric rule for this, I want to keep 
> > this since believe there's no difference in generated code.
> 
> I don't think the extra local variable assigned and used once really helps, but ok for me.
> 
> --
> Regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
>
