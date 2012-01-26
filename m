Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab2AZQBR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 11:01:17 -0500
Date: Thu, 26 Jan 2012 17:01:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/8] soc-camera: Add plane layout information to struct
 soc_mbus_pixelfmt
In-Reply-To: <1327504351-24413-4-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1201261659480.10057@axis700.grange>
References: <1327504351-24413-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1327504351-24413-4-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One more question:

On Wed, 25 Jan 2012, Laurent Pinchart wrote:

> To compute the number of bytes per line according to the V4L2
> specification, we need information about planes layout for planar
> formats. The new enum soc_mbus_layout convey that information.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/atmel-isi.c            |    1 +
>  drivers/media/video/mx3_camera.c           |    2 +
>  drivers/media/video/omap1_camera.c         |    8 ++++++
>  drivers/media/video/pxa_camera.c           |    1 +
>  drivers/media/video/sh_mobile_ceu_camera.c |    4 +++
>  drivers/media/video/soc_mediabus.c         |   33 ++++++++++++++++++++++++++++
>  include/media/soc_mediabus.h               |   19 ++++++++++++++++
>  7 files changed, 68 insertions(+), 0 deletions(-)

[snip]

> diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
> index 73f1e7e..18b0864 100644
> --- a/include/media/soc_mediabus.h
> +++ b/include/media/soc_mediabus.h
> @@ -47,6 +47,24 @@ enum soc_mbus_order {
>  };
>  
>  /**
> + * enum soc_mbus_layout - planes layout in memory
> + * @SOC_MBUS_LAYOUT_PACKED:		color components packed
> + * @SOC_MBUS_LAYOUT_PLANAR_Y_U_V:	YUV components stored in 3 planes
> + * @SOC_MBUS_LAYOUT_PLANAR_2Y_C:	YUV components stored in a luma and a
> + *					chroma plane (C plane is half the size
> + *					of Y plane)
> + * @SOC_MBUS_LAYOUT_PLANAR_Y_C:		YUV components stored in a luma and a
> + *					chroma plane (C plane is the same size
> + *					as Y plane)
> + */
> +enum soc_mbus_layout {
> +	SOC_MBUS_LAYOUT_PACKED = 0,
> +	SOC_MBUS_LAYOUT_PLANAR_Y_U_V,

Shouldn't we call this SOC_MBUS_LAYOUT_PLANAR_2Y_U_V?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
