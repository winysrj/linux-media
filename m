Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49295 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab1IANrw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 09:47:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] mt9t001: Aptina (Micron) MT9T001 3MP sensor driver
Date: Thu, 1 Sep 2011 15:48:22 +0200
Cc: linux-media@vger.kernel.org
References: <1314793452-23641-1-git-send-email-laurent.pinchart@ideasonboard.com> <201109011105.06121.laurent.pinchart@ideasonboard.com> <20110901103310.GX12368@valkosipuli.localdomain>
In-Reply-To: <20110901103310.GX12368@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109011548.22376.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 01 September 2011 12:33:11 Sakari Ailus wrote:
> On Thu, Sep 01, 2011 at 11:05:05AM +0200, Laurent Pinchart wrote:
> > On Wednesday 31 August 2011 20:23:33 Sakari Ailus wrote:
> > > On Wed, Aug 31, 2011 at 02:24:12PM +0200, Laurent Pinchart wrote:
> > > > The MT9T001 is a parallel 3MP sensor from Aptina (formerly Micron)
> > > > controlled through I2C.
> > > > 
> > > > The driver creates a V4L2 subdevice. It currently supports binning
> > > > and cropping, and the gain, exposure, test pattern and black level
> > > > controls.
> > > > 
> > > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[snip]

> > > > +#define V4L2_CID_TEST_PATTERN		(V4L2_CID_USER_BASE | 0x1001)
> > > 
> > > Thest pattern is something that almost every sensor have.
> > > 
> > > > +#define V4L2_CID_GAIN_RED		(V4L2_CTRL_CLASS_CAMERA | 0x1001)
> > > > +#define V4L2_CID_GAIN_GREEN1		(V4L2_CTRL_CLASS_CAMERA | 0x1002)
> > > > +#define V4L2_CID_GAIN_GREEN2		(V4L2_CTRL_CLASS_CAMERA | 0x1003)

[snip]

> > > Also these are quite low level controls as opposed to the other higher
> > > level controls in this class. I wonder if creating a separate class for
> > > them would make sense. We'll need a new class for the hblank/vblank
> > > controls anyway. I might call it "sensor".
> > > 
> > > These controls could be also standardised.
> > 
> > I agree.
> > 
> > A "sensor" control class might make sense for these 5 controls, but they
> > can also be useful for non-sensor hardware (for instance with an analog
> > pixel decoder).
> 
> What about calling it differently then?
> 
> V4L2_CTRL_CLASS_SOURCE
> V4L2_CTRL_CLASS_IMAGE_SOURCE
> V4L2_CTRL_CLASS_MBUS_SOURCE

Calling differently is probably a good idea. I'm not sure which name is the 
best though. I need to sleep on that.

Gain is an issue, as it can be applied at any stage in the pipeline. As such 
it doesn't really belong to a "source" class.

> > > > +#define V4L2_CID_GAIN_BLUE		(V4L2_CTRL_CLASS_CAMERA | 0x1004)
> > > > +
> > > > +static int mt9t001_gain_data(s32 *gain)
> > > > +{
> > > > +	/* Gain is controlled by 2 analog stages and a digital stage. Valid
> > > > +	 * values for the 3 stages are
> > > > +	 *
> > > > +	 * Stage		Min	Max	Step
> > > > +	 * ------------------------------------------
> > > > +	 * First analog stage	x1	x2	1
> > > > +	 * Second analog stage	x1	x4	0.125
> > > > +	 * Digital stage	x1	x16	0.125
> > > > +	 *
> > > > +	 * To minimize noise, the gain stages should be used in the second
> > > > +	 * analog stage, first analog stage, digital stage order. Gain from
> > > > a +	 * previous stage should be pushed to its maximum value before
> > > > the next +	 * stage is used.
> > > > +	 */
> > > > +	if (*gain <= 32)
> > > > +		return *gain;
> > > > +
> > > > +	if (*gain <= 64) {
> > > > +		*gain &= ~1;
> > > > +		return (1 << 6) | (*gain >> 1);
> > > > +	}
> > > > +
> > > > +	*gain &= ~7;
> > > > +	return ((*gain - 64) << 5) | (1 << 6) | 32;
> > > > +}
> > > 
> > > This one looks very similar to another Aptina sensor driver. My comment
> > > back then was that the analog and digital gain should be separate
> > > controls as the user typically would e.g. want to know (s)he's using
> > > digital gain instead of analog one.
> > > 
> > > What about implementing this?
> > > 
> > > It's a good question whether we need one or two new controls. If the
> > > answer is two, then how do they relate to the existing control?
> > 
> > I'm not too sure about this. If an application needs that much control
> > over the hardware, wouldn't it be hardware-specific anyway, and know
> > about control ranges ? The mt9t001 actually has 3 gain stages, so one
> > might even argue that we should expose 3 gain controls :-)
> 
> At least we should have two different ones. The driver might implement a
> policy for the single exposure control which would be combination of the
> two, but I'd rather see this done more genericly in libv4l: the algorithm
> is trivial and the same, and I also think this is relatively generic.

The algorithm isn't that generic, it depends on the hardware and how the gain 
stages are implemented.

> I don't think there's a need to show the secondary analog gain stage to the
> user, especially if the relation of the two stages is so simple. Are the
> units also the same?

I'm not sure what you mean here. Gains have no units :-)

-- 
Regards,

Laurent Pinchart
