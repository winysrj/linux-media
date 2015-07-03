Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46683 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbbGCN3y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2015 09:29:54 -0400
Message-ID: <55968E02.3060102@linux.intel.com>
Date: Fri, 03 Jul 2015 16:28:34 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
CC: mchehab@osg.samsung.com
Subject: Re: [PATCH v2 1/1] vb2: Only requeue buffers immediately once
 streaming is started
References: <1435927676-24559-1-git-send-email-sakari.ailus@linux.intel.com> <55968A26.1010102@xs4all.nl>
In-Reply-To: <55968A26.1010102@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> On 07/03/2015 02:47 PM, Sakari Ailus wrote:
>> Buffers can be returned back to videobuf2 in driver's streamon handler. In
>> this case vb2_buffer_done() with buffer state VB2_BUF_STATE_QUEUED will
>> cause the driver's buf_queue vb2 operation to be called, queueing the same
>> buffer again only to be returned to videobuf2 using vb2_buffer_done() and so
>> on.
>>
>> Add a new buffer state VB2_BUF_STATE_REQUEUEING which, when used as the
>
> It's spelled as requeuing (no e). The verb is 'to queue', but the -ing form is
> queuing. Check the dictionary: http://dictionary.reference.com/browse/queuing

My dictionary disagrees with yours. :-)

http://dictionary.cambridge.org/dictionary/british/queue?q=queueing

>
>> state argument to vb2_buffer_done(), will result in buffers queued to the
>> driver. Using VB2_BUF_STATE_QUEUED will leave the buffer to videobuf2, as it
>> was before "[media] vb2: allow requeuing buffers while streaming".
>>
>> Fixes: ce0eff016f72 ("[media] vb2: allow requeuing buffers while streaming")
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: stable@vger.kernel.org # for v4.1
>> ---
>> since v1:
>>
>> - Instead of relying on q->start_streaming_called and q->streaming, add a
>>    new buffer state VB2_BUF_STATE_REQUEUEING, as suggested by Hans. The
>>    cobalt driver will need the new flag as it returns the buffer back to the
>>    driver's queue, the rest will continue using VB2_BUF_STATE_QUEUED.
>>
>>   drivers/media/pci/cobalt/cobalt-irq.c    |  2 +-
>>   drivers/media/v4l2-core/videobuf2-core.c | 15 +++++++++++----
>>   include/media/videobuf2-core.h           |  2 ++
>>   3 files changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/pci/cobalt/cobalt-irq.c b/drivers/media/pci/cobalt/cobalt-irq.c
>> index e18f49e..2687cb0 100644
>> --- a/drivers/media/pci/cobalt/cobalt-irq.c
>> +++ b/drivers/media/pci/cobalt/cobalt-irq.c
>> @@ -134,7 +134,7 @@ done:
>>   	   also know about dropped frames. */
>>   	cb->vb.v4l2_buf.sequence = s->sequence++;
>>   	vb2_buffer_done(&cb->vb, (skip || s->unstable_frame) ?
>> -			VB2_BUF_STATE_QUEUED : VB2_BUF_STATE_DONE);
>> +			VB2_BUF_STATE_REQUEUEING : VB2_BUF_STATE_DONE);
>>   }
>>
>>   irqreturn_t cobalt_irq_handler(int irq, void *dev_id)
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 1a096a6..ca8c041 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -1182,7 +1182,8 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>>
>>   	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
>>   		    state != VB2_BUF_STATE_ERROR &&
>> -		    state != VB2_BUF_STATE_QUEUED))
>> +		    state != VB2_BUF_STATE_QUEUED &&
>> +		    state != VB2_BUF_STATE_REQUEUEING))
>>   		state = VB2_BUF_STATE_ERROR;
>>
>>   #ifdef CONFIG_VIDEO_ADV_DEBUG
>> @@ -1199,15 +1200,21 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>>   	for (plane = 0; plane < vb->num_planes; ++plane)
>>   		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
>>
>> -	/* Add the buffer to the done buffers list */
>>   	spin_lock_irqsave(&q->done_lock, flags);
>> -	vb->state = state;
>> -	if (state != VB2_BUF_STATE_QUEUED)
>> +	if (state == VB2_BUF_STATE_QUEUED ||
>> +	    state == VB2_BUF_STATE_REQUEUEING) {
>> +		vb->state = VB2_BUF_STATE_QUEUED;
>> +	} else {
>> +		/* Add the buffer to the done buffers list */
>>   		list_add_tail(&vb->done_entry, &q->done_list);
>> +		vb->state = state;
>> +	}
>>   	atomic_dec(&q->owned_by_drv_count);
>>   	spin_unlock_irqrestore(&q->done_lock, flags);
>>
>>   	if (state == VB2_BUF_STATE_QUEUED) {
>> +		return;
>> +	} else if (state == VB2_BUF_STATE_REQUEUEING) {
>
> No 'else' is needed here since the 'if' just returns.

Will fix.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
