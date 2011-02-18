Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:50886 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab1BRLWi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 06:22:38 -0500
Date: Fri, 18 Feb 2011 12:22:30 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [RFC/PATCH v6 3/4] MFC: Add MFC 5.1 V4L2 driver
In-reply-to: <000301cbcf2e$223f9a70$66becf50$%oh@samsung.com>
To: jaeryul.oh@samsung.com, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, kgene.kim@samsung.com
Message-id: <007701cbcf5e$24bf3fa0$6e3dbee0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-gb
Content-transfer-encoding: 7BIT
References: <1294417534-3856-1-git-send-email-k.debski@samsung.com>
 <1294417534-3856-4-git-send-email-k.debski@samsung.com>
 <000301cbcf2e$223f9a70$66becf50$%oh@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> From: Jaeryul Oh [mailto:jaeryul.oh@samsung.com]
> 
> Kamil, I have a question about MFC state FINISHING & FINISHED as below.

Hi Peter,

I have answered your question below.

> 
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Kamil Debski
> > Sent: Saturday, January 08, 2011 1:26 AM
> > To: linux-media@vger.kernel.org; linux-samsung-soc@vger.kernel.org
> > Cc: m.szyprowski@samsung.com; pawel@osciak.com;
> kyungmin.park@samsung.com;
> > k.debski@samsung.com; jaeryul.oh@samsung.com; kgene.kim@samsung.com
> > Subject: [RFC/PATCH v6 3/4] MFC: Add MFC 5.1 V4L2 driver
> >
> > Multi Format Codec 5.1 is capable of handling a range of video codecs
> > and this driver provides V4L2 interface for video decoding.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/media/video/Kconfig                  |    8 +
> >  drivers/media/video/Makefile                 |    1 +
> >  drivers/media/video/s5p-mfc/Makefile         |    3 +
> >  drivers/media/video/s5p-mfc/regs-mfc5.h      |  335 +++++
> >  drivers/media/video/s5p-mfc/s5p_mfc.c        | 2072
> > ++++++++++++++++++++++++++
> >  drivers/media/video/s5p-mfc/s5p_mfc_common.h |  224 +++
> >  drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h  |  173 +++
> >  drivers/media/video/s5p-mfc/s5p_mfc_debug.h  |   47 +
> >  drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   92 ++
> >  drivers/media/video/s5p-mfc/s5p_mfc_intr.h   |   26 +
> >  drivers/media/video/s5p-mfc/s5p_mfc_memory.h |   43 +
> >  drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |  885 +++++++++++
> >  drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |  160 ++
> >  13 files changed, 4069 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/video/s5p-mfc/Makefile
> >  create mode 100644 drivers/media/video/s5p-mfc/regs-mfc5.h
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc.c
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_common.h
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_debug.h
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.c
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.h
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_memory.h
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.h
> >
> 
> Snipped...
> > +/* Videobuf opts */
> > +static struct vb2_ops s5p_mfc_qops = {
> > +	.buf_queue = s5p_mfc_buf_queue,
> > +	.queue_setup = s5p_mfc_queue_setup,
> > +	.start_streaming = s5p_mfc_start_streaming,
> > +	.buf_init = s5p_mfc_buf_init,
> > +	.stop_streaming = s5p_mfc_stop_streaming,
> > +	.wait_prepare = s5p_mfc_unlock,
> > +	.wait_finish = s5p_mfc_lock,
> > +};
> > +
> > +static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx
> *ctx)
> > +{
> > +	struct s5p_mfc_dev *dev = ctx->dev;
> > +	struct s5p_mfc_buf *dst_buf;
> > +
> > +	ctx->state = MFCINST_DEC_FINISHED;
> > +	mfc_debug("Decided to finish\n");
> > +	ctx->sequence++;
> > +	while (!list_empty(&ctx->dst_queue)) {
> > +		dst_buf = list_entry(ctx->dst_queue.next,
> > +				     struct s5p_mfc_buf, list);
> > +		mfc_debug("Cleaning up buffer: %d\n",
> > +					  dst_buf->b->v4l2_buf.index);
> > +		vb2_set_plane_payload(dst_buf->b, 0, 0);
> > +		vb2_set_plane_payload(dst_buf->b, 1, 0);
> > +		list_del(&dst_buf->list);
> > +		ctx->dst_queue_cnt--;
> > +		dst_buf->b->v4l2_buf.sequence = (ctx->sequence++);
> > +		if (s5p_mfc_get_pic_time_top(ctx) ==
> > +			s5p_mfc_get_pic_time_bottom(ctx))
> > +			dst_buf->b->v4l2_buf.field = V4L2_FIELD_NONE;
> > +		else
> > +			dst_buf->b->v4l2_buf.field =
> > +				V4L2_FIELD_INTERLACED;
> > +		ctx->dec_dst_flag &= ~(1 << dst_buf->b->v4l2_buf.index);
> > +		vb2_buffer_done(dst_buf->b, VB2_BUF_STATE_DONE);
> > +		mfc_debug("Cleaned up buffer: %d\n",
> > +			  dst_buf->b->v4l2_buf.index);
> > +	}
> > +	mfc_debug("After cleanup\n");
> > +}
> > +
> > +static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx,
> unsigned
> > int err)
> > +{
> > +	struct s5p_mfc_dev *dev = ctx->dev;
> > +	struct s5p_mfc_buf  *dst_buf;
> > +	size_t dspl_y_addr = s5p_mfc_get_dspl_y_adr();
> > +
> > +	ctx->sequence++;
> > +	/* If frame is same as previous then skip and do not dequeue */
> > +	if (s5p_mfc_get_frame_type() ==  S5P_FIMV_DECODE_FRAME_SKIPPED)
> > +		return;
> > +	/* The MFC returns address of the buffer, now we have to
> > +	 * check which videobuf does it correspond to */
> > +	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
> > +		mfc_debug("Listing: %d\n", dst_buf->b->v4l2_buf.index);
> > +		/* Check if this is the buffer we're looking for */
> > +		if (vb2_cma_plane_paddr(dst_buf->b, 0) == dspl_y_addr) {
> > +			list_del(&dst_buf->list);
> > +			ctx->dst_queue_cnt--;
> > +			dst_buf->b->v4l2_buf.sequence = ctx->sequence;
> > +			if (s5p_mfc_get_pic_time_top(ctx) ==
> > +				s5p_mfc_get_pic_time_bottom(ctx))
> > +				dst_buf->b->v4l2_buf.field =
> V4L2_FIELD_NONE;
> > +			else
> > +				dst_buf->b->v4l2_buf.field =
> > +						V4L2_FIELD_INTERLACED;
> > +			vb2_set_plane_payload(dst_buf->b, 0, ctx-
> >luma_size);
> > +			vb2_set_plane_payload(dst_buf->b, 1, ctx-
> >chroma_size);
> > +			clear_bit(dst_buf->b->v4l2_buf.index,
> > +						&ctx->dec_dst_flag);
> > +			if (err) {
> > +				vb2_buffer_done(dst_buf->b,
> > +						VB2_BUF_STATE_ERROR);
> > +			} else {
> > +				vb2_buffer_done(dst_buf->b,
> VB2_BUF_STATE_DONE);
> > +			}
> > +			break;
> > +		}
> > +	}
> > +}
> > +
> > +/* Handle frame decoding interrupt */
> > +static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
> > +					unsigned int reason, unsigned int
> err)
> > +{
> > +	struct s5p_mfc_dev *dev = ctx->dev;
> > +	unsigned int dst_frame_status;
> > +	struct s5p_mfc_buf *src_buf;
> > +	unsigned long flags;
> > +
> > +	dst_frame_status = s5p_mfc_get_dspl_status()
> > +				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
> > +	mfc_debug("Frame Status: %x\n", dst_frame_status);
> > +	spin_lock_irqsave(&dev->irqlock, flags);
> > +	/* All frames remaining in the buffer have been extracted  */
> > +	if (dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_EMPTY) {
> > +		s5p_mfc_handle_frame_all_extracted(ctx);
> > +	}
> > +
> > +	/* A frame has been decoded and is in the buffer  */
> > +	if (dst_frame_status == S5P_FIMV_DEC_STATUS_DISPLAY_ONLY ||
> > +	    dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_DISPLAY) {
> > +		s5p_mfc_handle_frame_new(ctx, err);
> > +	} else {
> > +		mfc_debug("No frame decode.\n");
> > +	}
> > +	/* Mark source buffer as complete */
> > +	if (dst_frame_status != S5P_FIMV_DEC_STATUS_DISPLAY_ONLY
> > +		&& !list_empty(&ctx->src_queue)) {
> > +		src_buf = list_entry(ctx->src_queue.next, struct
> s5p_mfc_buf,
> > +								list);
> > +		mfc_debug("Packed PB test. Size:%d, prev offset: %ld, this
> > run:"
> > +			" %d\n", src_buf->b->v4l2_planes[0].bytesused,
> > +			ctx->consumed_stream,
> s5p_mfc_get_consumed_stream());
> > +		ctx->consumed_stream += s5p_mfc_get_consumed_stream();
> > +		if (s5p_mfc_get_frame_type() ==
> > S5P_FIMV_DECODE_FRAME_P_FRAME
> > +					&& ctx->consumed_stream <
> > +					src_buf->b-
> >v4l2_planes[0].bytesused) {
> > +			/* Run MFC again on the same buffer */
> > +			mfc_debug("Running again the same buffer.\n");
> > +			s5p_mfc_set_dec_stream_buffer(ctx,
> > +				src_buf->cookie.stream, ctx-
> >consumed_stream,
> > +				src_buf->b->v4l2_planes[0].bytesused -
> > +							ctx-
> >consumed_stream);
> > +			dev->curr_ctx = ctx->num;
> > +			s5p_mfc_clean_ctx_int_flags(ctx);
> > +			spin_unlock_irqrestore(&dev->irqlock, flags);
> > +			s5p_mfc_clear_int_flags();
> > +			wake_up_ctx(ctx, reason, err);
> > +			s5p_mfc_decode_one_frame(ctx, 0);
> > +			return;
> > +		} else {
> > +			mfc_debug("MFC needs next buffer.\n");
> > +			/* Advance to next buffer */
> > +			if (src_buf->b->v4l2_planes[0].bytesused == 0) {
> > +				mfc_debug("Setting ctx->state to
> FINISHING\n");
> > +				ctx->state = MFCINST_DEC_FINISHING;
> > +			}
> > +			ctx->consumed_stream = 0;
> > +			list_del(&src_buf->list);
> > +			ctx->src_queue_cnt--;
> > +			vb2_buffer_done(src_buf->b, VB2_BUF_STATE_DONE);
> > +		}
> > +	}
> > +	spin_unlock_irqrestore(&dev->irqlock, flags);
> > +	mfc_debug("Assesing whether this context should be run
> again.\n");
> > +	if ((ctx->src_queue_cnt == 0 && ctx->state !=
> MFCINST_DEC_FINISHING)
> > +				    || ctx->dst_queue_cnt < ctx->dpb_count)
> {
> > +		mfc_debug("No need to run again.\n");
> > +		clear_work_bit(ctx);
> > +	}
> > +	mfc_debug("After assesing whether this context should be run
> > again.\n");
> > +	s5p_mfc_clear_int_flags();
> > +	wake_up_ctx(ctx, reason, err);
> > +	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> > +		BUG();
> > +	s5p_mfc_try_run(dev);
> > +}
> > +
> Basically, I understand that FINISHING state is starting point just
> after
> src
> queue/dequeue is
> finished. And state goes to the FINISHED right after all extracted.
> But, you change state as a FINISHED at beginning of
> s5p_mfc_handle_frame_all_extracted().
> What about FINISHING state ?
> if (src_buf->b->v4l2_planes[0].bytesused == 0) this condition meets
> after
> FINISHED state set
> So, it is confusing if state change like (RUNNING -> FINISHING ->
> FINISHED)
> is
> right.

The state flow is as follows:
1) The driver receives an src buffer with bytesused set to 0
	State is changed from RUNNING to FINISHING.
	At this point the command that is sent to MFC hw is
	S5P_FIMV_CH_LAST_FRAME (aka LAST_SEQ).
2) The driver dequeued remaining frames frame by frame.
	State is FINISHING, S5P_FIMV_CH_LAST_FRAME commands are
	sent and frames are dequeued in the interrupt handler.
3) If DISPLAY_STATUS[2:0] = 3 (DPB is empty and decoding is finished)
 	Then state is changed to FINISHED. This is the time when
	s5p_mfc_handle_frame_all_extracted is called.

I guess that the thing that bothers you is the place where state is set
to FINISHING. This could be moved to s5p_mfc_run_dec_frame - maybe the code
would be clearer. Anyway I think still it is ok, because the following code:

if (src_buf->b->v4l2_planes[0].bytesused == 0) {
	mfc_debug("Setting ctx->state to FINISHING\n");
	ctx->state = MFCINST_DEC_FINISHING;
}

Is run only if the following condition:

if (dst_frame_status != S5P_FIMV_DEC_STATUS_DISPLAY_ONLY
			&& !list_empty(&ctx->src_queue))

is met.

I hope I have answered your question.

> Snipped...
> 

Bets regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

