Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53650 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2FRWs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 18:48:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh Sharma <bhupesh.sharma@st.com>
Cc: linux-usb@vger.kernel.org, balbi@ti.com,
	linux-media@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use videobuf2 framework
Date: Tue, 19 Jun 2012 00:49:07 +0200
Message-ID: <2099637.B2epIePqJp@avalon>
In-Reply-To: <243660e539dcccd868c641188faef26d83c2b894.1338543124.git.bhupesh.sharma@st.com>
References: <cover.1338543124.git.bhupesh.sharma@st.com> <243660e539dcccd868c641188faef26d83c2b894.1338543124.git.bhupesh.sharma@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhupesh,

Thanks for the patch. It looks quite good, please see below for various small 
comments.

On Friday 01 June 2012 15:08:57 Bhupesh Sharma wrote:
> This patch reworks the videobuffer management logic present in the UVC
> webcam gadget and ports it to use the "more apt" videobuf2 framework for
> video buffer management.
> 
> To support routing video data captured from a real V4L2 video capture
> device with a "zero copy" operation on videobuffers (as they pass from the
> V4L2 domain to UVC domain via a user-space application), we need to support
> USER_PTR IO method at the UVC gadget side.
> 
> So the V4L2 capture device driver can still continue to use MMAO IO method

s/MMAO/MMAP/

> and now the user-space application can just pass a pointer to the video
> buffers being DeQueued from the V4L2 device side while Queueing them at the

I don't think dequeued and queueing need capitals :-)

> UVC gadget end. This ensures that we have a "zero-copy" design as the
> videobuffers pass from the V4L2 capture device to the UVC gadget.
> 
> Note that there will still be a need to apply UVC specific payload headers
> on top of each UVC payload data, which will still require a copy operation
> to be performed in the 'encode' routines of the UVC gadget.
> 
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> ---
>  drivers/usb/gadget/Kconfig     |    1 +
>  drivers/usb/gadget/uvc_queue.c |  524 ++++++++++---------------------------
>  drivers/usb/gadget/uvc_queue.h |   25 +--
>  drivers/usb/gadget/uvc_v4l2.c  |   35 ++--
>  drivers/usb/gadget/uvc_video.c |   17 +-
>  5 files changed, 184 insertions(+), 418 deletions(-)

[snip]

> diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
> index 0cdf89d..907ece8 100644
> --- a/drivers/usb/gadget/uvc_queue.c
> +++ b/drivers/usb/gadget/uvc_queue.c

[snip]

This part is a bit difficult to review, as git tried too hard to create a 
universal diff where your patch really replaces the code. I'll remove the - 
lines to make the comments as readable as possible.

> +/*
> ---------------------------------------------------------------------------
> --
> + * videobuf2 queue operations
>   */
> +
> +static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format
> *fmt,
> +				unsigned int *nbuffers, unsigned int *nplanes,
> +				unsigned int sizes[], void *alloc_ctxs[])
>  {
> +	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
> +	struct uvc_video *video =
> +			container_of(queue, struct uvc_video, queue);

No need for a line split.

> 
> +	if (*nbuffers > UVC_MAX_VIDEO_BUFFERS)
> +		*nbuffers = UVC_MAX_VIDEO_BUFFERS;
> 
> +	*nplanes = 1;
> +
> +	sizes[0] = video->imagesize;
> 
>  	return 0;
>  }
> 
> +static int uvc_buffer_prepare(struct vb2_buffer *vb)
>  {
> +	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
> +	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
> 
> +	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> +			vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {

Please align vb2 with the vb-> on the previous line.

Have you by any chance found some inspiration in 
drivers/media/video/uvc/uvc_queue.c ? :-) It would probably make sense to move 
this check to vb2 core, but that's outside of the scope of this patch.

> +		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds.\n");
> +		return -EINVAL;
> +	}
> 
> +	if (unlikely(queue->flags & UVC_QUEUE_DISCONNECTED))
> +		return -ENODEV;
> 
> +	buf->state = UVC_BUF_STATE_QUEUED;
> +	buf->mem = vb2_plane_vaddr(vb, 0);
> +	buf->length = vb2_plane_size(vb, 0);
> +	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		buf->bytesused = 0;
> +	else
> +		buf->bytesused = vb2_get_plane_payload(vb, 0);

The driver doesn't support the capture type at the moment so this might be a 
bit overkill, but I think it's a good idea to support capture in the queue 
imeplementation. I plan to try and merge the uvcvideo and uvcgadget queue 
implementations at some point.

