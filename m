Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:43832 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751096AbeCIIaz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 03:30:55 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>
Subject: [PATCH 2/2] media: v4l2-core: get rid of videobuf-dvb
Date: Fri,  9 Mar 2018 05:30:48 -0300
Message-Id: <149554ed3a9b0b9ace8f34d49b22676560c69e0b.1520584203.git.mchehab@s-opensource.com>
In-Reply-To: <dd7ed7485c5c2bdff0aa157579ed578e19e8f178.1520584203.git.mchehab@s-opensource.com>
References: <dd7ed7485c5c2bdff0aa157579ed578e19e8f178.1520584203.git.mchehab@s-opensource.com>
In-Reply-To: <dd7ed7485c5c2bdff0aa157579ed578e19e8f178.1520584203.git.mchehab@s-opensource.com>
References: <dd7ed7485c5c2bdff0aa157579ed578e19e8f178.1520584203.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Videobuf has been replaced by videobuf2. Now, no drivers use
the videobuf-dvb helper module anymore. So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/Kconfig        |   4 -
 drivers/media/v4l2-core/Makefile       |   1 -
 drivers/media/v4l2-core/videobuf-dvb.c | 398 ---------------------------------
 include/media/videobuf-dvb.h           |  59 -----
 4 files changed, 462 deletions(-)
 delete mode 100644 drivers/media/v4l2-core/videobuf-dvb.c
 delete mode 100644 include/media/videobuf-dvb.h

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 8e37e7c5e0f7..2a56f37f186b 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -76,7 +76,3 @@ config VIDEOBUF_DMA_CONTIG
 	tristate
 	depends on HAS_DMA
 	select VIDEOBUF_GEN
-
-config VIDEOBUF_DVB
-	tristate
-	select VIDEOBUF_GEN
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 7df54582e956..9ee57e1efefe 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -31,7 +31,6 @@ obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
 obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
 obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
 obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
-obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 ccflags-y += -I$(srctree)/drivers/media/tuners
diff --git a/drivers/media/v4l2-core/videobuf-dvb.c b/drivers/media/v4l2-core/videobuf-dvb.c
deleted file mode 100644
index b7efa4516d36..000000000000
--- a/drivers/media/v4l2-core/videobuf-dvb.c
+++ /dev/null
@@ -1,398 +0,0 @@
-/*
- *
- * some helper function for simple DVB cards which simply DMA the
- * complete transport stream and let the computer sort everything else
- * (i.e. we are using the software demux, ...).  Also uses the
- * video-buf to manage DMA buffers.
- *
- * (c) 2004 Gerd Knorr <kraxel@bytesex.org> [SUSE Labs]
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/device.h>
-#include <linux/fs.h>
-#include <linux/kthread.h>
-#include <linux/file.h>
-#include <linux/slab.h>
-
-#include <linux/freezer.h>
-
-#include <media/videobuf-core.h>
-#include <media/videobuf-dvb.h>
-
-/* ------------------------------------------------------------------ */
-
-MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
-MODULE_LICENSE("GPL");
-
-static unsigned int debug;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug,"enable debug messages");
-
-#define dprintk(fmt, arg...)	if (debug)			\
-	printk(KERN_DEBUG "%s/dvb: " fmt, dvb->name , ## arg)
-
-/* ------------------------------------------------------------------ */
-
-static int videobuf_dvb_thread(void *data)
-{
-	struct videobuf_dvb *dvb = data;
-	struct videobuf_buffer *buf;
-	unsigned long flags;
-	void *outp;
-
-	dprintk("dvb thread started\n");
-	set_freezable();
-	videobuf_read_start(&dvb->dvbq);
-
-	for (;;) {
-		/* fetch next buffer */
-		buf = list_entry(dvb->dvbq.stream.next,
-				 struct videobuf_buffer, stream);
-		list_del(&buf->stream);
-		videobuf_waiton(&dvb->dvbq, buf, 0, 1);
-
-		/* no more feeds left or stop_feed() asked us to quit */
-		if (0 == dvb->nfeeds)
-			break;
-		if (kthread_should_stop())
-			break;
-		try_to_freeze();
-
-		/* feed buffer data to demux */
-		outp = videobuf_queue_to_vaddr(&dvb->dvbq, buf);
-
-		if (buf->state == VIDEOBUF_DONE)
-			dvb_dmx_swfilter(&dvb->demux, outp,
-					 buf->size);
-
-		/* requeue buffer */
-		list_add_tail(&buf->stream,&dvb->dvbq.stream);
-		spin_lock_irqsave(dvb->dvbq.irqlock,flags);
-		dvb->dvbq.ops->buf_queue(&dvb->dvbq,buf);
-		spin_unlock_irqrestore(dvb->dvbq.irqlock,flags);
-	}
-
-	videobuf_read_stop(&dvb->dvbq);
-	dprintk("dvb thread stopped\n");
-
-	/* Hmm, linux becomes *very* unhappy without this ... */
-	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule();
-	}
-	return 0;
-}
-
-static int videobuf_dvb_start_feed(struct dvb_demux_feed *feed)
-{
-	struct dvb_demux *demux  = feed->demux;
-	struct videobuf_dvb *dvb = demux->priv;
-	int rc;
-
-	if (!demux->dmx.frontend)
-		return -EINVAL;
-
-	mutex_lock(&dvb->lock);
-	dvb->nfeeds++;
-	rc = dvb->nfeeds;
-
-	if (NULL != dvb->thread)
-		goto out;
-	dvb->thread = kthread_run(videobuf_dvb_thread,
-				  dvb, "%s dvb", dvb->name);
-	if (IS_ERR(dvb->thread)) {
-		rc = PTR_ERR(dvb->thread);
-		dvb->thread = NULL;
-	}
-
-out:
-	mutex_unlock(&dvb->lock);
-	return rc;
-}
-
-static int videobuf_dvb_stop_feed(struct dvb_demux_feed *feed)
-{
-	struct dvb_demux *demux  = feed->demux;
-	struct videobuf_dvb *dvb = demux->priv;
-	int err = 0;
-
-	mutex_lock(&dvb->lock);
-	dvb->nfeeds--;
-	if (0 == dvb->nfeeds  &&  NULL != dvb->thread) {
-		err = kthread_stop(dvb->thread);
-		dvb->thread = NULL;
-	}
-	mutex_unlock(&dvb->lock);
-	return err;
-}
-
-static int videobuf_dvb_register_adapter(struct videobuf_dvb_frontends *fe,
-			  struct module *module,
-			  void *adapter_priv,
-			  struct device *device,
-			  char *adapter_name,
-			  short *adapter_nr,
-			  int mfe_shared)
-{
-	int result;
-
-	mutex_init(&fe->lock);
-
-	/* register adapter */
-	result = dvb_register_adapter(&fe->adapter, adapter_name, module,
-		device, adapter_nr);
-	if (result < 0) {
-		printk(KERN_WARNING "%s: dvb_register_adapter failed (errno = %d)\n",
-		       adapter_name, result);
-	}
-	fe->adapter.priv = adapter_priv;
-	fe->adapter.mfe_shared = mfe_shared;
-
-	return result;
-}
-
-static int videobuf_dvb_register_frontend(struct dvb_adapter *adapter,
-	struct videobuf_dvb *dvb)
-{
-	int result;
-
-	/* register frontend */
-	result = dvb_register_frontend(adapter, dvb->frontend);
-	if (result < 0) {
-		printk(KERN_WARNING "%s: dvb_register_frontend failed (errno = %d)\n",
-		       dvb->name, result);
-		goto fail_frontend;
-	}
-
-	/* register demux stuff */
-	dvb->demux.dmx.capabilities =
-		DMX_TS_FILTERING | DMX_SECTION_FILTERING |
-		DMX_MEMORY_BASED_FILTERING;
-	dvb->demux.priv       = dvb;
-	dvb->demux.filternum  = 256;
-	dvb->demux.feednum    = 256;
-	dvb->demux.start_feed = videobuf_dvb_start_feed;
-	dvb->demux.stop_feed  = videobuf_dvb_stop_feed;
-	result = dvb_dmx_init(&dvb->demux);
-	if (result < 0) {
-		printk(KERN_WARNING "%s: dvb_dmx_init failed (errno = %d)\n",
-		       dvb->name, result);
-		goto fail_dmx;
-	}
-
-	dvb->dmxdev.filternum    = 256;
-	dvb->dmxdev.demux        = &dvb->demux.dmx;
-	dvb->dmxdev.capabilities = 0;
-	result = dvb_dmxdev_init(&dvb->dmxdev, adapter);
-
-	if (result < 0) {
-		printk(KERN_WARNING "%s: dvb_dmxdev_init failed (errno = %d)\n",
-		       dvb->name, result);
-		goto fail_dmxdev;
-	}
-
-	dvb->fe_hw.source = DMX_FRONTEND_0;
-	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_hw);
-	if (result < 0) {
-		printk(KERN_WARNING "%s: add_frontend failed (DMX_FRONTEND_0, errno = %d)\n",
-		       dvb->name, result);
-		goto fail_fe_hw;
-	}
-
-	dvb->fe_mem.source = DMX_MEMORY_FE;
-	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_mem);
-	if (result < 0) {
-		printk(KERN_WARNING "%s: add_frontend failed (DMX_MEMORY_FE, errno = %d)\n",
-		       dvb->name, result);
-		goto fail_fe_mem;
-	}
-
-	result = dvb->demux.dmx.connect_frontend(&dvb->demux.dmx, &dvb->fe_hw);
-	if (result < 0) {
-		printk(KERN_WARNING "%s: connect_frontend failed (errno = %d)\n",
-		       dvb->name, result);
-		goto fail_fe_conn;
-	}
-
-	/* register network adapter */
-	result = dvb_net_init(adapter, &dvb->net, &dvb->demux.dmx);
-	if (result < 0) {
-		printk(KERN_WARNING "%s: dvb_net_init failed (errno = %d)\n",
-		       dvb->name, result);
-		goto fail_fe_conn;
-	}
-	return 0;
-
-fail_fe_conn:
-	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
-fail_fe_mem:
-	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
-fail_fe_hw:
-	dvb_dmxdev_release(&dvb->dmxdev);
-fail_dmxdev:
-	dvb_dmx_release(&dvb->demux);
-fail_dmx:
-	dvb_unregister_frontend(dvb->frontend);
-fail_frontend:
-	dvb_frontend_detach(dvb->frontend);
-	dvb->frontend = NULL;
-
-	return result;
-}
-
-/* ------------------------------------------------------------------ */
-/* Register a single adapter and one or more frontends */
-int videobuf_dvb_register_bus(struct videobuf_dvb_frontends *f,
-			  struct module *module,
-			  void *adapter_priv,
-			  struct device *device,
-			  short *adapter_nr,
-			  int mfe_shared)
-{
-	struct list_head *list, *q;
-	struct videobuf_dvb_frontend *fe;
-	int res;
-
-	fe = videobuf_dvb_get_frontend(f, 1);
-	if (!fe) {
-		printk(KERN_WARNING "Unable to register the adapter which has no frontends\n");
-		return -EINVAL;
-	}
-
-	/* Bring up the adapter */
-	res = videobuf_dvb_register_adapter(f, module, adapter_priv, device,
-		fe->dvb.name, adapter_nr, mfe_shared);
-	if (res < 0) {
-		printk(KERN_WARNING "videobuf_dvb_register_adapter failed (errno = %d)\n", res);
-		return res;
-	}
-
-	/* Attach all of the frontends to the adapter */
-	mutex_lock(&f->lock);
-	list_for_each_safe(list, q, &f->felist) {
-		fe = list_entry(list, struct videobuf_dvb_frontend, felist);
-		res = videobuf_dvb_register_frontend(&f->adapter, &fe->dvb);
-		if (res < 0) {
-			printk(KERN_WARNING "%s: videobuf_dvb_register_frontend failed (errno = %d)\n",
-				fe->dvb.name, res);
-			goto err;
-		}
-	}
-	mutex_unlock(&f->lock);
-	return 0;
-
-err:
-	mutex_unlock(&f->lock);
-	videobuf_dvb_unregister_bus(f);
-	return res;
-}
-EXPORT_SYMBOL(videobuf_dvb_register_bus);
-
-void videobuf_dvb_unregister_bus(struct videobuf_dvb_frontends *f)
-{
-	videobuf_dvb_dealloc_frontends(f);
-
-	dvb_unregister_adapter(&f->adapter);
-}
-EXPORT_SYMBOL(videobuf_dvb_unregister_bus);
-
-struct videobuf_dvb_frontend *videobuf_dvb_get_frontend(
-	struct videobuf_dvb_frontends *f, int id)
-{
-	struct list_head *list, *q;
-	struct videobuf_dvb_frontend *fe, *ret = NULL;
-
-	mutex_lock(&f->lock);
-
-	list_for_each_safe(list, q, &f->felist) {
-		fe = list_entry(list, struct videobuf_dvb_frontend, felist);
-		if (fe->id == id) {
-			ret = fe;
-			break;
-		}
-	}
-
-	mutex_unlock(&f->lock);
-
-	return ret;
-}
-EXPORT_SYMBOL(videobuf_dvb_get_frontend);
-
-int videobuf_dvb_find_frontend(struct videobuf_dvb_frontends *f,
-	struct dvb_frontend *p)
-{
-	struct list_head *list, *q;
-	struct videobuf_dvb_frontend *fe = NULL;
-	int ret = 0;
-
-	mutex_lock(&f->lock);
-
-	list_for_each_safe(list, q, &f->felist) {
-		fe = list_entry(list, struct videobuf_dvb_frontend, felist);
-		if (fe->dvb.frontend == p) {
-			ret = fe->id;
-			break;
-		}
-	}
-
-	mutex_unlock(&f->lock);
-
-	return ret;
-}
-EXPORT_SYMBOL(videobuf_dvb_find_frontend);
-
-struct videobuf_dvb_frontend *videobuf_dvb_alloc_frontend(
-	struct videobuf_dvb_frontends *f, int id)
-{
-	struct videobuf_dvb_frontend *fe;
-
-	fe = kzalloc(sizeof(struct videobuf_dvb_frontend), GFP_KERNEL);
-	if (fe == NULL)
-		goto fail_alloc;
-
-	fe->id = id;
-	mutex_init(&fe->dvb.lock);
-
-	mutex_lock(&f->lock);
-	list_add_tail(&fe->felist, &f->felist);
-	mutex_unlock(&f->lock);
-
-fail_alloc:
-	return fe;
-}
-EXPORT_SYMBOL(videobuf_dvb_alloc_frontend);
-
-void videobuf_dvb_dealloc_frontends(struct videobuf_dvb_frontends *f)
-{
-	struct list_head *list, *q;
-	struct videobuf_dvb_frontend *fe;
-
-	mutex_lock(&f->lock);
-	list_for_each_safe(list, q, &f->felist) {
-		fe = list_entry(list, struct videobuf_dvb_frontend, felist);
-		if (fe->dvb.net.dvbdev) {
-			dvb_net_release(&fe->dvb.net);
-			fe->dvb.demux.dmx.remove_frontend(&fe->dvb.demux.dmx,
-				&fe->dvb.fe_mem);
-			fe->dvb.demux.dmx.remove_frontend(&fe->dvb.demux.dmx,
-				&fe->dvb.fe_hw);
-			dvb_dmxdev_release(&fe->dvb.dmxdev);
-			dvb_dmx_release(&fe->dvb.demux);
-			dvb_unregister_frontend(fe->dvb.frontend);
-		}
-		if (fe->dvb.frontend)
-			/* always allocated, may have been reset */
-			dvb_frontend_detach(fe->dvb.frontend);
-		list_del(list); /* remove list entry */
-		kfree(fe);	/* free frontend allocation */
-	}
-	mutex_unlock(&f->lock);
-}
-EXPORT_SYMBOL(videobuf_dvb_dealloc_frontends);
diff --git a/include/media/videobuf-dvb.h b/include/media/videobuf-dvb.h
deleted file mode 100644
index c9c81990a56c..000000000000
--- a/include/media/videobuf-dvb.h
+++ /dev/null
@@ -1,59 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#include <media/dvbdev.h>
-#include <media/dmxdev.h>
-#include <media/dvb_demux.h>
-#include <media/dvb_net.h>
-#include <media/dvb_frontend.h>
-
-#ifndef _VIDEOBUF_DVB_H_
-#define	_VIDEOBUF_DVB_H_
-
-struct videobuf_dvb {
-	/* filling that the job of the driver */
-	char                       *name;
-	struct dvb_frontend        *frontend;
-	struct videobuf_queue      dvbq;
-
-	/* video-buf-dvb state info */
-	struct mutex               lock;
-	struct task_struct         *thread;
-	int                        nfeeds;
-
-	/* videobuf_dvb_(un)register manges this */
-	struct dvb_demux           demux;
-	struct dmxdev              dmxdev;
-	struct dmx_frontend        fe_hw;
-	struct dmx_frontend        fe_mem;
-	struct dvb_net             net;
-};
-
-struct videobuf_dvb_frontend {
-	struct list_head felist;
-	int id;
-	struct videobuf_dvb dvb;
-};
-
-struct videobuf_dvb_frontends {
-	struct list_head felist;
-	struct mutex lock;
-	struct dvb_adapter adapter;
-	int active_fe_id; /* Indicates which frontend in the felist is in use */
-	int gate; /* Frontend with gate control 0=!MFE,1=fe0,2=fe1 etc */
-};
-
-int videobuf_dvb_register_bus(struct videobuf_dvb_frontends *f,
-			  struct module *module,
-			  void *adapter_priv,
-			  struct device *device,
-			  short *adapter_nr,
-			  int mfe_shared);
-
-void videobuf_dvb_unregister_bus(struct videobuf_dvb_frontends *f);
-
-struct videobuf_dvb_frontend * videobuf_dvb_alloc_frontend(struct videobuf_dvb_frontends *f, int id);
-void videobuf_dvb_dealloc_frontends(struct videobuf_dvb_frontends *f);
-
-struct videobuf_dvb_frontend * videobuf_dvb_get_frontend(struct videobuf_dvb_frontends *f, int id);
-int videobuf_dvb_find_frontend(struct videobuf_dvb_frontends *f, struct dvb_frontend *p);
-
-#endif			/* _VIDEOBUF_DVB_H_ */
-- 
2.14.3
