Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55593 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750980AbdGYN3s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 09:29:48 -0400
Date: Tue, 25 Jul 2017 15:27:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4] uvcvideo: add a metadata device node
In-Reply-To: <3406101.2MuKeu43r1@avalon>
Message-ID: <Pine.LNX.4.64.1707240958280.4948@axis700.grange>
References: <Pine.LNX.4.64.1707071536440.9200@axis700.grange>
 <3406101.2MuKeu43r1@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your comments!

On Fri, 21 Jul 2017, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thank you for the patch.
> 
> > Some UVC video cameras contain metadata in their payload headers. This
> > patch extracts that data, adding more clock synchronisation information,
> > on both bulk and isochronous endpoints and makes it available to the
> > user space on a separate video node, using the V4L2_CAP_META_CAPTURE
> > capability and the V4L2_BUF_TYPE_META_CAPTURE buffer queue type. Even
> > though different cameras will have different metadata formats, we use
> > the same V4L2_META_FMT_UVC pixel format for all of them. Users have to
> > parse data, based on the specific camera model information.
> 
> The issue we still haven't addressed is how to ensure that vendors will
> document their metadata format :-S

Uhm, add a black list of offending vendors and drop 60% of their frames? 
;-)

> > This version of the patch only creates such metadata nodes for cameras,
> > specifying a UVC_QUIRK_METADATA_NODE quirk flag.
> > 
> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > ---
> > 
> > v4:
> > - add support for isochronous cameras. Metadata is now collected from as 
> > many payloads as they fit in the buffer
> > - add a USB Start Of Frame and a system timestamp to each metadata block 
> > for user-space clock synchronisation
> > - use a default buffer size of 1024 bytes
> > 
> > Thanks to Laurent for patient long discussions and to everybody, who 
> > helped me conduct all the investigation into various past, present and 
> > future UVC cameras :-)
> > 
> >  drivers/media/usb/uvc/Makefile       |   2 +-
> >  drivers/media/usb/uvc/uvc_driver.c   |   4 +
> >  drivers/media/usb/uvc/uvc_isight.c   |   2 +-
> >  drivers/media/usb/uvc/uvc_metadata.c | 158 +++++++++++++++++++++++++++++++
> >  drivers/media/usb/uvc/uvc_queue.c    |  68 ++++++++++-----
> >  drivers/media/usb/uvc/uvc_video.c    | 101 +++++++++++++++++++---
> >  drivers/media/usb/uvc/uvcvideo.h     |  23 ++++-
> >  drivers/media/v4l2-core/v4l2-ioctl.c |   1 +
> >  include/uapi/linux/uvcvideo.h        |  19 +++++
> >  include/uapi/linux/videodev2.h       |   3 +
> >  10 files changed, 347 insertions(+), 34 deletions(-)
> >  create mode 100644 drivers/media/usb/uvc/uvc_metadata.c
> 
> [snip]
> 
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c
> > index 70842c5..9f23dcf 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -1880,6 +1880,7 @@ static void uvc_unregister_video(struct uvc_device
> > *dev)
> >  			continue;
> >  
> >  		video_unregister_device(&stream->vdev);
> > +		video_unregister_device(&stream->meta.vdev);
> >  
> >  		uvc_debugfs_cleanup_stream(stream);
> >  	}
> > @@ -1941,6 +1942,9 @@ static int uvc_register_video(struct uvc_device *dev,
> >  		return ret;
> >  	}
> >  
> > +	/* Register a metadata node. */
> > +	uvc_meta_register(stream);
> 
> This can fail, you should handle errors.

Yes, this is in a way deliberate. If metadata node registration fails, the 
driver continues without one. Would you prefer to fail and unregister the 
main node in this case?

