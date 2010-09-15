Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44382 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0IOURF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 16:17:05 -0400
Received: by eyb6 with SMTP id 6so357562eyb.19
        for <linux-media@vger.kernel.org>; Wed, 15 Sep 2010 13:17:02 -0700 (PDT)
Message-ID: <4C91299B.70609@osciak.com>
Date: Wed, 15 Sep 2010 22:16:27 +0200
From: Pawel Osciak <pawel@osciak.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Subject: Re: [PATCH v1 1/7] v4l: add videobuf2 Video for Linux 2 driver framework
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com> <1284023988-23351-2-git-send-email-p.osciak@samsung.com> <4C891989.3010302@redhat.com>
In-Reply-To: <4C891989.3010302@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Mauro,

Thank you for the review. Please see my responses inline.
Please also note that my e-mail address has changed.

On 09/09/2010 07:29 PM, Mauro Carvalho Chehab wrote:
> Em 09-09-2010 06:19, Pawel Osciak escreveu:
>> Videobuf2 is a Video for Linux 2 API-compatible driver framework for
>> multimedia devices. It acts as an intermediate layer between userspace
>> applications and device drivers. It also provides low-level, modular
>> memory management functions for drivers.
>>
>> Videobuf2 eases driver development, reduces drivers' code size and
aids in
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
>>   drivers/media/video/videobuf2-core.c | 1457++++++++++++++++++++++++++++++++++
>>   include/media/videobuf2-core.h       |  337 ++++++++
>>   4 files changed, 1799 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/media/video/videobuf2-core.c
>>   create mode 100644 include/media/videobuf2-core.h
>>

(snip)

