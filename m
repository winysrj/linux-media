Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39022 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbeHXQJa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 12:09:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 24 Aug 2018 18:05:00 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, robh@kernel.org,
        mark.rutland@arm.com, Andy Gross <andy.gross@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-media-owner@vger.kernel.org
Subject: Re: [PATCH v6 1/4] venus: firmware: add routine to reset ARM9
In-Reply-To: <51cc9d6b-0483-76a6-d413-3f5cc63f3f56@linaro.org>
References: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org>
 <1535034528-11590-2-git-send-email-vgarodia@codeaurora.org>
 <CAPBb6MUZawT84Wcrhi+MEyn+zSCWOpn_iOZMMudZz+_Urixsrw@mail.gmail.com>
 <51cc9d6b-0483-76a6-d413-3f5cc63f3f56@linaro.org>
Message-ID: <d6661f5a8f6c64b017dad5b7b8000042@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-08-24 14:27, Stanimir Varbanov wrote:
> Hi Alex,
> 
> On 08/24/2018 10:38 AM, Alexandre Courbot wrote:
>> On Thu, Aug 23, 2018 at 11:29 PM Vikash Garodia 
>> <vgarodia@codeaurora.org> wrote:
>>> 

[snip]

>>> index c4a5778..a9d042e 100644
>>> --- a/drivers/media/platform/qcom/venus/firmware.c
>>> +++ b/drivers/media/platform/qcom/venus/firmware.c
>>> @@ -22,10 +22,43 @@
>>>  #include <linux/sizes.h>
>>>  #include <linux/soc/qcom/mdt_loader.h>
>>> 
>>> +#include "core.h"
>>>  #include "firmware.h"
>>> +#include "hfi_venus_io.h"
>>> 
>>>  #define VENUS_PAS_ID                   9
>>>  #define VENUS_FW_MEM_SIZE              (6 * SZ_1M)
>> 
>> This is making a strong assumption about the size of the FW memory
>> region, which in practice is not always true (I had to reduce it to
>> 5MB). How about having this as a member of venus_core, which is
> 
> Why you reduced to 5MB? Is there an issue with 6MB or you don't want to
> waste reserved memory?
> 
>> initialized in venus_load_fw() from the actual size of the memory
>> region? You could do this as an extra patch that comes before this
>> one.

I would go with existing design than relying on the size specified in 
the
memory-region for venus. size loaded is always taken from DT while the
VENUS_FW_MEM_SIZE serves the purpose of sanity check.

> The size is 6MB by historical reasons and they are no more valid, so I
> think we could safely decrease to 5MB. I could prepare a patch for 
> that.

Thanks Stan. Initial patch in this series had 5MB. We discussed earlier 
to keep
it as is and take it as a separate patch to update from 6MB to 5MB.
