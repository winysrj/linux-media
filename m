Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:41653 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3ARL4o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jan 2013 06:56:44 -0500
Received: by mail-qc0-f177.google.com with SMTP id u28so2311112qcs.22
        for <linux-media@vger.kernel.org>; Fri, 18 Jan 2013 03:56:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50F923C9.8000205@samsung.com>
References: <1358503278-13414-1-git-send-email-shaik.ameer@samsung.com>
	<50F923C9.8000205@samsung.com>
Date: Fri, 18 Jan 2013 17:26:43 +0530
Message-ID: <CAOD6ATpE2gM2BaHnWGR9dHOx4-zEV11n1E-zk_G0pQfu3qiKVA@mail.gmail.com>
Subject: Re: [PATCH] s5p-fimc: set m2m context to null at the end of fimc_m2m_resume
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Fri, Jan 18, 2013 at 3:58 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hi Shaik,
>
> On 01/18/2013 11:01 AM, Shaik Ameer Basha wrote:
>> fimc_m2m_job_finish() has to be called with the m2m context for the necessary
>> cleanup while resume. But currently fimc_m2m_job_finish() always passes
>> fimc->m2m.ctx as NULL.
>>
>> This patch changes the order of the calls for proper cleanup while resume.
>>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> ---
>>  drivers/media/platform/s5p-fimc/fimc-core.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
>> index 2a1558a..5b11544 100644
>> --- a/drivers/media/platform/s5p-fimc/fimc-core.c
>> +++ b/drivers/media/platform/s5p-fimc/fimc-core.c
>> @@ -868,14 +868,15 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
>>  {
>>       unsigned long flags;
>>
>> +     if (test_and_clear_bit(ST_M2M_SUSPENDED, &fimc->state))
>> +             fimc_m2m_job_finish(fimc->m2m.ctx,
>> +                                 VB2_BUF_STATE_ERROR);
>> +
>>       spin_lock_irqsave(&fimc->slock, flags);
>>       /* Clear for full H/W setup in first run after resume */
>>       fimc->m2m.ctx = NULL;
>>       spin_unlock_irqrestore(&fimc->slock, flags);
>>
>> -     if (test_and_clear_bit(ST_M2M_SUSPENDED, &fimc->state))
>> -             fimc_m2m_job_finish(fimc->m2m.ctx,
>> -                                 VB2_BUF_STATE_ERROR);
>
> Thanks for the patch. Not sure how I managed to miss that...
> I'm not convince this is the right fix though. fimc->m2m.ctx should
> be reset so the device is properly configured in fimc_dma_run()
> callback. Since after suspend/resume cycle all previous registers'
> state is lost.

Yes, you are right. In case, more buffers are queued for the same
context, there can be issues.
I think you can apply this patch with your modified changes.

> So I think something more like below is needed. Can you check if it
> helps ? And what problem exactly are you observing ? Streaming is not
> resumed after system resume ?
>

I was reviewing my gsc-m2m code and found out this issue.
As you know gsc-m2m mostly follows fimc-m2m ;)

Regards,
Shaik Ameer Basha

>
> diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c
> b/drivers/media/platform/s5p-fimc/fimc-core.c
> index bdb544f..feb8620 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-core.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-core.c
> @@ -869,16 +869,18 @@ static int fimc_m2m_suspend(struct fimc_dev *fimc)
>
>  static int fimc_m2m_resume(struct fimc_dev *fimc)
>  {
> +       struct fimc_ctx *ctx;
>         unsigned long flags;
>
>         spin_lock_irqsave(&fimc->slock, flags);
>         /* Clear for full H/W setup in first run after resume */
> +       ctx = fimc->m2m.ctx;
>         fimc->m2m.ctx = NULL;
>         spin_unlock_irqrestore(&fimc->slock, flags);
>
>         if (test_and_clear_bit(ST_M2M_SUSPENDED, &fimc->state))
> -               fimc_m2m_job_finish(fimc->m2m.ctx,
> -                                   VB2_BUF_STATE_ERROR);
> +               fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
> +
>         return 0;
>  }
>
> Regards,
> Sylwester
>
> --
> Sylwester Nawrocki
> Samsung Poland R&D Center
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
