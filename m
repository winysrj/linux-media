Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38463 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756135AbcH2OXI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 10:23:08 -0400
Received: by mail-wm0-f41.google.com with SMTP id o80so94750753wme.1
        for <linux-media@vger.kernel.org>; Mon, 29 Aug 2016 07:22:12 -0700 (PDT)
Subject: Re: [PATCH 3/8] media: vidc: decoder: add video decoder files
To: Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1471871619-25873-1-git-send-email-stanimir.varbanov@linaro.org>
 <1471871619-25873-4-git-send-email-stanimir.varbanov@linaro.org>
 <133fe2fe-8ede-6903-e948-52b5784b648a@xs4all.nl>
 <8d32132a-e831-edb6-e2ae-e3b24677da96@linaro.org>
 <57BC4BC6.5000102@cisco.com>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <c161a005-0c28-0502-6edf-a74fa15b3849@linaro.org>
Date: Mon, 29 Aug 2016 17:22:09 +0300
MIME-Version: 1.0
In-Reply-To: <57BC4BC6.5000102@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

<cut>

>>>> +static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
>>>> +{
>>>> +	struct vidc_inst *inst = vb2_get_drv_priv(q);
>>>> +	struct hfi_core *hfi = &inst->core->hfi;
>>>> +	struct device *dev = inst->core->dev;
>>>> +	struct hfi_buffer_requirements bufreq;
>>>> +	struct hfi_buffer_count_actual buf_count;
>>>> +	struct vb2_queue *queue;
>>>> +	u32 ptype;
>>>> +	int ret;
>>>> +
>>>> +	switch (q->type) {
>>>> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>>>> +		queue = &inst->bufq_cap;
>>>> +		break;
>>>> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>>>> +		queue = &inst->bufq_out;
>>>> +		break;
>>>> +	default:
>>>
>>> If start_streaming fails, then all pending buffers have to be returned by the driver
>>> by calling vb2_buffer_done(VB2_BUF_STATE_QUEUED). This will give ownership back to
>>> userspace.
>>
>> Infact this error path shouldn't be possible, because videobu2-core
>> should check q->type before jumping here?
> 
> Sorry, I wasn't clear. It is not just this place (and you are right, the error
> path here isn't possible), but any place where an error is returned in this
> function.
> 
> Those should be replaced by a goto fail; and in the fail label all pending buffers
> have to be returned. Same code as in stop_streaming, but you call vb2_buffer_done
> with state QUEUED instead of state ERROR.

OK, I need to call vb2_buffer_done(ERROR) for every queued buffer
(before invocation of STREAM_ON) if start_streaming failed.

I think that in present code I have calls to vb2_buffer_done but with
status DONE.

<cut>

>>>> +static int vdec_op_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>>>> +{
>>>> +	struct vidc_inst *inst = ctrl_to_inst(ctrl);
>>>> +	struct vdec_controls *ctr = &inst->controls.dec;
>>>> +	struct hfi_core *hfi = &inst->core->hfi;
>>>> +	union hfi_get_property hprop;
>>>> +	u32 ptype = HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT;
>>>> +	int ret;
>>>> +
>>>> +	switch (ctrl->id) {
>>>> +	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
>>>> +	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
>>>> +	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
>>>> +		ret = vidc_hfi_session_get_property(hfi, inst->hfi_inst, ptype,
>>>> +						    &hprop);
>>>> +		if (!ret)
>>>> +			ctr->profile = hprop.profile_level.profile;
>>>> +		ctrl->val = ctr->profile;
>>>> +		break;
>>>> +	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
>>>> +	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
>>>> +		ret = vidc_hfi_session_get_property(hfi, inst->hfi_inst, ptype,
>>>> +						    &hprop);
>>>> +		if (!ret)
>>>> +			ctr->level = hprop.profile_level.level;
>>>> +		ctrl->val = ctr->level;
>>>> +		break;
>>>> +	case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER:
>>>> +		ctrl->val = ctr->post_loop_deb_mode;
>>>> +		break;
>>>
>>> Why are these volatile?
>>
>> Because the firmware acording to stream headers that profile and levels
>> are different.
> 
> But when these change, isn't the driver told about it? And can these
> change midstream? I would expect this to be set once when you start
> decoding and not change afterwards.

Actually the decoder firmware will detect the profile/level pair itself
based on elementary stream headers. So I'd expect that getting those
parameters by session_get_property API will just return what the decoder
thinks about profile/level.

-- 
regards,
Stan
