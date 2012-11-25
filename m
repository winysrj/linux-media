Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47517 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2KYO5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 09:57:15 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so4056493eek.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 06:57:14 -0800 (PST)
Message-ID: <50B231C8.9040807@gmail.com>
Date: Sun, 25 Nov 2012 15:57:12 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.samsung@gmail.com>,
	Sachin Kamat <sachin.kamat@linaro.org>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v2 0/4] [media] exynos-gsc: Some fixes
References: <1353668682-13366-1-git-send-email-sachin.kamat@linaro.org> <CAOD6ATpPKvG3H2Z3_XK+yozM3KC4kh5=70HM2hpMUYvPfpe_6w@mail.gmail.com>
In-Reply-To: <CAOD6ATpPKvG3H2Z3_XK+yozM3KC4kh5=70HM2hpMUYvPfpe_6w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Shaik,

Sachin, I've applied the last patch fixing the checkpatch.pl warning.

As for the remaining three, can you please squash them, together
with following patch

 From cb7b42d2089206c8134fa195c0d1f4145fcb4f72 Mon Sep 17 00:00:00 2001
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Date: Sun, 25 Nov 2012 14:16:02 +0100
Subject: [PATCH] exynos-gsc: Correct clock handling

Make sure there is no unbalanced clk_unprepare call and add missing
clock release in the driver's remove() callback.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
  drivers/media/platform/exynos-gsc/gsc-core.c |    9 +++++----
  1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c 
b/drivers/media/platform/exynos-gsc/gsc-core.c
index 5a285b2..0c22ad5 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1002,10 +1002,8 @@ static void *gsc_get_drv_data(struct 
platform_device *pdev)

  static void gsc_clk_put(struct gsc_dev *gsc)
  {
-	if (IS_ERR_OR_NULL(gsc->clock))
-		return;
-
-	clk_unprepare(gsc->clock);
+	if (!IS_ERR(gsc->clock))
+		clk_unprepare(gsc->clock);
  }

  static int gsc_clk_get(struct gsc_dev *gsc)
@@ -1025,6 +1023,7 @@ static int gsc_clk_get(struct gsc_dev *gsc)
  	if (ret < 0) {
  		dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
  			GSC_CLOCK_GATE_NAME);
+		gsc->clock = ERR_PTR(-EINVAL);
  		return ret;
  	}

@@ -1097,6 +1096,7 @@ static int gsc_probe(struct platform_device *pdev)
  	init_waitqueue_head(&gsc->irq_queue);
  	spin_lock_init(&gsc->slock);
  	mutex_init(&gsc->lock);
+	gsc->clock = ERR_PTR(-EINVAL);

  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
  	gsc->regs = devm_request_and_ioremap(dev, res);
@@ -1160,6 +1160,7 @@ static int __devexit gsc_remove(struct 
platform_device *pdev)

  	vb2_dma_contig_cleanup_ctx(gsc->alloc_ctx);
  	pm_runtime_disable(&pdev->dev);
+	gsc_clk_put(gsc);

  	dev_dbg(&pdev->dev, "%s driver unloaded\n", pdev->name);
  	return 0;
-- 
1.7.4.1

And then maybe create 2 patches out of it, one adding missing gsc_clk_put()
in the gsc_remove() callback and the other converting to devm_clk_get() ?

I don't like how one of these patches adds something that is mostly removed
in subsequent one. This is just unneeded churn that makes the changes more
difficult to follow.

Thanks,
Sylwester

On 11/25/2012 08:00 AM, Shaik Ameer Basha wrote:
> Hi Sylwester,
>
> I tested this patch series. Looks good to me.
>
> Thanks,
> Shaik Ameer Basha
>
> On Fri, Nov 23, 2012 at 4:34 PM, Sachin Kamat<sachin.kamat@linaro.org>  wrote:
>> Changes since v1:
>> Removed the label 'err' from function gsc_clk_get as suggested
>> by Sylwester Nawrocki<s.nawrocki@samsung.com>  in patch 3/4.
>> Other patches remain the same.
>>
>> Patch series build tested and based on samsung/for_v3.8 branch of
>> git://linuxtv.org/snawrocki/media.git.
>>
>> Sachin Kamat (4):
>>    [media] exynos-gsc: Rearrange error messages for valid prints
>>    [media] exynos-gsc: Remove gsc_clk_put call from gsc_clk_get
>>    [media] exynos-gsc: Use devm_clk_get()
>>    [media] exynos-gsc: Fix checkpatch warning in gsc-m2m.c
>>
>>   drivers/media/platform/exynos-gsc/gsc-core.c |   21 ++++++++-------------
>>   drivers/media/platform/exynos-gsc/gsc-m2m.c  |    2 +-
>>   2 files changed, 9 insertions(+), 14 deletions(-)
>>
>> --
>> 1.7.4.1
