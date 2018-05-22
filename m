Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36114 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753081AbeEVU54 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 16:57:56 -0400
Received: by mail-wm0-f66.google.com with SMTP id n10-v6so3440518wmc.1
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 13:57:56 -0700 (PDT)
Subject: Re: [PATCH 3/4] venus: add check to make scm calls
To: Vikash Garodia <vgarodia@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, acourbot@google.com
References: <1526556740-25494-1-git-send-email-vgarodia@codeaurora.org>
 <1526556740-25494-4-git-send-email-vgarodia@codeaurora.org>
 <9d5e12b1-40bd-adab-05f0-bdb209bf0174@linaro.org>
 <20180522195026.GA16550@jcrouse-lnx.qualcomm.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <f9f99014-526d-d23b-6eaf-c04e45bef10a@linaro.org>
Date: Tue, 22 May 2018 23:57:53 +0300
MIME-Version: 1.0
In-Reply-To: <20180522195026.GA16550@jcrouse-lnx.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jordan,

On 22.05.2018 22:50, Jordan Crouse wrote:
> On Tue, May 22, 2018 at 04:04:51PM +0300, Stanimir Varbanov wrote:
>> Hi Vikash,
>>
>> On 05/17/2018 02:32 PM, Vikash Garodia wrote:
>>> In order to invoke scm calls, ensure that the platform
>>> has the required support to invoke the scm calls in
>>> secure world. This code is in preparation to add PIL
>>> functionality in venus driver.
>>>
>>> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
>>> ---
>>>   drivers/media/platform/qcom/venus/hfi_venus.c | 26 +++++++++++++++++++-------
>>>   1 file changed, 19 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
>>> index f61d34b..9bcce94 100644
>>> --- a/drivers/media/platform/qcom/venus/hfi_venus.c
>>> +++ b/drivers/media/platform/qcom/venus/hfi_venus.c
>>> @@ -27,6 +27,7 @@
>>>   #include "hfi_msgs.h"
>>>   #include "hfi_venus.h"
>>>   #include "hfi_venus_io.h"
>>> +#include "firmware.h"
>>>   
>>>   #define HFI_MASK_QHDR_TX_TYPE		0xff000000
>>>   #define HFI_MASK_QHDR_RX_TYPE		0x00ff0000
>>> @@ -570,13 +571,19 @@ static int venus_halt_axi(struct venus_hfi_device *hdev)
>>>   static int venus_power_off(struct venus_hfi_device *hdev)
>>>   {
>>>   	int ret;
>>> +	void __iomem *reg_base;
>>>   
>>>   	if (!hdev->power_enabled)
>>>   		return 0;
>>>   
>>> -	ret = qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_SUSPEND, 0);
>>> -	if (ret)
>>> -		return ret;
>>> +	if (qcom_scm_is_available()) {
>>> +		ret = qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_SUSPEND, 0);
>>
>> I think it will be clearer if we abstract qcom_scm_set_remote_state to
>> something like venus_set_state(SUSPEND|RESUME) in firmware.c and export
>> the functions to be used here.
> 
> This specific function is a little odd because the SCM function got overloaded
> and used as a hardware workaround for the adreno a5xx zap shader.
> 
> When we added it for the GPU we knew the day would come that we would need it
> for Venus so we kept the name purposely generic. You can wrap if if you want
> but just know that there are other non video entities out there using it.

Sorry I wasn't clear, by abstract it I meant to introduce a new 
venus_set_state function in venus/firmware.c where we'll select 
tz/non-tz functions for suspend / resume depending on the configuration.

regards,
Stan
