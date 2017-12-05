Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41145 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751380AbdLEAYR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 19:24:17 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 3/3 v7] uvcvideo: add a metadata device node
Date: Tue, 05 Dec 2017 02:24:30 +0200
Message-ID: <2006709.83fRcNtr9s@avalon>
In-Reply-To: <1510156814-28645-4-git-send-email-g.liakhovetski@gmx.de>
References: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de> <1510156814-28645-4-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch. We're getting very close, I only have small comments, 
please see below.

On Wednesday, 8 November 2017 18:00:14 EET Guennadi Liakhovetski wrote:
> Some UVC video cameras contain metadata in their payload headers. This
> patch extracts that data, adding more clock synchronisation information,
> on both bulk and isochronous endpoints and makes it available to the
> user space on a separate video node, using the V4L2_CAP_META_CAPTURE
> capability and the V4L2_BUF_TYPE_META_CAPTURE buffer queue type. Even
> though different cameras will have different metadata formats, we use
> the same V4L2_META_FMT_UVC pixel format for all of them. Users have to
> parse data, based on the specific camera model information. This
> version of the patch only creates such metadata nodes for cameras,
> specifying a UVC_QUIRK_METADATA_NODE quirk flag.

I don't think this is correct anymore, as we'll use different 4CCs for 
different vendor metadata. How would you like to rephrase the commit message ?

> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> ---
> 
> v7: support up to two metadata formats per camera - the standard one and
> an optional private one, if specified in device information
> 
>  drivers/media/usb/uvc/Makefile       |   2 +-
>  drivers/media/usb/uvc/uvc_driver.c   |  15 +++
>  drivers/media/usb/uvc/uvc_isight.c   |   2 +-
>  drivers/media/usb/uvc/uvc_metadata.c | 204 ++++++++++++++++++++++++++++++++
>  drivers/media/usb/uvc/uvc_queue.c    |  41 +++++--
>  drivers/media/usb/uvc/uvc_video.c    | 127 ++++++++++++++++++++--
>  drivers/media/usb/uvc/uvcvideo.h     |  19 +++-
>  drivers/media/v4l2-core/v4l2-ioctl.c |   1 +
>  include/uapi/linux/uvcvideo.h        |  26 +++++
>  9 files changed, 416 insertions(+), 21 deletions(-)
>  create mode 100644 drivers/media/usb/uvc/uvc_metadata.c

[snip]

> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index cbf79b9..5f7ce97 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1877,6 +1877,7 @@ static void uvc_unregister_video(struct uvc_device
> *dev) continue;
> 
>  		video_unregister_device(&stream->vdev);
> +		video_unregister_device(&stream->meta.vdev);
> 
>  		uvc_debugfs_cleanup_stream(stream);
>  	}
> @@ -1934,6 +1935,11 @@ static int uvc_register_video(struct uvc_device *dev,
> return ret;
>  	}
> 
> +	/* Register a metadata node, but ignore a possible failure, complete
> +	 * registration of video nodes anyway.
> +	 */
> +	uvc_meta_register(stream);
> +
>  	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		stream->chain->caps |= V4L2_CAP_VIDEO_CAPTURE;
>  	else
> @@ -2003,6 +2009,7 @@ static int uvc_register_chains(struct uvc_device *dev)
> 
>  struct uvc_device_info {
>  	u32	quirks;
> +	u32	meta_format;
>  };
> 
>  static int uvc_probe(struct usb_interface *intf,
> @@ -2038,8 +2045,16 @@ static int uvc_probe(struct usb_interface *intf,
>  	dev->udev = usb_get_dev(udev);
>  	dev->intf = usb_get_intf(intf);
>  	dev->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
> +	if (uvc_quirks_param != -1 &&
> +	    uvc_quirks_param & UVC_DEV_FLAG_METADATA_NODE) {
> +		uvc_quirks_param &= ~UVC_DEV_FLAG_METADATA_NODE;
> +		if (uvc_quirks_param == 0)
> +			uvc_quirks_param = -1;
> +	}

I think we can remove the UVC_DEV_FLAG_METADATA_NODE flag. We can use the 
metadata format specified in the device information structure if present, and 
default to the standard metadata format otherwise. A metadata video node will 
always be registered, which I think is the right thing to do as exposing 
timestamp information to userspace is useful.

Do you see any adverse effect of registering a metadata video node 
unconditionally ?

>  	dev->quirks = (uvc_quirks_param == -1)
>  		    ? quirks : uvc_quirks_param;
> +	if (info)
> +		dev->meta_format = info->meta_format;
> 
>  	if (udev->product != NULL)
>  		strlcpy(dev->name, udev->product, sizeof dev->name);

[snip]

> diff --git a/drivers/media/usb/uvc/uvc_metadata.c
> b/drivers/media/usb/uvc/uvc_metadata.c new file mode 100644
> index 0000000..21eeee9
> --- /dev/null
> +++ b/drivers/media/usb/uvc/uvc_metadata.c

[snip]

> +/* ------------------------------------------------------------------------
> + * videobuf2 Queue Operations
> + */
> +

You can remove this now that the section is empty :-)

> +/* ------------------------------------------------------------------------
> + * V4L2 ioctls
> + */
> +
> +static int uvc_meta_v4l2_querycap(struct file *file, void *fh,
> +				  struct v4l2_capability *cap)
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

Do you think we could reuse uvc_ioctl_querycap() as-is ?

> +
> +static int uvc_meta_v4l2_get_format(struct file *file, void *fh,
> +				    struct v4l2_format *format)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
> +	struct v4l2_meta_format *fmt = &format->fmt.meta;
> +
> +	if (format->type != vfh->vdev->queue->type)
> +		return -EINVAL;
> +
> +	memset(fmt, 0, sizeof(*fmt));
> +
> +	fmt->dataformat = stream->cur_meta_format;
> +	fmt->buffersize = UVC_METATADA_BUF_SIZE;

You need to take the stream->mutex lock here to protect against races with the 
set format ioctl.

> +	return 0;
> +}
> +
> +static int uvc_meta_v4l2_try_format(struct file *file, void *fh,
> +				    struct v4l2_format *format)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
> +	struct uvc_device *dev = stream->dev;
> +	struct v4l2_meta_format *fmt = &format->fmt.meta;
> +	u32 fmeta = fmt->dataformat;
> +
> +	if (format->type != vfh->vdev->queue->type)
> +		return -EINVAL;
> +
> +	memset(fmt, 0, sizeof(*fmt));
> +
> +	fmt->dataformat = fmeta == dev->meta_format ? fmeta : V4L2_META_FMT_UVC;
> +	fmt->buffersize = UVC_METATADA_BUF_SIZE;
> +
> +	return 0;
> +}
> +
> +static int uvc_meta_v4l2_set_format(struct file *file, void *fh,
> +				    struct v4l2_format *format)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
> +	struct v4l2_meta_format *fmt = &format->fmt.meta;
> +	int ret = uvc_meta_v4l2_try_format(file, fh, format);
> +	if (ret < 0)
> +		return ret;

I expect checkpatch to complain here that a blank line is missing between 
variable declaration and code. I would thus write it

	int ret;

	ret = uvc_meta_v4l2_try_format(file, fh, format);
	if (ret < 0)
		return ret;

