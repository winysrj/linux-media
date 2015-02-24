Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49750 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbbBXAWY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 19:22:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] media: omap3isp: ispvideo: use vb2_fop_mmap/poll
Date: Tue, 24 Feb 2015 02:23:26 +0200
Message-ID: <1796599.ux1YsIdsDy@avalon>
In-Reply-To: <1424722773-20131-4-git-send-email-prabhakar.csengg@gmail.com>
References: <1424722773-20131-1-git-send-email-prabhakar.csengg@gmail.com> <1424722773-20131-4-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thank you for the patch.

On Monday 23 February 2015 20:19:33 Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> No need to reinvent the wheel. Just use the already existing
> functions provided v4l-core.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/omap3isp/ispvideo.c | 30  ++++----------------------
>  1 file changed, 4 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index b648176..5dd5ffc 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -1277,37 +1277,13 @@ static int isp_video_release(struct file *file)
>  	return ret;
>  }
> 
> -static unsigned int isp_video_poll(struct file *file, poll_table *wait)
> -{
> -	struct isp_video *video = video_drvdata(file);
> -	int ret;
> -
> -	mutex_lock(&video->queue_lock);
> -	ret = vb2_poll(&video->queue, file, wait);
> -	mutex_unlock(&video->queue_lock);
> -
> -	return ret;
> -}

This depends on patch 2/3, which can't be accepted as-is for now.

> -static int isp_video_mmap(struct file *file, struct vm_area_struct *vma)
> -{
> -	struct isp_video *video = video_drvdata(file);
> -	int ret;
> -
> -	mutex_lock(&video->queue_lock);
> -	ret = vb2_mmap(&video->queue, vma);
> -	mutex_unlock(&video->queue_lock);
> -
> -	return ret;
> -}

This should be good but has the side effect of removing locking in 
isp_video_mmap(). Now, I think that's the right thing to do, but it should be 
done in a separate patch first with a proper explanation. I can do so, or you 
can submit an additional patch.

>  static struct v4l2_file_operations isp_video_fops = {
>  	.owner = THIS_MODULE,
>  	.unlocked_ioctl = video_ioctl2,
>  	.open = isp_video_open,
>  	.release = isp_video_release,
> -	.poll = isp_video_poll,
> -	.mmap = isp_video_mmap,
> +	.poll = vb2_fop_poll,
> +	.mmap = vb2_fop_mmap,
>  };
> 
>  /* ------------------------------------------------------------------------
>  @@ -1389,6 +1365,8 @@ int omap3isp_video_register(struct isp_video
> *video, struct v4l2_device *vdev)
> 
>  	video->video.v4l2_dev = vdev;
> 
> +	/* queue isnt initalized */
> +	video->video.queue = &video->queue;
>  	ret = video_register_device(&video->video, VFL_TYPE_GRABBER, -1);
>  	if (ret < 0)
>  		dev_err(video->isp->dev,

-- 
Regards,

Laurent Pinchart

