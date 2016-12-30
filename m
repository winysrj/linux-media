Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51972 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752475AbcL3KnL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Dec 2016 05:43:11 -0500
Date: Fri, 30 Dec 2016 11:43:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v3 4/4] uvcvideo: add a metadata device node
In-Reply-To: <1481541412-1186-5-git-send-email-guennadi.liakhovetski@intel.com>
Message-ID: <Pine.LNX.4.64.1612300938110.9905@axis700.grange>
References: <1481541412-1186-1-git-send-email-guennadi.liakhovetski@intel.com>
 <1481541412-1186-5-git-send-email-guennadi.liakhovetski@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I'd like to discuss extending this patch a bit, preferably as an 
incremental patch.

First let me confirm my current understanding of the way the UVC driver 
creates its media device topology. Do I understand it correctly, that the 
driver allocates UVC entities (not media controller entities) for all UVC 
units and terminals, but then uses subdevices for all such UVC entities, 
except terminals, i.e. only for UVC units? struct uvc_entity has an 
embedded struct v4l2_subdev object, but it's unused for UVC terminals. 
Instead terminals are associated to video devices, which are then linked 
into the MC topology? Is this my understanding correct?

I have a problem with the current version of this patch, that there is no 
way to associate video device nodes with respepctive metadata nodes. Would 
it be acceptable to use an MC link for this association? Is it allowed for 
video device MC entities to have source pads additionally to their 
(usually single) sink pad(s) (in case of input video devices)? If that 
would be acceptable, I could create an additional patch to add a source 
pad to output terminal video nodes to link it to metadata nodes.

Thanks
Guennadi

On Mon, 12 Dec 2016, Guennadi Liakhovetski wrote:

> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Some UVC video cameras contain metadata in their payload headers. This
> patch extracts that data, skipping the standard part of the header, on
> both bulk and isochronous endpoints and makes it available to the user
> space on a separate video node, using the V4L2_CAP_META_CAPTURE
> capability and the V4L2_BUF_TYPE_META_CAPTURE buffer queue type. Even
> though different cameras will have different metadata formats, we use
> the same V4L2_META_FMT_UVC pixel format for all of them. Users have to
> parse data, based on the specific camera model information.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> ---
> 
> v3: all comments to v2 have been addressed - thanks! Most important 
> ones:
> 
> * metadata nodes are now only created for cameras, for which a 
>   UVC_QUIRK_METADATA_NODE flag is specified
> * no metadata nodes are created for video interfaces with isochronous 
>   endpoints. For those to be meaningfully supported a UVC standard 
>   extension is required.
> * the uvc_queue.c vb2_queue implementation is extended and used 
>   instead of a separate implementation
> 
>  drivers/media/usb/uvc/Makefile       |   2 +-
>  drivers/media/usb/uvc/uvc_driver.c   |   4 +
>  drivers/media/usb/uvc/uvc_isight.c   |   2 +-
>  drivers/media/usb/uvc/uvc_metadata.c | 159 +++++++++++++++++++++++++++++++++++
>  drivers/media/usb/uvc/uvc_queue.c    |  68 ++++++++++-----
>  drivers/media/usb/uvc/uvc_video.c    |  41 ++++++++-
>  drivers/media/usb/uvc/uvcvideo.h     |  19 ++++-
>  drivers/media/v4l2-core/v4l2-ioctl.c |   1 +
>  include/uapi/linux/uvcvideo.h        |   7 ++
>  include/uapi/linux/videodev2.h       |   3 +
>  10 files changed, 278 insertions(+), 28 deletions(-)
>  create mode 100644 drivers/media/usb/uvc/uvc_metadata.c
> 
> diff --git a/drivers/media/usb/uvc/Makefile b/drivers/media/usb/uvc/Makefile
> index c26d12f..06c7cd3 100644
> --- a/drivers/media/usb/uvc/Makefile
> +++ b/drivers/media/usb/uvc/Makefile
> @@ -1,5 +1,5 @@
>  uvcvideo-objs  := uvc_driver.o uvc_queue.o uvc_v4l2.o uvc_video.o uvc_ctrl.o \
> -		  uvc_status.o uvc_isight.o uvc_debugfs.o
> +		  uvc_status.o uvc_isight.o uvc_debugfs.o uvc_metadata.o
>  ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
>  uvcvideo-objs  += uvc_entity.o
>  endif
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index 04bf350..b2e9eef 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1865,6 +1865,7 @@ static void uvc_unregister_video(struct uvc_device *dev)
>  			continue;
>  
>  		video_unregister_device(&stream->vdev);
> +		video_unregister_device(&stream->meta.vdev);
>  
>  		uvc_debugfs_cleanup_stream(stream);
>  	}
> @@ -1926,6 +1927,9 @@ static int uvc_register_video(struct uvc_device *dev,
>  		return ret;
>  	}
>  
> +	/* Register a metadata node. */
> +	uvc_meta_register(stream);
> +
>  	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		stream->chain->caps |= V4L2_CAP_VIDEO_CAPTURE;
>  	else
> diff --git a/drivers/media/usb/uvc/uvc_isight.c b/drivers/media/usb/uvc/uvc_isight.c
> index 8510e725..fb940cf 100644
> --- a/drivers/media/usb/uvc/uvc_isight.c
> +++ b/drivers/media/usb/uvc/uvc_isight.c
> @@ -100,7 +100,7 @@ static int isight_decode(struct uvc_video_queue *queue, struct uvc_buffer *buf,
>  }
>  
>  void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
> -		struct uvc_buffer *buf)
> +			struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
>  {
>  	int ret, i;
>  
> diff --git a/drivers/media/usb/uvc/uvc_metadata.c b/drivers/media/usb/uvc/uvc_metadata.c
> new file mode 100644
> index 0000000..711ffde
> --- /dev/null
> +++ b/drivers/media/usb/uvc/uvc_metadata.c
> @@ -0,0 +1,159 @@
> +/*
> + *      uvc_metadata.c  --  USB Video Class driver - Metadata handling
> + *
> + *      Copyright (C) 2016
> + *          Guennadi Liakhovetski (guennadi.liakhovetski@intel.com)
> + *
> + *      This program is free software; you can redistribute it and/or modify
> + *      it under the terms of the GNU General Public License as published by
> + *      the Free Software Foundation; either version 2 of the License, or
> + *      (at your option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/usb.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-v4l2.h>
> +#include <media/videobuf2-vmalloc.h>
> +
> +#include "uvcvideo.h"
> +
> +/* -----------------------------------------------------------------------------
> + * videobuf2 Queue Operations
> + */
> +
> +static struct vb2_ops uvc_meta_queue_ops = {
> +	.queue_setup = uvc_queue_setup,
> +	.buf_prepare = uvc_buffer_prepare,
> +	.buf_queue = uvc_buffer_queue,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +	.stop_streaming = uvc_stop_streaming,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 ioctls
> + */
> +
> +static int meta_v4l2_querycap(struct file *file, void *fh,
> +			      struct v4l2_capability *cap)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
> +
> +	strlcpy(cap->driver, "uvcvideo", sizeof(cap->driver));
> +	strlcpy(cap->card, vfh->vdev->name, sizeof(cap->card));
> +	usb_make_path(stream->dev->udev, cap->bus_info, sizeof(cap->bus_info));
> +
> +	return 0;
> +}
> +
> +static int meta_v4l2_get_format(struct file *file, void *fh,
> +				struct v4l2_format *format)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct v4l2_meta_format *fmt = &format->fmt.meta;
> +
> +	if (format->type != vfh->vdev->queue->type)
> +		return -EINVAL;
> +
> +	memset(fmt, 0, sizeof(*fmt));
> +
> +	fmt->dataformat = V4L2_META_FMT_UVC;
> +	fmt->buffersize = UVC_PAYLOAD_HEADER_MAX_SIZE;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops uvc_meta_ioctl_ops = {
> +	.vidioc_querycap		= meta_v4l2_querycap,
> +	.vidioc_g_fmt_meta_cap		= meta_v4l2_get_format,
> +	.vidioc_s_fmt_meta_cap		= meta_v4l2_get_format,
> +	.vidioc_try_fmt_meta_cap	= meta_v4l2_get_format,
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 File Operations
> + */
> +
> +static struct v4l2_file_operations uvc_meta_fops = {
> +	.owner = THIS_MODULE,
> +	.unlocked_ioctl = video_ioctl2,
> +	.open = v4l2_fh_open,
> +	.release = vb2_fop_release,
> +	.poll = vb2_fop_poll,
> +	.mmap = vb2_fop_mmap,
> +};
> +
> +int uvc_meta_register(struct uvc_streaming *stream)
> +{
> +	struct uvc_device *dev = stream->dev;
> +	struct uvc_meta_device *meta = &stream->meta;
> +	struct video_device *vdev = &meta->vdev;
> +	struct uvc_video_queue *quvc = &meta->queue;
> +	struct vb2_queue *queue = &quvc->queue;
> +	int ret;
> +
> +	mutex_init(&quvc->mutex);
> +	spin_lock_init(&quvc->irqlock);
> +	INIT_LIST_HEAD(&quvc->irqqueue);
> +
> +	/*
> +	 * We register metadata device nodes only if the METADATA_NODE quirk is
> +	 * set and only on interfaces with bulk endpoints. To meaningfully
> +	 * support interfaces with isochronous endpoints, we need to collect
> +	 * headers from all payloads, comprising a single frame. For that we
> +	 * need to know the maximum number of such payloads per frame to be able
> +	 * to calculate the buffer size. Currently this information is
> +	 * unavailable. A proposal should be made to the UVC committee to add
> +	 * this information to camera descriptors.
> +	 */
> +	if (stream->intf->num_altsetting > 1 ||
> +	    !(dev->quirks & UVC_QUIRK_METADATA_NODE) ||
> +	    dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT)
> +		return 0;
> +
> +	vdev->v4l2_dev = &dev->vdev;
> +	vdev->fops = &uvc_meta_fops;
> +	vdev->ioctl_ops = &uvc_meta_ioctl_ops;
> +	vdev->release = video_device_release_empty;
> +	vdev->prio = &stream->chain->prio;
> +	vdev->vfl_dir = VFL_DIR_RX;
> +	vdev->queue = queue;
> +	vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
> +	strlcpy(vdev->name, dev->name, sizeof(vdev->name));
> +
> +	video_set_drvdata(vdev, stream);
> +
> +	/* Initialize the video buffer queue. */
> +	queue->type = V4L2_BUF_TYPE_META_CAPTURE;
> +	queue->io_modes = VB2_MMAP | VB2_USERPTR;
> +	queue->drv_priv = quvc;
> +	queue->buf_struct_size = sizeof(struct uvc_buffer);
> +	queue->ops = &uvc_meta_queue_ops;
> +	queue->mem_ops = &vb2_vmalloc_memops;
> +	queue->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
> +		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
> +	queue->lock = &quvc->mutex;
> +	ret = vb2_queue_init(queue);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0)
> +		uvc_printk(KERN_ERR, "Failed to register metadata device (%d).\n", ret);
> +
> +	return ret;
> +}
> diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
> index b9ef31c..2f205db 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -69,13 +69,26 @@ static void uvc_queue_return_buffers(struct uvc_video_queue *queue,
>   * videobuf2 queue operations
>   */
>  
> -static int uvc_queue_setup(struct vb2_queue *vq,
> -			   unsigned int *nbuffers, unsigned int *nplanes,
> -			   unsigned int sizes[], struct device *alloc_devs[])
> +int uvc_queue_setup(struct vb2_queue *vq,
> +		    unsigned int *nbuffers, unsigned int *nplanes,
> +		    unsigned int sizes[], struct device *alloc_devs[])
>  {
>  	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
> -	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
> -	unsigned size = stream->ctrl.dwMaxVideoFrameSize;
> +	struct uvc_streaming *stream;
> +	unsigned int size;
> +
> +	switch (vq->type) {
> +	case V4L2_BUF_TYPE_META_CAPTURE:
> +		size = UVC_PAYLOAD_HEADER_MAX_SIZE;
> +
> +		if (*nplanes && *nplanes != 1)
> +			return -EINVAL;
> +
> +		break;
> +	default:
> +		stream = uvc_queue_to_stream(queue);
> +		size = stream->ctrl.dwMaxVideoFrameSize;
> +	}
>  
>  	/* Make sure the image size is large enough. */
>  	if (*nplanes)
> @@ -85,34 +98,47 @@ static int uvc_queue_setup(struct vb2_queue *vq,
>  	return 0;
>  }
>  
> -static int uvc_buffer_prepare(struct vb2_buffer *vb)
> +int uvc_buffer_prepare(struct vb2_buffer *vb)
>  {
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
>  	struct uvc_buffer *buf = uvc_vbuf_to_buffer(vbuf);
>  
> -	if (vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> -	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
> -		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds.\n");
> -		return -EINVAL;
> -	}
> -
>  	if (unlikely(queue->flags & UVC_QUEUE_DISCONNECTED))
>  		return -ENODEV;
>  
> +	switch (vb->type) {
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +		if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
> +			uvc_trace(UVC_TRACE_CAPTURE,
> +				  "[E] Bytes used out of bounds.\n");
> +			return -EINVAL;
> +		}
> +
> +		buf->bytesused = vb2_get_plane_payload(vb, 0);
> +
> +		break;
> +	case V4L2_BUF_TYPE_META_CAPTURE:
> +		if (vb->num_planes != 1 ||
> +		    vb2_plane_size(vb, 0) < UVC_PAYLOAD_HEADER_MAX_SIZE) {
> +			uvc_trace(UVC_TRACE_CAPTURE,
> +				  "[E] Invalid buffer configuration.\n");
> +			return -EINVAL;
> +		}
> +		/* Fall through */
> +	default:
> +		buf->bytesused = 0;
> +	}
> +
>  	buf->state = UVC_BUF_STATE_QUEUED;
>  	buf->error = 0;
>  	buf->mem = vb2_plane_vaddr(vb, 0);
>  	buf->length = vb2_plane_size(vb, 0);
> -	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		buf->bytesused = 0;
> -	else
> -		buf->bytesused = vb2_get_plane_payload(vb, 0);
>  
>  	return 0;
>  }
>  
> -static void uvc_buffer_queue(struct vb2_buffer *vb)
> +void uvc_buffer_queue(struct vb2_buffer *vb)
>  {
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
> @@ -164,13 +190,15 @@ static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	return ret;
>  }
>  
> -static void uvc_stop_streaming(struct vb2_queue *vq)
> +void uvc_stop_streaming(struct vb2_queue *vq)
>  {
>  	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
> -	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
>  	unsigned long flags;
>  
> -	uvc_video_enable(stream, 0);
> +	if (vq->type != V4L2_BUF_TYPE_META_CAPTURE) {
> +		struct uvc_streaming *stream = uvc_queue_to_stream(queue);
> +		uvc_video_enable(stream, 0);
> +	}
>  
>  	spin_lock_irqsave(&queue->irqlock, flags);
>  	uvc_queue_return_buffers(queue, UVC_BUF_STATE_ERROR);
> diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> index 51b5ae5..ed5aac5 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1158,8 +1158,30 @@ static void uvc_video_validate_buffer(const struct uvc_streaming *stream,
>  /*
>   * Completion handler for video URBs.
>   */
> +static struct uvc_buffer *uvc_video_decode_meta(struct uvc_streaming *stream,
> +			struct uvc_buffer *buf, struct uvc_buffer *meta_buf,
> +			u8 *mem, unsigned int length)
> +{
> +	size_t nbytes;
> +
> +	if (!meta_buf || !length)
> +		return NULL;
> +
> +	nbytes = min(length, meta_buf->length);
> +
> +	meta_buf->buf.sequence = buf->buf.sequence;
> +	meta_buf->buf.field = buf->buf.field;
> +	meta_buf->buf.vb2_buf.timestamp = buf->buf.vb2_buf.timestamp;
> +
> +	memcpy(meta_buf->mem, mem, nbytes);
> +	meta_buf->bytesused = nbytes;
> +	meta_buf->state = UVC_BUF_STATE_READY;
> +
> +	return uvc_queue_next_buffer(&stream->meta.queue, meta_buf);
> +}
> +
>  static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
> -	struct uvc_buffer *buf)
> +			struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
>  {
>  	u8 *mem;
>  	int ret, i;
> @@ -1205,7 +1227,7 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
>  }
>  
>  static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
> -	struct uvc_buffer *buf)
> +			struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
>  {
>  	u8 *mem;
>  	int len, ret;
> @@ -1239,6 +1261,8 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
>  			memcpy(stream->bulk.header, mem, ret);
>  			stream->bulk.header_size = ret;
>  
> +			uvc_video_decode_meta(stream, buf, meta_buf, mem, ret);
> +
>  			mem += ret;
>  			len -= ret;
>  		}
> @@ -1272,7 +1296,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
>  }
>  
>  static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
> -	struct uvc_buffer *buf)
> +	struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
>  {
>  	u8 *mem = urb->transfer_buffer;
>  	int len = stream->urb_size, ret;
> @@ -1318,7 +1342,9 @@ static void uvc_video_complete(struct urb *urb)
>  {
>  	struct uvc_streaming *stream = urb->context;
>  	struct uvc_video_queue *queue = &stream->queue;
> +	struct uvc_video_queue *qmeta = &stream->meta.queue;
>  	struct uvc_buffer *buf = NULL;
> +	struct uvc_buffer *buf_meta = NULL;
>  	unsigned long flags;
>  	int ret;
>  
> @@ -1337,6 +1363,7 @@ static void uvc_video_complete(struct urb *urb)
>  	case -ECONNRESET:	/* usb_unlink_urb() called. */
>  	case -ESHUTDOWN:	/* The endpoint is being disabled. */
>  		uvc_queue_cancel(queue, urb->status == -ESHUTDOWN);
> +		uvc_queue_cancel(qmeta, urb->status == -ESHUTDOWN);
>  		return;
>  	}
>  
> @@ -1346,7 +1373,13 @@ static void uvc_video_complete(struct urb *urb)
>  				       queue);
>  	spin_unlock_irqrestore(&queue->irqlock, flags);
>  
> -	stream->decode(urb, stream, buf);
> +	spin_lock_irqsave(&qmeta->irqlock, flags);
> +	if (!list_empty(&qmeta->irqqueue))
> +		buf_meta = list_first_entry(&qmeta->irqqueue, struct uvc_buffer,
> +					    queue);
> +	spin_unlock_irqrestore(&qmeta->irqlock, flags);
> +
> +	stream->decode(urb, stream, buf, buf_meta);
>  
>  	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
>  		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> index a1e6a19..c9f8090 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -176,6 +176,7 @@
>  #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
>  #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
>  #define UVC_QUIRK_FORCE_Y8		0x00000800
> +#define UVC_QUIRK_METADATA_NODE		0x00001000
>  
>  /* Format flags */
>  #define UVC_FMT_FLAG_COMPRESSED		0x00000001
> @@ -464,6 +465,11 @@ struct uvc_stats_stream {
>  	unsigned int max_sof;		/* Maximum STC.SOF value */
>  };
>  
> +struct uvc_meta_device {
> +	struct video_device vdev;
> +	struct uvc_video_queue queue;
> +};
> +
>  struct uvc_streaming {
>  	struct list_head list;
>  	struct uvc_device *dev;
> @@ -495,7 +501,9 @@ struct uvc_streaming {
>  	unsigned int frozen : 1;
>  	struct uvc_video_queue queue;
>  	void (*decode) (struct urb *urb, struct uvc_streaming *video,
> -			struct uvc_buffer *buf);
> +			struct uvc_buffer *buf, struct uvc_buffer *meta_buf);
> +
> +	struct uvc_meta_device meta;
>  
>  	/* Context data used by the bulk completion handler. */
>  	struct {
> @@ -675,6 +683,12 @@ extern unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
>  		unsigned long pgoff);
>  #endif
>  extern int uvc_queue_allocated(struct uvc_video_queue *queue);
> +extern int uvc_queue_setup(struct vb2_queue *vq,
> +			   unsigned int *nbuffers, unsigned int *nplanes,
> +			   unsigned int sizes[], struct device *alloc_devs[]);
> +extern int uvc_buffer_prepare(struct vb2_buffer *vb);
> +extern void uvc_buffer_queue(struct vb2_buffer *vb);
> +extern void uvc_stop_streaming(struct vb2_queue *vq);
>  static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
>  {
>  	return vb2_is_streaming(&queue->queue);
> @@ -704,6 +718,7 @@ extern int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
>  void uvc_video_clock_update(struct uvc_streaming *stream,
>  			    struct vb2_v4l2_buffer *vbuf,
>  			    struct uvc_buffer *buf);
> +int uvc_meta_register(struct uvc_streaming *stream);
>  
>  /* Status */
>  extern int uvc_status_init(struct uvc_device *dev);
> @@ -758,7 +773,7 @@ extern struct usb_host_endpoint *uvc_find_endpoint(
>  
>  /* Quirks support */
>  void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
> -		struct uvc_buffer *buf);
> +		struct uvc_buffer *buf, struct uvc_buffer *meta_buf);
>  
>  /* debugfs and statistics */
>  int uvc_debugfs_init(void);
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 44a29af..1618be4 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1232,6 +1232,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  	case V4L2_TCH_FMT_DELTA_TD08:	descr = "8-bit signed deltas"; break;
>  	case V4L2_TCH_FMT_TU16:		descr = "16-bit unsigned touch data"; break;
>  	case V4L2_TCH_FMT_TU08:		descr = "8-bit unsigned touch data"; break;
> +	case V4L2_META_FMT_UVC:		descr = "UVC payload header metadata"; break;
>  
>  	default:
>  		/* Compressed formats */
> diff --git a/include/uapi/linux/uvcvideo.h b/include/uapi/linux/uvcvideo.h
> index 3b08186..9e8e7db 100644
> --- a/include/uapi/linux/uvcvideo.h
> +++ b/include/uapi/linux/uvcvideo.h
> @@ -67,4 +67,11 @@ struct uvc_xu_control_query {
>  #define UVCIOC_CTRL_MAP		_IOWR('u', 0x20, struct uvc_xu_control_mapping)
>  #define UVCIOC_CTRL_QUERY	_IOWR('u', 0x21, struct uvc_xu_control_query)
>  
> +/*
> + * Metadata node
> + */
> +
> +/* Header size is stored in 1 byte, i.e. <= 255 */
> +#define UVC_PAYLOAD_HEADER_MAX_SIZE 255
> +
>  #endif
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 1b894db..6b74191 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -678,6 +678,9 @@ struct v4l2_pix_format {
>  #define V4L2_TCH_FMT_TU16	v4l2_fourcc('T', 'U', '1', '6') /* 16-bit unsigned touch data */
>  #define V4L2_TCH_FMT_TU08	v4l2_fourcc('T', 'U', '0', '8') /* 8-bit unsigned touch data */
>  
> +/* Meta-data formats */
> +#define V4L2_META_FMT_UVC         v4l2_fourcc('U', 'V', 'C', 'H') /* UVC Payload Header metadata */
> +
>  /* priv field value to indicates that subsequent fields are valid. */
>  #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
>  
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
