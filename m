Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50830 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab2BVLYp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 06:24:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 30/33] omap3isp: Add resizer data rate configuration to resizer_set_stream
Date: Wed, 22 Feb 2012 12:24:48 +0100
Message-ID: <1709623.OrBLBvPVIp@avalon>
In-Reply-To: <1329703032-31314-30-git-send-email-sakari.ailus@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-30-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Monday 20 February 2012 03:57:09 Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/omap3isp/ispresizer.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispresizer.c
> b/drivers/media/video/omap3isp/ispresizer.c index 6ce2349..81e1bc4 100644
> --- a/drivers/media/video/omap3isp/ispresizer.c
> +++ b/drivers/media/video/omap3isp/ispresizer.c
> @@ -1147,9 +1147,13 @@ static int resizer_set_stream(struct v4l2_subdev *sd,
> int enable) struct device *dev = to_device(res);
> 
>  	if (res->state == ISP_PIPELINE_STREAM_STOPPED) {
> +		struct isp_pipeline *pipe = to_isp_pipeline(&sd->entity);
> +
>  		if (enable == ISP_PIPELINE_STREAM_STOPPED)
>  			return 0;
> 
> +		omap3isp_resizer_max_rate(res, &pipe->max_rate);
> +
>  		omap3isp_subclk_enable(isp, OMAP3_ISP_SUBCLK_RESIZER);
>  		resizer_configure(res);
>  		resizer_print_status(res);

What about moving this to link validation ?

Could you please also remove it from isp_video_validate_pipeline() in this 
patch ? It would make review easier.

-- 
Regards,

Laurent Pinchart
