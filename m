Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53934 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaCKQHI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 12:07:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 27/48] v4l: Validate fields in the core code for subdev EDID ioctls
Date: Tue, 11 Mar 2014 17:08:42 +0100
Message-ID: <3176580.C10mxSGlFc@avalon>
In-Reply-To: <531F2F5B.1040805@xs4all.nl>
References: <1394493359-14115-28-git-send-email-laurent.pinchart@ideasonboard.com> <1394550593-25191-1-git-send-email-laurent.pinchart@ideasonboard.com> <531F2F5B.1040805@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 11 March 2014 16:44:27 Hans Verkuil wrote:
> On 03/11/2014 04:09 PM, Laurent Pinchart wrote:
> > The subdev EDID ioctls receive a pad field that must reference an
> > existing pad and an EDID field that must point to a buffer. Validate
> > both fields in the core code instead of duplicating validation in all
> > drivers.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Here is my:
> 
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> But take note: the adv7604 driver does not handle a get_edid with
> edid->blocks == 0 correctly: it should fill in the blocks field with the
> real number of blocks and return 0 instead of returning EINVAL.

Should it also set edid->start_block to 0 ?

> I also read through the spec again and it does not actually explicitly say
> that you can use G_EDID with edid->blocks == 0, but I think it makes a lot
> of sense to do that.
> 
> All existing drivers that use get_edid all return -EINVAL if blocks == 0,
> so this patch does not change anything with that.
> 
> I plan on making a patch to clarify the spec and update the drivers, but you
> might want to make a patch for adv7604 yourself instead of waiting for me.
> I leave that up to you. Anyway, this patch is fine.
> 
> Regards,
> 
> 	Hans
> 
> > ---
> > 
> >  drivers/media/i2c/ad9389b.c           |  2 --
> >  drivers/media/i2c/adv7511.c           |  2 --
> >  drivers/media/i2c/adv7604.c           |  4 ----
> >  drivers/media/i2c/adv7842.c           |  4 ----
> >  drivers/media/v4l2-core/v4l2-subdev.c | 24 ++++++++++++++++++++----
> >  5 files changed, 20 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
> > index 4cdff9e..5b78828 100644
> > --- a/drivers/media/i2c/ad9389b.c
> > +++ b/drivers/media/i2c/ad9389b.c
> > @@ -683,8 +683,6 @@ static int ad9389b_get_edid(struct v4l2_subdev *sd,
> > 
> >  		return -EINVAL;
> >  	
> >  	if (edid->blocks == 0 || edid->blocks > 256)
> >  	
> >  		return -EINVAL;
> > 
> > -	if (!edid->edid)
> > -		return -EINVAL;
> > 
> >  	if (!state->edid.segments) {
> >  	
> >  		v4l2_dbg(1, debug, sd, "EDID segment 0 not found\n");
> >  		return -ENODATA;
> > 
> > diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
> > index de7ddf5..ff1c2cd 100644
> > --- a/drivers/media/i2c/adv7511.c
> > +++ b/drivers/media/i2c/adv7511.c
> > @@ -784,8 +784,6 @@ static int adv7511_get_edid(struct v4l2_subdev *sd,
> > 
> >  		return -EINVAL;
> >  	
> >  	if ((edid->blocks == 0) || (edid->blocks > 256))
> >  	
> >  		return -EINVAL;
> > 
> > -	if (!edid->edid)
> > -		return -EINVAL;
> > 
> >  	if (!state->edid.segments) {
> >  	
> >  		v4l2_dbg(1, debug, sd, "EDID segment 0 not found\n");
> >  		return -ENODATA;
> > 
> > diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> > index 71c8570..de3db42 100644
> > --- a/drivers/media/i2c/adv7604.c
> > +++ b/drivers/media/i2c/adv7604.c
> > @@ -1673,8 +1673,6 @@ static int adv7604_get_edid(struct v4l2_subdev *sd,
> > struct v4l2_subdev_edid *edi> 
> >  		return -EINVAL;
> >  	
> >  	if (edid->start_block == 1)
> >  	
> >  		edid->blocks = 1;
> > 
> > -	if (!edid->edid)
> > -		return -EINVAL;
> > 
> >  	if (edid->blocks > state->edid.blocks)
> >  	
> >  		edid->blocks = state->edid.blocks;
> > 
> > @@ -1761,8 +1759,6 @@ static int adv7604_set_edid(struct v4l2_subdev *sd,
> > struct v4l2_subdev_edid *edi> 
> >  		edid->blocks = 2;
> >  		return -E2BIG;
> >  	
> >  	}
> > 
> > -	if (!edid->edid)
> > -		return -EINVAL;
> > 
> >  	v4l2_dbg(2, debug, sd, "%s: write EDID pad %d, edid.present = 
0x%x\n",
> >  	
> >  			__func__, edid->pad, state->edid.present);
> > 
> > diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
> > index a319275..3c5a7d9 100644
> > --- a/drivers/media/i2c/adv7842.c
> > +++ b/drivers/media/i2c/adv7842.c
> > @@ -2035,8 +2035,6 @@ static int adv7842_get_edid(struct v4l2_subdev *sd,
> > struct v4l2_subdev_edid *edi> 
> >  		return -EINVAL;
> >  	
> >  	if (edid->start_block == 1)
> >  	
> >  		edid->blocks = 1;
> > 
> > -	if (!edid->edid)
> > -		return -EINVAL;
> > 
> >  	switch (edid->pad) {
> > 
> >  	case ADV7842_EDID_PORT_A:
> > @@ -2071,8 +2069,6 @@ static int adv7842_set_edid(struct v4l2_subdev *sd,
> > struct v4l2_subdev_edid *e)> 
> >  		return -EINVAL;
> >  	
> >  	if (e->blocks > 2)
> >  	
> >  		return -E2BIG;
> > 
> > -	if (!e->edid)
> > -		return -EINVAL;
> > 
> >  	/* todo, per edid */
> >  	state->aspect_ratio = v4l2_calc_aspect_ratio(e->edid[0x15],
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
> > b/drivers/media/v4l2-core/v4l2-subdev.c index 853fb84..f6185f9 100644
> > --- a/drivers/media/v4l2-core/v4l2-subdev.c
> > +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> > @@ -349,11 +349,27 @@ static long subdev_do_ioctl(struct file *file,
> > unsigned int cmd, void *arg)> 
> >  			sd, pad, set_selection, subdev_fh, sel);
> >  	
> >  	}
> > 
> > -	case VIDIOC_SUBDEV_G_EDID:
> > -		return v4l2_subdev_call(sd, pad, get_edid, arg);
> > +	case VIDIOC_SUBDEV_G_EDID: {
> > +		struct v4l2_subdev_edid *edid = arg;
> > 
> > -	case VIDIOC_SUBDEV_S_EDID:
> > -		return v4l2_subdev_call(sd, pad, set_edid, arg);
> > +		if (edid->pad >= sd->entity.num_pads)
> > +			return -EINVAL;
> > +		if (edid->blocks && edid->edid == NULL)
> > +			return -EINVAL;
> > +
> > +		return v4l2_subdev_call(sd, pad, get_edid, edid);
> > +	}
> > +
> > +	case VIDIOC_SUBDEV_S_EDID: {
> > +		struct v4l2_subdev_edid *edid = arg;
> > +
> > +		if (edid->pad >= sd->entity.num_pads)
> > +			return -EINVAL;
> > +		if (edid->blocks && edid->edid == NULL)
> > +			return -EINVAL;
> > +
> > +		return v4l2_subdev_call(sd, pad, set_edid, edid);
> > +	}
> > 
> >  	case VIDIOC_SUBDEV_DV_TIMINGS_CAP: {
> >  	
> >  		struct v4l2_dv_timings_cap *cap = arg;

-- 
Regards,

Laurent Pinchart

