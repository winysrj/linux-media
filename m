Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44145 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbdB1Ns4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 08:48:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] omap3isp: Remove misleading comment
Date: Tue, 28 Feb 2017 15:42:19 +0200
Message-ID: <1506772.h8Xp7uijkX@avalon>
In-Reply-To: <1487604142-27610-4-git-send-email-sakari.ailus@linux.intel.com>
References: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com> <1487604142-27610-4-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 20 Feb 2017 17:22:19 Sakari Ailus wrote:
> The intent of the check the comment is related to is to ensure we are
> streaming --- still. Not that streaming wouldn't be enabled yet. Remove
> it.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/omap3isp/ispvideo.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index 9e9b18c..a3ca2a4 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -1205,7 +1205,6 @@ isp_video_streamoff(struct file *file, void *fh, enum
> v4l2_buf_type type)
> 
>  	mutex_lock(&video->stream_lock);
> 
> -	/* Make sure we're not streaming yet. */
>  	mutex_lock(&video->queue_lock);
>  	streaming = vb2_is_streaming(&vfh->queue);
>  	mutex_unlock(&video->queue_lock);

-- 
Regards,

Laurent Pinchart
