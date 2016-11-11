Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:34905 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754572AbcKKLcd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 06:32:33 -0500
Subject: Re: [PATCH v3 3/9] media: venus: adding core part and helper
 functions
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-4-git-send-email-stanimir.varbanov@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f907ec9a-6d61-07f8-2135-f399e656d4e4@xs4all.nl>
Date: Fri, 11 Nov 2016 12:32:28 +0100
MIME-Version: 1.0
In-Reply-To: <1478540043-24558-4-git-send-email-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

Some comments:

On 11/07/2016 06:33 PM, Stanimir Varbanov wrote:
>  * core.c has implemented the platform dirver methods, file
> operations and v4l2 registration.
> 
>  * helpers.c has implemented common helper functions for:
>    - buffer management
> 
>    - vb2_ops and functions for format propagation,
> 
>    - functions for allocating and freeing buffers for
>    internal usage. The buffer parameters describing internal
>    buffers depends on current format, resolution and codec.
> 
>    - functions for calculation of current load of the
>    hardware. Depending on the count of instances and
>    resolutions it selects the best clock rate for the video
>    core.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/core.c    | 557 +++++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/core.h    | 261 ++++++++++++
>  drivers/media/platform/qcom/venus/helpers.c | 612 ++++++++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/helpers.h |  43 ++
>  4 files changed, 1473 insertions(+)
>  create mode 100644 drivers/media/platform/qcom/venus/core.c
>  create mode 100644 drivers/media/platform/qcom/venus/core.h
>  create mode 100644 drivers/media/platform/qcom/venus/helpers.c
>  create mode 100644 drivers/media/platform/qcom/venus/helpers.h
> 

<snip>

> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> new file mode 100644
> index 000000000000..21ed053aeb17
> --- /dev/null
> +++ b/drivers/media/platform/qcom/venus/core.h

<snip>

> +struct venus_ctrl {
> +	u32 id;
> +	enum v4l2_ctrl_type type;
> +	s32 min;
> +	s32 max;
> +	s32 def;
> +	u32 step;
> +	u64 menu_skip_mask;
> +	u32 flags;
> +	const char * const *qmenu;
> +};

Why duplicate struct v4l2_ctrl_config? Just use that struct to define custom controls
together with v4l2_ctrl_new_custom().

> +
> +/*
> + * Offset base for buffers on the destination queue - used to distinguish
> + * between source and destination buffers when mmapping - they receive the same
> + * offsets but for different queues
> + */
> +#define DST_QUEUE_OFF_BASE	(1 << 30)
> +
> +static inline struct venus_inst *to_inst(struct file *filp)
> +{
> +	return container_of(filp->private_data, struct venus_inst, fh);
> +}
> +
> +static inline void *to_hfi_priv(struct venus_core *core)
> +{
> +	return core->priv;
> +}
> +
> +static inline struct vb2_queue *
> +to_vb2q(struct file *file, enum v4l2_buf_type type)
> +{
> +	struct venus_inst *inst = to_inst(file);
> +
> +	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		return &inst->bufq_cap;
> +	else if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		return &inst->bufq_out;
> +
> +	return NULL;
> +}
> +
> +#endif
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> new file mode 100644
> index 000000000000..c2d1446ad254
> --- /dev/null
> +++ b/drivers/media/platform/qcom/venus/helpers.c

<snip>

