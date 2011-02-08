Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56218 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab1BHMCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Feb 2011 07:02:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: martin@neutronstar.dyndns.org
Subject: Re: [PATCH] v4l: Add driver for Micron MT9M032 camera sensor
Date: Tue, 8 Feb 2011 13:02:05 +0100
Cc: linux-media@vger.kernel.org
References: <1295389122-30325-1-git-send-email-martin@neutronstar.dyndns.org> <201101241232.12633.laurent.pinchart@ideasonboard.com> <20110124204539.GA16733@neutronstar.dyndns.org>
In-Reply-To: <20110124204539.GA16733@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102081302.05627.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Martin,

On Monday 24 January 2011 21:45:39 martin@neutronstar.dyndns.org wrote:
> On Mon, Jan 24, 2011 at 12:32:12PM +0100, Laurent Pinchart wrote:
> > On Thursday 20 January 2011 23:56:07 martin@neutronstar.dyndns.org wrote:

[snip]

> > > >> +#define OFFSET_UNCHANGED	0xFFFFFFFF
> > > >> +static int mt9m032_set_pad_geom(struct mt9m032 *sensor,
> > > >> +				struct v4l2_subdev_fh *fh,
> > > >> +				u32 which, u32 pad,
> > > >> +				s32 top, s32 left, s32 width, s32 height)
> > > >> +{
> > > >> +	struct v4l2_mbus_framefmt tmp_format;
> > > >> +	struct v4l2_rect tmp_crop;
> > > >> +	struct v4l2_mbus_framefmt *format;
> > > >> +	struct v4l2_rect *crop;
> > > >> +
> > > >> +	if (pad != 0)
> > > >> +		return -EINVAL;
> > > >> +
> > > >> +	format = __mt9m032_get_pad_format(sensor, fh, which);
> > > >> +	crop = __mt9m032_get_pad_crop(sensor, fh, which);
> > > >> +	if (!format || !crop)
> > > >> +		return -EINVAL;
> > > >> +	if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> > > >> +		tmp_crop = *crop;
> > > >> +		tmp_format = *format;
> > > >> +		format = &tmp_format;
> > > >> +		crop = &tmp_crop;
> > > >> +	}
> > > >> +
> > > >> +	if (top != OFFSET_UNCHANGED)
> > > >> +		crop->top = top & ~0x1;
> > > >> +	if (left != OFFSET_UNCHANGED)
> > > >> +		crop->left = left;
> > > >> +	crop->height = height;
> > > >> +	crop->width = width & ~1;
> > > >> +
> > > >> +	format->height = crop->height;
> > > >> +	format->width = crop->width;
> > > > 
> > > > This looks very weird to me. If your sensor doesn't include a scaler,
> > > > it should support a single fixed format. Crop will then be used to
> > > > select the crop rectangle. You're mixing the two for no obvious
> > > > reason.
> > > 
> > > I think i have to have both size and crop writable. So i wrote the code
> > > to just have format width/height and crop width/height to be equal at
> > > all times. So actually almost all code for crop setting and format are
> > > shared.
> > > 
> > > As you wrote in your recent mail this api isn't really intuitive and
> > > i'm not really sure what's the right thing to do thus i just copied
> > > the semantics from an existing driver with similar capable hardware.
> > > 
> > > This code works nicely and media-ctl needs to be able to set the size
> > > so that's the most logical i could come up with...
> > 
> > See
> > http://git.linuxtv.org/pinchartl/media.git?a=commitdiff;h=10affb3c5e0c8ae
> > 74461c1b6a4ca6ed5251c27d8 for crop/format implementation for a sensor
> > that supports cropping and binning.
> 
> You basically say the set_format should just force the width and height of
> the format to the croping rect's width and height if the sensor doesn't
> support binning? That would of course be easy to implement.

Yes, that's how I think it should be implemented.

> Btw, i noticed MT9T001 does the register writes on crop->which ==
> V4L2_SUBDEV_FORMAT_TRY in mt9t001_set_crop... Looks like a tiny bug.

I saw the bug a couple of weeks ago, I've fixed it and I'll push a new version 
when I'll have time to clean the code a little bit.

-- 
Regards,

Laurent Pinchart
