Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45827 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab3FMKHV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 06:07:21 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOB005MLTAZHX70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Jun 2013 11:07:19 +0100 (BST)
Message-id: <51B999D5.1070206@samsung.com>
Date: Thu, 13 Jun 2013 12:07:17 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	'Philipp Zabel' <p.zabel@pengutronix.de>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'John Sheu' <sheu@google.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH v4] [media] mem2mem: add support for hardware buffered queue
References: <1370247828-7219-1-git-send-email-p.zabel@pengutronix.de>
 <002201ce681a$afaa1200$0efe3600$%debski@samsung.com>
In-reply-to: <002201ce681a$afaa1200$0efe3600$%debski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2013 11:45 AM, Kamil Debski wrote:
> Pawel and Marek, I would really like to hear your opinions on this patch.
> I remember that the assumption of the mem2mem framework (not to be confused
> with
> mem2mem type of devices) was that it was for simple devices where one output
> buffer
> was equivalent to one capture buffer. More complicated devices were supposed
> to use videobuf2 directly.
> 
> Please state your opinions.
> 
> Best wishes,
> -- 
> Kamil Debski
> Linux Kernel Developer
> Samsung R&D Institute Poland
>
>> > -----Original Message-----
>> > From: Philipp Zabel [mailto:p.zabel@pengutronix.de]
>> > Sent: Monday, June 03, 2013 10:24 AM
>> > To: linux-media@vger.kernel.org
>> > Cc: Sylwester Nawrocki; Mauro Carvalho Chehab; Pawel Osciak; John Sheu;
>> > Hans Verkuil; Kamil Debski; Andrzej Hajda; Philipp Zabel
>> > Subject: [PATCH v4] [media] mem2mem: add support for hardware buffered
>> > queue
>> > 
>> > On mem2mem decoders with a hardware bitstream ringbuffer, to drain the
>> > buffer at the end of the stream, remaining frames might need to be
>> > decoded from the bitstream buffer without additional input buffers
>> > being provided.
>> > To achieve this, allow a queue to be marked as buffered by the driver,
>> > and allow scheduling of device_runs when buffered ready queues are
>> > empty.
>> > 
>> > This also allows a driver to copy input buffers into their bitstream
>> > ringbuffer and immediately mark them as done to be dequeued.
>> > 
>> > The motivation for this patch is hardware assisted h.264 reordering
>> > support in the coda driver. For high profile streams, the coda can hold
>> > back out-of-order frames, causing a few mem2mem device runs in the
>> > beginning, that don't produce any decompressed buffer at the v4l2
>> > capture side. At the same time, the last few frames can be decoded from
>> > the bitstream with mem2mem device runs that don't need a new input
>> > buffer at the v4l2 output side. The decoder command ioctl can be used
>> > to put the decoder into the ringbuffer draining end-of-stream mode.
>> > 
>> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

As far as I'm concerned this change looks like something useful upstream,
it's really a simple modification and it makes the in-kernel m2m framework
more universal and useful for more drivers. But that's just my personal
opinion.

:-)

Thanks,
Sylwester

>> > ---
>> > Changes since v3:
>> >  - Split queue_set_buffered into set_src_buffered and set_dst_buffered,
>> > which
>> >    take a v4l2_m2m_ctx pointer instead of a vb2_queue (which isn't
>> > guaranteed
>> >    to be embedded in a v4l2_m2m_queue_ctx).
>> >  - Make them static inline.
>> > ---
>> >  drivers/media/v4l2-core/v4l2-mem2mem.c | 10 ++++++++--
>> >  include/media/v4l2-mem2mem.h           | 13 +++++++++++++
>> >  2 files changed, 21 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c
>> > b/drivers/media/v4l2-core/v4l2-mem2mem.c
>> > index 66f599f..1007e60 100644
>> > --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
>> > +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
>> > @@ -196,6 +196,10 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev
>> > *m2m_dev)
>> >   * 2) at least one destination buffer has to be queued,
>> >   * 3) streaming has to be on.
>> >   *
>> > + * If a queue is buffered (for example a decoder hardware ringbuffer
>> > + that has
>> > + * to be drained before doing streamoff), allow scheduling without
>> > v4l2
>> > + buffers
>> > + * on that queue.
>> > + *
>> >   * There may also be additional, custom requirements. In such case the
>> > driver
>> >   * should supply a custom callback (job_ready in v4l2_m2m_ops) that
>> > should
>> >   * return 1 if the instance is ready.
>> > @@ -224,14 +228,16 @@ static void v4l2_m2m_try_schedule(struct
>> > v4l2_m2m_ctx *m2m_ctx)
>> >  	}
>> > 
>> >  	spin_lock_irqsave(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
>> > -	if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue)) {
>> > +	if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue)
>> > +	    && !m2m_ctx->out_q_ctx.buffered) {
>> >  		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
>> > flags);
>> >  		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
>> >  		dprintk("No input buffers available\n");
>> >  		return;
>> >  	}
>> >  	spin_lock_irqsave(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
>> > -	if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)) {
>> > +	if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)
>> > +	    && !m2m_ctx->cap_q_ctx.buffered) {
>> >  		spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock,
>> > flags);
>> >  		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
>> > flags);
>> >  		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
>> > diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-
>> > mem2mem.h index d3eef01..a8e1bb3 100644
>> > --- a/include/media/v4l2-mem2mem.h
>> > +++ b/include/media/v4l2-mem2mem.h
>> > @@ -60,6 +60,7 @@ struct v4l2_m2m_queue_ctx {
>> >  	struct list_head	rdy_queue;
>> >  	spinlock_t		rdy_spinlock;
>> >  	u8			num_rdy;
>> > +	bool			buffered;
>> >  };
>> > 
>> >  struct v4l2_m2m_ctx {
>> > @@ -132,6 +133,18 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct
>> > v4l2_m2m_dev *m2m_dev,
>> >  		void *drv_priv,
>> >  		int (*queue_init)(void *priv, struct vb2_queue *src_vq,
>> > struct vb2_queue *dst_vq));
>> > 
>> > +static inline void v4l2_m2m_set_src_buffered(struct v4l2_m2m_ctx
>> > *m2m_ctx,
>> > +					     bool buffered)
>> > +{
>> > +	m2m_ctx->out_q_ctx.buffered = buffered; }
>> > +
>> > +static inline void v4l2_m2m_set_dst_buffered(struct v4l2_m2m_ctx
>> > *m2m_ctx,
>> > +					     bool buffered)
>> > +{
>> > +	m2m_ctx->cap_q_ctx.buffered = buffered; }
>> > +
>> >  void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx);
>> > 
>> >  void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct
>> > vb2_buffer *vb);
>> > --
>> > 1.8.2.rc2

-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
Samsung Electronics
