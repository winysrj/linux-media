Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25251 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965813Ab3DQLDJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 07:03:09 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLE00H4XBWSZKC0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Apr 2013 12:03:07 +0100 (BST)
Message-id: <516E816A.4080309@samsung.com>
Date: Wed, 17 Apr 2013 13:03:06 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH 1/1] [media] exynos4-is: Fix potential null pointer
 dereferencing
References: <1366027438-4560-1-git-send-email-sachin.kamat@linaro.org>
 <516C1B0B.4010806@samsung.com>
 <CAK9yfHyU8jebjSqc=cG7TqsobZ=avzxFXt6qky2H52W6UGRTww@mail.gmail.com>
In-reply-to: <CAK9yfHyU8jebjSqc=cG7TqsobZ=avzxFXt6qky2H52W6UGRTww@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 04/16/2013 08:16 AM, Sachin Kamat wrote:
> Hi Sylwester,
> 
> On 15 April 2013 20:51, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> 
>>> -     if (!fimc->drv_data || fimc->id >= fimc->drv_data->num_entities ||
>>> -         fimc->id < 0) {
>>> -             dev_err(dev, "Invalid driver data or device id (%d/%d)\n",
>>> -                     fimc->id, fimc->drv_data->num_entities);
>>> +     if (!fimc->drv_data || fimc->id >= fimc->drv_data->num_entities) {
>>> +             dev_err(dev, "Invalid driver data or device id (%d)\n",
>>> +                     fimc->id);
>>>               return -EINVAL;
>>
>> Thanks for the patch. To make it more explicit I would prefer to change
>> id type to 'int', and to leave the check for negative value. There is
>> a similar issue in fimc-lite.c that could be addressed in same patch.
>> Could you also fix this and resend ?
> 
> Sure.
> I also found a few more things to fix and sent a 5 patch fix series
> including the above changes.

Thanks a lot for your review and patches. I'll apply patches 1..2/5 for
3.10-rc, and patch 3/5 for 3.11.

Regarding patch 4/5, as can be seen I didn't test the driver as a module
before pushing upstream, my bad! :( So I had a look at it and found a few
more issues. _Almost_ everything is fine now :-) after I fixed those,
I'm going to post related patch set soon. Your patch 4/5 is not applicable
any more unfortunately.

Regarding patch 5/5, I would prefer to keep that code, if you and others
don't mind. Sorry, I'm a bit tied to it ;) Seriously, I hope to have more
V4L2 controls supported for 3.11, so removing and re-adding that chunks
would be a useless churn IMHO.


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
