Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37648 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbeJYPzH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Oct 2018 11:55:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Oct 2018 12:53:37 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Tomasz Figa <tfiga@chromium.org>
Cc: mgottam@codeaurora.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        linux-media-owner@vger.kernel.org
Subject: Re: [PATCH v2] media: venus: add support for key frame
In-Reply-To: <CAAFQd5CaYH-kxj+9cquObTHiRyA1VoEYHQmiQAGjdZm6J1ACfg@mail.gmail.com>
References: <1540389162-30358-1-git-send-email-mgottam@codeaurora.org>
 <CAAFQd5CaYH-kxj+9cquObTHiRyA1VoEYHQmiQAGjdZm6J1ACfg@mail.gmail.com>
Message-ID: <86344762e1eeab8fe8a940a1bfffa2c1@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-10-24 20:02, Tomasz Figa wrote:
> On Wed, Oct 24, 2018 at 10:52 PM Malathi Gottam 
> <mgottam@codeaurora.org> wrote:
>> 
>> When client requests for a keyframe, set the property
>> to hardware to generate the sync frame.
>> 
>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
>> ---
>>  drivers/media/platform/qcom/venus/venc_ctrls.c | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c 
>> b/drivers/media/platform/qcom/venus/venc_ctrls.c
>> index 45910172..6c2655d 100644
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
>> @@ -173,6 +175,15 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>> 
>>                 ctr->num_b_frames = bframes;
>>                 break;
>> +       case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
>> +               if (inst->streamon_out && inst->streamon_cap) {
>> +                       ptype = 
>> HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME;
>> +                       ret = hfi_session_set_property(inst, ptype, 
>> &en);
>> +
>> +                       if (ret)
>> +                               return ret;
>> +               }
>> +               break;
> 
> This is still not the right way to handle this.
> 
> Please see the documentation of this control [1]:
> 
> "V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME (button)
> Force a key frame for the next queued buffer. Applicable to encoders.
> This is a general, codec-agnostic keyframe control."
> 
> Even if the driver is not streaming, it must remember that the
> keyframe was requested for next buffer. The next time userspace QBUFs
> an OUTPUT buffer, it should ask the hardware to encode that OUTPUT
> buffer into a keyframe.

That's correct. Driver can cache the client request and set it when the 
hardware
is capable of accepting the property.
Still the issue having the requested OUTPUT buffer to be encoded as sync 
frame will
be there. If there are few frames queued before streamon, driver will 
only keep a
note that it has to set the request for keyframe, but not the exact one 
which was
requested.

> [1]
> https://www.kernel.org/doc/html/latest/media/uapi/v4l/extended-controls.html?highlight=v4l2_cid_mpeg_video_force_key_frame
> 
> But generally, the proper modern way for the userspace to request a
> keyframe is to set the V4L2_BUF_FLAG_KEYFRAME flag in the
> vb2_buffer_flag when queuing an OUTPUT buffer. It's the only
> guaranteed way to ensure that the keyframe will be encoded exactly for
> the selected frame. (The V4L2 control API doesn't guarantee any
> synchronization between controls and buffers itself.)

This is a better way to handle it to ensure exact buffer gets encoded as 
sync frame.

> Best regards,
> Tomasz
