Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39226 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750968AbdE2Haj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 03:30:39 -0400
Date: Mon, 29 May 2017 10:29:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hsu, Cedric" <cedric.hsu@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>
Subject: Re: [PATCH v3 1/1] [media] i2c: add support for OV13858 sensor
Message-ID: <20170529072957.GZ29527@valkosipuli.retiisi.org.uk>
References: <1495844847-21655-1-git-send-email-hyungwoo.yang@intel.com>
 <20170527203053.GY29527@valkosipuli.retiisi.org.uk>
 <7A4F467111FEF64486F40DFE7DF3500A03EAF344@ORSMSX111.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A4F467111FEF64486F40DFE7DF3500A03EAF344@ORSMSX111.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hyugnwoo,

On Sun, May 28, 2017 at 11:26:46PM +0000, Yang, Hyungwoo wrote:
> > > +/* Mode : resolution and related config&values */
> > > +struct ov13858_mode 
> > > +{
> > > +	/* Frame width */
> > > +	u32 width;
> > > +	/* Frame height */
> > > +	u32 height;
> > > +
> > > +	/* V-timing */
> > > +	u32 vts;
> > 
> > Aren't the three fields here unused?
> 
> ?? Yes, they are used. 

Oh, this was a different struct I thought it was. Please ignore the comment.

> 		:
> 		:
> 		:
> > 
> > > +/* Mode configs */
> > > +static const struct ov13858_mode supported_modes[] = {
> > > +	{
> > > +		.width = 4224,
> > > +		.height = 3136,
> > > +		.vts = OV13858_VTS_30FPS,
> > > +		.reg_list = {
> > > +			.num_of_regs = ARRAY_SIZE(mode_4224x3136_regs),
> > > +			.regs = mode_4224x3136_regs,
> > > +		},
> > > +		.link_freq_index = OV13858_LINK_FREQ_INDEX_0,
> > > +	},
> > > +	{
> > > +		.width = 2112,
> > > +		.height = 1568,
> > > +		.vts = OV13858_VTS_30FPS,
> > > +		.reg_list = {
> > > +			.num_of_regs = ARRAY_SIZE(mode_2112x1568_regs),
> > > +			.regs = mode_2112x1568_regs,
> > > +		},
> > > +		.link_freq_index = OV13858_LINK_FREQ_INDEX_1,
> > > +	},
> > > +	{
> > > +		.width = 2112,
> > > +		.height = 1188,
> > > +		.vts = OV13858_VTS_30FPS,
> > > +		.reg_list = {
> > > +			.num_of_regs = ARRAY_SIZE(mode_2112x1188_regs),
> > > +			.regs = mode_2112x1188_regs,
> > > +		},
> > > +		.link_freq_index = OV13858_LINK_FREQ_INDEX_1,
> > > +	},
> > > +	{
> > > +		.width = 1056,
> > > +		.height = 784,
> > > +		.vts = OV13858_VTS_30FPS,
> > > +		.reg_list = {
> > > +			.num_of_regs = ARRAY_SIZE(mode_1056x784_regs),
> > > +			.regs = mode_1056x784_regs,
> > > +		},
> > > +		.link_freq_index = OV13858_LINK_FREQ_INDEX_1,
> > > +	}
> > > +};
> > > +
> > > +struct ov13858 {
> > > +	struct v4l2_subdev sd;
> > > +	struct media_pad pad;
> > > +
> > > +	struct v4l2_ctrl_handler ctrl_handler;
> > > +	/* V4L2 Controls */
> > > +	struct v4l2_ctrl *link_freq;
> > > +	struct v4l2_ctrl *pixel_rate;
> > > +	struct v4l2_ctrl *vblank;
> > > +	struct v4l2_ctrl *exposure;
> > > +
> > > +	/* Current mode */
> > > +	const struct ov13858_mode *cur_mode;
> > > +
> > > +	/* Num of skip frames */
> > > +	u32 num_of_skip_frames;
> > 
> > If you always tell the receiver to skip  OV13858_NUM_OF_SKIP_FRAMES frames in the beginning, you could just return this from your g_skip_frames callback.
> > 
> 
> Oops!!! Yes, you're right. My original version gets some platform dependent values including this through fwnode API.
> I removed them to make this simple but didn't think much. I'll remove this.

Ack.

> 
> > > +
> > > +	/* Mutex for serialized access */
> > > +	struct mutex mutex;
> > > +
> > > +	/* Streaming on/off */
> > > +	bool streaming;
> > > +};
> > > +
> > > +#define to_ov13858(_sd)	container_of(_sd, struct ov13858, sd)
> > > +
> > > +/* Read registers up to 4 at a time */ static int 
> > > +ov13858_read_reg(struct ov13858 *ov13858, u16 reg, u32 len, u32 *val) 
> > > +{
> > > +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> > > +	struct i2c_msg msgs[2];
> > > +	u8 *data_be_p;
> > > +	int ret;
> > > +	u32 data_be = 0;
> > > +	u16 reg_addr_be = cpu_to_be16(reg);
> > > +
> > > +	if (len > 4)
> > > +		return -EINVAL;
> > > +
> > > +	data_be_p = (u8 *)&data_be;
> > > +	/* Write register address */
> > > +	msgs[0].addr = client->addr;
> > > +	msgs[0].flags = 0;
> > > +	msgs[0].len = 2;
> > > +	msgs[0].buf = (u8 *)&reg_addr_be;
> > > +
> > > +	/* Read data from register */
> > > +	msgs[1].addr = client->addr;
> > > +	msgs[1].flags = I2C_M_RD;
> > > +	msgs[1].len = len;
> > > +	msgs[1].buf = &data_be_p[4 - len];
> > > +
> > > +	ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
> > > +	if (ret != ARRAY_SIZE(msgs))
> > > +		return -EIO;
> > > +
> > > +	*val = be32_to_cpu(data_be);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/* Write registers up to 4 at a time */ static int 
> > > +ov13858_write_reg(struct ov13858 *ov13858, u16 reg, u32 len, u32 val) 
> > > +{
> > > +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> > > +	int buf_i, val_i;
> > > +	u8 buf[6], *val_p;
> > > +
> > > +	if (len > 4)
> > > +		return -EINVAL;
> > > +
> > > +	buf[0] = reg >> 8;
> > > +	buf[1] = reg & 0xff;
> > > +
> > > +	buf_i = 2;
> > > +	val_p = (u8 *)&val;
> > > +	val_i = len - 1;
> > > +
> > > +	while (val_i >= 0)
> > > +		buf[buf_i++] = val_p[val_i--];
> > > +
> > > +	if (i2c_master_send(client, buf, len + 2) != len + 2)
> > > +		return -EIO;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/* Write a list of registers */
> > > +static int ov13858_write_regs(struct ov13858 *ov13858,
> > > +			      const struct ov13858_reg *regs, u32 len) {
> > > +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> > > +	int ret;
> > > +	u32 i;
> > > +
> > > +	for (i = 0; i < len; i++) {
> > > +		ret = ov13858_write_reg(ov13858, regs[i].address, 1,
> > > +					regs[i].val);
> > > +		if (ret) {
> > > +			dev_err_ratelimited(
> > > +				&client->dev,
> > > +				"Failed to write reg 0x%4.4x. error = %d\n",
> > > +				regs[i].address, ret);
> > > +
> > > +			return ret;
> > > +		}
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int ov13858_write_reg_list(struct ov13858 *ov13858,
> > > +				  const struct ov13858_reg_list *r_list) {
> > > +	return ov13858_write_regs(ov13858, r_list->regs, 
> > > +r_list->num_of_regs); }
> > > +
> > > +/* Open sub-device */
> > > +static int ov13858_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh 
> > > +*fh) {
> > > +	struct ov13858 *ov13858 = to_ov13858(sd);
> > > +	struct v4l2_mbus_framefmt *try_fmt;
> > > +
> > > +	mutex_lock(&ov13858->mutex);
> > > +
> > > +	/* Initialize try_fmt */
> > > +	try_fmt = v4l2_subdev_get_try_format(sd, fh->pad, 0);
> > > +	try_fmt->width = ov13858->cur_mode->width;
> > > +	try_fmt->height = ov13858->cur_mode->height;
> > > +	try_fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
> > > +	try_fmt->field = V4L2_FIELD_NONE;
> > > +
> > > +	/* No crop or compose */
> > > +	mutex_unlock(&ov13858->mutex);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/* Update max exposure while meeting expected vertial blanking */ 
> > > +static void ov13858_update_exposure_limits(struct ov13858 *ov13858) {
> > > +	s64 max;
> > > +
> > > +	max = ov13858->cur_mode->height + ov13858->vblank->val - 8;
> > > +	__v4l2_ctrl_modify_range(ov13858->exposure, ov13858->exposure->minimum,
> > > +				 max, ov13858->exposure->step, max); }
> > > +
> > > +/* Update exposure */
> > > +static int ov13858_update_exposure(struct ov13858 *ov13858,
> > > +				   struct v4l2_ctrl *ctrl)
> > > +{
> > > +	return ov13858_write_reg(ov13858, OV13858_REG_EXPOSURE,
> > > +				OV13858_REG_VALUE_24BIT, ctrl->val << 4); }
> > > +
> > > +/* Update VTS that meets expected vertical blanking */ static int 
> > > +ov13858_update_vblank(struct ov13858 *ov13858,
> > > +				 struct v4l2_ctrl *ctrl)
> > > +{
> > > +	return ov13858_write_reg(
> > > +			ov13858, OV13858_REG_VTS,
> > > +			OV13858_REG_VALUE_16BIT,
> > > +			ov13858->cur_mode->height + ov13858->vblank->val); }
> > > +
> > > +/* Update analog gain */
> > > +static int ov13858_update_analog_gain(struct ov13858 *ov13858,
> > > +				      struct v4l2_ctrl *ctrl)
> > > +{
> > > +	return ov13858_write_reg(ov13858, OV13858_REG_ANALOG_GAIN,
> > > +				 OV13858_REG_VALUE_16BIT, ctrl->val);
> > 
> > I think I'd move what the four above functions do to ov13858_set_ctrl() unless they're used in more than one location.
> 
> Why ? Personally I like this. Since there  wouldn't be any difference in
> generated machine code, I want to keep this if there's no strict rule on
> this.

There's no strict rule on such matters, but the function definitions don't
really add anything --- especially that they take a struct v4l2_ctrl as
argument, so you can only meaningfully use them when you have the related
struct v4l2_ctrl. It's just harder to read the way it is.

> 
> > 
> > > +}
> > > +
> > > +static int ov13858_set_ctrl(struct v4l2_ctrl *ctrl) {
> > > +	struct ov13858 *ov13858 = container_of(ctrl->handler,
> > > +					       struct ov13858, ctrl_handler);
> > > +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> > > +	int ret;
> > > +
> > > +	/* Propagate change of current control to all related controls */
> > > +	switch (ctrl->id) {
> > > +	case V4L2_CID_VBLANK:
> > > +		ov13858_update_exposure_limits(ov13858);
> > > +		break;
> > > +	};
> > > +
> > > +	/*
> > > +	 * Applying V4L2 control value only happens
> > > +	 * when power is up for streaming
> > > +	 */
> > > +	if (pm_runtime_get_if_in_use(&client->dev) <= 0)
> > > +		return 0;
> > > +
> > > +	ret = 0;
> > > +	switch (ctrl->id) {
> > > +	case V4L2_CID_ANALOGUE_GAIN:
> > > +		ret = ov13858_update_analog_gain(ov13858, ctrl);
> > > +		break;
> > > +	case V4L2_CID_EXPOSURE:
> > > +		ret = ov13858_update_exposure(ov13858, ctrl);
> > > +		break;
> > > +	case V4L2_CID_VBLANK:
> > > +		ret = ov13858_update_vblank(ov13858, ctrl);
> > > +		break;
> > > +	default:
> > > +		dev_info(&client->dev,
> > > +			 "ctrl(id:0x%x,val:0x%x) is not handled\n",
> > > +			 ctrl->id, ctrl->val);
> > > +		break;
> > > +	};
> > > +
> > > +	pm_runtime_put(&client->dev);
> > > +
> > > +	return ret;
> > > +}
> > > +
> 		:
> 		:
> > > +/*
> > > + * Prepare streaming by writing default values and customized values.
> > > + * This should be called with ov13858->mutex acquired.
> > > + */
> > > +static int ov13858_prepare_streaming(struct ov13858 *ov13858)
> > > +{
> > > +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> > > +	const struct ov13858_reg_list *reg_list;
> > > +	int ret, link_freq_index;
> > > +
> > > +	/* Get out of from software reset */
> > > +	ret = ov13858_write_reg(ov13858, OV13858_REG_SOFTWARE_RST,
> > > +				OV13858_REG_VALUE_08BIT, OV13858_SOFTWARE_RST);
> > > +	if (ret) {
> > > +		dev_err(&client->dev, "%s failed to set powerup registers\n",
> > > +			__func__);
> > > +		return ret;
> > > +	}
> > > +
> > > +	/* Setup PLL */
> > > +	link_freq_index = ov13858->cur_mode->link_freq_index;
> > > +	reg_list = &link_freq_configs[link_freq_index].reg_list;
> > > +	ret = ov13858_write_reg_list(ov13858, reg_list);
> > > +	if (ret) {
> > > +		dev_err(&client->dev, "%s failed to set plls\n", __func__);
> > > +		return ret;
> > > +	}
> > > +
> > > +	/* Apply default values of current mode */
> > > +	reg_list = &ov13858->cur_mode->reg_list;
> > > +	ret = ov13858_write_reg_list(ov13858, reg_list);
> > > +	if (ret) {
> > > +		dev_err(&client->dev, "%s failed to set mode\n", __func__);
> > > +		return ret;
> > > +	}
> > > +
> > > +	/* Apply customized values from user */
> > > +	return __v4l2_ctrl_handler_setup(ov13858->sd.ctrl_handler);
> > > +}
> > > +
> > > +/* Start streaming */
> > > +static int ov13858_start_streaming(struct ov13858 *ov13858)
> > > +{
> > > +	int ret;
> > > +
> > > +	/* Write default & customized values */
> > > +	ret = ov13858_prepare_streaming(ov13858);
> > 
> > Could you merge this with ov13858_prepare_streaming()?
> > 
> 
> Why ? I want to keep this. If you want to worry about 1 more jump then, if it is really there, I can make this function "inline"

An extra jump doesn't really matter, it's readability that does.

> 
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	return ov13858_write_reg(ov13858, OV13858_REG_MODE_SELECT,
> > > +				 OV13858_REG_VALUE_08BIT,
> > > +				 OV13858_MODE_STREAMING);
> > > +}
> > > +
> > > +/* Stop streaming */
> > > +static int ov13858_stop_streaming(struct ov13858 *ov13858)
> > > +{
> > > +	return ov13858_write_reg(ov13858, OV13858_REG_MODE_SELECT,
> > > +				 OV13858_REG_VALUE_08BIT, OV13858_MODE_STANDBY);
> > > +}
> > > +

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
