Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753583AbeGFLJG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jul 2018 07:09:06 -0400
Subject: Re: [PATCH v2 2/3] s5p-g2d: Remove unrequired wait in .job_abort
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Cc: linux-media@vger.kernel.org, kernel@collabora.com,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>
References: <20180618043852.13293-1-ezequiel@collabora.com>
 <20180618043852.13293-3-ezequiel@collabora.com>
 <0c63d9ee-88c4-c09d-ec36-cc0ee3ca3d8f@xs4all.nl>
From: Sylwester Nawrocki <snawrocki@kernel.org>
Message-ID: <7a4debab-717e-c99b-778f-fc9bdc99775e@kernel.org>
Date: Fri, 6 Jul 2018 13:09:01 +0200
MIME-Version: 1.0
In-Reply-To: <0c63d9ee-88c4-c09d-ec36-cc0ee3ca3d8f@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/04/2018 10:04 AM, Hans Verkuil wrote:
> On 18/06/18 06:38, Ezequiel Garcia wrote:
>> As per the documentation, job_abort is not required
>> to wait until the current job finishes. It is redundant
>> to do so, as the core will perform the wait operation.

Could you elaborate how the core ensures DMA operation is not in progress
after VIDIOC_STREAMOFF, VIDIOC_DQBUF with this patch applied?

>> Remove the wait infrastructure completely.
> 
> Sylwester, can you review this?

Thanks for forwarding Hans!

>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Kamil Debski <kamil@wypas.org>
>> Cc: Andrzej Hajda <a.hajda@samsung.com>
>> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
>> ---
>>   drivers/media/platform/s5p-g2d/g2d.c | 11 -----------
>>   drivers/media/platform/s5p-g2d/g2d.h |  1 -
>>   2 files changed, 12 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
>> index 66aa8cf1d048..e98708883413 100644
>> --- a/drivers/media/platform/s5p-g2d/g2d.c
>> +++ b/drivers/media/platform/s5p-g2d/g2d.c
>> @@ -483,15 +483,6 @@ static int vidioc_s_crop(struct file *file, void *prv, const struct v4l2_crop *c
>>   
>>   static void job_abort(void *prv)
>>   {
>> -	struct g2d_ctx *ctx = prv;
>> -	struct g2d_dev *dev = ctx->dev;
>> -
>> -	if (dev->curr == NULL) /* No job currently running */
>> -		return;
>> -
>> -	wait_event_timeout(dev->irq_queue,
>> -			   dev->curr == NULL,
>> -			   msecs_to_jiffies(G2D_TIMEOUT));

I think after this patch there will be a potential race condition possible,
we could have the hardware DMA and CPU writing to same buffer with sequence like:
...
QBUF
STREAMON
STREAMOFF
DQBUF 
CPU accessing the buffer  <--  at this point G2D DMA could still be writing
to an already dequeued buffer. Image processing can take few miliseconds, it should
be fairly easy to trigger such a condition.

Not saying about DMA being still in progress after device file handle is closed,
but that's something that deserves a separate patch. It seems there is a bug in 
the driver as there is no call to v4l2_m2m_ctx_release()in the device fops release() 
callback.

I think we could remove the s5p-g2d driver altogether as the functionality is covered
by the exynos DRM IPP driver (drivers/gpu/drm/exynos).

>>   }
>>   
>>   static void device_run(void *prv)
>> @@ -563,7 +554,6 @@ static irqreturn_t g2d_isr(int irq, void *prv)
>>   	v4l2_m2m_job_finish(dev->m2m_dev, ctx->fh.m2m_ctx);
>>   
>>   	dev->curr = NULL;
>> -	wake_up(&dev->irq_queue);
>>   	return IRQ_HANDLED;
>>   }

--
Regards,
Sylwester
