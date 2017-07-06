Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41727 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751898AbdGFI3n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 04:29:43 -0400
Subject: Re: [PATCH 03/12] [media] vb2: add in-fence support to QBUF
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-4-gustavo@padovan.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <396bc2f8-eea6-82d5-c3b5-b8c2514af853@xs4all.nl>
Date: Thu, 6 Jul 2017 10:29:35 +0200
MIME-Version: 1.0
In-Reply-To: <20170616073915.5027-4-gustavo@padovan.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/17 09:39, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Receive in-fence from userspace and add support for waiting on them
> before queueing the buffer to the driver. Buffers are only queued
> to the driver once they are ready. A buffer is ready when its
> in-fence signals.
> 
> v2:
> 	- fix vb2_queue_or_prepare_buf() ret check
> 	- remove check for VB2_MEMORY_DMABUF only (Javier)
> 	- check num of ready buffers to start streaming
> 	- when queueing, start from the first ready buffer
> 	- handle queue cancel
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/Kconfig                    |  1 +
>  drivers/media/v4l2-core/videobuf2-core.c | 97 +++++++++++++++++++++++++-------
>  drivers/media/v4l2-core/videobuf2-v4l2.c | 15 ++++-
>  include/media/videobuf2-core.h           |  7 ++-
>  4 files changed, 99 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 55d9c2b..3cd1d3d 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -11,6 +11,7 @@ config CEC_NOTIFIER
>  menuconfig MEDIA_SUPPORT
>  	tristate "Multimedia support"
>  	depends on HAS_IOMEM
> +	select SYNC_FILE

Is this the right place for this? Shouldn't this be selected in
'config VIDEOBUF2_CORE'?

Fences are specific to vb2 after all.

