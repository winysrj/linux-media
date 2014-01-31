Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47127 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbaAaAuz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jan 2014 19:50:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH] [media] uvcvideo: Enable VIDIOC_CREATE_BUFS
Date: Fri, 31 Jan 2014 01:51:47 +0100
Message-ID: <1474634.xnVfC2yuQa@avalon>
In-Reply-To: <1391012032-19600-1-git-send-email-p.zabel@pengutronix.de>
References: <1391012032-19600-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Wednesday 29 January 2014 17:13:52 Philipp Zabel wrote:
> This patch enables the ioctl to create additional buffers
> on the videobuf2 capture queue.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

This looks good to me. I've applied the patch to my tree and will send a pull 
request for v3.15.

> ---
>  drivers/media/usb/uvc/uvc_queue.c | 11 +++++++++++
>  drivers/media/usb/uvc/uvc_v4l2.c  | 10 ++++++++++
>  drivers/media/usb/uvc/uvcvideo.h  |  2 ++
>  3 files changed, 23 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_queue.c
> b/drivers/media/usb/uvc/uvc_queue.c index cd962be..7efb157 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -196,6 +196,17 @@ int uvc_query_buffer(struct uvc_video_queue *queue,
> struct v4l2_buffer *buf) return ret;
>  }
> 
> +int uvc_create_buffers(struct uvc_video_queue *queue, struct
> v4l2_create_buffers *cb) +{
> +	int ret;
> +
> +	mutex_lock(&queue->mutex);
> +	ret = vb2_create_bufs(&queue->queue, cb);
> +	mutex_unlock(&queue->mutex);
> +
> +	return ret;
> +}
> +
>  int uvc_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer
> *buf) {
>  	int ret;
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index 3afff92..fa58131 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -1000,6 +1000,16 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) return uvc_query_buffer(&stream->queue, buf);
>  	}
> 
> +	case VIDIOC_CREATE_BUFS:
> +	{
> +		struct v4l2_create_buffers *cb = arg;
> +
> +		if (!uvc_has_privileges(handle))
> +			return -EBUSY;
> +
> +		return uvc_create_buffers(&stream->queue, cb);
> +	}
> +
>  	case VIDIOC_QBUF:
>  		if (!uvc_has_privileges(handle))
>  			return -EBUSY;
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 9e35982..a28da0f 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -616,6 +616,8 @@ extern int uvc_alloc_buffers(struct uvc_video_queue
> *queue, extern void uvc_free_buffers(struct uvc_video_queue *queue);
>  extern int uvc_query_buffer(struct uvc_video_queue *queue,
>  		struct v4l2_buffer *v4l2_buf);
> +extern int uvc_create_buffers(struct uvc_video_queue *queue,
> +		struct v4l2_create_buffers *v4l2_cb);
>  extern int uvc_queue_buffer(struct uvc_video_queue *queue,
>  		struct v4l2_buffer *v4l2_buf);
>  extern int uvc_dequeue_buffer(struct uvc_video_queue *queue,

-- 
Regards,

Laurent Pinchart

