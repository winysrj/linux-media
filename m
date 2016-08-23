Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37536 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757358AbcHWMqB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 08:46:01 -0400
Received: by mail-wm0-f45.google.com with SMTP id i5so193714872wmg.0
        for <linux-media@vger.kernel.org>; Tue, 23 Aug 2016 05:46:00 -0700 (PDT)
Subject: Re: [PATCH 3/8] media: vidc: decoder: add video decoder files
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1471871619-25873-1-git-send-email-stanimir.varbanov@linaro.org>
 <1471871619-25873-4-git-send-email-stanimir.varbanov@linaro.org>
 <133fe2fe-8ede-6903-e948-52b5784b648a@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <8d32132a-e831-edb6-e2ae-e3b24677da96@linaro.org>
Date: Tue, 23 Aug 2016 15:45:57 +0300
MIME-Version: 1.0
In-Reply-To: <133fe2fe-8ede-6903-e948-52b5784b648a@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the valuable comments!

<cut>

>> +
>> +static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
>> +{
>> +	struct vidc_inst *inst = to_inst(file);
>> +	const struct vidc_format *fmt = NULL;
>> +	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
>> +
>> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>> +		fmt = inst->fmt_cap;
>> +	else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> +		fmt = inst->fmt_out;
>> +
>> +	if (inst->in_reconfig) {
>> +		inst->height = inst->reconfig_height;
>> +		inst->width = inst->reconfig_width;
>> +		inst->in_reconfig = false;
>> +	}
>> +
>> +	pixmp->pixelformat = fmt->pixfmt;
>> +
>> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>> +		pixmp->width = inst->width;
>> +		pixmp->height = inst->height;
>> +		pixmp->colorspace = inst->colorspace;
>> +		pixmp->ycbcr_enc = inst->ycbcr_enc;
>> +		pixmp->quantization = inst->quantization;
>> +		pixmp->xfer_func = inst->xfer_func;
>> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>> +		pixmp->width = inst->out_width;
>> +		pixmp->height = inst->out_height;
>> +	}
>> +
>> +	vdec_try_fmt_common(inst, f);
> 
> Is this call really necessary? The current format should always be a valid format,
> so this is dubious.

Agreed, this looks over engineered. The only thing which could be
related to this call could be the reconfiguration above. The
reconfiguration is a event from firmware side that the streaming
resolution (based on stream headers) is different from the initial
resolution set it before stream_on. In this case the decoder refuses to
start and wait for reconfiguration. Also get_fmt can be called after the
stream_on so maybe my idea was to return the changed resolution to
userspace so that it can handle the exception properly.

> 
>> +
>> +	return 0;
>> +}
>> +
>> +static int vdec_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
>> +{
>> +	struct vidc_inst *inst = to_inst(file);
>> +	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
>> +	struct v4l2_pix_format_mplane orig_pixmp;
>> +	const struct vidc_format *fmt;
>> +	struct v4l2_format format;
>> +	u32 pixfmt_out = 0, pixfmt_cap = 0;
>> +
>> +	orig_pixmp = *pixmp;
>> +
>> +	fmt = vdec_try_fmt_common(inst, f);
>> +	if (!fmt)
>> +		return -EINVAL;
>> +
>> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>> +		pixfmt_out = pixmp->pixelformat;
>> +		pixfmt_cap = inst->fmt_cap->pixfmt;
>> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>> +		pixfmt_cap = pixmp->pixelformat;
>> +		pixfmt_out = inst->fmt_out->pixfmt;
>> +	}
>> +
>> +	memset(&format, 0, sizeof(format));
>> +
>> +	format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
>> +	format.fmt.pix_mp.pixelformat = pixfmt_out;
>> +	format.fmt.pix_mp.width = orig_pixmp.width;
>> +	format.fmt.pix_mp.height = orig_pixmp.height;
>> +	vdec_try_fmt_common(inst, &format);
>> +	inst->out_width = format.fmt.pix_mp.width;
>> +	inst->out_height = format.fmt.pix_mp.height;
>> +	inst->colorspace = pixmp->colorspace;
>> +	inst->ycbcr_enc = pixmp->ycbcr_enc;
>> +	inst->quantization = pixmp->quantization;
>> +	inst->xfer_func = pixmp->xfer_func;
> 
> These four fields can only be set if f->type == VIDEO_OUTPUT.

OK, corrected.

> 
>> +
>> +	memset(&format, 0, sizeof(format));
>> +
>> +	format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>> +	format.fmt.pix_mp.pixelformat = pixfmt_cap;
>> +	format.fmt.pix_mp.width = orig_pixmp.width;
>> +	format.fmt.pix_mp.height = orig_pixmp.height;
>> +	vdec_try_fmt_common(inst, &format);
>> +	inst->width = format.fmt.pix_mp.width;
>> +	inst->height = format.fmt.pix_mp.height;
> 
> This doesn't look right.
> 
> If I understand this code correctly, the capture and output format
> depend on one another. Can you explain a bit more what the dependencies
> are? I have to revisit this later, once I have a better idea of what's
> going on here.

