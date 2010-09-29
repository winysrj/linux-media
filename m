Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41019 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0I2Xky (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 19:40:54 -0400
Received: by wyb28 with SMTP id 28so1326853wyb.19
        for <linux-media@vger.kernel.org>; Wed, 29 Sep 2010 16:40:52 -0700 (PDT)
Message-ID: <4CA3CE7C.4040100@osciak.com>
Date: Wed, 29 Sep 2010 16:40:44 -0700
From: Pawel Osciak <pawel@osciak.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Subject: Re: [PATCH v1 1/7] v4l: add videobuf2 Video for Linux 2 driver framework
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com> <1284023988-23351-2-git-send-email-p.osciak@samsung.com> <201009251627.33193.hverkuil@xs4all.nl>
In-Reply-To: <201009251627.33193.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,
Big thanks for the review!

On 09/25/2010 07:27 AM, Hans Verkuil wrote:
 > Hi Pawel,
 >
 > I finally had some time for a code review:
 >
 > On Thursday, September 09, 2010 11:19:42 Pawel Osciak wrote:
 >> Videobuf2 is a Video for Linux 2 API-compatible driver framework for
 >> multimedia devices. It acts as an intermediate layer between userspace
 >> applications and device drivers. It also provides low-level, modular
 >> memory management functions for drivers.
 >>
 >> Videobuf2 eases driver development, reduces drivers' code size and aids in
 >> proper and consistent implementation of V4L2 API in drivers.
 >>
 >> Videobuf2 memory management backend is fully modular. This allows custom
 >> memory management routines for devices and platforms with non-standard
 >> memory management requirements to be plugged in, without changing the
 >> high-level buffer management functions and API.
 >>
 >> The framework provides:
 >> - implementations of streaming I/O V4L2 ioctls and file operations
 >> - high-level video buffer, video queue and state management functions
 >> - video buffer memory allocation and management
 >>
 >> Signed-off-by: Pawel Osciak<p.osciak@samsung.com>
 >> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
 >> ---
 >>   drivers/media/video/Kconfig          |    3 +
 >>   drivers/media/video/Makefile         |    2 +
 >>   drivers/media/video/videobuf2-core.c | 1457 ++++++++++++++++++++++++++++++++++
 >>   include/media/videobuf2-core.h       |  337 ++++++++
 >>   4 files changed, 1799 insertions(+), 0 deletions(-)
 >>   create mode 100644 drivers/media/video/videobuf2-core.c
 >>   create mode 100644 include/media/videobuf2-core.h
 >>
 >
 > <snip>
 >

<snip>

 >> +
 >> +	dprintk(4, "Done processing on buffer %d, state: %d\n",
 >> +			vb->v4l2_buf.index, vb->state);
 >> +
 >> +	/* Add the buffer to the done buffers list */
 >> +	spin_lock_irqsave(&q->done_lock, flags);
 >> +	vb->state = state;
 >> +	list_add_tail(&vb->done_entry,&q->done_list);
 >> +	spin_unlock_irqrestore(&q->done_lock, flags);
 >> +
 >> +	/* Inform any processes that may be waiting for buffers */
 >> +	wake_up_interruptible(&q->done_wq);
 >> +}
 >> +EXPORT_SYMBOL_GPL(vb2_buffer_done);
 >> +
 >> +/**
 >> + * __fill_vb2_buffer() - fill a vb2_buffer with information provided in
 >> + * a v4l2_buffer by the userspace
 >> + */
 >> +static int __fill_vb2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b,
 >> +				struct v4l2_plane *v4l2_planes)
 >> +{
 >> +	unsigned int plane;
 >> +	int ret;
 >> +
 >> +	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 >> +		/*
 >> +		 * Verify that the userspace gave us a valid array for
 >> +		 * plane information.
 >> +		 */
 >> +		ret = __verify_planes_array(vb, b);
 >> +		if (ret)
 >> +			return ret;
 >> +
 >> +		/* Fill in driver-provided information for OUTPUT types */
 >> +		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
 >> +			/*
 >> +			 * Will have to go up to b->length when API starts
 >> +			 * accepting variable number of planes.
 >> +			 */
 >> +			for (plane = 0; plane<  vb->num_planes; ++plane) {
 >> +				v4l2_planes[plane].bytesused =
 >> +					b->m.planes[plane].bytesused;
 >> +				v4l2_planes[plane].data_offset =
 >> +					b->m.planes[plane].data_offset;
 >> +			}
 >> +		}
 >> +
 >> +		if (b->memory == V4L2_MEMORY_USERPTR) {
 >> +			for (plane = 0; plane<  vb->num_planes; ++plane) {
 >> +				v4l2_planes[plane].m.userptr =
 >> +					b->m.planes[plane].m.userptr;
 >> +				v4l2_planes[plane].length =
 >> +					b->m.planes[plane].length;
 >> +			}
 >> +		}
 >> +	} else {
 >> +		/*
 >> +		 * Single-planar buffers do not use planes array,
 >> +		 * so fill in relevant v4l2_buffer struct fields instead.
 >> +		 * In videobuf we use our internal V4l2_planes struct for
 >> +		 * single-planar buffers as well, for simplicity.
 >> +		 */
 >> +		if (V4L2_TYPE_IS_OUTPUT(b->type))
 >> +			v4l2_planes[0].bytesused = b->bytesused;
 >> +
 >> +		if (b->memory == V4L2_MEMORY_USERPTR) {
 >> +			v4l2_planes[0].m.userptr = b->m.userptr;
 >> +			v4l2_planes[0].length = b->length;
 >> +		}
 >> +	}
 >> +
 >> +	vb->v4l2_buf.field = b->field;
 >> +	vb->v4l2_buf.timestamp = b->timestamp;
 >> +
 >> +	return 0;
 >> +}
 >> +
 >> +/**
 >> + * __qbuf_userptr() - handle qbuf of a USERPTR buffer
 >> + */
 >> +static int __qbuf_userptr(struct vb2_buffer *vb, struct v4l2_buffer *b)
 >> +{
 >> +	struct v4l2_plane planes[VIDEO_MAX_PLANES];
 >> +	struct vb2_queue *q = vb->vb2_queue;
 >> +	void *mem_priv = NULL;
 >> +	unsigned int plane;
 >> +	int ret;
 >> +
 >> +	/* Verify and copy relevant information provided by the userspace */
 >> +	ret = __fill_vb2_buffer(vb, b, planes);
 >> +	if (ret)
 >> +		return ret;
 >> +
 >> +	for (plane = 0; plane<  vb->num_planes; ++plane) {
 >> +		/* Skip the plane if already verified */
 >> +		if (vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
 >> +		&&  vb->v4l2_planes[plane].length == planes[plane].length)
 >> +			continue;
 >> +
 >> +		dprintk(3, "qbuf: userspace address for plane %d changed, "
 >> +				"reacquiring memory\n", plane);
 >> +
 >> +		/* Release previously acquired memory if present */
 >> +		if (vb->planes[plane].mem_priv)
 >> +			call_memop(q, plane, put_userptr,
 >> +					vb->planes[plane].mem_priv);
 >> +
 >> +		vb->planes[plane].mem_priv = NULL;
 >> +
 >> +		/* Acquire each plane's memory */
 >> +		if (mem_ops(q, plane)->get_userptr) {
 >> +			mem_priv = mem_ops(q, plane)->get_userptr(
 >> +							planes[plane].m.userptr,
 >> +							planes[plane].length);
 >> +			if (IS_ERR(mem_priv)) {
 >> +				dprintk(1, "qbuf: failed acquiring userspace "
 >> +						"memory for plane %d\n", plane);
 >> +				goto err;
 >> +			}
 >
 > Just to verify my understanding: get_userptr is responsible for locking the
 > pages into memory and to increase a use count on that memory. So if the app
 > would do a QBUF, then free the memory and allocate a new buffer, then the
 > original buffer memory is not released until put_userptr is called, and the
 > pointer of the new buffer that the app allocated will always be different from
 > the original buffer (since it was still in use when the app allocated the new
 > one).
 >

Yes. If an application frees a buffer, the use count is still >0, since the driver
is still holding it. When the application queues the new buffer, userptr code
sees that the pointer has changed, releases the old memory and get()s the new one.

 > I've always wondered if something nasty like this was handled correctly. I never
 > had the time to dive into the mm core, though.
 >
<snip>
 >> +		ret = -EINVAL;
 >> +		goto done;
 >> +	}
 >> +
 >> +	/* Fill buffer information for the userspace */
 >> +	__fill_v4l2_buffer(vb, b);
 >> +	/* Remove from videobuf queue */
 >> +	list_del(&vb->queued_entry);
 >> +
 >> +	dprintk(1, "dqbuf of buffer %d, with state %d\n",
 >> +			vb->v4l2_buf.index, vb->state);
 >> +
 >> +	vb->state = VB2_BUF_STATE_DEQUEUED;
 >> +
 >> +done:
 >> +	mutex_unlock(&q->vb_lock);
 >> +	return ret;
 >> +}
 >> +EXPORT_SYMBOL_GPL(vb2_dqbuf);
 >> +
 >> +/**
 >> + * vb2_streamon - start streaming
 >> + * @q:		videobuf2 queue
 >> + * @type:	type argument passed from userspace to vidioc_streamon handler
 >> + *
 >> + * Should be called from vidioc_streamon handler of a driver.
 >> + * This function:
 >> + * 1) verifies current state
 >> + * 2) starts streaming and passes any previously queued buffers to the driver
 >> + *
 >> + * The return values from this function are intended to be directly returned
 >> + * from vidioc_streamon handler in the driver.
 >> + */
 >> +int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 >> +{
 >> +	struct vb2_buffer *vb;
 >> +	int ret = 0;
 >> +
 >> +	mutex_lock(&q->vb_lock);
 >> +
 >> +	if (type != q->type) {
 >> +		dprintk(1, "streamon: invalid stream type\n");
 >> +		ret = -EINVAL;
 >> +		goto done;
 >> +	}
 >> +
 >> +	if (q->streaming) {
 >> +		dprintk(1, "streamon: already streaming\n");
 >> +		ret = -EBUSY;
 >> +		goto done;
 >> +	}
 >> +
 >> +	/*
 >> +	 * Cannot start streaming on an OUTPUT device if no buffers have
 >> +	 * been queued yet.
 >> +	 */
 >> +	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
 >> +		if (list_empty(&q->queued_list)) {
 >> +			dprintk(1, "streamon: no output buffers queued\n");
 >> +			ret = -EINVAL;
 >> +			goto done;
 >> +		}
 >> +	}
 >> +
 >> +	q->streaming = 1;
 >> +
 >> +	/*
 >> +	 * If any buffers were queued before streamon,
 >> +	 * we can now pass them to driver for processing.
 >> +	 */
 >> +	list_for_each_entry(vb,&q->queued_list, queued_entry)
 >> +		__enqueue_in_driver(vb);
 >> +
 >> +	dprintk(3, "Streamon successful\n");
 >> +done:
 >> +	mutex_unlock(&q->vb_lock);
 >> +	return ret;
 >> +}
 >> +EXPORT_SYMBOL_GPL(vb2_streamon);
 >> +
 >> +/**
 >> + * __vb2_queue_cancel() - cancel and stop (pause) streaming
 >> + *
 >> + * Removes all queued buffers from driver's queue and all buffers queued by
 >> + * userspace from videobuf's queue. Returns to state after reqbufs.
 >> + */
 >> +static void __vb2_queue_cancel(struct vb2_queue *q)
 >> +{
 >> +	unsigned long flags = 0;
 >> +	int i;
 >> +
 >> +	q->streaming = 0;
 >> +
 >> +	/*
 >> +	 * Remove buffers from driver's queue. If a hardware operation
 >> +	 * is currently underway, drv_lock should be claimed and we will
 >> +	 * have to wait for it to finish before taking back buffers.
 >> +	 */
 >> +	spin_lock_irqsave(q->drv_lock, flags);
 >> +	for (i = 0; i<  q->num_buffers; ++i) {
 >> +		if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
 >> +			list_del(&q->bufs[i]->drv_entry);
 >> +		q->bufs[i]->state = VB2_BUF_STATE_DEQUEUED;
 >> +	}
 >> +	spin_unlock_irqrestore(q->drv_lock, flags);
 >
 > I feel that this spinlock is too simplistic. I think we need a new op:
 > stop_streaming() or something like that. The driver will stop any streaming
 > and dequeue any active buffers. And if necessary it has to wait for any DMA
 > in progress to finish first.
 >
 > That will also make it possible to remove the drv_lock altogether and make the
 > driver responsible for proper locking in buf_queue and stop_streaming.
 >

The purpose of drv_lock is basically to properly handle cancelling. So yes, if we
add such an op, it'd become obsolete. Drivers would have to manage that spinlock
themselves. I'm trying to see all the implications, I'll try reimplementing it
to get a better picture.

 > Actually, it might also be an idea to implement a start_streaming op for symmetry.
 >

There is actually another thing to consider here. We had a thorough discussion with
Laurent about this, which I'm afraid I don't recall well enough at the moment though.
When vidioc_streamon in driver is called and buffers were previously queued, videobuf
calls buffer_queue in driver as well, so it can begin processing immediately. The
problem is though that the driver has to actually activate the device somewhere during
that time as well. We have two main scenarios:

driver_vidioc_streamon()
{
         activate_device();
         vb2_streamon();
}

or

driver_vidioc_streamon()
{
        vb2_streamon();
        activate_device();
}

Now in case (1), the buffers will be passed to the driver by vb after the device
is activated. This might not be good, since some devices may require buffers to be
ready before they can be activated. In case (2) on the other hand, streamon will
call the buffer_queue callback which now needs to know whether it has been called
from streamon or from a later qbuf. There are also issues with buffer_queue being
called with a spinlock held. I'm probably missing something right now, but maybe
introducing that start_streaming callback and at the same time getting rid of the
driver spinlock might help, somehow.

 >> +
 >> +	/*
 >> +	 * Remove all buffers from videobuf's list...
 >> +	 */
 >> +	INIT_LIST_HEAD(&q->queued_list);
 >> +	/*
 >> +	 * ...and done list; userspace will not receive any buffers it
 >> +	 * has not already dequeued before initiating cancel.
 >> +	 */
 >> +	INIT_LIST_HEAD(&q->done_list);
 >
 > Is this correct? Shouldn't put_userptr be called for all queued and done buffers?
 >

queue_cancel is used for pausing. Since we do not want to free memory on pause,
I thought that the symmetrical thing to do here in case of userptr is not put()ing
memory when pausing either. Put is called on close (release) or on reqbufs(0).

 >> +	wake_up_interruptible_all(&q->done_wq);
 >> +}
 >> +
 >> +/**
 >> + * vb2_streamoff - stop streaming
 >> + * @q:		videobuf2 queue
 >> + * @type:	type argument passed from userspace to vidioc_streamoff handler
 >> + *
 >> + * Should be called from vidioc_streamoff handler of a driver.
 >> + * This function:
 >> + * 1) verifies current state,
 >> + * 2) stop streaming and dequeues any queued buffers, including those previously
 >> + *    passed to the driver (after waiting for the driver to finish).
 >> + *
 >> + * This call can be used for pausing playback.
 >> + * The return values from this function are intended to be directly returned
 >> + * from vidioc_streamoff handler in the driver
 >> + */
 >> +int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 >> +{
 >> +	int ret = 0;
 >> +
 >> +	mutex_lock(&q->vb_lock);
 >> +
 >> +	if (type != q->type) {
 >> +		dprintk(1, "streamoff: invalid stream type\n");
 >> +		ret = -EINVAL;
 >> +		goto end;
 >> +	}
 >> +
 >> +	if (!q->streaming) {
 >> +		dprintk(1, "streamoff: not streaming\n");
 >> +		ret = -EINVAL;
 >> +		goto end;
 >> +	}
 >> +
 >> +	/*
 >> +	 * Cancel will pause streaming and remove all buffers from the driver
 >> +	 * and videobuf, effectively returning control over them to userspace.
 >> +	 */
 >> +	__vb2_queue_cancel(q);
 >> +
 >> +	dprintk(3, "Streamoff successful\n");
 >> +end:
 >> +	mutex_unlock(&q->vb_lock);
 >> +	return ret;
 >> +}
 >> +EXPORT_SYMBOL_GPL(vb2_streamoff);
 >
 > <snip>
 >
 > Some general remarks:
 >
 > 1) It is probably useful to add a simply inline function like this:
 >
 > static inline bool vb2_is_streaming(struct vb2_queue *q)
 > {
 >         return q->streaming;
 > }
 >

