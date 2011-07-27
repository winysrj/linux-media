Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60586 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1G0Rvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 13:51:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] mt9p031: Aptina (Micron) MT9P031 5MP sensor driver
Date: Wed, 27 Jul 2011 19:51:36 +0200
Cc: linux-media@vger.kernel.org, javier.martin@vista-silicon.com,
	shotty317@gmail.com
References: <CACKLOr1veNZ_6E3V_m1Tf+mxxUAKiRKDbboW-fMbRGUrLns_XA@mail.gmail.com> <1311757981-6968-1-git-send-email-laurent.pinchart@ideasonboard.com> <20110727101305.GI32629@valkosipuli.localdomain>
In-Reply-To: <20110727101305.GI32629@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107271951.37601.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 27 July 2011 12:13:05 Sakari Ailus wrote:
> Hi Laurent,
> 
> Thanks for the patch. I have a few comments below.

Thanks for the review. Please see my answers to your comments below. Javier, 
there's one question for you as well.

> On Wed, Jul 27, 2011 at 11:13:01AM +0200, Laurent Pinchart wrote:

[snip]

> > +static struct mt9p031 *to_mt9p031(struct v4l2_subdev *sd)
> > +{
> > +	return container_of(sd, struct mt9p031, subdev);
> > +}
> > +
> > +static int mt9p031_read(struct i2c_client *client, u8 reg)
> > +{
> > +	s32 data = i2c_smbus_read_word_data(client, reg);
> > +	return data < 0 ? data : swab16(data);
> 
> Why swab16, and not e.g. be16_to_cpu?

No reason. I'll fix that.

> > +}
> > +
> > +static int mt9p031_write(struct i2c_client *client, u8 reg, u16 data)
> > +{
> > +	return i2c_smbus_write_word_data(client, reg, swab16(data));
> 
> Same here.
> 
> > +}

[snip]

> > +/*
> > + * This static table uses ext_freq and vdd_io values to select suitable
> > + * PLL dividers m, n and p1 which have been calculated as specifiec in
> > p36 + * of Aptina's mt9p031 datasheet. New values should be added here.
> > + */
> > +static const struct mt9p031_pll_divs mt9p031_divs[] = {
> > +	/* ext_freq	target_freq	m	n	p1 */
> > +	{21000000,	48000000,	26,	2,	6}
> 
> Can the divisors be calculated dynamically?
> 
> The external clock frequency, target_freq (pixel clock, I assume!) are
> typically highly board dependent.

Probably. That's on my TODO list.

> > +};
> > +
> > +static int mt9p031_pll_get_divs(struct mt9p031 *mt9p031)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(mt9p031_divs); i++) {
> > +		if (mt9p031_divs[i].ext_freq == mt9p031->pdata->ext_freq &&
> > +		  mt9p031_divs[i].target_freq == mt9p031->pdata->target_freq) {
> > +			mt9p031->ext_freq = mt9p031_divs[i].ext_freq;
> > +			mt9p031->m = mt9p031_divs[i].m;
> > +			mt9p031->n = mt9p031_divs[i].n;
> > +			mt9p031->p1 = mt9p031_divs[i].p1;
> 
> What about a pointer to the array instead of copying the values?

Sounds good to me.

> > +			return 0;
> > +		}
> > +	}
> > +
> > +	dev_err(&client->dev, "Couldn't find PLL dividers for ext_freq = %d, "
> > +		"target_freq = %d\n", mt9p031->pdata->ext_freq,
> > +		mt9p031->pdata->target_freq);
> > +	return -EINVAL;
> > +}
> > +
> > +static int mt9p031_pll_enable(struct mt9p031 *mt9p031)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
> > +	int ret;
> > +
> > +	ret = mt9p031_write(client, MT9P031_PLL_CONTROL,
> > +			    MT9P031_PLL_CONTROL_PWRON);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = mt9p031_write(client, MT9P031_PLL_CONFIG_1,
> > +			    (mt9p031->m << 8) | (mt9p031->n - 1));
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = mt9p031_write(client, MT9P031_PLL_CONFIG_2, mt9p031->p1 - 1);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	mdelay(1);
> 
> mdelay() is a busyloop. Either msleep(), if the timing isn't critical, and
> if it is, then usleep_range().

Timing isn't critical, but that's a stream-on delay, so I'll use 
usleep_range().

> > +	ret = mt9p031_write(client, MT9P031_PLL_CONTROL,
> > +			    MT9P031_PLL_CONTROL_PWRON |
> > +			    MT9P031_PLL_CONTROL_USEPLL);
> > +	mdelay(1);

Javier, is this second mdelay() needed ?

