Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38826 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753938AbcL3N2Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Dec 2016 08:28:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3 1/4] uvcvideo: (cosmetic) add and use an inline function
Date: Fri, 30 Dec 2016 15:28:37 +0200
Message-ID: <1556654.51pUyBztm0@avalon>
In-Reply-To: <1481541412-1186-2-git-send-email-guennadi.liakhovetski@intel.com>
References: <1481541412-1186-1-git-send-email-guennadi.liakhovetski@intel.com> <1481541412-1186-2-git-send-email-guennadi.liakhovetski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Monday 12 Dec 2016 12:16:49 Guennadi Liakhovetski wrote:
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Add an inline function to obtain a struct uvc_buffer pointer from a
> struct vb2_v4l2_buffer one.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> ---
>  drivers/media/usb/uvc/uvc_queue.c | 6 +++---
>  drivers/media/usb/uvc/uvcvideo.h  | 4 ++++
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_queue.c
> b/drivers/media/usb/uvc/uvc_queue.c index 77edd20..c119551 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -89,7 +89,7 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
>  {
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
> -	struct uvc_buffer *buf = container_of(vbuf, struct uvc_buffer, buf);
> +	struct uvc_buffer *buf = uvc_vbuf_to_buffer(vbuf);
> 
>  	if (vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
>  	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
> @@ -116,7 +116,7 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
>  {
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
> -	struct uvc_buffer *buf = container_of(vbuf, struct uvc_buffer, buf);
> +	struct uvc_buffer *buf = uvc_vbuf_to_buffer(vbuf);
>  	unsigned long flags;
> 
>  	spin_lock_irqsave(&queue->irqlock, flags);
> @@ -138,7 +138,7 @@ static void uvc_buffer_finish(struct vb2_buffer *vb)
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
>  	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
> -	struct uvc_buffer *buf = container_of(vbuf, struct uvc_buffer, buf);
> +	struct uvc_buffer *buf = uvc_vbuf_to_buffer(vbuf);
> 
>  	if (vb->state == VB2_BUF_STATE_DONE)
>  		uvc_video_clock_update(stream, vbuf, buf);
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 3d6cc62..a1e6a19 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -679,6 +679,10 @@ static inline int uvc_queue_streaming(struct
> uvc_video_queue *queue) {
>  	return vb2_is_streaming(&queue->queue);
>  }
> +static inline struct uvc_buffer *uvc_vbuf_to_buffer(struct vb2_v4l2_buffer
> *vbuf)

If you rename vbuf to buf you'll fit within the 80 columns limit.

I also propose moving the function to uvc_queue.c as it's only used there, 
like the uvc_queue_to_stream() function.

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

If you're fine with those changes there's no need to resubmit, I'll fix when 
applying (for v4.11).

> +{
> +	return container_of(vbuf, struct uvc_buffer, buf);
> +}
> 
>  /* V4L2 interface */
>  extern const struct v4l2_ioctl_ops uvc_ioctl_ops;

-- 
Regards,

Laurent Pinchart

