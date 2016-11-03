Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:42531 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752131AbcKCNyo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 09:54:44 -0400
Subject: Re: [PATCH v2 1/2] [media] st-hva: encoding summary at instance
 release
To: Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        linux-media@vger.kernel.org
References: <1474364796-23747-1-git-send-email-jean-christophe.trotin@st.com>
 <1474364796-23747-2-git-send-email-jean-christophe.trotin@st.com>
Cc: kernel@stlinux.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <295fbe1b-163a-024e-e0c3-0277fa6483bf@xs4all.nl>
Date: Thu, 3 Nov 2016 14:54:39 +0100
MIME-Version: 1.0
In-Reply-To: <1474364796-23747-2-git-send-email-jean-christophe.trotin@st.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/09/16 11:46, Jean-Christophe Trotin wrote:
> This patch prints unconditionnaly a short summary about the encoding
> operation at each instance closing, for debug purpose:
> - information about the frame (format, resolution)
> - information about the stream (format, profile, level, resolution)
> - number of encoded frames
> - potential (system, encoding...) errors
>
> Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
> Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
> ---
>  drivers/media/platform/sti/hva/Makefile    |  2 +-
>  drivers/media/platform/sti/hva/hva-debug.c | 71 ++++++++++++++++++++++++++++++
>  drivers/media/platform/sti/hva/hva-h264.c  |  6 +++
>  drivers/media/platform/sti/hva/hva-hw.c    |  5 +++
>  drivers/media/platform/sti/hva/hva-mem.c   |  5 ++-
>  drivers/media/platform/sti/hva/hva-v4l2.c  | 28 +++++++-----
>  drivers/media/platform/sti/hva/hva.h       | 10 +++++
>  7 files changed, 115 insertions(+), 12 deletions(-)
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
> index 0000000..43bb7e4
> --- /dev/null
> +++ b/drivers/media/platform/sti/hva/hva-debug.c
> @@ -0,0 +1,71 @@
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
> +	static char str[200] = "";
> +	char *cur = str;
> +	size_t left = sizeof(str);
> +	int cnt = 0;
> +	int ret = 0;
> +
> +	/* frame info */
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
> +	/* encoding info */
> +	cur += cnt;
> +	left -= cnt;
> +	ret = snprintf(cur, left, "%d frames encoded", ctx->encoded_frames);
> +	cnt = (left > ret ? ret : left);
> +
> +	/* error info */
> +	if (ctx->sys_errors) {
> +		cur += cnt;
> +		left -= cnt;
> +		ret = snprintf(cur, left, ", %d system errors",
> +			       ctx->sys_errors);
> +		cnt = (left > ret ? ret : left);
> +	}
> +
> +	if (ctx->encode_errors) {
> +		cur += cnt;
> +		left -= cnt;
> +		ret = snprintf(cur, left, ", %d encoding errors",
> +			       ctx->encode_errors);
> +		cnt = (left > ret ? ret : left);
> +	}
> +
> +	if (ctx->frame_errors) {
> +		cur += cnt;
> +		left -= cnt;
> +		ret = snprintf(cur, left, ", %d frame errors",
> +			       ctx->frame_errors);
> +		cnt = (left > ret ? ret : left);
> +	}

Yuck. Just make this one big snprintf. Or even better, just use 
dev_info. No need to use a
static char buffer that way.

