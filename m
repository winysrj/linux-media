Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36078 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbeKAWEm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 18:04:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Nov 2018 18:31:48 +0530
From: mgottam@codeaurora.org
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
Subject: Re: [PATCH] media: venus: dynamic handling of bitrate
In-Reply-To: <3ff2c3dd-434d-960b-6806-f4bb8ec0d954@linaro.org>
References: <1540971728-26789-1-git-send-email-mgottam@codeaurora.org>
 <3ff2c3dd-434d-960b-6806-f4bb8ec0d954@linaro.org>
Message-ID: <3364115421e89c7710725c06b820f8c6@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-11-01 17:48, Stanimir Varbanov wrote:
> Hi Malathi,
> 
> Thanks for the patch!
> 
> On 10/31/18 9:42 AM, Malathi Gottam wrote:
>> Any request for a change in bitrate after both planes
>> are streamed on is handled by setting the target bitrate
>> property to hardware.
>> 
>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
>> ---
>>  drivers/media/platform/qcom/venus/venc_ctrls.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>> 
>> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c 
>> b/drivers/media/platform/qcom/venus/venc_ctrls.c
>> index 45910172..54f310c 100644
>> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
>> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
>> @@ -79,7 +79,9 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>>  {
>>  	struct venus_inst *inst = ctrl_to_inst(ctrl);
>>  	struct venc_controls *ctr = &inst->controls.enc;
>> +	struct hfi_bitrate brate;
>>  	u32 bframes;
>> +	u32 ptype;
>>  	int ret;
>> 
>>  	switch (ctrl->id) {
>> @@ -88,6 +90,15 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>>  		break;
>>  	case V4L2_CID_MPEG_VIDEO_BITRATE:
>>  		ctr->bitrate = ctrl->val;
>> +		if (inst->streamon_out && inst->streamon_cap) {
> 
> Hmm, hfi_session_set_property already checks the instance state so I
> don't think those checks are needed. Another thing is that we need to
> take the instance mutex to check the instance state.

Yes Stan, "hfi_session_set_property" this property check the instance 
state,
but returns EINVAL if this is set at UNINIT instance state.

Controls initialization happens much earlier than session init and 
instance init.
So the instance is still in UNINIT state which causes failure while 
setting.

Through this patch we try to meet the client request of changing bitrate 
only
when both planes are streamed on.

We have two ways to handle it
1. The way in this patch checks the planes state which will definitely 
ensure
    instance is in START state.
2. Have a check to ensure that instance is atleast Initialized.

I hope the first proposal is good enough for meeting requirement.

> 
>> +			ptype = HFI_PROPERTY_CONFIG_VENC_TARGET_BITRATE;
>> +			brate.bitrate = ctr->bitrate;
>> +			brate.layer_id = 0;
>> +
>> +			ret = hfi_session_set_property(inst, ptype, &brate);
>> +			if (ret)
>> +				return ret;
>> +		}
>>  		break;
>>  	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
>>  		ctr->bitrate_peak = ctrl->val;
>> 
