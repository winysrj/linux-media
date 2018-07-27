Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:54486 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730771AbeG0QwK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 12:52:10 -0400
Subject: Re: [PATCH v2 1/5] v4l2-mem2mem: Fix missing v4l2_m2m_try_run call
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: kernel@collabora.com, paul.kocialkowski@bootlin.com,
        maxime.ripard@bootlin.com, Hans Verkuil <hans.verkuil@cisco.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
References: <20180725171516.11210-1-ezequiel@collabora.com>
 <20180725171516.11210-2-ezequiel@collabora.com>
 <c0cf528b-103a-9a92-527d-e80508734c72@xs4all.nl>
 <d50d043a-0624-c697-147c-7a7a10d81d4c@xs4all.nl>
 <280a403a8c00eb99c50e98e636ab5d32647411d9.camel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5904862a-fe7a-3121-0670-20d76bec2afb@xs4all.nl>
Date: Fri, 27 Jul 2018 17:29:42 +0200
MIME-Version: 1.0
In-Reply-To: <280a403a8c00eb99c50e98e636ab5d32647411d9.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/07/18 17:16, Ezequiel Garcia wrote:
> On Fri, 2018-07-27 at 15:41 +0200, Hans Verkuil wrote:
>> On 27/07/18 15:35, Hans Verkuil wrote:
>>> On 25/07/18 19:15, Ezequiel Garcia wrote:
>>>> Commit 34dbb848d5e4 ("media: mem2mem: Remove excessive try_run call")
>>>> removed a redundant call to v4l2_m2m_try_run but instead introduced
>>>> a bug. Consider the following case:
>>>>
>>>>  1) Context A schedules, queues and runs job A.
>>>>  2) While the m2m device is running, context B schedules
>>>>     and queues job B. Job B cannot run, because it has to
>>>>     wait for job A.
>>>>  3) Job A completes, calls v4l2_m2m_job_finish, and tries
>>>>     to queue a job for context A, but since the context is
>>>>     empty it won't do anything.
>>>>
>>>> In this scenario, queued job B will never run. Fix this by calling
>>>> v4l2_m2m_try_run from v4l2_m2m_try_schedule.
>>>>
>>>> While here, add more documentation to these functions.
>>>>
>>>> Fixes: 34dbb848d5e4 ("media: mem2mem: Remove excessive try_run call")
>>>> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
>>>
>>> So just to be clear: this first patch fixes a regression and can be applied
>>> separately from the other patches?
>>>
> 
> That is correct, it's a regression and can be applied independently.
> 
> This patch has been tested independently of the rest of the series,
> using the test introduced in "selftests: media_tests: Add a
> memory-to-memory concurrent stress test".
> 
> Without this patch, the test fails.
> 
>>>> ---
>>>>  drivers/media/v4l2-core/v4l2-mem2mem.c | 32 +++++++++++++++++++++++---
>>>>  1 file changed, 29 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
>>>> index 5f9cd5b74cda..dfd796621b06 100644
>>>> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
>>>> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
>>>> @@ -209,15 +209,23 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
>>>>  	m2m_dev->curr_ctx->job_flags |= TRANS_RUNNING;
>>>>  	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
>>>>  
>>>> +	dprintk("Running job on m2m_ctx: %p\n", m2m_dev->curr_ctx);
>>>
>>> Is this intended? It feels out of place in this patch.
>>>
> 
> It was intended :) Since the patch is adding some more documentation,
> it felt OK to add this debug message, as it also helps the testing.
> 
> But I can drop it if you think it's out of place.
> 
>>>>  	m2m_dev->m2m_ops->device_run(m2m_dev->curr_ctx->priv);
>>>>  }
>>>>  
>>>> -void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>>>> +/*
>>>> + * __v4l2_m2m_try_queue() - queue a job
>>>> + * @m2m_dev: m2m device
>>>> + * @m2m_ctx: m2m context
>>>> + *
>>>> + * Check if this context is ready to queue a job.
>>>> + *
>>>> + * This function can run in interrupt context.
>>>> + */
>>>> +static void __v4l2_m2m_try_queue(struct v4l2_m2m_dev *m2m_dev, struct v4l2_m2m_ctx *m2m_ctx)
>>>>  {
>>>> -	struct v4l2_m2m_dev *m2m_dev;
>>>>  	unsigned long flags_job, flags_out, flags_cap;
>>>>  
>>>> -	m2m_dev = m2m_ctx->m2m_dev;
>>>>  	dprintk("Trying to schedule a job for m2m_ctx: %p\n", m2m_ctx);
>>>>  
>>>>  	if (!m2m_ctx->out_q_ctx.q.streaming
>>>> @@ -275,7 +283,25 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>>>>  	m2m_ctx->job_flags |= TRANS_QUEUED;
>>>>  
>>>>  	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
>>>> +}
>>>> +
>>>> +/**
>>>> + * v4l2_m2m_try_schedule() - schedule and possibly run a job for any context
>>>> + * @m2m_ctx: m2m context
>>>> + *
>>>> + * Check if this context is ready to queue a job. If suitable,
>>>> + * run the next queued job on the mem2mem device.
>>>> + *
>>>> + * This function shouldn't run in interrupt context.
>>>> + *
>>>> + * Note that v4l2_m2m_try_schedule() can schedule one job for this context,
>>>> + * and then run another job for another context.
>>>> + */
>>>> +void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>>>> +{
>>>> +	struct v4l2_m2m_dev *m2m_dev = m2m_ctx->m2m_dev;
>>>>  
>>>> +	__v4l2_m2m_try_queue(m2m_dev, m2m_ctx);
>>>
>>> Why introduce __v4l2_m2m_try_queue? Why not keep it in here?
>>>
> 
> Well, specifically we need to make sure xxx_try_run is called
> even if no job was queued. After a lot of back and forth, I ended
> up thinking the queue and run operations were different and needed
> different functions.
> 
> If we were to keep the code in try_schedule, we would have to use
> some extra conditionals or gotos to make sure try_run is called even
> if no job was queued.
> 
> The important thing to keep in mind here is that these functions
> could be called on a given context, but then actually run a job
> for another context.
> 
>>>>  	v4l2_m2m_try_run(m2m_dev);
>>
>> I'm completely confused: v4l2_m2m_try_schedule() already calls v4l2_m2m_try_run()!
>>
>> Either my brain has crashed due to the heatwave I'm suffering through, or there
>> is something amiss with this patch.
>>
>>
> 
> Right, v4l2_m2m_try_schedule calls v4l2_m2m_try_run *if* a job was queued.
> This might not always be the case.
> 
> Consider you schedule two jobs, both will be queued but only one will run.
> When will the second job run? Answer: never :)

Ah, now I get it. I hadn't seen that the 'return' statements in try_schedule
would prevent the try_run call at the end.

Thanks for the patch, I'll make a pull request for this one.

Regards,

	Hans
