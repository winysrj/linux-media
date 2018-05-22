Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:56618 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750733AbeEVKCM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 06:02:12 -0400
Subject: Re: [PATCHv3 1/5] videobuf2-core: don't call memop 'finish' when
 queueing
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180522081451.94794-1-hverkuil@xs4all.nl>
 <20180522081451.94794-2-hverkuil@xs4all.nl>
 <20180522093531.bjbsvqknrop2nt5y@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5b5c9770-589d-afbd-6e6f-4f573dd48413@xs4all.nl>
Date: Tue, 22 May 2018 12:02:09 +0200
MIME-Version: 1.0
In-Reply-To: <20180522093531.bjbsvqknrop2nt5y@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/05/18 11:35, Sakari Ailus wrote:
> Hi Hans,
> 
> On Tue, May 22, 2018 at 10:14:47AM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> When a buffer is queued or requeued in vb2_buffer_done, then don't
>> call the finish memop. In this case the buffer is only returned to vb2,
>> not to userspace.
>>
>> Calling 'finish' here will cause an unbalance when the queue is
>> canceled, since the core will call the same memop again.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/common/videobuf2/videobuf2-core.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
>> index d3f7bb33a54d..f32ec7342ef0 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-core.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
>> @@ -916,9 +916,12 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>>  	dprintk(4, "done processing on buffer %d, state: %d\n",
>>  			vb->index, state);
>>  
>> -	/* sync buffers */
>> -	for (plane = 0; plane < vb->num_planes; ++plane)
>> -		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
>> +	if (state != VB2_BUF_STATE_QUEUED &&
>> +	    state != VB2_BUF_STATE_REQUEUEING) {
>> +		/* sync buffers */
>> +		for (plane = 0; plane < vb->num_planes; ++plane)
>> +			call_void_memop(vb, finish, vb->planes[plane].mem_priv);
>> +	}
>>  
>>  	spin_lock_irqsave(&q->done_lock, flags);
>>  	if (state == VB2_BUF_STATE_QUEUED ||
> 
> How long do you think this problem has existed? Would this be worth fixing
> in the stable series as well?
> 
> 
> Could it be related to either of these two:
> 
> commit 03703ed1debf777ea845aa9b50ba2e80a5e7dd3c
> Author: Sakari Ailus <sakari.ailus@linux.intel.com>
> Date:   Fri Feb 2 05:08:59 2018 -0500
> 
>     media: vb2: core: Finish buffers at the end of the stream
>     
>     If buffers were prepared or queued and the buffers were released without
>     starting the queue, the finish mem op (corresponding to the prepare mem
>     op) was never called to the buffers.
>     
>     Before commit a136f59c0a1f there was no need to do this as in such a case
>     the prepare mem op had not been called yet. Address the problem by
>     explicitly calling finish mem op when the queue is stopped if the buffer
>     is in either prepared or queued state.
>     
>     Fixes: a136f59c0a1f ("[media] vb2: Move buffer cache synchronisation to prepare from queue")
>     
>     Cc: stable@vger.kernel.org # for v4.13 and up
>     Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>     Tested-by: Devin Heitmueller <dheitmueller@kernellabs.com>
>     Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> commit a136f59c0a1f1b09eb203951975e3fc5e8d3e722
> Author: Sakari Ailus <sakari.ailus@linux.intel.com>
> Date:   Wed May 31 11:17:26 2017 -0300
> 
>     [media] vb2: Move buffer cache synchronisation to prepare from queue
>     
>     The buffer cache should be synchronised in buffer preparation, not when
>     the buffer is queued to the device. Fix this.
>     
>     Mmap buffers do not need cache synchronisation since they are always
>     coherent.
>     
>     Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>     Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 

I think it is this last commit that introduced this.

It should definitely be applied to 4.16, but probably also to 4.14 (longterm
kernel), although that will first need your "vb2: core: Finish buffers at the
end of the stream" patch.

Regards,

	Hans
