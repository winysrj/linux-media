Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52397 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3ARK23 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jan 2013 05:28:29 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGT00EREH201L40@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 18 Jan 2013 10:28:27 +0000 (GMT)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MGT00GPWH3F8V10@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 18 Jan 2013 10:28:27 +0000 (GMT)
Message-id: <50F923C9.8000205@samsung.com>
Date: Fri, 18 Jan 2013 11:28:25 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] s5p-fimc: set m2m context to null at the end of
 fimc_m2m_resume
References: <1358503278-13414-1-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1358503278-13414-1-git-send-email-shaik.ameer@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

On 01/18/2013 11:01 AM, Shaik Ameer Basha wrote:
> fimc_m2m_job_finish() has to be called with the m2m context for the necessary
> cleanup while resume. But currently fimc_m2m_job_finish() always passes
> fimc->m2m.ctx as NULL.
> 
> This patch changes the order of the calls for proper cleanup while resume.
> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> ---
>  drivers/media/platform/s5p-fimc/fimc-core.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
> index 2a1558a..5b11544 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-core.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-core.c
> @@ -868,14 +868,15 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
>  {
>  	unsigned long flags;
>  
> +	if (test_and_clear_bit(ST_M2M_SUSPENDED, &fimc->state))
> +		fimc_m2m_job_finish(fimc->m2m.ctx,
> +				    VB2_BUF_STATE_ERROR);
> +
>  	spin_lock_irqsave(&fimc->slock, flags);
>  	/* Clear for full H/W setup in first run after resume */
>  	fimc->m2m.ctx = NULL;
>  	spin_unlock_irqrestore(&fimc->slock, flags);
>  
> -	if (test_and_clear_bit(ST_M2M_SUSPENDED, &fimc->state))
> -		fimc_m2m_job_finish(fimc->m2m.ctx,
> -				    VB2_BUF_STATE_ERROR);

Thanks for the patch. Not sure how I managed to miss that...
I'm not convince this is the right fix though. fimc->m2m.ctx should
be reset so the device is properly configured in fimc_dma_run()
callback. Since after suspend/resume cycle all previous registers'
state is lost.
So I think something more like below is needed. Can you check if it
helps ? And what problem exactly are you observing ? Streaming is not
resumed after system resume ?


diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c
b/drivers/media/platform/s5p-fimc/fimc-core.c
index bdb544f..feb8620 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -869,16 +869,18 @@ static int fimc_m2m_suspend(struct fimc_dev *fimc)

 static int fimc_m2m_resume(struct fimc_dev *fimc)
 {
+       struct fimc_ctx *ctx;
        unsigned long flags;

        spin_lock_irqsave(&fimc->slock, flags);
        /* Clear for full H/W setup in first run after resume */
+       ctx = fimc->m2m.ctx;
        fimc->m2m.ctx = NULL;
        spin_unlock_irqrestore(&fimc->slock, flags);

        if (test_and_clear_bit(ST_M2M_SUSPENDED, &fimc->state))
-               fimc_m2m_job_finish(fimc->m2m.ctx,
-                                   VB2_BUF_STATE_ERROR);
+               fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
+
        return 0;
 }

Regards,
Sylwester

-- 
Sylwester Nawrocki
Samsung Poland R&D Center
