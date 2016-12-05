Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:56181 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750998AbcLEL0h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 06:26:37 -0500
Subject: Re: [PATCH v4 1/9] media: v4l2-mem2mem: extend m2m APIs for more
 accurate buffer management
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1480583001-32236-1-git-send-email-stanimir.varbanov@linaro.org>
 <1480583001-32236-2-git-send-email-stanimir.varbanov@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <464b3cd6-f5b4-ed26-717d-929d6957c015@xs4all.nl>
Date: Mon, 5 Dec 2016 12:25:19 +0100
MIME-Version: 1.0
In-Reply-To: <1480583001-32236-2-git-send-email-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/01/2016 10:03 AM, Stanimir Varbanov wrote:
> this add functions for:
>   - remove buffers from src/dst queue by index
>   - remove exact buffer from src/dst queue
> 
> also extends m2m API to iterate over a list of src/dst buffers
> in safely and non-safely manner.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 37 +++++++++++++++
>  include/media/v4l2-mem2mem.h           | 83 ++++++++++++++++++++++++++++++++++
>  2 files changed, 120 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index 6bc27e7b2a33..d689e7bb964f 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -126,6 +126,43 @@ void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx)
>  }
>  EXPORT_SYMBOL_GPL(v4l2_m2m_buf_remove);
>  
> +void v4l2_m2m_buf_remove_exact(struct v4l2_m2m_queue_ctx *q_ctx,
> +			       struct vb2_v4l2_buffer *vbuf)

I'd call this v4l2_m2m_buf_remove_by_buf to be consistent with _by_idx.

Other than that, this looks OK.

Regards,

	Hans

> +{
> +	struct v4l2_m2m_buffer *b;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&q_ctx->rdy_spinlock, flags);
> +	b = container_of(vbuf, struct v4l2_m2m_buffer, vb);
> +	list_del(&b->list);
> +	q_ctx->num_rdy--;
> +	spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_m2m_buf_remove_exact);
> +
> +struct vb2_v4l2_buffer *
> +v4l2_m2m_buf_remove_by_idx(struct v4l2_m2m_queue_ctx *q_ctx, unsigned int idx)
> +
> +{
> +	struct v4l2_m2m_buffer *b, *tmp;
> +	struct vb2_v4l2_buffer *ret = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&q_ctx->rdy_spinlock, flags);
> +	list_for_each_entry_safe(b, tmp, &q_ctx->rdy_queue, list) {
> +		if (b->vb.vb2_buf.index == idx) {
> +			list_del(&b->list);
> +			q_ctx->num_rdy--;
> +			ret = &b->vb;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_m2m_buf_remove_by_idx);
> +
>  /*
>   * Scheduling handlers
>   */
> diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
> index 3ccd01bd245e..c8632c52d5e2 100644
> --- a/include/media/v4l2-mem2mem.h
> +++ b/include/media/v4l2-mem2mem.h
> @@ -437,6 +437,41 @@ static inline void *v4l2_m2m_next_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
>  }
>  
>  /**
> + * v4l2_m2m_for_each_dst_buf() - iterate over a list of destination ready
> + * buffers
> + *
> + * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
> + */
> +#define v4l2_m2m_for_each_dst_buf(m2m_ctx, b)	\
> +	list_for_each_entry(b, &m2m_ctx->cap_q_ctx.rdy_queue, list)
> +
> +/**
> + * v4l2_m2m_for_each_src_buf() - iterate over a list of source ready buffers
> + *
> + * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
> + */
> +#define v4l2_m2m_for_each_src_buf(m2m_ctx, b)	\
> +	list_for_each_entry(b, &m2m_ctx->out_q_ctx.rdy_queue, list)
> +
> +/**
> + * v4l2_m2m_for_each_dst_buf_safe() - iterate over a list of destination ready
> + * buffers safely
> + *
> + * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
> + */
> +#define v4l2_m2m_for_each_dst_buf_safe(m2m_ctx, b, n)	\
> +	list_for_each_entry_safe(b, n, &m2m_ctx->cap_q_ctx.rdy_queue, list)
> +
> +/**
> + * v4l2_m2m_for_each_src_buf_safe() - iterate over a list of source ready
> + * buffers safely
> + *
> + * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
> + */
> +#define v4l2_m2m_for_each_src_buf_safe(m2m_ctx, b, n)	\
> +	list_for_each_entry_safe(b, n, &m2m_ctx->out_q_ctx.rdy_queue, list)
> +
> +/**
>   * v4l2_m2m_get_src_vq() - return vb2_queue for source buffers
>   *
>   * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
> @@ -488,6 +523,54 @@ static inline void *v4l2_m2m_dst_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
>  	return v4l2_m2m_buf_remove(&m2m_ctx->cap_q_ctx);
>  }
>  
> +/**
> + * v4l2_m2m_buf_remove_exact() - take off exact buffer from the list of ready
> + * buffers
> + *
> + * @q_ctx: pointer to struct @v4l2_m2m_queue_ctx
> + */
> +void v4l2_m2m_buf_remove_exact(struct v4l2_m2m_queue_ctx *q_ctx,
> +			       struct vb2_v4l2_buffer *vbuf);
> +
> +/**
> + * v4l2_m2m_src_buf_remove_exact() - take off exact source buffer from the list
> + * of ready buffers
> + *
> + * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
> + */
> +static inline void v4l2_m2m_src_buf_remove_exact(struct v4l2_m2m_ctx *m2m_ctx,
> +						 struct vb2_v4l2_buffer *vbuf)
> +{
> +	v4l2_m2m_buf_remove_exact(&m2m_ctx->out_q_ctx, vbuf);
> +}
> +
> +/**
> + * v4l2_m2m_src_buf_remove_exact() - take off exact destination buffer from the
> + * list of ready buffers
> + *
> + * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
> + */
> +static inline void v4l2_m2m_dst_buf_remove_exact(struct v4l2_m2m_ctx *m2m_ctx,
> +						 struct vb2_v4l2_buffer *vbuf)
> +{
> +	v4l2_m2m_buf_remove_exact(&m2m_ctx->cap_q_ctx, vbuf);
> +}
> +
> +struct vb2_v4l2_buffer *
> +v4l2_m2m_buf_remove_by_idx(struct v4l2_m2m_queue_ctx *q_ctx, unsigned int idx);
> +
> +static inline struct vb2_v4l2_buffer *
> +v4l2_m2m_src_buf_remove_by_idx(struct v4l2_m2m_ctx *m2m_ctx, unsigned int idx)
> +{
> +	return v4l2_m2m_buf_remove_by_idx(&m2m_ctx->out_q_ctx, idx);
> +}
> +
> +static inline struct vb2_v4l2_buffer *
> +v4l2_m2m_dst_buf_remove_by_idx(struct v4l2_m2m_ctx *m2m_ctx, unsigned int idx)
> +{
> +	return v4l2_m2m_buf_remove_by_idx(&m2m_ctx->cap_q_ctx, idx);
> +}
> +
>  /* v4l2 ioctl helpers */
>  
>  int v4l2_m2m_ioctl_reqbufs(struct file *file, void *priv,
> 

