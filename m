Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35710 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbeHXMbh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 08:31:37 -0400
Received: by mail-wm0-f67.google.com with SMTP id o18-v6so906348wmc.0
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 01:57:56 -0700 (PDT)
Subject: Re: [PATCH v6 1/4] venus: firmware: add routine to reset ARM9
To: Alexandre Courbot <acourbot@chromium.org>, vgarodia@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, robh@kernel.org,
        mark.rutland@arm.com, Andy Gross <andy.gross@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org>
 <1535034528-11590-2-git-send-email-vgarodia@codeaurora.org>
 <CAPBb6MUZawT84Wcrhi+MEyn+zSCWOpn_iOZMMudZz+_Urixsrw@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <51cc9d6b-0483-76a6-d413-3f5cc63f3f56@linaro.org>
Date: Fri, 24 Aug 2018 11:57:52 +0300
MIME-Version: 1.0
In-Reply-To: <CAPBb6MUZawT84Wcrhi+MEyn+zSCWOpn_iOZMMudZz+_Urixsrw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

On 08/24/2018 10:38 AM, Alexandre Courbot wrote:
> On Thu, Aug 23, 2018 at 11:29 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>>
>> Add routine to reset the ARM9 and brings it out of reset. Also
>> abstract the Venus CPU state handling with a new function. This
>> is in preparation to add PIL functionality in venus driver.
>>
>> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
>> ---
>>  drivers/media/platform/qcom/venus/core.h         |  2 ++
>>  drivers/media/platform/qcom/venus/firmware.c     | 33 ++++++++++++++++++++++++
>>  drivers/media/platform/qcom/venus/firmware.h     | 11 ++++++++
>>  drivers/media/platform/qcom/venus/hfi_venus.c    | 13 +++-------
>>  drivers/media/platform/qcom/venus/hfi_venus_io.h |  7 +++++
>>  5 files changed, 57 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
>> index 2f02365..dfd5c10 100644
>> --- a/drivers/media/platform/qcom/venus/core.h
>> +++ b/drivers/media/platform/qcom/venus/core.h
>> @@ -98,6 +98,7 @@ struct venus_caps {
>>   * @dev:               convenience struct device pointer
>>   * @dev_dec:   convenience struct device pointer for decoder device
>>   * @dev_enc:   convenience struct device pointer for encoder device
>> + * @no_tz:     a flag that suggests presence of trustzone
>>   * @lock:      a lock for this strucure
>>   * @instances: a list_head of all instances
>>   * @insts_count:       num of instances
>> @@ -129,6 +130,7 @@ struct venus_core {
>>         struct device *dev;
>>         struct device *dev_dec;
>>         struct device *dev_enc;
>> +       bool no_tz;
>>         struct mutex lock;
>>         struct list_head instances;
>>         atomic_t insts_count;
>> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
>> index c4a5778..a9d042e 100644
>> --- a/drivers/media/platform/qcom/venus/firmware.c
>> +++ b/drivers/media/platform/qcom/venus/firmware.c
>> @@ -22,10 +22,43 @@
>>  #include <linux/sizes.h>
>>  #include <linux/soc/qcom/mdt_loader.h>
>>
>> +#include "core.h"
>>  #include "firmware.h"
>> +#include "hfi_venus_io.h"
>>
>>  #define VENUS_PAS_ID                   9
>>  #define VENUS_FW_MEM_SIZE              (6 * SZ_1M)
> 
> This is making a strong assumption about the size of the FW memory
> region, which in practice is not always true (I had to reduce it to
> 5MB). How about having this as a member of venus_core, which is

Why you reduced to 5MB? Is there an issue with 6MB or you don't want to
waste reserved memory?

> initialized in venus_load_fw() from the actual size of the memory
> region? You could do this as an extra patch that comes before this
> one.
> 

The size is 6MB by historical reasons and they are no more valid, so I
think we could safely decrease to 5MB. I could prepare a patch for that.

-- 
regards,
Stan
