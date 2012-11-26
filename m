Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62900 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab2KZEyb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 23:54:31 -0500
Received: by mail-vc0-f174.google.com with SMTP id m18so7234548vcm.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 20:54:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B23A09.4010105@gmail.com>
References: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
	<1353671443-2978-2-git-send-email-sachin.kamat@linaro.org>
	<50B23A09.4010105@gmail.com>
Date: Mon, 26 Nov 2012 10:24:29 +0530
Message-ID: <CAK9yfHy=PfSXkvVNbFBBfpX1WJXo2jR4tucMojei1=rcCR-xOQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] [media] s5p-fimc: Use devm_clk_get in mipi-csis.c
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 25 November 2012 21:02, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Sachin,
>
>
> On 11/23/2012 12:50 PM, Sachin Kamat wrote:
>>
>> devm_clk_get is device managed and makes error handling and cleanup
>> a bit simpler.
>
>
> Can we postpone this once devm_clk_prepare() is available ?
Ok. No problem. I will hold on till then.

>
>
>> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
>> ---
>>   drivers/media/platform/s5p-fimc/mipi-csis.c |    6 +-----
>>   1 files changed, 1 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c
>> b/drivers/media/platform/s5p-fimc/mipi-csis.c
>> index 4c961b1..d624bfa 100644
>> --- a/drivers/media/platform/s5p-fimc/mipi-csis.c
>> +++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
>> @@ -341,8 +341,6 @@ static void s5pcsis_clk_put(struct csis_state *state)
>>                 if (IS_ERR_OR_NULL(state->clock[i]))
>>                         continue;
>>                 clk_unprepare(state->clock[i]);
>> -               clk_put(state->clock[i]);
>> -               state->clock[i] = NULL;
>
>
> This line shouldn't be removed, it protects from releasing already
> released clock resource.

Wouldn't 'state->clock[i] = NULL' cause a problem when put gets called
upon exit from this function by devres f/w as its argument would be
NULL?
In that case devm_clk_put would be better here?

> In fact state->clock[i] = ERR_PTR(-EINVAL);
> would be more correct, but that's a different story.
>
>
>>         }
>>   }
>>
>> @@ -352,13 +350,11 @@ static int s5pcsis_clk_get(struct csis_state *state)
>>         int i, ret;
>>
>>         for (i = 0; i<  NUM_CSIS_CLOCKS; i++) {
>> -               state->clock[i] = clk_get(dev, csi_clock_name[i]);
>> +               state->clock[i] = devm_clk_get(dev, csi_clock_name[i]);
>>                 if (IS_ERR(state->clock[i]))
>>                         goto err;
>>                 ret = clk_prepare(state->clock[i]);
>>                 if (ret<  0) {
>> -                       clk_put(state->clock[i]);
>> -                       state->clock[i] = NULL;
>
>
> And same here, now we have a pointer to valid, unprepared clock in
> state->clock[i]. When s5pcsis_clk_put() gets called afterwards it will
> invoke unbalanced clk_unprepare() in this clock.
>
> I would prefer to hold on with that sort of changes in s5p-fimc driver,
> until after devm_clk_prepare() is available.

Ok.

>
>>                         goto err;
>>                 }
>>         }
>
>
> Regards,
> Sylwester



-- 
With warm regards,
Sachin
