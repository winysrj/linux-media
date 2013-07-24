Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:49965 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3GXUij (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 16:38:39 -0400
Date: Wed, 24 Jul 2013 22:38:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp
Subject: Re: [PATCH v8] V4L2: soc_camera: Renesas R-Car VIN driver
In-Reply-To: <51F02CA1.7050603@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1307242227141.5611@axis700.grange>
References: <201307200314.35345.sergei.shtylyov@cogentembedded.com>
 <Pine.LNX.4.64.1307241731560.2179@axis700.grange> <51F02CA1.7050603@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir

On Wed, 24 Jul 2013, Vladimir Barinov wrote:

> Hi Guennadi,
> 
> Thank you for the v8 review.
> 
> On 07/24/2013 08:14 PM, Guennadi Liakhovetski wrote:
> > [snip]
> > > +	/* output format */
> > > +	switch (icd->current_fmt->host_fmt->fourcc) {
> > > +	case V4L2_PIX_FMT_NV16:
> > > +		iowrite32(ALIGN(cam->width * cam->height, 0x80),
> > > +			  priv->base + VNUVAOF_REG);
> > > +		dmr = VNDMR_DTMD_YCSEP;
> > > +		output_is_yuv = true;
> > > +		break;
> > > +	case V4L2_PIX_FMT_YUYV:
> > > +		dmr = VNDMR_BPSM;
> > > +		output_is_yuv = true;
> > > +		break;
> > > +	case V4L2_PIX_FMT_UYVY:
> > > +		dmr = 0;
> > > +		output_is_yuv = true;
> > > +		break;
> > > +	case V4L2_PIX_FMT_RGB555X:
> > > +		dmr = VNDMR_DTMD_ARGB1555;
> > > +		break;
> > > +	case V4L2_PIX_FMT_RGB565:
> > > +		dmr = 0;
> > > +		break;
> > > +	case V4L2_PIX_FMT_RGB32:
> > > +		if (priv->chip == RCAR_H1 || priv->chip == RCAR_E1) {
> > > +			dmr = VNDMR_EXRGB;
> > > +			break;
> > > +		}
> > > +	default:
> > > +		BUG();
> > as commented above, please, remove
> Does WARN_ON(1) work instead of removal?

Sorry, by "remove" I certainly meant replace with a proper handling, not 
just delete. In principle the above condition should never be entered, 
right? Also for fmt == V4L2_PIX_FMT_RGB32 but chip not one of RCAR_H1 or 
RCAR_E1? Well, this function is called from your driver's .buf_queue(), 
which doesn't return an error. But yes, I would make rcar_vin_setup() 
issue a warning and return an error and then, back in 
rcar_vin_videobuf_queue() return the buffer with an error code (goto 
error).

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
