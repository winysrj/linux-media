Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:33477 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932854AbdGCOMd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 10:12:33 -0400
Received: by mail-wr0-f173.google.com with SMTP id r103so235246496wrb.0
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 07:12:32 -0700 (PDT)
Subject: Re: [PATCH v2 09/19] media: camms: Add core files
To: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
 <1497883719-12410-10-git-send-email-todor.tomov@linaro.org>
 <20c81ca2-09f4-b0c9-a72a-1e39f861cfb5@xs4all.nl>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <ef378fb1-509f-799a-d05d-64be02898769@linaro.org>
Date: Mon, 3 Jul 2017 17:12:25 +0300
MIME-Version: 1.0
In-Reply-To: <20c81ca2-09f4-b0c9-a72a-1e39f861cfb5@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

Thank you for the review.

On 07/03/2017 02:24 PM, Hans Verkuil wrote:
> On 06/19/2017 04:48 PM, Todor Tomov wrote:
>> These files implement the platform driver code.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>   drivers/media/platform/qcom/camss-8x16/camss.c | 630 +++++++++++++++++++++++++
>>   drivers/media/platform/qcom/camss-8x16/camss.h |  96 ++++
>>   2 files changed, 726 insertions(+)
>>   create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.c
>>   create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.h
>>
>> diff --git a/drivers/media/platform/qcom/camss-8x16/camss.c b/drivers/media/platform/qcom/camss-8x16/camss.c
>> new file mode 100644
>> index 0000000..a8798d1
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/camss-8x16/camss.c
>> @@ -0,0 +1,630 @@
>> +/*
>> + * camss.c
>> + *
>> + * Qualcomm MSM Camera Subsystem - Core
>> + *
>> + * Copyright (c) 2015, The Linux Foundation. All rights reserved.
>> + * Copyright (C) 2015-2016 Linaro Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +#include <linux/clk.h>
>> +#include <linux/media-bus-format.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/of.h>
>> +#include <linux/slab.h>
>> +
>> +#include <media/media-device.h>
>> +#include <media/v4l2-async.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-mc.h>
>> +#include <media/v4l2-of.h>
> 
> v4l2-of.h has been replaced by v4l2-fwnode.h. You need to rebase.

I'll rebase for the next version of the patchset.

> 
> Regards,
> 
>     Hans

-- 
Best regards,
Todor Tomov
