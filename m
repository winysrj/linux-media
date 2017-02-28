Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44144 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751768AbdB1Ns4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 08:48:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/6] omap3isp: Call video_unregister_device() unconditionally
Date: Tue, 28 Feb 2017 15:42:08 +0200
Message-ID: <1795290.FHDqLA2GvD@avalon>
In-Reply-To: <1487604142-27610-3-git-send-email-sakari.ailus@linux.intel.com>
References: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com> <1487604142-27610-3-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 20 Feb 2017 17:22:18 Sakari Ailus wrote:
> video_unregister_device() can be called on a never or an already
> unregistered device. Drop the redundant check.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/omap3isp/ispvideo.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index 218e6d7..9e9b18c 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -1495,6 +1495,5 @@ int omap3isp_video_register(struct isp_video *video,
> struct v4l2_device *vdev)
> 
>  void omap3isp_video_unregister(struct isp_video *video)
>  {
> -	if (video_is_registered(&video->video))
> -		video_unregister_device(&video->video);
> +	video_unregister_device(&video->video);
>  }

-- 
Regards,

Laurent Pinchart
