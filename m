Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:38189 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756296AbcIOKZC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 06:25:02 -0400
Subject: Re: [PATCH v1 1/2] st-hva: encoding summary at instance release
To: Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        linux-media@vger.kernel.org
References: <1473696075-9190-1-git-send-email-jean-christophe.trotin@st.com>
 <1473696075-9190-2-git-send-email-jean-christophe.trotin@st.com>
Cc: kernel@stlinux.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b7210d05-5bab-5f9f-ecb5-b9766115fd5b@xs4all.nl>
Date: Thu, 15 Sep 2016 12:24:55 +0200
MIME-Version: 1.0
In-Reply-To: <1473696075-9190-2-git-send-email-jean-christophe.trotin@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Christophe,

I think it would be better to add a Kconfig option to explicitly enable this encoding/performance
summary.

Wouldn't debugfs be more appropriate for this? Especially given the next patch.

Regards,

	Hans

On 09/12/2016 06:01 PM, Jean-Christophe Trotin wrote:
> This patch prints unconditionnaly a short summary about the encoding
> operation at each instance closing, for debug purpose:
> - information about the stream (format, profile, level, resolution)
> - performance information (number of encoded frames, maximum framerate)
> - potential (system, encoding...) errors
> 
> Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
> Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
> ---
>  drivers/media/platform/sti/hva/Makefile    |   2 +-
>  drivers/media/platform/sti/hva/hva-debug.c | 125 +++++++++++++++++++++++++++++
>  drivers/media/platform/sti/hva/hva-h264.c  |   6 ++
>  drivers/media/platform/sti/hva/hva-hw.c    |   5 ++
>  drivers/media/platform/sti/hva/hva-mem.c   |   5 +-
>  drivers/media/platform/sti/hva/hva-v4l2.c  |  30 ++++---
>  drivers/media/platform/sti/hva/hva.h       |  27 +++++++
>  7 files changed, 188 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/media/platform/sti/hva/hva-debug.c
> 
> diff --git a/drivers/media/platform/sti/hva/Makefile b/drivers/media/platform/sti/hva/Makefile
> index ffb69ce..0895d2d 100644
> --- a/drivers/media/platform/sti/hva/Makefile
> +++ b/drivers/media/platform/sti/hva/Makefile
> @@ -1,2 +1,2 @@
>  obj-$(CONFIG_VIDEO_STI_HVA) := st-hva.o
> -st-hva-y := hva-v4l2.o hva-hw.o hva-mem.o hva-h264.o
> +st-hva-y := hva-v4l2.o hva-hw.o hva-mem.o hva-h264.o hva-debug.o
> diff --git a/drivers/media/platform/sti/hva/hva-debug.c b/drivers/media/platform/sti/hva/hva-debug.c
> new file mode 100644
> index 0000000..71bbf32
> --- /dev/null
> +++ b/drivers/media/platform/sti/hva/hva-debug.c
> @@ -0,0 +1,125 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2015
> + * Authors: Yannick Fertre <yannick.fertre@st.com>
> + *          Hugues Fruchet <hugues.fruchet@st.com>
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#include "hva.h"
> +
> +/*
> + * encoding summary
> + */
> +
> +char *hva_dbg_summary(struct hva_ctx *ctx)
> +{
> +	struct hva_streaminfo *stream = &ctx->streaminfo;
> +	struct hva_frameinfo *frame = &ctx->frameinfo;
> +	struct hva_ctx_dbg *dbg = &ctx->dbg;
> +	static char str[200] = "";
> +	char *cur = str;
> +	size_t left = sizeof(str);
> +	int cnt = 0;
> +	int ret = 0;
> +	u32 errors;
> +
> +	/* frame info */
> +	cur += cnt;
> +	left -= cnt;
> +	ret = snprintf(cur, left, "%4.4s %dx%d > ",
> +		       (char *)&frame->pixelformat,
> +		       frame->aligned_width, frame->aligned_height);
> +	cnt = (left > ret ? ret : left);
> +
> +	/* stream info */
> +	cur += cnt;
> +	left -= cnt;
> +	ret = snprintf(cur, left, "%4.4s %dx%d %s %s: ",
> +		       (char *)&stream->streamformat,
> +		       stream->width, stream->height,
> +		       stream->profile, stream->level);
> +	cnt = (left > ret ? ret : left);
> +
> +	/* performance info */
> +	cur += cnt;
> +	left -= cnt;
> +	ret = snprintf(cur, left, "%d frames encoded", dbg->cnt_duration);
> +	cnt = (left > ret ? ret : left);
> +
> +	if (dbg->cnt_duration && dbg->total_duration) {
> +		u64 div;
> +		u32 fps;
> +
> +		div = (u64)dbg->cnt_duration * 100000;
> +		do_div(div, dbg->total_duration);
> +		fps = (u32)div;
> +		cur += cnt;
> +		left -= cnt;
> +		ret = snprintf(cur, left, ", max fps (0.1Hz)=%d", fps);
> +		cnt = (left > ret ? ret : left);
> +	}
> +
> +	/* error info */
> +	errors = dbg->sys_errors + dbg->encode_errors + dbg->frame_errors;
> +	if (errors) {
> +		cur += cnt;
> +		left -= cnt;
> +		ret = snprintf(cur, left, ", %d errors", errors);
> +		cnt = (left > ret ? ret : left);
> +	}
> +
> +	return str;
> +}
> +
> +/*
> + * performance debug info
> + */
> +
> +void hva_dbg_perf_begin(struct hva_ctx *ctx)
> +{
> +	struct hva_ctx_dbg *dbg = &ctx->dbg;
> +
> +	dbg->begin = ktime_get();
> +
> +	/*
> +	 * filter sequences valid for performance:
> +	 * - begin/begin (no stream available) is an invalid sequence
> +	 * - begin/end is a valid sequence
> +	 */
> +	dbg->is_valid_period = false;
> +}
> +
> +void hva_dbg_perf_end(struct hva_ctx *ctx, struct hva_stream *stream)
> +{
> +	struct device *dev = ctx_to_dev(ctx);
> +	u64 div;
> +	u32 duration;
> +	u32 bytesused;
> +	u32 timestamp;
> +	struct hva_ctx_dbg *dbg = &ctx->dbg;
> +	ktime_t end = ktime_get();
> +
> +	/* stream bytesused and timestamp in us */
> +	bytesused = vb2_get_plane_payload(&stream->vbuf.vb2_buf, 0);
> +	div = stream->vbuf.vb2_buf.timestamp;
> +	do_div(div, 1000);
> +	timestamp = (u32)div;
> +
> +	/* encoding duration */
> +	div = (u64)ktime_us_delta(end, dbg->begin);
> +
> +	dev_dbg(dev,
> +		"%s perf stream[%d] dts=%d encoded using %d bytes in %d us",
> +		ctx->name,
> +		stream->vbuf.sequence,
> +		timestamp,
> +		bytesused, (u32)div);
> +
> +	do_div(div, 100);
> +	duration = (u32)div;
> +
> +	dbg->total_duration += duration;
> +	dbg->cnt_duration++;
> +
> +	dbg->is_valid_period = true;
> +}
> diff --git a/drivers/media/platform/sti/hva/hva-h264.c b/drivers/media/platform/sti/hva/hva-h264.c
> index 8cc8467..b1e2b60 100644
> --- a/drivers/media/platform/sti/hva/hva-h264.c
> +++ b/drivers/media/platform/sti/hva/hva-h264.c
> @@ -607,6 +607,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
>  			"%s   width(%d) or height(%d) exceeds limits (%dx%d)\n",
>  			pctx->name, frame_width, frame_height,
>  			H264_MAX_SIZE_W, H264_MAX_SIZE_H);
> +		pctx->dbg.frame_errors++;
>  		return -EINVAL;
>  	}
>  
> @@ -717,6 +718,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
>  	default:
>  		dev_err(dev, "%s   invalid source pixel format\n",
>  			pctx->name);
> +		pctx->dbg.frame_errors++;
>  		return -EINVAL;
>  	}
>  
> @@ -741,6 +743,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
>  
>  	if (td->framerate_den == 0) {
>  		dev_err(dev, "%s   invalid framerate\n", pctx->name);
> +		pctx->dbg.frame_errors++;
>  		return -EINVAL;
>  	}
>  
> @@ -831,6 +834,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
>  	    (payload > MAX_SPS_PPS_SIZE)) {
>  		dev_err(dev, "%s   invalid sps/pps size %d\n", pctx->name,
>  			payload);
> +		pctx->dbg.frame_errors++;
>  		return -EINVAL;
>  	}
>  
> @@ -842,6 +846,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
>  						   (u8 *)stream->vaddr,
>  						   &payload)) {
>  		dev_err(dev, "%s   fail to get SEI nal\n", pctx->name);
> +		pctx->dbg.frame_errors++;
>  		return -EINVAL;
>  	}
>  
> @@ -963,6 +968,7 @@ err_seq_info:
>  err_ctx:
>  	devm_kfree(dev, ctx);
>  err:
> +	pctx->dbg.sys_errors++;
>  	return ret;
>  }
>  
> diff --git a/drivers/media/platform/sti/hva/hva-hw.c b/drivers/media/platform/sti/hva/hva-hw.c
> index 8d9ad1c..c84b860 100644
> --- a/drivers/media/platform/sti/hva/hva-hw.c
> +++ b/drivers/media/platform/sti/hva/hva-hw.c
> @@ -470,6 +470,7 @@ int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
>  
>  	if (pm_runtime_get_sync(dev) < 0) {
>  		dev_err(dev, "%s     failed to get pm_runtime\n", ctx->name);
> +		ctx->dbg.sys_errors++;
>  		ret = -EFAULT;
>  		goto out;
>  	}
> @@ -481,6 +482,7 @@ int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
>  		break;
>  	default:
>  		dev_dbg(dev, "%s     unknown command 0x%x\n", ctx->name, cmd);
> +		ctx->dbg.encode_errors++;
>  		ret = -EFAULT;
>  		goto out;
>  	}
> @@ -511,6 +513,7 @@ int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
>  					 msecs_to_jiffies(2000))) {
>  		dev_err(dev, "%s     %s: time out on completion\n", ctx->name,
>  			__func__);
> +		ctx->dbg.encode_errors++;
>  		ret = -EFAULT;
>  		goto out;
>  	}
> @@ -518,6 +521,8 @@ int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
>  	/* get encoding status */
>  	ret = ctx->hw_err ? -EFAULT : 0;
>  
> +	ctx->dbg.encode_errors += ctx->hw_err ? 1 : 0;
> +
>  out:
>  	disable_irq(hva->irq_its);
>  	disable_irq(hva->irq_err);
> diff --git a/drivers/media/platform/sti/hva/hva-mem.c b/drivers/media/platform/sti/hva/hva-mem.c
> index 649f660..2b8ed81 100644
> --- a/drivers/media/platform/sti/hva/hva-mem.c
> +++ b/drivers/media/platform/sti/hva/hva-mem.c
> @@ -17,14 +17,17 @@ int hva_mem_alloc(struct hva_ctx *ctx, u32 size, const char *name,
>  	void *base;
>  
>  	b = devm_kzalloc(dev, sizeof(*b), GFP_KERNEL);
> -	if (!b)
> +	if (!b) {
> +		ctx->dbg.sys_errors++;
>  		return -ENOMEM;
> +	}
>  
>  	base = dma_alloc_attrs(dev, size, &paddr, GFP_KERNEL | GFP_DMA,
>  			       DMA_ATTR_WRITE_COMBINE);
>  	if (!base) {
>  		dev_err(dev, "%s %s : dma_alloc_attrs failed for %s (size=%d)\n",
>  			ctx->name, __func__, name, size);
> +		ctx->dbg.sys_errors++;
>  		devm_kfree(dev, b);
>  		return -ENOMEM;
>  	}
> diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
> index 1696e02..fb65816 100644
> --- a/drivers/media/platform/sti/hva/hva-v4l2.c
> +++ b/drivers/media/platform/sti/hva/hva-v4l2.c
> @@ -614,19 +614,17 @@ static int hva_s_ctrl(struct v4l2_ctrl *ctrl)
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
>  		ctx->ctrls.profile = ctrl->val;
> -		if (ctx->flags & HVA_FLAG_STREAMINFO)
> -			snprintf(ctx->streaminfo.profile,
> -				 sizeof(ctx->streaminfo.profile),
> -				 "%s profile",
> -				 v4l2_ctrl_get_menu(ctrl->id)[ctrl->val]);
> +		snprintf(ctx->streaminfo.profile,
> +			 sizeof(ctx->streaminfo.profile),
> +			 "%s profile",
> +			 v4l2_ctrl_get_menu(ctrl->id)[ctrl->val]);
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
>  		ctx->ctrls.level = ctrl->val;
> -		if (ctx->flags & HVA_FLAG_STREAMINFO)
> -			snprintf(ctx->streaminfo.level,
> -				 sizeof(ctx->streaminfo.level),
> -				 "level %s",
> -				 v4l2_ctrl_get_menu(ctrl->id)[ctrl->val]);
> +		snprintf(ctx->streaminfo.level,
> +			 sizeof(ctx->streaminfo.level),
> +			 "level %s",
> +			 v4l2_ctrl_get_menu(ctrl->id)[ctrl->val]);
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:
>  		ctx->ctrls.entropy_mode = ctrl->val;
> @@ -793,6 +791,8 @@ static void hva_run_work(struct work_struct *work)
>  	/* protect instance against reentrancy */
>  	mutex_lock(&ctx->lock);
>  
> +	hva_dbg_perf_begin(ctx);
> +
>  	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
>  	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
>  
> @@ -812,6 +812,8 @@ static void hva_run_work(struct work_struct *work)
>  		dst_buf->field = V4L2_FIELD_NONE;
>  		dst_buf->sequence = ctx->stream_num - 1;
>  
> +		hva_dbg_perf_end(ctx, stream);
> +
>  		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
>  		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
>  	}
> @@ -1026,6 +1028,8 @@ err:
>  			v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_QUEUED);
>  	}
>  
> +	ctx->dbg.sys_errors++;
> +
>  	return ret;
>  }
>  
> @@ -1150,6 +1154,7 @@ static int hva_open(struct file *file)
>  	if (ret) {
>  		dev_err(dev, "%s [x:x] failed to setup controls\n",
>  			HVA_PREFIX);
> +		ctx->dbg.sys_errors++;
>  		goto err_fh;
>  	}
>  	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
> @@ -1162,6 +1167,7 @@ static int hva_open(struct file *file)
>  		ret = PTR_ERR(ctx->fh.m2m_ctx);
>  		dev_err(dev, "%s failed to initialize m2m context (%d)\n",
>  			HVA_PREFIX, ret);
> +		ctx->dbg.sys_errors++;
>  		goto err_ctrls;
>  	}
>  
> @@ -1206,6 +1212,10 @@ static int hva_release(struct file *file)
>  		hva->nb_of_instances--;
>  	}
>  
> +	/* trace a summary of instance before closing (debug purpose) */
> +	if (ctx->flags & HVA_FLAG_STREAMINFO)
> +		dev_info(dev, "%s %s\n", ctx->name, hva_dbg_summary(ctx));
> +
>  	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
>  
>  	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> diff --git a/drivers/media/platform/sti/hva/hva.h b/drivers/media/platform/sti/hva/hva.h
> index caa5808..badc5f4 100644
> --- a/drivers/media/platform/sti/hva/hva.h
> +++ b/drivers/media/platform/sti/hva/hva.h
> @@ -153,6 +153,27 @@ struct hva_stream {
>  #define to_hva_stream(vb) \
>  	container_of(vb, struct hva_stream, vbuf)
>  
> +/**
> + * struct hva_ctx_dbg - instance context debug info
> + *
> + * @is_valid_period: true if the sequence is valid for performance
> + * @begin:           start time of last HW task
> + * @total_duration:  total HW processing durations in 0.1ms
> + * @cnt_duration:    number of HW processings
> + * @sys_errors:      number of system errors (memory, resource, pm..)
> + * @encode_errors:   number of encoding errors (hw/driver errors)
> + * @frame_errors:    number of frame errors (format, size, header...)
> + */
> +struct hva_ctx_dbg {
> +	bool	is_valid_period;
> +	ktime_t	begin;
> +	u32	total_duration;
> +	u32	cnt_duration;
> +	u32	sys_errors;
> +	u32	encode_errors;
> +	u32	frame_errors;
> +};
> +
>  struct hva_dev;
>  struct hva_enc;
>  
> @@ -182,6 +203,7 @@ struct hva_enc;
>   * @priv:            private codec data for this instance, allocated
>   *                   by encoder @open time
>   * @hw_err:          true if hardware error detected
> + * @dbg:             context debug info
>   */
>  struct hva_ctx {
>  	struct hva_dev		        *hva_dev;
> @@ -207,6 +229,7 @@ struct hva_ctx {
>  	struct hva_enc			*enc;
>  	void				*priv;
>  	bool				hw_err;
> +	struct hva_ctx_dbg		dbg;
>  };
>  
>  #define HVA_FLAG_STREAMINFO	0x0001
> @@ -312,4 +335,8 @@ struct hva_enc {
>  				  struct hva_stream *stream);
>  };
>  
> +char *hva_dbg_summary(struct hva_ctx *ctx);
> +void hva_dbg_perf_begin(struct hva_ctx *ctx);
> +void hva_dbg_perf_end(struct hva_ctx *ctx, struct hva_stream *stream);
> +
>  #endif /* HVA_H */
> 