> 
> +	return 0;
> +}
> 
> +static void uvc_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
> +	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
> +	unsigned long flags;
> 
> +	spin_lock_irqsave(&queue->irqlock, flags);
> 
> +	if (likely(!(queue->flags & UVC_QUEUE_DISCONNECTED))) {
> +		list_add_tail(&buf->queue, &queue->irqqueue);
> +	} else {
> +		/* If the device is disconnected return the buffer to userspace
> +		 * directly. The next QBUF call will fail with -ENODEV.
> +		 */
> +		buf->state = UVC_BUF_STATE_ERROR;
> +		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
>  	}
> 
> +	spin_unlock_irqrestore(&queue->irqlock, flags);
>  }
> 
> +static struct vb2_ops uvc_queue_qops = {
> +	.queue_setup = uvc_queue_setup,
> +	.buf_prepare = uvc_buffer_prepare,
> +	.buf_queue = uvc_buffer_queue,
> +};
> +
> +static
> +void uvc_queue_init(struct uvc_video_queue *queue,
> +				enum v4l2_buf_type type)

This can fit on two lines. Please align enum with struct.

>  {
> +	mutex_init(&queue->mutex);
> +	spin_lock_init(&queue->irqlock);
> +	INIT_LIST_HEAD(&queue->irqqueue);

Please add a blank line here.

> +	queue->queue.type = type;
> +	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR;
> +	queue->queue.drv_priv = queue;
> +	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
> +	queue->queue.ops = &uvc_queue_qops;
> +	queue->queue.mem_ops = &vb2_vmalloc_memops;
> +	vb2_queue_init(&queue->queue);
>  }

[snip]

>  /*
> + * Allocate the video buffers.
>   */
> +static int uvc_alloc_buffers(struct uvc_video_queue *queue,
> +				struct v4l2_requestbuffers *rb)

Please align struct with struct (same for the rest of the file).

>  {
> +	int ret;
> 
> +	/*
> +	 * we can support a max of UVC_MAX_VIDEO_BUFFERS video buffers
> +	 */
> +	if (rb->count > UVC_MAX_VIDEO_BUFFERS)
> +		rb->count = UVC_MAX_VIDEO_BUFFERS;
> 

The check is already present in uvc_queue_setup(), you can remove it here.

>  	mutex_lock(&queue->mutex);
> +	ret = vb2_reqbufs(&queue->queue, rb);
> +	mutex_unlock(&queue->mutex);
> 
> +	return ret ? ret : rb->count;
> +}

[snip]

> @@ -481,10 +250,10 @@ static void uvc_queue_cancel(struct uvc_video_queue
> *queue, int disconnect) spin_lock_irqsave(&queue->irqlock, flags);
>  	while (!list_empty(&queue->irqqueue)) {
>  		buf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
> -				       queue);
> +					queue);

No need to change indentation here.

>  		list_del(&buf->queue);
>  		buf->state = UVC_BUF_STATE_ERROR;
> -		wake_up(&buf->wait);
> +		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
>  	}
>  	/* This must be protected by the irqlock spinlock to avoid race
>  	 * conditions between uvc_queue_buffer and the disconnection event that
> @@ -516,26 +285,28 @@ static void uvc_queue_cancel(struct uvc_video_queue
> *queue, int disconnect) */
>  static int uvc_queue_enable(struct uvc_video_queue *queue, int enable)
>  {
> +	unsigned long flags;
>  	int ret = 0;
> 
>  	mutex_lock(&queue->mutex);
>  	if (enable) {
> +		ret = vb2_streamon(&queue->queue, queue->queue.type);
> +		if (ret < 0)
>  			goto done;
> +
>  		queue->buf_used = 0;
> +		queue->flags |= UVC_QUEUE_STREAMING;

I think UVC_QUEUE_STREAMING isn't used anymore.

>  	} else {
> +		if (uvc_queue_streaming(queue)) {

The uvcvideo driver doesn't have this check. It thus returns -EINVAL if 
VIDIOC_STREAMOFF is called on a stream that is already stopped. I'm not sure 
what the right behaviour is, so let's keep the check here until we figure it 
out.

> +			ret = vb2_streamoff(&queue->queue, queue->queue.type);
> +			if (ret < 0)
> +				goto done;
> +
> +			spin_lock_irqsave(&queue->irqlock, flags);
> +			INIT_LIST_HEAD(&queue->irqqueue);
> +			queue->flags &= ~UVC_QUEUE_STREAMING;
> +			spin_unlock_irqrestore(&queue->irqlock, flags);
> +		}
>  	}
> 
>  done:
> @@ -543,30 +314,29 @@ done:
>  	return ret;
>  }
> 
> -/* called with queue->irqlock held.. */
> +/* called with &queue_irqlock held.. */
>  static struct uvc_buffer *
>  uvc_queue_next_buffer(struct uvc_video_queue *queue, struct uvc_buffer
> *buf) {
>  	struct uvc_buffer *nextbuf;
> 
>  	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
> -	    buf->buf.length != buf->buf.bytesused) {
> +			buf->length != buf->bytesused) {

Please keep the indentation.

>  		buf->state = UVC_BUF_STATE_QUEUED;
> -		buf->buf.bytesused = 0;
> +		vb2_set_plane_payload(&buf->buf, 0, 0);
>  		return buf;
>  	}
> 
>  	list_del(&buf->queue);
>  	if (!list_empty(&queue->irqqueue))
>  		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
> -					   queue);
> +						queue);

