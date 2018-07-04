Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39784 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933581AbeGDII1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 04:08:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Jul 2018 13:38:26 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, robh@kernel.org,
        mark.rutland@arm.com, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        acourbot@chromium.org
Subject: Re: [PATCH v2 2/5] media: venus: add a routine to set venus state
In-Reply-To: <be5cc865-608b-dabb-2a3c-b5864c387d64@mm-sol.com>
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-3-git-send-email-vgarodia@codeaurora.org>
 <be5cc865-608b-dabb-2a3c-b5864c387d64@mm-sol.com>
Message-ID: <1b9ba366cc8484e4f2ef1510a8f57b38@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

Thanks for your valuable comments.

On 2018-06-04 19:20, Stanimir Varbanov wrote:
> Hi Vikash,
> 
> Thanks for the patch!
> 
> On  1.06.2018 23:26, Vikash Garodia wrote:
>> Add a new routine which abstracts the TZ call to
> 
> Actually the new routine abstracts Venus CPU state, Isn't it?

Yes, its a Venus CPU state controlled by TZ. I can mention it as
an abstraction of venus CPU state.

>> set the video hardware state.
>> 
>> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
>> ---
>>   drivers/media/platform/qcom/venus/core.h      |  5 +++++
>>   drivers/media/platform/qcom/venus/firmware.c  | 28 
>> +++++++++++++++++++++++++++
>>   drivers/media/platform/qcom/venus/firmware.h  |  1 +
>>   drivers/media/platform/qcom/venus/hfi_venus.c | 13 ++++---------
>>   4 files changed, 38 insertions(+), 9 deletions(-)
>> 
>> diff --git a/drivers/media/platform/qcom/venus/core.h 
>> b/drivers/media/platform/qcom/venus/core.h
>> index 85e66e2..e7bfb63 100644
>> --- a/drivers/media/platform/qcom/venus/core.h
>> +++ b/drivers/media/platform/qcom/venus/core.h
>> @@ -35,6 +35,11 @@ struct reg_val {
>>   	u32 value;
>>   };
>> 
>> +enum tzbsp_video_state {
>> +	TZBSP_VIDEO_SUSPEND = 0,
>> +	TZBSP_VIDEO_RESUME
>> +};
> 
> please move this in firmware.c, for more see below.
> 
>> +
>>   struct venus_resources {
>>   	u64 dma_mask;
>>   	const struct freq_tbl *freq_tbl;
>> diff --git a/drivers/media/platform/qcom/venus/firmware.c 
>> b/drivers/media/platform/qcom/venus/firmware.c
>> index 7d89b5a..b4664ed 100644
>> --- a/drivers/media/platform/qcom/venus/firmware.c
>> +++ b/drivers/media/platform/qcom/venus/firmware.c
>> @@ -53,6 +53,34 @@ static void venus_reset_hw(struct venus_core *core)
>>   	/* Bring Arm9 out of reset */
>>   	writel_relaxed(0, reg_base + WRAPPER_A9SS_SW_RESET);
>>   }
>> +
>> +int venus_set_hw_state(enum tzbsp_video_state state, struct 
>> venus_core *core)
> 
> can we put this function this way:
> 
> venus_set_state(struct venus_core *core, bool on)
> 
> so we set the state to On when we are power-up the venus CPU and Off
> when we power-down.
> 
> by this way we really abstract the state, IMO.

Good point. Will do in similar way.

>> +{
>> +	int ret;
>> +	struct device *dev = core->dev;
>> +	void __iomem *reg_base = core->base;
> 
> just 'base' should be enough.

Infact, comment from Jordan, we can remove it altogether.

>> +
>> +	switch (state) {
>> +	case TZBSP_VIDEO_SUSPEND:
>> +		if (qcom_scm_is_available())
> 
> You really shouldn't rely on this function (see the comment from Bjorn
> on first version of this patch series).
> 
> I think we have to replace qcom_scm_is_available() with some flag which
> is reflecting does the firmware subnode is exist or not. In case it is
> not exist the we have to go with TZ scm calls.

As we discussed, will keep it under the check for a valid firmware 
device.
We can avoid the extra flag in that way.

>> +			ret = qcom_scm_set_remote_state(TZBSP_VIDEO_SUSPEND, 0);
>> +		else
>> +			writel_relaxed(1, reg_base + WRAPPER_A9SS_SW_RESET);
>> +		break;
>> +	case TZBSP_VIDEO_RESUME:
>> +		if (qcom_scm_is_available())
>> +			ret = qcom_scm_set_remote_state(TZBSP_VIDEO_RESUME, 0);
>> +		else
>> +			venus_reset_hw(core);
>> +		break;
>> +	default:
>> +		dev_err(dev, "invalid state\n");
>> +		break;
>> +	}
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(venus_set_hw_state);
>> +
> 
> regards,
> Stan
