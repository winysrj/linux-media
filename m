Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:51784 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753494AbcKNJrM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 04:47:12 -0500
Subject: Re: [PATCH v3 3/9] media: venus: adding core part and helper
 functions
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-4-git-send-email-stanimir.varbanov@linaro.org>
 <f907ec9a-6d61-07f8-2135-f399e656d4e4@xs4all.nl>
 <2cdf728b-f58d-03fa-7ae4-58cbef4c4624@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a6557768-787d-7794-8cd0-781dc1ee9072@xs4all.nl>
Date: Mon, 14 Nov 2016 10:47:01 +0100
MIME-Version: 1.0
In-Reply-To: <2cdf728b-f58d-03fa-7ae4-58cbef4c4624@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/14/2016 10:42 AM, Stanimir Varbanov wrote:
> Hi Hans,
> 
> Thanks for the comments!
> 
> On 11/11/2016 01:32 PM, Hans Verkuil wrote:
>> Hi Stanimir,
>>
>> Some comments:
>>
>> On 11/07/2016 06:33 PM, Stanimir Varbanov wrote:
>>>  * core.c has implemented the platform dirver methods, file
>>> operations and v4l2 registration.
>>>
>>>  * helpers.c has implemented common helper functions for:
>>>    - buffer management
>>>
>>>    - vb2_ops and functions for format propagation,
>>>
>>>    - functions for allocating and freeing buffers for
>>>    internal usage. The buffer parameters describing internal
>>>    buffers depends on current format, resolution and codec.
>>>
>>>    - functions for calculation of current load of the
>>>    hardware. Depending on the count of instances and
>>>    resolutions it selects the best clock rate for the video
>>>    core.
>>>
>>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>>> ---
>>>  drivers/media/platform/qcom/venus/core.c    | 557 +++++++++++++++++++++++++
>>>  drivers/media/platform/qcom/venus/core.h    | 261 ++++++++++++
>>>  drivers/media/platform/qcom/venus/helpers.c | 612 ++++++++++++++++++++++++++++
>>>  drivers/media/platform/qcom/venus/helpers.h |  43 ++
>>>  4 files changed, 1473 insertions(+)
>>>  create mode 100644 drivers/media/platform/qcom/venus/core.c
>>>  create mode 100644 drivers/media/platform/qcom/venus/core.h
>>>  create mode 100644 drivers/media/platform/qcom/venus/helpers.c
>>>  create mode 100644 drivers/media/platform/qcom/venus/helpers.h
>>>
>>
>> <snip>
>>
>>> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
>>> new file mode 100644
>>> index 000000000000..21ed053aeb17
>>> --- /dev/null
>>> +++ b/drivers/media/platform/qcom/venus/core.h
>>
>> <snip>
>>
>>> +struct venus_ctrl {
>>> +	u32 id;
>>> +	enum v4l2_ctrl_type type;
>>> +	s32 min;
>>> +	s32 max;
>>> +	s32 def;
>>> +	u32 step;
>>> +	u64 menu_skip_mask;
>>> +	u32 flags;
>>> +	const char * const *qmenu;
>>> +};
>>
>> Why duplicate struct v4l2_ctrl_config? Just use that struct to define custom controls
>> together with v4l2_ctrl_new_custom().
> 
> OK, I will rework the controls to avoid struct v4l2_ctrl_config duplication.
> 
>>
>>> +
>>> +/*
>>> + * Offset base for buffers on the destination queue - used to distinguish
>>> + * between source and destination buffers when mmapping - they receive the same
>>> + * offsets but for different queues
>>> + */
>>> +#define DST_QUEUE_OFF_BASE	(1 << 30)
>>> +
>>> +static inline struct venus_inst *to_inst(struct file *filp)
>>> +{
>>> +	return container_of(filp->private_data, struct venus_inst, fh);
>>> +}
>>> +
>>> +static inline void *to_hfi_priv(struct venus_core *core)
>>> +{
>>> +	return core->priv;
>>> +}
>>> +
>>> +static inline struct vb2_queue *
>>> +to_vb2q(struct file *file, enum v4l2_buf_type type)
>>> +{
>>> +	struct venus_inst *inst = to_inst(file);
>>> +
>>> +	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>>> +		return &inst->bufq_cap;
>>> +	else if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>>> +		return &inst->bufq_out;
>>> +
>>> +	return NULL;
>>> +}
>>> +
>>> +#endif
>>> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
>>> new file mode 100644
>>> index 000000000000..c2d1446ad254
>>> --- /dev/null
>>> +++ b/drivers/media/platform/qcom/venus/helpers.c
>>
>> <snip>
>>
>>> +void vidc_vb2_stop_streaming(struct vb2_queue *q)
>>> +{
>>> +	struct venus_inst *inst = vb2_get_drv_priv(q);
>>> +	struct venus_core *core = inst->core;
>>> +	struct device *dev = core->dev;
>>> +	struct vb2_queue *other_queue;
>>> +	struct vidc_buffer *buf, *n;
>>> +	enum vb2_buffer_state state;
>>> +	int ret;
>>> +
>>> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>>> +		other_queue = &inst->bufq_cap;
>>> +	else
>>> +		other_queue = &inst->bufq_out;
>>> +
>>> +	if (!vb2_is_streaming(other_queue))
>>> +		return;
>>
>> This seems wrong to me: this return means that the buffers of queue q are never
>> released. Either drop this 'if' or release both queues when the last queue
>> stops streaming. I think dropping the 'if' is best.
> 
> I have done this way because hfi_session_stop must be called only once,
> and buffers will be released on first streamoff for both queues.

Are you sure the buffers are released for both queues? I may have missed that when
reviewing.

I would recommend to call hfi_session_stop when the first stop_streaming is called,
not when it is called for both queues. I say this because stopping streaming without
releasing the buffers is likely to cause problems.

Did you turn on CONFIG_VIDEO_ADV_DEBUG? If it is on, and you don't release buffers
then I think you will see warnings in the kernel log.

Regards,

	Hans
