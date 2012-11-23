Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51941 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030268Ab2KWJrq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 04:47:46 -0500
Received: by mail-vc0-f174.google.com with SMTP id m18so5418304vcm.19
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 01:47:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50AF425E.9030203@samsung.com>
References: <1353645902-7467-1-git-send-email-sachin.kamat@linaro.org>
	<1353645902-7467-2-git-send-email-sachin.kamat@linaro.org>
	<50AF425E.9030203@samsung.com>
Date: Fri, 23 Nov 2012 15:17:45 +0530
Message-ID: <CAK9yfHzOs6B0=Z+EwwGt670tNLkpvFX0nkVELMzyyikpgzY=cw@mail.gmail.com>
Subject: Re: [PATCH 1/4] [media] exynos-gsc: Rearrange error messages for
 valid prints
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, patches@linaro.org,
	Shaik Ameer Basha <shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the review.

On 23 November 2012 15:01, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Hi Sachin,
>
> Thanks for the patches.
>
> On 11/23/2012 05:44 AM, Sachin Kamat wrote:
>> In case of clk_prepare failure, the function gsc_clk_get also prints
>> "failed to get clock" which is not correct. Hence move the error
>> messages to their respective blocks. While at it, also renamed the labels
>> meaningfully.
>>
>> Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/media/platform/exynos-gsc/gsc-core.c |   19 ++++++++++---------
>>  1 files changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
>> index 6d6f65d..45bcfa7 100644
>> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
>> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
>> @@ -1017,25 +1017,26 @@ static int gsc_clk_get(struct gsc_dev *gsc)
>>       dev_dbg(&gsc->pdev->dev, "gsc_clk_get Called\n");
>>
>>       gsc->clock = clk_get(&gsc->pdev->dev, GSC_CLOCK_GATE_NAME);
>> -     if (IS_ERR(gsc->clock))
>> -             goto err_print;
>> +     if (IS_ERR(gsc->clock)) {
>> +             dev_err(&gsc->pdev->dev, "failed to get clock~~~: %s\n",
>> +                     GSC_CLOCK_GATE_NAME);
>> +             goto err_clk_get;
>
> You could also just return PTR_ERR(gsc->clock) here and remove
> err_clk_get label entirely.

OK.

>
>> +     }
>>
>>       ret = clk_prepare(gsc->clock);
>>       if (ret < 0) {
>> +             dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
>> +                     GSC_CLOCK_GATE_NAME);
>>               clk_put(gsc->clock);
>>               gsc->clock = NULL;
>> -             goto err;
>> +             goto err_clk_prepare;
>>       }
>>
>>       return 0;
>>
>> -err:
>> -     dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
>> -                                     GSC_CLOCK_GATE_NAME);
>> +err_clk_prepare:
>>       gsc_clk_put(gsc);
>
> This call can be removed too. I would remove all labels and gotos in
> this function. Since there is only one clock, you need to only call
> clk_put when clk_prepare() fails, there is no need for gsc_clk_put().

I have removed gsc_clk_put() in the subsequent patch in this series.
I will probably incorporate your previous comment and remove the label
altogether (in patch 3)
and send it again.

>
>> -err_print:
>> -     dev_err(&gsc->pdev->dev, "failed to get clock~~~: %s\n",
>> -                                     GSC_CLOCK_GATE_NAME);
>> +err_clk_get:
>>       return -ENXIO;
>>  }
>
> As a general remark, I think changes like in this series have to be
> validated before we can think of applying it. I guess Shaik or
> somebody else would need to test it. I still have no board I could
> test Exynos5 Gscaler IP.

Yes you are right. I have already talked to Shaik about it.
He has agreed to test the same.

>
> --
>
> Regards,
> Sylwester



-- 
With warm regards,
Sachin
