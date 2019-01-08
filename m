Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE9AC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 10:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 417012087F
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 10:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbfAHK0y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 05:26:54 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51579 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727689AbfAHK0y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 05:26:54 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ggoax-0000qC-Iv; Tue, 08 Jan 2019 11:26:51 +0100
Message-ID: <1546943210.5406.2.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] v4l2-mem2mem: add job_write callback
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Date:   Tue, 08 Jan 2019 11:26:50 +0100
In-Reply-To: <d65a2757-69b9-b419-081e-ae6953bad508@xs4all.nl>
References: <20181214154316.62011-1-hverkuil-cisco@xs4all.nl>
         <20181214154316.62011-2-hverkuil-cisco@xs4all.nl>
         <d65a2757-69b9-b419-081e-ae6953bad508@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Mon, 2019-01-07 at 15:42 +0100, Hans Verkuil wrote:
> Tomasz, Ezequiel, Philipp,
> 
> I'd really like to have a review of this patch. If you have some time to
> look at this, then that would be very nice.

I don't think coda supports swapping in new buffers while a job is
running. Before I can test this I'll have to restructure the coda
encoder to use an internal ring buffer and memcpy from there to vmalloc
capture buffers. I don't expect I can get around to this soon. That
being said, the TRANS_WRITING mechanism looks like it would fit to the
way the coda encoder's buffer overflow stall / resume work (to my
understanding).

I don't think the nomenclature is accurate for coda, though, as
TRANS_RUNNING/TRANS_WRITING is the same state as far as the encoder is
concerned. I assume that when the encoder output fifo overflows, the
macroblock sequencer stalls and only continues encoding further
macroblocks when there is again space to continue.

> On a related note: I am also thinking of adding a new callback to help
> decoders search for headers containing the resolution. This as per the
> stateful decoder spec where you start streaming on the output queue
> until the header information is found. Only then will userspace start
> the capture queue.
> 
> Currently the search for this header is done in buf_queue (e.g. mediatek)
> but it would be much nicer if this is properly integrated into the mem2mem
> framework.

Yes it would be nice to unify decoder drivers' structure where possible.