>  	help
>  	  If you want to use Webcams, Video grabber devices and/or TV devices
>  	  enable this option and other options below.
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index ea83126..29aa9d4 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1279,6 +1279,22 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
>  	return 0;
>  }
>  
> +static int __get_num_ready_buffers(struct vb2_queue *q)
> +{
> +	struct vb2_buffer *vb;
> +	int ready_count = 0;
> +
> +	/* count num of buffers ready in front of the queued_list */
> +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> +		if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
> +			break;

Obviously the break is wrong as Mauro mentioned.

> +
> +		ready_count++;
> +	}
> +
> +	return ready_count;
> +}
> +
>  int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
>  {
>  	struct vb2_buffer *vb;
> @@ -1324,8 +1340,15 @@ static int vb2_start_streaming(struct vb2_queue *q)
>  	 * If any buffers were queued before streamon,
>  	 * we can now pass them to driver for processing.
>  	 */
> -	list_for_each_entry(vb, &q->queued_list, queued_entry)
> +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> +		if (vb->state != VB2_BUF_STATE_QUEUED)
> +			continue;

I think this test is unnecessary.

> +
> +		if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
> +			break;
> +
>  		__enqueue_in_driver(vb);

I would move the above test (after fixing it as Mauro said) to __enqueue_in_driver.
I.e. if this is waiting for a fence then __enqueue_in_driver does nothing.

> +	}
>  
>  	/* Tell the driver to start streaming */
>  	q->start_streaming_called = 1;
> @@ -1369,33 +1392,55 @@ static int vb2_start_streaming(struct vb2_queue *q)
>  
>  static int __vb2_core_qbuf(struct vb2_buffer *vb, struct vb2_queue *q)
>  {
> +	struct vb2_buffer *b;
>  	int ret;
>  
>  	/*
>  	 * If already streaming, give the buffer to driver for processing.
>  	 * If not, the buffer will be given to driver on next streamon.
>  	 */
> -	if (q->start_streaming_called)
> -		__enqueue_in_driver(vb);
>  
> -	/*
> -	 * If streamon has been called, and we haven't yet called
> -	 * start_streaming() since not enough buffers were queued, and
> -	 * we now have reached the minimum number of queued buffers,
> -	 * then we can finally call start_streaming().
> -	 */
> -	if (q->streaming && !q->start_streaming_called &&
> -	    q->queued_count >= q->min_buffers_needed) {
> -		ret = vb2_start_streaming(q);
> -		if (ret)
> -			return ret;
> +	if (q->start_streaming_called) {
> +		list_for_each_entry(b, &q->queued_list, queued_entry) {
> +			if (b->state != VB2_BUF_STATE_QUEUED)
> +				continue;
> +
> +			if (b->in_fence && !dma_fence_is_signaled(b->in_fence))
> +				break;

Again, if this test is in __enqueue_in_driver, then you can keep the
original code. Why would you need to loop over all buffers anyway?

If a fence is ready then the callback will call this function for that
buffer. Everything works fine AFAICT without looping over buffers here.

> +
> +			__enqueue_in_driver(b);
> +		}
> +	} else {
> +		/*
> +		 * If streamon has been called, and we haven't yet called
> +		 * start_streaming() since not enough buffers were queued, and
> +		 * we now have reached the minimum number of queued buffers
> +		 * that are ready, then we can finally call start_streaming().
> +		 */
> +		if (q->streaming &&
> +		    __get_num_ready_buffers(q) >= q->min_buffers_needed) {

Just combine this with the 'else' to an 'else if'. Saves an extra level of
indentation.

To follow-up from Mauro's comment: having an 'else if' here is fine.

> +			ret = vb2_start_streaming(q);
> +			if (ret)
> +				return ret;
> +		}
>  	}
>  
>  	dprintk(1, "qbuf of buffer %d succeeded\n", vb->index);
>  	return 0;
>  }
>  
> -int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> +static void vb2_qbuf_fence_cb(struct dma_fence *f, struct dma_fence_cb *cb)
> +{
> +	struct vb2_buffer *vb = container_of(cb, struct vb2_buffer, fence_cb);
> +
> +	dma_fence_put(vb->in_fence);
> +	vb->in_fence = NULL;
> +
> +	__vb2_core_qbuf(vb, vb->vb2_queue);
> +}
> +
> +int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
> +		  struct dma_fence *fence)
>  {
>  	struct vb2_buffer *vb;
>  	int ret;
> @@ -1436,6 +1481,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>  	if (pb)
>  		call_void_bufop(q, fill_user_buffer, vb, pb);
>  
> +	vb->in_fence = fence;
> +	if (fence && !dma_fence_add_callback(fence, &vb->fence_cb,
> +					     vb2_qbuf_fence_cb))
> +		return 0;

Shouldn't this return an error? How would userspace know this failed?

> +
>  	return __vb2_core_qbuf(vb, q);
>  }
>  EXPORT_SYMBOL_GPL(vb2_core_qbuf);
> @@ -1647,6 +1697,7 @@ EXPORT_SYMBOL_GPL(vb2_core_dqbuf);
>  static void __vb2_queue_cancel(struct vb2_queue *q)
>  {
>  	unsigned int i;
> +	struct vb2_buffer *vb;
>  
>  	/*
>  	 * Tell driver to stop all transactions and release all queued
> @@ -1669,6 +1720,14 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  		WARN_ON(atomic_read(&q->owned_by_drv_count));
>  	}
>  
> +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> +		if (vb->in_fence) {
> +			dma_fence_remove_callback(vb->in_fence, &vb->fence_cb);
> +			dma_fence_put(vb->in_fence);
> +			vb->in_fence = NULL;
> +		}
> +	}
> +
>  	q->streaming = 0;
>  	q->start_streaming_called = 0;
>  	q->queued_count = 0;
> @@ -1735,7 +1794,7 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
>  	 * Tell driver to start streaming provided sufficient buffers
>  	 * are available.
>  	 */
> -	if (q->queued_count >= q->min_buffers_needed) {
> +	if (__get_num_ready_buffers(q) >= q->min_buffers_needed) {
>  		ret = v4l_vb2q_enable_media_source(q);
>  		if (ret)
>  			return ret;
> @@ -2250,7 +2309,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>  		 * Queue all buffers.
>  		 */
>  		for (i = 0; i < q->num_buffers; i++) {
> -			ret = vb2_core_qbuf(q, i, NULL);
> +			ret = vb2_core_qbuf(q, i, NULL, NULL);
>  			if (ret)
>  				goto err_reqbufs;
>  			fileio->bufs[i].queued = 1;
> @@ -2429,7 +2488,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>  
>  		if (copy_timestamp)
>  			b->timestamp = ktime_get_ns();
> -		ret = vb2_core_qbuf(q, index, NULL);
> +		ret = vb2_core_qbuf(q, index, NULL, NULL);
>  		dprintk(5, "vb2_dbuf result: %d\n", ret);
>  		if (ret)
>  			return ret;
> @@ -2532,7 +2591,7 @@ static int vb2_thread(void *data)
>  		if (copy_timestamp)
>  			vb->timestamp = ktime_get_ns();;
>  		if (!threadio->stop)
> -			ret = vb2_core_qbuf(q, vb->index, NULL);
> +			ret = vb2_core_qbuf(q, vb->index, NULL, NULL);
>  		call_void_qop(q, wait_prepare, q);
>  		if (ret || threadio->stop)
>  			break;
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 110fb45..e6ad77f 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -23,6 +23,7 @@
>  #include <linux/sched.h>
>  #include <linux/freezer.h>
>  #include <linux/kthread.h>
> +#include <linux/sync_file.h>
>  
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-fh.h>
> @@ -560,6 +561,7 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
>  
>  int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  {
> +	struct dma_fence *fence = NULL;
>  	int ret;
>  
>  	if (vb2_fileio_is_active(q)) {
> @@ -568,7 +570,18 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  	}
>  
>  	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
> -	return ret ? ret : vb2_core_qbuf(q, b->index, b);
> +	if (ret)
> +		return ret;
> +
> +	if (b->flags & V4L2_BUF_FLAG_IN_FENCE) {
> +		fence = sync_file_get_fence(b->fence_fd);
> +		if (!fence) {
> +			dprintk(1, "failed to get in-fence from fd\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return ret ? ret : vb2_core_qbuf(q, b->index, b, fence);
>  }
>  EXPORT_SYMBOL_GPL(vb2_qbuf);
>  
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index cb97c22..aa43e43 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -16,6 +16,7 @@
>  #include <linux/mutex.h>
>  #include <linux/poll.h>
>  #include <linux/dma-buf.h>
> +#include <linux/dma-fence.h>
>  
>  #define VB2_MAX_FRAME	(32)
>  #define VB2_MAX_PLANES	(8)
> @@ -259,6 +260,9 @@ struct vb2_buffer {
>  
>  	struct list_head	queued_entry;
>  	struct list_head	done_entry;
> +
> +	struct dma_fence	*in_fence;
> +	struct dma_fence_cb	fence_cb;
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	/*
>  	 * Counters for how often these buffer-related ops are
> @@ -727,7 +731,8 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
>   * The return values from this function are intended to be directly returned
>   * from vidioc_qbuf handler in driver.
>   */
> -int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
> +int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
> +		  struct dma_fence *fence);
>  
>  /**
>   * vb2_core_dqbuf() - Dequeue a buffer to the userspace
> 

Regards,

	Hans
