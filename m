Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:43063 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753834AbdLHOHB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 09:07:01 -0500
Received: by mail-lf0-f66.google.com with SMTP id 94so12000959lfy.10
        for <linux-media@vger.kernel.org>; Fri, 08 Dec 2017 06:07:01 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 8 Dec 2017 15:06:58 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 13/28] rcar-vin: fix handling of single field frames
 (top, bottom and alternate fields)
Message-ID: <20171208140658.GP31989@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
 <20171208010842.20047-14-niklas.soderlund+renesas@ragnatech.se>
 <1830403.Cn442MVTMc@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1830403.Cn442MVTMc@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your feedback.

On 2017-12-08 11:35:18 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Friday, 8 December 2017 03:08:27 EET Niklas Söderlund wrote:
> > There was never proper support in the VIN driver to deliver ALTERNATING
> > field format to user-space, remove this field option. For sources using
> > this field format instead use the VIN hardware feature of combining the
> > fields to an interlaced format. This mode of operation was previously
> > the default behavior and ALTERNATING was only delivered to user-space if
> > explicitly requested. Allowing this to be explicitly requested was a
> > mistake and was never properly tested and never worked due to the
> > constraints put on the field format when it comes to sequence numbers and
> > timestamps etc.
> 
> I'm puzzled, why can't we support V4L2_FIELD_ALTERNATE if we can support 
> V4L2_FIELD_TOP and V4L2_FIELD_BOTTOM ? I don't dispute the fact that the 
> currently implemented logic might be wrong (although I haven't double-checked 
> that), but what prevents us from implementing it correctly ?

Maybe my commit message is fuzzy. We can support V4L2_FIELD_ALTERNATE as 
a source to the VIN but we can't (yet) support delivering it to 
user-space in a good way. So if we have a video source which outputs 
V4L2_FIELD_ALTERNATE we are fine as we can use the hardware to interlace 
that or only capture the TOP or BOTTOM fields.

But the driver logic to capture frames (the whole dance with single and 
continues capture modes) to be able to deal with situations where 
buffers are not queued fast enough currently prevents us from delivering 
V4L2_FIELD_ALTERNATE to user-space. The problem is we can only capture 
(correctly) ALTERNATE if we run in continues mode, if the driver is feed 
buffers to slow and switches to single capture mode we can't live up to 
the specification of the field order from the documentation:

"If fields are successive, without any dropped fields between them 
(fields can drop individually), can be determined from the struct 
v4l2_buffer sequence field."

So even if in single capture mode we switch between TOP and BOTTOM for 
each capture the sequence number would always be sequential but the 
fields would in temporal time potentially be far apparat (depending on 
how fast user-space queues buffers + the time it takes to shutdown and 
startup the VIN capture).

So instead of badly supporting this field order now I feel it's better 
to not support it and once we tackle the issue of trying to remove 
single capture mode (if at all possible) add support for it. But this is 
a task for a different patch-set as this one is quiet large already and 
it's focus is to add Gen3 support.

