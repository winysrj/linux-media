Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:43810 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab3DPGQS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 02:16:18 -0400
Received: by mail-oa0-f47.google.com with SMTP id n9so145660oag.34
        for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 23:16:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <516C1B0B.4010806@samsung.com>
References: <1366027438-4560-1-git-send-email-sachin.kamat@linaro.org>
	<516C1B0B.4010806@samsung.com>
Date: Tue, 16 Apr 2013 11:46:18 +0530
Message-ID: <CAK9yfHyU8jebjSqc=cG7TqsobZ=avzxFXt6qky2H52W6UGRTww@mail.gmail.com>
Subject: Re: [PATCH 1/1] [media] exynos4-is: Fix potential null pointer dereferencing
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 15 April 2013 20:51, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:

>> -     if (!fimc->drv_data || fimc->id >= fimc->drv_data->num_entities ||
>> -         fimc->id < 0) {
>> -             dev_err(dev, "Invalid driver data or device id (%d/%d)\n",
>> -                     fimc->id, fimc->drv_data->num_entities);
>> +     if (!fimc->drv_data || fimc->id >= fimc->drv_data->num_entities) {
>> +             dev_err(dev, "Invalid driver data or device id (%d)\n",
>> +                     fimc->id);
>>               return -EINVAL;
>
> Thanks for the patch. To make it more explicit I would prefer to change
> id type to 'int', and to leave the check for negative value. There is
> a similar issue in fimc-lite.c that could be addressed in same patch.
> Could you also fix this and resend ?

Sure.
I also found a few more things to fix and sent a 5 patch fix series
including the above changes.

-- 
With warm regards,
Sachin