> > +	return ret;
> > +}
> > +
> > +static inline int mt9p031_pll_disable(struct mt9p031 *mt9p031)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
> > +
> > +	return mt9p031_write(client, MT9P031_PLL_CONTROL,
> > +			     MT9P031_PLL_CONTROL_PWROFF);
> > +}
> > +
> > +static int mt9p031_power_on(struct mt9p031 *mt9p031)
> > +{
> > +	/* Ensure RESET_BAR is low */
> > +	if (mt9p031->pdata->reset) {
> > +		mt9p031->pdata->reset(&mt9p031->subdev, 1);
> > +		msleep(1);
> 
> msleep(1) may take considerably longer than 1 ms, depending on the system
> clock. You might want to use usleep_range() here.

Good point.

> > +	}
> > +
> > +	/* Emable clock */
> > +	if (mt9p031->pdata->set_xclk)
> > +		mt9p031->pdata->set_xclk(&mt9p031->subdev,
> > +					 mt9p031->pdata->ext_freq);
> > +
> > +	/* Now RESET_BAR must be high */
> > +	if (mt9p031->pdata->reset) {
> > +		mt9p031->pdata->reset(&mt9p031->subdev, 0);
> > +		msleep(1);
> > +	}
> > +
> > +	return 0;
> > +}

[snip]

> > +static int mt9p031_set_params(struct mt9p031 *mt9p031)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
> > +	struct v4l2_mbus_framefmt *format = &mt9p031->format;
> > +	const struct v4l2_rect *crop = &mt9p031->crop;
> > +	unsigned int hblank;
> > +	unsigned int vblank;
> > +	unsigned int xskip;
> > +	unsigned int yskip;
> > +	unsigned int xbin;
> > +	unsigned int ybin;
> > +	int ret;
> > +
> > +	/* Windows position and size.
> > +	 *
> > +	 * TODO: Make sure the start coordinates and window size match the
> > +	 * skipping, binning and mirroring (see description of registers 2 and
> > 4 +	 * in table 13, and Binning section on page 41).
> > +	 */
> > +	ret = mt9p031_write(client, MT9P031_COLUMN_START, crop->left);
> > +	if (ret < 0)
> > +		return ret;
> > +	ret = mt9p031_write(client, MT9P031_ROW_START, crop->top);
> > +	if (ret < 0)
> > +		return ret;
> > +	ret = mt9p031_write(client, MT9P031_WINDOW_WIDTH, crop->width - 1);
> > +	if (ret < 0)
> > +		return ret;
> > +	ret = mt9p031_write(client, MT9P031_WINDOW_HEIGHT, crop->height - 1);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/* Row and column binning and skipping. Use the maximum binning value
> > +	 * compatible with the skipping settings.
> > +	 */
> > +	xskip = DIV_ROUND_CLOSEST(crop->width, format->width);
> > +	yskip = DIV_ROUND_CLOSEST(crop->height, format->height);
> > +	xbin = 1 << (ffs(xskip) - 1);
> > +	ybin = 1 << (ffs(yskip) - 1);
> > +
> > +	ret = mt9p031_write(client, MT9P031_COLUMN_ADDRESS_MODE,
> > +			    ((xbin - 1) << 4) | (xskip - 1));
> > +	if (ret < 0)
> > +		return ret;
> > +	ret = mt9p031_write(client, MT9P031_ROW_ADDRESS_MODE,
> > +			    ((ybin - 1) << 4) | (yskip - 1));
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/* Blanking - use minimum value for horizontal blanking and default
> > +	 * value for vertical blanking.
> > +	 */
> > +	hblank = 346 * ybin + 64 + (80 >> max_t(unsigned int, xbin, 3));
> 
> Where do all these numbers come from? :-)

Directly from the datasheet :-) See table 8.

> I saw very nice register definitions and value ranges in the beginning of
> the patch.
> 
> > +	vblank = MT9P031_VERTICAL_BLANK_DEF;
> > +
> > +	ret = mt9p031_write(client, MT9P031_HORIZONTAL_BLANK, hblank);
> > +	if (ret < 0)
> > +		return ret;
> > +	ret = mt9p031_write(client, MT9P031_VERTICAL_BLANK, vblank);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return ret;
> > +}

[snip]

