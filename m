Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35605 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754483AbdGCOKy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 10:10:54 -0400
Received: by mail-wm0-f46.google.com with SMTP id w126so169745972wme.0
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 07:10:53 -0700 (PDT)
Subject: Re: [PATCH v2 05/19] media: camss: Add CSID files
To: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
 <1497883719-12410-6-git-send-email-todor.tomov@linaro.org>
 <abbffc59-d3a5-6abb-51ac-cb04eca292bd@xs4all.nl>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <8d73bee7-ee9f-24c3-b2ca-27af0718ab77@linaro.org>
Date: Mon, 3 Jul 2017 17:10:49 +0300
MIME-Version: 1.0
In-Reply-To: <abbffc59-d3a5-6abb-51ac-cb04eca292bd@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

Thank you for the review.

On 07/03/2017 01:49 PM, Hans Verkuil wrote:
> On 06/19/2017 04:48 PM, Todor Tomov wrote:
>> These files control the CSID modules which handle the protocol and application
>> layer of the CSI2 receivers.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>   drivers/media/platform/qcom/camss-8x16/csid.c | 1072 +++++++++++++++++++++++++
>>   drivers/media/platform/qcom/camss-8x16/csid.h |   82 ++
>>   2 files changed, 1154 insertions(+)
>>   create mode 100644 drivers/media/platform/qcom/camss-8x16/csid.c
>>   create mode 100644 drivers/media/platform/qcom/camss-8x16/csid.h
>>
>> diff --git a/drivers/media/platform/qcom/camss-8x16/csid.c b/drivers/media/platform/qcom/camss-8x16/csid.c
>> new file mode 100644
>> index 0000000..c637d78
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/camss-8x16/csid.c
>> @@ -0,0 +1,1072 @@
>> +/*
>> + * csid.c
>> + *
>> + * Qualcomm MSM Camera Subsystem - CSID Module
>> + *
>> + * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
>> + * Copyright (C) 2015-2016 Linaro Ltd.
> 
> 2016 -> 2017
> 
> This should probably be done elsewhere as well.

Yes, I'll fix it here and on all other places.

> 
> Regards,
> 
>     Hans

-- 
Best regards,
Todor Tomov