> +
> +	/*
> +	 * We could in principle switch at any time, also during streaming.
> +	 * Metadata buffers would still be perfectly parseable, but it's more
> +	 * consistent and cleaner to disallow that

Nitpicking, could you add a period at the end of sentences in comments ?

> +	 */
> +	mutex_lock(&stream->mutex);
> +
> +	if (uvc_queue_allocated(&stream->queue))
> +		ret = -EBUSY;
> +	else
> +		stream->cur_meta_format = fmt->dataformat;
> +
> +	mutex_unlock(&stream->mutex);
> +
> +	return ret;
> +}
> +
> +static int uvc_meta_v4l2_enum_formats(struct file *file, void *fh,
> +				      struct v4l2_fmtdesc *fdesc)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
> +	struct uvc_device *dev = stream->dev;
> +	u32 index = fdesc->index;
> +
> +	if (fdesc->type != vfh->vdev->queue->type ||
> +	    index > 1U || (index && !dev->meta_format))
> +		return -EINVAL;
> +
> +	memset(fdesc, 0, sizeof(*fdesc));
> +
> +	fdesc->type = vfh->vdev->queue->type;
> +	fdesc->index = index;
> +	fdesc->pixelformat = index ? dev->meta_format : V4L2_META_FMT_UVC;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops uvc_meta_ioctl_ops = {
> +	.vidioc_querycap		= uvc_meta_v4l2_querycap,
> +	.vidioc_g_fmt_meta_cap		= uvc_meta_v4l2_get_format,
> +	.vidioc_s_fmt_meta_cap		= uvc_meta_v4l2_set_format,
> +	.vidioc_try_fmt_meta_cap	= uvc_meta_v4l2_try_format,
> +	.vidioc_enum_fmt_meta_cap	= uvc_meta_v4l2_enum_formats,
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
> +/* ------------------------------------------------------------------------
> + * V4L2 File Operations
> + */
> +
> +static struct v4l2_file_operations uvc_meta_fops = {

This should be static const.

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
> +	int ret;
> +
> +	/*
> +	 * Register metadata device nodes only if the METADATA_NODE quirk is
> +	 * set.
> +	 */
> +	if (!(dev->quirks & UVC_DEV_FLAG_METADATA_NODE))
> +		return 0;
> +
> +	/* COMMENT: consider re-using the code from
> uvc_driver.c::uvc_register_video() */

Who is that comment for ? :-)

Could https://www.mail-archive.com/linux-media@vger.kernel.org/msg122737.html 
help ?

> +	vdev->v4l2_dev = &dev->vdev;
> +	vdev->fops = &uvc_meta_fops;
> +	vdev->ioctl_ops = &uvc_meta_ioctl_ops;
> +	vdev->release = stream->vdev.release;
> +	vdev->prio = &stream->chain->prio;
> +	vdev->vfl_dir = VFL_DIR_RX;
> +	vdev->queue = &quvc->queue;

uvc_register_video() doesn't set vdev->queue, because the driver handles 
locking manually. While thus could possibly be reworked, careful consideration 
is needed, so I would probably keep queue unset in uvc_register_video_device() 
and set it here.

> +	vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
> +	strlcpy(vdev->name, dev->name, sizeof(vdev->name));
> +
> +	video_set_drvdata(vdev, stream);
> +
> +	/* Initialize the video buffer queue. */
> +	ret = uvc_queue_init(quvc, V4L2_BUF_TYPE_META_CAPTURE, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0)
> +		uvc_printk(KERN_ERR,
> +			   "Failed to register metadata device (%d).\n", ret);
> +	else
> +		kref_get(&dev->ref);
> +
> +	stream->cur_meta_format = V4L2_META_FMT_UVC;

You should set this before registering the video device, otherwise you risk a 
race with userspace.

> +
> +	return ret;
> +}

With the uvc_register_video_device() helper this function would become

int uvc_meta_register(struct uvc_streaming *stream)
{
	struct uvc_device *dev = stream->dev;
	struct video_device *vdev = &stream->meta.vdev;
	struct uvc_video_queue *queue = &stream->meta.queue;

	/*
	 * Register metadata device nodes only if the METADATA_NODE quirk is
	 * set.
	 */
	if (!(dev->quirks & UVC_DEV_FLAG_METADATA_NODE))
		return 0;

	stream->cur_meta_format = V4L2_META_FMT_UVC;

	/*
	 * The video interface queue uses manual locking and thus does not set
	 * the queue pointer. Set it manually here.
	 */
	vdev->queue = &queue->queue;

	return uvc_register_video_device(dev, stream, vdev, queue,
					 V4L2_BUF_TYPE_META_CAPTURE,
					 &uvc_meta_fops, &uvc_meta_ioctl_ops);
}

What do you think, is it worth it ?

> diff --git a/drivers/media/usb/uvc/uvc_queue.c
> b/drivers/media/usb/uvc/uvc_queue.c index c8d78b2..b2998f5 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c

[snip]

