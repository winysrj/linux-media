Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41059 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdG1AWd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 20:22:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4] uvcvideo: add a metadata device node
Date: Fri, 28 Jul 2017 03:22:42 +0300
Message-ID: <1573148.l0ngrOGOl6@avalon>
In-Reply-To: <Pine.LNX.4.64.1707240958280.4948@axis700.grange>
References: <Pine.LNX.4.64.1707071536440.9200@axis700.grange> <3406101.2MuKeu43r1@avalon> <Pine.LNX.4.64.1707240958280.4948@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 25 Jul 2017 15:27:24 Guennadi Liakhovetski wrote:
> On Fri, 21 Jul 2017, Laurent Pinchart wrote:
> > Hi Guennadi,
> > 
> > Thank you for the patch.
> > 
> >> Some UVC video cameras contain metadata in their payload headers. This
> >> patch extracts that data, adding more clock synchronisation information,
> >> on both bulk and isochronous endpoints and makes it available to the
> >> user space on a separate video node, using the V4L2_CAP_META_CAPTURE
> >> capability and the V4L2_BUF_TYPE_META_CAPTURE buffer queue type. Even
> >> though different cameras will have different metadata formats, we use
> >> the same V4L2_META_FMT_UVC pixel format for all of them. Users have to
> >> parse data, based on the specific camera model information.
> > 
> > The issue we still haven't addressed is how to ensure that vendors will
> > document their metadata format :-S
> 
> Uhm, add a black list of offending vendors and drop 60% of their frames?
> ;-)

This was actually a serious question :-)

How about white-listing cameras instead, and enabling extended metadata (after 
the standard header) support only for vendors who have documented their format 
?

Speaking of which, where's the documentation for the camera you're working on 
? :-)

> >> This version of the patch only creates such metadata nodes for cameras,
> >> specifying a UVC_QUIRK_METADATA_NODE quirk flag.
> >> 
> >> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> >> ---
> >> 
> >> v4:
> >> - add support for isochronous cameras. Metadata is now collected from as
> >> many payloads as they fit in the buffer
> >> - add a USB Start Of Frame and a system timestamp to each metadata block
> >> for user-space clock synchronisation
> >> - use a default buffer size of 1024 bytes
> >> 
> >> Thanks to Laurent for patient long discussions and to everybody, who
> >> helped me conduct all the investigation into various past, present and
> >> future UVC cameras :-)
> >> 
> >>  drivers/media/usb/uvc/Makefile       |   2 +-
> >>  drivers/media/usb/uvc/uvc_driver.c   |   4 +
> >>  drivers/media/usb/uvc/uvc_isight.c   |   2 +-
> >>  drivers/media/usb/uvc/uvc_metadata.c | 158 ++++++++++++++++++++++++++++
> >>  drivers/media/usb/uvc/uvc_queue.c    |  68 ++++++++++-----
> >>  drivers/media/usb/uvc/uvc_video.c    | 101 +++++++++++++++++++---
> >>  drivers/media/usb/uvc/uvcvideo.h     |  23 ++++-
> >>  drivers/media/v4l2-core/v4l2-ioctl.c |   1 +
> >>  include/uapi/linux/uvcvideo.h        |  19 +++++
> >>  include/uapi/linux/videodev2.h       |   3 +
> >>  10 files changed, 347 insertions(+), 34 deletions(-)
> >>  create mode 100644 drivers/media/usb/uvc/uvc_metadata.c
> > 
> > [snip]
> > 
> >> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> >> b/drivers/media/usb/uvc/uvc_driver.c
> >> index 70842c5..9f23dcf 100644
> >> --- a/drivers/media/usb/uvc/uvc_driver.c
> >> +++ b/drivers/media/usb/uvc/uvc_driver.c

[snip]

> >> @@ -1941,6 +1942,9 @@ static int uvc_register_video(struct uvc_device
> >> *dev,
> > >  		return ret;
> > >  	}
> > > 
> > > +	/* Register a metadata node. */
> > > +	uvc_meta_register(stream);
> > 
> > This can fail, you should handle errors.
> 
> Yes, this is in a way deliberate. If metadata node registration fails, the
> driver continues without one. Would you prefer to fail and unregister the
> main node in this case?

No, that's fine, but you should then add a comment to explain why the error 
isn't handled.

Please also make sure that no damage can occur at device removal time if the 
metadata node hasn't been registered.

