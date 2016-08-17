Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35464
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbcHQVVh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 17:21:37 -0400
Subject: Re: [RFC PATCH 1/2] [media] vb2: defer sync buffers from
 vb2_buffer_done() with a workqueue
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1471458537-16859-1-git-send-email-javier@osg.samsung.com>
 <1471458537-16859-2-git-send-email-javier@osg.samsung.com>
 <20160817195027.GE3182@valkosipuli.retiisi.org.uk>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org
Message-ID: <7900e8f2-8435-c11c-ea0a-083f2d4b2a65@osg.samsung.com>
Date: Wed, 17 Aug 2016 17:21:16 -0400
MIME-Version: 1.0
In-Reply-To: <20160817195027.GE3182@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

Thanks a lot for your feedback.

On 08/17/2016 03:50 PM, Sakari Ailus wrote:
> Hi Javier,
> 
> On Wed, Aug 17, 2016 at 02:28:56PM -0400, Javier Martinez Canillas wrote:
>> The vb2_buffer_done() function can be called from interrupt context but it
>> currently calls the vb2 memory allocator .finish operation to sync buffers
>> and this can take a long time, so it's not suitable to be done there.
>>
>> This patch defers part of the vb2_buffer_done() logic to a worker thread
>> to avoid doing the time consuming operation in interrupt context.
> 
> I agree the interrupt handler is not the best place to perform the work in
> vb2_buffer_done() (including cache flushing), but is a work queue an ideal
> solution?
>

I would also like to know Hans opinions since he suggested deferring the buffer
sync to be done in a worker thread (if I understood his suggestions correctly).
 
> The work queue task is a regular kernel thread not subject to
> sched_setscheduler(2) and alike, which user space programs can and do use to
> change how the scheduler treats these processes. Requiring a work queue to
> be run between the interrupt arriving from the hardware and the user space
> process being able to dequeue the related buffer would hurt use cases where
> strict time limits are crucial.
> 
> Neither I propose making the work queue to have real time priority either,
> albeit I think might still be marginally better.
>
> Additionally, the work queue brings another context switch per dequeued
> buffer. This would also be undesirable on IoT and mobile systems that often
> handle multiple buffer queues simultaneously.
>

Yes, I agree with you that this change might increase the latency.
 
> Performing this task in the context of the process that actually dequeues
> the buffer avoids both of these problem entirely as there are no other
> processes involved.
> 

You already mentioned in the other thread that you prefer to move the buffer
sync to DQBUF. But as I explained there, the reason why I want to move the
dma-buf unmapping out of DQBUF is to allow other drivers that share the same
DMA buffer to access the buffer even when a DQBUF has not been called yet.

This may be possible if vb2 supports implicit dma-buf fences and in this case
user-space doesn't even need to call DQBUF/QBUF, since the fences can be used
to serialize the access to the shared DMA buffer. Instead of using DQBUF/QBUF
as a serialization mechanism like is the case for the current non-fences case.

It would be possible to move the cache flushing to DQBUF and leave the dma-buf
unmap there, and do these operations when the driver calls vb2_buffer_done()
only when implicit fences are used. But it would simplify the vb2-core if this
is consistent between the fences and non-fences cases.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