> > +static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct mt9p031 *mt9p031 =
> > +			container_of(ctrl->handler, struct mt9p031, ctrls);
> > +	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
> > +	u16 data;
> > +	int ret;
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_EXPOSURE:
> > +		ret = mt9p031_write(client, MT9P031_SHUTTER_WIDTH_UPPER,
> > +				    (ctrl->val >> 16) & 0xffff);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		return mt9p031_write(client, MT9P031_SHUTTER_WIDTH_LOWER,
> > +				     ctrl->val & 0xffff);
> > +
> > +	case V4L2_CID_GAIN:
> > +		/* Gain is controlled by 2 analog stages and a digital stage.
> 
> Just a general question: shouldn't there be another control for digital (or
> analog) range? Which to change in what point of time is somewhat a policy
> decision. Sometimes the user would also want to know that (s)he is using
> digital gain.

The could indeed be useful. Green/blue/red gain controls could be useful as 
well. We need to standardize them :-)

> > +		 * Valid values for the 3 stages are
> > +		 *
> > +		 * Stage                Min     Max     Step
> > +		 * ------------------------------------------
> > +		 * First analog stage   x1      x2      1
> > +		 * Second analog stage  x1      x4      0.125
> > +		 * Digital stage        x1      x16     0.125
> > +		 *
> > +		 * To minimize noise, the gain stages should be used in the
> > +		 * second analog stage, first analog stage, digital stage order.
> > +		 * Gain from a previous stage should be pushed to its maximum
> > +		 * value before the next stage is used.
> > +		 */
> > +		if (ctrl->val <= 32) {
> > +			data = ctrl->val;
> > +		} else if (ctrl->val <= 64) {
> > +			ctrl->val &= ~1;
> > +			data = (1 << 6) | (ctrl->val >> 1);
> > +		} else {
> > +			ctrl->val &= ~7;
> > +			data = ((ctrl->val - 64) << 5) | (1 << 6) | 32;
> > +		}
> > +
> > +		return mt9p031_write(client, MT9P031_GLOBAL_GAIN, data);
> > +
> > +	case V4L2_CID_HFLIP:
> > +		if (ctrl->val)
> > +			return mt9p031_set_mode2(mt9p031,
> > +					0, MT9P031_READ_MODE_2_COL_MIR);
> > +		else
> > +			return mt9p031_set_mode2(mt9p031,
> > +					MT9P031_READ_MODE_2_COL_MIR, 0);
> > +
> > +	case V4L2_CID_VFLIP:
> > +		if (ctrl->val)
> > +			return mt9p031_set_mode2(mt9p031,
> > +					0, MT9P031_READ_MODE_2_ROW_MIR);
> > +		else
> > +			return mt9p031_set_mode2(mt9p031,
> > +					MT9P031_READ_MODE_2_ROW_MIR, 0);
> > +
> > +	case V4L2_CID_TEST_PATTERN:
> > +		if (!ctrl->val) {
> > +			ret = mt9p031_set_mode2(mt9p031,
> > +					0, MT9P031_READ_MODE_2_ROW_BLC);
> > +			if (ret < 0)
> > +				return ret;
> > +
> > +			return mt9p031_write(client, MT9P031_TEST_PATTERN,
> > +					     MT9P031_TEST_PATTERN_DISABLE);
> > +		}
> > +
> > +		ret = mt9p031_write(client, MT9P031_TEST_PATTERN_GREEN, 0x05a0);
> > +		if (ret < 0)
> > +			return ret;
> > +		ret = mt9p031_write(client, MT9P031_TEST_PATTERN_RED, 0x0a50);
> > +		if (ret < 0)
> > +			return ret;
> > +		ret = mt9p031_write(client, MT9P031_TEST_PATTERN_BLUE, 0x0aa0);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ret = mt9p031_set_mode2(mt9p031, MT9P031_READ_MODE_2_ROW_BLC,
> > +					0);
> > +		if (ret < 0)
> > +			return ret;
> > +		ret = mt9p031_write(client, MT9P031_ROW_BLACK_DEF_OFFSET, 0);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		return mt9p031_write(client, MT9P031_TEST_PATTERN,
> > +				((ctrl->val - 1) << MT9P031_TEST_PATTERN_SHIFT)
> > +				| MT9P031_TEST_PATTERN_ENABLE);
> > +	}
> > +	return 0;
> > +}
> > +
> > +static struct v4l2_ctrl_ops mt9p031_ctrl_ops = {
> > +	.s_ctrl = mt9p031_s_ctrl,
> > +};
> > +
> > +static const char * const mt9p031_test_pattern_menu[] = {
> > +	"Disabled",
> > +	"Color Field",
> > +	"Horizontal Gradient",
> > +	"Vertical Gradient",
> > +	"Diagonal Gradient",
> > +	"Classic Test Pattern",
> > +	"Walking 1s",
> > +	"Monochrome Horizontal Bars",
> > +	"Monochrome Vertical Bars",
> > +	"Vertical Color Bars",
> > +};
> > +
> > +static const struct v4l2_ctrl_config mt9p031_ctrls[] = {
> > +	{
> > +		.ops		= &mt9p031_ctrl_ops,
> > +		.id		= V4L2_CID_TEST_PATTERN,
> > +		.type		= V4L2_CTRL_TYPE_MENU,
> > +		.name		= "Test Pattern",
> > +		.min		= 0,
> > +		.max		= 9,
> 
> I wonder if ARRAY_SIZE(mt9p031_test_pattern_menu) would return something
> sensible.

I can try :-) (minus one though).

> > +		.step		= 0,
> > +		.def		= 0,
> > +		.flags		= 0,
> > +		.menu_skip_mask	= 0,
> > +		.qmenu		= mt9p031_test_pattern_menu,
> > +	}
> > +};

