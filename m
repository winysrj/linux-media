Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:37901 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3EBETY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 00:19:24 -0400
Received: by mail-ob0-f171.google.com with SMTP id v19so130527obq.30
        for <linux-media@vger.kernel.org>; Wed, 01 May 2013 21:19:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5180E05C.7020206@gmail.com>
References: <1367297493-31782-1-git-send-email-sachin.kamat@linaro.org>
	<5180E05C.7020206@gmail.com>
Date: Thu, 2 May 2013 09:49:23 +0530
Message-ID: <CAK9yfHz-Q6t5YtQOHj7TgDvKzxeiJntJWdimkw4qf0dek3BW0A@mail.gmail.com>
Subject: Re: [PATCH 1/1] [media] exynos4-is: Remove redundant NULL check in fimc-lite.c
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1 May 2013 14:59, Sylwester Nawrocki <sylvester.nawrocki@gmail.com> wrote:
> Sachin,
>
>
> On 04/30/2013 06:51 AM, Sachin Kamat wrote:
>>
>> clk_unprepare checks for NULL pointer. Hence convert IS_ERR_OR_NULL
>> to IS_ERR only.
>>
>> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
>> ---
>>   drivers/media/platform/exynos4-is/fimc-lite.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c
>> b/drivers/media/platform/exynos4-is/fimc-lite.c
>> index 661d0d1..2a0ef82 100644
>> --- a/drivers/media/platform/exynos4-is/fimc-lite.c
>> +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
>> @@ -1416,7 +1416,7 @@ static void
>> fimc_lite_unregister_capture_subdev(struct fimc_lite *fimc)
>>
>>   static void fimc_lite_clk_put(struct fimc_lite *fimc)
>>   {
>> -       if (IS_ERR_OR_NULL(fimc->clock))
>> +       if (IS_ERR(fimc->clock))
>>                 return;
>>
>>         clk_unprepare(fimc->clock);
>
>
> I've queued this patch for 3.11 with the below chunk squashed to it:

Thanks Sylwester.


-- 
With warm regards,
Sachin
