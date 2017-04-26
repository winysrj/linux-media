Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34296 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753944AbdDZTgP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 15:36:15 -0400
Subject: Re: [PATCH] [media] s5p-jpeg: fix recursive spinlock acquisition
To: Alexandre Courbot <acourbot@chromium.org>
References: <20170425061943.717-1-acourbot@chromium.org>
 <14d0d257-a5c3-222e-137d-4991482c6fb4@gmail.com>
 <CAPBb6MV6YCARzwkvXoxtCFYuZkM1-TzR_BRY6xH1qpzs+vAEuQ@mail.gmail.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <ad2fc73b-0709-f5d3-04c0-658974e2eb21@gmail.com>
Date: Wed, 26 Apr 2017 21:35:30 +0200
MIME-Version: 1.0
In-Reply-To: <CAPBb6MV6YCARzwkvXoxtCFYuZkM1-TzR_BRY6xH1qpzs+vAEuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/26/2017 04:54 AM, Alexandre Courbot wrote:
> On Wed, Apr 26, 2017 at 4:15 AM, Jacek Anaszewski
> <jacek.anaszewski@gmail.com> wrote:
>> Hi Alexandre,
>>
>> Thanks for the patch.
>>
>> On 04/25/2017 08:19 AM, Alexandre Courbot wrote:
>>> v4l2_m2m_job_finish(), which is called from the interrupt handler with
>>> slock acquired, can call the device_run() hook immediately if another
>>> context was in the queue. This hook also acquires slock, resulting in
>>> a deadlock for this scenario.
>>>
>>> Fix this by releasing slock right before calling v4l2_m2m_job_finish().
>>> This is safe to do as the state of the hardware cannot change before
>>> v4l2_m2m_job_finish() is called anyway.
>>>
>>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>>> ---
>>>  drivers/media/platform/s5p-jpeg/jpeg-core.c | 12 +++++++++---
>>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
>>> index 52dc7941db65..223b4379929e 100644
>>> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
>>> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
>>> @@ -2642,13 +2642,13 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
>>>       if (curr_ctx->mode == S5P_JPEG_ENCODE)
>>>               vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload_size);
>>>       v4l2_m2m_buf_done(dst_buf, state);
>>> -     v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
>>>
>>>       curr_ctx->subsampling = s5p_jpeg_get_subsampling_mode(jpeg->regs);
>>>       spin_unlock(&jpeg->slock);
>>>
>>>       s5p_jpeg_clear_int(jpeg->regs);
>>>
>>> +     v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
>>>       return IRQ_HANDLED;
>>>  }
>>>
>>> @@ -2707,11 +2707,12 @@ static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
>>>               v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_ERROR);
>>>       }
>>>
>>> -     v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
>>>       if (jpeg->variant->version == SJPEG_EXYNOS4)
>>>               curr_ctx->subsampling = exynos4_jpeg_get_frame_fmt(jpeg->regs);
>>>
>>>       spin_unlock(&jpeg->slock);
>>> +
>>> +     v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
>>>       return IRQ_HANDLED;
>>>  }
>>>
>>> @@ -2770,10 +2771,15 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
>>>       if (curr_ctx->mode == S5P_JPEG_ENCODE)
>>>               vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload_size);
>>>       v4l2_m2m_buf_done(dst_buf, state);
>>> -     v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
>>>
>>>       curr_ctx->subsampling =
>>>                       exynos3250_jpeg_get_subsampling_mode(jpeg->regs);
>>> +
>>> +     spin_unlock(&jpeg->slock);
>>> +
>>> +     v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
>>> +     return IRQ_HANDLED;
>>> +
>>>  exit_unlock:
>>>       spin_unlock(&jpeg->slock);
>>>       return IRQ_HANDLED;
>>>
>>
>> Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
>>
>> Just out of curiosity - could you share how you discovered the problem -
>> by some static checkers or trying to use the driver?
> 
> We discovered this issue after adding a new unit test for the jpeg
> codec in Chromium OS:
> 
> https://bugs.chromium.org/p/chromium/issues/detail?id=705971
> 
>>From what I understand the test spawns different processes that access
> the codec device concurrently, creating the situation leading to the
> bug.

Thanks for the explanation. Nice fix.

> On a slightly related note, I was thinking whether it would make sense
> to move the call to  v4l2_m2m_job_finish() (and maybe other parts of
> the current interrupt handler) into a worker or a threaded interrupt
> handler so as to reduce the time we spend with interrupts disabled.
> Can I have your input on this idea?

Right, all remaining drivers call it from workers.
Feel free to submit a patch.

-- 
Best regards,
Jacek Anaszewski