> >  	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> >  		stream->chain->caps |= V4L2_CAP_VIDEO_CAPTURE;
> >  	else
> 
> [snip]
> 
> > diff --git a/drivers/media/usb/uvc/uvc_metadata.c 
> b/drivers/media/usb/uvc/uvc_metadata.c
> > new file mode 100644
> > index 0000000..876badd
> > --- /dev/null
> > +++ b/drivers/media/usb/uvc/uvc_metadata.c
> > @@ -0,0 +1,158 @@
> > +/*
> > + *      uvc_metadata.c  --  USB Video Class driver - Metadata handling
> > + *
> > + *      Copyright (C) 2016
> > + *          Guennadi Liakhovetski (guennadi.liakhovetski@intel.com)
> > + *
> > + *      This program is free software; you can redistribute it and/or
> > modify
> > + *      it under the terms of the GNU General Public License as published
> > by
> > + *      the Free Software Foundation; either version 2 of the License, or
> > + *      (at your option) any later version.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/list.h>
> > +#include <linux/module.h>
> > +#include <linux/usb.h>
> > +#include <linux/videodev2.h>
> > +
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/videobuf2-v4l2.h>
> > +#include <media/videobuf2-vmalloc.h>
> > +
> > +#include "uvcvideo.h"
> > +
> > +/* -----------------------------------------------------------------------
> > + * videobuf2 Queue Operations
> > + */
> > +
> > +static struct vb2_ops uvc_meta_queue_ops = {
> > +	.queue_setup = uvc_queue_setup,
> > +	.buf_prepare = uvc_buffer_prepare,
> > +	.buf_queue = uvc_buffer_queue,
> > +	.wait_prepare = vb2_ops_wait_prepare,
> > +	.wait_finish = vb2_ops_wait_finish,
> > +	.stop_streaming = uvc_stop_streaming,
> 
> This looks unbalanced without a start_streaming operation. I know that
> you've modified the uvc_stop_streaming() function to not stop the video
> stream for metadata video nodes, but I think the code would be clearer
> if you implemented a uvc_meta_stop_streaming() function 
> for 

Unfinished sentence? Adding a uvc_meta_stop_streaming() wouldn't balance 
the .start_streaming() by itself. Do you want a dummy function, returning 
0 there? Seems even uglier to me...

> > +};
> > +
> > +/* ------------------------------------------------------------------------
> > + * V4L2 ioctls
> > + */
> > +
> > +static int meta_v4l2_querycap(struct file *file, void *fh,
> > +			      struct v4l2_capability *cap)
> 
> For consistency with the rest of the code, could you prefix this and the
> next function with uvc_ ?
> 
> > +{
> > +	struct v4l2_fh *vfh = file->private_data;
> > +	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
> > +
> > +	strlcpy(cap->driver, "uvcvideo", sizeof(cap->driver));
> > +	strlcpy(cap->card, vfh->vdev->name, sizeof(cap->card));
> > +	usb_make_path(stream->dev->udev, cap->bus_info, sizeof(cap
> > ->bus_info));
> > +
> > +	return 0;
> > +}
> 
> [snip]
> 
> > +int uvc_meta_register(struct uvc_streaming *stream)
> > +{
> > +	struct uvc_device *dev = stream->dev;
> > +	struct uvc_meta_device *meta = &stream->meta;
> > +	struct video_device *vdev = &meta->vdev;
> > +	struct uvc_video_queue *quvc = &meta->queue;
> > +	struct vb2_queue *queue = &quvc->queue;
> > +	int ret;
> > +
> > +	mutex_init(&quvc->mutex);
> > +	spin_lock_init(&quvc->irqlock);
> > +	INIT_LIST_HEAD(&quvc->irqqueue);
> > +
> > +	/*
> > +	 * We register metadata device nodes only if the METADATA_NODE quirk
> > is
> > +	 * set and only on interfaces with bulk endpoints. To meaningfully
> > +	 * support interfaces with isochronous endpoints, we need to collect
> > +	 * headers from all payloads, comprising a single frame. For that we
> > +	 * need to know the maximum number of such payloads per frame to be
> > able
> > +	 * to calculate the buffer size. Currently this information is
> > +	 * unavailable. A proposal should be made to the UVC committee to add
> > +	 * this information to camera descriptors.
> > +	 */
> > +	if (!(dev->quirks & UVC_QUIRK_METADATA_NODE) ||
> > +	    dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT)
> > +		return 0;
> > +
> > +	vdev->v4l2_dev = &dev->vdev;
> > +	vdev->fops = &uvc_meta_fops;
> > +	vdev->ioctl_ops = &uvc_meta_ioctl_ops;
> > +	vdev->release = video_device_release_empty;
> 
> Please, no. You'll end up crashing the kernel if an application has the meta
> devnode open when the device is disconnected. Proper refcounting is needed.

Hm, I just tried

open("/dev/video1",..);
sleep();
/* unplug */
ioctl();
close();

no crash. Why do you think there should be one? Doesn't the 
uvc_disconnect() already take care of everything, including unregistering 
both video devices?

> > +	vdev->prio = &stream->chain->prio;
> > +	vdev->vfl_dir = VFL_DIR_RX;
> > +	vdev->queue = queue;
> > +	vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
> > +	strlcpy(vdev->name, dev->name, sizeof(vdev->name));
> > +
> > +	video_set_drvdata(vdev, stream);
> > +
> > +	/* Initialize the video buffer queue. */
> > +	queue->type = V4L2_BUF_TYPE_META_CAPTURE;
> > +	queue->io_modes = VB2_MMAP | VB2_USERPTR;
> > +	queue->drv_priv = quvc;
> > +	queue->buf_struct_size = sizeof(struct uvc_buffer);
> > +	queue->ops = &uvc_meta_queue_ops;
> > +	queue->mem_ops = &vb2_vmalloc_memops;
> > +	queue->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
> > +		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
> > +	queue->lock = &quvc->mutex;
> > +	ret = vb2_queue_init(queue);
> > +	if (ret < 0)
> > +		return ret;
> 
> How about calling uvc_queue_init() instead of duplicating the code ? You would
> just need to extend the function with a parameter for the queue ops. Or,
> possibly even better, you could move the definition of the queue ops to
> uvc_queue.c. That way you won't have to expose a bunch of currently static
> queue functions.

I tried to isolate all the metadata node related code to a separate file 
to avoid blowing up existing code paths and for easier maintenance, but 
sure, can do.

> Similarly, it looks like you're duplicating code from uvc_register_video(),
> which I believe could be shared.

It could, yes, but that would only save about 5 to 10 lines of code, would 
not put a complete vdev initialisation in one place or would have to 
explicitly check for META. This looks less suitable for reuse to me.

> > +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> > +	if (ret < 0)
> > +		uvc_printk(KERN_ERR, "Failed to register metadata device (%d).
> \n", ret);
> 
> This line is over 80 characters.
> 
> > +	return ret;
> > +}
> > diff --git a/drivers/media/usb/uvc/uvc_queue.c
> > b/drivers/media/usb/uvc/uvc_queue.c
> > index aa21997..77dedbc 100644
> > --- a/drivers/media/usb/uvc/uvc_queue.c
> > +++ b/drivers/media/usb/uvc/uvc_queue.c
> > @@ -74,13 +74,26 @@ static void uvc_queue_return_buffers(struct
> > uvc_video_queue *queue,
> >   * videobuf2 queue operations
> >   */
> >  
> > -static int uvc_queue_setup(struct vb2_queue *vq,
> > -			   unsigned int *nbuffers, unsigned int *nplanes,
> > -			   unsigned int sizes[], struct device *alloc_devs[])
> > +int uvc_queue_setup(struct vb2_queue *vq,
> > +		    unsigned int *nbuffers, unsigned int *nplanes,
> > +		    unsigned int sizes[], struct device *alloc_devs[])
> >  {
> >  	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
> > -	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
> > -	unsigned size = stream->ctrl.dwMaxVideoFrameSize;
> > +	struct uvc_streaming *stream;
> > +	unsigned int size;
> > +
> > +	switch (vq->type) {
> > +	case V4L2_BUF_TYPE_META_CAPTURE:
> > +		size = UVC_METATADA_BUF_SIZE;
> > +
> > +		if (*nplanes && *nplanes != 1)
> > +			return -EINVAL;
> 
> As the driver doesn't support any multi-plane format, should this check be
> moved out of the switch ? You should then add it in a separate patch before
> this one.

I've double-checked the documentation for struct vb2_ops and it says:

 *			The driver should return the required number of buffers
 *			in \*num_buffers, the required number of planes per
 *			buffer in \*num_planes,...

But later

 *					If either \*num_planes or the requested
 *			sizes are invalid callback must return %-EINVAL.

I'd say, the former refers to the case, when *num_planes = 0 on input, so, 
yes, we can add a check globally.

> > +		break;
> 
> Could you add a blank line between break statements and the next case to be
> consistent with the driver's coding style ?
> 
> > +	default:
> > +		stream = uvc_queue_to_stream(queue);
> > +		size = stream->ctrl.dwMaxVideoFrameSize;
> 
> While not strictly needed, the driver uses break statements in the default
> cases. Could you please do so here (and below) too ?
> 
> > +	}
> >  
> >  	/* Make sure the image size is large enough. */
> >  	if (*nplanes)
> > @@ -90,34 +103,47 @@ static int uvc_queue_setup(struct vb2_queue *vq,
> >  	return 0;
> >  }
> >  
> > -static int uvc_buffer_prepare(struct vb2_buffer *vb)
> > +int uvc_buffer_prepare(struct vb2_buffer *vb)
> >  {
> >  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> >  	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
> >  	struct uvc_buffer *buf = uvc_vbuf_to_buffer(vbuf);
> >  
> > -	if (vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> > -	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
> > -		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds
> > .\n");
> > -		return -EINVAL;
> > -	}
> > -
> >  	if (unlikely(queue->flags & UVC_QUEUE_DISCONNECTED))
> >  		return -ENODEV;
> >  
> > +	switch (vb->type) {
> > +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> > +		if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
> > +			uvc_trace(UVC_TRACE_CAPTURE,
> > +				  "[E] Bytes used out of bounds.\n");
> > +			return -EINVAL;
> > +		}
> > +
> > +		buf->bytesused = vb2_get_plane_payload(vb, 0);
> > +
> > +		break;
> > +	case V4L2_BUF_TYPE_META_CAPTURE:
> > +		if (vb->num_planes != 1 ||
> > +		    vb2_plane_size(vb, 0) < UVC_METATADA_BUF_SIZE) {
> 
> Can this happen, given that queue_setup rejects buffers that verify those
> conditions ?

As far as I can see, e.g. in the USERPTR case the length is directly 
copied from the user-provided struct v4l2_buffer:

vb2_qbuf()
vb2_core_qbuf()
__buf_prepare()
__prepare_userptr()	
__fill_vb2_buffer()
	planes[0].length = b->length;

Still, the length check is optional. We could just as well omit it here 
and rely on the respective uvc_video_decode_*() function to limit the 
amount of copied data. But it does look like vb->num_planes cannot be 
wrong, you're right about that one.

> > +			uvc_trace(UVC_TRACE_CAPTURE,
> > +				  "[E] Invalid buffer configuration.\n");
> > +			return -EINVAL;
> > +		}
> > +		/* Fall through */
> > +	default:
> > +		buf->bytesused = 0;
> > +	}
> > +
> >  	buf->state = UVC_BUF_STATE_QUEUED;
> >  	buf->error = 0;
> >  	buf->mem = vb2_plane_vaddr(vb, 0);
> >  	buf->length = vb2_plane_size(vb, 0);
> > -	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> 
> Unless I was mistaken in my previous comment, I think you only need to change
> the condition to vb->type != V4L2_BUF_TYPE_VIDEO_OUTPUT, no other change to
> the function should be needed.

Yeah, ok, let's do that.

> > -		buf->bytesused = 0;
> > -	else
> > -		buf->bytesused = vb2_get_plane_payload(vb, 0);
> >  
> >  	return 0;
> >  }
> >  
> > -static void uvc_buffer_queue(struct vb2_buffer *vb)
> > +void uvc_buffer_queue(struct vb2_buffer *vb)
> >  {
> >  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> >  	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
> > @@ -169,13 +195,15 @@ static int uvc_start_streaming(struct vb2_queue *vq,
> > unsigned int count)
> >  	return ret;
> >  }
> >  
> > -static void uvc_stop_streaming(struct vb2_queue *vq)
> > +void uvc_stop_streaming(struct vb2_queue *vq)
> >  {
> >  	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
> > -	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
> >  	unsigned long flags;
> >  
> > -	uvc_video_enable(stream, 0);
> > +	if (vq->type != V4L2_BUF_TYPE_META_CAPTURE) {
> > +		struct uvc_streaming *stream = uvc_queue_to_stream(queue);
> 
> Hasn't checkpatch complained about a missing blank line here ?
> 
> > +		uvc_video_enable(stream, 0);
> > +	}
> >  
> >  	spin_lock_irqsave(&queue->irqlock, flags);
> >  	uvc_queue_return_buffers(queue, UVC_BUF_STATE_ERROR);
> > diff --git a/drivers/media/usb/uvc/uvc_video.c
> > b/drivers/media/usb/uvc/uvc_video.c
> > index fb86d6a..3a54439 100644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -1152,8 +1152,76 @@ static void uvc_video_validate_buffer(const struct
> > uvc_streaming *stream,
> >  /*
> >   * Completion handler for video URBs.
> >   */
> 
> I think this function would be better placed in a new "Metadata" section right
> before the "URB handling" section.
> 
> > +
> > +static void uvc_video_decode_meta(struct uvc_streaming *stream,
> > +			struct uvc_buffer *buf, struct uvc_buffer *meta_buf,
> 
> You might want to call buf video_buf for clarity.
> 
> > +			u8 *mem, unsigned int length)
> > +{
> > +	struct uvc_meta_buf *meta;
> > +	size_t len_std = 2;
> > +	bool has_pts, has_scr;
> > +	u8 *scr;
> > +
> > +	if (!meta_buf || length == 2 ||
> > +	    meta_buf->length - meta_buf->bytesused <
> > +	    length + sizeof(meta->ts) + sizeof(meta->sof) ||
> > +	    length != mem[0])
> 
> I don't think the last condition can occur here, as it should be caught in
> uvc_video_decode_start() and result in the payload being skipped.
> 
> > +		return;
> > +
> > +	has_pts = mem[1] & UVC_STREAM_PTS;
> > +	has_scr = mem[1] & UVC_STREAM_SCR;
> > +
> > +	if (has_pts) {
> > +		len_std += 4;
> > +		scr = mem + 6;
> > +	} else {
> > +		scr = mem + 2;
> > +	}
> > +
> > +	if (has_scr)
> > +		len_std += 6;
> > +
> > +	if (length == len_std && (!has_scr ||
> > +				  !memcmp(scr, stream->clock.last_scr, 6)))
> > +		return;
> 
> I think a comment would be useful to explain the strategy. I understand it now
> as we've discussed it recently, but I'm not sure I still will in 6 months :-)
> You could add a comment block at the beginning of the function, similarly to
> uvc_video_decode_start().
> 
> > +
> > +	meta = (struct uvc_meta_buf *)((u8 *)meta_buf->mem + meta_buf
> > ->bytesused);
> > +	uvc_video_get_ts(&meta->ts);
> > +	meta->sof = usb_get_current_frame_number(stream->dev->udev);
> 
> You should disable local interrupts around those two calls to ensure that they
> will be as close as possible.

Hmmm, is it a "recommended" practice? But sure, it can indeed help, so, if 
you're ok with it, will do.

> > +
> > +	if (!meta_buf->bytesused) {
> > +		meta_buf->buf.sequence = buf->buf.sequence;
> > +		meta_buf->buf.field = buf->buf.field;
> > +		meta_buf->buf.vb2_buf.timestamp = buf->buf.vb2_buf.timestamp;
> 
> I wonder whether it wouldn't be clearer to do this in
> uvc_video_step_buffers(). You wouldn't need to check bytesused then, and the
> code would be more future-proof in case the driver gets changed to set one of
> those fields later than uvc_video_decode_start().
> 
> > +	}
> > +
> > +	if (has_scr)
> > +		memcpy(stream->clock.last_scr, scr, 6);
> > +
> > +	memcpy(&meta->length, mem, length);
> > +	meta_buf->bytesused += length + sizeof(meta->ts) + sizeof(meta->sof);
> > +
> > +	uvc_trace(UVC_TRACE_FRAME,
> > +		  "%s(): t-sys %lu.%09lus, SOF %u, len %u, flags 0x%x, PTS %u,
> > STC %u frame SOF %u\n",
> > +		  __func__, meta->ts.tv_sec, meta->ts.tv_nsec, meta->sof,
> > +		  meta->length, meta->flags, has_pts ? *(u32 *)meta->buf : 0,
> > +		  has_scr ? *(u32 *)scr : 0,
> > +		  has_scr ? *(u32 *)(scr + 4) & 0x7ff : 0);
> > +}
> > +
> > +static struct uvc_buffer *uvc_video_step_buffers(struct uvc_streaming
> > *stream,
> > +			struct uvc_buffer *buf, struct uvc_buffer **meta_buf)
> 
> Wouldn't it better to make the function more symmetrical by passing **buf the
> same way we pass **meta_buf ?

No! I definitely don't think symmetry is worth it!

> And as commented above, I think I would rename
> buf to video_buf.
> 
> > +{
> > +	if (*meta_buf) {
> > +		(*meta_buf)->state = UVC_BUF_STATE_READY;
> > +		*meta_buf = uvc_queue_next_buffer(&stream->meta.queue,
> > +						  *meta_buf);
> > +	}
> > +	return uvc_queue_next_buffer(&stream->queue, buf);
> > +}
> > +
> >  static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming
> >  *stream,
> > -	struct uvc_buffer *buf)
> > +			struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
> >  {
> >  	u8 *mem;
> >  	int ret, i;
> 
> [snip]
> 
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h 
> b/drivers/media/usb/uvc/uvcvideo.h
> > index 15e415e..d06e2d6 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -185,6 +185,7 @@
> >  #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
> >  #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
> >  #define UVC_QUIRK_FORCE_Y8		0x00000800
> > +#define UVC_QUIRK_METADATA_NODE		0x00001000
> 
> I notice that you don't set the quirk for any device. What's your plan there,
> will there be more patches ?

Yes, if the quirk is your preferred way to go, I can submit (an) 
additional patch(es) with some cameras.

> >  /* Format flags */
> >  #define UVC_FMT_FLAG_COMPRESSED		0x00000001
> 
> [snip]
> 
> > @@ -546,6 +556,8 @@ struct uvc_streaming {
> >  		u16 last_sof;
> >  		u16 sof_offset;
> >  
> > +		u8 last_scr[6];
> > +
> >  		spinlock_t lock;
> >  	} clock;
> >  };
> > @@ -684,6 +696,12 @@ extern unsigned long uvc_queue_get_unmapped_area(struct 
> uvc_video_queue *queue,
> >  		unsigned long pgoff);
> >  #endif
> >  extern int uvc_queue_allocated(struct uvc_video_queue *queue);
> > +extern int uvc_queue_setup(struct vb2_queue *vq,
> > +			   unsigned int *nbuffers, unsigned int *nplanes,
> > +			   unsigned int sizes[], struct device *alloc_devs[]);
> > +extern int uvc_buffer_prepare(struct vb2_buffer *vb);
> > +extern void uvc_buffer_queue(struct vb2_buffer *vb);
> > +extern void uvc_stop_streaming(struct vb2_queue *vq);
> 
> You can drop the extern keyword, it's not needed.

I know, but I was following the coding style of this driver ;-) But in 
fact after moving uvc_meta_queue_qops to uvc_queue.c, these declarations 
aren't needed any more, which is good.

> >  static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
> >  {
> >  	return vb2_is_streaming(&queue->queue);
> 
> [snip]
> 
> > diff --git a/include/uapi/linux/uvcvideo.h b/include/uapi/linux/uvcvideo.h
> > index 3b08186..c503dcc 100644
> > --- a/include/uapi/linux/uvcvideo.h
> > +++ b/include/uapi/linux/uvcvideo.h
> > @@ -67,4 +67,23 @@ struct uvc_xu_control_query {
> >  #define UVCIOC_CTRL_MAP		_IOWR('u', 0x20, struct 
> uvc_xu_control_mapping)
> >  #define UVCIOC_CTRL_QUERY	_IOWR('u', 0x21, struct uvc_xu_control_query)
> >  
> > +/*
> > + * Metadata node
> > + */
> > +
> > +/*
> 
> Could you please use kerneldoc comments to document this structure ?
> 
> > + * UVC metadata nodes fill buffers with possibly multiple instances of the
> > + * following struct. The first two fields are added by the driver, they can
> > be
> > + * used for clock synchronisation. The rest is an exact copy of a UVC
> > payload
> > + * header. Only complete objects with complete buffers are included.
> > Therefore
> > + * it's always sizeof(meta->ts) + sizeof(meta->sof) + meta->length bytes
> > large.
> > + */
> > +struct uvc_meta_buf {
> > +	struct timespec ts;
> 
> timespec has a different size on 32-bit and 64-bit architectures, so there
> could be issues on 32-bit userspace running on a 64-bit kernel.
> 
> Additionally, on 32-bit platforms, timespec is not year 2038-safe. I thought
> that timespec64 was exposed to userspace nowadays, but it doesn't seem to be
> the case. I'm not sure how to handle this.

Oh, that isn't good :-/ I'll have to think more about this. If you get any 
more ideas, I'd be glad to hear them too.

Thanks
Guennadi

> > +	__u16 sof;
> > +	__u8 length;
> > +	__u8 flags;
> > +	__u8 buf[];
> 
> I had imagined inserting the ts + sof after the standard header, but this
> probably makes more sense.
> 
> > +};
> > +
> >  #endif
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > index 45cf735..9b0cc7e 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -683,6 +683,9 @@ struct v4l2_pix_format {
> >  #define V4L2_META_FMT_VSP1_HGO    v4l2_fourcc('V', 'S', 'P', 'H') /* R-Car
> >  VSP1 1-D Histogram */
> >  #define V4L2_META_FMT_VSP1_HGT    v4l2_fourcc('V', 'S', 'P', 'T') /* R-Car
> >  VSP1 2-D Histogram */
> >  
> > +/* Meta-data formats */
> > +#define V4L2_META_FMT_UVC         v4l2_fourcc('U', 'V', 'C', 'H') /* UVC 
> Payload Header metadata */
> 
> This should be documented in Documentation/media/, and probably split to a
> separate patch.
> 
> > +
> >  /* priv field value to indicates that subsequent fields are valid. */
> >  #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
> >  
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