> > >  	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > >  		stream->chain->caps |= V4L2_CAP_VIDEO_CAPTURE;
> > >  	else
> > 
> > [snip]
> > 
> >> diff --git a/drivers/media/usb/uvc/uvc_metadata.c
> >> b/drivers/media/usb/uvc/uvc_metadata.c
> >> new file mode 100644
> >> index 0000000..876badd
> >> --- /dev/null
> >> +++ b/drivers/media/usb/uvc/uvc_metadata.c

[snip]

> >> +/* --------------------------------------------------------------------
> >> + * videobuf2 Queue Operations
> >> + */
> >> +
> >> +static struct vb2_ops uvc_meta_queue_ops = {
> >> +	.queue_setup = uvc_queue_setup,
> >> +	.buf_prepare = uvc_buffer_prepare,
> >> +	.buf_queue = uvc_buffer_queue,
> >> +	.wait_prepare = vb2_ops_wait_prepare,
> >> +	.wait_finish = vb2_ops_wait_finish,
> >> +	.stop_streaming = uvc_stop_streaming,
> > 
> > This looks unbalanced without a start_streaming operation. I know that
> > you've modified the uvc_stop_streaming() function to not stop the video
> > stream for metadata video nodes, but I think the code would be clearer
> > if you implemented a uvc_meta_stop_streaming() function
> > for
> 
> Unfinished sentence?

Sorry, I meant to write for meta data nodes I think :-)

> Adding a uvc_meta_stop_streaming() wouldn't balance the .start_streaming()
> by itself. Do you want a dummy function, returning 0 there? Seems even
> uglier to me...

That doesn't sound better, you're right.

> >> +};

[snip]

