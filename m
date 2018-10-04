Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35935 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbeJEC4E (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 22:56:04 -0400
Received: by mail-lf1-f66.google.com with SMTP id d4-v6so7745593lfa.3
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2018 13:01:15 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Thu, 4 Oct 2018 22:01:12 +0200
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/3] rcar-vin: align format width with hardware limits
Message-ID: <20181004200112.GO24305@bigcity.dyn.berto.se>
References: <20180914021345.9277-1-niklas.soderlund+renesas@ragnatech.se>
 <20180914021345.9277-2-niklas.soderlund+renesas@ragnatech.se>
 <6676e7fa-5548-7c3e-25f0-19bf6b03ed42@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6676e7fa-5548-7c3e-25f0-19bf6b03ed42@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your feedback.

On 2018-09-14 10:47:41 +0200, Hans Verkuil wrote:
> On 09/14/2018 04:13 AM, Niklas Söderlund wrote:
> > The Gen3 datasheets lists specific alignment restrictions compared to
> > Gen2. This was overlooked when adding Gen3 support as no problematic
> > configuration was encountered. However when adding support for Gen3 Up
> > Down Scaler (UDS) strange issues could be observed for odd widths
> > without taking this limit into consideration.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > index dc77682b47857c97..2fc2a05eaeacb134 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > @@ -673,6 +673,21 @@ static void rvin_mc_try_format(struct rvin_dev *vin,
> >  	pix->quantization = V4L2_MAP_QUANTIZATION_DEFAULT(true, pix->colorspace,
> >  							  pix->ycbcr_enc);
> >  
> > +	switch (vin->format.pixelformat) {
> > +	case V4L2_PIX_FMT_NV16:
> > +		pix->width = ALIGN(pix->width, 0x80);
> > +		break;
> > +	case V4L2_PIX_FMT_YUYV:
> > +	case V4L2_PIX_FMT_UYVY:
> > +	case V4L2_PIX_FMT_RGB565:
> > +	case V4L2_PIX_FMT_XRGB555:
> > +		pix->width = ALIGN(pix->width, 0x40);
> > +		break;
> > +	default:
> > +		pix->width = ALIGN(pix->width, 0x20);
> > +		break;
> > +	}
> > +
> >  	rvin_format_align(vin, pix);
> >  }
> >  
> > 
> 
> This looks weird. So for NV16 the width must be a multiple of 128,
> do I read that correctly?
> 
> Are you sure you don't mean bytesperline?
> 
> And if it really is the width, doesn't this place very big constraints
> on the vin driver? If you don't want/need the UDS, then I can imagine
> that you don't want these alignments.

Thanks for brining this up, after more carefully reading the datasheet 
(which is a bit ambiguous in this section) I figured out that this is to 
strict. Will rewrite this patch for v2.

-- 
Regards,
Niklas Söderlund
