Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:56218 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932381AbdJ0KBn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 06:01:43 -0400
Date: Fri, 27 Oct 2017 11:01:39 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC v4 16/17] [media] vb2: add out-fence support to QBUF
Message-ID: <20171027100139.GF40170@e107564-lin.cambridge.arm.com>
References: <20171020215012.20646-1-gustavo@padovan.org>
 <20171020215012.20646-17-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20171020215012.20646-17-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo,

On Fri, Oct 20, 2017 at 07:50:11PM -0200, Gustavo Padovan wrote:
>From: Gustavo Padovan <gustavo.padovan@collabora.com>
>
>If V4L2_BUF_FLAG_OUT_FENCE flag is present on the QBUF call we create
>an out_fence and send to userspace on the V4L2_EVENT_OUT_FENCE when
>the buffer is queued to the driver, or right away if the queue is ordered
>both in VB2 and in the driver.
>
>The fence is signaled on buffer_done(), when the job on the buffer is
>finished.
>
>v5:
>	- delay fd_install to DQ_EVENT (Hans)
>	- if queue is fully ordered send OUT_FENCE event right away
>	(Brian)
>	- rename 'q->ordered' to 'q->ordered_in_driver'
>	- merge change to implement OUT_FENCE event here
>
>v4:
>	- return the out_fence_fd in the BUF_QUEUED event(Hans)
>
>v3:	- add WARN_ON_ONCE(q->ordered) on requeueing (Hans)
>	- set the OUT_FENCE flag if there is a fence pending (Hans)
>	- call fd_install() after vb2_core_qbuf() (Hans)
>	- clean up fence if vb2_core_qbuf() fails (Hans)
>	- add list to store sync_file and fence for the next queued buffer
>
>v2: check if the queue is ordered.
>
>Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
>---
> drivers/media/v4l2-core/v4l2-event.c     |  2 ++
> drivers/media/v4l2-core/videobuf2-core.c | 25 +++++++++++++++
> drivers/media/v4l2-core/videobuf2-v4l2.c | 55 ++++++++++++++++++++++++++++++++
> 3 files changed, 82 insertions(+)
>
>diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
>index 6274e3e174e0..275da224ace4 100644
>--- a/drivers/media/v4l2-core/v4l2-event.c
>+++ b/drivers/media/v4l2-core/v4l2-event.c
>@@ -385,6 +385,8 @@ int v4l2_subscribe_event_v4l2(struct v4l2_fh *fh,
> 	switch (sub->type) {
> 	case V4L2_EVENT_CTRL:
> 		return v4l2_ctrl_subscribe_event(fh, sub);
>+	case V4L2_EVENT_OUT_FENCE:
>+		return v4l2_event_subscribe(fh, sub, VIDEO_MAX_FRAME, NULL);
> 	}
> 	return -EINVAL;
> }
>diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>index c7ba67bda5ac..21e2052776c1 100644
>--- a/drivers/media/v4l2-core/videobuf2-core.c
>+++ b/drivers/media/v4l2-core/videobuf2-core.c
>@@ -354,6 +354,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
> 			vb->planes[plane].length = plane_sizes[plane];
> 			vb->planes[plane].min_length = plane_sizes[plane];
> 		}
>+		vb->out_fence_fd = -1;
> 		q->bufs[vb->index] = vb;
>
> 		/* Allocate video buffer memory for the MMAP type */
>@@ -934,10 +935,24 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> 	case VB2_BUF_STATE_QUEUED:
> 		return;
> 	case VB2_BUF_STATE_REQUEUEING:
>+		/*
>+		 * Explicit synchronization requires ordered queues for now,
>+		 * so WARN_ON if we are requeuing on an ordered queue.
>+		 */
>+		if (vb->out_fence)
>+			WARN_ON_ONCE(q->ordered_in_driver);
>+
> 		if (q->start_streaming_called)
> 			__enqueue_in_driver(vb);
> 		return;
> 	default:
>+		if (state == VB2_BUF_STATE_ERROR)
>+			dma_fence_set_error(vb->out_fence, -ENOENT);
>+		dma_fence_signal(vb->out_fence);
>+		dma_fence_put(vb->out_fence);
>+		vb->out_fence = NULL;
>+		vb->out_fence_fd = -1;
>+
> 		/* Inform any processes that may be waiting for buffers */
> 		wake_up(&q->done_wq);
> 		break;
>@@ -1235,6 +1250,9 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
> 	trace_vb2_buf_queue(q, vb);
>
> 	call_void_vb_qop(vb, buf_queue, vb);
>+
>+	if (!(q->is_output || q->ordered_in_vb2))
>+		call_void_bufop(q, send_out_fence, vb);
> }
>
> static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
>@@ -1451,6 +1469,7 @@ static struct dma_fence *__set_in_fence(struct vb2_queue *q,
> 		}
>
> 		q->last_fence = dma_fence_get(fence);
>+		call_void_bufop(q, send_out_fence, vb);
> 	}
>
> 	return fence;
>@@ -1840,6 +1859,11 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
> 	}
>
> 	/*
>+	 * Renew out-fence context.
>+	 */

