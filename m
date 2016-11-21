Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35225 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932262AbcKUQRG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 11:17:06 -0500
Received: by mail-wm0-f41.google.com with SMTP id a197so155908701wmd.0
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2016 08:17:06 -0800 (PST)
Subject: Re: [PATCH v3 4/9] media: venus: vdec: add video decoder files
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-5-git-send-email-stanimir.varbanov@linaro.org>
 <63a91a5a-a97b-f3df-d16d-c8f76bf20c30@xs4all.nl>
 <4ec31084-1720-845a-30f6-60ddfe285ff1@linaro.org>
 <86442d1d-4a12-71c1-97fa-12bc73bb5045@linaro.org>
 <9ff4f3cf-f6d1-cebe-6f1a-e4209c55e4f4@xs4all.nl>
 <15975057-dd6a-6946-07ac-93a748b6a176@linaro.org>
 <aed4a795-3abe-2d5a-abc4-c638cd4f4d61@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <113772f1-8eb9-dd44-42c6-4f109200dff7@linaro.org>
Date: Mon, 21 Nov 2016 18:09:53 +0200
MIME-Version: 1.0
In-Reply-To: <aed4a795-3abe-2d5a-abc4-c638cd4f4d61@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/21/2016 05:33 PM, Hans Verkuil wrote:
> On 21/11/16 16:29, Stanimir Varbanov wrote:
>> Hi Hans,
>>
>> On 11/21/2016 05:04 PM, Hans Verkuil wrote:
>>> On 18/11/16 10:11, Stanimir Varbanov wrote:
>>>> Hi Hans,
>>>>
>>>>>>> +
>>>>>>> +static int
>>>>>>> +vdec_reqbufs(struct file *file, void *fh, struct
>>>>>>> v4l2_requestbuffers *b)
>>>>>>> +{
>>>>>>> +    struct vb2_queue *queue = to_vb2q(file, b->type);
>>>>>>> +
>>>>>>> +    if (!queue)
>>>>>>> +        return -EINVAL;
>>>>>>> +
>>>>>>> +    return vb2_reqbufs(queue, b);
>>>>>>> +}
>>>>>>
>>>>>> Is there any reason why the v4l2_m2m_ioctl_reqbufs et al helper
>>>>>> functions
>>>>>> can't be used? I strongly recommend that, unless there is a specific
>>>>>> reason
>>>>>> why that won't work.
>>>>>
>>>>> So that means I need to completely rewrite the v4l2 part and adopt it
>>>>> for mem2mem device APIs.
>>>>>
>>>>> If that is what you meant I can invest some time to make a estimation
>>>>> what would be the changes and time needed. After that we can decide
>>>>> what
>>>>> to do - take the driver as is and port it to mem2mem device APIs later
>>>>> on or wait for the this transition to happen before merging.
>>>>>
>>>>
>>>> I made an attempt to adopt v4l2 part of the venus driver to m2m API's
>>>> and the result was ~300 less lines of code, but with the price of few
>>>> extensions in m2m APIs (and I still have issues with running
>>>> simultaneously multiple instances).
>>>>
>>>> I have to add few functions/macros to iterate over a list
>>>> (list_for_each
>>>> and friends). This is used to find the returned from decoder buffers by
>>>> address and associate them to vb2_buffer, because the decoder can
>>>> change
>>>> the order of the output buffers.
>>>>
>>>> The main problem I have is registering of the capture buffers before
>>>> session_start. This is requirement (disadvantage) of the firmware
>>>> implementation i.e. I need to announce capture buffers (address and
>>>> size
>>>> of the buffer) to the firmware before start buffer interaction by
>>>> session_start.
>>>>
>>>> So having that I think I will need one more week to stabilize the
>>>> driver
>>>> to the state that it was before this m2m transition.
>>>>
>>>> Thoughts?
>>>>
>>>
>>> It sounds like this it worth doing, since if you need these extensions,
>>> then
>>> it is likely someone else will need it as well.
>>
>> Meanwhile I have found bigger obstacle - I cannot run multiple instances
>> simultaneously. By m2m design it can execute only one job (m2m context)
>> at a time per m2m device. Can you confirm that my observation is correct?
> 
> The m2m framework assumes a single HW instance, yes. Do you have multiple
> HW decoders? I might not understand what you mean...
> 

I mean that I can start and execute up to 16 decoder sessions
simultaneously. Its a firmware responsibility how those sessions are
scheduled and how the hardware is shared between them. Of course
depending on the resolution the firmware can refuse to start the session
because the hardware will be overloaded and will not be able to satisfy
the bitrate requirements.

-- 
regards,
Stan
