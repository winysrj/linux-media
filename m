Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:47795 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750926AbdJRVXj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Oct 2017 17:23:39 -0400
Subject: Re: [PATCH] videobuf2-core: add queue_busy/idle queue ops
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacob Chen <jacob-chen@iotwrt.com>
References: <223c0040-0d7f-5a6b-4fa7-9b7f04db1e9f@xs4all.nl>
 <68563113.VIsaoZKvtQ@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b63aaf2f-a73f-eabd-728a-c6f9761b4701@xs4all.nl>
Date: Wed, 18 Oct 2017 23:23:32 +0200
MIME-Version: 1.0
In-Reply-To: <68563113.VIsaoZKvtQ@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/18/2017 11:12 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Friday, 22 September 2017 15:29:22 EEST Hans Verkuil wrote:
>> Some controls (ROTATE) change the buffer layout. This means that they cannot
>> be set when buffers are allocated. This can be achieved by calling
>> v4l2_ctrl_grab(ctrl, true) when the queue becomes busy (i.e. the first
>> buffer is allocated) and v4l2_ctrl_grab(ctrl, false) when the queue becomes
>> idle (i.e. the last buffer is released).
>>
>> However, we do not have such queue ops at the moment. This patch adds a
>> queue_busy and a queue_idle op.
> 
> I wonder if this is the best approach. From a quick look at the patch, and 
> without seeing drivers using it, I'm worried those new callbacks will be prone 
> to race conditions with control operations. I think an in-depth analysis of 
> the issue is needed first, and I'd rather avoid new users of the rotation 
> control until we come up with a good way to handle it.

While the queue_busy/idle ops are new, calling v4l2_ctrl_grab() from vb2_queue ops
is not. Typically they are called from the start/stop_streaming ops and have been
for many years.

So I have no worries about race conditions.

Regards,

	Hans

> 
>> Note that currently queue_busy returns a void, so it assumes that it can't
>> return an error.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>> Jacob, this has only been compile-tested. It's best if you add this patch to
>> your rockchip-rga patch series and test it there.
>> ---
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
>> b/drivers/media/v4l2-core/videobuf2-core.c index 14f83cecfa92..e8ad0e9f78d2
>> 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -665,6 +665,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum
>> vb2_memory memory, }
>>
>>  	if (*count == 0 || q->num_buffers != 0 || q->memory != memory) {
>> +		num_buffers = q->num_buffers;
>>  		/*
>>  		 * We already have buffers allocated, so first check if they
>>  		 * are not in use and can be freed.
>> @@ -686,6 +687,8 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum
>> vb2_memory memory, mutex_unlock(&q->mmap_lock);
>>  		if (ret)
>>  			return ret;
>> +		if (num_buffers)
>> +			call_void_qop(q, queue_idle, q);
>>
>>  		/*
>>  		 * In case of REQBUFS(0) return immediately without calling
>> @@ -752,6 +755,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum
>> vb2_memory memory, */
>>  	}
>>
>> +	call_void_qop(q, queue_busy, q);
>>  	mutex_lock(&q->mmap_lock);
>>  	q->num_buffers = allocated_buffers;
>>
>> @@ -762,6 +766,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum
>> vb2_memory memory, */
>>  		__vb2_queue_free(q, allocated_buffers);
>>  		mutex_unlock(&q->mmap_lock);
>> +		call_void_qop(q, queue_idle, q);
>>  		return ret;
>>  	}
>>  	mutex_unlock(&q->mmap_lock);
>> @@ -842,6 +847,8 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum
>> vb2_memory memory, */
>>  	}
>>
>> +	if (!q->num_buffers)
>> +		call_void_qop(q, queue_busy, q);
>>  	mutex_lock(&q->mmap_lock);
>>  	q->num_buffers += allocated_buffers;
>>
>> @@ -852,6 +859,8 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum
>> vb2_memory memory, */
>>  		__vb2_queue_free(q, allocated_buffers);
>>  		mutex_unlock(&q->mmap_lock);
>> +		if (!q->num_buffers)
>> +			call_void_qop(q, queue_idle, q);
>>  		return -ENOMEM;
>>  	}
>>  	mutex_unlock(&q->mmap_lock);
>> @@ -2011,11 +2020,15 @@ static int __vb2_init_fileio(struct vb2_queue *q,
>> int read); static int __vb2_cleanup_fileio(struct vb2_queue *q);
>>  void vb2_core_queue_release(struct vb2_queue *q)
>>  {
>> +	bool was_busy = vb2_is_busy(q);
>> +
>>  	__vb2_cleanup_fileio(q);
>>  	__vb2_queue_cancel(q);
>>  	mutex_lock(&q->mmap_lock);
>>  	__vb2_queue_free(q, q->num_buffers);
>>  	mutex_unlock(&q->mmap_lock);
>> +	if (was_busy)
>> +		call_void_qop(q, queue_idle, q);
>>  }
>>  EXPORT_SYMBOL_GPL(vb2_core_queue_release);
>>
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>> index cb97c224be73..3aa039fd29ce 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -315,6 +315,10 @@ struct vb2_buffer {
>>   *			\*num_buffers are being allocated additionally to
>>   *			q->num_buffers. If either \*num_planes or the requested
>>   *			sizes are invalid callback must return %-EINVAL.
>> + * @queue_busy:		called when the queue becomes busy (i.e. at least one
>> + *			buffer has been allocated).
>> + * @queue_idle:		called when the last buffer from the queue is released
>> + *			and the queue is no longer marked busy.
>>   * @wait_prepare:	release any locks taken while calling vb2 functions;
>>   *			it is called before an ioctl needs to wait for a new
>>   *			buffer to arrive; required to avoid a deadlock in
>> @@ -380,6 +384,8 @@ struct vb2_ops {
>>  	int (*queue_setup)(struct vb2_queue *q,
>>  			   unsigned int *num_buffers, unsigned int *num_planes,
>>  			   unsigned int sizes[], struct device *alloc_devs[]);
>> +	void (*queue_busy)(struct vb2_queue *q);
>> +	void (*queue_idle)(struct vb2_queue *q);
>>
>>  	void (*wait_prepare)(struct vb2_queue *q);
>>  	void (*wait_finish)(struct vb2_queue *q);
>> @@ -547,6 +553,8 @@ struct vb2_queue {
>>  	 * called. Used to check for unbalanced ops.
>>  	 */
>>  	u32				cnt_queue_setup;
>> +	u32				cnt_queue_busy;
>> +	u32				cnt_queue_idle;
>>  	u32				cnt_wait_prepare;
>>  	u32				cnt_wait_finish;
>>  	u32				cnt_start_streaming;
> 
> 
