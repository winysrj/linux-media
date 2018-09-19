Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:54452 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732122AbeISUiu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 16:38:50 -0400
Received: by mail-it0-f67.google.com with SMTP id f14-v6so8676661ita.4
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 08:00:30 -0700 (PDT)
Subject: Re: [PATCH v9 1/5] venus: firmware: add routine to reset ARM9
To: Alexandre Courbot <acourbot@chromium.org>, vgarodia@codeaurora.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, robh@kernel.org,
        mark.rutland@arm.com, Andy Gross <andy.gross@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <1537314192-26892-1-git-send-email-vgarodia@codeaurora.org>
 <1537314192-26892-2-git-send-email-vgarodia@codeaurora.org>
 <CAPBb6MXMv_TD2dbxyM+D2p3pWfCJpQ-_FHK6WdkAEgBhwTdL6g@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <97b94b9b-f028-cb8b-a3db-67626dc517ab@linaro.org>
Date: Wed, 19 Sep 2018 18:00:27 +0300
MIME-Version: 1.0
In-Reply-To: <CAPBb6MXMv_TD2dbxyM+D2p3pWfCJpQ-_FHK6WdkAEgBhwTdL6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

On 09/19/2018 10:32 AM, Alexandre Courbot wrote:
> On Wed, Sep 19, 2018 at 8:43 AM Vikash Garodia <vgarodia@codeaurora.org> wrote:
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
> 
> Looks like it suggests the absence of trustzone?
> 
> Actually I would rename it as use_tz and set it if TrustZone is used.
> This would avoid double-negative statements like what we see below.

I find this suggestion reasonable.

> 
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
>> index c4a5778..f2ae2f0 100644
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
>> +#define VENUS_FW_START_ADDR            0x0
>> +
>> +static void venus_reset_cpu(struct venus_core *core)
>> +{
>> +       void __iomem *base = core->base;
>> +
>> +       writel(0, base + WRAPPER_FW_START_ADDR);
>> +       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_FW_END_ADDR);
>> +       writel(0, base + WRAPPER_CPA_START_ADDR);
>> +       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_CPA_END_ADDR);
>> +       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_NONPIX_START_ADDR);
>> +       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_NONPIX_END_ADDR);
>> +       writel(0x0, base + WRAPPER_CPU_CGC_DIS);
>> +       writel(0x0, base + WRAPPER_CPU_CLOCK_CONFIG);
>> +
>> +       /* Bring ARM9 out of reset */
>> +       writel(0, base + WRAPPER_A9SS_SW_RESET);
>> +}
>> +
>> +int venus_set_hw_state(struct venus_core *core, bool resume)
>> +{
>> +       if (!core->no_tz)
> 
> This is the kind of double negative statement I was referring do
> above: "if we do not not have TrustZone". Turning it into
> 
>     if (core->use_tz)
> 
> would save the reader a few neurons. :)
> 
>> +               return qcom_scm_set_remote_state(resume, 0);
>> +
>> +       if (resume)
>> +               venus_reset_cpu(core);
>> +       else
>> +               writel(1, core->base + WRAPPER_A9SS_SW_RESET);
>> +
>> +       return 0;
>> +}
>>
>>  int venus_boot(struct device *dev, const char *fwname)
>>  {
>> diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
>> index 428efb5..397570c 100644
>> --- a/drivers/media/platform/qcom/venus/firmware.h
>> +++ b/drivers/media/platform/qcom/venus/firmware.h
>> @@ -18,5 +18,16 @@
>>
>>  int venus_boot(struct device *dev, const char *fwname);
>>  int venus_shutdown(struct device *dev);
>> +int venus_set_hw_state(struct venus_core *core, bool suspend);
>> +
>> +static inline int venus_set_hw_state_suspend(struct venus_core *core)
>> +{
>> +       return venus_set_hw_state(core, false);
>> +}
>> +
>> +static inline int venus_set_hw_state_resume(struct venus_core *core)
>> +{
>> +       return venus_set_hw_state(core, true);
>> +}
> 
> I think these two venus_set_hw_state_suspend() and
> venus_set_hw_state_resume() are superfluous, if you want to make the
> state explicit you can also define an enum { SUSPEND, RESUME } to use
> as argument of venus_set_hw_state() and call it directly.

Infact this was by my request, and I wanted to avoid enum and have the
type of the action in the function name and also avoid one extra
function argument. Of course it is a matter of taste.

-- 
regards,
Stan