> Anyway, that's just a heads-up.
> 
> Regards,
> 
> 	Hans
> 
> On 12/14/2018 04:43 PM, hverkuil-cisco@xs4all.nl wrote:
> > From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > 
> > The m2m framework works well for a stateful decoder: in job_ready()
> > you can process all output buffers until the whole compressed frame
> > is available for decoding, and then you return true to signal that
> > the decoder can start. The decoder decodes to a single capture buffer,
> > and the job is finished.
> > 
> > For encoders, however, life is harder: currently the m2m framework
> > assumes that the result of the encoder fits in a single buffer. There
> > is no nice API to be able to store the compressed frames into multiple
> > capture buffers.
> > 
> > This patch adds a new mode (TRANS_WRITING) where the result of the
> > device_run is written out buffer-by-buffer until all the data is
> > written. At that time v4l2_m2m_job_finish() is called and the next
> > job can start.
> >
> > This mode is triggered by calling v4l2_m2m_job_writing() if it is
> > clear in the process step that multiple buffers are required.
> > 
> > Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > ---
> >  drivers/media/v4l2-core/v4l2-mem2mem.c | 61 +++++++++++++++++++++-----
> >  include/media/v4l2-mem2mem.h           | 27 +++++++++++-
> >  2 files changed, 77 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> > index 5bbdec55b7d7..e00277e175f3 100644
> > --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> > +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> > @@ -43,8 +43,10 @@ module_param(debug, bool, 0644);
> >  #define TRANS_QUEUED		(1 << 0)
> >  /* Instance is currently running in hardware */
> >  #define TRANS_RUNNING		(1 << 1)
> > +/* Instance is writing the result */
> > +#define TRANS_WRITING		(1 << 2)
> >  /* Instance is currently aborting */
> > -#define TRANS_ABORT		(1 << 2)
> > +#define TRANS_ABORT		(1 << 3)
> >  
> >  
> >  /* Offset base for buffers on the destination queue - used to distinguish
> > @@ -253,9 +255,10 @@ EXPORT_SYMBOL(v4l2_m2m_get_curr_priv);
> >  static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
> >  {
> >  	unsigned long flags;
> > +	bool is_writing;
> >  
> >  	spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
> > -	if (NULL != m2m_dev->curr_ctx) {
> > +	if (m2m_dev->curr_ctx) {
> >  		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> >  		dprintk("Another instance is running, won't run now\n");
> >  		return;
> > @@ -274,6 +277,15 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
> >  
> >  	dprintk("Running job on m2m_ctx: %p\n", m2m_dev->curr_ctx);
> >  	m2m_dev->m2m_ops->device_run(m2m_dev->curr_ctx->priv);
> > +
> > +	spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
> > +	is_writing = m2m_dev->curr_ctx &&
> > +		v4l2_m2m_num_dst_bufs_ready(m2m_dev->curr_ctx) &&
> > +		(m2m_dev->curr_ctx->job_flags & TRANS_WRITING);
> > +	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> > +
> > +	if (is_writing)
> > +		m2m_dev->m2m_ops->job_write(m2m_dev->curr_ctx->priv);

What is the purpose of this hunk? Catch short running encode jobs that
throw an overflow interrupt and have it handled before device_run
returns?
Or is try_run also for jobs that are already in TRANS_WRITING state?

> >  }
> >  
> >  /*
> > @@ -326,8 +338,8 @@ static void __v4l2_m2m_try_queue(struct v4l2_m2m_dev *m2m_dev,
> >  	spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags_cap);
> >  	spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags_out);
> >  
> > -	if (m2m_dev->m2m_ops->job_ready
> > -		&& (!m2m_dev->m2m_ops->job_ready(m2m_ctx->priv))) {
> > +	if (m2m_dev->m2m_ops->job_ready &&
> > +	    !m2m_dev->m2m_ops->job_ready(m2m_ctx->priv)) {
> >  		dprintk("Driver not ready\n");
> >  		goto job_unlock;
> >  	}
> > @@ -384,7 +396,8 @@ static void v4l2_m2m_device_run_work(struct work_struct *work)
> >   * @m2m_ctx: m2m context with jobs to be canceled
> >   *
> >   * In case of streamoff or release called on any context,
> > - * 1] If the context is currently running, then abort job will be called
> > + * 1] If the context is currently running or writing, then abort job will be
> > + *    called
> >   * 2] If the context is queued, then the context will be removed from
> >   *    the job_queue
> >   */
> > @@ -397,16 +410,19 @@ static void v4l2_m2m_cancel_job(struct v4l2_m2m_ctx *m2m_ctx)
> >  	spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
> >  
> >  	m2m_ctx->job_flags |= TRANS_ABORT;
> > -	if (m2m_ctx->job_flags & TRANS_RUNNING) {
> > +	if (m2m_ctx->job_flags & (TRANS_RUNNING | TRANS_WRITING)) {
> >  		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> >  		if (m2m_dev->m2m_ops->job_abort)
> >  			m2m_dev->m2m_ops->job_abort(m2m_ctx->priv);
> > +		if (m2m_ctx->job_flags & TRANS_WRITING)
> > +			v4l2_m2m_job_finish(m2m_dev, m2m_ctx);
> >  		dprintk("m2m_ctx %p running, will wait to complete\n", m2m_ctx);
> > -		wait_event(m2m_ctx->finished,
> > -				!(m2m_ctx->job_flags & TRANS_RUNNING));
> > +		wait_event(m2m_ctx->finished, !(m2m_ctx->job_flags &
> > +					(TRANS_RUNNING | TRANS_WRITING)));
> >  	} else if (m2m_ctx->job_flags & TRANS_QUEUED) {
> >  		list_del(&m2m_ctx->queue);
> > -		m2m_ctx->job_flags &= ~(TRANS_QUEUED | TRANS_RUNNING);
> > +		m2m_ctx->job_flags &= ~(TRANS_QUEUED | TRANS_RUNNING |
> > +					TRANS_WRITING);
> >  		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> >  		dprintk("m2m_ctx: %p had been on queue and was removed\n",
> >  			m2m_ctx);
> > @@ -416,6 +432,26 @@ static void v4l2_m2m_cancel_job(struct v4l2_m2m_ctx *m2m_ctx)
> >  	}
> >  }
> >  
> > +void v4l2_m2m_job_writing(struct v4l2_m2m_dev *m2m_dev,
> > +			  struct v4l2_m2m_ctx *m2m_ctx)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
> > +	if (!m2m_dev->curr_ctx || m2m_dev->curr_ctx != m2m_ctx) {
> > +		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> > +		dprintk("Called by an instance not currently running\n");
> > +		return;
> > +	}
> > +
> > +	m2m_dev->curr_ctx->job_flags &= ~TRANS_RUNNING;
> > +	m2m_dev->curr_ctx->job_flags |= TRANS_WRITING;
> > +
> > +	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> > +}
> > +EXPORT_SYMBOL(v4l2_m2m_job_writing);

What happens if a new capture buffer is queued right before the driver
calls v4l2_m2m_job_writing?

I would have expected v4l2_m2m_job_writing to check if there are buffers
available and if so immediately schedule a job_work, and then in that
job_work call ->job_write instead of v4l2_m2m_try_run.

