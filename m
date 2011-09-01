Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:53287 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1IAKdQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 06:33:16 -0400
Date: Thu, 1 Sep 2011 13:33:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] mt9t001: Aptina (Micron) MT9T001 3MP sensor driver
Message-ID: <20110901103310.GX12368@valkosipuli.localdomain>
References: <1314793452-23641-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <20110831182332.GM12368@valkosipuli.localdomain>
 <201109011105.06121.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109011105.06121.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 01, 2011 at 11:05:05AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the review.
> 
> On Wednesday 31 August 2011 20:23:33 Sakari Ailus wrote:
> > On Wed, Aug 31, 2011 at 02:24:12PM +0200, Laurent Pinchart wrote:
> > > The MT9T001 is a parallel 3MP sensor from Aptina (formerly Micron)
> > > controlled through I2C.
> > > 
> > > The driver creates a V4L2 subdevice. It currently supports binning and
> > > cropping, and the gain, exposure, test pattern and black level controls.
> > > 
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> [snip]
> 
> > > diff --git a/drivers/media/video/mt9t001.c
> > > b/drivers/media/video/mt9t001.c new file mode 100644
> > > index 0000000..32ab217
> > > --- /dev/null
> > > +++ b/drivers/media/video/mt9t001.c
> > > @@ -0,0 +1,788 @@
> 
> [snip]
> 
> > > +/*
> > > + * mt9m001 i2c address 0x5d
> > 
> > Is it also that for mt8t001?
> 
> Do you mean mt9t001 ? :-) The comment isn't really useful, I've removed it.

Ack.

> > > + */
> 
> [snip]
> 
> > > +static struct mt9t001 *to_mt9t001(struct v4l2_subdev *sd)
> > > +{
> > > +	return container_of(sd, struct mt9t001, subdev);
> > > +}
> > 
> > I guess you could add inline here, or define it as a macro.
> 
> I've added inline.
> 
> > > +static int mt9t001_read(struct i2c_client *client, const u8 reg)
> > > +{
> > > +	s32 data = i2c_smbus_read_word_data(client, reg);
> > > +	return data < 0 ? data : swab16(data);
> > 
> > Is the swab16 correct here? What about be16_to_cpu()?
> 
> Fixed.
> 
> > > +}
> > > +
> > > +static int mt9t001_write(struct i2c_client *client, const u8 reg,
> > > +			 const u16 data)
> > > +{
> > > +	return i2c_smbus_write_word_data(client, reg, swab16(data));
> > 
> > Ditto.
> > 
> > > +}
> 
> [snip]
> 
> > > +static int mt9t001_s_stream(struct v4l2_subdev *subdev, int enable)
> > > +{
> > > +	struct mt9t001 *mt9t001 = to_mt9t001(subdev);
> > > +
> > > +	/* Switch to master "normal" mode or stop sensor readout */
> > > +	return mt9t001_set_output_control(mt9t001,
> > > +		enable ? 0 : MT9T001_OUTPUT_CONTROL_CHIP_ENABLE,
> > > +		enable ? MT9T001_OUTPUT_CONTROL_CHIP_ENABLE : 0);
> > 
> > I wonder if an if would be better here. You also could change the
> > mt9t001_set_output_control() to take in the number of the bit and whether
> > you enable or disable it.
> 
> I've added more code to s_stream, the code looks cleaner now.
> 
> > > +}
> 
> [snip]
> 
> > > +#define V4L2_CID_TEST_PATTERN		(V4L2_CID_USER_BASE | 0x1001)
> > 
> > Thest pattern is something that almost every sensor have.
> > 
> > > +#define V4L2_CID_GAIN_RED		(V4L2_CTRL_CLASS_CAMERA | 0x1001)
> > > +#define V4L2_CID_GAIN_GREEN1		(V4L2_CTRL_CLASS_CAMERA | 0x1002)
> > > +#define V4L2_CID_GAIN_GREEN2		(V4L2_CTRL_CLASS_CAMERA | 0x1003)
> > 
> > The greens are usually not numbered but have either blue/red subscript
> > based on the colour of the adjacent pixel as far as I understand. What
> > about calling them GREEN_RED or GREEN_R (and same for blue)?
> 
> Good point. I've fixed that.
> 
> > Also these are quite low level controls as opposed to the other higher
> > level controls in this class. I wonder if creating a separate class for
> > them would make sense. We'll need a new class for the hblank/vblank
> > controls anyway. I might call it "sensor".
> > 
> > These controls could be also standardised.
> 
> I agree.
> 
> A "sensor" control class might make sense for these 5 controls, but they can 
> also be useful for non-sensor hardware (for instance with an analog pixel 
> decoder).