> >> +int uvc_meta_register(struct uvc_streaming *stream)
> >> +{
> >> +	struct uvc_device *dev = stream->dev;
> >> +	struct uvc_meta_device *meta = &stream->meta;
> >> +	struct video_device *vdev = &meta->vdev;
> >> +	struct uvc_video_queue *quvc = &meta->queue;
> >> +	struct vb2_queue *queue = &quvc->queue;
> >> +	int ret;
> >> +
> >> +	mutex_init(&quvc->mutex);
> >> +	spin_lock_init(&quvc->irqlock);
> >> +	INIT_LIST_HEAD(&quvc->irqqueue);
> >> +
> >> +	/*
> >> +	 * We register metadata device nodes only if the METADATA_NODE quirk
> >> is
> >> +	 * set and only on interfaces with bulk endpoints. To meaningfully
> >> +	 * support interfaces with isochronous endpoints, we need to collect
> >> +	 * headers from all payloads, comprising a single frame. For that we
> >> +	 * need to know the maximum number of such payloads per frame to be
> >> able
> >> +	 * to calculate the buffer size. Currently this information is
> >> +	 * unavailable. A proposal should be made to the UVC committee to add
> >> +	 * this information to camera descriptors.
> >> +	 */
> >> +	if (!(dev->quirks & UVC_QUIRK_METADATA_NODE) ||
> >> +	    dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT)
> >> +		return 0;
> >> +
> >> +	vdev->v4l2_dev = &dev->vdev;
> >> +	vdev->fops = &uvc_meta_fops;
> >> +	vdev->ioctl_ops = &uvc_meta_ioctl_ops;
> >> +	vdev->release = video_device_release_empty;
> > 
> > Please, no. You'll end up crashing the kernel if an application has the
> > meta devnode open when the device is disconnected. Proper refcounting is
> > needed.
>
> Hm, I just tried
> 
> open("/dev/video1",..);
> sleep();
> /* unplug */
> ioctl();
> close();
> 
> no crash. Why do you think there should be one? Doesn't the
> uvc_disconnect() already take care of everything, including unregistering
> both video devices?

OK, it won't crash every time, but you'll potentially dereference freed 
memory, which can lead to all kind of unpleasant results (including crashes) 
depending on the phase of the moon.

The idea is that you must not free the memory used for the video_device 
structure until all open file handles have been closed. As video_device is 
embedded in uvc_streaming, that's the one we must not free. The driver counts 
the number of registered streams in uvc_device::nstreams and only frees memory 
by calling uvc_delete() when the number reaches 0.

You need to use the same mechanism here. nstreams won't be a good name 
anymore, as there will be two references taken per stream. I propose 
converting uvc_device::nstreams from an atomic_t to a struct kref first (you 
can call the field ref) in a separate patch, and then just taking an 
additional reference when registering the metadata video device (just like in 
uvc_register_video, that's one more line of shared code ;-)), and using 
uvc_release() as the video_device release handler.

> > > +	vdev->prio = &stream->chain->prio;
> > > +	vdev->vfl_dir = VFL_DIR_RX;
> > > +	vdev->queue = queue;
> > > +	vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
> > > +	strlcpy(vdev->name, dev->name, sizeof(vdev->name));
> > > +
> > > +	video_set_drvdata(vdev, stream);
> > > +
> > > +	/* Initialize the video buffer queue. */
> > > +	queue->type = V4L2_BUF_TYPE_META_CAPTURE;
> > > +	queue->io_modes = VB2_MMAP | VB2_USERPTR;
> > > +	queue->drv_priv = quvc;
> > > +	queue->buf_struct_size = sizeof(struct uvc_buffer);
> > > +	queue->ops = &uvc_meta_queue_ops;
> > > +	queue->mem_ops = &vb2_vmalloc_memops;
> > > +	queue->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
> > > +		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
> > > +	queue->lock = &quvc->mutex;
> > > +	ret = vb2_queue_init(queue);
> > > +	if (ret < 0)
> > > +		return ret;
> > 
> > How about calling uvc_queue_init() instead of duplicating the code ? You
> > would just need to extend the function with a parameter for the queue
> > ops. Or, possibly even better, you could move the definition of the queue
> > ops to uvc_queue.c. That way you won't have to expose a bunch of
> > currently static queue functions.
> 
> I tried to isolate all the metadata node related code to a separate file
> to avoid blowing up existing code paths and for easier maintenance, but
> sure, can do.

Don't get me wrong, I'm in favour of isolating the metadata-related code as 
well, but I think that in this case the result will be simpler if we move the 
definition of the queue to uvc_queue.c.

> > Similarly, it looks like you're duplicating code from
> > uvc_register_video(), which I believe could be shared.
> 
> It could, yes, but that would only save about 5 to 10 lines of code, would
> not put a complete vdev initialisation in one place or would have to
> explicitly check for META. This looks less suitable for reuse to me.

I might give it a try on top of your patch then :-)

> >> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> >> +	if (ret < 0)
> >> +		uvc_printk(KERN_ERR, "Failed to register metadata device (%d).
> >> \n", ret);
> > 
> > This line is over 80 characters.
> >
> >> +	return ret;
> >> +}
> >> diff --git a/drivers/media/usb/uvc/uvc_queue.c
> >> b/drivers/media/usb/uvc/uvc_queue.c
> >> index aa21997..77dedbc 100644
> >> --- a/drivers/media/usb/uvc/uvc_queue.c
> >> +++ b/drivers/media/usb/uvc/uvc_queue.c

[snip]

> >> -static int uvc_buffer_prepare(struct vb2_buffer *vb)
> >> +int uvc_buffer_prepare(struct vb2_buffer *vb)
> >>  {
> >>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> >>  	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
> >>  	struct uvc_buffer *buf = uvc_vbuf_to_buffer(vbuf);
> >> 
> >> -	if (vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> >> -	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
> >> -		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds
> >> .\n");
> >> -		return -EINVAL;
> >> -	}
> >> -
> >>  	if (unlikely(queue->flags & UVC_QUEUE_DISCONNECTED))
> >>  		return -ENODEV;
> >> 
> >> +	switch (vb->type) {
> >> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> >> +		if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
> >> +			uvc_trace(UVC_TRACE_CAPTURE,
> >> +				  "[E] Bytes used out of bounds.\n");
> >> +			return -EINVAL;
> >> +		}
> >> +
> >> +		buf->bytesused = vb2_get_plane_payload(vb, 0);
> >> +
> >> +		break;
> >> +	case V4L2_BUF_TYPE_META_CAPTURE:
> >> +		if (vb->num_planes != 1 ||
> >> +		    vb2_plane_size(vb, 0) < UVC_METATADA_BUF_SIZE) {
> > 
> > Can this happen, given that queue_setup rejects buffers that verify those
> > conditions ?
> 
> As far as I can see, e.g. in the USERPTR case the length is directly
> copied from the user-provided struct v4l2_buffer:
> 
> vb2_qbuf()
> vb2_core_qbuf()
> __buf_prepare()
> __prepare_userptr()
> __fill_vb2_buffer()
> 	planes[0].length = b->length;

Right, but __fill_vb2_buffer() calls __verify_length(), which, unless I'm 
mistaken, verifies the length passed by userspace.

> Still, the length check is optional. We could just as well omit it here
> and rely on the respective uvc_video_decode_*() function to limit the
> amount of copied data. But it does look like vb->num_planes cannot be
> wrong, you're right about that one.
> 
> >> +			uvc_trace(UVC_TRACE_CAPTURE,
> >> +				  "[E] Invalid buffer configuration.\n");
> >> +			return -EINVAL;
> >> +		}
> >> +		/* Fall through */
> >> +	default:
> >> +		buf->bytesused = 0;
> >> +	}
> >> +
> >>  	buf->state = UVC_BUF_STATE_QUEUED;
> >>  	buf->error = 0;
> >>  	buf->mem = vb2_plane_vaddr(vb, 0);
> >>  	buf->length = vb2_plane_size(vb, 0);
> >> 
> >> -	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > 
> > Unless I was mistaken in my previous comment, I think you only need to
> > change the condition to vb->type != V4L2_BUF_TYPE_VIDEO_OUTPUT, no other
> > change to the function should be needed.
> 
> Yeah, ok, let's do that.
> 
> >> -		buf->bytesused = 0;
> >> -	else
> >> -		buf->bytesused = vb2_get_plane_payload(vb, 0);
> >> 
> >>  	return 0;
> >>  }