Yes, good point.

 > 2) We need very clear documentation detailing:
 >
 >     - where the struct vb2_queue has to be stored (it should be associated with the
 >       video_device struct or the v4l2_device struct if there is only one queue).

I don't think vb2 needs to be aware with what it is "associated" with. Does/should it
make any difference for vb2?

 >     - when to call vb2_queue_init (before registering the device node, I think).

No constraints on how early it can be called, basically yes.

 >     - when to call vb2_queue_release (after unregistering the device node? Does that
 >       also work well with USB devices after a disconnect? I think it is OK, but I'm
 >       not 100% certain.)

Not sure about how USB devices work in this matter...

 >     - how does it work if multiple file handles are open? If fh A calls REQBUFS, is fh
 >       B allowed to call it again? My feeling is that once a fh calls REQBUFS, the
 >       queue is associated with that fh until REQBUFS with count == 0 is called, or
 >       until the fh is closed. All the other streaming ioctls should be called from
 >       that fh. To implement this reqbufs should be passed a struct file (or a v4l2_fh?).
 >       And for the others we either need this as well or we add a simple inline function
 >       checking this that drivers can call.

Basically, if you call reqbufs multiple times, it will work as expected, i.e. will
free or reallocate memory.

vb2 doesn't have any notion of video devices, file handles, etc. Do you think it should?
It just does whatever driver passes to it, of course making sure everything stays in
a sane state (e.g. you can't allocate memory twice, or free memory when streaming).

I think the state machine in vb2 is complicated enough. If we need more advanced,
file handle-aware state machine, maybe a higher-level module should be introduced for that,
something that would build up on vb2, like mem2mem does?

I think you might be thinking of vb2 as of a more complicated framework that it really is.
I was trying to make it as compact as possible, so that it would provide fundamentals to
later built on if needed: e.g. if we needed a mem2mem-like capability, we'd use mem2mem
that would be adding additional constraints and features built on vb2, if we needed
something else, we'd have a different module for that, also utilizing the basic vb2
framework. What is your opinion on that?

 >
 > 3) Read/write will have its own issues: if the driver supports read/write, then
 >     some internal checks are needed: once reqbufs was called on a fh, read/write
 >     should not be allowed (until REQBUFS(0), that is). The same is true vice versa,
 >     except that once you've started reading or writing the only way to go back to
 >     streaming I/O is by closing the fh first.
 >

