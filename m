Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:39714 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab3HBJEI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 05:04:08 -0400
Received: by mail-oa0-f54.google.com with SMTP id o6so823216oag.41
        for <linux-media@vger.kernel.org>; Fri, 02 Aug 2013 02:04:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51FB71B3.5060008@samsung.com>
References: <1375425134-17080-1-git-send-email-sachin.kamat@linaro.org>
	<1375425134-17080-3-git-send-email-sachin.kamat@linaro.org>
	<51FB71B3.5060008@samsung.com>
Date: Fri, 2 Aug 2013 14:34:07 +0530
Message-ID: <CAK9yfHwiF4F6edafkwtogUFwAtWm3-My=UEhgARez9eksngwuA@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] exynos4-is: Fix potential NULL pointer dereference
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 2 August 2013 14:15, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Hi Sachin,
>
> On 08/02/2013 08:32 AM, Sachin Kamat wrote:
>> dev->of_node could be NULL. Hence check for the same and return before
>> dereferencing it in the subsequent error message.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/media/platform/exynos4-is/fimc-lite.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
>> index 08fbfed..214bde2 100644
>> --- a/drivers/media/platform/exynos4-is/fimc-lite.c
>> +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
>> @@ -1513,6 +1513,9 @@ static int fimc_lite_probe(struct platform_device *pdev)
>>               if (of_id)
>>                       drv_data = (struct flite_drvdata *)of_id->data;
>>               fimc->index = of_alias_get_id(dev->of_node, "fimc-lite");
>> +     } else {
>> +             dev_err(dev, "device node not found\n");
>> +             return -EINVAL;
>>       }
>
> Thanks for the patch. I would prefer to add a check at very beginning
> of fimc_lite_probe() like:
>
>         if (!dev->of_node)
>                 return -ENODEV;
>
> Those devices are only used on DT platforms.

OK. Sounds good. I will re-spin this one.

-- 
With warm regards,
Sachin