Why is that? I don't think I understand the nuances of fence contexts.

>+	q->out_fence_context = dma_fence_context_alloc(1);
>+
>+	/*
> 	 * Remove all buffers from videobuf's list...
> 	 */
> 	INIT_LIST_HEAD(&q->queued_list);
>@@ -2171,6 +2195,7 @@ int vb2_core_queue_init(struct vb2_queue *q)
> 	spin_lock_init(&q->done_lock);
> 	mutex_init(&q->mmap_lock);
> 	init_waitqueue_head(&q->done_wq);
>+	q->out_fence_context = dma_fence_context_alloc(1);
>
> 	if (q->buf_struct_size == 0)
> 		q->buf_struct_size = sizeof(struct vb2_buffer);
>diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
>index 4c09ea007d90..9fb01ddefdc9 100644
>--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
>+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
>@@ -32,6 +32,11 @@
>
> #include <media/videobuf2-v4l2.h>
>
>+struct out_fence_data {
>+	int fence_fd;
>+	struct file *file;
>+};
>+
> static int debug;
> module_param(debug, int, 0644);
>
>@@ -138,6 +143,38 @@ static void __copy_timestamp(struct vb2_buffer *vb, const void *pb)
> 	}
> };
>
>+static void __fd_install_at_dequeue_cb(void *data)
>+{
>+	struct out_fence_data *of = data;
>+
>+	fd_install(of->fence_fd, of->file);
>+	kfree(of);

Is it possible for the user to never dequeue the event? In that case
the fd and sync_file would leak I guess.

>+}
>+
>+static void __send_out_fence(struct vb2_buffer *vb)
>+{
>+	struct video_device *vdev = to_video_device(vb->vb2_queue->dev);
>+	struct v4l2_fh *fh = vdev->queue->owner;
>+	struct v4l2_event event;
>+	struct out_fence_data *of;
>+
>+	if (vb->out_fence_fd < 0)
>+		return;
>+
>+	memset(&event, 0, sizeof(event));
>+	event.type = V4L2_EVENT_OUT_FENCE;
>+	event.u.out_fence.index = vb->index;
>+	event.u.out_fence.out_fence_fd = vb->out_fence_fd;
>+
>+	of = kmalloc(sizeof(*of), GFP_KERNEL);
>+	of->fence_fd = vb->out_fence_fd;
>+	of->file = vb->sync_file->file;
>+
>+	v4l2_event_queue_fh_with_cb(fh, &event, __fd_install_at_dequeue_cb, of);
>+
>+	vb->sync_file = NULL;

See the comment above about never dequeuing the event - maybe you need
to keep hold of the sync file to be able to clean it up in-case the
user never dequeues. If not, then you could set vb->out_fence_fd = -1
here too.

I've been looking at your v4l2-fences branch on kernel.org, which
looks quite different. Is this the newer version?

Cheers,
-Brian

>+}
>+
> static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
> {
> 	static bool check_once;
>@@ -185,6 +222,12 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
> 		return -EINVAL;
> 	}
>
>+	if (!q->ordered_in_driver && (b->flags & V4L2_BUF_FLAG_OUT_FENCE)) {
>+		dprintk(1, "%s: out-fence doesn't work on unordered queues\n",
>+			opname);
>+		return -EINVAL;
>+	}
>+
> 	return __verify_planes_array(q->bufs[b->index], b);
> }
>
>@@ -213,6 +256,8 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
> 	b->reserved = 0;
>
> 	b->fence_fd = -1;
>+	if (vb->out_fence)
>+		b->flags |= V4L2_BUF_FLAG_OUT_FENCE;
> 	if (vb->in_fence)
> 		b->flags |= V4L2_BUF_FLAG_IN_FENCE;
> 	else
>@@ -456,6 +501,7 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
> 	.fill_user_buffer	= __fill_v4l2_buffer,
> 	.fill_vb2_buffer	= __fill_vb2_buffer,
> 	.copy_timestamp		= __copy_timestamp,
>+	.send_out_fence		= __send_out_fence,
> };
>
> /**
>@@ -593,6 +639,15 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> 		}
> 	}
>
>+	if (b->flags & V4L2_BUF_FLAG_OUT_FENCE) {
>+		ret = vb2_setup_out_fence(q, b->index);
>+		if (ret) {
>+			dprintk(1, "failed to set up out-fence\n");
>+			dma_fence_put(fence);
>+			return ret;
>+		}
>+	}
>+
> 	return vb2_core_qbuf(q, b->index, b, fence);
> }
> EXPORT_SYMBOL_GPL(vb2_qbuf);
>-- 
>2.13.6
>
