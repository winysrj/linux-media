Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:52260 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753768AbcHWNZI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 09:25:08 -0400
Subject: Re: [PATCH 3/8] media: vidc: decoder: add video decoder files
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1471871619-25873-1-git-send-email-stanimir.varbanov@linaro.org>
 <1471871619-25873-4-git-send-email-stanimir.varbanov@linaro.org>
 <133fe2fe-8ede-6903-e948-52b5784b648a@xs4all.nl>
 <8d32132a-e831-edb6-e2ae-e3b24677da96@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <57BC4BC6.5000102@cisco.com>
Date: Tue, 23 Aug 2016 15:12:38 +0200
MIME-Version: 1.0
In-Reply-To: <8d32132a-e831-edb6-e2ae-e3b24677da96@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/16 14:45, Stanimir Varbanov wrote:
> Hi Hans,
> 
> Thanks for the valuable comments!
> 
> <cut>
> 
>>> +static int vdec_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
>>> +{
>>> +	struct vidc_inst *inst = to_inst(file);
>>> +	struct v4l2_captureparm *cap = &a->parm.capture;
>>> +	struct v4l2_fract *timeperframe = &cap->timeperframe;
>>> +	u64 us_per_frame, fps;
>>> +
>>> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
>>> +	    a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>>> +		return -EINVAL;
>>> +
>>> +	memset(cap->reserved, 0, sizeof(cap->reserved));
>>> +	if (!timeperframe->denominator)
>>> +		timeperframe->denominator = inst->timeperframe.denominator;
>>> +	if (!timeperframe->numerator)
>>> +		timeperframe->numerator = inst->timeperframe.numerator;
>>> +	cap->readbuffers = 0;
>>
>> Just set readbuffers to the minimum number of required buffers. Hmm, shouldn't
>> v4l2-compliance complain about a 0 value for readbuffers? Odd.
> 
> I guess I misunderstood the meaning of those fields and just zeroing
> them to make v4l2-compliance happy.

These fields are really left-overs from old times. One of these days I'll
probably remove them. I think that there are still one or two old drivers
that actually use these.

>>> +static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
>>> +{
>>> +	struct vidc_inst *inst = vb2_get_drv_priv(q);
>>> +	struct hfi_core *hfi = &inst->core->hfi;
>>> +	struct device *dev = inst->core->dev;
>>> +	struct hfi_buffer_requirements bufreq;
>>> +	struct hfi_buffer_count_actual buf_count;
>>> +	struct vb2_queue *queue;
>>> +	u32 ptype;
>>> +	int ret;
>>> +
>>> +	switch (q->type) {
>>> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>>> +		queue = &inst->bufq_cap;
>>> +		break;
>>> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>>> +		queue = &inst->bufq_out;
>>> +		break;
>>> +	default:
>>
>> If start_streaming fails, then all pending buffers have to be returned by the driver
>> by calling vb2_buffer_done(VB2_BUF_STATE_QUEUED). This will give ownership back to
>> userspace.
> 
> Infact this error path shouldn't be possible, because videobu2-core
> should check q->type before jumping here?

Sorry, I wasn't clear. It is not just this place (and you are right, the error
path here isn't possible), but any place where an error is returned in this
function.

Those should be replaced by a goto fail; and in the fail label all pending buffers
have to be returned. Same code as in stop_streaming, but you call vb2_buffer_done
with state QUEUED instead of state ERROR.

> 
>>
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	if (!vb2_is_streaming(queue))
>>> +		return 0;
>>
>> Can never happen, no need to test for this.
> 
> This can happen cause start_streaming is called for OUTPUT and for
> CAPTURE queues, see the above switch (q->type). If start_streaming is
> called for the CAPTURE thus vb2_is_streaming() checks does
> start_streaming is already called for OUTPUT. So this guarantee that the
> firmware will be started when the streaming is started for both queues.

Ah, now I see it. Please rename 'queue' to 'other_queue' or something like
that. I thought it was the queue that start_streaming was called for, but
that is called 'q'. A bit confusing :-)

> 
>>
>>> +
>>> +	inst->in_reconfig = false;
>>> +	inst->sequence = 0;
>>> +
>>> +	ret = pm_runtime_get_sync(dev);
>>> +	if (ret < 0)
>>> +		return ret;
>>> +
>>> +	ret = vdec_init_session(inst);
>>> +	if (ret)
>>> +		goto put_sync;
>>> +
>>> +	ret = vdec_set_properties(inst);
>>> +	if (ret)
>>> +		goto deinit_sess;
>>> +
>>> +	ret = vdec_check_configuration(inst);
>>> +	if (ret)
>>> +		goto deinit_sess;
>>> +
>>> +	ptype = HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL;
>>> +	buf_count.type = HFI_BUFFER_INPUT;
>>> +	buf_count.count_actual = inst->num_input_bufs;
>>> +
>>> +	ret = vidc_hfi_session_set_property(hfi, inst->hfi_inst,
>>> +					    ptype, &buf_count);
>>> +	if (ret)
>>> +		goto deinit_sess;
>>> +
>>> +	ret = vidc_buf_descs(inst, HFI_BUFFER_OUTPUT, &bufreq);
>>> +	if (ret)
>>> +		goto deinit_sess;
>>> +
>>> +	ptype = HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL;
>>> +	buf_count.type = HFI_BUFFER_OUTPUT;
>>> +	buf_count.count_actual = inst->num_output_bufs;
>>> +
>>> +	ret = vidc_hfi_session_set_property(hfi, inst->hfi_inst,
>>> +					    ptype, &buf_count);
>>> +	if (ret)
>>> +		goto deinit_sess;
>>> +
>>> +	if (inst->num_output_bufs != bufreq.count_actual) {
>>> +		struct hfi_buffer_display_hold_count_actual display;
>>> +
>>> +		ptype = HFI_PROPERTY_PARAM_BUFFER_DISPLAY_HOLD_COUNT_ACTUAL;
>>> +		display.type = HFI_BUFFER_OUTPUT;
>>> +		display.hold_count = inst->num_output_bufs -
>>> +				     bufreq.count_actual;
>>> +
>>> +		ret = vidc_hfi_session_set_property(hfi, inst->hfi_inst,
>>> +						    ptype, &display);
>>> +		if (ret)
>>> +			goto deinit_sess;
>>> +	}
>>> +
>>> +	ret = vidc_vb2_start_streaming(inst);
>>> +	if (ret)
>>> +		goto deinit_sess;
>>> +
>>> +	return 0;
>>> +
>>> +deinit_sess:
>>> +	vidc_hfi_session_deinit(hfi, inst->hfi_inst);
>>
>> Note that vidc_vb2_start_streaming already calls vidc_hfi_session_deinit on error.
> 
> Probably you wanted to say vdec_init_session has deinit on error path?
> If so I cannot see the problem, vidc_hfi_session_deinit is called only once?

Never mind. I thought vidc_hfi_session_deinit() was called from vidc_vb2_start_streaming,
but it is called from vidc_vb2_stop_streaming. My mistake.

>>> +static int vdec_op_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>>> +{
>>> +	struct vidc_inst *inst = ctrl_to_inst(ctrl);
>>> +	struct vdec_controls *ctr = &inst->controls.dec;
>>> +	struct hfi_core *hfi = &inst->core->hfi;
>>> +	union hfi_get_property hprop;
>>> +	u32 ptype = HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT;
>>> +	int ret;
>>> +
>>> +	switch (ctrl->id) {
>>> +	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
>>> +	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
>>> +	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
>>> +		ret = vidc_hfi_session_get_property(hfi, inst->hfi_inst, ptype,
>>> +						    &hprop);
>>> +		if (!ret)
>>> +			ctr->profile = hprop.profile_level.profile;
>>> +		ctrl->val = ctr->profile;
>>> +		break;
>>> +	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
>>> +	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
>>> +		ret = vidc_hfi_session_get_property(hfi, inst->hfi_inst, ptype,
>>> +						    &hprop);
>>> +		if (!ret)
>>> +			ctr->level = hprop.profile_level.level;
>>> +		ctrl->val = ctr->level;
>>> +		break;
>>> +	case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER:
>>> +		ctrl->val = ctr->post_loop_deb_mode;
>>> +		break;
>>
>> Why are these volatile?
> 
> Because the firmware acording to stream headers that profile and levels
> are different.

But when these change, isn't the driver told about it? And can these
change midstream? I would expect this to be set once when you start
decoding and not change afterwards.

Regards,

	Hans
