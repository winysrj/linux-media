Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36116 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753058AbcKQJKn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 04:10:43 -0500
Received: by mail-wm0-f42.google.com with SMTP id g23so297026920wme.1
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2016 01:10:43 -0800 (PST)
Subject: Re: [PATCH v3 3/9] media: venus: adding core part and helper
 functions
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-4-git-send-email-stanimir.varbanov@linaro.org>
 <f907ec9a-6d61-07f8-2135-f399e656d4e4@xs4all.nl>
 <2cdf728b-f58d-03fa-7ae4-58cbef4c4624@linaro.org>
 <a6557768-787d-7794-8cd0-781dc1ee9072@xs4all.nl>
 <dd5c0fef-4994-4beb-952f-659ff5d17fb0@linaro.org>
 <72f8675a-4771-3e9a-6ee0-6e1b86589e8f@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <fe4b4f77-1c90-a88a-f393-44e35f8f1466@linaro.org>
Date: Thu, 17 Nov 2016 11:10:40 +0200
MIME-Version: 1.0
In-Reply-To: <72f8675a-4771-3e9a-6ee0-6e1b86589e8f@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 11/14/2016 12:25 PM, Hans Verkuil wrote:
> On 11/14/2016 11:11 AM, Stanimir Varbanov wrote:
>> Hi Hans,
>>
>> <cut>
>>
>>>>>
>>>>>> +void vidc_vb2_stop_streaming(struct vb2_queue *q)
>>>>>> +{
>>>>>> +	struct venus_inst *inst = vb2_get_drv_priv(q);
>>>>>> +	struct venus_core *core = inst->core;
>>>>>> +	struct device *dev = core->dev;
>>>>>> +	struct vb2_queue *other_queue;
>>>>>> +	struct vidc_buffer *buf, *n;
>>>>>> +	enum vb2_buffer_state state;
>>>>>> +	int ret;
>>>>>> +
>>>>>> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>>>>>> +		other_queue = &inst->bufq_cap;
>>>>>> +	else
>>>>>> +		other_queue = &inst->bufq_out;
>>>>>> +
>>>>>> +	if (!vb2_is_streaming(other_queue))
>>>>>> +		return;
>>>>>
>>>>> This seems wrong to me: this return means that the buffers of queue q are never
>>>>> released. Either drop this 'if' or release both queues when the last queue
>>>>> stops streaming. I think dropping the 'if' is best.
>>>>
>>>> I have done this way because hfi_session_stop must be called only once,
>>>> and buffers will be released on first streamoff for both queues.
>>>
>>> Are you sure the buffers are released for both queues? I may have missed that when
>>> reviewing.
>>
>> yes, hfi_session_stop will instruct the firmware to stop using provided
>> buffers and return ownership to the host driver by fill_buf_done and
>> empty_buf_done callbacks.
>>
>>>
>>> I would recommend to call hfi_session_stop when the first stop_streaming is called,
>>> not when it is called for both queues. I say this because stopping streaming without
>>> releasing the buffers is likely to cause problems.
>>
>> this is what I tried to implement with above
>> !vb2_is_streaming(other_queue) thing.
> 
> That doesn't work: if the application calls STREAMON(CAPTURE) followed by STREAMOFF(CAPTURE)
> without ever starting the OUTPUT queue, this will not clean up the capture queue.

Yes this is a bug which should be fixed.

-- 
regards,
Stan
