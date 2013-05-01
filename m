Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:51070 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529Ab3EAJ3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 May 2013 05:29:05 -0400
Received: by mail-ee0-f54.google.com with SMTP id e49so588492eek.27
        for <linux-media@vger.kernel.org>; Wed, 01 May 2013 02:29:03 -0700 (PDT)
Message-ID: <5180E05C.7020206@gmail.com>
Date: Wed, 01 May 2013 11:29:00 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org
Subject: Re: [PATCH 1/1] [media] exynos4-is: Remove redundant NULL check in
 fimc-lite.c
References: <1367297493-31782-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1367297493-31782-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sachin,

On 04/30/2013 06:51 AM, Sachin Kamat wrote:
> clk_unprepare checks for NULL pointer. Hence convert IS_ERR_OR_NULL
> to IS_ERR only.
>
> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
> ---
>   drivers/media/platform/exynos4-is/fimc-lite.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
> index 661d0d1..2a0ef82 100644
> --- a/drivers/media/platform/exynos4-is/fimc-lite.c
> +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
> @@ -1416,7 +1416,7 @@ static void fimc_lite_unregister_capture_subdev(struct fimc_lite *fimc)
>
>   static void fimc_lite_clk_put(struct fimc_lite *fimc)
>   {
> -	if (IS_ERR_OR_NULL(fimc->clock))
> +	if (IS_ERR(fimc->clock))
>   		return;
>
>   	clk_unprepare(fimc->clock);

I've queued this patch for 3.11 with the below chunk squashed to it:

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c 
b/drivers/media/platform/exynos4-is/fimc-lite.c
index 2ede148..faf2a75 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1422,7 +1422,7 @@ static void fimc_lite_clk_put(struct fimc_lite *fimc)

         clk_unprepare(fimc->clock);
         clk_put(fimc->clock);
-       fimc->clock = NULL;
+       fimc->clock = ERR_PTR(-EINVAL);
  }

  static int fimc_lite_clk_get(struct fimc_lite *fimc)
@@ -1436,7 +1436,7 @@ static int fimc_lite_clk_get(struct fimc_lite *fimc)
         ret = clk_prepare(fimc->clock);
         if (ret < 0) {
                 clk_put(fimc->clock);
-               fimc->clock = NULL;
+               fimc->clock = ERR_PTR(-EINVAL);
         }
         return ret;
  }

Thanks.
Sylwester
