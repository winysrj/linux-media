Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51428 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab2CGLA3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 06:00:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 30/35] omap3isp: Move CCDC link validation to ccdc_link_validate()
Date: Wed, 07 Mar 2012 12:00:48 +0100
Message-ID: <1437113.Q2NA52b0Is@avalon>
In-Reply-To: <1331051596-8261-30-git-send-email-sakari.ailus@iki.fi>
References: <20120306163239.GN1075@valkosipuli.localdomain> <1331051596-8261-30-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Tuesday 06 March 2012 18:33:11 Sakari Ailus wrote:
> Perform CCDC link validation in ccdc_link_validate() instead of
> isp_video_validate_pipeline(). Also perform maximum data rate check in
> isp_video_check_external_subdevs().
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

[snip]

> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c index 6d4ad87..51075b3 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c

[snip]

> @@ -950,6 +867,7 @@ static int isp_video_check_external_subdevs(struct
> isp_pipeline *pipe) struct v4l2_subdev_format fmt;
>  	struct v4l2_ext_controls ctrls;
>  	struct v4l2_ext_control ctrl;
> +	unsigned int rate = UINT_MAX;

You can move this variable inside the if statement below.

>  	int i;
>  	int ret = 0;
> 
> @@ -1002,6 +920,16 @@ static int isp_video_check_external_subdevs(struct
> isp_pipeline *pipe)
> 
>  	pipe->external_rate = ctrl.value64;
> 
> +	if (pipe->entities & (1 << isp->isp_ccdc.subdev.entity.id)) {
> +		/*
> +		 * Check that maximum allowed CCDC pixel rate isn't
> +		 * exceeded by the pixel rate.

What's wrong with 80 columns, really ? :-)

> +		 */
> +		omap3isp_ccdc_max_rate(&isp->isp_ccdc, &rate);
> +		if (pipe->external_rate > rate)
> +			return -ENOSPC;
> +	}
> +
>  	return 0;
>  }

Pending those two changes,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