> @@ -198,20 +209,36 @@ static void uvc_stop_streaming(struct vb2_queue *vq)
>  	.stop_streaming = uvc_stop_streaming,
>  };
> 
> +static struct vb2_ops uvc_meta_queue_qops = {

This should be static const.

> +	.queue_setup = uvc_queue_setup,
> +	.buf_prepare = uvc_buffer_prepare,
> +	.buf_queue = uvc_buffer_queue,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +	.stop_streaming = uvc_stop_streaming,
> +};
> +
>  int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
>  		    int drop_corrupted)
>  {
>  	int ret;
> 
>  	queue->queue.type = type;
> -	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR;
>  	queue->queue.drv_priv = queue;
>  	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
> -	queue->queue.ops = &uvc_queue_qops;
>  	queue->queue.mem_ops = &vb2_vmalloc_memops;
>  	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
>  		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
>  	queue->queue.lock = &queue->mutex;
> +	switch (type) {
> +	case V4L2_BUF_TYPE_META_CAPTURE:
> +		queue->queue.ops = &uvc_meta_queue_qops;
> +		break;
> +	default:
> +		queue->queue.io_modes |= VB2_DMABUF;
> +		queue->queue.ops = &uvc_queue_qops;

Could you please add a break here ?

> +	}

And I think a blank line here and before the switch would improve readability.

>  	ret = vb2_queue_init(&queue->queue);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index fb86d6a..034b79b 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1135,6 +1135,76 @@ static int uvc_video_encode_data(struct uvc_streaming
> *stream, }
> 
>  /* ------------------------------------------------------------------------
> + * Metadata
> + */
> +
> +/*
> + * Ideally we want to capture all payload headers for each frame. However
> their
> + * number is unknown and unlimited. Additionally to the payload headers we
> want
> + * to provide the user with USB Frame Numbers and system time values. We
> also
> + * choose to drop headers, containing only a standard header, which either
> + * contains no SCR value or a value, equal to the previous payload. The
> + * resulting buffer is composed of blocks, containing a 64-bit timestamp in
> + * nanoseconds, a 16-bit USB Frame Number, and a copy of the payload
> header.

To underline the rationale behind the decision to drop some headers, I would 
phrase this as

/*
 * Additionally to the payload headers we also want to provide the user with
 * USB Frame Numbers and system time values. The resulting buffer is thus
 * composed of blocks, containing a 64-bit timestamp in  nanoseconds, a 16-bit
 * USB Frame Number, and a copy of the payload header.
 *
 * Ideally we want to capture all payload headers for each frame. However,
 * their number is unknown and unbound. We thus drop headers that contain no
 * vendor data and that either contain no SCR value or an SCR value identical
 * to the previous header.
 */

> + */
> +static void uvc_video_decode_meta(struct uvc_streaming *stream,
> +			struct uvc_buffer *buf, struct uvc_buffer *meta_buf,
> +			u8 *mem, unsigned int length)

The buf parameter is unused, you can remove it. mem isn't modified, I would 
make it const.

> +{
> +	struct uvc_meta_buf *meta;
> +	size_t len_std = 2;
> +	bool has_pts, has_scr;
> +	unsigned long flags;
> +	struct timespec ts;
> +	u8 *scr;

And scr should be const too.

> +
> +	if (!meta_buf || length == 2 ||
> +	    meta_buf->length - meta_buf->bytesused <
> +	    length + sizeof(meta->ns) + sizeof(meta->sof))
> +		return;

If the metadata buffer overflows should we also set the error bit like we do 
for video buffers ? I have mixed feelings about this, I'd appreciate your 
input.

> +	has_pts = mem[1] & UVC_STREAM_PTS;
> +	has_scr = mem[1] & UVC_STREAM_SCR;
> +
> +	if (has_pts) {
> +		len_std += 4;
> +		scr = mem + 6;
> +	} else {
> +		scr = mem + 2;
> +	}
> +
> +	if (has_scr)
> +		len_std += 6;
> +
> +	if (stream->cur_meta_format == V4L2_META_FMT_UVC)
> +		length = len_std;
> +
> +	if (length == len_std && (!has_scr ||
> +				  !memcmp(scr, stream->clock.last_scr, 6)))
> +		return;
> +
> +	meta = (struct uvc_meta_buf *)((u8 *)meta_buf->mem + meta_buf->bytesused);
> +	local_irq_save(flags);
> +	uvc_video_get_ts(&ts);

FYI, Arnd has posted https://patchwork.kernel.org/patch/10076887/. If the 
patch gets merged first I can help with the rebasing.

> +	meta->sof = usb_get_current_frame_number(stream->dev->udev);
> +	local_irq_restore(flags);
> +	meta->ns = timespec_to_ns(&ts);

The meta pointer can be unaligned as the structure is packed and its size 
isn't a multiple of the size of the largest field (and it can contain an 
unspecified amount of vendor data anyway). You thus can't access it directly 
on all architectures, you will need to use the put_unaligned macro. As I 
haven't checked whether all architectures can handle unaligned accesses 
without generating a trap, I would store the USB frame number in a local 
variable and use the put_unaligned macro output of the IRQ disabled section 
(feel free to show me that I'm unnecessarily cautious :-)).

> +	if (has_scr)
> +		memcpy(stream->clock.last_scr, scr, 6);
> +
> +	memcpy(&meta->length, mem, length);
> +	meta_buf->bytesused += length + sizeof(meta->ns) + sizeof(meta->sof);
> +
> +	uvc_trace(UVC_TRACE_FRAME,
> +		  "%s(): t-sys %lu.%09lus, SOF %u, len %u, flags 0x%x, PTS %u, STC %u
> frame SOF %u\n",
> +		  __func__, ts.tv_sec, ts.tv_nsec, meta->sof,
> +		  meta->length, meta->flags, has_pts ? *(u32 *)meta->buf : 0,
> +		  has_scr ? *(u32 *)scr : 0,
> +		  has_scr ? *(u32 *)(scr + 4) & 0x7ff : 0);
> +}
> +
> +/* ------------------------------------------------------------------------
>   * URB handling
>   */
> 
> @@ -1152,8 +1222,28 @@ static void uvc_video_validate_buffer(const struct
> uvc_streaming *stream,
>  /*
>   * Completion handler for video URBs.
>   */
> +
> +static struct uvc_buffer *uvc_video_step_buffers(struct uvc_streaming
> *stream,
> +		struct uvc_buffer *video_buf, struct uvc_buffer **meta_buf)

I find the name uvc_video_step_buffers() a bit confusing and would have gone 
for uvc_video_next_buffers(), but that might just be because I'm not used to 
the new name :-)

I still dislike the fact that the video and metadata buffers are handled 
differently :-/ Do you really think it would be a bad idea to pass both as 
struct uvc_buffer ** ?

> +{
> +	if (*meta_buf) {
> +		struct vb2_v4l2_buffer *vb2_meta = &(*meta_buf)->buf;
> +		const struct vb2_v4l2_buffer *vb2_video = &video_buf->buf;
> +
> +		vb2_meta->sequence = vb2_video->sequence;
> +		vb2_meta->field = vb2_video->field;
> +		vb2_meta->vb2_buf.timestamp = vb2_video->vb2_buf.timestamp;
> +
> +		(*meta_buf)->state = UVC_BUF_STATE_READY;
> +		(*meta_buf)->error = video_buf->error;

If we set the error bit when the metadata buffer overflows (see above) then we 
shouldn't overwrite it unconditionally here.

> +		*meta_buf = uvc_queue_next_buffer(&stream->meta.queue,
> +						  *meta_buf);
> +	}
> +	return uvc_queue_next_buffer(&stream->queue, video_buf);
> +}

[snip]

> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 34c7ee6..a657bc1 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -185,6 +185,7 @@
>  #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
>  #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
>  #define UVC_QUIRK_FORCE_Y8		0x00000800
> +#define UVC_DEV_FLAG_METADATA_NODE	0x80000000
> 
>  /* Format flags */
>  #define UVC_FMT_FLAG_COMPRESSED		0x00000001
> @@ -473,6 +474,13 @@ struct uvc_stats_stream {
>  	unsigned int max_sof;		/* Maximum STC.SOF value */
>  };
> 
> +struct uvc_meta_device {
> +	struct video_device vdev;
> +	struct uvc_video_queue queue;
> +};
> +
> +#define UVC_METATADA_BUF_SIZE 1024
> +
>  struct uvc_streaming {
>  	struct list_head list;
>  	struct uvc_device *dev;
> @@ -504,7 +512,10 @@ struct uvc_streaming {
>  	unsigned int frozen : 1;
>  	struct uvc_video_queue queue;
>  	void (*decode) (struct urb *urb, struct uvc_streaming *video,
> -			struct uvc_buffer *buf);
> +			struct uvc_buffer *buf, struct uvc_buffer *meta_buf);
> +
> +	struct uvc_meta_device meta;
> +	__u32 cur_meta_format;

Nitpicking, as the uvc_meta_device structure isn't really needed as a separate 
structure, I'd write this

	struct {
		struct video_device vdev;
		struct uvc_video_queue queue;
		__u32 format;
	} meta;

> 
>  	/* Context data used by the bulk completion handler. */
>  	struct {

[snip]

> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> b/drivers/media/v4l2-core/v4l2-ioctl.c index 7961499..fba8021 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1246,6 +1246,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
> case V4L2_TCH_FMT_TU08:		descr = "8-bit unsigned touch data"; break; 
case
> V4L2_META_FMT_VSP1_HGO:	descr = "R-Car VSP1 1-D Histogram"; break; case
> V4L2_META_FMT_VSP1_HGT:	descr = "R-Car VSP1 2-D Histogram"; break; +	case
> V4L2_META_FMT_UVC:		descr = "UVC payload header metadata"; break;
> 
>  	default:
>  		/* Compressed formats */

I think this belongs to patch 1/3. I'll move it there.

[snip]

For your convenience I've rebased your patch series on top of the two patches 
I mentioned and added another patch on top that contains fixes for all the 
small issues mentioned above. The result is available at

	git://linuxtv.org/pinchartl/media.git uvc/metadata

There are just a handful of issues or questions I haven't addressed, if we 
handle them I think we'll be good to go.

-- 
Regards,

Laurent Pinchart
