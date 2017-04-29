Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46242 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1165625AbdD2WVt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Apr 2017 18:21:49 -0400
Date: Sun, 30 Apr 2017 01:21:41 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v8 05/10] media: venus: adding core part and helper
 functions
Message-ID: <20170429222141.GK7456@valkosipuli.retiisi.org.uk>
References: <1493370837-19793-1-git-send-email-stanimir.varbanov@linaro.org>
 <1493370837-19793-6-git-send-email-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493370837-19793-6-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Stan!!

On Fri, Apr 28, 2017 at 12:13:52PM +0300, Stanimir Varbanov wrote:
...
> +int helper_get_bufreq(struct venus_inst *inst, u32 type,
> +		      struct hfi_buffer_requirements *req)
> +{
> +	u32 ptype = HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS;
> +	union hfi_get_property hprop;
> +	int ret, i;

unsigned int i ? It's an array index...

> +
> +	if (req)
> +		memset(req, 0, sizeof(*req));
> +
> +	ret = hfi_session_get_property(inst, ptype, &hprop);
> +	if (ret)
> +		return ret;
> +
> +	ret = -EINVAL;
> +
> +	for (i = 0; i < HFI_BUFFER_TYPE_MAX; i++) {
> +		if (hprop.bufreq[i].type != type)
> +			continue;
> +
> +		if (req)
> +			memcpy(req, &hprop.bufreq[i], sizeof(*req));
> +		ret = 0;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(helper_get_bufreq);

As these are global symbols but still specific to a single driver, it'd be
good to have them prefixed with a common prefix. How about "venus"? You
actually already have that in a macro in the header. :-)

> +
> +int helper_set_input_resolution(struct venus_inst *inst, unsigned int width,
> +				unsigned int height)
> +{
> +	u32 ptype = HFI_PROPERTY_PARAM_FRAME_SIZE;
> +	struct hfi_framesize fs;
> +
> +	fs.buffer_type = HFI_BUFFER_INPUT;
> +	fs.width = width;
> +	fs.height = height;
> +
> +	return hfi_session_set_property(inst, ptype, &fs);
> +}
> +EXPORT_SYMBOL_GPL(helper_set_input_resolution);
> +
> +int helper_set_output_resolution(struct venus_inst *inst, unsigned int width,
> +				 unsigned int height)
> +{
> +	u32 ptype = HFI_PROPERTY_PARAM_FRAME_SIZE;
> +	struct hfi_framesize fs;
> +
> +	fs.buffer_type = HFI_BUFFER_OUTPUT;
> +	fs.width = width;
> +	fs.height = height;
> +
> +	return hfi_session_set_property(inst, ptype, &fs);
> +}
> +EXPORT_SYMBOL_GPL(helper_set_output_resolution);
> +
> +int helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
> +			unsigned int output_bufs)
> +{
> +	u32 ptype = HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL;
> +	struct hfi_buffer_count_actual buf_count;
> +	int ret;
> +
> +	buf_count.type = HFI_BUFFER_INPUT;
> +	buf_count.count_actual = input_bufs;
> +
> +	ret = hfi_session_set_property(inst, ptype, &buf_count);
> +	if (ret)
> +		return ret;
> +
> +	buf_count.type = HFI_BUFFER_OUTPUT;
> +	buf_count.count_actual = output_bufs;
> +
> +	return hfi_session_set_property(inst, ptype, &buf_count);
> +}
> +EXPORT_SYMBOL_GPL(helper_set_num_bufs);
> +
> +int helper_set_color_format(struct venus_inst *inst, u32 pixfmt)
> +{
> +	struct hfi_uncompressed_format_select fmt;
> +	u32 ptype = HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SELECT;
> +	int ret;
> +
> +	if (inst->session_type == VIDC_SESSION_TYPE_DEC)
> +		fmt.buffer_type = HFI_BUFFER_OUTPUT;
> +	else if (inst->session_type == VIDC_SESSION_TYPE_ENC)
> +		fmt.buffer_type = HFI_BUFFER_INPUT;
> +	else
> +		return -EINVAL;
> +
> +	switch (pixfmt) {
> +	case V4L2_PIX_FMT_NV12:
> +		fmt.format = HFI_COLOR_FORMAT_NV12;
> +		break;
> +	case V4L2_PIX_FMT_NV21:
> +		fmt.format = HFI_COLOR_FORMAT_NV21;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret = hfi_session_set_property(inst, ptype, &fmt);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(helper_set_color_format);
> +
> +static void delayed_process_buf_func(struct work_struct *work)
> +{
> +	struct venus_buffer *buf, *n;
> +	struct venus_inst *inst;
> +	int ret;
> +
> +	inst = container_of(work, struct venus_inst, delayed_process_work);
> +
> +	mutex_lock(&inst->lock);
> +
> +	if (!(inst->streamon_out & inst->streamon_cap))
> +		goto unlock;
> +
> +	list_for_each_entry_safe(buf, n, &inst->delayed_process, ref_list) {
> +		if (buf->flags & HFI_BUFFERFLAG_READONLY)
> +			continue;
> +
> +		ret = session_process_buf(inst, &buf->vb);
> +		if (ret)
> +			return_buf_error(inst, &buf->vb);
> +
> +		list_del_init(&buf->ref_list);
> +	}
> +unlock:
> +	mutex_unlock(&inst->lock);
> +}
> +
> +void helper_release_buf_ref(struct venus_inst *inst, unsigned int idx)
> +{
> +	struct venus_buffer *buf;
> +
> +	list_for_each_entry(buf, &inst->registeredbufs, reg_list) {
> +		if (buf->vb.vb2_buf.index == idx) {
> +			buf->flags &= ~HFI_BUFFERFLAG_READONLY;
> +			schedule_work(&inst->delayed_process_work);
> +			break;
> +		}
> +	}
> +}
> +EXPORT_SYMBOL_GPL(helper_release_buf_ref);
> +
> +void helper_acquire_buf_ref(struct vb2_v4l2_buffer *vbuf)
> +{
> +	struct venus_buffer *buf = to_venus_buffer(vbuf);
> +
> +	buf->flags |= HFI_BUFFERFLAG_READONLY;
> +}
> +EXPORT_SYMBOL_GPL(helper_acquire_buf_ref);
> +
> +static int is_buf_refed(struct venus_inst *inst, struct vb2_v4l2_buffer *vbuf)
> +{
> +	struct venus_buffer *buf = to_venus_buffer(vbuf);
> +
> +	if (buf->flags & HFI_BUFFERFLAG_READONLY) {
> +		list_add_tail(&buf->ref_list, &inst->delayed_process);
> +		schedule_work(&inst->delayed_process_work);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +struct vb2_v4l2_buffer *
> +helper_find_buf(struct venus_inst *inst, unsigned int type, u32 idx)
> +{
> +	struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
> +
> +	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		return v4l2_m2m_src_buf_remove_by_idx(m2m_ctx, idx);
> +	else
> +		return v4l2_m2m_dst_buf_remove_by_idx(m2m_ctx, idx);
> +}
> +EXPORT_SYMBOL_GPL(helper_find_buf);
> +
> +int helper_vb2_buf_init(struct vb2_buffer *vb)
> +{
> +	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct venus_buffer *buf = to_venus_buffer(vbuf);
> +	struct sg_table *sgt;
> +
> +	sgt = vb2_dma_sg_plane_desc(vb, 0);
> +	if (!sgt)
> +		return -EFAULT;
> +
> +	buf->size = vb2_plane_size(vb, 0);
> +	buf->dma_addr = sg_dma_address(sgt->sgl);
> +
> +	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		list_add_tail(&buf->reg_list, &inst->registeredbufs);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(helper_vb2_buf_init);
> +
> +int helper_vb2_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> +	    vb2_plane_size(vb, 0) < inst->output_buf_size)
> +		return -EINVAL;
> +	if (vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
> +	    vb2_plane_size(vb, 0) < inst->input_buf_size)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(helper_vb2_buf_prepare);
> +
> +void helper_vb2_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
> +	struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
> +	int ret;
> +
> +	mutex_lock(&inst->lock);
> +
> +	if (inst->cmd_stop) {
> +		vbuf->flags |= V4L2_BUF_FLAG_LAST;
> +		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_DONE);
> +		inst->cmd_stop = false;
> +		goto unlock;
> +	}
> +
> +	v4l2_m2m_buf_queue(m2m_ctx, vbuf);
> +
> +	if (!(inst->streamon_out & inst->streamon_cap))
> +		goto unlock;
> +
> +	ret = is_buf_refed(inst, vbuf);
> +	if (ret)
> +		goto unlock;
> +
> +	ret = session_process_buf(inst, vbuf);
> +	if (ret)
> +		return_buf_error(inst, vbuf);
> +
> +unlock:
> +	mutex_unlock(&inst->lock);
> +}
> +EXPORT_SYMBOL_GPL(helper_vb2_buf_queue);
> +
> +void helper_buffers_done(struct venus_inst *inst, enum vb2_buffer_state state)
> +{
> +	struct vb2_v4l2_buffer *buf;
> +
> +	while ((buf = v4l2_m2m_src_buf_remove(inst->m2m_ctx)))
> +		v4l2_m2m_buf_done(buf, state);
> +	while ((buf = v4l2_m2m_dst_buf_remove(inst->m2m_ctx)))
> +		v4l2_m2m_buf_done(buf, state);
> +}
> +EXPORT_SYMBOL_GPL(helper_buffers_done);
> +
> +void helper_vb2_stop_streaming(struct vb2_queue *q)
> +{
> +	struct venus_inst *inst = vb2_get_drv_priv(q);
> +	struct venus_core *core = inst->core;
> +	int ret;
> +
> +	mutex_lock(&inst->lock);
> +
> +	if (inst->streamon_out & inst->streamon_cap) {
> +		ret = hfi_session_stop(inst);
> +		ret |= hfi_session_unload_res(inst);
> +		ret |= session_unregister_bufs(inst);
> +		ret |= intbufs_free(inst);
> +		ret |= hfi_session_deinit(inst);
> +
> +		if (inst->session_error || core->sys_error)
> +			ret = -EIO;
> +
> +		if (ret)
> +			hfi_session_abort(inst);
> +
> +		load_scale_clocks(core);
> +	}
> +
> +	helper_buffers_done(inst, VB2_BUF_STATE_ERROR);
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		inst->streamon_out = 0;
> +	else
> +		inst->streamon_cap = 0;
> +
> +	mutex_unlock(&inst->lock);
> +}
> +EXPORT_SYMBOL_GPL(helper_vb2_stop_streaming);
> +
> +int helper_vb2_start_streaming(struct venus_inst *inst)
> +{
> +	struct venus_core *core = inst->core;
> +	int ret;
> +
> +	ret = intbufs_alloc(inst);
> +	if (ret)
> +		return ret;
> +
> +	ret = session_register_bufs(inst);
> +	if (ret)
> +		goto err_bufs_free;
> +
> +	load_scale_clocks(core);
> +
> +	ret = hfi_session_load_res(inst);
> +	if (ret)
> +		goto err_unreg_bufs;
> +
> +	ret = hfi_session_start(inst);
> +	if (ret)
> +		goto err_unload_res;
> +
> +	return 0;
> +
> +err_unload_res:
> +	hfi_session_unload_res(inst);
> +err_unreg_bufs:
> +	session_unregister_bufs(inst);
> +err_bufs_free:
> +	intbufs_free(inst);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(helper_vb2_start_streaming);
> +
> +void helper_m2m_device_run(void *priv)
> +{
> +	struct venus_inst *inst = priv;
> +	struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
> +	struct v4l2_m2m_buffer *buf, *n;
> +	int ret;
> +
> +	mutex_lock(&inst->lock);
> +
> +	v4l2_m2m_for_each_dst_buf_safe(m2m_ctx, buf, n) {
> +		ret = session_process_buf(inst, &buf->vb);
> +		if (ret)
> +			return_buf_error(inst, &buf->vb);
> +	}
> +
> +	v4l2_m2m_for_each_src_buf_safe(m2m_ctx, buf, n) {
> +		ret = session_process_buf(inst, &buf->vb);
> +		if (ret)
> +			return_buf_error(inst, &buf->vb);
> +	}
> +
> +	mutex_unlock(&inst->lock);
> +}
> +EXPORT_SYMBOL_GPL(helper_m2m_device_run);
> +
> +void helper_m2m_job_abort(void *priv)
> +{
> +	struct venus_inst *inst = priv;
> +
> +	v4l2_m2m_job_finish(inst->m2m_dev, inst->m2m_ctx);
> +}
> +EXPORT_SYMBOL_GPL(helper_m2m_job_abort);
> +
> +void helper_init_instance(struct venus_inst *inst)
> +{
> +	if (inst->session_type == VIDC_SESSION_TYPE_DEC) {
> +		INIT_LIST_HEAD(&inst->delayed_process);
> +		INIT_WORK(&inst->delayed_process_work,
> +			  delayed_process_buf_func);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(helper_init_instance);
> diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
> new file mode 100644
> index 000000000000..1ff5005b5add
> --- /dev/null
> +++ b/drivers/media/platform/qcom/venus/helpers.h
> @@ -0,0 +1,44 @@
> +/*
> + * Copyright (c) 2012-2016, The Linux Foundation. All rights reserved.
> + * Copyright (C) 2017 Linaro Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +#ifndef __VENUS_HELPERS_H__
> +#define __VENUS_HELPERS_H__
> +
> +#include <media/videobuf2-v4l2.h>
> +
> +struct venus_inst;
> +
> +struct vb2_v4l2_buffer *helper_find_buf(struct venus_inst *inst,
> +					unsigned int type, u32 idx);
> +void helper_buffers_done(struct venus_inst *inst, enum vb2_buffer_state state);
> +int helper_vb2_buf_init(struct vb2_buffer *vb);
> +int helper_vb2_buf_prepare(struct vb2_buffer *vb);
> +void helper_vb2_buf_queue(struct vb2_buffer *vb);
> +void helper_vb2_stop_streaming(struct vb2_queue *q);
> +int helper_vb2_start_streaming(struct venus_inst *inst);
> +void helper_m2m_device_run(void *priv);
> +void helper_m2m_job_abort(void *priv);
> +int helper_get_bufreq(struct venus_inst *inst, u32 type,
> +		      struct hfi_buffer_requirements *req);
> +int helper_set_input_resolution(struct venus_inst *inst, unsigned int width,
> +				unsigned int height);
> +int helper_set_output_resolution(struct venus_inst *inst, unsigned int width,
> +				 unsigned int height);
> +int helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
> +			unsigned int output_bufs);
> +int helper_set_color_format(struct venus_inst *inst, u32 fmt);
> +void helper_acquire_buf_ref(struct vb2_v4l2_buffer *vbuf);
> +void helper_release_buf_ref(struct venus_inst *inst, unsigned int idx);
> +void helper_init_instance(struct venus_inst *inst);
> +#endif
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
