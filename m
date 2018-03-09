Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:37419 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751187AbeCIQRQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 11:17:16 -0500
Received: by mail-lf0-f66.google.com with SMTP id y19-v6so13935079lfd.4
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2018 08:17:15 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 9 Mar 2018 17:17:11 +0100
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v12 11/33] rcar-vin: set a default field to fallback on
Message-ID: <20180309161711.GI2205@bigcity.dyn.berto.se>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
 <20180307220511.9826-12-niklas.soderlund+renesas@ragnatech.se>
 <4181fb92-5ac9-9ad8-a60d-65c57f5baaa0@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4181fb92-5ac9-9ad8-a60d-65c57f5baaa0@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your feedback, I don't think I can appreciate how happy I'm 
that you reviewed this patch-set, Thank you!

On 2018-03-09 16:25:23 +0100, Hans Verkuil wrote:
> On 07/03/18 23:04, Niklas Söderlund wrote:
> > If the field is not supported by the driver it should not try to keep
> > the current field. Instead it should set it to a default fallback. Since
> > trying a format should always result in the same state regardless of the
> > current state of the device.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > index c2265324c7c96308..ebcd78b1bb6e8cb6 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > @@ -23,6 +23,7 @@
> >  #include "rcar-vin.h"
> >  
> >  #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
> > +#define RVIN_DEFAULT_FIELD	V4L2_FIELD_NONE
> >  
> >  /* -----------------------------------------------------------------------------
> >   * Format Conversions
> > @@ -143,7 +144,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
> >  	case V4L2_FIELD_INTERLACED:
> >  		break;
> >  	default:
> > -		vin->format.field = V4L2_FIELD_NONE;
> > +		vin->format.field = RVIN_DEFAULT_FIELD;
> >  		break;
> >  	}
> >  
> > @@ -213,10 +214,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
> >  	u32 walign;
> >  	int ret;
> >  
> > -	/* Keep current field if no specific one is asked for */
> > -	if (pix->field == V4L2_FIELD_ANY)
> > -		pix->field = vin->format.field;
> > -
> >  	/* If requested format is not supported fallback to the default */
> >  	if (!rvin_format_from_pixel(pix->pixelformat)) {
> >  		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
> > @@ -246,7 +243,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
> >  	case V4L2_FIELD_INTERLACED:
> >  		break;
> >  	default:
> > -		pix->field = V4L2_FIELD_NONE;
> > +		pix->field = RVIN_DEFAULT_FIELD;
> >  		break;
> >  	}
> >  
> > 
> 
> I wonder if this code is correct. What if the adv7180 is the source? Does that even
> support FIELD_NONE? I suspect that the default field should actually depend on the
> source. FIELD_NONE for dv_timings based or sensor based subdevs and FIELD_INTERLACED
> for SDTV (g/s_std) subdevs.

I see what you mean but I think this is correct. The field is only set 
to V4L2_FIELD_NONE if the field returned from the source is not one of 
TOP, BOTTOM, ALTERNATE, NONE, INERLACED, INTERLACED_TB, INTERLACED_BT.  
So it works perfectly with the adv7180 as it will return 
V4L2_FIELD_INTERLACED and then VIN will accept that and not change it.  
So the field do depend on the source both before and after this change.

This check is just to block the driver reporting SEQ_TB/BT if a source 
where to report that (I known of no source who reports that) to 
userspace as the driver do not yet support this.  I have patches to add 
support for this but I will keep them back until this series are picked 
up :-)

> 
> I might very well be missing something here but it looks suspicious.
> 
> Regards,
> 
> 	Hans

-- 
Regards,
Niklas Söderlund