What about calling it differently then?

V4L2_CTRL_CLASS_SOURCE
V4L2_CTRL_CLASS_IMAGE_SOURCE
V4L2_CTRL_CLASS_MBUS_SOURCE

> > > +#define V4L2_CID_GAIN_BLUE		(V4L2_CTRL_CLASS_CAMERA | 0x1004)
> > > +
> > > +static int mt9t001_gain_data(s32 *gain)
> > > +{
> > > +	/* Gain is controlled by 2 analog stages and a digital stage. Valid
> > > +	 * values for the 3 stages are
> > > +	 *
> > > +	 * Stage		Min	Max	Step
> > > +	 * ------------------------------------------
> > > +	 * First analog stage	x1	x2	1
> > > +	 * Second analog stage	x1	x4	0.125
> > > +	 * Digital stage	x1	x16	0.125
> > > +	 *
> > > +	 * To minimize noise, the gain stages should be used in the second
> > > +	 * analog stage, first analog stage, digital stage order. Gain from a
> > > +	 * previous stage should be pushed to its maximum value before the next
> > > +	 * stage is used.
> > > +	 */
> > > +	if (*gain <= 32)
> > > +		return *gain;
> > > +
> > > +	if (*gain <= 64) {
> > > +		*gain &= ~1;
> > > +		return (1 << 6) | (*gain >> 1);
> > > +	}
> > > +
> > > +	*gain &= ~7;
> > > +	return ((*gain - 64) << 5) | (1 << 6) | 32;
> > > +}
> > 
> > This one looks very similar to another Aptina sensor driver. My comment
> > back then was that the analog and digital gain should be separate controls
> > as the user typically would e.g. want to know (s)he's using digital gain
> > instead of analog one.
> > 
> > What about implementing this?
> > 
> > It's a good question whether we need one or two new controls. If the answer
> > is two, then how do they relate to the existing control?
> 
> I'm not too sure about this. If an application needs that much control over 
> the hardware, wouldn't it be hardware-specific anyway, and know about control 
> ranges ? The mt9t001 actually has 3 gain stages, so one might even argue that 
> we should expose 3 gain controls :-)

At least we should have two different ones. The driver might implement a
policy for the single exposure control which would be combination of the
two, but I'd rather see this done more genericly in libv4l: the algorithm is
trivial and the same, and I also think this is relatively generic.

I don't think there's a need to show the secondary analog gain stage to the
user, especially if the relation of the two stages is so simple. Are the
units also the same?

