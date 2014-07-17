Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50972 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaGQRak (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 13:30:40 -0400
Message-ID: <1405618233.3611.21.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 06/11] [media] coda: delay coda_fill_bitstream()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>
Date: Thu, 17 Jul 2014 19:30:33 +0200
In-Reply-To: <53C7F72B.6080908@xs4all.nl>
References: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de>
	 <1405613112-22442-7-git-send-email-p.zabel@pengutronix.de>
	 <53C7F72B.6080908@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

thank you for the review.

Am Donnerstag, den 17.07.2014, 18:17 +0200 schrieb Hans Verkuil:
> > @@ -2272,6 +2273,15 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
> >  	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> >  	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> >  		if (q_data_src->fourcc == V4L2_PIX_FMT_H264) {
> > +			struct vb2_queue *vq;
> > +			/* start_streaming_called must be set, for v4l2_m2m_buf_done() */
> > +			vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> > +			vq->start_streaming_called = 1;
> 
> Why set start_streaming_called to 1? It is set before calling start_streaming.
> This is a recent change in videobuf2-core.c though.

Because I hadn't seen "[media] v4l: vb2: Fix stream start and buffer
completion race" yet. I'll update this patch.

> BTW, you should test with CONFIG_VIDEO_ADV_DEBUG on and force start_streaming
> errors to check whether vb2_buffer_done(buf, VB2_BUF_STATE_DEQUEUED) is called
> for the queued buffers in case of start_streaming failure.
> 
> With that config option vb2 will complain about unbalanced vb2 operations.
>
> I strongly suspect this code does not play well with this.

Yes, I will fix this.

> BTW, isn't it time to split up the coda driver? Over 3000 lines...

Indeed. This is also on my list.

regards
Philipp

