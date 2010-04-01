Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45628 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0DAJT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 05:19:56 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <p.osciak@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Date: Thu, 1 Apr 2010 14:49:29 +0530
Subject: RE: [PATCH v3 1/2] v4l: Add memory-to-memory device helper
 framework for videobuf.
Message-ID: <19F8576C6E063C45BE387C64729E7394044DF7EEAB@dbde02.ent.ti.com>
References: <1269848207-2325-1-git-send-email-p.osciak@samsung.com>
 <1269848207-2325-2-git-send-email-p.osciak@samsung.com>
 <201004011106.51357.hverkuil@xs4all.nl>
In-Reply-To: <201004011106.51357.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Thursday, April 01, 2010 2:37 PM
> To: Pawel Osciak
> Cc: linux-media@vger.kernel.org; m.szyprowski@samsung.com;
> kyungmin.park@samsung.com; Hiremath, Vaibhav
> Subject: Re: [PATCH v3 1/2] v4l: Add memory-to-memory device helper
> framework for videobuf.
>
> Here is my review...
[Hiremath, Vaibhav] Pawel,

Some of the Hans's comments have already been addressed in my cleanup patch, so please make note of it.

Thanks,
Vaibhav

>
> On Monday 29 March 2010 09:36:46 Pawel Osciak wrote:
> > A mem-to-mem device is a device that uses memory buffers passed by
> > userspace applications for both their source and destination data. This
> > is different from existing drivers, which utilize memory buffers for
> either
> > input or output, but not both.
> >
> > In terms of V4L2 such a device would be both of OUTPUT and CAPTURE type.
> >
> > Examples of such devices would be: image 'resizers', 'rotators',
> > 'colorspace converters', etc.
> >
> > This patch adds a separate Kconfig sub-menu for mem-to-mem devices as
> well.
> >
> > Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/media/video/Kconfig        |   14 +
> >  drivers/media/video/Makefile       |    2 +
> >  drivers/media/video/v4l2-mem2mem.c |  685
> ++++++++++++++++++++++++++++++++++++
> >  include/media/v4l2-mem2mem.h       |  154 ++++++++
> >  4 files changed, 855 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/video/v4l2-mem2mem.c
> >  create mode 100644 include/media/v4l2-mem2mem.h
> >
> > diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> > index f8fc865..5fd041e 100644
> > --- a/drivers/media/video/Kconfig
> > +++ b/drivers/media/video/Kconfig
> > @@ -45,6 +45,10 @@ config VIDEO_TUNER
> >     tristate
> >     depends on MEDIA_TUNER
> >
> > +config V4L2_MEM2MEM_DEV
> > +   tristate
> > +   depends on VIDEOBUF_GEN
> > +
> >  #
> >  # Multimedia Video device configuration
> >  #
> > @@ -1107,3 +1111,13 @@ config USB_S2255
> >
> >  endif # V4L_USB_DRIVERS
> >  endif # VIDEO_CAPTURE_DRIVERS
> > +
> > +menuconfig V4L_MEM2MEM_DRIVERS
> > +   bool "Memory-to-memory multimedia devices"
> > +   depends on VIDEO_V4L2
> > +   default n
> > +   ---help---
> > +     Say Y here to enable selecting drivers for V4L devices that
> > +     use system memory for both source and destination buffers, as
> opposed
> > +     to capture and output drivers, which use memory buffers for just
> > +     one of those.
> > diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> > index b88b617..e974680 100644
> > --- a/drivers/media/video/Makefile
> > +++ b/drivers/media/video/Makefile
> > @@ -117,6 +117,8 @@ obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
> >  obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
> >  obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
> >
> > +obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
> > +
> >  obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
> >
> >  obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
> > diff --git a/drivers/media/video/v4l2-mem2mem.c
> b/drivers/media/video/v4l2-mem2mem.c
> > new file mode 100644
> > index 0000000..a78157f
> > --- /dev/null
> > +++ b/drivers/media/video/v4l2-mem2mem.c
> > @@ -0,0 +1,685 @@
> > +/*
> > + * Memory-to-memory device framework for Video for Linux 2 and videobuf.
> > + *
> > + * Helper functions for devices that use videobuf buffers for both their
> > + * source and destination.
> > + *
> > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <p.osciak@samsung.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> the
> > + * Free Software Foundation; either version 2 of the License, or (at your
> > + * option) any later version.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/sched.h>
> > +#include <media/videobuf-core.h>
> > +#include <media/v4l2-mem2mem.h>
> > +
> > +MODULE_DESCRIPTION("Mem to mem device framework for videobuf");
> > +MODULE_AUTHOR("Pawel Osciak, <p.osciak@samsung.com>");
> > +MODULE_LICENSE("GPL");
> > +
> > +static int debug;
> > +module_param(debug, int, 0644);
> > +
> > +#define dprintk(fmt, arg...)                                               \
> > +   do {                                                            \
> > +           if (debug >= 1)                                         \
> > +                   printk(KERN_DEBUG "%s: " fmt, __func__, ## arg);\
> > +   } while (0)
> > +
> > +
> > +/* Instance is already queued on the jobqueue */
> > +#define TRANS_QUEUED               (1 << 0)
> > +/* Instance is currently running in hardware */
> > +#define TRANS_RUNNING              (1 << 1)
> > +
> > +
> > +/* Offset base for buffers on the destination queue - used to distinguish
> > + * between source and destination buffers when mmapping - they receive
> the same
> > + * offsets but for different queues */
> > +#define DST_QUEUE_OFF_BASE (1 << 30)
> > +
> > +
> > +/**
> > + * struct v4l2_m2m_dev - per-device context
> > + * @curr_ctx:              currently running instance
> > + * @jobqueue:              instances queued to run
> > + * @job_spinlock:  protects jobqueue
> > + * @m2m_ops:               driver callbacks
> > + */
> > +struct v4l2_m2m_dev {
> > +   struct v4l2_m2m_ctx     *curr_ctx;
> > +
> > +   struct list_head        jobqueue;
>
> Using job_queue is a bit more consistent as you also use an '_' in
> job_spinlock.
>
> > +   spinlock_t              job_spinlock;
> > +
> > +   struct v4l2_m2m_ops     *m2m_ops;
> > +};
> > +
> > +static struct v4l2_m2m_queue_ctx *get_queue_ctx(struct v4l2_m2m_ctx
> *m2m_ctx,
> > +                                           enum v4l2_buf_type type)
> > +{
> > +   switch (type) {
> > +   case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> > +           return &m2m_ctx->cap_q_ctx;
> > +   case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> > +           return &m2m_ctx->out_q_ctx;
> > +   default:
> > +           printk(KERN_ERR "Invalid buffer type\n");
> > +           return NULL;
> > +   }
> > +}
> > +
> > +/**
> > + * v4l2_m2m_get_vq() - return videobuf_queue for the given type
> > + */
> > +struct videobuf_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
> > +                                  enum v4l2_buf_type type)
> > +{
> > +   struct v4l2_m2m_queue_ctx *q_ctx;
> > +
> > +   q_ctx = get_queue_ctx(m2m_ctx, type);
> > +   if (!q_ctx)
> > +           return NULL;
> > +
> > +   return &q_ctx->q;
>
> Shorter:
>
>       struct v4l2_m2m_queue_ctx *q_ctx = get_queue_ctx(m2m_ctx, type);
>
>       return q_ctx ? &q_ctx->q : NULL;
>
> > +}
> > +EXPORT_SYMBOL(v4l2_m2m_get_vq);
> > +
> > +/**
> > + * v4l2_m2m_get_src_vq() - return videobuf_queue for source buffers
> > + */
> > +struct videobuf_queue *v4l2_m2m_get_src_vq(struct v4l2_m2m_ctx *m2m_ctx)
> > +{
> > +   return v4l2_m2m_get_vq(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> > +}
> > +EXPORT_SYMBOL(v4l2_m2m_get_src_vq);
> > +
> > +/**
> > + * v4l2_m2m_get_dst_vq() - return videobuf_queue for destination buffers
> > + */
> > +struct videobuf_queue *v4l2_m2m_get_dst_vq(struct v4l2_m2m_ctx *m2m_ctx)
> > +{
> > +   return v4l2_m2m_get_vq(m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> > +}
> > +EXPORT_SYMBOL(v4l2_m2m_get_dst_vq);
> > +
> > +/**
> > + * v4l2_m2m_next_buf() - return next buffer from the list of ready
> buffers
> > + */
> > +static void *v4l2_m2m_next_buf(struct v4l2_m2m_ctx *m2m_ctx,
> > +                          enum v4l2_buf_type type)
> > +{
> > +   struct v4l2_m2m_queue_ctx *q_ctx;
> > +   struct videobuf_buffer *vb = NULL;
> > +   unsigned long flags;
> > +
> > +   q_ctx = get_queue_ctx(m2m_ctx, type);
> > +   if (!q_ctx)
> > +           return NULL;
> > +
> > +   spin_lock_irqsave(q_ctx->q.irqlock, flags);
> > +
> > +   if (list_empty(&q_ctx->rdy_queue))
> > +           goto end;
> > +
> > +   vb = list_entry(q_ctx->rdy_queue.next, struct videobuf_buffer, queue);
> > +   vb->state = VIDEOBUF_ACTIVE;
> > +
> > +end:
> > +   spin_unlock_irqrestore(q_ctx->q.irqlock, flags);
> > +   return vb;
> > +}
> > +
> > +/**
> > + * v4l2_m2m_next_src_buf() - return next source buffer from the list of
> ready
> > + * buffers
> > + */
> > +inline void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
>
> inline makes no sense for an exported function.
>
> You can also move this to the header and make it static inline. That would
> be
> a valid option for a lot of these small one-liner functions.
>
> > +{
> > +   return v4l2_m2m_next_buf(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> > +}
> > +EXPORT_SYMBOL(v4l2_m2m_next_src_buf);
> > +
> > +/**
> > + * v4l2_m2m_next_dst_buf() - return next destination buffer from the list
> of
> > + * ready buffers
> > + */
> > +inline void *v4l2_m2m_next_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
> > +{
> > +   return v4l2_m2m_next_buf(m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> > +}
> > +EXPORT_SYMBOL(v4l2_m2m_next_dst_buf);
> > +
> > +/**
> > + * v4l2_m2m_buf_remove() - take off a buffer from the list of ready
> buffers and
> > + * return it
> > + */
> > +static void *v4l2_m2m_buf_remove(struct v4l2_m2m_ctx *m2m_ctx,
> > +                            enum v4l2_buf_type type)
> > +{
> > +   struct v4l2_m2m_queue_ctx *q_ctx;
> > +   struct videobuf_buffer *vb = NULL;
> > +   unsigned long flags;
> > +
> > +   q_ctx = get_queue_ctx(m2m_ctx, type);
> > +   if (!q_ctx)
> > +           return NULL;
> > +
> > +   spin_lock_irqsave(q_ctx->q.irqlock, flags);
> > +   if (!list_empty(&q_ctx->rdy_queue)) {
> > +           vb = list_entry(q_ctx->rdy_queue.next, struct videobuf_buffer,
> > +                           queue);
> > +           list_del(&vb->queue);
> > +           q_ctx->num_rdy--;
> > +   }
> > +   spin_unlock_irqrestore(q_ctx->q.irqlock, flags);
> > +
> > +   return vb;
> > +}
> > +
> > +/**
> > + * v4l2_m2m_src_buf_remove() - take off a source buffer from the list of
> ready
> > + * buffers and return it
> > + */
> > +void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
> > +{
> > +   return v4l2_m2m_buf_remove(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> > +}
> > +EXPORT_SYMBOL(v4l2_m2m_src_buf_remove);
> > +
> > +/**
> > + * v4l2_m2m_dst_buf_remove() - take off a destination buffer from the
> list of
> > + * ready buffers and return it
> > + */
> > +void *v4l2_m2m_dst_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
> > +{
> > +   return v4l2_m2m_buf_remove(m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> > +}
> > +EXPORT_SYMBOL(v4l2_m2m_dst_buf_remove);
> > +
> > +
> > +/*
> > + * Scheduling handlers
> > + */
> > +
> > +/**
> > + * v4l2_m2m_get_curr_priv() - return driver private data for the
> currently
> > + * running instance or NULL if no instance is running
> > + */
> > +void *v4l2_m2m_get_curr_priv(struct v4l2_m2m_dev *m2m_dev)
> > +{
> > +   unsigned long flags;
> > +   void *ret;
> > +
> > +   spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
> > +   if (!m2m_dev->curr_ctx)
> > +           ret = NULL;
> > +   else
> > +           ret = m2m_dev->curr_ctx->priv;
>
> Shorter:
>
>       ret = m2m_dev->curr_ctx ? m2m_dev->curr_ctx->priv : NULL;
>
> > +   spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> > +
> > +   return ret;
> > +}
> > +EXPORT_SYMBOL(v4l2_m2m_get_curr_priv);
> > +
> > +/**
> > + * v4l2_m2m_try_run() - select next job to perform and run it if possible
> > + *
> > + * Get next transaction (if present) from the waiting jobs list and run
> it.
> > + */
> > +static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
> > +{
> > +   unsigned long flags;
> > +
> > +   spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
> > +   if (NULL != m2m_dev->curr_ctx) {
> > +           spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> > +           dprintk("Another instance is running, won't run now\n");
> > +           return;
> > +   }
> > +
> > +   if (list_empty(&m2m_dev->jobqueue)) {
> > +           spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> > +           dprintk("No job pending\n");
> > +           return;
> > +   }
> > +
> > +   m2m_dev->curr_ctx = list_entry(m2m_dev->jobqueue.next,
> > +                              struct v4l2_m2m_ctx, queue);
> > +   m2m_dev->curr_ctx->job_flags |= TRANS_RUNNING;
> > +   spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> > +
> > +   m2m_dev->m2m_ops->device_run(m2m_dev->curr_ctx->priv);
> > +
> > +   return;
>
> Bogus return.
>
> > +}
> > +
> > +/**
> > + * v4l2_m2m_try_schedule() - check whether an instance is ready to be
> added to
> > + * the pending job queue and add it if so.
> > + * @m2m_ctx:       m2m context assigned to the instance to be checked
> > + *
> > + * There are three basic requirements an instance has to meet to be able
> to run:
> > + * 1) at least one source buffer has to be queued,
> > + * 2) at least one destination buffer has to be queued,
> > + * 3) streaming has to be on.
> > + *
> > + * There may also be additional, custom requirements. In such case the
> driver
> > + * should supply a custom callback (job_ready in v4l2_m2m_ops) that
> should
> > + * return 1 if the instance is ready.
> > + * An example of the above could be an instance that requires more than
> one
> > + * src/dst buffer per transaction.
> > + */
> > +static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
> > +{
> > +   struct v4l2_m2m_dev *m2m_dev;
> > +   unsigned long flags_job, flags;
> > +
> > +   m2m_dev = m2m_ctx->m2m_dev;
> > +   dprintk("Trying to schedule a job for m2m_ctx: %p\n", m2m_ctx);
> > +
> > +   if (!m2m_ctx->out_q_ctx.q.streaming
> > +       || !m2m_ctx->cap_q_ctx.q.streaming) {
> > +           dprintk("Streaming needs to be on for both queues\n");
> > +           return;
> > +   }
> > +
> > +   spin_lock_irqsave(&m2m_dev->job_spinlock, flags_job);
> > +   if (m2m_ctx->job_flags & TRANS_QUEUED) {
> > +           spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
> > +           dprintk("On job queue already\n");
> > +           return;
> > +   }
> > +
> > +   spin_lock_irqsave(m2m_ctx->out_q_ctx.q.irqlock, flags);
>
> Two spin_lock_irqsave's? I think it will work, but it is very unusual.
>
> Does job_spinlock really have to be held with interrupts turned off?
>
> > +   if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue)) {
> > +           spin_unlock_irqrestore(m2m_ctx->out_q_ctx.q.irqlock, flags);
> > +           spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
> > +           dprintk("No input buffers available\n");
> > +           return;
> > +   }
> > +   if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)) {
> > +           spin_unlock_irqrestore(m2m_ctx->out_q_ctx.q.irqlock, flags);
> > +           spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
> > +           dprintk("No output buffers available\n");
> > +           return;
> > +   }
> > +   spin_unlock_irqrestore(m2m_ctx->out_q_ctx.q.irqlock, flags);
> > +
> > +   if (m2m_dev->m2m_ops->job_ready
> > +           && (!m2m_dev->m2m_ops->job_ready(m2m_ctx->priv))) {
> > +           spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
> > +           dprintk("Driver not ready\n");
> > +           return;
> > +   }
> > +
> > +   if (!(m2m_ctx->job_flags & TRANS_QUEUED)) {
> > +           list_add_tail(&m2m_ctx->queue, &m2m_dev->jobqueue);
> > +           m2m_ctx->job_flags |= TRANS_QUEUED;
> > +   }
> > +   spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
> > +
> > +   v4l2_m2m_try_run(m2m_dev);
> > +}
> > +
> > +/**
> > + * v4l2_m2m_job_finish() - inform the framework that a job has been
> finished
> > + * and have it clean up
> > + *
> > + * Called by a driver to yield back the device after it has finished with
> it.
> > + * Should be called as soon as possible after reaching a state which
> allows
> > + * other instances to take control of the device.
> > + *
> > + * This function has to be called only after device_run() callback has
> been
> > + * called on the driver. To prevent recursion, it should not be called
> directly
> > + * from the device_run() callback though.
> > + */
> > +void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
> > +                    struct v4l2_m2m_ctx *m2m_ctx)
> > +{
> > +   unsigned long flags;
> > +
> > +   spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
> > +   if (!m2m_dev->curr_ctx || m2m_dev->curr_ctx != m2m_ctx) {
> > +           spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> > +           dprintk("Called by an instance not currently running\n");
> > +           return;
> > +   }
> > +
> > +   list_del(&m2m_dev->curr_ctx->queue);
> > +   m2m_dev->curr_ctx->job_flags &= ~(TRANS_QUEUED | TRANS_RUNNING);
> > +   m2m_dev->curr_ctx = NULL;
> > +
> > +   spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> > +
> > +   /* This instance might have more buffers ready, but since we do not
> > +    * allow more than one job on the jobqueue per instance, each has
> > +    * to be scheduled separately after the previous one finishes. */
> > +   v4l2_m2m_try_schedule(m2m_ctx);
> > +   v4l2_m2m_try_run(m2m_dev);
> > +}
> > +EXPORT_SYMBOL(v4l2_m2m_job_finish);
> > +
> > +/**
> > + * v4l2_m2m_reqbufs() - multi-queue-aware REQBUFS multiplexer
> > + */
> > +int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> > +                struct v4l2_requestbuffers *reqbufs)
> > +{
> > +   struct videobuf_queue *vq;
> > +
> > +   vq = v4l2_m2m_get_vq(m2m_ctx, reqbufs->type);
> > +   return videobuf_reqbufs(vq, reqbufs);
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_reqbufs);
> > +
> > +/**
> > + * v4l2_m2m_querybuf() - multi-queue-aware QUERYBUF multiplexer
> > + *
> > + * See v4l2_m2m_mmap() documentation for details.
> > + */
> > +int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> > +                 struct v4l2_buffer *buf)
> > +{
> > +   struct videobuf_queue *vq;
> > +   int ret;
> > +
> > +   vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
> > +   ret = videobuf_querybuf(vq, buf);
> > +
> > +   if (buf->memory == V4L2_MEMORY_MMAP
> > +       && vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> > +           buf->m.offset += DST_QUEUE_OFF_BASE;
> > +   }
> > +
> > +   return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_querybuf);
> > +
> > +/**
> > + * v4l2_m2m_qbuf() - enqueue a source or destination buffer, depending on
> > + * the type
> > + */
> > +int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> > +             struct v4l2_buffer *buf)
> > +{
> > +   struct videobuf_queue *vq;
> > +   int ret;
> > +
> > +   vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
> > +   ret = videobuf_qbuf(vq, buf);
> > +   if (ret)
> > +           return ret;
> > +
> > +   v4l2_m2m_try_schedule(m2m_ctx);
> > +
> > +   return 0;
>
> Simplify:
>
>       ret = videobuf_qbuf(vq, buf);
>       if (!ret)
>               v4l2_m2m_try_schedule(m2m_ctx);
>       return ret;
>
>
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_qbuf);
> > +
> > +/**
> > + * v4l2_m2m_dqbuf() - dequeue a source or destination buffer, depending
> on
> > + * the type
> > + */
> > +int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> > +              struct v4l2_buffer *buf)
> > +{
> > +   struct videobuf_queue *vq;
> > +
> > +   vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
> > +   return videobuf_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
> > +
> > +/**
> > + * v4l2_m2m_streamon() - turn on streaming for a video queue
> > + */
> > +int v4l2_m2m_streamon(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> > +                 enum v4l2_buf_type type)
> > +{
> > +   struct videobuf_queue *vq;
> > +   int ret;
> > +
> > +   vq = v4l2_m2m_get_vq(m2m_ctx, type);
> > +   ret = videobuf_streamon(vq);
> > +   if (ret)
> > +           return ret;
> > +
> > +   v4l2_m2m_try_schedule(m2m_ctx);
>
> Same as above.
>
> > +
> > +   return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_streamon);
> > +
> > +/**
> > + * v4l2_m2m_streamoff() - turn off streaming for a video queue
> > + */
> > +int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> > +                  enum v4l2_buf_type type)
> > +{
> > +   struct videobuf_queue *vq;
> > +
> > +   vq = v4l2_m2m_get_vq(m2m_ctx, type);
> > +
> > +   return videobuf_streamoff(vq);
>
> Shorter:
>
>       return videobuf_streamoff(v4l2_m2m_get_vq(m2m_ctx, type));
>
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_streamoff);
> > +
> > +/**
> > + * v4l2_m2m_poll() - poll replacement, for destination buffers only
> > + *
> > + * Call from driver's poll() function. Will poll the destination queue
> only.
> > + */
> > +unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx
> *m2m_ctx,
> > +                      struct poll_table_struct *wait)
> > +{
> > +   struct videobuf_queue *dst_q;
> > +   struct videobuf_buffer *vb = NULL;
> > +   unsigned int rc = 0;
> > +
> > +   dst_q = v4l2_m2m_get_dst_vq(m2m_ctx);
> > +
> > +   mutex_lock(&dst_q->vb_lock);
> > +
> > +   if (dst_q->streaming) {
> > +           if (!list_empty(&dst_q->stream))
> > +                   vb = list_entry(dst_q->stream.next,
> > +                                   struct videobuf_buffer, stream);
> > +   }
> > +
> > +   if (!vb)
> > +           rc = POLLERR;
> > +
> > +   if (0 == rc) {
> > +           poll_wait(file, &vb->done, wait);
> > +           if (vb->state == VIDEOBUF_DONE || vb->state == VIDEOBUF_ERROR)
> > +                   rc = POLLOUT | POLLRDNORM;
> > +   }
> > +
> > +   mutex_unlock(&dst_q->vb_lock);
>
> Would there be any need for polling for writing?
>
> > +   return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_poll);
> > +
> > +/**
> > + * v4l2_m2m_mmap() - source and destination queues-aware mmap multiplexer
> > + *
> > + * Call from driver's mmap() function. Will handle mmap() for both queues
> > + * seamlessly for videobuffer, which will receive normal per-queue
> offsets and
> > + * proper videobuf queue pointers. The differentiation is made outside
> videobuf
> > + * by adding a predefined offset to buffers from one of the queues and
> > + * subtracting it before passing it back to videobuf. Only drivers (and
> > + * thus applications) receive modified offsets.
> > + */
> > +int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> > +                    struct vm_area_struct *vma)
> > +{
> > +   unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
> > +   struct videobuf_queue *vq;
> > +
> > +   if (offset < DST_QUEUE_OFF_BASE) {
> > +           vq = v4l2_m2m_get_src_vq(m2m_ctx);
> > +   } else {
> > +           vq = v4l2_m2m_get_dst_vq(m2m_ctx);
> > +           vma->vm_pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
> > +   }
> > +
> > +   return videobuf_mmap_mapper(vq, vma);
> > +}
> > +EXPORT_SYMBOL(v4l2_m2m_mmap);
> > +
> > +/**
> > + * v4l2_m2m_init() - initialize per-driver m2m data
> > + *
> > + * Usually called from driver's probe() function.
> > + */
> > +struct v4l2_m2m_dev *v4l2_m2m_init(struct v4l2_m2m_ops *m2m_ops)
> > +{
> > +   struct v4l2_m2m_dev *m2m_dev;
> > +
> > +   if (!m2m_ops)
> > +           return ERR_PTR(-EINVAL);
> > +
> > +   BUG_ON(!m2m_ops->device_run);
> > +   BUG_ON(!m2m_ops->job_abort);
>
> No need to crash. Use WARN_ON and return an error.
>
> Learned something today: I didn't know ERR_PTR existed! Nice.
>
> > +
> > +   m2m_dev = kzalloc(sizeof *m2m_dev, GFP_KERNEL);
> > +   if (!m2m_dev)
> > +           return ERR_PTR(-ENOMEM);
> > +
> > +   m2m_dev->curr_ctx = NULL;
> > +   m2m_dev->m2m_ops = m2m_ops;
> > +   INIT_LIST_HEAD(&m2m_dev->jobqueue);
> > +   spin_lock_init(&m2m_dev->job_spinlock);
> > +
> > +   return m2m_dev;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_init);
> > +
> > +/**
> > + * v4l2_m2m_release() - cleans up and frees a m2m_dev structure
> > + *
> > + * Usually called from driver's remove() function.
> > + */
> > +void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev)
> > +{
> > +   kfree(m2m_dev);
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_release);
>
> Wouldn't it make sense to embed this struct in a filehandle structure?
> Then there is no need to allocate anything, you just need an init function.
>
> I like embedding structures: it's quite clean.
>
> > +
> > +/**
> > + * v4l2_m2m_ctx_init() - allocate and initialize a m2m context
> > + * @priv - driver's instance private data
> > + * @m2m_dev - a previously initialized m2m_dev struct
> > + * @vq_init - a callback for queue type-specific initialization function
> to be
> > + * used for initializing videobuf_queues
> > + *
> > + * Usually called from driver's open() function.
> > + */
> > +struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(void *priv, struct v4l2_m2m_dev
> *m2m_dev,
> > +                   void (*vq_init)(void *priv, struct videobuf_queue *,
> > +                                   enum v4l2_buf_type))
> > +{
> > +   struct v4l2_m2m_ctx *m2m_ctx;
> > +   struct v4l2_m2m_queue_ctx *out_q_ctx;
> > +   struct v4l2_m2m_queue_ctx *cap_q_ctx;
> > +
> > +   if (!vq_init)
> > +           return ERR_PTR(-EINVAL);
> > +
> > +   m2m_ctx = kzalloc(sizeof *m2m_ctx, GFP_KERNEL);
> > +   if (!m2m_ctx)
> > +           return ERR_PTR(-ENOMEM);
> > +
> > +   m2m_ctx->priv = priv;
> > +   m2m_ctx->m2m_dev = m2m_dev;
> > +
> > +   out_q_ctx = get_queue_ctx(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> > +   cap_q_ctx = get_queue_ctx(m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> > +
> > +   INIT_LIST_HEAD(&out_q_ctx->rdy_queue);
> > +   INIT_LIST_HEAD(&cap_q_ctx->rdy_queue);
> > +
> > +   INIT_LIST_HEAD(&m2m_ctx->queue);
> > +
> > +   vq_init(priv, &out_q_ctx->q, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> > +   vq_init(priv, &cap_q_ctx->q, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> > +   out_q_ctx->q.priv_data = cap_q_ctx->q.priv_data = priv;
> > +
> > +   return m2m_ctx;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_init);
> > +
> > +/**
> > + * v4l2_m2m_ctx_release() - release m2m context
> > + *
> > + * Usually called from driver's release() function.
> > + */
> > +void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx)
> > +{
> > +   struct v4l2_m2m_dev *m2m_dev;
> > +   struct videobuf_buffer *vb;
> > +   unsigned long flags;
> > +
> > +   m2m_dev = m2m_ctx->m2m_dev;
> > +
> > +   spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
> > +   if (m2m_ctx->job_flags & TRANS_RUNNING) {
> > +           spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> > +           m2m_dev->m2m_ops->job_abort(m2m_ctx->priv);
> > +           dprintk("m2m_ctx %p running, will wait to complete", m2m_ctx);
> > +           vb = v4l2_m2m_next_dst_buf(m2m_ctx);
> > +           BUG_ON(NULL == vb);
> > +           wait_event(vb->done, vb->state != VIDEOBUF_ACTIVE
> > +                                && vb->state != VIDEOBUF_QUEUED);
> > +   } else if (m2m_ctx->job_flags & TRANS_QUEUED) {
> > +           list_del(&m2m_ctx->queue);
> > +           m2m_ctx->job_flags &= ~(TRANS_QUEUED | TRANS_RUNNING);
> > +           spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> > +           dprintk("m2m_ctx: %p had been on queue and was removed\n",
> > +                   m2m_ctx);
> > +   } else {
> > +           /* Do nothing, was not on queue/running */
> > +           spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> > +   }
> > +
> > +   videobuf_stop(&m2m_ctx->cap_q_ctx.q);
> > +   videobuf_stop(&m2m_ctx->out_q_ctx.q);
> > +
> > +   videobuf_mmap_free(&m2m_ctx->cap_q_ctx.q);
> > +   videobuf_mmap_free(&m2m_ctx->out_q_ctx.q);
> > +
> > +   kfree(m2m_ctx);
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_release);
> > +
> > +/**
> > + * v4l2_m2m_buf_queue() - add a buffer to the proper ready buffers list.
> > + *
> > + * Call from withing buf_queue() videobuf_queue_ops callback.
> > + *
> > + * Locking: Caller holds q->irqlock (taken by videobuf before calling
> buf_queue
> > + * callback in the driver).
> > + */
> > +void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct
> videobuf_queue *vq,
> > +                   struct videobuf_buffer *vb)
> > +{
> > +   struct v4l2_m2m_queue_ctx *q_ctx;
> > +
> > +   q_ctx = get_queue_ctx(m2m_ctx, vq->type);
> > +   if (!q_ctx)
> > +           return;
> > +
> > +   list_add_tail(&vb->queue, &q_ctx->rdy_queue);
> > +   q_ctx->num_rdy++;
> > +
> > +   vb->state = VIDEOBUF_QUEUED;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_buf_queue);
> > +
> > diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
> > new file mode 100644
> > index 0000000..33fe9f3
> > --- /dev/null
> > +++ b/include/media/v4l2-mem2mem.h
> > @@ -0,0 +1,154 @@
> > +/*
> > + * Memory-to-memory device framework for Video for Linux 2.
> > + *
> > + * Helper functions for devices that use memory buffers for both source
> > + * and destination.
> > + *
> > + * Copyright (c) 2009 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <p.osciak@samsung.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> the
> > + * Free Software Foundation; either version 2 of the
> > + * License, or (at your option) any later version
> > + */
> > +
> > +#ifndef _MEDIA_V4L2_MEM2MEM_H
> > +#define _MEDIA_V4L2_MEM2MEM_H
> > +
> > +#include <media/videobuf-core.h>
> > +
> > +/**
> > + * struct v4l2_m2m_ops - mem-to-mem device driver callbacks
> > + * @device_run:    required. Begin the actual job (transaction) inside
> this
> > + *         callback.
> > + *         The job does NOT have to end before this callback returns
> > + *         (and it will be the usual case). When the job finishes,
> > + *         v4l2_m2m_job_finish() has to be called.
> > + * @job_ready:     optional. Should return 0 if the driver does not have a
> job
> > + *         fully prepared to run yet (i.e. it will not be able to finish a
> > + *         transaction without sleeping). If not provided, it will be
> > + *         assumed that one source and one destination buffer are all
> > + *         that is required for the driver to perform one full transaction.
> > + *         This method may not sleep.
> > + * @job_abort:     required. Informs the driver that it has to abort the
> currently
> > + *         running transaction as soon as possible (i.e. as soon as it can
> > + *         stop the device safely; e.g. in the next interrupt handler),
> > + *         even if the transaction would not have been finished by then.
> > + *         After the driver performs the necessary steps, it has to call
> > + *         v4l2_m2m_job_finish() (as if the transaction ended normally).
> > + *         This function does not have to (and will usually not) wait
> > + *         until the device enters a state when it can be stopped.
> > + */
> > +struct v4l2_m2m_ops {
> > +   void (*device_run)(void *priv);
> > +   int (*job_ready)(void *priv);
> > +   void (*job_abort)(void *priv);
> > +};
> > +
> > +struct v4l2_m2m_dev;
> > +
> > +struct v4l2_m2m_queue_ctx {
> > +/* private: internal use only */
> > +   struct videobuf_queue   q;
> > +
> > +   /* Base value for offsets of mmaped buffers on this queue */
> > +   unsigned long           offset_base;
> > +
> > +   /* Queue for buffers ready to be processed as soon as this
> > +    * instance receives access to the device */
> > +   struct list_head        rdy_queue;
> > +   u8                      num_rdy;
> > +};
> > +
> > +struct v4l2_m2m_ctx {
> > +/* private: internal use only */
> > +   struct v4l2_m2m_dev             *m2m_dev;
> > +
> > +   /* Capture (output to memory) queue context */
> > +   struct v4l2_m2m_queue_ctx       cap_q_ctx;
> > +
> > +   /* Output (input from memory) queue context */
> > +   struct v4l2_m2m_queue_ctx       out_q_ctx;
> > +
> > +   /* For device job queue */
> > +   struct list_head                queue;
> > +   unsigned long                   job_flags;
> > +
> > +   /* Instance private data */
> > +   void                            *priv;
> > +};
> > +
> > +void *v4l2_m2m_get_curr_priv(struct v4l2_m2m_dev *m2m_dev);
> > +
> > +struct videobuf_queue *v4l2_m2m_get_src_vq(struct v4l2_m2m_ctx *m2m_ctx);
> > +struct videobuf_queue *v4l2_m2m_get_dst_vq(struct v4l2_m2m_ctx *m2m_ctx);
> > +struct videobuf_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
> > +                                  enum v4l2_buf_type type);
> > +
> > +void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
> > +                    struct v4l2_m2m_ctx *m2m_ctx);
> > +
> > +void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx);
> > +void *v4l2_m2m_next_dst_buf(struct v4l2_m2m_ctx *m2m_ctx);
> > +
> > +void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx);
> > +void *v4l2_m2m_dst_buf_remove(struct v4l2_m2m_ctx *m2m_ctx);
> > +
> > +
> > +int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> > +                struct v4l2_requestbuffers *reqbufs);
> > +
> > +int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> > +                 struct v4l2_buffer *buf);
> > +
> > +int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> > +             struct v4l2_buffer *buf);
> > +int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> > +              struct v4l2_buffer *buf);
> > +
> > +int v4l2_m2m_streamon(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> > +                 enum v4l2_buf_type type);
> > +int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> > +                  enum v4l2_buf_type type);
> > +
> > +unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx
> *m2m_ctx,
> > +                      struct poll_table_struct *wait);
> > +
> > +int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> > +             struct vm_area_struct *vma);
> > +
> > +struct v4l2_m2m_dev *v4l2_m2m_init(struct v4l2_m2m_ops *m2m_ops);
> > +void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev);
> > +
> > +struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(void *priv, struct v4l2_m2m_dev
> *m2m_dev,
> > +                   void (*vq_init)(void *priv, struct videobuf_queue *,
> > +                                   enum v4l2_buf_type));
> > +void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx);
> > +
> > +void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct
> videobuf_queue *vq,
> > +                   struct videobuf_buffer *vb);
> > +
> > +/**
> > + * v4l2_m2m_num_src_bufs_ready() - return the number of source buffers
> ready for
> > + * use
> > + */
> > +static inline
> > +unsigned int v4l2_m2m_num_src_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
> > +{
> > +   return m2m_ctx->cap_q_ctx.num_rdy;
> > +}
> > +
> > +/**
> > + * v4l2_m2m_num_src_bufs_ready() - return the number of destination
> buffers
> > + * ready for use
> > + */
> > +static inline
> > +unsigned int v4l2_m2m_num_dst_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
> > +{
> > +   return m2m_ctx->out_q_ctx.num_rdy;
> > +}
> > +
> > +#endif /* _MEDIA_V4L2_MEM2MEM_H */
> > +
> >
>
> Regards,
>
>       Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
