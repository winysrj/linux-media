Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36392 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbbAAXEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Jan 2015 18:04:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 1/1] omap3isp: Correctly set QUERYCAP capabilities
Date: Fri, 02 Jan 2015 01:04:16 +0200
Message-ID: <17321888.FUCG9ahuk4@avalon>
In-Reply-To: <1420146834-13458-1-git-send-email-sakari.ailus@iki.fi>
References: <1420146834-13458-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Thursday 01 January 2015 23:13:54 Sakari Ailus wrote:
> device_caps in struct v4l2_capability were inadequately set in
> VIDIOC_QUERYCAP. Fix this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/platform/omap3isp/ispvideo.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index cdfec27..d644164 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -602,10 +602,13 @@ isp_video_querycap(struct file *file, void *fh, struct
> v4l2_capability *cap) strlcpy(cap->card, video->video.name,
> sizeof(cap->card));
>  	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));
> 
> +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
> +		| V4L2_CAP_STREAMING | V4L2_CAP_DEVICE_CAPS;

I would align the | under the =. Apart from that,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +
>  	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>  	else
> -		cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> +		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> 
>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart

