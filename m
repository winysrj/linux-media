Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39716 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbeKAWNb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 18:13:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Nov 2018 18:40:35 +0530
From: mgottam@codeaurora.org
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
Subject: Re: [PATCH] media: venus: add support for selection rectangles
In-Reply-To: <0e0f689e-f6e3-73a6-e145-deb2ef7cafc8@linaro.org>
References: <1539071603-1588-1-git-send-email-mgottam@codeaurora.org>
 <0e0f689e-f6e3-73a6-e145-deb2ef7cafc8@linaro.org>
Message-ID: <5037ca4b0dd0de80750e35ca889d4225@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-10-16 15:11, Stanimir Varbanov wrote:
> Hi Malathi,
> 
> On 10/09/2018 10:53 AM, Malathi Gottam wrote:
>> Handles target type crop by setting the new active rectangle
>> to hardware. The new rectangle should be within YUV size.
>> 
>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
>> ---
>>  drivers/media/platform/qcom/venus/venc.c | 19 +++++++++++++++++--
>>  1 file changed, 17 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/media/platform/qcom/venus/venc.c 
>> b/drivers/media/platform/qcom/venus/venc.c
>> index 3f50cd0..754c19a 100644
>> --- a/drivers/media/platform/qcom/venus/venc.c
>> +++ b/drivers/media/platform/qcom/venus/venc.c
>> @@ -478,16 +478,31 @@ static int venc_g_fmt(struct file *file, void 
>> *fh, struct v4l2_format *f)
>>  venc_s_selection(struct file *file, void *fh, struct v4l2_selection 
>> *s)
>>  {
>>  	struct venus_inst *inst = to_inst(file);
>> +	int ret;
>> +	u32 buftype;
>> 
>>  	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
>>  		return -EINVAL;
>> 
>>  	switch (s->target) {
>>  	case V4L2_SEL_TGT_CROP:
>> -		if (s->r.width != inst->out_width ||
>> -		    s->r.height != inst->out_height ||
>> +		if (s->r.width > inst->out_width ||
>> +		    s->r.height > inst->out_height ||
>>  		    s->r.top != 0 || s->r.left != 0)
>>  			return -EINVAL;
>> +		if (s->r.width != inst->width ||
>> +		    s->r.height != inst->height) {
>> +			buftype = HFI_BUFFER_OUTPUT;
>> +			ret = venus_helper_set_output_resolution(inst,
>> +								 s->r.width,
>> +								 s->r.height,
>> +								 buftype);
> 
> I'm afraid that set_output_resolution cannot be called at any time. Do
> you think we can set it after start_session?

Yes Stan, we can set output_resolution after the session has been 
initialization.
As per the spec, this call s_selection is an optional step under 
Initialization
procedure of encoder even before we request buffers.

So I think setting output resolution in this api shouldn't cause any 
issue once
we are confident on the instance state.
