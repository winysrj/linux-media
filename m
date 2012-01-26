Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:65422 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab2AZP70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 10:59:26 -0500
Date: Thu, 26 Jan 2012 16:59:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 5/8] soc-camera: Add soc_mbus_image_size
In-Reply-To: <1327504351-24413-6-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1201261652440.10057@axis700.grange>
References: <1327504351-24413-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1327504351-24413-6-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 25 Jan 2012, Laurent Pinchart wrote:

> The function returns the minimum size of an image for a given number of
> bytes per line (as per the V4L2 specification), width and format.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/soc_mediabus.c |   18 ++++++++++++++++++
>  include/media/soc_mediabus.h       |    2 ++
>  2 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
> index a707314..3f47774 100644
> --- a/drivers/media/video/soc_mediabus.c
> +++ b/drivers/media/video/soc_mediabus.c
> @@ -397,6 +397,24 @@ s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
>  }
>  EXPORT_SYMBOL(soc_mbus_bytes_per_line);
>  
> +s32 soc_mbus_image_size(u32 bytes_per_line, u32 height,
> +			const struct soc_mbus_pixelfmt *mf)

What do you think about making mf the first parameter? :-)

> +{
> +	if (mf->layout == SOC_MBUS_LAYOUT_PACKED)
> +		return bytes_per_line * height;
> +
> +	switch (mf->packing) {
> +	case SOC_MBUS_PACKING_2X8_PADHI:
> +	case SOC_MBUS_PACKING_2X8_PADLO:
> +		return bytes_per_line * height * 2;
> +	case SOC_MBUS_PACKING_1_5X8:
> +		return bytes_per_line * height * 3 / 2;

Hm, confused. Why have you decided to calculate the size based on packing 
and not on layout?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
