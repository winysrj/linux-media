Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43559 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754771AbZHCMbJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Aug 2009 08:31:09 -0400
Date: Mon, 3 Aug 2009 14:31:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Eric Miao <eric.y.miao@gmail.com>
cc: Marek Vasut <marek.vasut@gmail.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mike Rapoport <mike@compulab.co.il>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
Subject: Re: [PATCH] Add RGB555X and RGB565X formats to pxa-camera
In-Reply-To: <4A76CB7C.10401@gmail.com>
Message-ID: <Pine.LNX.4.64.0908031415370.5310@axis700.grange>
References: <200908031031.00676.marek.vasut@gmail.com> <4A76CB7C.10401@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 3 Aug 2009, Eric Miao wrote:

> Marek Vasut wrote:
> > Hi!
> > 
> > Eric, would you mind applying ?
> > 
> > From 4dcbff010e996f4c6e5761b3c19f5d863ab51b39 Mon Sep 17 00:00:00 2001
> > From: Marek Vasut <marek.vasut@gmail.com>
> > Date: Mon, 3 Aug 2009 10:27:57 +0200
> > Subject: [PATCH] Add RGB555X and RGB565X formats to pxa-camera
> > 
> > Those formats are requiered on widely used OmniVision OV96xx cameras.
> > Those formats are nothing more then endian-swapped RGB555 and RGB565.
> > 
> > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> 
> Acked-by: Eric Miao <eric.y.miao@gmail.com>
> 
> Guennadi,
> 
> Would be better if this gets merged by you, thanks.

Indeed it would, and I do have a couple of questions to this and related 
patches:

1. Marek, you're saying, you need these formats for the OV96xx camera. Yre 
you using the patch from Stefan Herbrechtsmeier to support ov96xx or some 
other?

2. Mike, while reviewing this patch I came across code in 
pxa_camera_setup_cicr(), introduced by your earlier patch:

	case V4L2_PIX_FMT_RGB555:
		cicr1 |= CICR1_RGB_BPP_VAL(1) | CICR1_RGBT_CONV_VAL(2) |
			CICR1_TBIT | CICR1_COLOR_SP_VAL(1);
		break;

Why are you enabling the RGB to RGBT conversion here unconditionally? 
Generally, what are the advantages of configuring CICR1 for a specific RGB 
format compared to using just a raw capture? Do I understand it right, 
that ATM we are not using any of those features?

Thanks
Guennadi

> 
> > ---
> >  drivers/media/video/pxa_camera.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/pxa_camera.c 
> > b/drivers/media/video/pxa_camera.c
> > index 46e0d8a..de0fc8a 100644
> > --- a/drivers/media/video/pxa_camera.c
> > +++ b/drivers/media/video/pxa_camera.c
> > @@ -1222,6 +1222,8 @@ static int required_buswidth(const struct 
> > soc_camera_data_format *fmt)
> >  	case V4L2_PIX_FMT_YVYU:
> >  	case V4L2_PIX_FMT_RGB565:
> >  	case V4L2_PIX_FMT_RGB555:
> > +	case V4L2_PIX_FMT_RGB565X:
> > +	case V4L2_PIX_FMT_RGB555X:
> >  		return 8;
> >  	default:
> >  		return fmt->depth;
> > @@ -1260,6 +1262,8 @@ static int pxa_camera_get_formats(struct 
> > soc_camera_device *icd, int idx,
> >  	case V4L2_PIX_FMT_YVYU:
> >  	case V4L2_PIX_FMT_RGB565:
> >  	case V4L2_PIX_FMT_RGB555:
> > +	case V4L2_PIX_FMT_RGB565X:
> > +	case V4L2_PIX_FMT_RGB555X:
> >  		formats++;
> >  		if (xlate) {
> >  			xlate->host_fmt = icd->formats + idx;
> 

---
Guennadi Liakhovetski
