Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:43820 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752091AbeCCQXm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2018 11:23:42 -0500
Received: by mail-lf0-f67.google.com with SMTP id q69so17460458lfi.10
        for <linux-media@vger.kernel.org>; Sat, 03 Mar 2018 08:23:41 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sat, 3 Mar 2018 17:23:39 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v11 12/32] rcar-vin: fix handling of single field frames
 (top, bottom and alternate fields)
Message-ID: <20180303162339.GK12470@bigcity.dyn.berto.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
 <20180302015751.25596-13-niklas.soderlund+renesas@ragnatech.se>
 <2141364.444NBPQ5qU@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2141364.444NBPQ5qU@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your comments.

On 2018-03-02 12:48:55 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Friday, 2 March 2018 03:57:31 EET Niklas Söderlund wrote:
> > There was never proper support in the VIN driver to deliver ALTERNATING
> > field format to user-space, remove this field option. The problem is
> > that ALTERNATING filed order requires the sequence numbers of buffers
> 
> s/filed/field/
> 
> > returned to userspace to reflect if fields where dropped or not,
> > something which is not possible with the VIN drivers capture logic.
> > 
> > The VIN driver can still capture from a video source which delivers
> > frames in ALTERNATING field order, but needs to combine them using the
> > VIN hardware into INTERLACED field order. Before this change if a source
> > was delivering fields using ALTERNATE the driver would default to
> > combining them using this hardware feature. Only if the user explicitly
> > requested ALTERNATE filed order would incorrect frames be delivered.
> > 
> > The height should not be cut in half for the format for TOP or BOTTOM
> > fields settings. This was a mistake and it was made visible by the
> > scaling refactoring. Correct behavior is that the user should request a
> > frame size that fits the half height frame reflected in the field
> > setting. If not the VIN will do its best to scale the top or bottom to
> > the requested format and cropping and scaling do not work as expected.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-dma.c  | 15 +----------
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 40 +++++++-------------------
> >  2 files changed, 10 insertions(+), 45 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> > b/drivers/media/platform/rcar-vin/rcar-dma.c index
> > fd14be20a6604d7a..c8831e189d362c8b 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > @@ -617,7 +617,6 @@ static int rvin_setup(struct rvin_dev *vin)
> >  	case V4L2_FIELD_INTERLACED_BT:
> >  		vnmc = VNMC_IM_FULL | VNMC_FOC;
> >  		break;
> > -	case V4L2_FIELD_ALTERNATE:
> 
> Just to make sure I understand things correctly, field will never be 
> V4L2_FIELD_ALTERNATE after this patch, right ?

That is the intention, but as you noticed bellow it's not perfect until 
4 patches later in the series, see bellow.

> 
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
> > ebcd78b1bb6e8cb6..cef9070884d93ba6 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > @@ -121,33 +121,6 @@ static int rvin_reset_format(struct rvin_dev *vin)
> >  	vin->format.colorspace	= mf->colorspace;
> >  	vin->format.field	= mf->field;
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
> > -		vin->format.field = RVIN_DEFAULT_FIELD;
> > -		break;
> > -	}
> > -
> 
> I might be wrong, but if this function is called from S_STD or S_DV_TIMINGS 
> and userspace calls G_FMT immediately after that, won't it get 
> V4L2_FIELD_ALTERNATE (assuming that's what the sensor produces of course) ?

Yes you are correct, this is 'fixed' in 'rcar-vin: read subdevice format 
for crop only when needed' where the format alignment rework is 
completed.

I could add a specific hack which is removed 4 patches later or we can 
we live with this problem until that time. Normally I would not hesitate 
to fix this here, but since ALTERNATE is already broken before the 
rework I wonder if the effort really is worth it. What would you 
recommend?

None the less I'm impressed you found this, I wish to one day posses 
your review skill!

> 
> >  	rvin_reset_crop_compose(vin);
> > 
> >  	vin->format.bytesperline = rvin_format_bytesperline(&vin->format);
> > @@ -233,15 +206,20 @@ static int __rvin_try_format(struct rvin_dev *vin,
> >  	switch (pix->field) {
> >  	case V4L2_FIELD_TOP:
> >  	case V4L2_FIELD_BOTTOM:
> > -	case V4L2_FIELD_ALTERNATE:
> > -		pix->height /= 2;
> > -		source->height /= 2;
> > -		break;
> >  	case V4L2_FIELD_NONE:
> >  	case V4L2_FIELD_INTERLACED_TB:
> >  	case V4L2_FIELD_INTERLACED_BT:
> >  	case V4L2_FIELD_INTERLACED:
> >  		break;
> > +	case V4L2_FIELD_ALTERNATE:
> > +		/*
> > +		 * Driver do not (yet) support outputting ALTERNATE to a
> 
> While at it, s/do/does/
> 
> > +		 * userspace. It does support outputting INTERLACED so use
> > +		 * the VIN hardware to combine the two fields.
> > +		 */
> > +		pix->field = V4L2_FIELD_INTERLACED;
> > +		pix->height *= 2;
> > +		break;
> >  	default:
> >  		pix->field = RVIN_DEFAULT_FIELD;
> >  		break;
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
