Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:60390 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505Ab0JZL6K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Oct 2010 07:58:10 -0400
Date: Tue, 26 Oct 2010 20:58:28 +0900
From: Jaeryul Oh <jaeryul.oh@samsung.com>
Subject: RE: [PATCH 3/4] MFC: Add MFC 5.1 V4L2 driver
In-reply-to: <1286968160-10629-4-git-send-email-k.debski@samsung.com>
To: 'Kamil Debski' <k.debski@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, kgene.kim@samsung.com
Reply-to: jaeryul.oh@samsung.com
Message-id: <00e501cb7505$1c7b73d0$55725b70$%oh@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1286968160-10629-1-git-send-email-k.debski@samsung.com>
 <1286968160-10629-4-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, Kamil, 
there is one meaningless parameter.

k.debski@samsung.com wrote:
[snip]
> +}
> +
> +/* Try running an operation on hardware */
> +static void s5p_mfc_try_run()
> +{
> +	struct vb2_buffer *temp_vb;
> +	struct s5p_mfc_ctx *ctx;
> +	int new_ctx;
> +	unsigned long flags;
> +	unsigned int cnt;
> +	unsigned int ret;
> +	mfc_debug("Try run dev: %p\n", dev);
> +	/* Check whether hardware is not running */
> +	if (test_and_set_bit(0, &dev->hw_lock) == 0) {
> +		/* Choose the context to run */
> +		spin_lock_irqsave(&dev->condlock, flags);
> +		mfc_debug("Previos context: %d (bit field %08lx)\n",
> +					  dev->curr_ctx, dev-
>ctx_work_bits);
> +		new_ctx = (dev->curr_ctx + 1) % MFC_NUM_CONTEXTS;
> +		cnt = 0;
> +		while (!test_bit(new_ctx, &dev->ctx_work_bits)) {
> +			new_ctx = (new_ctx + 1) % MFC_NUM_CONTEXTS;
> +			cnt++;
> +			if (cnt > MFC_NUM_CONTEXTS) {
> +				/* No contexts to run */
> +				spin_unlock_irqrestore(&dev->condlock,
flags);
> +				if (test_and_clear_bit(0, &dev->hw_lock) ==
0)
> {
> +					mfc_err("Failed to unlock
hardware.\n");
> +					return;
> +				}
> +				mfc_debug("No ctx is scheduled to be
run.\n");
> +				return;
> +			}
> +		}
> +		mfc_debug("New context: %d\n", new_ctx);
> +		spin_unlock_irqrestore(&dev->condlock, flags);
> +		ctx = dev->ctx[new_ctx];
> +		mfc_debug("Seting new context to %p\n", ctx);
> +		/* Got context to run in ctx */
> +		mfc_debug("ctx->dst_queue_cnt=%d ctx->dpb_count=%d" \
> +				" ctx->src_queue_cnt=%d\n", ctx-
> >dst_queue_cnt,\
> +					ctx->dpb_count, ctx->src_queue_cnt);
> +		mfc_debug("ctx->state=%d\n", ctx->state);
> +		/* Last frame has already been sent to MFC
> +		 * Now obtaining frames from MFC buffer */
> +		if (ctx->state == MFCINST_DEC_FINISHING) {
> +			s5p_mfc_set_dec_stream_buffer(ctx, 0, 0, 0);
> +			dev->curr_ctx = ctx->num;
> +			s5p_mfc_clean_ctx_int_flags(ctx);
> +			s5p_mfc_decode_one_frame(ctx, 1);
> +		} else if (ctx->state == MFCINST_DEC_RUNNING) {
> +			/* Frames are being decoded */
> +			if (list_empty(&ctx->src_queue)) {
> +				if (test_and_clear_bit(0, &dev->hw_lock) ==
0)
> {
> +					mfc_err("Failed to unlock
hardware.\n");
> +					return;
> +				}
> +				mfc_debug("No source buffers.\n");
> +				return;
> +			}
> +			/* Get the next source buffer */
> +			temp_vb = list_entry(ctx->src_queue.next, \
> +						struct vb2_buffer,
drv_entry);
> +			mfc_debug("Temp vb: %p\n", temp_vb);
> +			mfc_debug("Src Addr: %08lx\n",
> +						vb2_plane_paddr(temp_vb,
0));
> +			s5p_mfc_set_dec_stream_buffer(ctx, \
> +			      vb2_plane_paddr(temp_vb, 0), 0, \
> +			      temp_vb->v4l2_planes[0].bytesused);
> +			dev->curr_ctx = ctx->num;
> +			s5p_mfc_clean_ctx_int_flags(ctx);
> +			s5p_mfc_decode_one_frame(ctx,
> +				temp_vb->v4l2_planes[0].bytesused == 0);
> +		} else if (ctx->state == MFCINST_DEC_INIT) {
> +			/* Preparing decoding - getting instance number */
> +			mfc_debug("Getting instance number\n");
> +			dev->curr_ctx = ctx->num;
> +			s5p_mfc_clean_ctx_int_flags(ctx);
> +/*			s5p_mfc_set_dec_temp_buffers(ctx);
> + *			Removed per request by Peter, check if MFC works OK
*/
> +			ret = s5p_mfc_open_inst(ctx);
> +			if (ret) {
> +				mfc_err("Failed to create a new
instance.\n");
> +				ctx->state = MFCINST_DEC_ERROR;
> +			}
> +		} else if (ctx->state == MFCINST_DEC_RETURN_INST) {
> +			/* Closing decoding instance  */
> +			mfc_debug("Returning instance number\n");
> +			dev->curr_ctx = ctx->num;
> +			s5p_mfc_clean_ctx_int_flags(ctx);
> +			ret = s5p_mfc_return_inst_no(ctx);
> +			if (ret) {
> +				mfc_err("Failed to return an instance.\n");
> +				ctx->state = MFCINST_DEC_ERROR;
> +			}
> +
> +		} else if (ctx->state == MFCINST_DEC_GOT_INST) {
> +			/* Initializing decoding - parsing header */
> +			mfc_debug("Preparing to init decoding.\n");
> +			temp_vb = list_entry(ctx->src_queue.next,
> +						struct vb2_buffer,
drv_entry);
> +			s5p_mfc_set_dec_temp_buffers(ctx);
> +			mfc_debug("Header size: %d\n", \
> +					temp_vb->v4l2_planes[0].bytesused);
> +			s5p_mfc_set_dec_stream_buffer(ctx,\
> +					vb2_plane_paddr(temp_vb, 0), 0,
> +					 temp_vb->v4l2_planes[0].bytesused);
> +			dev->curr_ctx = ctx->num;
> +			mfc_debug("paddr: %08x\n", \
> +				(int)phys_to_virt(vb2_plane_paddr(temp_vb,
0)));
> +			s5p_mfc_clean_ctx_int_flags(ctx);
> +			s5p_mfc_init_decode(ctx);
> +		} else if (ctx->state == MFCINST_DEC_HEAD_PARSED) {
> +			/* Header was parsed now starting processing
> +			 * First set the output frame buffers
> +			 * s5p_mfc_alloc_dec_buffers(ctx); */
> +			if (ctx->capture_state == QUEUE_BUFS_MMAPED) {
> +				temp_vb = list_entry(ctx->src_queue.next, \
> +						struct vb2_buffer,
drv_entry);
> +				mfc_debug("Header size: %d\n",
> +					temp_vb->v4l2_planes[0].bytesused);
> +				s5p_mfc_set_dec_stream_buffer(ctx, \
> +					vb2_plane_paddr(temp_vb, 0), 0, \
> +					temp_vb->v4l2_planes[0].bytesused);
> +				dev->curr_ctx = ctx->num;
> +				s5p_mfc_clean_ctx_int_flags(ctx);
> +				s5p_mfc_set_dec_frame_buffer(ctx, 1);

What is second parameter (value = 1) ? In the
s5p_mfc_set_dec_frame_buffer(), 
Always, if (do_int) is runned. Is there any purpose ? otherwise, remove
this param.

> +			} else {
> +				mfc_err("It seems that not all
destionation" \
> +				    " buffers were mmaped.\nMFC requires
that" \
> +				    " all destination are mmaped before" \
> +				    " starting processing.\n");
> +				if (test_and_clear_bit(0, &dev->hw_lock) ==
0)
> {
> +					mfc_err("Failed to unlock
hardware.\n");
> +					return;
> +				}
> +			}
> +		} else {
> +			/* Free hardware lock */
> +			if (test_and_clear_bit(0, &dev->hw_lock) == 0) {
> +				mfc_err("Failed to unlock hardware.\n");
> +				return;
> +			}
> +		}
> +	} else {
> +		/* This is perfectly ok, the scheduled ctx should wait */
> +		mfc_debug("Couldn't lock HW.\n");
> +	}
> +}
> +

[snip]

> --
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