> +void vidc_vb2_stop_streaming(struct vb2_queue *q)
> +{
> +	struct venus_inst *inst = vb2_get_drv_priv(q);
> +	struct venus_core *core = inst->core;
> +	struct device *dev = core->dev;
> +	struct vb2_queue *other_queue;
> +	struct vidc_buffer *buf, *n;
> +	enum vb2_buffer_state state;
> +	int ret;
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		other_queue = &inst->bufq_cap;
> +	else
> +		other_queue = &inst->bufq_out;
> +
> +	if (!vb2_is_streaming(other_queue))
> +		return;

This seems wrong to me: this return means that the buffers of queue q are never
released. Either drop this 'if' or release both queues when the last queue
stops streaming. I think dropping the 'if' is best.

> +
> +	ret = hfi_session_stop(inst);
> +	if (ret) {
> +		dev_err(dev, "session: stop failed (%d)\n", ret);
> +		goto abort;
> +	}
> +
> +	ret = hfi_session_unload_res(inst);
> +	if (ret) {
> +		dev_err(dev, "session: release resources failed (%d)\n", ret);
> +		goto abort;
> +	}
> +
> +	ret = session_unregister_bufs(inst);
> +	if (ret) {
> +		dev_err(dev, "failed to release capture buffers: %d\n", ret);
> +		goto abort;
> +	}
> +
> +	ret = intbufs_free(inst);
> +
> +	if (inst->state == INST_INVALID || core->state == CORE_INVALID)
> +		ret = -EINVAL;
> +
> +abort:
> +	if (ret)
> +		hfi_session_abort(inst);
> +
> +	load_scale_clocks(core);
> +
> +	ret = hfi_session_deinit(inst);
> +
> +	pm_runtime_put_sync(dev);
> +
> +	mutex_lock(&inst->bufqueue_lock);
> +
> +	if (list_empty(&inst->bufqueue)) {
> +		mutex_unlock(&inst->bufqueue_lock);
> +		return;
> +	}
> +
> +	if (ret)
> +		state = VB2_BUF_STATE_ERROR;
> +	else
> +		state = VB2_BUF_STATE_DONE;

Are you sure that the state depends on 'ret'? Usually when stop_streaming is
called none of the pending buffers are filled with valid frame data, so the
state is set to ERROR.

STATE_DONE implies that the contents of the buffers has valid frame data.

> +
> +	list_for_each_entry_safe(buf, n, &inst->bufqueue, list) {
> +		vb2_buffer_done(&buf->vb.vb2_buf, state);
> +		list_del(&buf->list);
> +	}
> +
> +	mutex_unlock(&inst->bufqueue_lock);
> +}
> +
> +int vidc_vb2_start_streaming(struct venus_inst *inst)
> +{
> +	struct venus_core *core = inst->core;
> +	struct vidc_buffer *buf, *n;
> +	int ret;
> +
> +	ret = intbufs_alloc(inst);
> +	if (ret)
> +		return ret;

This should still release all buffers instead of returning an error.

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
> +	mutex_lock(&inst->bufqueue_lock);
> +	list_for_each_entry_safe(buf, n, &inst->bufqueue, list) {
> +		ret = session_set_buf(&buf->vb.vb2_buf);
> +		if (ret)
> +			break;
> +	}
> +	mutex_unlock(&inst->bufqueue_lock);
> +
> +	if (ret)
> +		goto err_session_stop;
> +
> +	return 0;
> +
> +err_session_stop:
> +	hfi_session_stop(inst);
> +err_unload_res:
> +	hfi_session_unload_res(inst);
> +err_unreg_bufs:
> +	session_unregister_bufs(inst);
> +err_bufs_free:
> +	intbufs_free(inst);
> +
> +	mutex_lock(&inst->bufqueue_lock);
> +
> +	if (list_empty(&inst->bufqueue))
> +		goto err_done;
> +
> +	list_for_each_entry_safe(buf, n, &inst->bufqueue, list) {
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
> +		list_del(&buf->list);
> +	}

I think this is done in the wrong place. The vdec has its own high level start_streaming
that calls this function, but that high level function doesn't release the buffers at
all if there is an error. Same for venc. I propose that you make a new function that
just releases the buffers and call that from the vdec/venc start_streaming function
whenever an error occurs.

> +
> +err_done:
> +	mutex_unlock(&inst->bufqueue_lock);
> +
> +	return ret;
> +}

Regards,

	Hans
