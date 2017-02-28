Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44154 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752443AbdB1Num (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 08:50:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/6] omap3isp: Disable streaming at driver unbind time
Date: Tue, 28 Feb 2017 15:51:14 +0200
Message-ID: <1825906.3DC6oLSMPM@avalon>
In-Reply-To: <1487604142-27610-5-git-send-email-sakari.ailus@linux.intel.com>
References: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com> <1487604142-27610-5-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 20 Feb 2017 17:22:20 Sakari Ailus wrote:
> Once the driver is unbound accessing the hardware is not allowed anymore.
> Due to this, disable streaming when the device driver is unbound. The
> states of the associated objects related to Media controller and videobuf2
> frameworks are updated as well, just like if the application disabled
> streaming explicitly.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

This looks mostly good to me, although I'm a bit concerned about race 
conditions related to buffer handling. I don't think this patch introduces any 
new one though, so

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

We'll have to go through buffer management at some point in the near future, 
including from a V4L2 API point of view I think.

> ---
>  drivers/media/platform/omap3isp/ispvideo.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index a3ca2a4..c04d357 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -1191,22 +1191,17 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type)
>  }
> 
>  static int
> -isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
> +__isp_video_streamoff(struct isp_video *video)
>  {
> -	struct isp_video_fh *vfh = to_isp_video_fh(fh);
> -	struct isp_video *video = video_drvdata(file);
>  	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
>  	enum isp_pipeline_state state;
>  	unsigned int streaming;
>  	unsigned long flags;
> 
> -	if (type != video->type)
> -		return -EINVAL;
> -
>  	mutex_lock(&video->stream_lock);
> 
>  	mutex_lock(&video->queue_lock);
> -	streaming = vb2_is_streaming(&vfh->queue);
> +	streaming = video->queue && vb2_is_streaming(video->queue);
>  	mutex_unlock(&video->queue_lock);
> 
>  	if (!streaming)
> @@ -1229,7 +1224,7 @@ isp_video_streamoff(struct file *file, void *fh, enum
> v4l2_buf_type type) omap3isp_video_cancel_stream(video);
> 
>  	mutex_lock(&video->queue_lock);
> -	vb2_streamoff(&vfh->queue, type);
> +	vb2_streamoff(video->queue, video->queue->type);
>  	mutex_unlock(&video->queue_lock);
>  	video->queue = NULL;
>  	video->error = false;
> @@ -1245,6 +1240,17 @@ isp_video_streamoff(struct file *file, void *fh, enum
> v4l2_buf_type type) }
> 
>  static int
> +isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
> +{
> +	struct isp_video *video = video_drvdata(file);
> +
> +	if (type != video->type)
> +		return -EINVAL;
> +
> +	return __isp_video_streamoff(video);
> +}
> +
> +static int
>  isp_video_enum_input(struct file *file, void *fh, struct v4l2_input *input)
> {
>  	if (input->index > 0)
> @@ -1494,5 +1500,6 @@ int omap3isp_video_register(struct isp_video *video,
> struct v4l2_device *vdev)
> 
>  void omap3isp_video_unregister(struct isp_video *video)
>  {
> +	__isp_video_streamoff(video);
>  	video_unregister_device(&video->video);
>  }

-- 
Regards,

Laurent Pinchart
