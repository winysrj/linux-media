Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37020 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbeJVUWm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 16:22:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 22 Oct 2018 17:34:25 +0530
From: mgottam@codeaurora.org
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
Subject: Re: [PATCH] media: venus: handle peak bitrate set property
In-Reply-To: <274a112a-604c-82b4-130a-c3718abcf141@linaro.org>
References: <1539071483-1371-1-git-send-email-mgottam@codeaurora.org>
 <274a112a-604c-82b4-130a-c3718abcf141@linaro.org>
Message-ID: <1c2db4af132609460b1cf6cf0c25a024@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-10-09 20:29, Stanimir Varbanov wrote:
> Hi Malathi,
> 
> Thanks for the patch!
> 
> On 10/09/2018 10:51 AM, Malathi Gottam wrote:
>> Max bitrate property is not supported for venus version 4xx.
>> Add a version check for the same.
> 
> I'd like to avoid version checks in this layer of the driver. Could 
> just
> black-list this property in pkt_session_set_property_4xx? Hint, see
> HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE in the same function.
> 
>> 
>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
>> ---
>>  drivers/media/platform/qcom/venus/venc.c | 22 ++++++++++++----------
>>  1 file changed, 12 insertions(+), 10 deletions(-)
>> 
>> diff --git a/drivers/media/platform/qcom/venus/venc.c 
>> b/drivers/media/platform/qcom/venus/venc.c
>> index ef11495..3f50cd0 100644
>> --- a/drivers/media/platform/qcom/venus/venc.c
>> +++ b/drivers/media/platform/qcom/venus/venc.c
>> @@ -757,18 +757,20 @@ static int venc_set_properties(struct venus_inst 
>> *inst)
>>  	if (ret)
>>  		return ret;
>> 
>> -	if (!ctr->bitrate_peak)
>> -		bitrate *= 2;
>> -	else
>> -		bitrate = ctr->bitrate_peak;
>> +	if (!IS_V4(inst->core)) {
>> +		if (!ctr->bitrate_peak)
>> +			bitrate *= 2;
>> +		else
>> +			bitrate = ctr->bitrate_peak;
>> 
>> -	ptype = HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE;
>> -	brate.bitrate = bitrate;
>> -	brate.layer_id = 0;
>> +		ptype = HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE;
>> +		brate.bitrate = bitrate;
>> +		brate.layer_id = 0;
>> 
>> -	ret = hfi_session_set_property(inst, ptype, &brate);
>> -	if (ret)
>> -		return ret;
>> +		ret = hfi_session_set_property(inst, ptype, &brate);
>> +		if (ret)
>> +			return ret;
>> +	}
>> 
>>  	if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_H264) {
>>  		profile = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_H264_PROFILE,
>> 
Hi Stan,

Though this property is bypassed in the function 
"pkt_session_set_property_4xx", it is set to firmware in hfi_venus 
layer.

So we can return -ENOTSUPP from packet layer. If hfi_venus layer 
receives error as ENOTSUPP, treat it as normal and return 0 to venc 
layer.

I will post the updated patch, with this implementation.
