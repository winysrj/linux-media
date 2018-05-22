Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:48648 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751196AbeEVQsS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 12:48:18 -0400
Subject: Re: [PATCH v10 12/16] vb2: add in-fence support to QBUF
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: kernel@collabora.com,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com>
 <20180521165946.11778-13-ezequiel@collabora.com>
 <7462919b-ad6f-eb8c-7389-ef0ff6e9d1a2@xs4all.nl>
 <062e8128491e63927f4669ad08c40d29dfbb4141.camel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8848cdb3-73cf-2122-4c50-a57fcd83e151@xs4all.nl>
Date: Tue, 22 May 2018 18:48:15 +0200
MIME-Version: 1.0
In-Reply-To: <062e8128491e63927f4669ad08c40d29dfbb4141.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/05/18 18:22, Ezequiel Garcia wrote:
>>> @@ -1615,7 +1762,12 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
>>>  		return;
>>>  
>>>  	vb->state = VB2_BUF_STATE_DEQUEUED;
>>> -
>>> +	if (vb->in_fence) {
>>> +		if (dma_fence_remove_callback(vb->in_fence, &vb->fence_cb))
>>> +			__vb2_buffer_put(vb);
>>> +		dma_fence_put(vb->in_fence);
>>> +		vb->in_fence = NULL;
>>> +	}
>>>  	/* unmap DMABUF buffer */
>>>  	if (q->memory == VB2_MEMORY_DMABUF)
>>>  		for (i = 0; i < vb->num_planes; ++i) {
>>> @@ -1653,7 +1805,7 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
>>>  	if (pindex)
>>>  		*pindex = vb->index;
>>>  
>>> -	/* Fill buffer information for the userspace */
>>> +	/* Fill buffer information for userspace */
>>>  	if (pb)
>>>  		call_void_bufop(q, fill_user_buffer, vb, pb);
>>>  
>>> @@ -1700,8 +1852,8 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>>>  	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
>>>  		for (i = 0; i < q->num_buffers; ++i)
>>>  			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE) {
>>> -				pr_warn("driver bug: stop_streaming operation is leaving buf %p in active state\n",
>>> -					q->bufs[i]);
>>> +				pr_warn("driver bug: stop_streaming operation is leaving buf[%d] 0x%p in active
>>> state\n",
>>> +					q->bufs[i]->index, q->bufs[i]);
>>>  				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
>>>  			}
>>
>> Shouldn't any pending fences be canceled here?
>>
> 
> No, we don't have to flush -- that's the reason of the refcount :)
> The qbuf_work won't do anything if all the buffers are returned
> by the driver (with error or done state), and if !streaming.
> 
> Also, note that's why qbuf_work checks for the queued state, and not
> for the error state.
> 
>> I feel uncomfortable with the refcounting of buffers, I'd rather that when we
>> cancel the queue all fences for buffers are removed/canceled/whatever.
>>
>> Is there any reason for refcounting if we cancel all pending fences here?
>>
>> Note that besides canceling fences you also need to cancel/flush __qbuf_work.
>>
>>
> 
> Like I said above, I'm trying to avoid cancel/flushing the workqueue.
> Currently, I believe it works fine without any flushing, provided we refcount
> the buffers.
> 
> The problem with cancelling the workqueue, is that you need to unlock the queue
> lock, to avoid a deadlock. It seemed to me that having a refcount is more natural.
> 
> Thoughts?
> 

I'll take another look tomorrow morning. Do you have a public git tree containing
this series that I can browse?

Regards,

	Hans
