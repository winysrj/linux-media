Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55916 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab2CGKuA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 05:50:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 25/35] omap3isp: Collect entities that are part of the pipeline
Date: Wed, 07 Mar 2012 11:50:19 +0100
Message-ID: <6281574.FW0nkSrXHX@avalon>
In-Reply-To: <1331051596-8261-25-git-send-email-sakari.ailus@iki.fi>
References: <20120306163239.GN1075@valkosipuli.localdomain> <1331051596-8261-25-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Another comment.

On Tuesday 06 March 2012 18:33:06 Sakari Ailus wrote:
> Collect entities which are part of the pipeline into a single bit mask.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

[snip]

> diff --git a/drivers/media/video/omap3isp/ispvideo.h
> b/drivers/media/video/omap3isp/ispvideo.h index d91bdb91..0423c9d 100644
> --- a/drivers/media/video/omap3isp/ispvideo.h
> +++ b/drivers/media/video/omap3isp/ispvideo.h
> @@ -96,6 +96,7 @@ struct isp_pipeline {
>  	enum isp_pipeline_stream_state stream_state;
>  	struct isp_video *input;
>  	struct isp_video *output;
> +	u32 entities;
>  	unsigned long l3_ick;
>  	unsigned int max_rate;
>  	atomic_t frame_number;

Could you please update the structure documentation ?

@entities: Bitmask of entities in the pipeline (indexed by entity ID)

-- 
Regards,

Laurent Pinchart

