Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44206 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbeK1XlS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 18:41:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Nov 2018 18:09:45 +0530
From: mgottam@codeaurora.org
To: Tomasz Figa <tfiga@chromium.org>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        vgarodia@codeaurora.org
Subject: Re: [PATCH v3] media: venus: add support for key frame
In-Reply-To: <CAAFQd5D=hNdkEovonE6GOaYvq9dBbQwSZ=95V9a80e-sLp7cYg@mail.gmail.com>
References: <1541163476-23249-1-git-send-email-mgottam@codeaurora.org>
 <CAAFQd5D=hNdkEovonE6GOaYvq9dBbQwSZ=95V9a80e-sLp7cYg@mail.gmail.com>
Message-ID: <702e222691accc7d92263a7265391b5f@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-11-03 08:31, Tomasz Figa wrote:
> Hi Malathi,
> 
> On Fri, Nov 2, 2018 at 9:58 PM Malathi Gottam <mgottam@codeaurora.org> 
> wrote:
>> 
>> When client requests for a keyframe, set the property
>> to hardware to generate the sync frame.
>> 
>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
>> ---
>>  drivers/media/platform/qcom/venus/venc_ctrls.c | 20 
>> +++++++++++++++++++-
>>  1 file changed, 19 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c 
>> b/drivers/media/platform/qcom/venus/venc_ctrls.c
>> index 45910172..59fe7fc 100644
>> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
>> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
>> @@ -79,8 +79,10 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>>  {
>>         struct venus_inst *inst = ctrl_to_inst(ctrl);
>>         struct venc_controls *ctr = &inst->controls.enc;
>> +       struct hfi_enable en = { .enable = 1 };
>>         u32 bframes;
>>         int ret;
>> +       u32 ptype;
>> 
>>         switch (ctrl->id) {
>>         case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
>> @@ -173,6 +175,19 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>> 
>>                 ctr->num_b_frames = bframes;
>>                 break;
>> +       case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
>> +               mutex_lock(&inst->lock);
>> +               if (inst->streamon_out && inst->streamon_cap) {
> 
> We had a discussion on this in v2. I don't remember seeing any 
> conclusion.
> 
> Obviously the hardware should generate a keyframe naturally when the
> CAPTURE streaming starts, which is where the encoding starts, but the
> state of the OUTPUT queue should not affect this.
> 
> The application is free to stop and start streaming on the OUTPUT
> queue as it goes and it shouldn't imply any side effects in the
> encoded bitstream (e.g. a keyframe inserted). So:
> - a sequence of STREAMOFF(OUTPUT),
> S_CTRL(V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME), STREAMON(OUTPUT) should
> explicitly generate a keyframe,
> - a sequence of STREAMOFF(OUTPUT), STREAMON(OUTPUT) should _not_
> explicitly generate a keyframe (the hardware may generate one, if the
> periodic keyframe counter is active or a scene detection algorithm
> decides so).
> 
> Please refer to the specification (v2 is the latest for the time being
> -> https://lore.kernel.org/patchwork/patch/1002476/) for further
> details and feel free to leave any comment for it.
> 
> Best regards,
> Tomasz

Gentle reminder!!

Stan, please provide your view on this.

Thanks,
Malathi.
