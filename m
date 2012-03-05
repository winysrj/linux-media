Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46496 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab2CEL2C (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 06:28:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com
Subject: Re: [PATCH v4 26/34] omap3isp: Add information on external subdev to struct isp_pipeline
Date: Mon, 05 Mar 2012 12:28:21 +0100
Message-ID: <4023505.SC8tmEe4Q6@avalon>
In-Reply-To: <1330709442-16654-26-git-send-email-sakari.ailus@iki.fi>
References: <20120302173219.GA15695@valkosipuli.localdomain> <1330709442-16654-26-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 02 March 2012 19:30:34 Sakari Ailus wrote:
> Add pointer to external subdev, pixel rate of the external subdev and bpp of
> the format to struct isp_pipeline.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/omap3isp/ispvideo.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispvideo.h
> b/drivers/media/video/omap3isp/ispvideo.h index d91bdb91..b198723 100644
> --- a/drivers/media/video/omap3isp/ispvideo.h
> +++ b/drivers/media/video/omap3isp/ispvideo.h
> @@ -102,6 +102,9 @@ struct isp_pipeline {
>  	bool do_propagation; /* of frame number */
>  	bool error;
>  	struct v4l2_fract max_timeperframe;
> +	struct v4l2_subdev *external;
> +	unsigned int external_rate;
> +	int external_bpp;

unsigned int ? :-)

With that change,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  };
> 
>  #define to_isp_pipeline(__e) \

-- 
Regards,

Laurent Pinchart