> > +
> > +
> >  void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
> >  			 struct v4l2_m2m_ctx *m2m_ctx)
> >  {
> > @@ -429,7 +465,8 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
> >  	}
> >  
> >  	list_del(&m2m_dev->curr_ctx->queue);
> > -	m2m_dev->curr_ctx->job_flags &= ~(TRANS_QUEUED | TRANS_RUNNING);
> > +	m2m_dev->curr_ctx->job_flags &= ~(TRANS_QUEUED | TRANS_RUNNING |
> > +					  TRANS_WRITING);
> >  	wake_up(&m2m_dev->curr_ctx->finished);
> >  	m2m_dev->curr_ctx = NULL;
> >  
> > @@ -504,6 +541,10 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> >  		return -EPERM;
> >  	}
> >  	ret = vb2_qbuf(vq, vdev->v4l2_dev->mdev, buf);
> > +	if (!ret && !V4L2_TYPE_IS_OUTPUT(vq->type) &&
> > +	    (m2m_ctx->job_flags & TRANS_WRITING))
> > +		m2m_ctx->m2m_dev->m2m_ops->job_write(m2m_ctx->priv);
> > +
> >  	if (!ret && !(buf->flags & V4L2_BUF_FLAG_IN_REQUEST))
> >  		v4l2_m2m_try_schedule(m2m_ctx);
> >  
> > diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
> > index 5467264771ec..380f8aea9191 100644
> > --- a/include/media/v4l2-mem2mem.h
> > +++ b/include/media/v4l2-mem2mem.h
> > @@ -25,13 +25,18 @@
> >   *		callback.
> >   *		The job does NOT have to end before this callback returns
> >   *		(and it will be the usual case). When the job finishes,
> > - *		v4l2_m2m_job_finish() has to be called.
> > + *		v4l2_m2m_job_writing() or v4l2_m2m_job_finish() has to be called.
> >   * @job_ready:	optional. Should return 0 if the driver does not have a job
> >   *		fully prepared to run yet (i.e. it will not be able to finish a
> >   *		transaction without sleeping). If not provided, it will be
> >   *		assumed that one source and one destination buffer are all
> >   *		that is required for the driver to perform one full transaction.
> >   *		This method may not sleep.
> > + * @job_write:	optional. After v4l2_m2m_job_writing() was called, this callback
> > + *		is called whenever a new capture buffer was queued so the result
> > + *		of the job can be written to the newly queued buffer(s). Once the
> > + *		full result has been written the job can be finished by calling
> > + *		v4l2_m2m_job_finish().

As mentioned above, "the result of the job" may not necessarily exist at
this point. If the whole encoder hardware pipeline stalls on buffer
overflows, calling job_write actually may continue the encoding job.

> >   * @job_abort:	optional. Informs the driver that it has to abort the currently
> >   *		running transaction as soon as possible (i.e. as soon as it can
> >   *		stop the device safely; e.g. in the next interrupt handler),
> > @@ -44,6 +49,7 @@
> >  struct v4l2_m2m_ops {
> >  	void (*device_run)(void *priv);
> >  	int (*job_ready)(void *priv);
> > +	void (*job_write)(void *priv);
> >  	void (*job_abort)(void *priv);
> >  };
> >  
> > @@ -159,6 +165,25 @@ struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
> >   */
> >  void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx);
> >  
> > +/**
> > + * v4l2_m2m_job_writing() - inform the framework that the result of the job
> > + * is ready and is now being written to capture buffers

"inform the framework that the job needs further capture buffers to
continue."?

Depending on the hardware implementation, the result of the job may be
ready, or the job may be stalled waiting for capture buffer space.

> > + *
> > + * @m2m_dev: opaque pointer to the internal data to handle M2M context
> > + * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
> > + *
> > + * Called by a driver if the resulting data of the job is being written to
> > + * capture buffers. This means that whenever a new capture buffer is queued
> > + * up the &v4l2_m2m_ops->job_write callback is called. Once all the data has
> > + * been written v4l2_m2m_job_finish() is called.
> > + *
> > + * This is typically only needed by stateful encoders where it is not known
> > + * until the compressed data arrives how many capture buffers are needed to
> > + * store the result and it has to wait for new capture buffers to be queued.
> > + */
> > +void v4l2_m2m_job_writing(struct v4l2_m2m_dev *m2m_dev,
> > +			  struct v4l2_m2m_ctx *m2m_ctx);
> > +
> >  /**
> >   * v4l2_m2m_job_finish() - inform the framework that a job has been finished
> >   * and have it clean up
> > 

regards
Philipp
