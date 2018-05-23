Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58868 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753866AbeEWFbA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 01:31:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 23 May 2018 11:00:59 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, acourbot@google.com,
        linux-media-owner@vger.kernel.org
Subject: Re: [PATCH 3/4] venus: add check to make scm calls
In-Reply-To: <f9f99014-526d-d23b-6eaf-c04e45bef10a@linaro.org>
References: <1526556740-25494-1-git-send-email-vgarodia@codeaurora.org>
 <1526556740-25494-4-git-send-email-vgarodia@codeaurora.org>
 <9d5e12b1-40bd-adab-05f0-bdb209bf0174@linaro.org>
 <20180522195026.GA16550@jcrouse-lnx.qualcomm.com>
 <f9f99014-526d-d23b-6eaf-c04e45bef10a@linaro.org>
Message-ID: <7ec3133c8fd5599ca3cb538cddf846c4@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stan,

On 2018-05-23 02:27, Stanimir Varbanov wrote:
> Hi Jordan,
> 
> On 22.05.2018 22:50, Jordan Crouse wrote:
>> On Tue, May 22, 2018 at 04:04:51PM +0300, Stanimir Varbanov wrote:
>>> Hi Vikash,
>>> 
>>> On 05/17/2018 02:32 PM, Vikash Garodia wrote:
>>>> In order to invoke scm calls, ensure that the platform
>>>> has the required support to invoke the scm calls in
>>>> secure world. This code is in preparation to add PIL
>>>> functionality in venus driver.
>>>> 
>>>> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
>>>> ---
>>>>   drivers/media/platform/qcom/venus/hfi_venus.c | 26 
>>>> +++++++++++++++++++-------
>>>>   1 file changed, 19 insertions(+), 7 deletions(-)
>>>> 
>>>> diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c 
>>>> b/drivers/media/platform/qcom/venus/hfi_venus.c
>>>> index f61d34b..9bcce94 100644
>>>> --- a/drivers/media/platform/qcom/venus/hfi_venus.c
>>>> +++ b/drivers/media/platform/qcom/venus/hfi_venus.c
>>>> @@ -27,6 +27,7 @@
>>>>   #include "hfi_msgs.h"
>>>>   #include "hfi_venus.h"
>>>>   #include "hfi_venus_io.h"
>>>> +#include "firmware.h"
>>>>     #define HFI_MASK_QHDR_TX_TYPE		0xff000000
>>>>   #define HFI_MASK_QHDR_RX_TYPE		0x00ff0000
>>>> @@ -570,13 +571,19 @@ static int venus_halt_axi(struct 
>>>> venus_hfi_device *hdev)
>>>>   static int venus_power_off(struct venus_hfi_device *hdev)
>>>>   {
>>>>   	int ret;
>>>> +	void __iomem *reg_base;
>>>>     	if (!hdev->power_enabled)
>>>>   		return 0;
>>>>   -	ret = qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_SUSPEND, 0);
>>>> -	if (ret)
>>>> -		return ret;
>>>> +	if (qcom_scm_is_available()) {
>>>> +		ret = qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_SUSPEND, 0);
>>> 
>>> I think it will be clearer if we abstract qcom_scm_set_remote_state 
>>> to
>>> something like venus_set_state(SUSPEND|RESUME) in firmware.c and 
>>> export
>>> the functions to be used here.
>> 
>> This specific function is a little odd because the SCM function got 
>> overloaded
>> and used as a hardware workaround for the adreno a5xx zap shader.
>> 
>> When we added it for the GPU we knew the day would come that we would 
>> need it
>> for Venus so we kept the name purposely generic. You can wrap if if 
>> you want
>> but just know that there are other non video entities out there using 
>> it.
> 
> Sorry I wasn't clear, by abstract it I meant to introduce a new
> venus_set_state function in venus/firmware.c where we'll select
> tz/non-tz functions for suspend / resume depending on the
> configuration.

Yes, that's a good idea to abstract the decision to use tz or non-tz way 
as much
as possible to firmware.c. Will add this in my next patch.

> regards,
> Stan