The thing is that the capture resolution have hardware alignment
restrictions. Here the height must be aligned to 32 lines. So I got
original pixmp struct and call try_fmt_common to align height to 32 and
save the resolution in the instance height variable.

> 
>> +
>> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> +		inst->fmt_out = fmt;
>> +	else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>> +		inst->fmt_cap = fmt;
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +vdec_g_selection(struct file *file, void *priv, struct v4l2_selection *s)
>> +{
>> +	struct vidc_inst *inst = to_inst(file);
>> +
>> +	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>> +		return -EINVAL;
>> +
>> +	switch (s->target) {
>> +	case V4L2_SEL_TGT_CROP_DEFAULT:
>> +	case V4L2_SEL_TGT_CROP_BOUNDS:
>> +	case V4L2_SEL_TGT_CROP:
>> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
>> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
>> +	case V4L2_SEL_TGT_COMPOSE:
> 
> You can't set both crop and compose with just a single s->r. That makes no sense.
> 
> What exactly are you trying to do here?

This is related to hardware alignment restriction. I'm expecting
userspace (gstreamer is one of them) would call g_selection (g_crop) to
got the actual resolution without vertical padding.

> 
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	s->r.top = 0;
>> +	s->r.left = 0;
>> +	s->r.width = inst->out_width;
>> +	s->r.height = inst->out_height;
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +vdec_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *b)
>> +{
>> +	struct vb2_queue *queue = vidc_to_vb2q(file, b->type);
>> +
>> +	if (!queue)
>> +		return -EINVAL;
>> +
>> +	if (!b->count)
>> +		vb2_core_queue_release(queue);
> 
> Don't do this. Let vb2_reqbufs handle this for you.

Sorry this is leftover during testing with some custom Gstreamer plugin.

> 
>> +
>> +	return vb2_reqbufs(queue, b);
>> +}
>> +
>> +static int
>> +vdec_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
>> +{
>> +	strlcpy(cap->driver, VIDC_DRV_NAME, sizeof(cap->driver));
>> +	strlcpy(cap->card, "video decoder", sizeof(cap->card));
>> +	strlcpy(cap->bus_info, "platform:vidc", sizeof(cap->bus_info));
>> +
>> +	cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
>> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> 
> Drop these two lines. Instead set the device_caps field of struct video_device
> to V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING. The v4l2 core will fill
> in these two cap fields for you based on the vdev->device_caps field.

OK, done.

> 
>> +
>> +	return 0;
>> +}
>> +
>> +static int vdec_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
>> +{
>> +	const struct vidc_format *fmt;
>> +
>> +	memset(f->reserved, 0, sizeof(f->reserved));
>> +
>> +	fmt = find_format_by_index(f->index, f->type);
>> +	if (!fmt)
>> +		return -EINVAL;
>> +
>> +	f->pixelformat = fmt->pixfmt;
>> +
>> +	return 0;
>> +}
>> +
>> +static int vdec_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
>> +{
>> +	struct vb2_queue *queue = vidc_to_vb2q(file, b->type);
>> +	unsigned int p;
>> +	int ret;
>> +
>> +	if (!queue)
>> +		return -EINVAL;
>> +
>> +	ret = vb2_querybuf(queue, b);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (b->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
>> +	    b->memory == V4L2_MEMORY_MMAP) {
>> +		for (p = 0; p < b->length; p++)
>> +			b->m.planes[p].m.mem_offset += DST_QUEUE_OFF_BASE;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +vdec_create_bufs(struct file *file, void *fh, struct v4l2_create_buffers *b)
>> +{
>> +	struct vb2_queue *queue = vidc_to_vb2q(file, b->format.type);
>> +
>> +	if (!queue)
>> +		return -EINVAL;
>> +
>> +	return vb2_create_bufs(queue, b);
>> +}
>> +
>> +static int vdec_prepare_buf(struct file *file, void *fh, struct v4l2_buffer *b)
>> +{
>> +	struct vb2_queue *queue = vidc_to_vb2q(file, b->type);
>> +
>> +	if (!queue)
>> +		return -EINVAL;
>> +
>> +	return vb2_prepare_buf(queue, b);
>> +}
>> +
>> +static int vdec_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
>> +{
>> +	struct vb2_queue *queue = vidc_to_vb2q(file, b->type);
>> +
>> +	if (!queue)
>> +		return -EINVAL;
>> +
>> +	return vb2_qbuf(queue, b);
>> +}
>> +
>> +static int
>> +vdec_exportbuf(struct file *file, void *fh, struct v4l2_exportbuffer *b)
>> +{
>> +	struct vb2_queue *queue = vidc_to_vb2q(file, b->type);
>> +
>> +	if (!queue)
>> +		return -EINVAL;
>> +
>> +	return vb2_expbuf(queue, b);
>> +}
>> +
>> +static int vdec_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
>> +{
>> +	struct vb2_queue *queue = vidc_to_vb2q(file, b->type);
>> +
>> +	if (!queue)
>> +		return -EINVAL;
>> +
>> +	return vb2_dqbuf(queue, b, file->f_flags & O_NONBLOCK);
>> +}
>> +
>> +static int vdec_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
>> +{
>> +	struct vb2_queue *queue = vidc_to_vb2q(file, type);
>> +
>> +	if (!queue)
>> +		return -EINVAL;
>> +
>> +	return vb2_streamon(queue, type);
>> +}
>> +
>> +static int vdec_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
>> +{
>> +	struct vb2_queue *queue = vidc_to_vb2q(file, type);
>> +
>> +	if (!queue)
>> +		return -EINVAL;
>> +
>> +	return vb2_streamoff(queue, type);
>> +}
> 
> Is there a reason why the v4l2-mem2mem framework isn't used? It seems to me that
> a lot of this code is in there as well.

So in the begging of driver reworking I have the impression that mem2mem
is the right API to use. Then I decided that this will complicate the
driver a bit without any benefit. Of course I could be wrong.

> 
>> +
>> +static int vdec_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
>> +{
>> +	struct vidc_inst *inst = to_inst(file);
>> +	struct v4l2_captureparm *cap = &a->parm.capture;
>> +	struct v4l2_fract *timeperframe = &cap->timeperframe;
>> +	u64 us_per_frame, fps;
>> +
>> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
>> +	    a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> +		return -EINVAL;
>> +
>> +	memset(cap->reserved, 0, sizeof(cap->reserved));
>> +	if (!timeperframe->denominator)
>> +		timeperframe->denominator = inst->timeperframe.denominator;
>> +	if (!timeperframe->numerator)
>> +		timeperframe->numerator = inst->timeperframe.numerator;
>> +	cap->readbuffers = 0;
> 
> Just set readbuffers to the minimum number of required buffers. Hmm, shouldn't
> v4l2-compliance complain about a 0 value for readbuffers? Odd.

I guess I misunderstood the meaning of those fields and just zeroing
them to make v4l2-compliance happy.

> 
> Also, for output use v4l2_outputparm. I know, they are the same, but I don't
> really like it when that fact is (ab)used.

sure, I will.

> 
>> +	cap->extendedmode = 0;
>> +	cap->capability = V4L2_CAP_TIMEPERFRAME;
>> +	us_per_frame = timeperframe->numerator * (u64)USEC_PER_SEC;
>> +	do_div(us_per_frame, timeperframe->denominator);
>> +
>> +	if (!us_per_frame)
>> +		return -EINVAL;
>> +
>> +	fps = (u64)USEC_PER_SEC;
>> +	do_div(fps, us_per_frame);
>> +
>> +	inst->fps = fps;
>> +	inst->timeperframe = *timeperframe;
> 
> Can both capture and output set the timeperframe? Is that intended?

>From the firmware point of view the timeperframe is expected to be set
on the input buffers.

> 
>> +
>> +	return 0;
>> +}
>> +
>> +static int vdec_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
>> +{
>> +	struct vidc_inst *inst = to_inst(file);
>> +
>> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
>> +	    a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> +		return -EINVAL;
>> +
>> +	a->parm.capture.capability |= V4L2_CAP_TIMEPERFRAME;
>> +	a->parm.capture.timeperframe = inst->timeperframe;
>> +
>> +	return 0;
>> +}
>> +
>> +static int vdec_enum_framesizes(struct file *file, void *fh,
>> +				struct v4l2_frmsizeenum *fsize)
>> +{
>> +	struct hfi_inst *hfi_inst = to_hfi_inst(file);
>> +	const struct vidc_format *fmt;
>> +
>> +	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
>> +
>> +	fmt = find_format(fsize->pixel_format,
>> +			  V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
>> +	if (!fmt) {
>> +		fmt = find_format(fsize->pixel_format,
>> +				  V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
>> +		if (!fmt)
>> +			return -EINVAL;
>> +	}
>> +
>> +	if (fsize->index)
>> +		return -EINVAL;
>> +
>> +	fsize->stepwise.min_width = hfi_inst->width.min;
>> +	fsize->stepwise.max_width = hfi_inst->width.max;
>> +	fsize->stepwise.step_width = hfi_inst->width.step_size;
>> +	fsize->stepwise.min_height = hfi_inst->height.min;
>> +	fsize->stepwise.max_height = hfi_inst->height.max;
>> +	fsize->stepwise.step_height = hfi_inst->height.step_size;
>> +
>> +	return 0;
>> +}
>> +
>> +static int vdec_enum_frameintervals(struct file *file, void *fh,
>> +				    struct v4l2_frmivalenum *fival)
>> +{
>> +	struct hfi_inst *hfi_inst = to_hfi_inst(file);
>> +	const struct vidc_format *fmt;
>> +
>> +	fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
>> +
>> +	fmt = find_format(fival->pixel_format,
>> +			  V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
>> +	if (!fmt)
>> +		return -EINVAL;
>> +
>> +	if (fival->index)
>> +		return -EINVAL;
>> +
>> +	if (!fival->width || !fival->height)
>> +		return -EINVAL;
>> +
>> +	if (fival->width > hfi_inst->width.max ||
>> +	    fival->width < hfi_inst->width.min ||
>> +	    fival->height > hfi_inst->height.max ||
>> +	    fival->height < hfi_inst->height.min)
>> +		return -EINVAL;
>> +
>> +	fival->stepwise.min.numerator = hfi_inst->framerate.min;
>> +	fival->stepwise.min.denominator = 1;
>> +	fival->stepwise.max.numerator = hfi_inst->framerate.max;
>> +	fival->stepwise.max.denominator = 1;
>> +	fival->stepwise.step.numerator = hfi_inst->framerate.step_size;
>> +	fival->stepwise.step.denominator = 1;
>> +
>> +	return 0;
>> +}
>> +
>> +static int vdec_subscribe_event(struct v4l2_fh *fh,
>> +				const struct v4l2_event_subscription *sub)
>> +{
>> +	switch (sub->type) {
>> +	case V4L2_EVENT_EOS:
>> +		return v4l2_event_subscribe(fh, sub, 2, NULL);
>> +	case V4L2_EVENT_SOURCE_CHANGE:
>> +		return v4l2_src_change_event_subscribe(fh, sub);
>> +	case V4L2_EVENT_CTRL:
>> +		return v4l2_ctrl_subscribe_event(fh, sub);
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +}
>> +
>> +static const struct v4l2_ioctl_ops vdec_ioctl_ops = {
>> +	.vidioc_querycap = vdec_querycap,
>> +	.vidioc_enum_fmt_vid_cap_mplane = vdec_enum_fmt,
>> +	.vidioc_enum_fmt_vid_out_mplane = vdec_enum_fmt,
>> +	.vidioc_s_fmt_vid_cap_mplane = vdec_s_fmt,
>> +	.vidioc_s_fmt_vid_out_mplane = vdec_s_fmt,
>> +	.vidioc_g_fmt_vid_cap_mplane = vdec_g_fmt,
>> +	.vidioc_g_fmt_vid_out_mplane = vdec_g_fmt,
>> +	.vidioc_try_fmt_vid_cap_mplane = vdec_try_fmt,
>> +	.vidioc_try_fmt_vid_out_mplane = vdec_try_fmt,
>> +	.vidioc_g_selection = vdec_g_selection,
>> +	.vidioc_reqbufs = vdec_reqbufs,
>> +	.vidioc_querybuf = vdec_querybuf,
>> +	.vidioc_create_bufs = vdec_create_bufs,
>> +	.vidioc_prepare_buf = vdec_prepare_buf,
>> +	.vidioc_qbuf = vdec_qbuf,
>> +	.vidioc_expbuf = vdec_exportbuf,
>> +	.vidioc_dqbuf = vdec_dqbuf,
>> +	.vidioc_streamon = vdec_streamon,
>> +	.vidioc_streamoff = vdec_streamoff,
>> +	.vidioc_s_parm = vdec_s_parm,
>> +	.vidioc_g_parm = vdec_g_parm,
>> +	.vidioc_enum_framesizes = vdec_enum_framesizes,
>> +	.vidioc_enum_frameintervals = vdec_enum_frameintervals,
>> +	.vidioc_subscribe_event = vdec_subscribe_event,
>> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>> +};
>> +
>> +static int vdec_init_session(struct vidc_inst *inst)
>> +{
>> +	struct hfi_core *hfi = &inst->core->hfi;
>> +	u32 pixfmt = inst->fmt_out->pixfmt;
>> +	struct hfi_framesize fs;
>> +	u32 ptype;
>> +	int ret;
>> +
>> +	ret = vidc_hfi_session_init(hfi, inst->hfi_inst, pixfmt,
>> +				    VIDC_SESSION_TYPE_DEC);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ptype = HFI_PROPERTY_PARAM_FRAME_SIZE;
>> +	fs.buffer_type = HFI_BUFFER_INPUT;
>> +	fs.width = inst->out_width;
>> +	fs.height = inst->out_height;
>> +
>> +	ret = vidc_hfi_session_set_property(hfi, inst->hfi_inst, ptype, &fs);
>> +	if (ret)
>> +		goto err;
>> +
>> +	fs.buffer_type = HFI_BUFFER_OUTPUT;
>> +	fs.width = inst->width;
>> +	fs.height = inst->height;
>> +
>> +	ret = vidc_hfi_session_set_property(hfi, inst->hfi_inst, ptype, &fs);
>> +	if (ret)
>> +		goto err;
>> +
>> +	pixfmt = inst->fmt_cap->pixfmt;
>> +
>> +	ret = vidc_set_color_format(inst, HFI_BUFFER_OUTPUT, pixfmt);
>> +	if (ret)
>> +		goto err;
>> +
>> +	return 0;
>> +err:
>> +	vidc_hfi_session_deinit(hfi, inst->hfi_inst);
>> +	return ret;
>> +}
>> +
>> +static int vdec_cap_num_buffers(struct vidc_inst *inst,
>> +				struct hfi_buffer_requirements *bufreq)
>> +{
>> +	struct hfi_core *hfi = &inst->core->hfi;
>> +	struct device *dev = inst->core->dev;
>> +	int ret, ret2;
>> +
>> +	ret = pm_runtime_get_sync(dev);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = vdec_init_session(inst);
>> +	if (ret)
>> +		goto put_sync;
>> +
>> +	ret = vidc_buf_descs(inst, HFI_BUFFER_OUTPUT, bufreq);
>> +
>> +	vidc_hfi_session_deinit(hfi, inst->hfi_inst);
>> +
>> +put_sync:
>> +	ret2 = pm_runtime_put_sync(dev);
>> +
>> +	return ret ? ret : ret2;
>> +}
>> +
>> +static int vdec_queue_setup(struct vb2_queue *q,
>> +			    unsigned int *num_buffers, unsigned int *num_planes,
>> +			    unsigned int sizes[], struct device *alloc_devs[])
>> +{
>> +	struct vidc_inst *inst = vb2_get_drv_priv(q);
>> +	struct hfi_buffer_requirements bufreq;
>> +	unsigned int p;
>> +	int ret = 0;
>> +	u32 mbs;
>> +
>> +	switch (q->type) {
>> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>> +		*num_planes = inst->fmt_out->num_planes;
>> +
>> +		*num_buffers = clamp_val(*num_buffers, 4, VIDEO_MAX_FRAME);
> 
> No need to check for VIDEO_MAX_FRAME. I assume 4 is the minimum required
> number of buffers. Just set min_buffers_needed in struct vb2_queue to 4 instead.

Sure, I missed the clamp in videobu2-core.

> 
>> +
>> +		mbs = inst->out_width * inst->out_height /
>> +				MACROBLOCKS_PER_PIXEL;
>> +		for (p = 0; p < *num_planes; p++) {
>> +			sizes[p] = get_framesize_compressed(mbs);
>> +			alloc_devs[p] = inst->core->dev;
> 
> Don't do this here. Just set the dev field of vb2_queue to inst->core->dev.
> alloc_devs[] is prefilled with q->dev by vb2.

Good remark, this change has been made latetly so I have some excuse :)

> 
>> +		}
>> +
>> +		inst->num_input_bufs = *num_buffers;
>> +		break;
>> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>> +		*num_planes = inst->fmt_cap->num_planes;
>> +
>> +		ret = vdec_cap_num_buffers(inst, &bufreq);
>> +		if (ret)
>> +			break;
>> +
>> +		*num_buffers = max(*num_buffers, bufreq.count_actual);
> 
> How is bufreq.count_actual derived? I.e. what does it depend on?

Good question, the count_actual is derived from firmware based on input
and output resolutions, framerate and codec i.e. the firmware based on
those parameters decides the number of buffers need for optimal
performance.

> 
>> +
>> +		for (p = 0; p < *num_planes; p++) {
>> +			sizes[p] = get_framesize_nv12(p, inst->height,
>> +						      inst->width);
>> +			alloc_devs[p] = inst->core->dev;
>> +		}
>> +
>> +		inst->num_output_bufs = *num_buffers;
>> +		break;
>> +	default:
>> +		ret = -EINVAL;
>> +		break;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int vdec_check_configuration(struct vidc_inst *inst)
>> +{
>> +	struct hfi_buffer_requirements bufreq;
>> +	int ret;
>> +
>> +	ret = vidc_buf_descs(inst, HFI_BUFFER_OUTPUT, &bufreq);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (inst->num_output_bufs < bufreq.count_actual ||
>> +	    inst->num_output_bufs < bufreq.count_min)
>> +		return -EINVAL;
>> +
>> +	ret = vidc_buf_descs(inst, HFI_BUFFER_INPUT, &bufreq);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (inst->num_input_bufs < bufreq.count_min)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>> +static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
>> +{
>> +	struct vidc_inst *inst = vb2_get_drv_priv(q);
>> +	struct hfi_core *hfi = &inst->core->hfi;
>> +	struct device *dev = inst->core->dev;
>> +	struct hfi_buffer_requirements bufreq;
>> +	struct hfi_buffer_count_actual buf_count;
>> +	struct vb2_queue *queue;
>> +	u32 ptype;
>> +	int ret;
>> +
>> +	switch (q->type) {
>> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>> +		queue = &inst->bufq_cap;
>> +		break;
>> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>> +		queue = &inst->bufq_out;
>> +		break;
>> +	default:
> 
> If start_streaming fails, then all pending buffers have to be returned by the driver
> by calling vb2_buffer_done(VB2_BUF_STATE_QUEUED). This will give ownership back to
> userspace.

Infact this error path shouldn't be possible, because videobu2-core
should check q->type before jumping here?

> 
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!vb2_is_streaming(queue))
>> +		return 0;
> 
> Can never happen, no need to test for this.

This can happen cause start_streaming is called for OUTPUT and for
CAPTURE queues, see the above switch (q->type). If start_streaming is
called for the CAPTURE thus vb2_is_streaming() checks does
start_streaming is already called for OUTPUT. So this guarantee that the
firmware will be started when the streaming is started for both queues.

> 
>> +
>> +	inst->in_reconfig = false;
>> +	inst->sequence = 0;
>> +
>> +	ret = pm_runtime_get_sync(dev);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = vdec_init_session(inst);
>> +	if (ret)
>> +		goto put_sync;
>> +
>> +	ret = vdec_set_properties(inst);
>> +	if (ret)
>> +		goto deinit_sess;
>> +
>> +	ret = vdec_check_configuration(inst);
>> +	if (ret)
>> +		goto deinit_sess;
>> +
>> +	ptype = HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL;
>> +	buf_count.type = HFI_BUFFER_INPUT;
>> +	buf_count.count_actual = inst->num_input_bufs;
>> +
>> +	ret = vidc_hfi_session_set_property(hfi, inst->hfi_inst,
>> +					    ptype, &buf_count);
>> +	if (ret)
>> +		goto deinit_sess;
>> +
>> +	ret = vidc_buf_descs(inst, HFI_BUFFER_OUTPUT, &bufreq);
>> +	if (ret)
>> +		goto deinit_sess;
>> +
>> +	ptype = HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL;
>> +	buf_count.type = HFI_BUFFER_OUTPUT;
>> +	buf_count.count_actual = inst->num_output_bufs;
>> +
>> +	ret = vidc_hfi_session_set_property(hfi, inst->hfi_inst,
>> +					    ptype, &buf_count);
>> +	if (ret)
>> +		goto deinit_sess;
>> +
>> +	if (inst->num_output_bufs != bufreq.count_actual) {
>> +		struct hfi_buffer_display_hold_count_actual display;
>> +
>> +		ptype = HFI_PROPERTY_PARAM_BUFFER_DISPLAY_HOLD_COUNT_ACTUAL;
>> +		display.type = HFI_BUFFER_OUTPUT;
>> +		display.hold_count = inst->num_output_bufs -
>> +				     bufreq.count_actual;
>> +
>> +		ret = vidc_hfi_session_set_property(hfi, inst->hfi_inst,
>> +						    ptype, &display);
>> +		if (ret)
>> +			goto deinit_sess;
>> +	}
>> +
>> +	ret = vidc_vb2_start_streaming(inst);
>> +	if (ret)
>> +		goto deinit_sess;
>> +
>> +	return 0;
>> +
>> +deinit_sess:
>> +	vidc_hfi_session_deinit(hfi, inst->hfi_inst);
> 
> Note that vidc_vb2_start_streaming already calls vidc_hfi_session_deinit on error.

Probably you wanted to say vdec_init_session has deinit on error path?
If so I cannot see the problem, vidc_hfi_session_deinit is called only once?

> No idea if vidc_hfi_session_deinit can handle that, I just thought I'd mention it.
> 
>> +put_sync:
>> +	pm_runtime_put_sync(dev);
>> +	return ret;
>> +}
>> +
>> +static const struct vb2_ops vdec_vb2_ops = {
>> +	.queue_setup = vdec_queue_setup,
>> +	.buf_init = vidc_vb2_buf_init,
>> +	.buf_prepare = vidc_vb2_buf_prepare,
>> +	.start_streaming = vdec_start_streaming,
>> +	.stop_streaming = vidc_vb2_stop_streaming,
> 
> 
> Note that stop_streaming has to return all pending buffers by calling vb2_buffer_done(VB2_BUF_STATE_ERROR).
> This will give ownership back to userspace.
> 
> And I don't think vidc_vb2_stop_streaming does that right now.

Me too, I will re-consider it.

> 
>> +	.buf_queue = vidc_vb2_buf_queue,
>> +};
>> +
>> +static int vdec_empty_buf_done(struct hfi_inst *hfi_inst, u32 addr,
>> +			       u32 bytesused, u32 data_offset, u32 flags)
>> +{
>> +	struct vidc_inst *inst = hfi_inst->ops_priv;
>> +	struct vb2_v4l2_buffer *vbuf;
>> +	struct vb2_buffer *vb;
>> +
>> +	vbuf = vidc_vb2_find_buf(inst, addr);
>> +	if (!vbuf)
>> +		return -EINVAL;
>> +
>> +	vb = &vbuf->vb2_buf;
>> +	vbuf->flags = flags;
>> +
>> +	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
>> +
>> +	return 0;
>> +}
>> +
>> +static int vdec_fill_buf_done(struct hfi_inst *hfi_inst, u32 addr,
>> +			      u32 bytesused, u32 data_offset, u32 flags,
>> +			      struct timeval *timestamp)
>> +{
>> +	struct vidc_inst *inst = hfi_inst->ops_priv;
>> +	struct vb2_v4l2_buffer *vbuf;
>> +	struct vb2_buffer *vb;
>> +
>> +	vbuf = vidc_vb2_find_buf(inst, addr);
>> +	if (!vbuf)
>> +		return -EINVAL;
>> +
>> +	vb = &vbuf->vb2_buf;
>> +	vb->planes[0].bytesused = bytesused;
>> +	vb->planes[0].data_offset = data_offset;
>> +	vb->timestamp = timeval_to_ns(timestamp);
>> +	vbuf->flags = flags;
>> +	vbuf->sequence = inst->sequence++;
>> +
>> +	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
>> +
>> +	if (vbuf->flags & V4L2_BUF_FLAG_LAST) {
>> +		const struct v4l2_event ev = {
> 
> I think this can be static const.

Sure, will do it.

> 
>> +			.type = V4L2_EVENT_EOS
>> +		};
>> +
>> +		v4l2_event_queue_fh(&inst->fh, &ev);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int vdec_event_notify(struct hfi_inst *hfi_inst, u32 event,
>> +			     struct hfi_event_data *data)
>> +{
>> +	struct vidc_inst *inst = hfi_inst->ops_priv;
>> +	struct device *dev = inst->core->dev;
>> +	const struct v4l2_event ev = { .type = V4L2_EVENT_SOURCE_CHANGE };
> 
> I think this can be static const.

Sure, will do it.

> 
>> +
>> +	switch (event) {
>> +	case EVT_SESSION_ERROR:
>> +		if (hfi_inst) {
>> +			mutex_lock(&hfi_inst->lock);
>> +			inst->hfi_inst->state = INST_INVALID;
>> +			mutex_unlock(&hfi_inst->lock);
>> +		}
>> +		dev_err(dev, "dec: event session error (inst:%p)\n", hfi_inst);
>> +		break;
>> +	case EVT_SYS_EVENT_CHANGE:
>> +		switch (data->event_type) {
>> +		case HFI_EVENT_DATA_SEQUENCE_CHANGED_SUFFICIENT_BUF_RESOURCES:
>> +			dev_dbg(dev, "event sufficient resources\n");
>> +			break;
>> +		case HFI_EVENT_DATA_SEQUENCE_CHANGED_INSUFFICIENT_BUF_RESOURCES:
>> +			inst->reconfig_height = data->height;
>> +			inst->reconfig_width = data->width;
>> +			inst->in_reconfig = true;
>> +
>> +			v4l2_event_queue_fh(&inst->fh, &ev);
>> +
>> +			dev_dbg(dev, "event not sufficient resources (%ux%u)\n",
>> +				data->width, data->height);
>> +			break;
>> +		default:
>> +			break;
>> +		}
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return 0;
>> +}
>> +

<cut>

>> diff --git a/drivers/media/platform/qcom/vidc/vdec_ctrls.c b/drivers/media/platform/qcom/vidc/vdec_ctrls.c
>> new file mode 100644
>> index 000000000000..59225d8f1fd9
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/vidc/vdec_ctrls.c
>> @@ -0,0 +1,200 @@
>> +/*
>> + * Copyright (c) 2012-2015, The Linux Foundation. All rights reserved.
>> + * Copyright (C) 2016 Linaro Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +#include <linux/types.h>
>> +#include <media/v4l2-ctrls.h>
>> +
>> +#include "core.h"
>> +
>> +static struct vidc_ctrl vdec_ctrls[] = {
>> +	{
>> +		.id = V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE,
>> +		.type = V4L2_CTRL_TYPE_MENU,
>> +		.min = V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE,
>> +		.max = V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_CODING_EFFICIENCY,
>> +		.def = V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE,
>> +		.flags = V4L2_CTRL_FLAG_VOLATILE,
>> +		.menu_skip_mask = ~(
>> +			(1 << V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE) |
>> +			(1 << V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_SIMPLE)
>> +		),
>> +	}, {
>> +		.id = V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL,
>> +		.type = V4L2_CTRL_TYPE_MENU,
>> +		.min = V4L2_MPEG_VIDEO_MPEG4_LEVEL_0,
>> +		.max = V4L2_MPEG_VIDEO_MPEG4_LEVEL_5,
>> +		.def = V4L2_MPEG_VIDEO_MPEG4_LEVEL_0,
>> +		.flags = V4L2_CTRL_FLAG_VOLATILE,
>> +	}, {
>> +		.id = V4L2_CID_MPEG_VIDEO_H264_PROFILE,
>> +		.type = V4L2_CTRL_TYPE_MENU,
>> +		.min = V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE,
>> +		.max = V4L2_MPEG_VIDEO_H264_PROFILE_MULTIVIEW_HIGH,
>> +		.def = V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE,
>> +		.flags = V4L2_CTRL_FLAG_VOLATILE,
>> +		.menu_skip_mask = ~(
>> +		(1 << V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
>> +		(1 << V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE) |
>> +		(1 << V4L2_MPEG_VIDEO_H264_PROFILE_MAIN) |
>> +		(1 << V4L2_MPEG_VIDEO_H264_PROFILE_HIGH) |
>> +		(1 << V4L2_MPEG_VIDEO_H264_PROFILE_STEREO_HIGH) |
>> +		(1 << V4L2_MPEG_VIDEO_H264_PROFILE_MULTIVIEW_HIGH)
>> +		),
>> +	}, {
>> +		.id = V4L2_CID_MPEG_VIDEO_H264_LEVEL,
>> +		.type = V4L2_CTRL_TYPE_MENU,
>> +		.min = V4L2_MPEG_VIDEO_H264_LEVEL_1_0,
>> +		.max = V4L2_MPEG_VIDEO_H264_LEVEL_5_1,
>> +		.def = V4L2_MPEG_VIDEO_H264_LEVEL_1_0,
>> +		.flags = V4L2_CTRL_FLAG_VOLATILE,
>> +	}, {
>> +		.id = V4L2_CID_MPEG_VIDEO_VPX_PROFILE,
>> +		.type = V4L2_CTRL_TYPE_INTEGER,
>> +		.min = 0,
>> +		.max = 3,
>> +		.step = 1,
>> +		.def = 0,
>> +		.flags = V4L2_CTRL_FLAG_VOLATILE,
>> +	}, {
>> +		.id = V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER,
>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
>> +		.def = 0,
>> +	},
>> +};
>> +
>> +#define NUM_CTRLS	ARRAY_SIZE(vdec_ctrls)
>> +
>> +static int vdec_op_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct vidc_inst *inst = ctrl_to_inst(ctrl);
>> +	struct vdec_controls *ctr = &inst->controls.dec;
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER:
>> +		ctr->post_loop_deb_mode = ctrl->val;
>> +		break;
>> +	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
>> +	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
>> +	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
>> +		ctr->profile = ctrl->val;
>> +		break;
>> +	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
>> +	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
>> +		ctr->level = ctrl->val;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int vdec_op_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct vidc_inst *inst = ctrl_to_inst(ctrl);
>> +	struct vdec_controls *ctr = &inst->controls.dec;
>> +	struct hfi_core *hfi = &inst->core->hfi;
>> +	union hfi_get_property hprop;
>> +	u32 ptype = HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT;
>> +	int ret;
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
>> +	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
>> +	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
>> +		ret = vidc_hfi_session_get_property(hfi, inst->hfi_inst, ptype,
>> +						    &hprop);
>> +		if (!ret)
>> +			ctr->profile = hprop.profile_level.profile;
>> +		ctrl->val = ctr->profile;
>> +		break;
>> +	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
>> +	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
>> +		ret = vidc_hfi_session_get_property(hfi, inst->hfi_inst, ptype,
>> +						    &hprop);
>> +		if (!ret)
>> +			ctr->level = hprop.profile_level.level;
>> +		ctrl->val = ctr->level;
>> +		break;
>> +	case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER:
>> +		ctrl->val = ctr->post_loop_deb_mode;
>> +		break;
> 
> Why are these volatile?

Because the firmware acording to stream headers that profile and levels
are different.

> 
>> +	default:
>> +		return -EINVAL;
>> +	};
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct v4l2_ctrl_ops vdec_ctrl_ops = {
>> +	.s_ctrl = vdec_op_s_ctrl,
>> +	.g_volatile_ctrl = vdec_op_g_volatile_ctrl,
>> +};
>> +
>> +int vdec_ctrl_init(struct vidc_inst *inst)
>> +{
>> +	unsigned int i;
>> +	int ret;
>> +
>> +	ret = v4l2_ctrl_handler_init(&inst->ctrl_handler, NUM_CTRLS);
>> +	if (ret)
>> +		return ret;
>> +
>> +	for (i = 0; i < NUM_CTRLS; i++) {
>> +		struct v4l2_ctrl *ctrl;
>> +
>> +		if (vdec_ctrls[i].type == V4L2_CTRL_TYPE_MENU) {
>> +			ctrl = v4l2_ctrl_new_std_menu(&inst->ctrl_handler,
>> +					&vdec_ctrl_ops,
>> +					vdec_ctrls[i].id,
>> +					vdec_ctrls[i].max,
>> +					vdec_ctrls[i].menu_skip_mask,
>> +					vdec_ctrls[i].def);
>> +		} else {
>> +			ctrl = v4l2_ctrl_new_std(&inst->ctrl_handler,
>> +					&vdec_ctrl_ops,
>> +					vdec_ctrls[i].id,
>> +					vdec_ctrls[i].min,
>> +					vdec_ctrls[i].max,
>> +					vdec_ctrls[i].step,
>> +					vdec_ctrls[i].def);
>> +		}
> 
> Why have this vdec_ctrls array at all? Just call v4l2_ctrl_new_std(_menu)
> directly for the controls you want to add. Most drivers do that.

Sure I can give it a try, the only thing I am concerned on is the code size.

<cut>

-- 
regards,
Stan
