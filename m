Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:42006 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755823Ab0HETZ5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Aug 2010 15:25:57 -0400
Date: Thu, 5 Aug 2010 21:25:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <mgr@pengutronix.de>
cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	baruch@tkos.co.il, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 2/5] mx2_camera: remove emma limitation for RGB565
In-Reply-To: <20100804102727.GB10780@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1008052112440.26127@axis700.grange>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280828276-483-3-git-send-email-m.grzeschik@pengutronix.de>
 <Pine.LNX.4.64.1008041149470.29386@axis700.grange> <20100804102727.GB10780@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Aug 2010, Michael Grzeschik wrote:

> On Wed, Aug 04, 2010 at 11:55:39AM +0200, Guennadi Liakhovetski wrote:
> > On Tue, 3 Aug 2010, Michael Grzeschik wrote:
> > 
> > > In the current source status the emma has no limitation for any PIXFMT
> > > since the data is parsed raw and unprocessed into the memory.
> > 
> > I'd like some explanation for this one too, please. What about
> > 
> > +	/*
> > +	 * We only use the EMMA engine to get rid of the broken
> > +	 * DMA Engine. No color space consversion at the moment.
> > +	 * We adjust incoming and outgoing pixelformat to rgb16
> > +	 * and adjust the bytesperline accordingly.
> > +	 */
> > +	writel(PRP_CNTL_CH1EN |
> > +			PRP_CNTL_CSIEN |
> > +			PRP_CNTL_DATA_IN_RGB16 |
> > +			PRP_CNTL_CH1_OUT_RGB16 |
> > +			PRP_CNTL_CH1_LEN |
> > +			PRP_CNTL_CH1BYP |
> > +			PRP_CNTL_CH1_TSKIP(0) |
> > +			PRP_CNTL_IN_TSKIP(0),
> > +			pcdev->base_emma + PRP_CNTL);
> > +
> > +	writel(((bytesperline >> 1) << 16) | icd->user_height,
> > +			pcdev->base_emma + PRP_SRC_FRAME_SIZE);
> > +	writel(((bytesperline >> 1) << 16) | icd->user_height,
> > +			pcdev->base_emma + PRP_CH1_OUT_IMAGE_SIZE);
> > +	writel(bytesperline,
> > +			pcdev->base_emma + PRP_DEST_CH1_LINE_STRIDE);
> > +	writel(0x2ca00565, /* RGB565 */
> > +			pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
> > +	writel(0x2ca00565, /* RGB565 */
> > +			pcdev->base_emma + PRP_CH1_PIXEL_FORMAT_CNTL);
> > 
> > To me it looks like the eMMA is configured for RGB565. What's the trick?
> > 
> 
> Yes, it seems to be an indication, but the emma currently does not touch
> any pixels, since the SRC_PIXEL_FORMAT and CH1_PIXEL_FORMAT are
> identical. It will be needed in the future when we are going to do some
> resizing operations with the emma or the SRC_PIXEL_FORMAT will differ to
> the output channels. But at that time, the simple condition check for
> RGB565 wouldn't be enough. So we should better remove them now.

Then at least, please fix the above comment:

> > +	 * We adjust incoming and outgoing pixelformat to rgb16
> > +	 * and adjust the bytesperline accordingly.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