Same here.

>  	else
>  		nextbuf = NULL;
> 
> -	buf->buf.sequence = queue->sequence++;
> -	do_gettimeofday(&buf->buf.timestamp);

videobuf2 doesn't fill the sequence number or timestamp fields, so you either 
need to keep this here or move it to the caller.

> +	vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
> +	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
> 
> -	wake_up(&buf->wait);
>  	return nextbuf;
>  }
> 
> @@ -576,7 +346,7 @@ static struct uvc_buffer *uvc_queue_head(struct
> uvc_video_queue *queue)
> 
>  	if (!list_empty(&queue->irqqueue))
>  		buf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
> -				       queue);
> +					queue);

Please keep the indentation.

>  	else
>  		queue->flags |= UVC_QUEUE_PAUSED;
> 

[snip]

> diff --git a/drivers/usb/gadget/uvc_v4l2.c b/drivers/usb/gadget/uvc_v4l2.c
> index f6e083b..9c2b45b 100644
> --- a/drivers/usb/gadget/uvc_v4l2.c
> +++ b/drivers/usb/gadget/uvc_v4l2.c
> @@ -144,20 +144,23 @@ uvc_v4l2_release(struct file *file)
>  	struct uvc_device *uvc = video_get_drvdata(vdev);
>  	struct uvc_file_handle *handle = to_uvc_file_handle(file->private_data);
>  	struct uvc_video *video = handle->device;
> +	int ret;
> 
>  	uvc_function_disconnect(uvc);
> 
> -	uvc_video_enable(video, 0);
> -	mutex_lock(&video->queue.mutex);
> -	if (uvc_free_buffers(&video->queue) < 0)
> -		printk(KERN_ERR "uvc_v4l2_release: Unable to free "
> -				"buffers.\n");
> -	mutex_unlock(&video->queue.mutex);
> +	ret = uvc_video_enable(video, 0);
> +	if (ret < 0) {
> +		printk(KERN_ERR "uvc_v4l2_release: uvc video disable failed\n");
> +		return ret;
> +	}

This shouldn't prevent uvc_v4l2_release() from succeeding. In practive 
uvc_video_enable(0) will never fail, so you can remove the error check.

> +
> +	uvc_free_buffers(&video->queue);
> 
>  	file->private_data = NULL;
>  	v4l2_fh_del(&handle->vfh);
>  	v4l2_fh_exit(&handle->vfh);
>  	kfree(handle);
> +
>  	return 0;
>  }

[snip]

> diff --git a/drivers/usb/gadget/uvc_video.c b/drivers/usb/gadget/uvc_video.c
> index b0e53a8..195bbb6 100644
> --- a/drivers/usb/gadget/uvc_video.c
> +++ b/drivers/usb/gadget/uvc_video.c

[snip]

> @@ -161,6 +161,7 @@ static void
>  uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
>  {
>  	struct uvc_video *video = req->context;
> +	struct uvc_video_queue *queue = &video->queue;
>  	struct uvc_buffer *buf;
>  	unsigned long flags;
>  	int ret;
> @@ -169,13 +170,15 @@ uvc_video_complete(struct usb_ep *ep, struct
> usb_request *req) case 0:
>  		break;
> 
> -	case -ESHUTDOWN:
> +	case -ESHUTDOWN:	/* disconnect from host. */
>  		printk(KERN_INFO "VS request cancelled.\n");
> +		uvc_queue_cancel(queue, 1);
>  		goto requeue;
> 
>  	default:
>  		printk(KERN_INFO "VS request completed with status %d.\n",
>  			req->status);
> +		uvc_queue_cancel(queue, 0);

I wonder why there was no uvc_queue_cancel() here already, it makes me a bit 
suspicious :-) Have you double-checked this ?

>  		goto requeue;
>  	}

-- 
Regards,

Laurent Pinchart