[snip]

> >> diff --git a/drivers/media/usb/uvc/uvc_video.c
> >> b/drivers/media/usb/uvc/uvc_video.c
> >> index fb86d6a..3a54439 100644
> >> --- a/drivers/media/usb/uvc/uvc_video.c
> >> +++ b/drivers/media/usb/uvc/uvc_video.c
> >> @@ -1152,8 +1152,76 @@ static void uvc_video_validate_buffer(const
> >> struct uvc_streaming *stream,
> >>  /*
> >>   * Completion handler for video URBs.
> >>   */
> > 
> > I think this function would be better placed in a new "Metadata" section
> > right before the "URB handling" section.
> > 
> >> +
> >> +static void uvc_video_decode_meta(struct uvc_streaming *stream,
> >> +			struct uvc_buffer *buf, struct uvc_buffer *meta_buf,
> > 
> > You might want to call buf video_buf for clarity.
> > 
> >> +			u8 *mem, unsigned int length)
> >> +{
> >> +	struct uvc_meta_buf *meta;
> >> +	size_t len_std = 2;
> >> +	bool has_pts, has_scr;
> >> +	u8 *scr;
> >> +
> >> +	if (!meta_buf || length == 2 ||
> >> +	    meta_buf->length - meta_buf->bytesused <
> >> +	    length + sizeof(meta->ts) + sizeof(meta->sof) ||
> >> +	    length != mem[0])
> > 
> > I don't think the last condition can occur here, as it should be caught in
> > uvc_video_decode_start() and result in the payload being skipped.
> > 
> >> +		return;
> >> +
> >> +	has_pts = mem[1] & UVC_STREAM_PTS;
> >> +	has_scr = mem[1] & UVC_STREAM_SCR;
> >> +
> >> +	if (has_pts) {
> >> +		len_std += 4;
> >> +		scr = mem + 6;
> >> +	} else {
> >> +		scr = mem + 2;
> >> +	}
> >> +
> >> +	if (has_scr)
> >> +		len_std += 6;
> >> +
> >> +	if (length == len_std && (!has_scr ||
> >> +				  !memcmp(scr, stream->clock.last_scr, 6)))
> >> +		return;
> > 
> > I think a comment would be useful to explain the strategy. I understand it
> > now as we've discussed it recently, but I'm not sure I still will in 6
> > months :-) You could add a comment block at the beginning of the
> > function, similarly to uvc_video_decode_start().
> > 
> >> +
> >> +	meta = (struct uvc_meta_buf *)((u8 *)meta_buf->mem + meta_buf
> >> ->bytesused);
> >> +	uvc_video_get_ts(&meta->ts);
> >> +	meta->sof = usb_get_current_frame_number(stream->dev->udev);
> > 
> > You should disable local interrupts around those two calls to ensure that
> > they will be as close as possible.
> 
> Hmmm, is it a "recommended" practice? But sure, it can indeed help, so, if
> you're ok with it, will do.

If you think of another way to address this issue better than disabling local 
interrupts, I'm fine with that.

> >> +
> >> +	if (!meta_buf->bytesused) {
> >> +		meta_buf->buf.sequence = buf->buf.sequence;
> >> +		meta_buf->buf.field = buf->buf.field;
> >> +		meta_buf->buf.vb2_buf.timestamp = buf->buf.vb2_buf.timestamp;
> > 
> > I wonder whether it wouldn't be clearer to do this in
> > uvc_video_step_buffers(). You wouldn't need to check bytesused then, and
> > the code would be more future-proof in case the driver gets changed to
> > set one of those fields later than uvc_video_decode_start().
> > 
> >> +	}
> >> +
> >> +	if (has_scr)
> >> +		memcpy(stream->clock.last_scr, scr, 6);
> >> +
> >> +	memcpy(&meta->length, mem, length);
> >> +	meta_buf->bytesused += length + sizeof(meta->ts) + sizeof(meta->sof);
> >> +
> >> +	uvc_trace(UVC_TRACE_FRAME,
> >> +		  "%s(): t-sys %lu.%09lus, SOF %u, len %u, flags 0x%x, PTS %u,
> >> STC %u frame SOF %u\n",
> >> +		  __func__, meta->ts.tv_sec, meta->ts.tv_nsec, meta->sof,
> >> +		  meta->length, meta->flags, has_pts ? *(u32 *)meta->buf : 0,
> >> +		  has_scr ? *(u32 *)scr : 0,
> >> +		  has_scr ? *(u32 *)(scr + 4) & 0x7ff : 0);
> >> +}