> > > +static int mt9t001_ctrl_freeze(struct mt9t001 *mt9t001, bool freeze)
> > > +{
> > > +	return mt9t001_set_output_control(mt9t001,
> > > +		freeze ? 0 : MT9T001_OUTPUT_CONTROL_SYNC,
> > > +		freeze ? MT9T001_OUTPUT_CONTROL_SYNC : 0);
> > > +}
> > > +
> > > +static int mt9t001_s_ctrl(struct v4l2_ctrl *ctrl)
> > > +{
> > > +	static const u8 gains[4] = {
> > > +		MT9T001_RED_GAIN, MT9T001_GREEN1_GAIN,
> > > +		MT9T001_GREEN2_GAIN, MT9T001_BLUE_GAIN
> > > +	};
> > > +
> > > +	struct mt9t001 *mt9t001 =
> > > +			container_of(ctrl->handler, struct mt9t001, ctrls);
> > > +	struct i2c_client *client = v4l2_get_subdevdata(&mt9t001->subdev);
> > > +	unsigned int count;
> > > +	unsigned int i;
> > > +	int data;
> > > +	int ret;
> > > +
> > > +	switch (ctrl->id) {
> > > +	case V4L2_CID_GAIN_RED:
> > > +	case V4L2_CID_GAIN_GREEN1:
> > > +	case V4L2_CID_GAIN_GREEN2:
> > > +	case V4L2_CID_GAIN_BLUE:
> > > +
> > > +		/* Disable control updates if more than one control has changed
> > > +		 * in the cluster.
> > > +		 */
> > > +		for (i = 0, count = 0; i < 4; ++i) {
> > > +			struct v4l2_ctrl *gain = mt9t001->gains[i];
> > > +
> > > +			if (gain->val != gain->cur.val)
> > > +				count++;
> > > +		}
> > > +
> > > +		if (count > 1) {
> > > +			ret = mt9t001_ctrl_freeze(mt9t001, true);
> > > +			if (ret < 0)
> > > +				return ret;
> > > +		}
> > > +
> > > +		/* Update the gain controls. */
> > > +		for (i = 0; i < 4; ++i) {
> > > +			struct v4l2_ctrl *gain = mt9t001->gains[i];
> > > +
> > > +			if (gain->val == gain->cur.val)
> > > +				continue;
> > > +
> > > +			data = mt9t001_gain_data(&gain->val);
> > > +			ret = mt9t001_write(client, gains[i], data);
> > > +			if (ret < 0) {
> > > +				mt9t001_ctrl_freeze(mt9t001, false);
> > > +				return ret;
> > > +			}
> > > +		}
> > > +
> > > +		/* Enable control updates. */
> > > +		if (count > 1) {
> > > +			ret = mt9t001_ctrl_freeze(mt9t001, false);
> > > +			if (ret < 0)
> > > +				return ret;
> > > +		}
> > > +
> > > +		break;
> > > +
> > > +	case V4L2_CID_EXPOSURE:
> > > +		ret = mt9t001_write(client, MT9T001_SHUTTER_WIDTH_LOW,
> > > +				    ctrl->val & 0xffff);
> > > +		if (ret < 0)
> > > +			return ret;
> > > +
> > > +		return mt9t001_write(client, MT9T001_SHUTTER_WIDTH_HIGH,
> > > +				     ctrl->val >> 16);
> > > +	case V4L2_CID_TEST_PATTERN:
> > > +		ret = mt9t001_set_output_control(mt9t001,
> > > +			ctrl->val ? 0 : MT9T001_OUTPUT_CONTROL_TEST_DATA,
> > > +			ctrl->val ? MT9T001_OUTPUT_CONTROL_TEST_DATA : 0);
> > > +		if (ret < 0)
> > > +			return ret;
> > > +
> > > +		return mt9t001_write(client, MT9T001_TEST_DATA, ctrl->val << 2);
> > > +
> > 
> > > +	case V4L2_CID_BLACK_LEVEL:
> > Does this do automatic black level calibration? If so, I'd call this
> > BLACK_LEVEL_CALIBRATE instead.
> 
> V4L2_CID_BLACK_LEVEL is marked as deprecated, so a new control indeed makes 
> sense. It should probably belong to the sensor class.

Agreed.

> > > +		return mt9t001_write(client, MT9T001_BLACK_LEVEL_CALIBRATION,
> > > +				     MT9T001_BLACK_LEVEL_RECALCULATE);
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> 
> [snip]
> 
> > Just a general comment. How much does this sensor share with other Aptina
> > sensors? Could one of the existing Aptina sensor drivers such as the mt9v032
> > used to drive this sensor?
> 
> Not all features are available on both sensors, but that shouldn't be too much 
> of an issue.
> 
> The biggest problem is that there are many subtle differences. For instance 
> 
> #define MT9T001_ROW_START                               0x01
> #define MT9T001_COLUMN_START                            0x02
> 
> #define MT9V032_COLUMN_START                            0x01
> #define MT9V032_ROW_START                               0x02
> 
> is quite easy to miss. The MT9T001 needs to be programmed with window 
> width/height minus one, while the MT9V032 needs to be programmed with window 
> width/height. Horizontal and vertical binning are configured in two separate 
> registers in the MT9T001 and in a single register in the MT9V032. The list 
> goes on.

What you _could_ do, is to have an array of struct containing register
addresses, bits, minimums, maximums and masks for every sensor model you
support, and then use array indices to address this. You wouldn't need any
ifs in the code.

But I don't think it's the time for this yet.

> It might be possible to support several chips with a single driver, but I 
> think we need a couple more before we can identify the proper recurring 
> patterns.

Agreed.

-- 
Sakari Ailus
sakari.ailus@iki.fi
