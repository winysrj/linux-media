Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:49205 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbaGWD0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 23:26:20 -0400
Received: by mail-yk0-f178.google.com with SMTP id 142so416332ykq.23
        for <linux-media@vger.kernel.org>; Tue, 22 Jul 2014 20:26:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK5sBcFrb6j5yKyy=SYor-0+YL81feWFuHEyPVg0ZyP4g9bqAw@mail.gmail.com>
References: <1405918488-26142-1-git-send-email-shaik.ameer@samsung.com> <CAK5sBcFrb6j5yKyy=SYor-0+YL81feWFuHEyPVg0ZyP4g9bqAw@mail.gmail.com>
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
Date: Wed, 23 Jul 2014 08:55:59 +0530
Message-ID: <CAOD6ATrvU2w_jGyuYJWA=zSZYBpRh-M0Aja8C1kV+spLxS7Xpg@mail.gmail.com>
Subject: Re: [PATCH] [media] exynos-gsc: Remove PM_RUNTIME dependency
To: Sachin Kamat <spk.linux@gmail.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>, pawel@osciak.com,
	sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thanks for testing.

Even I tested with both PM enable/disable with EXYNOS_IOMMU. I didn't
face any issues.
Let me check with out IOMMU. I will update the status soon.

Regards,
Shaik Ameer Basha

On Tue, Jul 22, 2014 at 10:31 AM, Sachin Kamat <spk.linux@gmail.com> wrote:
> Hi Shaik,
>
> On Mon, Jul 21, 2014 at 10:24 AM, Shaik Ameer Basha
> <shaik.ameer@samsung.com> wrote:
>> 1] Currently Gscaler clock is enabled only inside pm_runtime callbacks.
>>    If PM_RUNTIME is disabled, driver hangs. This patch removes the
>>    PM_RUNTIME dependency by keeping the clock enable/disable functions
>>    in m2m start/stop streaming callbacks.
>>
>> 2] For Exynos5420/5800, Gscaler clock has to be Turned ON before powering
>>    on/off the Gscaler power domain. This dependency is taken care by
>>    this patch at driver level.
>>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> ---
>>  drivers/media/platform/exynos-gsc/gsc-core.c |   10 ++--------
>>  drivers/media/platform/exynos-gsc/gsc-m2m.c  |   13 +++++++++++++
>>  2 files changed, 15 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
>> index 9d0cc04..39c0953 100644
>> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
>> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
>> @@ -1132,23 +1132,17 @@ static int gsc_probe(struct platform_device *pdev)
>>
>>         platform_set_drvdata(pdev, gsc);
>>         pm_runtime_enable(dev);
>> -       ret = pm_runtime_get_sync(&pdev->dev);
>> -       if (ret < 0)
>> -               goto err_m2m;
>>
>>         /* Initialize continious memory allocator */
>>         gsc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
>>         if (IS_ERR(gsc->alloc_ctx)) {
>>                 ret = PTR_ERR(gsc->alloc_ctx);
>> -               goto err_pm;
>> +               goto err_m2m;
>>         }
>>
>>         dev_dbg(dev, "gsc-%d registered successfully\n", gsc->id);
>> -
>> -       pm_runtime_put(dev);
>>         return 0;
>> -err_pm:
>> -       pm_runtime_put(dev);
>> +
>>  err_m2m:
>>         gsc_unregister_m2m_device(gsc);
>>  err_v4l2:
>> diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
>> index e434f1f0..a98462c 100644
>> --- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
>> +++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
>> @@ -60,19 +60,32 @@ static void __gsc_m2m_job_abort(struct gsc_ctx *ctx)
>>  static int gsc_m2m_start_streaming(struct vb2_queue *q, unsigned int count)
>>  {
>>         struct gsc_ctx *ctx = q->drv_priv;
>> +       struct gsc_dev *gsc = ctx->gsc_dev;
>>         int ret;
>>
>> +       ret = clk_enable(gsc->clock);
>> +       if (ret)
>> +               return ret;
>> +
>>         ret = pm_runtime_get_sync(&ctx->gsc_dev->pdev->dev);
>> +
>> +       if (!pm_runtime_enabled(&gsc->pdev->dev)) {
>> +               gsc_hw_set_sw_reset(gsc);
>> +               gsc_wait_reset(gsc);
>> +       }
>> +
>>         return ret > 0 ? 0 : ret;
>>  }
>>
>>  static void gsc_m2m_stop_streaming(struct vb2_queue *q)
>>  {
>>         struct gsc_ctx *ctx = q->drv_priv;
>> +       struct gsc_dev *gsc = ctx->gsc_dev;
>>
>>         __gsc_m2m_job_abort(ctx);
>>
>>         pm_runtime_put(&ctx->gsc_dev->pdev->dev);
>> +       clk_disable(gsc->clock);
>>  }
>>
>>  void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state)
>> --
>> 1.7.9.5
>>
>
> Looks like there is some issue while runtime PM is disabled. The
> conversion operation hangs. Tested on 5420 based Arndale Octa
> board with latest next kernel.
>
> --
> Regards,
> Sachin.
