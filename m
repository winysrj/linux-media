Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56570 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab0DAMsn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 08:48:43 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L07006NB7L530@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Apr 2010 13:48:41 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L0700LIZ7L4DA@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Apr 2010 13:48:41 +0100 (BST)
Date: Thu, 01 Apr 2010 14:46:41 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH v3 1/2] v4l: Add memory-to-memory device helper framework
 for videobuf.
In-reply-to: <201004011106.51357.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, hvaibhav@ti.com
Message-id: <003d01cad199$60915860$21b40920$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1269848207-2325-1-git-send-email-p.osciak@samsung.com>
 <1269848207-2325-2-git-send-email-p.osciak@samsung.com>
 <201004011106.51357.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

thank you for the review. My comments below.

> Hans Verkuil [mailto:hverkuil@xs4all.nl] wrote:
>Here is my review...
>

[...]

>> +/**
>> + * v4l2_m2m_next_src_buf() - return next source buffer from the list of ready
>> + * buffers
>> + */
>> +inline void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
>
>inline makes no sense for an exported function.
>
>You can also move this to the header and make it static inline. That would be
>a valid option for a lot of these small one-liner functions.
>

I must have missed that, thanks.

[...]

>> +static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>> +{
>> +	struct v4l2_m2m_dev *m2m_dev;
>> +	unsigned long flags_job, flags;
>> +
>> +	m2m_dev = m2m_ctx->m2m_dev;
>> +	dprintk("Trying to schedule a job for m2m_ctx: %p\n", m2m_ctx);
>> +
>> +	if (!m2m_ctx->out_q_ctx.q.streaming
>> +	    || !m2m_ctx->cap_q_ctx.q.streaming) {
>> +		dprintk("Streaming needs to be on for both queues\n");
>> +		return;
>> +	}
>> +
>> +	spin_lock_irqsave(&m2m_dev->job_spinlock, flags_job);
>> +	if (m2m_ctx->job_flags & TRANS_QUEUED) {
>> +		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
>> +		dprintk("On job queue already\n");
>> +		return;
>> +	}
>> +
>> +	spin_lock_irqsave(m2m_ctx->out_q_ctx.q.irqlock, flags);
>
>Two spin_lock_irqsave's? I think it will work, but it is very unusual.
>
>Does job_spinlock really have to be held with interrupts turned off?

Yeah, it is unusual. But a driver may need to access current context from
its interrupt handler. That requires locking the job queue.

The insertion of a new instance to the job queue requires verification of all
those conditions. Hence the spinlocks.

[...]

>> +unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>> +			   struct poll_table_struct *wait)
>> +{
>> +	struct videobuf_queue *dst_q;
>> +	struct videobuf_buffer *vb = NULL;
>> +	unsigned int rc = 0;
>> +
>> +	dst_q = v4l2_m2m_get_dst_vq(m2m_ctx);
>> +
>> +	mutex_lock(&dst_q->vb_lock);
>> +
>> +	if (dst_q->streaming) {
>> +		if (!list_empty(&dst_q->stream))
>> +			vb = list_entry(dst_q->stream.next,
>> +					struct videobuf_buffer, stream);
>> +	}
>> +
>> +	if (!vb)
>> +		rc = POLLERR;
>> +
>> +	if (0 == rc) {
>> +		poll_wait(file, &vb->done, wait);
>> +		if (vb->state == VIDEOBUF_DONE || vb->state == VIDEOBUF_ERROR)
>> +			rc = POLLOUT | POLLRDNORM;
>> +	}
>> +
>> +	mutex_unlock(&dst_q->vb_lock);
>
>Would there be any need for polling for writing?

Something has to be chosen, we could be polling for both of course, but in
my opinion in case of m2m devices we are usually interested in the result
of the operation. And in a great majority of cases (1:1 src:dst buffers) this
will also mean src buffer is ready as well. Besides, the app can always simply
sleep on dqbuf in one thread.

>> +struct v4l2_m2m_dev *v4l2_m2m_init(struct v4l2_m2m_ops *m2m_ops)
>> +{
>> +	struct v4l2_m2m_dev *m2m_dev;
>> +
>> +	if (!m2m_ops)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	BUG_ON(!m2m_ops->device_run);
>> +	BUG_ON(!m2m_ops->job_abort);
>
>No need to crash. Use WARN_ON and return an error.
>
>Learned something today: I didn't know ERR_PTR existed! Nice.
>

Those BUG_ONs were actually "inspired" by similar code in videobuf-core ;)

>> +	m2m_dev = kzalloc(sizeof *m2m_dev, GFP_KERNEL);
>> +	if (!m2m_dev)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	m2m_dev->curr_ctx = NULL;
>> +	m2m_dev->m2m_ops = m2m_ops;
>> +	INIT_LIST_HEAD(&m2m_dev->jobqueue);
>> +	spin_lock_init(&m2m_dev->job_spinlock);
>> +
>> +	return m2m_dev;
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_m2m_init);
>> +
>> +/**
>> + * v4l2_m2m_release() - cleans up and frees a m2m_dev structure
>> + *
>> + * Usually called from driver's remove() function.
>> + */
>> +void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev)
>> +{
>> +	kfree(m2m_dev);
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_m2m_release);
>
>Wouldn't it make sense to embed this struct in a filehandle structure?
>Then there is no need to allocate anything, you just need an init function.
>
>I like embedding structures: it's quite clean.
>

This was actually my initial design, but I thought that moving as much as possible
out of drivers will simplify them. That was my main target when writing this
framework... But if people prefer it embedded, we can try to move it back.
Although - as I said - I wanted to simplify drivers as much as possible.

[...]


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





