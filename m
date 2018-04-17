Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:22808 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752327AbeDQUKZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 16:10:25 -0400
Date: Tue, 17 Apr 2018 23:10:21 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] media: Add a driver for the ov7251 camera sensor
Message-ID: <20180417201021.q6t4imtoaeh5vtsi@kekkonen.localdomain>
References: <1521778460-8717-1-git-send-email-todor.tomov@linaro.org>
 <1521778460-8717-3-git-send-email-todor.tomov@linaro.org>
 <20180329115147.nai3dgverqpjympu@paasikivi.fi.intel.com>
 <3b45d013-d9e7-04bf-22a3-06b858c2c7bd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b45d013-d9e7-04bf-22a3-06b858c2c7bd@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Tue, Apr 17, 2018 at 06:32:07PM +0300, Todor Tomov wrote:
...
> >> +static int ov7251_regulators_enable(struct ov7251 *ov7251)
> >> +{
> >> +	int ret;
> >> +
> >> +	ret = regulator_enable(ov7251->io_regulator);
> > 
> > How about regulator_bulk_enable() here, and bulk_disable below?
> 
> I'm not using the bulk API because usually there is a power up
> sequence and intervals that must be followed. For this sensor
> the only constraint is that core regulator must be enabled
> after io regulator. But the bulk API doesn't guarantee the
> order.

Could you add a comment explaining this? Otherwise it won't take long until
someone "fixes" the code.

...

> >> +static int ov7251_read_reg(struct ov7251 *ov7251, u16 reg, u8 *val)
> >> +{
> >> +	u8 regbuf[2];
> >> +	int ret;
> >> +
> >> +	regbuf[0] = reg >> 8;
> >> +	regbuf[1] = reg & 0xff;
> >> +
> >> +	ret = i2c_master_send(ov7251->i2c_client, regbuf, 2);
> >> +	if (ret < 0) {
> >> +		dev_err(ov7251->dev, "%s: write reg error %d: reg=%x\n",
> >> +			__func__, ret, reg);
> >> +		return ret;
> >> +	}
> >> +
> >> +	ret = i2c_master_recv(ov7251->i2c_client, val, 1);
> >> +	if (ret < 0) {
> >> +		dev_err(ov7251->dev, "%s: read reg error %d: reg=%x\n",
> >> +			__func__, ret, reg);
> >> +		return ret;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int ov7251_set_exposure(struct ov7251 *ov7251, s32 exposure)
> >> +{
> >> +	int ret;
> >> +
> >> +	ret = ov7251_write_reg(ov7251, OV7251_AEC_EXPO_0,
> >> +			       (exposure & 0xf000) >> 12);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	ret = ov7251_write_reg(ov7251, OV7251_AEC_EXPO_1,
> >> +			       (exposure & 0x0ff0) >> 4);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	return ov7251_write_reg(ov7251, OV7251_AEC_EXPO_2,
> >> +				(exposure & 0x000f) << 4);
> > 
> > It's not a good idea to access multi-octet registers separately. Depending
> > on the hardware implementation, the hardware could latch the value in the
> > middle of an update. This is only an issue during streaming in practice
> > though.
> 
> Good point. The sensor has a group write functionality which can be used
> to solve this but in general is intended
> to apply a group of exposure and gain settings in the same frame. However
> it seems to me that is not possible to use this functionality efficiently
> with the currently available user controls. The group write is configured
> using an id for a group of commands. So if we configure exposure and gain
> separately (a group for each):
> - if the driver uses same group id for exposure and gain, if both controls
>   are received in one frame the second will overwrite the first (the
>   first will not be applied);
> - if the driver uses different group id for exposure and gain, it will not
>   be possible for the user to change exposure and gain in the same frame
>   (as some exposure algorithms do) and it will lead again to frames with
>   "incorrect" brightness.
> 
> To do this correctly we will have to extend the API to be able to apply
> exposure and gain "atomically":
> - a single user control which will set both exposure and gain and it will
>   guarantee that they will be applied in the same frame;
> - some kind of: begin, set exposure, set gain, end, launch -API
> 
> What do you think?
> 
> Actually, I'm a little bit surprised that I didn't find anything
> like this already. And there are already a number of sensor drivers
> which update more than one register to set exposure.

The latter of the two would be preferred as it isn't limited to exposure
and gain only. Still, you could address the problem for this driver by
simply writing the register in a single transaction.

...

> >> +static int ov7251_enum_mbus_code(struct v4l2_subdev *sd,
> >> +				 struct v4l2_subdev_pad_config *cfg,
> >> +				 struct v4l2_subdev_mbus_code_enum *code)
> >> +{
> >> +	if (code->index > 0)
> >> +		return -EINVAL;
> >> +
> >> +	code->code = MEDIA_BUS_FMT_SBGGR10_1X10;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int ov7251_enum_frame_size(struct v4l2_subdev *subdev,
> >> +				  struct v4l2_subdev_pad_config *cfg,
> >> +				  struct v4l2_subdev_frame_size_enum *fse)
> >> +{
> >> +	if (fse->code != MEDIA_BUS_FMT_SBGGR10_1X10)
> > 
> > Can the flip controls affect the media bus code? Either take this into
> > account or remove flip controls.
> 
> This sensor is black and white (monochrome). I have used BGGR because I
> didn't find any monochrome format amongst the Bayer formats. Looking
> again at it now, probably we have to use MEDIA_BUS_FMT_Y10_1X10?

:-) Yes, that's the right media bus code AFAICT.

> 
> However I cannot find a suitable pixel format too (to be used by the
> platform driver) as the output is MIPI10 (same encoding as
> V4L2_PIX_FMT_SBGGR10P but monochrome) and V4L2_PIX_FMT_Y10BPACK has
> different encoding. So it seems to me that I will have to add another
> pixel format, right?

Yes, please.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
