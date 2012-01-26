Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41370 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab2AZSSc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 13:18:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 5/8] soc-camera: Add soc_mbus_image_size
Date: Thu, 26 Jan 2012 19:18:43 +0100
Cc: linux-media@vger.kernel.org
References: <1327504351-24413-1-git-send-email-laurent.pinchart@ideasonboard.com> <1327504351-24413-6-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1201261652440.10057@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1201261652440.10057@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201261918.43755.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thursday 26 January 2012 16:59:23 Guennadi Liakhovetski wrote:
> On Wed, 25 Jan 2012, Laurent Pinchart wrote:
> > The function returns the minimum size of an image for a given number of
> > bytes per line (as per the V4L2 specification), width and format.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/soc_mediabus.c |   18 ++++++++++++++++++
> >  include/media/soc_mediabus.h       |    2 ++
> >  2 files changed, 20 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/soc_mediabus.c
> > b/drivers/media/video/soc_mediabus.c index a707314..3f47774 100644
> > --- a/drivers/media/video/soc_mediabus.c
> > +++ b/drivers/media/video/soc_mediabus.c
> > @@ -397,6 +397,24 @@ s32 soc_mbus_bytes_per_line(u32 width, const struct
> > soc_mbus_pixelfmt *mf)
> > 
> >  }
> >  EXPORT_SYMBOL(soc_mbus_bytes_per_line);
> > 
> > +s32 soc_mbus_image_size(u32 bytes_per_line, u32 height,
> > +			const struct soc_mbus_pixelfmt *mf)
> 
> What do you think about making mf the first parameter? :-)

I copied the parameters order from soc_mbus_bytes_per_line(). I like having 
the format first, so I'll change that for soc_mbus_image_size().

> > +{
> > +	if (mf->layout == SOC_MBUS_LAYOUT_PACKED)
> > +		return bytes_per_line * height;
> > +
> > +	switch (mf->packing) {
> > +	case SOC_MBUS_PACKING_2X8_PADHI:
> > +	case SOC_MBUS_PACKING_2X8_PADLO:
> > +		return bytes_per_line * height * 2;
> > +	case SOC_MBUS_PACKING_1_5X8:
> > +		return bytes_per_line * height * 3 / 2;
> 
> Hm, confused. Why have you decided to calculate the size based on packing
> and not on layout?

Because planar YUV 4:2:0, 4:2:2 and 4:4:4 formats would all use 
SOC_MBUS_LAYOUT_Y_U_V. I could create SOC_MBUS_LAYOUT_2Y_U_V and 
SOC_MBUS_LAYOUT_4Y_U_V instead. As existing planar formats all have a 
bits_per_sample value of 8, mf->packing was already used by 
soc_mbus_bytes_per_line() (before my patches) to compute the total line size 
in bytes, so I thought it made sense to reuse it in soc_mbus_image_size().

-- 
Regards,

Laurent Pinchart
