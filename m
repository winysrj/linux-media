Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DECC4360F
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7188D21929
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfBONoN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 08:44:13 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:59211 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726106AbfBONoN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 08:44:13 -0500
Received: from [IPv6:2001:420:44c1:2579:e58e:188a:dca7:31dc] ([IPv6:2001:420:44c1:2579:e58e:188a:dca7:31dc])
        by smtp-cloud7.xs4all.net with ESMTPA
        id udmegW7m7LMwIudmhgWGMT; Fri, 15 Feb 2019 14:44:09 +0100
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <20190117162008.25217-11-stanimir.varbanov@linaro.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <60b3efff-31c1-bc04-8af9-deebb8bc013a@xs4all.nl>
Date:   Fri, 15 Feb 2019 14:44:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190117162008.25217-11-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfLMl6A5ABLX7UQQ/ME383CWEqdkNVKCJD7fanKktMW1BbRO5RQaMYgmPyJLkVDoVwgiAvLg61ye8mKjkj4C+9W2kV56ZxQvmF7X3R/hUqARvwA5Faf+y
 9dWHMxgVcSxhEz4MvbZkD5r41Ffu9Vq6/uzDpYiBpuivaYycjoPalo3wPZLEMw0yQhmEz7xdkEA6aE6crDi2ywo2EAk8tQa5aZ3PF6em8CaeSNLGzl7ADQ9D
 KTR0O2cfw2TFYWT+isey17gnkQ1YdcS85WbcR+moK9tHanl0qipANHgRoSKp9FvTzpl4rD6m08HW6dqomFerm39J8gmne7H6XZR8oeRS+afPnGIZS4dzlIdj
 PphyaKeC7PoL5v6wHl5Ao3iFproWvyeLR9j17mP/mA8j/9AL371LQsBm3RXS5a0BDOXyaZFBuzWhPPGRNjmfWgO7x/cXA4TsJWWgSdFoIA9BINnP78WcWfFE
 OB5or82wSdSPZidDpgMGVFzqr4+97cuvH7Hg5Wlo9bQpbUsDGIt60zUMDkIpyZc+0lkLRxcp/c/tZ5SNhhGOXVjLPXJbRIuqB6wTx8+5rYYSgzOk0N5+SoRl
 Oac=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Stanimir,

I never paid much attention to this patch series since others were busy
discussing it and I had a lot of other things on my plate, but then I heard
that this patch made G_FMT blocking.

That's a no-go. Apparently s5p-mfc does that as well, and that's against
the V4L2 spec as well (clearly I never realized that at the time).

So, just to make it unambiguous:

Nacked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Now, I plan to work on adding stateful codec checks to v4l2-compliance.
I had hoped to do some of that already, but didn't manage to find time
this week. I hope to have something decent in 2-3 weeks from now.

So I would wait with making this driver compliant until I have written
the tests.

Initially I'll test this with vicodec, but the next phase would be to
make it work with e.g. a venus codec. I might contact you for help
when I start work on that.

Regards,

	Hans

