Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34141 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab2AEKL4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 05:11:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/1] omap3isp: Check media bus code on links
Date: Thu, 5 Jan 2012 11:12:14 +0100
Cc: linux-media@vger.kernel.org
References: <1325754619-2520-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1325754619-2520-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201051112.14459.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 05 January 2012 10:10:19 Sakari Ailus wrote:
> Check media bus code on links. The user could configure different formats
> at different ends of the link, say, 8 bits-per-pixel in the source and 10
> bits-per-pixel in the sink. This leads to interesting and typically
> undesired results image-wise.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/omap3isp/ispvideo.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c index 615dae5..dbdd5b4 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -352,7 +352,8 @@ static int isp_video_validate_pipeline(struct
> isp_pipeline *pipe)
> 
>  		/* Check if the two ends match */
>  		if (fmt_source.format.width != fmt_sink.format.width ||
> -		    fmt_source.format.height != fmt_sink.format.height)
> +		    fmt_source.format.height != fmt_sink.format.height ||
> +		    fmt_source.format.code != fmt_sink.format.code)

If you scroll down a bit, the check is already present in the second branch of 
the if statement. The reason why the driver doesn't enforce the same format 
unconditionally is that the lane shifter on the CCDC sink link can shift data, 
so a special check is needed there.

>  			return -EPIPE;
> 
>  		if (shifter_link) {

-- 
Regards,

Laurent Pinchart