> +
> +	return str;
> +}
> diff --git a/drivers/media/platform/sti/hva/hva-h264.c b/drivers/media/platform/sti/hva/hva-h264.c
> index 8cc8467..e6f247a 100644
> --- a/drivers/media/platform/sti/hva/hva-h264.c
> +++ b/drivers/media/platform/sti/hva/hva-h264.c
> @@ -607,6 +607,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
>  			"%s   width(%d) or height(%d) exceeds limits (%dx%d)\n",
>  			pctx->name, frame_width, frame_height,
>  			H264_MAX_SIZE_W, H264_MAX_SIZE_H);
> +		pctx->frame_errors++;
>  		return -EINVAL;
>  	}
>
> @@ -717,6 +718,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
>  	default:
>  		dev_err(dev, "%s   invalid source pixel format\n",
>  			pctx->name);
> +		pctx->frame_errors++;
>  		return -EINVAL;
>  	}
>
> @@ -741,6 +743,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
>
>  	if (td->framerate_den == 0) {
>  		dev_err(dev, "%s   invalid framerate\n", pctx->name);
> +		pctx->frame_errors++;
>  		return -EINVAL;
>  	}
>
> @@ -831,6 +834,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
>  	    (payload > MAX_SPS_PPS_SIZE)) {
>  		dev_err(dev, "%s   invalid sps/pps size %d\n", pctx->name,
>  			payload);
> +		pctx->frame_errors++;
>  		return -EINVAL;
>  	}
>
> @@ -842,6 +846,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
>  						   (u8 *)stream->vaddr,
>  						   &payload)) {
>  		dev_err(dev, "%s   fail to get SEI nal\n", pctx->name);
> +		pctx->frame_errors++;
>  		return -EINVAL;
>  	}
>
> @@ -963,6 +968,7 @@ err_seq_info:
>  err_ctx:
>  	devm_kfree(dev, ctx);
>  err:
> +	pctx->sys_errors++;
>  	return ret;
>  }
>
> diff --git a/drivers/media/platform/sti/hva/hva-hw.c b/drivers/media/platform/sti/hva/hva-hw.c
> index 8d9ad1c..33fc1dd 100644
> --- a/drivers/media/platform/sti/hva/hva-hw.c
> +++ b/drivers/media/platform/sti/hva/hva-hw.c
> @@ -470,6 +470,7 @@ int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
>
>  	if (pm_runtime_get_sync(dev) < 0) {
>  		dev_err(dev, "%s     failed to get pm_runtime\n", ctx->name);
> +		ctx->sys_errors++;
>  		ret = -EFAULT;
>  		goto out;
>  	}
> @@ -481,6 +482,7 @@ int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
>  		break;
>  	default:
>  		dev_dbg(dev, "%s     unknown command 0x%x\n", ctx->name, cmd);
> +		ctx->encode_errors++;
>  		ret = -EFAULT;
>  		goto out;
>  	}
> @@ -511,6 +513,7 @@ int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
>  					 msecs_to_jiffies(2000))) {
>  		dev_err(dev, "%s     %s: time out on completion\n", ctx->name,
>  			__func__);
> +		ctx->encode_errors++;
>  		ret = -EFAULT;
>  		goto out;
>  	}
> @@ -518,6 +521,8 @@ int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
>  	/* get encoding status */
>  	ret = ctx->hw_err ? -EFAULT : 0;
>
> +	ctx->encode_errors += ctx->hw_err ? 1 : 0;
> +
>  out:
>  	disable_irq(hva->irq_its);
>  	disable_irq(hva->irq_err);
> diff --git a/drivers/media/platform/sti/hva/hva-mem.c b/drivers/media/platform/sti/hva/hva-mem.c
> index 649f660..821c78e 100644
> --- a/drivers/media/platform/sti/hva/hva-mem.c
> +++ b/drivers/media/platform/sti/hva/hva-mem.c
> @@ -17,14 +17,17 @@ int hva_mem_alloc(struct hva_ctx *ctx, u32 size, const char *name,
>  	void *base;
>
>  	b = devm_kzalloc(dev, sizeof(*b), GFP_KERNEL);
> -	if (!b)
> +	if (!b) {
> +		ctx->sys_errors++;
>  		return -ENOMEM;
> +	}
>
>  	base = dma_alloc_attrs(dev, size, &paddr, GFP_KERNEL | GFP_DMA,
>  			       DMA_ATTR_WRITE_COMBINE);
>  	if (!base) {
>  		dev_err(dev, "%s %s : dma_alloc_attrs failed for %s (size=%d)\n",
>  			ctx->name, __func__, name, size);
> +		ctx->sys_errors++;
>  		devm_kfree(dev, b);
>  		return -ENOMEM;
>  	}
> diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
> index 6bf3c858..3583a05 100644
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
> @@ -812,6 +810,8 @@ static void hva_run_work(struct work_struct *work)
>  		dst_buf->field = V4L2_FIELD_NONE;
>  		dst_buf->sequence = ctx->stream_num - 1;
>
> +		ctx->encoded_frames++;
> +
>  		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
>  		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
>  	}
> @@ -1026,6 +1026,8 @@ err:
>  			v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_QUEUED);
>  	}
>
> +	ctx->sys_errors++;
> +
>  	return ret;
>  }
>
> @@ -1150,6 +1152,7 @@ static int hva_open(struct file *file)
>  	if (ret) {
>  		dev_err(dev, "%s [x:x] failed to setup controls\n",
>  			HVA_PREFIX);
> +		ctx->sys_errors++;
>  		goto err_fh;
>  	}
>  	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
> @@ -1162,6 +1165,7 @@ static int hva_open(struct file *file)
>  		ret = PTR_ERR(ctx->fh.m2m_ctx);
>  		dev_err(dev, "%s failed to initialize m2m context (%d)\n",
>  			HVA_PREFIX, ret);
> +		ctx->sys_errors++;
>  		goto err_ctrls;
>  	}
>
> @@ -1206,6 +1210,10 @@ static int hva_release(struct file *file)
>  		hva->nb_of_instances--;
>  	}
>
> +	/* trace a summary of instance before closing (debug purpose) */
> +	if (ctx->flags & HVA_FLAG_STREAMINFO)
> +		dev_info(dev, "%s %s\n", ctx->name, hva_dbg_summary(ctx));

So just change this to:

		hva_dbg_summary(ctx);

> +
>  	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
>
>  	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> diff --git a/drivers/media/platform/sti/hva/hva.h b/drivers/media/platform/sti/hva/hva.h
> index caa5808..013aa16 100644
> --- a/drivers/media/platform/sti/hva/hva.h
> +++ b/drivers/media/platform/sti/hva/hva.h
> @@ -182,6 +182,10 @@ struct hva_enc;
>   * @priv:            private codec data for this instance, allocated
>   *                   by encoder @open time
>   * @hw_err:          true if hardware error detected
> + * @encoded_frames:  number of encoded frames
> + * @sys_errors:      number of system errors (memory, resource, pm...)
> + * @encode_errors:   number of encoding errors (hw/driver errors)
> + * @frame_errors:    number of frame errors (format, size, header...)
>   */
>  struct hva_ctx {
>  	struct hva_dev		        *hva_dev;
> @@ -207,6 +211,10 @@ struct hva_ctx {
>  	struct hva_enc			*enc;
>  	void				*priv;
>  	bool				hw_err;
> +	u32				encoded_frames;
> +	u32				sys_errors;
> +	u32				encode_errors;
> +	u32				frame_errors;
>  };
>
>  #define HVA_FLAG_STREAMINFO	0x0001
> @@ -312,4 +320,6 @@ struct hva_enc {
>  				  struct hva_stream *stream);
>  };
>
> +char *hva_dbg_summary(struct hva_ctx *ctx);
> +
>  #endif /* HVA_H */
>

Regards,

	Hans