On 1/17/19 5:20 PM, Stanimir Varbanov wrote:
> This refactored code for start/stop streaming vb2 operations and
> adds a state machine handling similar to the one in stateful codec
> API documentation. One major change is that now the HFI session is
> started on STREAMON(OUTPUT) and stopped on REQBUF(OUTPUT,count=0),
> during that time streamoff(cap,out) just flush buffers but doesn't
> stop the session. The other major change is that now the capture
> and output queues are completely separated.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/core.h    |  20 +-
>  drivers/media/platform/qcom/venus/helpers.c |  23 +-
>  drivers/media/platform/qcom/venus/helpers.h |   5 +
>  drivers/media/platform/qcom/venus/vdec.c    | 449 ++++++++++++++++----
>  4 files changed, 389 insertions(+), 108 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> index 79c7e816c706..5a133c203455 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -218,6 +218,15 @@ struct venus_buffer {
>  
>  #define to_venus_buffer(ptr)	container_of(ptr, struct venus_buffer, vb)
>  
> +#define DEC_STATE_UNINIT		0
> +#define DEC_STATE_INIT			1
> +#define DEC_STATE_CAPTURE_SETUP		2
> +#define DEC_STATE_STOPPED		3
> +#define DEC_STATE_SEEK			4
> +#define DEC_STATE_DRAIN			5
> +#define DEC_STATE_DECODING		6
> +#define DEC_STATE_DRC			7
> +
>  /**
>   * struct venus_inst - holds per instance paramerters
>   *
> @@ -241,6 +250,10 @@ struct venus_buffer {
>   * @colorspace:	current color space
>   * @quantization:	current quantization
>   * @xfer_func:	current xfer function
> + * @codec_state:	current codec API state (see DEC/ENC_STATE_)
> + * @reconf_wait:	wait queue for resolution change event
> + * @ten_bits:		does new stream is 10bits depth
> + * @buf_count:		used to count number number of buffers (reqbuf(0))
>   * @fps:		holds current FPS
>   * @timeperframe:	holds current time per frame structure
>   * @fmt_out:	a reference to output format structure
> @@ -255,8 +268,6 @@ struct venus_buffer {
>   * @opb_buftype:	output picture buffer type
>   * @opb_fmt:		output picture buffer raw format
>   * @reconfig:	a flag raised by decoder when the stream resolution changed
> - * @reconfig_width:	holds the new width
> - * @reconfig_height:	holds the new height
>   * @hfi_codec:		current codec for this instance in HFI space
>   * @sequence_cap:	a sequence counter for capture queue
>   * @sequence_out:	a sequence counter for output queue
> @@ -296,6 +307,9 @@ struct venus_inst {
>  	u8 ycbcr_enc;
>  	u8 quantization;
>  	u8 xfer_func;
> +	unsigned int codec_state;
> +	wait_queue_head_t reconf_wait;
> +	int buf_count;
>  	u64 fps;
>  	struct v4l2_fract timeperframe;
>  	const struct venus_format *fmt_out;
> @@ -310,8 +324,6 @@ struct venus_inst {
>  	u32 opb_buftype;
>  	u32 opb_fmt;
>  	bool reconfig;
> -	u32 reconfig_width;
> -	u32 reconfig_height;
>  	u32 hfi_codec;
>  	u32 sequence_cap;
>  	u32 sequence_out;
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index 637ce7b82d94..25d8cceccae4 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -1030,16 +1030,15 @@ void venus_helper_vb2_buf_queue(struct vb2_buffer *vb)
>  
>  	v4l2_m2m_buf_queue(m2m_ctx, vbuf);
>  
> -	if (!(inst->streamon_out & inst->streamon_cap))
> -		goto unlock;
> -
> -	ret = is_buf_refed(inst, vbuf);
> -	if (ret)
> -		goto unlock;
> +	if (IS_OUT(vb->vb2_queue, inst) || IS_CAP(vb->vb2_queue, inst)) {
> +		ret = is_buf_refed(inst, vbuf);
> +		if (ret)
> +			goto unlock;
>  
> -	ret = session_process_buf(inst, vbuf);
> -	if (ret)
> -		return_buf_error(inst, vbuf);
> +		ret = session_process_buf(inst, vbuf);
> +		if (ret)
> +			return_buf_error(inst, vbuf);
> +	}
>  
>  unlock:
>  	mutex_unlock(&inst->lock);
> @@ -1155,14 +1154,8 @@ int venus_helper_vb2_start_streaming(struct venus_inst *inst)
>  	if (ret)
>  		goto err_unload_res;
>  
> -	ret = venus_helper_queue_dpb_bufs(inst);
> -	if (ret)
> -		goto err_session_stop;
> -
>  	return 0;
>  
> -err_session_stop:
> -	hfi_session_stop(inst);
>  err_unload_res:
>  	hfi_session_unload_res(inst);
>  err_unreg_bufs:
> diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
> index 2ec1c1a8b416..3b46139b5ee1 100644
> --- a/drivers/media/platform/qcom/venus/helpers.h
> +++ b/drivers/media/platform/qcom/venus/helpers.h
> @@ -17,6 +17,11 @@
>  
>  #include <media/videobuf2-v4l2.h>
>  
> +#define IS_OUT(q, inst) (inst->streamon_out &&	\
> +		q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +#define IS_CAP(q, inst) (inst->streamon_cap &&	\
> +		q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +
>  struct venus_inst;
>  struct venus_core;
>  
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index 7a9370df7515..306e0f7d3337 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -201,28 +201,18 @@ static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
>  	struct venus_inst *inst = to_inst(file);
>  	const struct venus_format *fmt = NULL;
>  	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
> +	int ret;
>  
>  	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>  		fmt = inst->fmt_cap;
>  	else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>  		fmt = inst->fmt_out;
>  
> -	if (inst->reconfig) {
> -		struct v4l2_format format = {};
> -
> -		inst->out_width = inst->reconfig_width;
> -		inst->out_height = inst->reconfig_height;
> -		inst->reconfig = false;
> -
> -		format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> -		format.fmt.pix_mp.pixelformat = inst->fmt_cap->pixfmt;
> -		format.fmt.pix_mp.width = inst->out_width;
> -		format.fmt.pix_mp.height = inst->out_height;
> -
> -		vdec_try_fmt_common(inst, &format);
> -
> -		inst->width = format.fmt.pix_mp.width;
> -		inst->height = format.fmt.pix_mp.height;
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		ret = wait_event_timeout(inst->reconf_wait, inst->reconfig,
> +					 msecs_to_jiffies(100));
> +		if (!ret)
> +			return -EINVAL;
>  	}
>  
>  	pixmp->pixelformat = fmt->pixfmt;
> @@ -457,6 +447,10 @@ vdec_try_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
>  		if (cmd->flags & V4L2_DEC_CMD_STOP_TO_BLACK)
>  			return -EINVAL;
>  		break;
> +	case V4L2_DEC_CMD_START:
> +		if (cmd->flags & V4L2_DEC_CMD_START_MUTE_AUDIO)
> +			return -EINVAL;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -477,18 +471,23 @@ vdec_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
>  
>  	mutex_lock(&inst->lock);
>  
> -	/*
> -	 * Implement V4L2_DEC_CMD_STOP by enqueue an empty buffer on decoder
> -	 * input to signal EOS.
> -	 */
> -	if (!(inst->streamon_out & inst->streamon_cap))
> -		goto unlock;
> +	if (cmd->cmd == V4L2_DEC_CMD_STOP) {
> +		/*
> +		 * Implement V4L2_DEC_CMD_STOP by enqueue an empty buffer on
> +		 * decoder input to signal EOS.
> +		 */
> +		if (!(inst->streamon_out & inst->streamon_cap))
> +			goto unlock;
>  
> -	fdata.buffer_type = HFI_BUFFER_INPUT;
> -	fdata.flags |= HFI_BUFFERFLAG_EOS;
> -	fdata.device_addr = 0xdeadbeef;
> +		fdata.buffer_type = HFI_BUFFER_INPUT;
> +		fdata.flags |= HFI_BUFFERFLAG_EOS;
> +		fdata.device_addr = 0xdeadb000;
>  
> -	ret = hfi_session_process_buf(inst, &fdata);
> +		ret = hfi_session_process_buf(inst, &fdata);
> +
> +		if (!ret && inst->codec_state == DEC_STATE_DECODING)
> +			inst->codec_state = DEC_STATE_DRAIN;
> +	}
>  
>  unlock:
>  	mutex_unlock(&inst->lock);
> @@ -649,20 +648,18 @@ static int vdec_output_conf(struct venus_inst *inst)
>  	return 0;
>  }
>  
> -static int vdec_init_session(struct venus_inst *inst)
> +static int vdec_session_init(struct venus_inst *inst)
>  {
>  	int ret;
>  
>  	ret = hfi_session_init(inst, inst->fmt_out->pixfmt);
> -	if (ret)
> +	if (ret == -EINVAL)
> +		return 0;
> +	else if (ret)
>  		return ret;
>  
> -	ret = venus_helper_set_input_resolution(inst, inst->out_width,
> -						inst->out_height);
> -	if (ret)
> -		goto deinit;
> -
> -	ret = venus_helper_set_color_format(inst, inst->fmt_cap->pixfmt);
> +	ret = venus_helper_set_input_resolution(inst, frame_width_min(inst),
> +						frame_height_min(inst));
>  	if (ret)
>  		goto deinit;
>  
> @@ -681,26 +678,19 @@ static int vdec_num_buffers(struct venus_inst *inst, unsigned int *in_num,
>  
>  	*in_num = *out_num = 0;
>  
> -	ret = vdec_init_session(inst);
> -	if (ret)
> -		return ret;
> -
>  	ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
>  	if (ret)
> -		goto deinit;
> +		return ret;
>  
>  	*in_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
>  
>  	ret = venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
>  	if (ret)
> -		goto deinit;
> +		return ret;
>  
>  	*out_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
>  
> -deinit:
> -	hfi_session_deinit(inst);
> -
> -	return ret;
> +	return 0;
>  }
>  
>  static int vdec_queue_setup(struct vb2_queue *q,
> @@ -733,6 +723,10 @@ static int vdec_queue_setup(struct vb2_queue *q,
>  		return 0;
>  	}
>  
> +	ret = vdec_session_init(inst);
> +	if (ret)
> +		return ret;
> +
>  	ret = vdec_num_buffers(inst, &in_num, &out_num);
>  	if (ret)
>  		return ret;
> @@ -758,6 +752,11 @@ static int vdec_queue_setup(struct vb2_queue *q,
>  		inst->output_buf_size = sizes[0];
>  		*num_buffers = max(*num_buffers, out_num);
>  		inst->num_output_bufs = *num_buffers;
> +
> +		mutex_lock(&inst->lock);
> +		if (inst->codec_state == DEC_STATE_CAPTURE_SETUP)
> +			inst->codec_state = DEC_STATE_STOPPED;
> +		mutex_unlock(&inst->lock);
>  		break;
>  	default:
>  		ret = -EINVAL;
> @@ -794,80 +793,298 @@ static int vdec_verify_conf(struct venus_inst *inst)
>  	return 0;
>  }
>  
> -static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
> +static int vdec_start_capture(struct venus_inst *inst)
>  {
> -	struct venus_inst *inst = vb2_get_drv_priv(q);
>  	int ret;
>  
> -	mutex_lock(&inst->lock);
> +	if (!inst->streamon_out)
> +		return -EINVAL;
>  
> -	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> -		inst->streamon_out = 1;
> -	else
> -		inst->streamon_cap = 1;
> +	if (inst->codec_state == DEC_STATE_DECODING) {
> +		if (inst->reconfig)
> +			goto reconfigure;
>  
> -	if (!(inst->streamon_out & inst->streamon_cap)) {
> -		mutex_unlock(&inst->lock);
> +		venus_helper_queue_dpb_bufs(inst);
> +		venus_helper_process_initial_cap_bufs(inst);
> +		inst->streamon_cap = 1;
>  		return 0;
>  	}
>  
> -	venus_helper_init_instance(inst);
> +	if (inst->codec_state != DEC_STATE_STOPPED)
> +		return -EINVAL;
>  
> -	inst->reconfig = false;
> -	inst->sequence_cap = 0;
> -	inst->sequence_out = 0;
> +reconfigure:
> +	ret = hfi_session_flush(inst, HFI_FLUSH_OUTPUT);
> +	if (ret)
> +		return ret;
>  
> -	ret = vdec_init_session(inst);
> +	ret = vdec_output_conf(inst);
>  	if (ret)
> -		goto bufs_done;
> +		return ret;
> +
> +	ret = venus_helper_set_num_bufs(inst, inst->num_input_bufs,
> +					VB2_MAX_FRAME, VB2_MAX_FRAME);
> +	if (ret)
> +		return ret;
> +
> +	ret = venus_helper_intbufs_realloc(inst);
> +	if (ret)
> +		goto err;
> +
> +	ret = venus_helper_alloc_dpb_bufs(inst);
> +	if (ret)
> +		goto err;
> +
> +	ret = venus_helper_queue_dpb_bufs(inst);
> +	if (ret)
> +		goto free_dpb_bufs;
> +
> +	ret = venus_helper_process_initial_cap_bufs(inst);
> +	if (ret)
> +		goto free_dpb_bufs;
> +
> +	venus_helper_load_scale_clocks(inst->core);
> +
> +	ret = hfi_session_continue(inst);
> +	if (ret)
> +		goto free_dpb_bufs;
> +
> +	inst->codec_state = DEC_STATE_DECODING;
> +
> +	inst->streamon_cap = 1;
> +	inst->sequence_cap = 0;
> +	inst->reconfig = false;
> +
> +	return 0;
> +
> +free_dpb_bufs:
> +	venus_helper_free_dpb_bufs(inst);
> +err:
> +	return ret;
> +}
> +
> +static int vdec_start_output(struct venus_inst *inst)
> +{
> +	int ret;
> +
> +	if (inst->codec_state == DEC_STATE_SEEK) {
> +		ret = venus_helper_process_initial_out_bufs(inst);
> +		inst->codec_state = DEC_STATE_DECODING;
> +		goto done;
> +	}
> +
> +	if (inst->codec_state == DEC_STATE_INIT ||
> +	    inst->codec_state == DEC_STATE_CAPTURE_SETUP) {
> +		ret = venus_helper_process_initial_out_bufs(inst);
> +		goto done;
> +	}
> +
> +	if (inst->codec_state != DEC_STATE_UNINIT)
> +		return -EINVAL;
> +
> +	venus_helper_init_instance(inst);
> +	inst->sequence_out = 0;
> +	inst->reconfig = false;
>  
>  	ret = vdec_set_properties(inst);
>  	if (ret)
> -		goto deinit_sess;
> +		return ret;
>  
>  	ret = vdec_output_conf(inst);
>  	if (ret)
> -		goto deinit_sess;
> +		return ret;
>  
>  	ret = vdec_verify_conf(inst);
>  	if (ret)
> -		goto deinit_sess;
> +		return ret;
>  
>  	ret = venus_helper_set_num_bufs(inst, inst->num_input_bufs,
>  					VB2_MAX_FRAME, VB2_MAX_FRAME);
>  	if (ret)
> -		goto deinit_sess;
> +		return ret;
>  
> -	ret = venus_helper_alloc_dpb_bufs(inst);
> +	ret = venus_helper_vb2_start_streaming(inst);
>  	if (ret)
> -		goto deinit_sess;
> +		return ret;
>  
> -	ret = venus_helper_vb2_start_streaming(inst);
> +	ret = venus_helper_process_initial_out_bufs(inst);
>  	if (ret)
> -		goto deinit_sess;
> +		return ret;
>  
> -	mutex_unlock(&inst->lock);
> +	inst->codec_state = DEC_STATE_INIT;
> +
> +done:
> +	inst->streamon_out = 1;
> +	return ret;
> +}
> +
> +static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct venus_inst *inst = vb2_get_drv_priv(q);
> +	int ret;
> +
> +	mutex_lock(&inst->lock);
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		ret = vdec_start_capture(inst);
> +	else
> +		ret = vdec_start_output(inst);
>  
> +	if (ret)
> +		goto error;
> +
> +	mutex_unlock(&inst->lock);
>  	return 0;
>  
> -deinit_sess:
> -	hfi_session_deinit(inst);
> -bufs_done:
> +error:
>  	venus_helper_buffers_done(inst, VB2_BUF_STATE_QUEUED);
> +	mutex_unlock(&inst->lock);
> +	return ret;
> +}
> +
> +static void vdec_dst_buffers_done(struct venus_inst *inst,
> +				  enum vb2_buffer_state state)
> +{
> +	struct vb2_v4l2_buffer *buf;
> +
> +	while ((buf = v4l2_m2m_dst_buf_remove(inst->m2m_ctx)))
> +		v4l2_m2m_buf_done(buf, state);
> +}
> +
> +static int vdec_stop_capture(struct venus_inst *inst)
> +{
> +	int ret = 0;
> +
> +	switch (inst->codec_state) {
> +	case DEC_STATE_DECODING:
> +		ret = hfi_session_flush(inst, HFI_FLUSH_ALL);
> +		vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
> +		inst->codec_state = DEC_STATE_STOPPED;
> +		break;
> +	case DEC_STATE_DRAIN:
> +		vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
> +		inst->codec_state = DEC_STATE_STOPPED;
> +		break;
> +	case DEC_STATE_DRC:
> +		ret = hfi_session_flush(inst, HFI_FLUSH_OUTPUT);
> +		vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
> +		inst->codec_state = DEC_STATE_CAPTURE_SETUP;
> +		INIT_LIST_HEAD(&inst->registeredbufs);
> +		venus_helper_free_dpb_bufs(inst);
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	return ret;
> +}
> +
> +static int vdec_stop_output(struct venus_inst *inst)
> +{
> +	int ret = 0;
> +
> +	switch (inst->codec_state) {
> +	case DEC_STATE_DECODING:
> +	case DEC_STATE_DRAIN:
> +	case DEC_STATE_STOPPED:
> +		ret = hfi_session_flush(inst, HFI_FLUSH_ALL);
> +		inst->codec_state = DEC_STATE_SEEK;
> +		break;
> +	case DEC_STATE_INIT:
> +	case DEC_STATE_CAPTURE_SETUP:
> +		ret = hfi_session_flush(inst, HFI_FLUSH_INPUT);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static void vdec_stop_streaming(struct vb2_queue *q)
> +{
> +	struct venus_inst *inst = vb2_get_drv_priv(q);
> +	int ret = -EINVAL;
> +
> +	mutex_lock(&inst->lock);
> +
> +	if (IS_CAP(q, inst))
> +		ret = vdec_stop_capture(inst);
> +	else if (IS_OUT(q, inst))
> +		ret = vdec_stop_output(inst);
> +
> +	venus_helper_buffers_done(inst, VB2_BUF_STATE_ERROR);
> +
> +	if (ret)
> +		goto unlock;
> +
>  	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>  		inst->streamon_out = 0;
>  	else
>  		inst->streamon_cap = 0;
> +
> +unlock:
>  	mutex_unlock(&inst->lock);
> -	return ret;
> +}
> +
> +static void vdec_session_release(struct venus_inst *inst)
> +{
> +	struct venus_core *core = inst->core;
> +	int ret, abort = 0;
> +
> +	mutex_lock(&inst->lock);
> +
> +	inst->codec_state = DEC_STATE_UNINIT;
> +
> +	ret = hfi_session_stop(inst);
> +	abort = (ret && ret != -EINVAL) ? 1 : 0;
> +	ret = hfi_session_unload_res(inst);
> +	abort = (ret && ret != -EINVAL) ? 1 : 0;
> +	ret = venus_helper_unregister_bufs(inst);
> +	abort = (ret && ret != -EINVAL) ? 1 : 0;
> +	ret = venus_helper_intbufs_free(inst);
> +	abort = (ret && ret != -EINVAL) ? 1 : 0;
> +	ret = hfi_session_deinit(inst);
> +	abort = (ret && ret != -EINVAL) ? 1 : 0;
> +
> +	if (inst->session_error || core->sys_error)
> +		abort = 1;
> +
> +	if (abort)
> +		hfi_session_abort(inst);
> +
> +	venus_helper_free_dpb_bufs(inst);
> +	venus_helper_load_scale_clocks(core);
> +	INIT_LIST_HEAD(&inst->registeredbufs);
> +
> +	mutex_unlock(&inst->lock);
> +}
> +
> +static int vdec_buf_init(struct vb2_buffer *vb)
> +{
> +	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	inst->buf_count++;
> +
> +	return venus_helper_vb2_buf_init(vb);
> +}
> +
> +static void vdec_buf_cleanup(struct vb2_buffer *vb)
> +{
> +	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	inst->buf_count--;
> +	if (!inst->buf_count)
> +		vdec_session_release(inst);
>  }
>  
>  static const struct vb2_ops vdec_vb2_ops = {
>  	.queue_setup = vdec_queue_setup,
> -	.buf_init = venus_helper_vb2_buf_init,
> +	.buf_init = vdec_buf_init,
> +	.buf_cleanup = vdec_buf_cleanup,
>  	.buf_prepare = venus_helper_vb2_buf_prepare,
>  	.start_streaming = vdec_start_streaming,
> -	.stop_streaming = venus_helper_vb2_stop_streaming,
> +	.stop_streaming = vdec_stop_streaming,
>  	.buf_queue = venus_helper_vb2_buf_queue,
>  };
>  
> @@ -891,6 +1108,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>  
>  	vbuf->flags = flags;
>  	vbuf->field = V4L2_FIELD_NONE;
> +	vb = &vbuf->vb2_buf;
>  
>  	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>  		vb = &vbuf->vb2_buf;
> @@ -903,6 +1121,9 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>  			const struct v4l2_event ev = { .type = V4L2_EVENT_EOS };
>  
>  			v4l2_event_queue_fh(&inst->fh, &ev);
> +
> +			if (inst->codec_state == DEC_STATE_DRAIN)
> +				inst->codec_state = DEC_STATE_STOPPED;
>  		}
>  	} else {
>  		vbuf->sequence = inst->sequence_out++;
> @@ -914,17 +1135,69 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>  	if (hfi_flags & HFI_BUFFERFLAG_DATACORRUPT)
>  		state = VB2_BUF_STATE_ERROR;
>  
> +	if (hfi_flags & HFI_BUFFERFLAG_DROP_FRAME) {
> +		state = VB2_BUF_STATE_ERROR;
> +		vb2_set_plane_payload(vb, 0, 0);
> +		vb->timestamp = 0;
> +	}
> +
>  	v4l2_m2m_buf_done(vbuf, state);
>  }
>  
> +static void vdec_event_change(struct venus_inst *inst,
> +			      struct hfi_event_data *ev_data, bool sufficient)
> +{
> +	static const struct v4l2_event ev = {
> +		.type = V4L2_EVENT_SOURCE_CHANGE,
> +		.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION };
> +	struct device *dev = inst->core->dev_dec;
> +	struct v4l2_format format = {};
> +
> +	mutex_lock(&inst->lock);
> +
> +	format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	format.fmt.pix_mp.pixelformat = inst->fmt_cap->pixfmt;
> +	format.fmt.pix_mp.width = ev_data->width;
> +	format.fmt.pix_mp.height = ev_data->height;
> +
> +	vdec_try_fmt_common(inst, &format);
> +
> +	inst->width = format.fmt.pix_mp.width;
> +	inst->height = format.fmt.pix_mp.height;
> +
> +	inst->out_width = ev_data->width;
> +	inst->out_height = ev_data->height;
> +
> +	dev_dbg(dev, "event %s sufficient resources (%ux%u)\n",
> +		sufficient ? "" : "not", ev_data->width, ev_data->height);
> +
> +	if (sufficient) {
> +		hfi_session_continue(inst);
> +	} else {
> +		switch (inst->codec_state) {
> +		case DEC_STATE_INIT:
> +			inst->codec_state = DEC_STATE_CAPTURE_SETUP;
> +			break;
> +		case DEC_STATE_DECODING:
> +			inst->codec_state = DEC_STATE_DRC;
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	inst->reconfig = true;
> +	v4l2_event_queue_fh(&inst->fh, &ev);
> +	wake_up(&inst->reconf_wait);
> +
> +	mutex_unlock(&inst->lock);
> +}
> +
>  static void vdec_event_notify(struct venus_inst *inst, u32 event,
>  			      struct hfi_event_data *data)
>  {
>  	struct venus_core *core = inst->core;
>  	struct device *dev = core->dev_dec;
> -	static const struct v4l2_event ev = {
> -		.type = V4L2_EVENT_SOURCE_CHANGE,
> -		.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION };
>  
>  	switch (event) {
>  	case EVT_SESSION_ERROR:
> @@ -934,18 +1207,10 @@ static void vdec_event_notify(struct venus_inst *inst, u32 event,
>  	case EVT_SYS_EVENT_CHANGE:
>  		switch (data->event_type) {
>  		case HFI_EVENT_DATA_SEQUENCE_CHANGED_SUFFICIENT_BUF_RESOURCES:
> -			hfi_session_continue(inst);
> -			dev_dbg(dev, "event sufficient resources\n");
> +			vdec_event_change(inst, data, true);
>  			break;
>  		case HFI_EVENT_DATA_SEQUENCE_CHANGED_INSUFFICIENT_BUF_RESOURCES:
> -			inst->reconfig_height = data->height;
> -			inst->reconfig_width = data->width;
> -			inst->reconfig = true;
> -
> -			v4l2_event_queue_fh(&inst->fh, &ev);
> -
> -			dev_dbg(dev, "event not sufficient resources (%ux%u)\n",
> -				data->width, data->height);
> +			vdec_event_change(inst, data, false);
>  			break;
>  		case HFI_EVENT_RELEASE_BUFFER_REFERENCE:
>  			venus_helper_release_buf_ref(inst, data->tag);
> @@ -978,8 +1243,12 @@ static void vdec_inst_init(struct venus_inst *inst)
>  	inst->hfi_codec = HFI_VIDEO_CODEC_H264;
>  }
>  
> +static void vdec_m2m_device_run(void *priv)
> +{
> +}
> +
>  static const struct v4l2_m2m_ops vdec_m2m_ops = {
> -	.device_run = venus_helper_m2m_device_run,
> +	.device_run = vdec_m2m_device_run,
>  	.job_abort = venus_helper_m2m_job_abort,
>  };
>  
> @@ -1041,7 +1310,9 @@ static int vdec_open(struct file *file)
>  	inst->core = core;
>  	inst->session_type = VIDC_SESSION_TYPE_DEC;
>  	inst->num_output_bufs = 1;
> -
> +	inst->codec_state = DEC_STATE_UNINIT;
> +	inst->buf_count = 0;
> +	init_waitqueue_head(&inst->reconf_wait);
>  	venus_helper_init_instance(inst);
>  
>  	ret = pm_runtime_get_sync(core->dev_dec);
> 

