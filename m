Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:39738 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab2F0LIO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 07:08:14 -0400
Message-ID: <4FEAE987.6060104@iki.fi>
Date: Wed, 27 Jun 2012 14:07:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Abhishek Reddy Kondaveeti <areddykondaveeti@aptina.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: Re: [PATCH 1/6] omap3isp: video: Split format info bpp field into
 width and bpp
References: <1340718339-29915-1-git-send-email-laurent.pinchart@ideasonboard.com> <1340718339-29915-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1340718339-29915-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

Laurent Pinchart wrote:
> The bpp field currently stores the sample width and is aligned to the
> next multiple of 8 bits when computing data size in memory. This won't
> work anymore for YUYV8_2X8 formats. Split the bpp field into a sample
> width and a bits per pixel value.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

...

> diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
> index 5acc909..f8092cc 100644
> --- a/drivers/media/video/omap3isp/ispvideo.h
> +++ b/drivers/media/video/omap3isp/ispvideo.h
> @@ -51,7 +51,8 @@ struct v4l2_pix_format;
>   * @flavor: V4L2 media bus format code for the same pixel layout but
>   *	shifted to be 8 bits per pixel. =0 if format is not shiftable.
>   * @pixelformat: V4L2 pixel format FCC identifier
> - * @bpp: Bits per pixel
> + * @width: Data bus width
> + * @bpp: Bits per pixel (when stored in memory)

Would it make sense to use bytes rather than bits?

Also width isn't really the width of the data bus on serial busses, is
it? How about busses that transfer pixels 8 bits at the time?

You can also stop using ALIGN() in isp_video_mbus_to_pix() (in
ispvideo.c) as the ISP will always write complete bytes.

I might even switch the meaning between width and bpp but this is up to you.

>   */
>  struct isp_format_info {
>  	enum v4l2_mbus_pixelcode code;
> @@ -59,6 +60,7 @@ struct isp_format_info {
>  	enum v4l2_mbus_pixelcode uncompressed;
>  	enum v4l2_mbus_pixelcode flavor;
>  	u32 pixelformat;
> +	unsigned int width;
>  	unsigned int bpp;
>  };
>  
> @@ -106,7 +108,7 @@ struct isp_pipeline {
>  	struct v4l2_fract max_timeperframe;
>  	struct v4l2_subdev *external;
>  	unsigned int external_rate;
> -	unsigned int external_bpp;
> +	unsigned int external_width;
>  };
>  
>  #define to_isp_pipeline(__e) \
> 

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi


