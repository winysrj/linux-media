Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f171.google.com ([209.85.208.171]:34741 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbeJEDYt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 23:24:49 -0400
Received: by mail-lj1-f171.google.com with SMTP id j17-v6so323069lja.1
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2018 13:29:53 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Thu, 4 Oct 2018 22:29:51 +0200
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 1/3] rcar-vin: align width before stream start
Message-ID: <20181004202950.GQ24305@bigcity.dyn.berto.se>
References: <20181004200402.15113-1-niklas.soderlund+renesas@ragnatech.se>
 <20181004200402.15113-2-niklas.soderlund+renesas@ragnatech.se>
 <3937980.o2kZMfQ5OL@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3937980.o2kZMfQ5OL@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your feedback.

On 2018-10-04 23:11:50 +0300, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Thursday, 4 October 2018 23:04:00 EEST Niklas Söderlund wrote:
> > Instead of aligning the image width to match the image stride at stream
> > start time do so when configuring the format. This allows the format
> > width to strictly match the image stride which is useful when enabling
> > scaling on Gen3.
> 
> But is this required ? Aren't there use cases where an image with a width not 
> aligned with the stride requirements should be captured ? As long as the 
> stride itself matches the hardware requirements, I don't see a reason to 
> disallow that.

Yes there is a use-case for that. And the rcar-vin driver is starting to 
reaching a point where the whole format handling for buffers, source 
format, croping and scaling needs to be rewritten to enable more valid 
use-cases.

This fix is however in my view required at this time with the current 
driver design. If we keep aligning the width at stream on and enable the 
UDS it becomes apparent that when the alignment is needed the values for 
the stride register conflicts which how the scaling coefficients are 
calculated and the captured frame is distorted.

My hope is to add upstream to support for the UDS, support for 
sequential field captures and some more output pixel formats. And once 
the driver feature complete on Gen3 come back and simplify and if 
possible align the Gen2 and Gen3 format handling which in part adds to 
the somewhat messy current state.

> 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-dma.c  | 5 +----
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 9 +++++++++
> >  2 files changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> > b/drivers/media/platform/rcar-vin/rcar-dma.c index
> > 92323310f7352147..e752bc86e40153b1 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > @@ -597,10 +597,7 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
> >  	if (vin->info->model != RCAR_GEN3)
> >  		rvin_crop_scale_comp_gen2(vin);
> > 
> > -	if (vin->format.pixelformat == V4L2_PIX_FMT_NV16)
> > -		rvin_write(vin, ALIGN(vin->format.width, 0x20), VNIS_REG);
> > -	else
> > -		rvin_write(vin, ALIGN(vin->format.width, 0x10), VNIS_REG);
> > +	rvin_write(vin, vin->format.width, VNIS_REG);
> >  }
> > 
> >  /*
> > ---------------------------------------------------------------------------
> > -- diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> > dc77682b47857c97..94bc559a0cb1e47a 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > @@ -96,6 +96,15 @@ static void rvin_format_align(struct rvin_dev *vin,
> > struct v4l2_pix_format *pix) pix->pixelformat == V4L2_PIX_FMT_XBGR32))
> >  		pix->pixelformat = RVIN_DEFAULT_FORMAT;
> > 
> > +	switch (pix->pixelformat) {
> > +	case V4L2_PIX_FMT_NV16:
> > +		pix->width = ALIGN(pix->width, 0x20);
> > +		break;
> > +	default:
> > +		pix->width = ALIGN(pix->width, 0x10);
> > +		break;
> > +	}
> > +
> >  	switch (pix->field) {
> >  	case V4L2_FIELD_TOP:
> >  	case V4L2_FIELD_BOTTOM:
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 
> 

-- 
Regards,
Niklas Söderlund