Yes, that is basically it, to sum up:
REQBUFS(n) - ... - REQBUFS(0) - read/write allowed
REQBUFS(n) - ... - read/write disallowed
REQBUFS(n) - ... - close - open - read/write allowed
read/write - close - open - REQBUFS(0) - allowed
read/write - REQBUFS(0) - disallowed

 > 4) If poll is called without a preceding reqbufs or read, then it should initiate
 >     streaming and mark the queue as being in read (or write) mode. It's the way poll
 >     is supposed to work for read or write.
 >

Ok.

 > 5) Allowing mixing of read/write and streaming I/O. I am very much opposed to this.
 >     First of all it will cause skipped frames since read will steal from dqbuf (or
 >     vice versa, depending on how you look at it). Once you start to read it will also
 >     be impossible to use REQBUFS(0), and the internal administration will be a nightmare.
 >     Frankly, I don't think there is a way to implement this in a way that makes sense.
 >     We should probably investigate those utilities that are supposed to do this.
 >     I understand that they are xawtv and xdtv.
 >

I know Mauro would like to see this, but I'm not really keen on it either. But I'm thinking
of a different way to do that: introduce two videobuf queues and let driver multiplex among
them, which would basically mean initializing both queues on open, setting up formats on both
at the same time, etc., and passing read calls to one of the queues and streaming calls to
the other. Of course this would result in frame dropping...

-- 
Best regards,
Pawel Osciak
