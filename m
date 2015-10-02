Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17554 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbbJBMoY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2015 08:44:24 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Andrzej Hajda' <a.hajda@samsung.com>,
	"'open list:ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC)...'"
	<linux-media@vger.kernel.org>
Cc: 'Bartlomiej Zolnierkiewicz' <b.zolnierkie@samsung.com>,
	'Marek Szyprowski' <m.szyprowski@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Jeongtae Park' <jtp.park@samsung.com>,
	'Mauro Carvalho Chehab' <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org
References: <1443787779-18458-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1443787779-18458-1-git-send-email-a.hajda@samsung.com>
Subject: RE: [PATCH v2 1/2] s5p-mfc: end-of-stream handling for newer encoders
Date: Fri, 02 Oct 2015 14:44:21 +0200
Message-id: <002601d0fd10$1006ce90$30146bb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Thank you for your patch, I have a minor comment. Please find it below. 

> From: Andrzej Hajda [mailto:a.hajda@samsung.com]
> Sent: Friday, October 02, 2015 2:10 PM
> 
> MFC encoder supports end-of-stream handling for encoder in version 5 of
> hardware. This patch adds it also for newer version.
> It was successfully tested on MFC-v8.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
> Hi,
> 
> This version is rebased on latest media_tree branch.
> 
> Regards
> Andrzej
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c        | 25 ++++++------
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |  5 ++-
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 51
> ++++++++++++++++---------
>  3 files changed, 49 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 7b646c2..05a31ee 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -181,13 +181,6 @@ unlock:
>  		mutex_unlock(&dev->mfc_mutex);
>  }
> 
> -static void s5p_mfc_clear_int_flags(struct s5p_mfc_dev *dev) -{
> -	mfc_write(dev, 0, S5P_FIMV_RISC_HOST_INT);
> -	mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD);
> -	mfc_write(dev, 0xffff, S5P_FIMV_SI_RTN_CHID);
> -}
> -
>  static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
{
>  	struct s5p_mfc_buf *dst_buf;
> @@ -579,17 +572,13 @@ static void s5p_mfc_handle_init_buffers(struct
> s5p_mfc_ctx *ctx,
>  	}
>  }
> 
> -static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx,
> -				 unsigned int reason, unsigned int err)
> +static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx)
>  {
>  	struct s5p_mfc_dev *dev = ctx->dev;
>  	struct s5p_mfc_buf *mb_entry;
> 
>  	mfc_debug(2, "Stream completed\n");
> 
> -	s5p_mfc_clear_int_flags(dev);
> -	ctx->int_type = reason;
> -	ctx->int_err = err;
>  	ctx->state = MFCINST_FINISHED;
> 
>  	spin_lock(&dev->irqlock);
> @@ -646,6 +635,13 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
>  		if (ctx->c_ops->post_frame_start) {
>  			if (ctx->c_ops->post_frame_start(ctx))
>  				mfc_err("post_frame_start() failed\n");
> +
> +			if (ctx->state == MFCINST_FINISHING &&
> +						list_empty(&ctx->ref_queue))
> {
> +				s5p_mfc_hw_call_void(dev->mfc_ops,
> clear_int_flags, dev);
> +				s5p_mfc_handle_stream_complete(ctx);
> +				break;
> +			}
>  			s5p_mfc_hw_call_void(dev->mfc_ops,
> clear_int_flags, dev);
>  			wake_up_ctx(ctx, reason, err);
>  			WARN_ON(test_and_clear_bit(0, &dev->hw_lock) ==
> 0); @@ -691,7 +687,10 @@ static irqreturn_t s5p_mfc_irq(int irq, void
*priv)
>  		break;
> 
>  	case S5P_MFC_R2H_CMD_COMPLETE_SEQ_RET:
> -		s5p_mfc_handle_stream_complete(ctx, reason, err);
> +		s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
> +		ctx->int_type = reason;
> +		ctx->int_err = err;
> +		s5p_mfc_handle_stream_complete(ctx);
>  		break;
> 
>  	case S5P_MFC_R2H_CMD_DPB_FLUSH_RET:
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 94868f7..d082d47 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -907,9 +907,9 @@ static int enc_post_frame_start(struct s5p_mfc_ctx
> *ctx)
>  			list_add_tail(&mb_entry->list, &ctx->ref_queue);
>  			ctx->ref_queue_cnt++;
>  		}
> -		mfc_debug(2, "enc src count: %d, enc ref count: %d\n",
> -			  ctx->src_queue_cnt, ctx->ref_queue_cnt);
>  	}
> +	mfc_debug(2, "enc src count: %d, enc ref count: %d\n",
> +		  ctx->src_queue_cnt, ctx->ref_queue_cnt);
>  	if ((ctx->dst_queue_cnt > 0) && (strm_size > 0)) {
>  		mb_entry = list_entry(ctx->dst_queue.next, struct
> s5p_mfc_buf,
>
list);
> @@ -932,6 +932,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx
> *ctx)
>  	spin_unlock_irqrestore(&dev->irqlock, flags);
>  	if ((ctx->src_queue_cnt == 0) || (ctx->dst_queue_cnt == 0))
>  		clear_work_bit(ctx);
> +
>  	return 0;
>  }
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> index e0924a52..69a6880 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> @@ -522,7 +522,7 @@ static int s5p_mfc_set_enc_stream_buffer_v6(struct
> s5p_mfc_ctx *ctx,
>  	writel(addr, mfc_regs->e_stream_buffer_addr); /* 16B align */
>  	writel(size, mfc_regs->e_stream_buffer_size);
> 
> -	mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%x\n",
> +	mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%d\n",

A small mistake/type is present here - 0x is left when the formatting 
was changed from %x to %d.  I am not sure what your intention was, hence
I prefer to ask you instead of fixing this in my repo.

>  		  addr, size);
> 
>  	return 0;
> @@ -554,7 +554,7 @@ static void s5p_mfc_get_enc_frame_buffer_v6(struct
> s5p_mfc_ctx *ctx,
>  	enc_recon_y_addr = readl(mfc_regs->e_recon_luma_dpb_addr);
>  	enc_recon_c_addr = readl(mfc_regs->e_recon_chroma_dpb_addr);
> 
> -	mfc_debug(2, "recon y addr: 0x%08lx\n", enc_recon_y_addr);
> +	mfc_debug(2, "recon y addr: 0x%08lx y_addr: 0x%08lx\n",
> +enc_recon_y_addr, *y_addr);
>  	mfc_debug(2, "recon c addr: 0x%08lx\n", enc_recon_c_addr);  }
> 
> @@ -1483,6 +1483,7 @@ static int s5p_mfc_encode_one_frame_v6(struct
> s5p_mfc_ctx *ctx)  {
>  	struct s5p_mfc_dev *dev = ctx->dev;
>  	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
> +	int cmd;
> 
>  	mfc_debug(2, "++\n");
> 
> @@ -1493,9 +1494,13 @@ static int s5p_mfc_encode_one_frame_v6(struct
> s5p_mfc_ctx *ctx)
> 
>  	s5p_mfc_set_slice_mode(ctx);
> 
> +	if (ctx->state != MFCINST_FINISHING)
> +		cmd = S5P_FIMV_CH_FRAME_START_V6;
> +	else
> +		cmd = S5P_FIMV_CH_LAST_FRAME_V6;
> +
>  	writel(ctx->inst_no, mfc_regs->instance_id);
> -	s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
> -			S5P_FIMV_CH_FRAME_START_V6, NULL);
> +	s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev, cmd,
> NULL);
> 
>  	mfc_debug(2, "--\n");
> 
> @@ -1563,8 +1568,8 @@ static inline int s5p_mfc_run_dec_frame(struct
> s5p_mfc_ctx *ctx)
>  	temp_vb->flags |= MFC_BUF_FLAG_USED;
>  	s5p_mfc_set_dec_stream_buffer_v6(ctx,
>  		vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf,
> 0),
> -		ctx->consumed_stream,
> -		temp_vb->b->vb2_buf.planes[0].bytesused);
> +			ctx->consumed_stream,
> +			temp_vb->b->vb2_buf.planes[0].bytesused);
>  	spin_unlock_irqrestore(&dev->irqlock, flags);
> 
>  	dev->curr_ctx = ctx->num;
> @@ -1592,7 +1597,7 @@ static inline int s5p_mfc_run_enc_frame(struct
> s5p_mfc_ctx *ctx)
> 
>  	spin_lock_irqsave(&dev->irqlock, flags);
> 
> -	if (list_empty(&ctx->src_queue)) {
> +	if (list_empty(&ctx->src_queue) && ctx->state !=
> MFCINST_FINISHING) {
>  		mfc_debug(2, "no src buffers.\n");
>  		spin_unlock_irqrestore(&dev->irqlock, flags);
>  		return -EAGAIN;
> @@ -1604,15 +1609,28 @@ static inline int s5p_mfc_run_enc_frame(struct
> s5p_mfc_ctx *ctx)
>  		return -EAGAIN;
>  	}
> 
> -	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
> -	src_mb->flags |= MFC_BUF_FLAG_USED;
> -	src_y_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b-
> >vb2_buf, 0);
> -	src_c_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b-
> >vb2_buf, 1);
> +	if (list_empty(&ctx->src_queue)) {
> +		/* send null frame */
> +		s5p_mfc_set_enc_frame_buffer_v6(ctx, 0, 0);
> +		src_mb = NULL;
> +	} else {
> +		src_mb = list_entry(ctx->src_queue.next, struct
> s5p_mfc_buf, list);
> +		src_mb->flags |= MFC_BUF_FLAG_USED;
> +		if (src_mb->b->vb2_buf.planes[0].bytesused == 0) {
> +			s5p_mfc_set_enc_frame_buffer_v6(ctx, 0, 0);
> +			ctx->state = MFCINST_FINISHING;
> +		} else {
> +			src_y_addr =
> vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf, 0);
> +			src_c_addr =
> vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf, 1);
> 
> -	mfc_debug(2, "enc src y addr: 0x%08lx\n", src_y_addr);
> -	mfc_debug(2, "enc src c addr: 0x%08lx\n", src_c_addr);
> +			mfc_debug(2, "enc src y addr: 0x%08lx\n",
> src_y_addr);
> +			mfc_debug(2, "enc src c addr: 0x%08lx\n",
> src_c_addr);
> 
> -	s5p_mfc_set_enc_frame_buffer_v6(ctx, src_y_addr, src_c_addr);
> +			s5p_mfc_set_enc_frame_buffer_v6(ctx, src_y_addr,
> src_c_addr);
> +			if (src_mb->flags & MFC_BUF_FLAG_EOS)
> +				ctx->state = MFCINST_FINISHING;
> +		}
> +	}
> 
>  	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
>  	dst_mb->flags |= MFC_BUF_FLAG_USED;
> @@ -1639,11 +1657,10 @@ static inline void s5p_mfc_run_init_dec(struct
> s5p_mfc_ctx *ctx)
>  	spin_lock_irqsave(&dev->irqlock, flags);
>  	mfc_debug(2, "Preparing to init decoding.\n");
>  	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
> -	mfc_debug(2, "Header size: %d\n",
> -		temp_vb->b->vb2_buf.planes[0].bytesused);
> +	mfc_debug(2, "Header size: %d\n",
> +temp_vb->b->vb2_buf.planes[0].bytesused);
>  	s5p_mfc_set_dec_stream_buffer_v6(ctx,
>  		vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf,
> 0), 0,
> -		temp_vb->b->vb2_buf.planes[0].bytesused);
> +			temp_vb->b->vb2_buf.planes[0].bytesused);
>  	spin_unlock_irqrestore(&dev->irqlock, flags);
>  	dev->curr_ctx = ctx->num;
>  	s5p_mfc_init_decode_v6(ctx);
> --
> 1.9.1

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


