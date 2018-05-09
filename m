Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:39917 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933783AbeEIIP2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 04:15:28 -0400
Received: by mail-wm0-f41.google.com with SMTP id f8-v6so26004026wmc.4
        for <linux-media@vger.kernel.org>; Wed, 09 May 2018 01:15:27 -0700 (PDT)
Subject: Re: [PATCH 10/28] venus: vdec: call session_continue in insufficient
 event
To: Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-media-owner@vger.kernel.org
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
 <20180424124436.26955-11-stanimir.varbanov@linaro.org>
 <85963ca3e12f4d71f2bc2db7d601d4b2@codeaurora.org>
 <c349eca0-2227-75f3-111c-9980336896d1@linaro.org>
 <5cfb0fc9e54763712799e9adf5770dac@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <4c66fc5c-87fb-3c0e-06c1-6e5c23bc138c@linaro.org>
Date: Wed, 9 May 2018 11:15:23 +0300
MIME-Version: 1.0
In-Reply-To: <5cfb0fc9e54763712799e9adf5770dac@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On 05/04/2018 02:09 PM, Vikash Garodia wrote:
> Hi Stanimir,
> 
> On 2018-05-03 17:06, Stanimir Varbanov wrote:
>> Hi Vikash,
>>
>> Thanks for the comments!
>>
>> On  2.05.2018 09:26, Vikash Garodia wrote:
>>> Hello Stanimir,
>>>
>>> On 2018-04-24 18:14, Stanimir Varbanov wrote:
>>>> Call session_continue for Venus 4xx version even when the event
>>>> says that the buffer resources are not sufficient. Leaving a
>>>> comment with more information about the workaround.
>>>>
>>>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>>>> ---
>>>>  drivers/media/platform/qcom/venus/vdec.c | 8 ++++++++
>>>>  1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/drivers/media/platform/qcom/venus/vdec.c
>>>> b/drivers/media/platform/qcom/venus/vdec.c
>>>> index c45452634e7e..91c7384ff9c8 100644
>>>> --- a/drivers/media/platform/qcom/venus/vdec.c
>>>> +++ b/drivers/media/platform/qcom/venus/vdec.c
>>>> @@ -873,6 +873,14 @@ static void vdec_event_notify(struct venus_inst
>>>> *inst, u32 event,
>>>>
>>>>              dev_dbg(dev, "event not sufficient resources (%ux%u)\n",
>>>>                  data->width, data->height);
>>>> +            /*
>>>> +             * Workaround: Even that the firmware send and event for
>>>> +             * insufficient buffer resources it is safe to call
>>>> +             * session_continue because actually the event says that
>>>> +             * the number of capture buffers is lower.
>>>> +             */
>>>> +            if (IS_V4(core))
>>>> +                hfi_session_continue(inst);
>>>>              break;
>>>>          case HFI_EVENT_RELEASE_BUFFER_REFERENCE:
>>>>              venus_helper_release_buf_ref(inst, data->tag);
>>>
>>> Insufficient event from video firmware could be sent either,
>>> 1. due to insufficient buffer resources
>>> 2. due to lower capture buffers
>>>
>>> It cannot be assumed that the event received by the host is due to
>>> lower capture
>>> buffers. Incase the buffer resource is insufficient, let say there is
>>> a bitstream
>>> resolution switch from 720p to 1080p, capture buffers needs to be
>>> reallocated.
>>
>> I agree with you. I will rework this part and call session_continue
>> only for case #2.
> 
> Even if the capture buffers are lower, driver should consider
> reallocation of capture
> buffers with required higher count. Without this, it may happen that for
> a given video
> frame, the decoded output will not be generated.

Thanks for the comments, I realized that this workaround is not needed
anymore, so I will drop the patch.

-- 
regards,
Stan
