Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41406 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbeEBHkm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2018 03:40:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 02 May 2018 13:10:40 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 26/28] venus: implementing multi-stream support
In-Reply-To: <20180424124436.26955-27-stanimir.varbanov@linaro.org>
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
 <20180424124436.26955-27-stanimir.varbanov@linaro.org>
Message-ID: <d3611ce941e71fd901cce70da89f9ab4@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Stanimir,

On 2018-04-24 18:14, Stanimir Varbanov wrote:
> This is implementing a multi-stream decoder support. The multi
> stream gives an option to use the secondary decoder output
> with different raw format (or the same in case of crop).
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/core.h    |   1 +
>  drivers/media/platform/qcom/venus/helpers.c | 204 
> +++++++++++++++++++++++++++-
>  drivers/media/platform/qcom/venus/helpers.h |   6 +
>  drivers/media/platform/qcom/venus/vdec.c    |  91 ++++++++++++-
>  drivers/media/platform/qcom/venus/venc.c    |   1 +
>  5 files changed, 299 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/core.h
> b/drivers/media/platform/qcom/venus/core.h
> index 4d6c05f156c4..85e66e2dd672 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -259,6 +259,7 @@ struct venus_inst {
>  	struct list_head list;
>  	struct mutex lock;
>  	struct venus_core *core;
> +	struct list_head dpbbufs;
>  	struct list_head internalbufs;
>  	struct list_head registeredbufs;
>  	struct list_head delayed_process;
> diff --git a/drivers/media/platform/qcom/venus/helpers.c
> b/drivers/media/platform/qcom/venus/helpers.c
> index ed569705ecac..87dcf9973e6f 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -85,6 +85,112 @@ bool venus_helper_check_codec(struct venus_inst
> *inst, u32 v4l2_pixfmt)
>  }
>  EXPORT_SYMBOL_GPL(venus_helper_check_codec);
> 
> +static int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
> +{
> +	struct intbuf *buf;
> +	int ret = 0;
> +
> +	if (list_empty(&inst->dpbbufs))
> +		return 0;
> +
> +	list_for_each_entry(buf, &inst->dpbbufs, list) {
> +		struct hfi_frame_data fdata;
> +
> +		memset(&fdata, 0, sizeof(fdata));
> +		fdata.alloc_len = buf->size;
> +		fdata.device_addr = buf->da;
> +		fdata.buffer_type = buf->type;
> +
> +		ret = hfi_session_process_buf(inst, &fdata);
> +		if (ret)
> +			goto fail;
> +	}
> +
> +fail:
> +	return ret;
> +}
> +
> +int venus_helper_free_dpb_bufs(struct venus_inst *inst)
> +{
> +	struct intbuf *buf, *n;
> +
> +	if (list_empty(&inst->dpbbufs))
> +		return 0;
> +
> +	list_for_each_entry_safe(buf, n, &inst->dpbbufs, list) {
> +		list_del_init(&buf->list);
> +		dma_free_attrs(inst->core->dev, buf->size, buf->va, buf->da,
> +			       buf->attrs);
> +		kfree(buf);
> +	}
> +
> +	INIT_LIST_HEAD(&inst->dpbbufs);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(venus_helper_free_dpb_bufs);
> +
> +int venus_helper_alloc_dpb_bufs(struct venus_inst *inst)
> +{
> +	struct venus_core *core = inst->core;
> +	struct device *dev = core->dev;
> +	enum hfi_version ver = core->res->hfi_version;
> +	struct hfi_buffer_requirements bufreq;
> +	u32 buftype = inst->dpb_buftype;
> +	unsigned int dpb_size = 0;
> +	struct intbuf *buf;
> +	unsigned int i;
> +	u32 count;
> +	int ret;
> +
> +	/* no need to allocate dpb buffers */
> +	if (!inst->dpb_fmt)
> +		return 0;
> +
> +	if (inst->dpb_buftype == HFI_BUFFER_OUTPUT)
> +		dpb_size = inst->output_buf_size;
> +	else if (inst->dpb_buftype == HFI_BUFFER_OUTPUT2)
> +		dpb_size = inst->output2_buf_size;
> +
> +	if (!dpb_size)
> +		return 0;
> +
> +	ret = venus_helper_get_bufreq(inst, buftype, &bufreq);
> +	if (ret)
> +		return ret;
> +
> +	count = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
> +
> +	for (i = 0; i < count; i++) {
> +		buf = kzalloc(sizeof(*buf), GFP_KERNEL);
> +		if (!buf) {
> +			ret = -ENOMEM;
> +			goto fail;
> +		}
> +
> +		buf->type = buftype;
> +		buf->size = dpb_size;
> +		buf->attrs = DMA_ATTR_WRITE_COMBINE |
> +			     DMA_ATTR_NO_KERNEL_MAPPING;
> +		buf->va = dma_alloc_attrs(dev, buf->size, &buf->da, GFP_KERNEL,
> +					  buf->attrs);
> +		if (!buf->va) {
> +			kfree(buf);
> +			ret = -ENOMEM;
> +			goto fail;
> +		}
> +
> +		list_add_tail(&buf->list, &inst->dpbbufs);
> +	}
> +
> +	return 0;
> +
> +fail:
> +	venus_helper_free_dpb_bufs(inst);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(venus_helper_alloc_dpb_bufs);
> +
>  static int intbufs_set_buffer(struct venus_inst *inst, u32 type)
>  {
>  	struct venus_core *core = inst->core;
> @@ -342,7 +448,10 @@ session_process_buf(struct venus_inst *inst,
> struct vb2_v4l2_buffer *vbuf)
>  		if (vbuf->flags & V4L2_BUF_FLAG_LAST || !fdata.filled_len)
>  			fdata.flags |= HFI_BUFFERFLAG_EOS;
>  	} else if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> -		fdata.buffer_type = HFI_BUFFER_OUTPUT;
> +		if (inst->session_type == VIDC_SESSION_TYPE_ENC)
> +			fdata.buffer_type = HFI_BUFFER_OUTPUT;
> +		else
> +			fdata.buffer_type = inst->opb_buftype;
>  		fdata.filled_len = 0;
>  		fdata.offset = 0;
>  	}
> @@ -675,6 +784,27 @@ int venus_helper_set_color_format(struct
> venus_inst *inst, u32 pixfmt)
>  }
>  EXPORT_SYMBOL_GPL(venus_helper_set_color_format);
> 
> +int venus_helper_set_multistream(struct venus_inst *inst, bool out_en,
> +				 bool out2_en)
> +{
> +	struct hfi_multi_stream multi = {0};
> +	u32 ptype = HFI_PROPERTY_PARAM_VDEC_MULTI_STREAM;
> +	int ret;
> +
> +	multi.buffer_type = HFI_BUFFER_OUTPUT;
> +	multi.enable = out_en;
> +
> +	ret = hfi_session_set_property(inst, ptype, &multi);
> +	if (ret)
> +		return ret;
> +
> +	multi.buffer_type = HFI_BUFFER_OUTPUT2;
> +	multi.enable = out2_en;
> +
> +	return hfi_session_set_property(inst, ptype, &multi);
> +}
> +EXPORT_SYMBOL_GPL(venus_helper_set_multistream);
> +
>  int venus_helper_set_dyn_bufmode(struct venus_inst *inst)
>  {
>  	u32 ptype = HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE;
> @@ -822,9 +952,10 @@ EXPORT_SYMBOL_GPL(venus_helper_vb2_buf_init);
>  int venus_helper_vb2_buf_prepare(struct vb2_buffer *vb)
>  {
>  	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned int out_buf_size = venus_helper_get_opb_size(inst);
> 
>  	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> -	    vb2_plane_size(vb, 0) < inst->output_buf_size)
> +	    vb2_plane_size(vb, 0) < out_buf_size)
>  		return -EINVAL;
>  	if (vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
>  	    vb2_plane_size(vb, 0) < inst->input_buf_size)
> @@ -894,6 +1025,8 @@ void venus_helper_vb2_stop_streaming(struct 
> vb2_queue *q)
>  		if (ret)
>  			hfi_session_abort(inst);
> 
> +		venus_helper_free_dpb_bufs(inst);
> +
>  		load_scale_clocks(core);
>  		INIT_LIST_HEAD(&inst->registeredbufs);
>  	}
> @@ -932,8 +1065,14 @@ int venus_helper_vb2_start_streaming(struct
> venus_inst *inst)
>  	if (ret)
>  		goto err_unload_res;
> 
> +	ret = venus_helper_queue_dpb_bufs(inst);
> +	if (ret)
> +		goto err_session_stop;
> +
>  	return 0;
> 
> +err_session_stop:
> +	hfi_session_stop(inst);
>  err_unload_res:
>  	hfi_session_unload_res(inst);
>  err_unreg_bufs:
> @@ -987,6 +1126,67 @@ void venus_helper_init_instance(struct venus_inst 
> *inst)
>  }
>  EXPORT_SYMBOL_GPL(venus_helper_init_instance);
> 
> +static bool find_fmt_from_caps(struct venus_caps *caps, u32 buftype, 
> u32 fmt)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < caps->num_fmts; i++) {
> +		if (caps->fmts[i].buftype == buftype &&
> +		    caps->fmts[i].fmt == fmt)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +int venus_helper_get_out_fmts(struct venus_inst *inst, u32 v4l2_fmt,
> +			      u32 *out_fmt, u32 *out2_fmt, bool ubwc)
> +{
> +	struct venus_core *core = inst->core;
> +	struct venus_caps *caps;
> +	u32 ubwc_fmt, fmt = to_hfi_raw_fmt(v4l2_fmt);
> +	bool found, found_ubwc;
> +
> +	*out_fmt = *out2_fmt = 0;
> +
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	caps = venus_caps_by_codec(core, inst->hfi_codec, 
> inst->session_type);
> +	if (!caps)
> +		return -EINVAL;
> +
> +	if (ubwc) {
> +		ubwc_fmt = fmt | HFI_COLOR_FORMAT_UBWC_BASE;
> +		found_ubwc = find_fmt_from_caps(caps, HFI_BUFFER_OUTPUT,
> +						ubwc_fmt);
> +		found = find_fmt_from_caps(caps, HFI_BUFFER_OUTPUT2, fmt);
> +
> +		if (found_ubwc && found) {
> +			*out_fmt = ubwc_fmt;
> +			*out2_fmt = fmt;
> +			return 0;
> +		}
> +	}
> +
> +	found = find_fmt_from_caps(caps, HFI_BUFFER_OUTPUT, fmt);
> +	if (found) {
> +		*out_fmt = fmt;
> +		*out2_fmt = 0;
> +		return 0;
> +	}
> +
> +	found = find_fmt_from_caps(caps, HFI_BUFFER_OUTPUT2, fmt);
> +	if (found) {
> +		*out_fmt = 0;
> +		*out2_fmt = fmt;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(venus_helper_get_out_fmts);
> +
>  int venus_helper_power_enable(struct venus_core *core, u32 
> session_type,
>  			      bool enable)
>  {
> diff --git a/drivers/media/platform/qcom/venus/helpers.h
> b/drivers/media/platform/qcom/venus/helpers.h
> index 92b167a47166..2475f284f396 100644
> --- a/drivers/media/platform/qcom/venus/helpers.h
> +++ b/drivers/media/platform/qcom/venus/helpers.h
> @@ -50,10 +50,16 @@ int venus_helper_set_raw_format(struct venus_inst
> *inst, u32 hfi_format,
>  int venus_helper_set_color_format(struct venus_inst *inst, u32 fmt);
>  int venus_helper_set_dyn_bufmode(struct venus_inst *inst);
>  int venus_helper_set_bufsize(struct venus_inst *inst, u32 bufsize,
> u32 buftype);
> +int venus_helper_set_multistream(struct venus_inst *inst, bool out_en,
> +				 bool out2_en);
>  unsigned int venus_helper_get_opb_size(struct venus_inst *inst);
>  void venus_helper_acquire_buf_ref(struct vb2_v4l2_buffer *vbuf);
>  void venus_helper_release_buf_ref(struct venus_inst *inst, unsigned 
> int idx);
>  void venus_helper_init_instance(struct venus_inst *inst);
> +int venus_helper_get_out_fmts(struct venus_inst *inst, u32 fmt, u32 
> *out_fmt,
> +			      u32 *out2_fmt, bool ubwc);
> +int venus_helper_alloc_dpb_bufs(struct venus_inst *inst);
> +int venus_helper_free_dpb_bufs(struct venus_inst *inst);
>  int venus_helper_power_enable(struct venus_core *core, u32 
> session_type,
>  			      bool enable);
>  #endif
> diff --git a/drivers/media/platform/qcom/venus/vdec.c
> b/drivers/media/platform/qcom/venus/vdec.c
> index 589fc13b84bc..7deee104ac56 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -532,10 +532,16 @@ static int vdec_set_properties(struct venus_inst 
> *inst)
>  	return 0;
>  }
> 
> +#define is_ubwc_fmt(fmt) (!!((fmt) & HFI_COLOR_FORMAT_UBWC_BASE))
> +
>  static int vdec_output_conf(struct venus_inst *inst)
>  {
>  	struct venus_core *core = inst->core;
>  	struct hfi_enable en = { .enable = 1 };
> +	u32 width = inst->out_width;
> +	u32 height = inst->out_height;
> +	u32 out_fmt, out2_fmt;
> +	bool ubwc = false;
>  	u32 ptype;
>  	int ret;
> 
> @@ -554,6 +560,78 @@ static int vdec_output_conf(struct venus_inst 
> *inst)
>  			return ret;
>  	}
> 
> +	if (width > 1920 && height > ALIGN(1080, 32))
> +		ubwc = true;
> +
> +	if (IS_V4(core))
> +		ubwc = true;
> +
> +	ret = venus_helper_get_out_fmts(inst, inst->fmt_cap->pixfmt, 
> &out_fmt,
> +					&out2_fmt, ubwc);
> +	if (ret)
> +		return ret;
> +
> +	inst->output_buf_size =
> +			venus_helper_get_framesz_raw(out_fmt, width, height);
> +	inst->output2_buf_size =
> +			venus_helper_get_framesz_raw(out2_fmt, width, height);
> +
> +	if (is_ubwc_fmt(out_fmt)) {
> +		inst->opb_buftype = HFI_BUFFER_OUTPUT2;
> +		inst->opb_fmt = out2_fmt;
> +		inst->dpb_buftype = HFI_BUFFER_OUTPUT;
> +		inst->dpb_fmt = out_fmt;
> +	} else if (is_ubwc_fmt(out2_fmt)) {
> +		inst->opb_buftype = HFI_BUFFER_OUTPUT;
> +		inst->opb_fmt = out_fmt;
> +		inst->dpb_buftype = HFI_BUFFER_OUTPUT2;
> +		inst->dpb_fmt = out2_fmt;
> +	} else {
> +		inst->opb_buftype = HFI_BUFFER_OUTPUT;
> +		inst->opb_fmt = out_fmt;
> +		inst->dpb_buftype = 0;
> +		inst->dpb_fmt = 0;
> +	}
> +
> +	ret = venus_helper_set_raw_format(inst, inst->opb_fmt,
> +					  inst->opb_buftype);
> +	if (ret)
> +		return ret;
> +
> +	if (inst->dpb_fmt) {
> +		ret = venus_helper_set_multistream(inst, false, true);
> +		if (ret)
> +			return ret;
> +
> +		ret = venus_helper_set_raw_format(inst, inst->dpb_fmt,
> +						  inst->dpb_buftype);
> +		if (ret)
> +			return ret;
> +
> +		ret = venus_helper_set_output_resolution(inst, width, height,
> +							 HFI_BUFFER_OUTPUT2);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (IS_V3(core) || IS_V4(core)) {
> +		if (inst->output2_buf_size) {
> +			ret = venus_helper_set_bufsize(inst,
> +						       inst->output2_buf_size,
> +						       HFI_BUFFER_OUTPUT2);
> +			if (ret)
> +				return ret;
> +		}
> +
> +		if (inst->output_buf_size) {
> +			ret = venus_helper_set_bufsize(inst,
> +						       inst->output_buf_size,
> +						       HFI_BUFFER_OUTPUT);
> +			if (ret)
> +				return ret;
> +		}
> +	}
> +
>  	ret = venus_helper_set_dyn_bufmode(inst);
>  	if (ret)
>  		return ret;
> @@ -624,6 +702,8 @@ static int vdec_queue_setup(struct vb2_queue *q,
>  	int ret = 0;
> 
>  	if (*num_planes) {
> +		unsigned int output_buf_size = venus_helper_get_opb_size(inst);
> +
>  		if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
>  		    *num_planes != inst->fmt_out->num_planes)
>  			return -EINVAL;
> @@ -637,7 +717,7 @@ static int vdec_queue_setup(struct vb2_queue *q,
>  			return -EINVAL;
> 
>  		if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> -		    sizes[0] < inst->output_buf_size)
> +		    sizes[0] < output_buf_size)
>  			return -EINVAL;
> 
>  		return 0;
> @@ -746,6 +826,10 @@ static int vdec_start_streaming(struct vb2_queue
> *q, unsigned int count)
>  	if (ret)
>  		goto deinit_sess;
> 
> +	ret = venus_helper_alloc_dpb_bufs(inst);
> +	if (ret)
> +		goto deinit_sess;
> +
>  	ret = venus_helper_vb2_start_streaming(inst);
>  	if (ret)
>  		goto deinit_sess;
> @@ -797,9 +881,11 @@ static void vdec_buf_done(struct venus_inst
> *inst, unsigned int buf_type,
>  	vbuf->field = V4L2_FIELD_NONE;
> 
>  	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		unsigned int opb_sz = venus_helper_get_opb_size(inst);
> +
>  		vb = &vbuf->vb2_buf;
>  		vb->planes[0].bytesused =
> -			max_t(unsigned int, inst->output_buf_size, bytesused);
> +			max_t(unsigned int, opb_sz, bytesused);
>  		vb->planes[0].data_offset = data_offset;
>  		vb->timestamp = timestamp_us * NSEC_PER_USEC;
>  		vbuf->sequence = inst->sequence_cap++;
> @@ -945,6 +1031,7 @@ static int vdec_open(struct file *file)
>  	if (!inst)
>  		return -ENOMEM;
> 
> +	INIT_LIST_HEAD(&inst->dpbbufs);
>  	INIT_LIST_HEAD(&inst->registeredbufs);
>  	INIT_LIST_HEAD(&inst->internalbufs);
>  	INIT_LIST_HEAD(&inst->list);
> diff --git a/drivers/media/platform/qcom/venus/venc.c
> b/drivers/media/platform/qcom/venus/venc.c
> index 54f253b98b24..a703bce78abc 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -1084,6 +1084,7 @@ static int venc_open(struct file *file)
>  	if (!inst)
>  		return -ENOMEM;
> 
> +	INIT_LIST_HEAD(&inst->dpbbufs);
>  	INIT_LIST_HEAD(&inst->registeredbufs);
>  	INIT_LIST_HEAD(&inst->internalbufs);
>  	INIT_LIST_HEAD(&inst->list);

The dpb buffers queued to hardware will be returned back to host either 
during flush
or when the session is stopped. Host should not send these buffers to 
client.
vdec_buf_done should be handling in a way to drop dpb buffers from 
sending to client.

Thanks,
Vikash
