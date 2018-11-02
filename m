Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46134 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbeKBVko (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 17:40:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Nov 2018 18:03:39 +0530
From: mgottam@codeaurora.org
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Tomasz Figa <tfiga@chromium.org>, vgarodia@codeaurora.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        linux-media-owner@vger.kernel.org
Subject: Re: [PATCH] media: venus: dynamic handling of bitrate
In-Reply-To: <19a08bd3-4e4c-56d2-6df2-54c3d91af4f3@linaro.org>
References: <1540971728-26789-1-git-send-email-mgottam@codeaurora.org>
 <3ff2c3dd-434d-960b-6806-f4bb8ec0d954@linaro.org>
 <3364115421e89c7710725c06b820f8c6@codeaurora.org>
 <CAAFQd5A+9GWmn4aD4D2JMf1e1m-6Dtc3xUdMZsf8fPtgi34QVQ@mail.gmail.com>
 <ba1453b6868e97b96e0345129153b819@codeaurora.org>
 <CAAFQd5DuEqTiJbp5wR=_V0zVkVXTJPuMxDaJoTYFvVYfUA8U8g@mail.gmail.com>
 <19a08bd3-4e4c-56d2-6df2-54c3d91af4f3@linaro.org>
Message-ID: <40ae496b61880e747df9f19409ab26c0@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-11-01 20:33, Stanimir Varbanov wrote:
> On 11/1/18 4:31 PM, Tomasz Figa wrote:
>> On Thu, Nov 1, 2018 at 11:23 PM Vikash Garodia 
>> <vgarodia@codeaurora.org> wrote:
>>> 
>>> On 2018-11-01 19:23, Tomasz Figa wrote:
>>>> On Thu, Nov 1, 2018 at 10:01 PM <mgottam@codeaurora.org> wrote:
>>>>> 
>>>>> On 2018-11-01 17:48, Stanimir Varbanov wrote:
>>>>>> Hi Malathi,
>>>>>> 
>>>>>> Thanks for the patch!
>>>>>> 
>>>>>> On 10/31/18 9:42 AM, Malathi Gottam wrote:
>>>>>>> Any request for a change in bitrate after both planes
>>>>>>> are streamed on is handled by setting the target bitrate
>>>>>>> property to hardware.
>>>>>>> 
>>>>>>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
>>>>>>> ---
>>>>>>>  drivers/media/platform/qcom/venus/venc_ctrls.c | 11 +++++++++++
>>>>>>>  1 file changed, 11 insertions(+)
>>>>>>> 
>>>>>>> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c
>>>>>>> b/drivers/media/platform/qcom/venus/venc_ctrls.c
>>>>>>> index 45910172..54f310c 100644
>>>>>>> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
>>>>>>> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
>>>>>>> @@ -79,7 +79,9 @@ static int venc_op_s_ctrl(struct v4l2_ctrl 
>>>>>>> *ctrl)
>>>>>>>  {
>>>>>>>      struct venus_inst *inst = ctrl_to_inst(ctrl);
>>>>>>>      struct venc_controls *ctr = &inst->controls.enc;
>>>>>>> +    struct hfi_bitrate brate;
>>>>>>>      u32 bframes;
>>>>>>> +    u32 ptype;
>>>>>>>      int ret;
>>>>>>> 
>>>>>>>      switch (ctrl->id) {
>>>>>>> @@ -88,6 +90,15 @@ static int venc_op_s_ctrl(struct v4l2_ctrl 
>>>>>>> *ctrl)
>>>>>>>              break;
>>>>>>>      case V4L2_CID_MPEG_VIDEO_BITRATE:
>>>>>>>              ctr->bitrate = ctrl->val;
>>>>>>> +            if (inst->streamon_out && inst->streamon_cap) {
>>>>>> 
>>>>>> Hmm, hfi_session_set_property already checks the instance state so 
>>>>>> I
>>>>>> don't think those checks are needed. Another thing is that we need 
>>>>>> to
>>>>>> take the instance mutex to check the instance state.
>>>>> 
>>>>> Yes Stan, "hfi_session_set_property" this property check the 
>>>>> instance
>>>>> state,
>>>>> but returns EINVAL if this is set at UNINIT instance state.
>>>>> 
>>>>> Controls initialization happens much earlier than session init and
>>>>> instance init.
>>>>> So the instance is still in UNINIT state which causes failure while
>>>>> setting.
>>>>> 
>>>>> Through this patch we try to meet the client request of changing
>>>>> bitrate
>>>>> only
>>>>> when both planes are streamed on.
>>>> 
>>>> Where does this requirement come from? It should be possible to set
>>>> the control at any time and it should apply to any encoding 
>>>> happening
>>>> after the control is set.
>>>> 
>>> With the patch, now video driver will set the control whenever client
>>> sets
>>> and will apply to encoder.
>> 
>> That's good, thanks for clarifying. I guess I misunderstood Malathi's 
>> comment.
> 
> OK, just wonder about locking when we check streamon_out/cap flags?

Yes Stan, I agree that we should add an instance lock for these flags 
check.
Posting the updated patch. Please review.