[snip]

> >> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> >> b/drivers/media/usb/uvc/uvcvideo.h
> >> index 15e415e..d06e2d6 100644
> >> --- a/drivers/media/usb/uvc/uvcvideo.h
> >> +++ b/drivers/media/usb/uvc/uvcvideo.h
> >> @@ -185,6 +185,7 @@
> >>  #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
> >>  #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
> >>  #define UVC_QUIRK_FORCE_Y8		0x00000800
> >> +#define UVC_QUIRK_METADATA_NODE		0x00001000
> > 
> > I notice that you don't set the quirk for any device. What's your plan
> > there, will there be more patches ?
> 
> Yes, if the quirk is your preferred way to go, I can submit (an)
> additional patch(es) with some cameras.

It's more a device flag than a quirk, but that's just a semantic issue. I 
think this flag should only be settable from within the kernel though, not 
through the module's quirks parameter. I won't ask you to rework the quirk 
infrastructure completely though, I'm fine using the quirks field for now.

I propose renaming the flag to UVC_DEV_FLAG_METADATA_NODE, setting its value 
to 0x80000000, and masking the value out of the module's quirks parameter.

> >>  /* Format flags */
> >>  #define UVC_FMT_FLAG_COMPRESSED		0x00000001
> > 
> > [snip]
> > 

[snip]

> >> @@ -684,6 +696,12 @@ extern unsigned long
> >> uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
> >>  		unsigned long pgoff);
> >>  #endif
> >>  extern int uvc_queue_allocated(struct uvc_video_queue *queue);
> >> +extern int uvc_queue_setup(struct vb2_queue *vq,
> >> +			   unsigned int *nbuffers, unsigned int *nplanes,
> >> +			   unsigned int sizes[], struct device *alloc_devs[]);
> >> +extern int uvc_buffer_prepare(struct vb2_buffer *vb);
> >> +extern void uvc_buffer_queue(struct vb2_buffer *vb);
> >> +extern void uvc_stop_streaming(struct vb2_queue *vq);
> > 
> > You can drop the extern keyword, it's not needed.
> 
> I know, but I was following the coding style of this driver ;-)

Using extern here isn't a coding style but a mistake. I'm the one to blame for 
that :-)

> But in fact after moving uvc_meta_queue_qops to uvc_queue.c, these
> declarations aren't needed any more, which is good.

Perfect !

> >>  static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
> >>  {
> >>  	return vb2_is_streaming(&queue->queue);
> > 
> > [snip]
> > 
> >> diff --git a/include/uapi/linux/uvcvideo.h
> >> b/include/uapi/linux/uvcvideo.h
> >> index 3b08186..c503dcc 100644
> >> --- a/include/uapi/linux/uvcvideo.h
> >> +++ b/include/uapi/linux/uvcvideo.h

[snip]

> >> +struct uvc_meta_buf {
> >> +	struct timespec ts;
> > 
> > timespec has a different size on 32-bit and 64-bit architectures, so there
> > could be issues on 32-bit userspace running on a 64-bit kernel.
> > 
> > Additionally, on 32-bit platforms, timespec is not year 2038-safe. I
> > thought that timespec64 was exposed to userspace nowadays, but it doesn't
> > seem to be the case. I'm not sure how to handle this.
> 
> Oh, that isn't good :-/ I'll have to think more about this. If you get any
> more ideas, I'd be glad to hear them too.

As Hans recommended, using a u64 that stores the number of nanoseconds should 
be fine (unless you care about the year 2554 problem).

> >> +	__u16 sof;
> >> +	__u8 length;
> >> +	__u8 flags;
> >> +	__u8 buf[];
> > 
> > I had imagined inserting the ts + sof after the standard header, but this
> > probably makes more sense.
> > 
> >> +};
> >> +
> >> 
> >>  #endif
-- 
Regards,

Laurent Pinchart
