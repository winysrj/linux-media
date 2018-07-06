Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38847 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754102AbeGFU2f (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2018 16:28:35 -0400
Received: by mail-wm0-f68.google.com with SMTP id 69-v6so15404075wmf.3
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2018 13:28:34 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] s5p-g2d: Remove unrequired wait in .job_abort
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        kernel@collabora.com,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>
References: <20180618043852.13293-1-ezequiel@collabora.com>
 <20180618043852.13293-3-ezequiel@collabora.com>
 <0c63d9ee-88c4-c09d-ec36-cc0ee3ca3d8f@xs4all.nl>
 <7a4debab-717e-c99b-778f-fc9bdc99775e@kernel.org>
 <d84d6dc29cfb53eaf55e92bbf51dc36b72c7d6b9.camel@collabora.com>
From: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
Message-ID: <6060ee01-a772-735b-0161-1d776ee17eb7@gmail.com>
Date: Fri, 6 Jul 2018 22:28:32 +0200
MIME-Version: 1.0
In-Reply-To: <d84d6dc29cfb53eaf55e92bbf51dc36b72c7d6b9.camel@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/06/2018 03:43 PM, Ezequiel Garcia wrote:

>> Could you elaborate how the core ensures DMA operation is not in
>> progress
>> after VIDIOC_STREAMOFF, VIDIOC_DQBUF with this patch applied?
>>
> 
> Well, .streamoff is handled by v4l2_m2m_streamoff, which
> guarantees that no job is running by calling v4l2_m2m_cancel_job.
> 
> The call chain goes like this:
> 
> vidioc_streamoff
>    v4l2_m2m_ioctl_streamoff
>      v4l2_m2m_streamoff
>        v4l2_m2m_cancel_job
>          wait_event(m2m_ctx->finished, ...);
> 
> The wait_event() wakes up by v4l2_m2m_job_finish(),
> which is called by g2d_isr after marking the buffers
> as done.
> 
> The reason why I haven't elaborated this in the commit log
> is because it's documented in .job_abort declaration.

Indeed, you are right, job_abort implementation can be safely removed
in this case. As it is it doesn't help to handle cases when the HW gets
stuck and refuses to generate an interrupt. The rcar_jpu seems to be
addressing such situation properly though.

>>>> diff --git a/drivers/media/platform/s5p-g2d/g2d.c
>>>> b/drivers/media/platform/s5p-g2d/g2d.c
>>>> index 66aa8cf1d048..e98708883413 100644
>>>> --- a/drivers/media/platform/s5p-g2d/g2d.c
>>>> +++ b/drivers/media/platform/s5p-g2d/g2d.c
>>>> @@ -483,15 +483,6 @@ static int vidioc_s_crop(struct file *file,
>>>> void *prv, const struct v4l2_crop *c
>>>>    
>>>>    static void job_abort(void *prv)
>>>>    {
>>>> -	struct g2d_ctx *ctx = prv;
>>>> -	struct g2d_dev *dev = ctx->dev;
>>>> -
>>>> -	if (dev->curr == NULL) /* No job currently running */
>>>> -		return;
>>>> -
>>>> -	wait_event_timeout(dev->irq_queue,
>>>> -			   dev->curr == NULL,
>>>> -			   msecs_to_jiffies(G2D_TIMEOUT));
>>
>> I think after this patch there will be a potential race condition
>> possible,
>> we could have the hardware DMA and CPU writing to same buffer with
>> sequence like:
>> ...
>> QBUF
>> STREAMON
>> STREAMOFF
>> DQBUF
>> CPU accessing the buffer  <--  at this point G2D DMA could still be
>> writing
>> to an already dequeued buffer. Image processing can take few
>> miliseconds, it should
>> be fairly easy to trigger such a condition.
>>
> 
> I don't think this is the case, as I've explained above. This commit
> merely removes a redundant wait, as job_abort simply waits the
> interrupt handler to complete, and that is the purpose of
> v4l2_m2m_job_finish.
> 
> It only makes sense to implement job_abort if you can actually stop
> the current DMA. If you can only wait for it to complete, then it's not
> needed.

Agreed.

> The intention of this series is simply to make job_abort optional,
> and remove those drivers that implement job_abort as a wait-for-
> current-job.

Sure, thanks for your effort.

--
Regards,
Sylwester