>> +/**
>> + * __vb2_wait_for_done_vb() - wait for a buffer to become available
>> + * for dequeuing
>> + *
>> + * Will sleep if required for nonblocking == false.
>> + */
>> +static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
>> +{
>> +	int retval = 0;
>> +
>> +checks:
>> +	if (!q->streaming) {
>> +		dprintk(1, "Streaming off, will not wait for buffers\n");
>> +		retval = -EINVAL;
>> +		goto end;
>> +	}
>> +
>> +	/*
>> +	 * Buffers may be added to vb_done_list without holding the vb_lock,
>> +	 * but removal is performed only while holding both vb_lock and the
>> +	 * vb_done_lock spinlock. Thus we can be sure that as long as we hold
>> +	 * vb_lock, the list will remain not empty if this check succeeds.
>> +	 */
>> +	if (list_empty(&q->done_list)) {
>> +		if (nonblocking) {
>> +			dprintk(1, "Nonblocking and no buffers to dequeue, "
>> +					"will not wait\n");
>> +			retval = -EAGAIN;
>> +			goto end;
>> +		}
>> +
>> +		/*
>> +		 * We are streaming and nonblocking, wait for another buffer to
>> +		 * become ready or for streamoff. vb_lock is released to allow
>> +		 * streamoff or qbuf to be called while waiting.
>> +		 */
>> +		mutex_unlock(&q->vb_lock);
>
> There's no mutex_lock before this call inside this function... It doesn't
> seem to be a good idea to call it with a mutex locked, and having aunlock/lock
> inside the fuction. The better would be to call it with mutexunlocked and let it
> lock/unlock where needed.
>

Hm, this might be tricky... I am pretty sure we have to hold the vb_lock for the
duration of dqbuf, so I cannot call it without holding the vb_lock. Would you
prefer to put that whole code into dqbuf? Sorry, I am not sure I understood you
correctly here...

>> +		/*
>> +		 * Although the mutex is released here, we will be reevaluating
>> +		 * both conditions again after reacquiring it.
>> +		 */
>> +		dprintk(3, "Will sleep waiting for buffers\n");
>> +		retval = wait_event_interruptible(q->done_wq,
>> +				!list_empty(&q->done_list) || !q->streaming);
>
> I think you could have a race condition here, as you're checking forlist_empty
> without a lock. The better approach would be to do something like:
>
> static int vb2_is_videobuf_empty(struct vb2_queue *q)
> {
> 	int is_empty;
> 		
> 	mutex_lock(&q->vb_lock);
>
> 	is_empty = list_empty(&q->done_list);
>
> 	mutex_unlock(&q->vb_lock);
>
> 	return is_empty;
> }
>
> static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
> {
> 	...
> 	retval = wait_event_interruptible(q->done_wq,vb2_is_videobuf_empty(q) || !q->streaming);
> 	...
> }
>
> This way, you'll always have the mutex locked when checking for listempty.
>
> Btw, shouldn't it be using, instead a spinlock?
>

There are two locks to be considered here:
- vb_lock - main mutex protecting most of the calls
- done_lock - a spinlock protecting done_list

Both vb_lock and done_lock have to be held to remove items from the
done_list, but only done_lock has to be held to add items to the
done_list.

After we check the done_list and find it non-empty, it will
stay that way as long as we hold vb_lock. It is possible that
new buffers will be added to it during that time, but this is not a
problem, since we will acquire the done_lock spinlock before removing
anything from the list.

I am indeed checking for list_empty without holding vb_lock, but this is
only a preliminary check. After wait_event_interruptible returns 0, I
jump back to checks:, acquire vb_lock and recheck for list_empty while
holding it. If the list is still non-empty by this second check, I
can return from the function still holding the vb_lock (so nothing can
be taken off the done_list in the meantime).

I am not sure if you solution would change things here... Since
vb2_is_videobuf_empty() you proposed releases vb_lock before returning
(and it is of course how it should be), we still have to jump back,
reacquire vb_lock and recheck. We cannot release vb_lock after verifying
that the list is nonempty until we remove the buffer from the done_list,
to make sure it stays nonempty.

Or maybe I am missing something here?

> To avoid needing to have a lock also for q->streaming, the betterwould be to define
> it as atomic_t.
>

Right, this is a good idea.

>> +		mutex_lock(&q->vb_lock);
>> +
>> +		if (retval)
>> +			goto end;
>> +
>> +		goto checks;
>> +	}
>> +
>> +end:
>> +	return retval;
>> +}
>> +
>> +/**
>> + * __vb2_get_done_vb() - get a buffer ready for dequeuing
>> + *
>> + * Will sleep if required for nonblocking == false.
>> + */
>> +static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer**vb,
>> +				int nonblocking)
>> +{
>> +	unsigned long flags;
>> +	int ret = 0;
>> +
>> +	/*
>> +	 * Wait for at least one buffer to become available on the done_list.
>> +	 */
>> +	ret = __vb2_wait_for_done_vb(q, nonblocking);
>> +	if (ret)
>> +		goto end;
>> +
>> +	/*
>> +	 * vb_lock has been held since we last verified that done_list is
>> +	 * not empty, so no need for another list_empty(done_list) check.
>> +	 */
>> +	spin_lock_irqsave(&q->done_lock, flags);
>> +	*vb = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
>> +	list_del(&(*vb)->done_entry);
>> +	spin_unlock_irqrestore(&q->done_lock, flags);
>> +
>> +end:
>> +	return ret;
>> +}
>> +
>> +
>> +/**
>> + * vb2_dqbuf() - Dequeue a buffer to the userspace
>> + * @q:		videobuf2 queue
>> + * @b:		buffer structure passed from userspace to vidioc_dqbuf handler
>> + *		in driver
>> + * @nonblocking: if true, this call will not sleep waiting for abuffer if no
>> + *		 buffers ready for dequeuing are present. Normally the driver
>> + *		 would be passing (file->f_flags&  O_NONBLOCK) here
>> + *
>> + * Should be called from vidioc_dqbuf ioctl handler of a driver.
>> + * This function:
>> + * 1) verifies the passed buffer,
>> + * 2) calls buf_finish callback in the driver (if provided), in which
>> + *    driver can perform any additional operations that may berequired before
>> + *    returning the buffer to userspace, such as cache sync,
>> + * 3) the buffer struct members are filled with relevantinformation for
>> + *    the userspace.
>> + *
>> + * The return values from this function are intended to be directlyreturned
>> + * from vidioc_dqbuf handler in driver.
>> + */
>> +int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, boolnonblocking)
>> +{
>> +	struct vb2_buffer *vb = NULL;
>> +	int ret;
>> +
>> +	mutex_lock(&q->vb_lock);
>> +
>> +	if (b->type != q->type) {
>> +		dprintk(1, "dqbuf: invalid buffer type\n");
>> +		ret = -EINVAL;
>> +		goto done;
>> +	}
>> +
>> +	ret = __vb2_get_done_vb(q,&vb, nonblocking);
>> +	if (ret<  0) {
>> +		dprintk(1, "dqbuf: error getting next done buffer\n");
>> +		goto done;
>> +	}
>> +
>> +	if (q->ops->buf_finish) {
>> +		ret = q->ops->buf_finish(vb);
>> +		if (ret) {
>> +			dprintk(1, "dqbuf: buffer finish failed\n");
>> +			goto done;
>> +		}
>> +	}
>> +
>> +	switch (vb->state) {
>> +	case VB2_BUF_STATE_DONE:
>> +		dprintk(3, "dqbuf: Returning done buffer\n");
>> +		break;
>> +	case VB2_BUF_STATE_ERROR:
>> +		dprintk(3, "dqbuf: Returning done buffer with errors\n");
>> +		break;
>> +	default:
>> +		dprintk(1, "dqbuf: Invalid buffer state\n");
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


-- 
Best regards,
Pawel Osciak
