Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:53933 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1AXUpl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 15:45:41 -0500
Date: Mon, 24 Jan 2011 21:45:39 +0100
From: martin@neutronstar.dyndns.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: Add driver for Micron MT9M032 camera sensor
Message-ID: <20110124204539.GA16733@neutronstar.dyndns.org>
References: <1295389122-30325-1-git-send-email-martin@neutronstar.dyndns.org> <20110120225607.GD13173@neutronstar.dyndns.org> <201101241232.12633.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101241232.12633.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jan 24, 2011 at 12:32:12PM +0100, Laurent Pinchart wrote:
> Hi Martin,
> 
> On Thursday 20 January 2011 23:56:07 martin@neutronstar.dyndns.org wrote:
> 
> [snip]
> 
> > >> +static unsigned long mt9m032_row_time(struct mt9m032 *sensor, int
> > >> width) +{
> > >> +	int effective_width;
> > >> +	u64 ns;
> > >> +	effective_width = width + 716; /* emperical value */
> > > 
> > > Where does it come from ?
> > 
> > Like the comment says, it's just what the hardware seems to do from
> > measureing framerates. Sadly i couldn't find anything exact anywhere...
> 
> :-( Is the datasheet publicly available ?

Only a very reduced version, that has nothing detailed afaik...

> 
> [snip]
> 
> > >> +	row_time = mt9m032_row_time(sensor, crop->width);
> > >> +	do_div(ns, row_time);
> > >> +
> > >> +	additional_blanking_rows = ns - crop->height;
> > >> +
> > >> +	/* enforce minimal 1.6ms blanking time. */
> > >> +	min_blank = 1600000 / row_time;
> > >> +	if (additional_blanking_rows < min_blank)
> > >> +		additional_blanking_rows = min_blank;
> > > 
> > > You can use the min() macro.
> > 
> > I'm pretty sure it's the max() one, but yes.
> >
> > >> +	dev_dbg(to_dev(sensor),
> > >> +		"%s: V-blank %i\n", __func__, additional_blanking_rows);
> > >> +	if (additional_blanking_rows > 0x7ff) {
> > >> +		/* hardware limits 11 bit values */
> > >> +		dev_warn(to_dev(sensor),
> > >> +			"mt9m032: frame rate too low.\n");
> > >> +		additional_blanking_rows = 0x7ff;
> > >> +	}
> > > 
> > > Or rather the clamp() macro.
> > 
> > I think the error reporting reads more natual when doing the upper bound in
> > the if.
> 
> I would just do
> 
> 	additional_blanking_rows = clamp(ns - crop->height, min_blank, 0x7ff);
> 
> I don't think there's a need for any error reporting here. What you must do 
> instead is to limit the frame rate to hardware-acceptable values when the user 
> tries to set it.

Well when the value returned to userspace get gets clamped properly that
should be enough, yes.


> 
> [snip]
> 
> > >> +static int update_formatter2(struct mt9m032 *sensor, bool streaming)
> > >> +{
> > >> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > >> +
> > >> +	u16 reg_val =   0x1000   /* Dout enable */
> > >> +		      | 0x0070;  /* parts reserved! */
> > >> +				 /* possibly for changing to 14-bit mode */
> > >> +
> > >> +	if (streaming)
> > >> +		reg_val |= 0x2000;   /* pixclock enable */
> > > 
> > > Please define constants at the beginning of the file (with the register
> > > addresses) instead of using magic numbers.
> > 
> > I'm using defines for all register numbers where i know the function
> > reasonably well and explicit comments or variable names for all the bits i
> > set in these registers. (And each register is only set in one function)
> > 
> > I think that should be quite decent. Sadly from the material i have i have a
> > lot of just undocumented pokeing at reserved bits to keep. For these cases i
> > marked it in the code somehow are reserved and didn't do any defines for the
> > register names because they would be useless.
> 
> How did you get the information in the first place ?

Pseudo code for the setup tasks.


> 
> > Do you think this is acceptable? Or do i need to have a define for each
> > known bit position the driver sets?
> 
> Please define them. See 
> http://git.linuxtv.org/pinchartl/media.git?a=commitdiff;h=26e4a508f6e0fcb416e21bd29967ce6e2622abc7;hp=10affb3c5e0c8ae74461c1b6a4ca6ed5251c27d8#patch3
> 

Ok, i move everything where i'm confident that i know what it does to
defines.

> > What would i do with the undocumented bits?
> > 
> > >> +#define OFFSET_UNCHANGED	0xFFFFFFFF
> > >> +static int mt9m032_set_pad_geom(struct mt9m032 *sensor,
> > >> +				struct v4l2_subdev_fh *fh,
> > >> +				u32 which, u32 pad,
> > >> +				s32 top, s32 left, s32 width, s32 height)
> > >> +{
> > >> +	struct v4l2_mbus_framefmt tmp_format;
> > >> +	struct v4l2_rect tmp_crop;
> > >> +	struct v4l2_mbus_framefmt *format;
> > >> +	struct v4l2_rect *crop;
> > >> +
> > >> +	if (pad != 0)
> > >> +		return -EINVAL;
> > >> +
> > >> +	format = __mt9m032_get_pad_format(sensor, fh, which);
> > >> +	crop = __mt9m032_get_pad_crop(sensor, fh, which);
> > >> +	if (!format || !crop)
> > >> +		return -EINVAL;
> > >> +	if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> > >> +		tmp_crop = *crop;
> > >> +		tmp_format = *format;
> > >> +		format = &tmp_format;
> > >> +		crop = &tmp_crop;
> > >> +	}
> > >> +
> > >> +	if (top != OFFSET_UNCHANGED)
> > >> +		crop->top = top & ~0x1;
> > >> +	if (left != OFFSET_UNCHANGED)
> > >> +		crop->left = left;
> > >> +	crop->height = height;
> > >> +	crop->width = width & ~1;
> > >> +
> > >> +	format->height = crop->height;
> > >> +	format->width = crop->width;
> > > 
> > > This looks very weird to me. If your sensor doesn't include a scaler, it
> > > should support a single fixed format. Crop will then be used to select
> > > the crop rectangle. You're mixing the two for no obvious reason.
> > 
> > I think i have to have both size and crop writable. So i wrote the code to
> > just have format width/height and crop width/height to be equal at all
> > times. So actually almost all code for crop setting and format are shared.
> > 
> > As you wrote in your recent mail this api isn't really intuitive and i'm
> > not really sure what's the right thing to do thus i just copied the
> > semantics from an existing driver with similar capable hardware.
> > 
> > This code works nicely and media-ctl needs to be able to set the size so
> > that's the most logical i could come up with...
> 
> See 
> http://git.linuxtv.org/pinchartl/media.git?a=commitdiff;h=10affb3c5e0c8ae74461c1b6a4ca6ed5251c27d8 
> for crop/format implementation for a sensor that supports cropping and 
> binning.

You basically say the set_format should just force the width and height of
the format to the croping rect's width and height if the sensor doesn't
support binning? That would of course be easy to implement.

Btw, i noticed MT9T001 does the register writes on crop->which ==
V4L2_SUBDEV_FORMAT_TRY in mt9t001_set_crop... Looks like a tiny bug.


> 
> > >> +static int mt9m032_set_gain(struct mt9m032 *sensor, s32 val)
> > >> +{
> > >> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > >> +	int digital_gain_val;	/* in 1/8th (0..127) */
> > >> +	int analog_mul;		/* 0 or 1 */
> > >> +	int analog_gain_val;	/* in 1/16th. (0..63) */
> > >> +	u16 reg_val;
> > >> +
> > >> +	digital_gain_val = 51; /* from setup example */
> > > 
> > > So the digital gain isn't configurable ?
> > 
> > Right. That's all that was needed and i couldn't come up with a simple and
> > nice way to map from one scalar to both digital and analog gain in a nice
> > way.
> 
> What about 
> http://git.linuxtv.org/pinchartl/media.git?a=commitdiff;h=10affb3c5e0c8ae74461c1b6a4ca6ed5251c27d8 
> (search for V4L2_CID_GAIN) ?

I though we need to have the analog gain configurable while using the
digital gain too. That actually makes sense in a setting where the lower
digital bits get thrown away on the data path (12bit sensor with just 8bits
used). Ideally the driver would implement something that's general enough
but it's hard to cram that into one scalar. 
But maybe i can just use something similar to what's done for mt9t001...

> 
> > >> +	ret = mt9m032_write_reg(client, MT9M032_PLL_CONFIG1, reg_pll1);
> > >> +	if (!ret)
> > >> +		ret = mt9m032_write_reg(client, 0x10, 0x53); /* Select PLL as clock
> > > 
> > > No magic numbers please.
> > 
> > Undocumented magical values is all that i have here. I just know these
> > values have to go there and are the comment text... Nothing hidden i have
> > access too.
> 
> :-(
> 
> > >> +static int mt9m032_get_chip_ident(struct v4l2_subdev *subdev,
> > >> +		       struct v4l2_dbg_chip_ident *chip)
> > >> +{
> > >> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> > >> +
> > >> +	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_MT9M032,
> > >> 0); +}
> > > 
> > > Is g_chip_ident needed ?
> > 
> > Some comments in the headers said i should implement this...
> 
> See my answer to Hans about this. I don't think the operation is needed in 
> this case.

Ok, i dropped g_chip_ident, if it's needed maybe the framework can just do
the right thing for i2c based sensors anyway.

regards,
 - Martin Hostettler
