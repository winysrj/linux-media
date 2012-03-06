Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40655 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab2CFQWV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 11:22:21 -0500
Date: Tue, 6 Mar 2012 18:22:15 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 5/5] v4l: Add driver for Micron MT9M032 camera sensor
Message-ID: <20120306162215.GM1075@valkosipuli.localdomain>
References: <1331035786-8938-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1331035786-8938-6-git-send-email-laurent.pinchart@ideasonboard.com>
 <20120306150403.GG1075@valkosipuli.localdomain>
 <3590523.ZOyvX5TbID@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3590523.ZOyvX5TbID@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Mar 06, 2012 at 05:08:01PM +0100, Laurent Pinchart wrote:
...
> > > +struct mt9m032 {
> > > +	struct v4l2_subdev subdev;
> > > +	struct media_pad pad;
> > > +	struct mt9m032_platform_data *pdata;
> > > +
> > > +	struct v4l2_ctrl_handler ctrls;
> > > +	struct {
> > > +		struct v4l2_ctrl *hflip;
> > > +		struct v4l2_ctrl *vflip;
> > > +	};
> > > +
> > > +	bool streaming;
> > > +
> > > +	int pix_clock;
> > 
> > unsigned?
> 
> No comment ;-) I'll fix this.

:-)

> > > +	struct v4l2_mbus_framefmt format;
> > > +	struct v4l2_rect crop;
> > > +	struct v4l2_fract frame_interval;
> > > +};
> 
> [snip]
> 
> > > +static unsigned long mt9m032_row_time(struct mt9m032 *sensor, int width)
> > > +{
> > > +	int effective_width;
> > 
> > unsigned, this & width?
> 
> ...
> 
> > > +	u64 ns;
> > > +
> > > +	effective_width = width + 716; /* emperical value */
> > > +	ns = div_u64(((u64)1000000000) * effective_width, sensor->pix_clock);
> > > +	dev_dbg(to_dev(sensor),	"MT9M032 line time: %llu ns\n", ns);
> > 
> > The sensor is using rows internally for exposure as is SMIA++ sensor. Should
> > we use a different control or the same?
> > 
> > Some sensors also provide additional fine exposure control, which is in
> > pixels. It doesn't make sense to change the fine exposure time except in
> > very special situations, i.e. normally it's 0.
> 
> I would prefer keeping the same control for now. We have enough new features 
> to introduce already :-)

I'm fine with that. I agree we have more changes I would have hoped for, so
let's not try to make more.

> > > +	return ns;
> > > +}
> > > +
> > > +static int mt9m032_update_timing(struct mt9m032 *sensor,
> > > +				 struct v4l2_fract *interval)
> > > +{
> > > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > > +	struct v4l2_rect *crop = &sensor->crop;
> > > +	unsigned long row_time;
> > > +	unsigned int min_vblank;
> > > +	unsigned int vblank;
> > > +
> > > +	if (!interval)
> > > +		interval = &sensor->frame_interval;
> > > +
> > > +	row_time = mt9m032_row_time(sensor, crop->width);
> > > +
> > > +	vblank = div_u64(1000000000ULL * interval->numerator,
> > > +			 ((u64)interval->denominator) * row_time)
> > > +	       - crop->height;
> > > +
> > > +	if (vblank > MT9M032_MAX_BLANKING_ROWS) {
> > > +		/* hardware limits to 11 bit values */
> > > +		interval->denominator = 1000;
> > > +		interval->numerator =
> > > +			div_u64((crop->height + MT9M032_MAX_BLANKING_ROWS) *
> > > +				(u64)row_time * interval->denominator,
> > > +				1000000000ULL);
> > > +		vblank = div_u64(1000000000ULL * interval->numerator,
> > > +				 ((u64)interval->denominator) * row_time)
> > > +		       - crop->height;
> > > +	}
> > > +	/* enforce minimal 1.6ms blanking time. */
> > > +	min_vblank = 1600000 / row_time;
> > > +	vblank = clamp_t(unsigned int, vblank, min_vblank,
> > > +			 MT9M032_MAX_BLANKING_ROWS);
> > > +
> > > +	return mt9m032_write(client, MT9M032_VBLANK, vblank);
> > > +}
> > 
> > You'd get rid of these calculations with the new sensor control interface.
> > 
> > I'm fine with you starting to support that later on but that would change
> > the user space API for this driver. Is that an issue?
> 
> I don't see that as an issue.

It's agreed then.

...

> > > +static int mt9m032_set_exposure(struct mt9m032 *sensor, s32 val)
> > > +{
> > > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > > +	int shutter_width;
> > > +	u16 high_val, low_val;
> > > +	int ret;
> > 
> > What's the unit of the exposure control? I'd use lines but I think this
> > driver uses something else.
> 
> The driver seems to use microseconds. I'm thinking about switching that to 
> lines. What's your opinion ?

It would probably simplify the driver and lessen the number of the changes
that need to be done later on when switching over to the new sensor control
interface, also to the user space interface.

That said, before the user can get the pixel clock through the pixel rate
control it's not possible to set the exposure time in seconds in a generic
way.

...

> > > +struct mt9m032_platform_data {
> > > +	u32 ext_clock;
> > > +	u32 pix_clock;
> > > +	int invert_pixclock;
> > 
> > unsigned?
> 
> bool ?

Ack.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