> 
> > The height should not be cut in half for the format for TOP or BOTTOM
> > fields settings. This was a mistake and it was made visible by the
> > scaling refactoring. Correct behavior is that the user should request a
> > frame size that fits the half height frame reflected in the field
> > setting. If not the VIN will do its best to scale the top or bottom to
> > the requested format and cropping and scaling do not work as expected.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-dma.c  | 15 +--------
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 48 ++++++++++----------------
> >  2 files changed, 19 insertions(+), 44 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> > b/drivers/media/platform/rcar-vin/rcar-dma.c index
> > 7be5080f742825fb..e6478088d9464221 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > @@ -617,7 +617,6 @@ static int rvin_setup(struct rvin_dev *vin)
> >  	case V4L2_FIELD_INTERLACED_BT:
> >  		vnmc = VNMC_IM_FULL | VNMC_FOC;
> >  		break;
> > -	case V4L2_FIELD_ALTERNATE:
> >  	case V4L2_FIELD_NONE:
> >  		if (vin->continuous) {
> >  			vnmc = VNMC_IM_ODD_EVEN;
> > @@ -757,18 +756,6 @@ static int rvin_get_active_slot(struct rvin_dev *vin,
> > u32 vnms) return 0;
> >  }
> > 
> > -static enum v4l2_field rvin_get_active_field(struct rvin_dev *vin, u32
> > vnms)
> > -{
> > -	if (vin->format.field == V4L2_FIELD_ALTERNATE) {
> > -		/* If FS is set it's a Even field */
> > -		if (vnms & VNMS_FS)
> > -			return V4L2_FIELD_BOTTOM;
> > -		return V4L2_FIELD_TOP;
> > -	}
> > -
> > -	return vin->format.field;
> > -}
> > -
> >  static void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t
> > addr) {
> >  	const struct rvin_video_format *fmt;
> > @@ -941,7 +928,7 @@ static irqreturn_t rvin_irq(int irq, void *data)
> >  		goto done;
> > 
> >  	/* Capture frame */
> > -	vin->queue_buf[slot]->field = rvin_get_active_field(vin, vnms);
> > +	vin->queue_buf[slot]->field = vin->format.field;
> >  	vin->queue_buf[slot]->sequence = sequence;
> >  	vin->queue_buf[slot]->vb2_buf.timestamp = ktime_get_ns();
> >  	vb2_buffer_done(&vin->queue_buf[slot]->vb2_buf, VB2_BUF_STATE_DONE);
> > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> > 9cf9ff48ac1e2f4f..37fe1f6c646b0ea3 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > @@ -102,6 +102,24 @@ static int rvin_get_sd_format(struct rvin_dev *vin,
> > struct v4l2_pix_format *pix) if (ret)
> >  		return ret;
> > 
> > +	switch (fmt.format.field) {
> > +	case V4L2_FIELD_TOP:
> > +	case V4L2_FIELD_BOTTOM:
> > +	case V4L2_FIELD_NONE:
> > +	case V4L2_FIELD_INTERLACED_TB:
> > +	case V4L2_FIELD_INTERLACED_BT:
> > +	case V4L2_FIELD_INTERLACED:
> > +		break;
> > +	case V4L2_FIELD_ALTERNATE:
> > +		/* Use VIN hardware to combine the two fields */
> > +		fmt.format.field = V4L2_FIELD_INTERLACED;
> > +		fmt.format.height *= 2;
> > +		break;
> 
> I don't think this is right. If V4L2_FIELD_ALTERNATE isn't supported it should 
> be rejected in the set format handler, or rather this logic should be moved 
> there. It doesn't belong here, rvin_get_sd_format() should only be called with 
> a validated and supported field.

I might misunderstand you here, fmt.format.field comes from a the 
subdevice, just above this:

    struct v4l2_subdev_format fmt = {
	    .which = V4L2_SUBDEV_FORMAT_ACTIVE,
	    .pad = vin->digital->source_pad,
    };
    int ret;

    ret = v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
    if (ret)
	    return ret;

    switch (fmt.format.field) {
        ...
    }

So the format acted on here is the one from the subdevice, and if it is 
V4L2_FIELD_ALTERNATE it is supported as a source format, just not for 
output to user-space.

> 
> Furthermore treating the pix parameter of this function as both input and 
> output seems very confusing to me. If you want to extend rvin_get_sd_format() 
> beyond just getting the format from the subdev then please document the 
> function with kerneldoc, and let's try to make its API clear.

This comment confuses me, are we looking at the same change? The only 
reference I have to the pix parameter in rvin_get_sd_format() is just 
before the function returns and it's:

   v4l2_fill_pix_format(pix, &fmt.format);

So it's only used as an output for this function.

> 
> > +	default:
> > +		vin->format.field = V4L2_FIELD_NONE;
> > +		break;
> > +	}
> > +
> >  	v4l2_fill_pix_format(pix, &fmt.format);
> > 
> >  	return 0;
> > @@ -115,33 +133,6 @@ static int rvin_reset_format(struct rvin_dev *vin)
> >  	if (ret)
> >  		return ret;
> > 
> > -	/*
> > -	 * If the subdevice uses ALTERNATE field mode and G_STD is
> > -	 * implemented use the VIN HW to combine the two fields to
> > -	 * one INTERLACED frame. The ALTERNATE field mode can still
> > -	 * be requested in S_FMT and be respected, this is just the
> > -	 * default which is applied at probing or when S_STD is called.
> > -	 */
> > -	if (vin->format.field == V4L2_FIELD_ALTERNATE &&
> > -	    v4l2_subdev_has_op(vin_to_source(vin), video, g_std))
> > -		vin->format.field = V4L2_FIELD_INTERLACED;
> > -
> > -	switch (vin->format.field) {
> > -	case V4L2_FIELD_TOP:
> > -	case V4L2_FIELD_BOTTOM:
> > -	case V4L2_FIELD_ALTERNATE:
> > -		vin->format.height /= 2;
> > -		break;
> > -	case V4L2_FIELD_NONE:
> > -	case V4L2_FIELD_INTERLACED_TB:
> > -	case V4L2_FIELD_INTERLACED_BT:
> > -	case V4L2_FIELD_INTERLACED:
> > -		break;
> > -	default:
> > -		vin->format.field = V4L2_FIELD_NONE;
> > -		break;
> > -	}
> > -
> >  	vin->crop.top = vin->crop.left = 0;
> >  	vin->crop.width = vin->format.width;
> >  	vin->crop.height = vin->format.height;
> > @@ -226,9 +217,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
> >  	switch (pix->field) {
> >  	case V4L2_FIELD_TOP:
> >  	case V4L2_FIELD_BOTTOM:
> > -	case V4L2_FIELD_ALTERNATE:
> > -		pix->height /= 2;
> > -		break;
> >  	case V4L2_FIELD_NONE:
> >  	case V4L2_FIELD_INTERLACED_TB:
> >  	case V4L2_FIELD_INTERLACED_BT:
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
