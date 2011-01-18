Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34710 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab1ARKIl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 05:08:41 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Tue, 18 Jan 2011 19:08:31 +0900
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [RFC/PATCH v6 3/4] MFC: Add MFC 5.1 V4L2 driver
In-reply-to: <006a01cbb640$9f4b1050$dde130f0$%oh@samsung.com>
To: jaeryul.oh@samsung.com, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, kgene.kim@samsung.com
Message-id: <000c01cbb6f7$ac7139f0$0553add0$%debski@samsung.com>
Content-language: en-gb
References: <1294417534-3856-1-git-send-email-k.debski@samsung.com>
 <1294417534-3856-4-git-send-email-k.debski@samsung.com>
 <006a01cbb640$9f4b1050$dde130f0$%oh@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

> From: Jaeryul Oh [mailto:jaeryul.oh@samsung.com]
> 
> Hi, Kamil
> I have a comment about s5p_mfc_stop_streaming()function.
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

<snip>

> > +
> > +/* Thou shalt stream no more. */
> > +static int s5p_mfc_stop_streaming(struct vb2_queue *q)
> > +{
> > +	unsigned long flags;
> > +	struct s5p_mfc_ctx *ctx = q->drv_priv;
> > +	struct s5p_mfc_dev *dev = ctx->dev;
> > +
> > +	if ((ctx->state == MFCINST_DEC_FINISHING ||
> > +		ctx->state ==  MFCINST_DEC_RUNNING) &&
> > +		dev->curr_ctx == ctx->num && dev->hw_lock) {
> > +		ctx->state = MFCINST_DEC_ABORT;
> > +		s5p_mfc_wait_for_done_ctx(ctx,
> > S5P_FIMV_R2H_CMD_FRAME_DONE_RET,
> > +									0);
> > +	}
> > +	ctx->state = MFCINST_DEC_FINISHED;
> > +	spin_lock_irqsave(&dev->irqlock, flags);
> > +	s5p_mfc_error_cleanup_queue(&ctx->dst_queue,
> > +	        &ctx->vq_dst);
> > +	s5p_mfc_error_cleanup_queue(&ctx->src_queue,
> > +	        &ctx->vq_src);
> > +	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +		INIT_LIST_HEAD(&ctx->dst_queue);
> > +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> > +		INIT_LIST_HEAD(&ctx->src_queue);
> > +	spin_unlock_irqrestore(&dev->irqlock, flags);
> > +	return 0;
> > +}
> This function is called by __vb2_queue_cancel().and
> __vb2_queue_cancel()
> can be
> called by vb2_queue_release() or vb2_streamoff().
> But, in this s5p_mfc_stop_streaming(),s5p_mfc_error_cleanup_queue() for
> src/dst
> is runned regardless of q->type. Is that right ?
> and in case of streamoff, queued bufs should be removed, then qbuf is
> needed
> before streamon  again, so ctx->dst_queue_cnt = 0; ctx->src_queue_cnt =
> 0;
> is required
> what do you think about this ?
> 

It has to be changed to support pause and dynamic resolution change.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

