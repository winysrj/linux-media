Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56328 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934467Ab1JEQLk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 12:11:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] V4L: omap3isp: remove redundant operation
Date: Wed, 5 Oct 2011 18:11:34 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1109291255590.31659@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109291255590.31659@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110051811.36052.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch.

On Thursday 29 September 2011 12:57:00 Guennadi Liakhovetski wrote:
> Trivial arithmetics clean up.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've applied it to my tree.

> ---
>  drivers/media/video/omap3isp/ispccdc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispccdc.c
> b/drivers/media/video/omap3isp/ispccdc.c index 40b141c..65ae267 100644
> --- a/drivers/media/video/omap3isp/ispccdc.c
> +++ b/drivers/media/video/omap3isp/ispccdc.c
> @@ -1834,7 +1834,7 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct
> v4l2_subdev_fh *fh, * callers to request an output size bigger than the
> input size * up to the nearest multiple of 16.
>  		 */
> -		fmt->width = clamp_t(u32, width, 32, (fmt->width + 15) & ~15);
> +		fmt->width = clamp_t(u32, width, 32, fmt->width + 15);
>  		fmt->width &= ~15;
>  		fmt->height = clamp_t(u32, height, 32, fmt->height);
>  		break;

-- 
Regards,

Laurent Pinchart
