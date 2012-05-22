Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56785 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760419Ab2EVUzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 16:55:52 -0400
Received: by bkcji2 with SMTP id ji2so5379707bkc.19
        for <linux-media@vger.kernel.org>; Tue, 22 May 2012 13:55:51 -0700 (PDT)
Message-ID: <4FBBFD54.8080001@gmail.com>
Date: Tue, 22 May 2012 22:55:48 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>
CC: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	m.szyprowski@samsung.com, k.debski@samsung.com
Subject: Re: [PATCH 2/2] s5p-mfc: added encoder support for end of stream
 handling
References: <1337700835-13634-1-git-send-email-a.hajda@samsung.com> <1337700835-13634-3-git-send-email-a.hajda@samsung.com>
In-Reply-To: <1337700835-13634-3-git-send-email-a.hajda@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

just a few nit picks below...

On 05/22/2012 05:33 PM, Andrzej Hajda wrote:
> s5p-mfc encoder after receiving buffer with flag V4L2_BUF_FLAG_EOS
> will put all buffers cached in device into capture queue.
> It will indicate end of encoded stream by providing empty buffer.
> 
> Signed-off-by: Andrzej Hajda<a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> ---
...
> +static void s5p_mfc_handle_complete(struct s5p_mfc_ctx *ctx,
> +				 unsigned int reason, unsigned int err)
> +{
> +	struct s5p_mfc_dev *dev = ctx->dev;
> +	struct s5p_mfc_buf *mb_entry;
> +	unsigned long flags;
> +
> +	mfc_debug(2, "Stream completed");
> +
> +	s5p_mfc_clear_int_flags(dev);
> +	ctx->int_type = reason;
> +	ctx->int_err = err;
> +
> +	spin_lock_irqsave(&dev->irqlock, flags);
> +	ctx->state = MFCINST_FINISHED;
> +
> +	if (!list_empty(&ctx->dst_queue)) {
> +		mb_entry = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf,
> +									list);
> +		list_del(&mb_entry->list);
> +		ctx->dst_queue_cnt--;
> +		vb2_set_plane_payload(mb_entry->b, 0, 0);
> +		vb2_buffer_done(mb_entry->b, VB2_BUF_STATE_DONE);
> +	}
> +
> +	spin_unlock_irqrestore(&dev->irqlock, flags);
> +	if (ctx->dst_queue_cnt == 0) {
> +		spin_lock(&dev->condlock);
> +		clear_bit(ctx->num,&dev->ctx_work_bits);
> +		spin_unlock(&dev->condlock);

This looks a bit odd, since clear_bit is atomic and yet we protect it 
with a spinlock.

Perhaps it's worth to add a set_work_bit() function as a pair to existing 
clear_work_bit(),

static void clear_work_bit(struct s5p_mfc_dev *dev, unsigned int num)
{
	int flags;

	spin_lock_irqsave(&dev->condlock, flags);
	dev->ctx_work_bits &= ~BIT(num);
	spin_unlock_irqrestore(&dev->condlock, flags);
}

static void set_work_bit(struct s5p_mfc_dev *dev, unsigned int num)
{
	int flags;

	spin_lock_irqsave(&dev->condlock, flags);
	dev->ctx_work_bits |= BIT(num);
	spin_unlock_irqrestore(&dev->condlock, flags);
}

and replace all occurrences of spin_lock/set_bit/spin_unlock with it?
It's just a tiny optimization though.

> +	}
> +
> +	if (test_and_clear_bit(0,&dev->hw_lock) == 0)
> +		BUG();

Is it really needed, is it unrecoverable system error ? Wouldn't just
WARN_ON() do ? BUG(); seems an to me overkill here.

> +
> +	s5p_mfc_clock_off();
> +	wake_up(&ctx->queue);
> +}
> +
>   /* Interrupt processing */
>   static irqreturn_t s5p_mfc_irq(int irq, void *priv)
>   {
> @@ -614,6 +653,11 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
>   	case S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET:
>   		s5p_mfc_handle_init_buffers(ctx, reason, err);
>   		break;
> +
> +	case S5P_FIMV_R2H_CMD_ENC_COMPLETE_RET:
> +		s5p_mfc_handle_complete(ctx, reason, err);
> +		break;
> +
>   	default:
>   		mfc_debug(2, "Unknown int reason\n");
>   		s5p_mfc_clear_int_flags(dev);
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> index acedb20..8dec186 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> @@ -584,7 +584,7 @@ static int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
>   		return 1;
>   	/* context is ready to encode remain frames */
>   	if (ctx->state == MFCINST_FINISHING&&
> -		ctx->src_queue_cnt>= 1&&  ctx->dst_queue_cnt>= 1)
> +		ctx->dst_queue_cnt>= 1)
>   		return 1;
>   	mfc_debug(2, "ctx is not ready\n");
>   	return 0;
> @@ -1715,15 +1715,8 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
>   		mfc_buf =&ctx->src_bufs[vb->v4l2_buf.index];
>   		mfc_buf->used = 0;
>   		spin_lock_irqsave(&dev->irqlock, flags);
> -		if (vb->v4l2_planes[0].bytesused == 0) {
> -			mfc_debug(1, "change state to FINISHING\n");
> -			ctx->state = MFCINST_FINISHING;
> -			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> -			cleanup_ref_queue(ctx);
> -		} else {
> -			list_add_tail(&mfc_buf->list,&ctx->src_queue);
> -			ctx->src_queue_cnt++;
> -		}
> +		list_add_tail(&mfc_buf->list,&ctx->src_queue);
> +		ctx->src_queue_cnt++;
>   		spin_unlock_irqrestore(&dev->irqlock, flags);
>   	} else {
>   		mfc_err("unsupported buffer type (%d)\n", vq->type);
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> index e6217cb..4bcf93f 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> @@ -1081,8 +1081,14 @@ int s5p_mfc_encode_one_frame(struct s5p_mfc_ctx *ctx)
>   	else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT)
>   		mfc_write(dev, 3, S5P_FIMV_ENC_MAP_FOR_CUR);
>   	s5p_mfc_set_shared_buffer(ctx);
> -	mfc_write(dev, (S5P_FIMV_CH_FRAME_START<<  16&  0x70000) |
> -		(ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
> +
> +	if (ctx->state == MFCINST_FINISHING)
> +		mfc_write(dev, ((S5P_FIMV_CH_LAST_FRAME&  S5P_FIMV_CH_MASK)<<
> +		S5P_FIMV_CH_SHIFT) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);

Indentation is a bit misleading here.

> +	else
> +		mfc_write(dev, ((S5P_FIMV_CH_FRAME_START&  S5P_FIMV_CH_MASK)<<
> +		S5P_FIMV_CH_SHIFT) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
> +
>   	return 0;
>   }

--
Regards,
Sylwester
