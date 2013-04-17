Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:47303 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934796Ab3DQLJq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 07:09:46 -0400
Received: by mail-ob0-f179.google.com with SMTP id tb18so1306045obb.38
        for <linux-media@vger.kernel.org>; Wed, 17 Apr 2013 04:09:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <516E816A.4080309@samsung.com>
References: <1366027438-4560-1-git-send-email-sachin.kamat@linaro.org>
	<516C1B0B.4010806@samsung.com>
	<CAK9yfHyU8jebjSqc=cG7TqsobZ=avzxFXt6qky2H52W6UGRTww@mail.gmail.com>
	<516E816A.4080309@samsung.com>
Date: Wed, 17 Apr 2013 16:39:45 +0530
Message-ID: <CAK9yfHwX7sXr7Y5wvWBYPWVdfU4jHJwepwKKhpyy7eL6xXNxKw@mail.gmail.com>
Subject: Re: [PATCH 1/1] [media] exynos4-is: Fix potential null pointer dereferencing
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 17 April 2013 16:33, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Hi Sachin,
>
> On 04/16/2013 08:16 AM, Sachin Kamat wrote:
>> Hi Sylwester,
>>
>> On 15 April 2013 20:51, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
>>
>>>> -     if (!fimc->drv_data || fimc->id >= fimc->drv_data->num_entities ||
>>>> -         fimc->id < 0) {
>>>> -             dev_err(dev, "Invalid driver data or device id (%d/%d)\n",
>>>> -                     fimc->id, fimc->drv_data->num_entities);
>>>> +     if (!fimc->drv_data || fimc->id >= fimc->drv_data->num_entities) {
>>>> +             dev_err(dev, "Invalid driver data or device id (%d)\n",
>>>> +                     fimc->id);
>>>>               return -EINVAL;
>>>
>>> Thanks for the patch. To make it more explicit I would prefer to change
>>> id type to 'int', and to leave the check for negative value. There is
>>> a similar issue in fimc-lite.c that could be addressed in same patch.
>>> Could you also fix this and resend ?
>>
>> Sure.
>> I also found a few more things to fix and sent a 5 patch fix series
>> including the above changes.
>
> Thanks a lot for your review and patches. I'll apply patches 1..2/5 for
> 3.10-rc, and patch 3/5 for 3.11.

OK. No problem.

>
> Regarding patch 4/5, as can be seen I didn't test the driver as a module
> before pushing upstream, my bad! :( So I had a look at it and found a few
> more issues. _Almost_ everything is fine now :-) after I fixed those,
> I'm going to post related patch set soon. Your patch 4/5 is not applicable
> any more unfortunately.

Not a problem as long as the issue is handled or fixed :).

>
> Regarding patch 5/5, I would prefer to keep that code, if you and others
> don't mind. Sorry, I'm a bit tied to it ;) Seriously, I hope to have more
> V4L2 controls supported for 3.11, so removing and re-adding that chunks
> would be a useless churn IMHO.

Right. That is the reason I kept this patch at the end of the series
so that you may decide as appropriate.

-- 
With warm regards,
Sachin
