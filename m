Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:48102 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1764358AbdKRJaI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Nov 2017 04:30:08 -0500
Subject: Re: [RFC v5 07/11] [media] vb2: add in-fence support to QBUF
To: Gustavo Padovan <gustavo@padovan.org>
References: <20171115171057.17340-1-gustavo@padovan.org>
 <20171115171057.17340-8-gustavo@padovan.org>
 <185d8656-dacd-5e94-d93a-979a1acb2f66@xs4all.nl>
 <20171117174021.GK19033@jade>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <960d74f5-d269-b4de-3353-36cb03136911@xs4all.nl>
Date: Sat, 18 Nov 2017 10:30:02 +0100
MIME-Version: 1.0
In-Reply-To: <20171117174021.GK19033@jade>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/11/17 18:40, Gustavo Padovan wrote:
> 2017-11-17 Hans Verkuil <hverkuil@xs4all.nl>:
> 
>> On 15/11/17 18:10, Gustavo Padovan wrote:
>>> From: Gustavo Padovan <gustavo.padovan@collabora.com>
>>>
>>> Receive in-fence from userspace and add support for waiting on them
>>> before queueing the buffer to the driver. Buffers can't be queued to the
>>> driver before its fences signal. And a buffer can't be queue to the driver
>>> out of the order they were queued from userspace. That means that even if
>>> it fence signal it must wait all other buffers, ahead of it in the queue,
>>> to signal first.
>>>
>>> To make that possible we use fence_array to keep that ordering. Basically
>>> we create a fence_array that contains both the current fence and the fence
>>> from the previous buffer (which might be a fence array as well). The base
>>> fence class for the fence_array becomes the new buffer fence, waiting on
>>> that one guarantees that it won't be queued out of order.
>>>
>>> v6:
>>> 	- With fences always keep the order userspace queues the buffers.
>>> 	- Protect in_fence manipulation with a lock (Brian Starkey)
>>> 	- check if fences have the same context before adding a fence array
>>> 	- Fix last_fence ref unbalance in __set_in_fence() (Brian Starkey)
>>> 	- Clean up fence if __set_in_fence() fails (Brian Starkey)
>>> 	- treat -EINVAL from dma_fence_add_callback() (Brian Starkey)
>>>
>>> v5:	- use fence_array to keep buffers ordered in vb2 core when
>>> 	needed (Brian Starkey)
>>> 	- keep backward compat on the reserved2 field (Brian Starkey)
>>> 	- protect fence callback removal with lock (Brian Starkey)
>>>
>>> v4:
>>> 	- Add a comment about dma_fence_add_callback() not returning a
>>> 	error (Hans)
>>> 	- Call dma_fence_put(vb->in_fence) if fence signaled (Hans)
>>> 	- select SYNC_FILE under config VIDEOBUF2_CORE (Hans)
>>> 	- Move dma_fence_is_signaled() check to __enqueue_in_driver() (Hans)
>>> 	- Remove list_for_each_entry() in __vb2_core_qbuf() (Hans)
>>> 	-  Remove if (vb->state != VB2_BUF_STATE_QUEUED) from
>>> 	vb2_start_streaming() (Hans)
>>> 	- set IN_FENCE flags on __fill_v4l2_buffer (Hans)
>>> 	- Queue buffers to the driver as soon as they are ready (Hans)
>>> 	- call fill_user_buffer() after queuing the buffer (Hans)
>>> 	- add err: label to clean up fence
>>> 	- add dma_fence_wait() before calling vb2_start_streaming()
>>>
>>> v3:	- document fence parameter
>>> 	- remove ternary if at vb2_qbuf() return (Mauro)
>>> 	- do not change if conditions behaviour (Mauro)
>>>
>>> v2:
>>> 	- fix vb2_queue_or_prepare_buf() ret check
>>> 	- remove check for VB2_MEMORY_DMABUF only (Javier)
>>> 	- check num of ready buffers to start streaming
>>> 	- when queueing, start from the first ready buffer
>>> 	- handle queue cancel
>>>
>>> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
>>> ---
>>>  drivers/media/v4l2-core/Kconfig          |   1 +
>>>  drivers/media/v4l2-core/videobuf2-core.c | 202 ++++++++++++++++++++++++++++---
>>>  drivers/media/v4l2-core/videobuf2-v4l2.c |  29 ++++-
>>>  include/media/videobuf2-core.h           |  17 ++-
>>>  4 files changed, 231 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
>>> index a35c33686abf..3f988c407c80 100644
>>> --- a/drivers/media/v4l2-core/Kconfig
>>> +++ b/drivers/media/v4l2-core/Kconfig
>>> @@ -83,6 +83,7 @@ config VIDEOBUF_DVB
>>>  # Used by drivers that need Videobuf2 modules
>>>  config VIDEOBUF2_CORE
>>>  	select DMA_SHARED_BUFFER
>>> +	select SYNC_FILE
>>>  	tristate
>>>  
>>>  config VIDEOBUF2_MEMOPS
>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>>> index 60f8b582396a..26de4c80717d 100644
>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>>> @@ -23,6 +23,7 @@
>>>  #include <linux/sched.h>
>>>  #include <linux/freezer.h>
>>>  #include <linux/kthread.h>
>>> +#include <linux/dma-fence-array.h>
>>>  
>>>  #include <media/videobuf2-core.h>
>>>  #include <media/v4l2-mc.h>
>>> @@ -346,6 +347,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
>>>  		vb->index = q->num_buffers + buffer;
>>>  		vb->type = q->type;
>>>  		vb->memory = memory;
>>> +		spin_lock_init(&vb->fence_cb_lock);
>>>  		for (plane = 0; plane < num_planes; ++plane) {
>>>  			vb->planes[plane].length = plane_sizes[plane];
>>>  			vb->planes[plane].min_length = plane_sizes[plane];
>>> @@ -1222,6 +1224,9 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
>>>  {
>>>  	struct vb2_queue *q = vb->vb2_queue;
>>>  
>>> +	if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
>>> +		return;
>>> +
>>>  	vb->state = VB2_BUF_STATE_ACTIVE;
>>>  	atomic_inc(&q->owned_by_drv_count);
>>>  
>>> @@ -1273,6 +1278,23 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
>>>  	return 0;
>>>  }
>>>  
>>> +static int __get_num_ready_buffers(struct vb2_queue *q)
>>> +{
>>> +	struct vb2_buffer *vb;
>>> +	int ready_count = 0;
>>> +	unsigned long flags;
>>> +
>>> +	/* count num of buffers ready in front of the queued_list */
>>> +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
>>> +		spin_lock_irqsave(&vb->fence_cb_lock, flags);
>>> +		if (!vb->in_fence || dma_fence_is_signaled(vb->in_fence))
>>> +			ready_count++;
>>
>> Shouldn't there be a:
>>
>> 		else
>> 			break;
>>
>> here? You're counting the number of available (i.e. no fence or signaled
>> fence) buffers at the start of the queued buffer list.
> 
> Sure.
> 
>>
>>> +		spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
>>> +	}
>>> +
>>> +	return ready_count;
>>> +}
>>> +
>>>  int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
>>>  {
>>>  	struct vb2_buffer *vb;
>>> @@ -1361,9 +1383,87 @@ static int vb2_start_streaming(struct vb2_queue *q)
>>>  	return ret;
>>>  }
>>>  
>>> -int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>>> +static struct dma_fence *__set_in_fence(struct vb2_queue *q,
>>> +					struct vb2_buffer *vb,
>>> +					struct dma_fence *fence)
>>> +{
>>> +	if (q->last_fence && dma_fence_is_signaled(q->last_fence)) {
>>> +		dma_fence_put(q->last_fence);
>>> +		q->last_fence = NULL;
>>> +	}
>>> +
>>> +	/*
>>> +	 * We always guarantee the ordering of buffers queued from
>>> +	 * userspace to be the same it is queued to the driver. For that
>>> +	 * we create a fence array with the fence from the last queued
>>> +	 * buffer and this one, that way the fence for this buffer can't
>>> +	 * signal before the last one.
>>> +	 */
>>> +	if (fence && q->last_fence) {
>>> +		struct dma_fence **fences;
>>> +		struct dma_fence_array *arr;
>>> +
>>> +		if (fence->context == q->last_fence->context) {
>>> +			if (fence->seqno - q->last_fence->seqno <= INT_MAX) {
>>> +				dma_fence_put(q->last_fence);
>>> +				q->last_fence = dma_fence_get(fence);
>>> +			} else {
>>> +				dma_fence_put(fence);
>>> +				fence = dma_fence_get(q->last_fence);
>>> +			}
>>> +			return fence;
>>> +		}
>>> +
>>> +		fences = kcalloc(2, sizeof(*fences), GFP_KERNEL);
>>> +		if (!fences)
>>> +			return ERR_PTR(-ENOMEM);
>>> +
>>> +		fences[0] = fence;
>>> +		fences[1] = q->last_fence;
>>> +
>>> +		arr = dma_fence_array_create(2, fences,
>>> +					     dma_fence_context_alloc(1),
>>> +					     1, false);
>>> +		if (!arr) {
>>> +			kfree(fences);
>>> +			return ERR_PTR(-ENOMEM);
>>> +		}
>>> +
>>> +		fence = &arr->base;
>>> +
>>> +		q->last_fence = dma_fence_get(fence);
>>> +	} else if (!fence && q->last_fence) {
>>> +		fence = dma_fence_get(q->last_fence);
>>> +	}
>>
>> I have absolutely no idea what the purpose is of this code.
>>
>> The application is queuing buffers with in-fences. Why would it matter in what
>> order the in-fences trigger? All vb2 needs is the minimum number of usable
>> (no fence or signaled fence) buffers counted from the start of the queued list
>> (i.e. a contiguous set of buffers with no unsignaled fences in between).
>>
>> When that's reached it can start streaming.
>>
>> When streaming you cannot enqueue buffers to the driver as long as the first
>> buffer in the queued list is still waiting on a signal. Once that arrives the
>> fence callback can enqueue all buffers from the start of the queued list until
>> it reaches the next unsignaled fence.
>>
>> At least, that's the mechanism I have in my head and I think that's what users
>> expect.
>>
>> It looks like you allow for buffers to be queued to the driver out-of-order,
>> but you shouldn't do this.
>>
>> If userspace queues buffers A, B, C and D in that order, then that's also the
>> order they should be queued to the driver. Especially with the upcoming support
>> for the request API keeping the sequence intact is crucial.
> 
> And is exactly what this code is for, it keeps the ordering using fences
> magic. We append the fences of the previous buffer to the new one - that
> is called a fence_array. The fence_array just signal after both fences
> signal. That is enough to make sure it won't signal before any
> previously queued fence.
> 
> Arternatively we can get rid of this code and deal directly with
> ordering instead of relying on fences for that.

That sounds way better. We have the ordering already (i.e. the order in
which buffers are queued to the queued_list) so this code only complicates
matters.

The logic in the fence callback is the same as for the qbuf code:

If not streaming, then check if there are now sufficient buffers ready. If
not, return, if there are then queue them to the driver and start streaming.

If streaming, then queue all available (no fence or the fence signaled) buffers
from the start of the queue_list until you reach a buffer that is still waiting
for a fence.

It's simple and consistent. It might make sense to put this in a function that's
called by both qbuf and the fence callback. It depends on the code if that
makes sense.

Regards,

	Hans