[snip]

> > +static int mt9p031_probe(struct i2c_client *client,
> > +				const struct i2c_device_id *did)
> > +{
> > +	struct mt9p031_platform_data *pdata = client->dev.platform_data;
> 
> You might want to check pdata isn't NULL.

Good point again well.

> > +	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> > +	struct mt9p031 *mt9p031;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> > +		dev_warn(&adapter->dev,
> > +			"I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
> > +		return -EIO;
> > +	}
> > +
> > +	mt9p031 = kzalloc(sizeof(*mt9p031), GFP_KERNEL);
> > +	if (mt9p031 == NULL)
> > +		return -ENOMEM;
> > +
> > +	mt9p031->pdata = pdata;
> > +	mt9p031->output_control	= MT9P031_OUTPUT_CONTROL_DEF;
> > +	mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
> > +
> > +	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 4);
> > +
> > +	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
> > +			  V4L2_CID_EXPOSURE, MT9P031_SHUTTER_WIDTH_MIN,
> > +			  MT9P031_SHUTTER_WIDTH_MAX, 1,
> > +			  MT9P031_SHUTTER_WIDTH_DEF);
> > +	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
> > +			  V4L2_CID_GAIN, MT9P031_GLOBAL_GAIN_MIN,
> > +			  MT9P031_GLOBAL_GAIN_MAX, 1, MT9P031_GLOBAL_GAIN_DEF);
> > +	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
> > +			  V4L2_CID_HFLIP, 0, 1, 1, 0);
> > +	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
> > +			  V4L2_CID_VFLIP, 0, 1, 1, 0);
> > +
> > +	for (i = 0; i < ARRAY_SIZE(mt9p031_ctrls); ++i)
> > +		v4l2_ctrl_new_custom(&mt9p031->ctrls, &mt9p031_ctrls[i], NULL);
> > +
> > +	mt9p031->subdev.ctrl_handler = &mt9p031->ctrls;
> > +
> > +	if (mt9p031->ctrls.error)
> > +		printk(KERN_INFO "%s: control initialization error %d\n",
> > +		       __func__, mt9p031->ctrls.error);
> > +
> > +	mutex_init(&mt9p031->power_lock);
> > +	v4l2_i2c_subdev_init(&mt9p031->subdev, client, &mt9p031_subdev_ops);
> > +	mt9p031->subdev.internal_ops = &mt9p031_subdev_internal_ops;
> > +
> > +	mt9p031->pad.flags = MEDIA_PAD_FL_SOURCE;
> > +	ret = media_entity_init(&mt9p031->subdev.entity, 1, &mt9p031->pad, 0);
> > +	if (ret < 0)
> > +		goto done;
> > +
> > +	mt9p031->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +
> > +	mt9p031->crop.width = MT9P031_WINDOW_WIDTH_DEF;
> > +	mt9p031->crop.height = MT9P031_WINDOW_HEIGHT_DEF;
> > +	mt9p031->crop.left = MT9P031_COLUMN_START_DEF;
> > +	mt9p031->crop.top = MT9P031_ROW_START_DEF;
> > +
> > +	if (mt9p031->pdata->version == MT9P031_MONOCHROME_VERSION)
> > +		mt9p031->format.code = V4L2_MBUS_FMT_Y12_1X12;
> > +	else
> > +		mt9p031->format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
> > +
> > +	mt9p031->format.width = MT9P031_WINDOW_WIDTH_DEF;
> > +	mt9p031->format.height = MT9P031_WINDOW_HEIGHT_DEF;
> > +	mt9p031->format.field = V4L2_FIELD_NONE;
> > +	mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
> > +
> > +	ret = mt9p031_pll_get_divs(mt9p031);
> > +
> > +done:
> > +	if (ret < 0)
> > +		kfree(mt9p031);
> > +
> > +	return ret;
> > +}

-- 
Regards,

Laurent Pinchart
