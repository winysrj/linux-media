Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:12667 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbeIUJXb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 05:23:31 -0400
Message-ID: <5BA46742.4010804@huawei.com>
Date: Fri, 21 Sep 2018 11:36:34 +0800
From: zhong jiang <zhongjiang@huawei.com>
MIME-Version: 1.0
To: Todor Tomov <todor.tomov@linaro.org>
CC: <mchehab@kernel.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: qcom: remove duplicated include file
References: <1537419595-29990-1-git-send-email-zhongjiang@huawei.com> <43b41757-18ea-cbb3-1578-ba4068b13ab1@linaro.org>
In-Reply-To: <43b41757-18ea-cbb3-1578-ba4068b13ab1@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018/9/20 13:55, Todor Tomov wrote:
> Thank you for spotting that!
>
> On 19.09.2018 21:59, zhong jiang wrote:
>> device.h have duplicated include. hence just remove
>> redundant include file.
> I think it will be better to remove the second occurrence because
> it will keep the alphabetical order of the includes.
Yep,  I forget the point.  Will change in v2.

Thanks,
zhong jiang
> Best regards,
> Todor Tomov
>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>> ---
>>  drivers/media/platform/qcom/camss/camss.h | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/qcom/camss/camss.h b/drivers/media/platform/qcom/camss/camss.h
>> index 418996d..0823a71 100644
>> --- a/drivers/media/platform/qcom/camss/camss.h
>> +++ b/drivers/media/platform/qcom/camss/camss.h
>> @@ -10,7 +10,6 @@
>>  #ifndef QC_MSM_CAMSS_H
>>  #define QC_MSM_CAMSS_H
>>  
>> -#include <linux/device.h>
>>  #include <linux/types.h>
>>  #include <media/v4l2-async.h>
>>  #include <media/v4l2-device.h>
>>
>
>
