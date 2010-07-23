Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43602 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab0GWIf2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 04:35:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] mediabus: add MIPI CSI-2 pixel format codes
Date: Fri, 23 Jul 2010 10:35:28 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.1007231010370.22677@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1007231010370.22677@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007231035.31462.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Friday 23 July 2010 10:13:37 Guennadi Liakhovetski wrote:
> Add pixel format codes, defined in the MIPI CSI-2 specification.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> Even though it affects the same enum as my patch from yesterday, they are
> independent, Hans and Laurent CCed just to avoid possible conflicts, when
> further patching this file.
> 
>  include/media/v4l2-mediabus.h |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index a870965..b0dcace 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -41,6 +41,32 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
>  	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
>  	V4L2_MBUS_FMT_SGRBG8_1X8,
> +	/* MIPI CSI-2 codes */
> +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8_L,
> +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8,
> +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_10,
> +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8_CSPS,
> +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_10_CSPS,
> +	V4L2_MBUS_FMT_MIPI_CSI2_YUV422_8,
> +	V4L2_MBUS_FMT_MIPI_CSI2_YUV422_10,
> +	V4L2_MBUS_FMT_MIPI_CSI2_RGB888,
> +	V4L2_MBUS_FMT_MIPI_CSI2_RGB666,
> +	V4L2_MBUS_FMT_MIPI_CSI2_RGB565,
> +	V4L2_MBUS_FMT_MIPI_CSI2_RGB555,
> +	V4L2_MBUS_FMT_MIPI_CSI2_RGB444,
> +	V4L2_MBUS_FMT_MIPI_CSI2_RAW6,
> +	V4L2_MBUS_FMT_MIPI_CSI2_RAW7,
> +	V4L2_MBUS_FMT_MIPI_CSI2_RAW8,
> +	V4L2_MBUS_FMT_MIPI_CSI2_RAW10,
> +	V4L2_MBUS_FMT_MIPI_CSI2_RAW12,
> +	V4L2_MBUS_FMT_MIPI_CSI2_RAW14,
> +	V4L2_MBUS_FMT_MIPI_CSI2_GEN_NULL,
> +	V4L2_MBUS_FMT_MIPI_CSI2_GEN_BLANKING,
> +	V4L2_MBUS_FMT_MIPI_CSI2_GEN_EMBEDDED8,
> +	V4L2_MBUS_FMT_MIPI_CSI2_USER_1,
> +	V4L2_MBUS_FMT_MIPI_CSI2_USER_2,
> +	V4L2_MBUS_FMT_MIPI_CSI2_USER_3,
> +	V4L2_MBUS_FMT_MIPI_CSI2_USER_4,

I don't think I like this. Take the raw formats for instance, they're used for 
Bayer RGB. V4L2_MBUS_FMT_MIPI_CSI2_RAW8 could map to any Bayer format (GRBG, 
RGGB, ...). Why don't we just use "standard" pixel codes ?

>  };
> 
>  /**

-- 
Regards,

Laurent Pinchart
