Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3797 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab3K2J7V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 04:59:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	laurent.pinchart@ideasonboard.com, awalls@md.metrocast.net,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 8/9] vb2: Add videobuf2-dvb support.
Date: Fri, 29 Nov 2013 10:58:43 +0100
Message-Id: <d713b4025dad9b3285f90755c397770f163cffe5.1385719098.git.hans.verkuil@cisco.com>
In-Reply-To: <1385719124-11338-1-git-send-email-hverkuil@xs4all.nl>
References: <1385719124-11338-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f9d4d16ac6acde33e1c5c569cea9ae5886e7a1d7.1385719098.git.hans.verkuil@cisco.com>
References: <f9d4d16ac6acde33e1c5c569cea9ae5886e7a1d7.1385719098.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

With the new vb2_thread_start/stop core code it is very easy to implement
videobuf2-dvb. This should simplify coverting existing videobuf drivers to
vb2.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/Kconfig         |   4 +
 drivers/media/v4l2-core/Makefile        |   1 +
 drivers/media/v4l2-core/videobuf2-dvb.c | 336 ++++++++++++++++++++++++++++++++
 include/media/videobuf2-dvb.h           |  58 ++++++
 4 files changed, 399 insertions(+)
 create mode 100644 drivers/media/v4l2-core/videobuf2-dvb.c
 create mode 100644 include/media/videobuf2-dvb.h

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 8c05565..8cc76da 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -84,6 +84,10 @@ config VIDEOBUF2_DMA_SG
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
 
+config VIDEOBUF2_DVB
+	tristate
+	select VIDEOBUF2_CORE
+
 config VIDEO_V4L2_INT_DEVICE
 	tristate "V4L2 int device (DEPRECATED)"
 	depends on VIDEO_V4L2
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 1a85eee..c73ac0d 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
 obj-$(CONFIG_VIDEOBUF2_DMA_SG) += videobuf2-dma-sg.o
+obj-$(CONFIG_VIDEOBUF2_DVB) += videobuf2-dvb.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/v4l2-core/videobuf2-dvb.c b/drivers/media/v4l2-core/videobuf2-dvb.c
new file mode 100644
index 0000000..d092698
--- /dev/null
+++ b/drivers/media/v4l2-core/videobuf2-dvb.c
@@ -0,0 +1,336 @@
+/*
+ *
+ * some helper function for simple DVB cards which simply DMA the
+ * complete transport stream and let the computer sort everything else
+ * (i.e. we are using the software demux, ...).  Also uses the
+ * video-buf to manage DMA buffers.
+ *
+ * (c) 2004 Gerd Knorr <kraxel@bytesex.org> [SUSE Labs]
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+
+#include <media/videobuf2-dvb.h>
+
+/* ------------------------------------------------------------------ */
+
+MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
+MODULE_LICENSE("GPL");
+
+/* ------------------------------------------------------------------ */
+
+static int dvb_fnc(struct vb2_buffer *vb, void *priv)
+{
+	struct vb2_dvb *dvb = priv;
+
+	dvb_dmx_swfilter(&dvb->demux, vb2_plane_vaddr(vb, 0),
+				      vb2_get_plane_payload(vb, 0));
+	return 0;
+}
+
+static int vb2_dvb_start_feed(struct dvb_demux_feed *feed)
+{
+	struct dvb_demux *demux = feed->demux;
+	struct vb2_dvb *dvb = demux->priv;
+	int rc = 0;
+
+	if (!demux->dmx.frontend)
+		return -EINVAL;
+
+	mutex_lock(&dvb->lock);
+	dvb->nfeeds++;
+
+	if (!dvb->dvbq.threadio) {
+		rc = vb2_thread_start(&dvb->dvbq, dvb_fnc, dvb, dvb->name);
+		if (rc)
+			dvb->nfeeds--;
+	}
+	if (!rc)
+		rc = dvb->nfeeds;
+	mutex_unlock(&dvb->lock);
+	return rc;
+}
+
+static int vb2_dvb_stop_feed(struct dvb_demux_feed *feed)
+{
+	struct dvb_demux *demux = feed->demux;
+	struct vb2_dvb *dvb = demux->priv;
+	int err = 0;
+
+	mutex_lock(&dvb->lock);
+	dvb->nfeeds--;
+	if (0 == dvb->nfeeds)
+		err = vb2_thread_stop(&dvb->dvbq);
+	mutex_unlock(&dvb->lock);
+	return err;
+}
+
+static int vb2_dvb_register_adapter(struct vb2_dvb_frontends *fe,
+			  struct module *module,
+			  void *adapter_priv,
+			  struct device *device,
+			  char *adapter_name,
+			  short *adapter_nr,
+			  int mfe_shared)
+{
+	int result;
+
+	mutex_init(&fe->lock);
+
+	/* register adapter */
+	result = dvb_register_adapter(&fe->adapter, adapter_name, module,
+		device, adapter_nr);
+	if (result < 0) {
+		pr_warn("%s: dvb_register_adapter failed (errno = %d)\n",
+		       adapter_name, result);
+	}
+	fe->adapter.priv = adapter_priv;
+	fe->adapter.mfe_shared = mfe_shared;
+
+	return result;
+}
+
+static int vb2_dvb_register_frontend(struct dvb_adapter *adapter,
+	struct vb2_dvb *dvb)
+{
+	int result;
+
+	/* register frontend */
+	result = dvb_register_frontend(adapter, dvb->frontend);
+	if (result < 0) {
+		pr_warn("%s: dvb_register_frontend failed (errno = %d)\n",
+		       dvb->name, result);
+		goto fail_frontend;
+	}
+
+	/* register demux stuff */
+	dvb->demux.dmx.capabilities =
+		DMX_TS_FILTERING | DMX_SECTION_FILTERING |
+		DMX_MEMORY_BASED_FILTERING;
+	dvb->demux.priv       = dvb;
+	dvb->demux.filternum  = 256;
+	dvb->demux.feednum    = 256;
+	dvb->demux.start_feed = vb2_dvb_start_feed;
+	dvb->demux.stop_feed  = vb2_dvb_stop_feed;
+	result = dvb_dmx_init(&dvb->demux);
+	if (result < 0) {
+		pr_warn("%s: dvb_dmx_init failed (errno = %d)\n",
+		       dvb->name, result);
+		goto fail_dmx;
+	}
+
+	dvb->dmxdev.filternum    = 256;
+	dvb->dmxdev.demux        = &dvb->demux.dmx;
+	dvb->dmxdev.capabilities = 0;
+	result = dvb_dmxdev_init(&dvb->dmxdev, adapter);
+
+	if (result < 0) {
+		pr_warn("%s: dvb_dmxdev_init failed (errno = %d)\n",
+		       dvb->name, result);
+		goto fail_dmxdev;
+	}
+
+	dvb->fe_hw.source = DMX_FRONTEND_0;
+	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_hw);
+	if (result < 0) {
+		pr_warn("%s: add_frontend failed (DMX_FRONTEND_0, errno = %d)\n",
+		       dvb->name, result);
+		goto fail_fe_hw;
+	}
+
+	dvb->fe_mem.source = DMX_MEMORY_FE;
+	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_mem);
+	if (result < 0) {
+		pr_warn("%s: add_frontend failed (DMX_MEMORY_FE, errno = %d)\n",
+		       dvb->name, result);
+		goto fail_fe_mem;
+	}
+
+	result = dvb->demux.dmx.connect_frontend(&dvb->demux.dmx, &dvb->fe_hw);
+	if (result < 0) {
+		pr_warn("%s: connect_frontend failed (errno = %d)\n",
+		       dvb->name, result);
+		goto fail_fe_conn;
+	}
+
+	/* register network adapter */
+	result = dvb_net_init(adapter, &dvb->net, &dvb->demux.dmx);
+	if (result < 0) {
+		pr_warn("%s: dvb_net_init failed (errno = %d)\n",
+		       dvb->name, result);
+		goto fail_fe_conn;
+	}
+	return 0;
+
+fail_fe_conn:
+	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
+fail_fe_mem:
+	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
+fail_fe_hw:
+	dvb_dmxdev_release(&dvb->dmxdev);
+fail_dmxdev:
+	dvb_dmx_release(&dvb->demux);
+fail_dmx:
+	dvb_unregister_frontend(dvb->frontend);
+fail_frontend:
+	dvb_frontend_detach(dvb->frontend);
+	dvb->frontend = NULL;
+
+	return result;
+}
+
+/* ------------------------------------------------------------------ */
+/* Register a single adapter and one or more frontends */
+int vb2_dvb_register_bus(struct vb2_dvb_frontends *f,
+			 struct module *module,
+			 void *adapter_priv,
+			 struct device *device,
+			 short *adapter_nr,
+			 int mfe_shared)
+{
+	struct list_head *list, *q;
+	struct vb2_dvb_frontend *fe;
+	int res;
+
+	fe = vb2_dvb_get_frontend(f, 1);
+	if (!fe) {
+		pr_warn("Unable to register the adapter which has no frontends\n");
+		return -EINVAL;
+	}
+
+	/* Bring up the adapter */
+	res = vb2_dvb_register_adapter(f, module, adapter_priv, device,
+		fe->dvb.name, adapter_nr, mfe_shared);
+	if (res < 0) {
+		pr_warn("vb2_dvb_register_adapter failed (errno = %d)\n", res);
+		return res;
+	}
+
+	/* Attach all of the frontends to the adapter */
+	mutex_lock(&f->lock);
+	list_for_each_safe(list, q, &f->felist) {
+		fe = list_entry(list, struct vb2_dvb_frontend, felist);
+		res = vb2_dvb_register_frontend(&f->adapter, &fe->dvb);
+		if (res < 0) {
+			pr_warn("%s: vb2_dvb_register_frontend failed (errno = %d)\n",
+				fe->dvb.name, res);
+			goto err;
+		}
+	}
+	mutex_unlock(&f->lock);
+	return 0;
+
+err:
+	mutex_unlock(&f->lock);
+	vb2_dvb_unregister_bus(f);
+	return res;
+}
+EXPORT_SYMBOL(vb2_dvb_register_bus);
+
+void vb2_dvb_unregister_bus(struct vb2_dvb_frontends *f)
+{
+	vb2_dvb_dealloc_frontends(f);
+
+	dvb_unregister_adapter(&f->adapter);
+}
+EXPORT_SYMBOL(vb2_dvb_unregister_bus);
+
+struct vb2_dvb_frontend *vb2_dvb_get_frontend(
+	struct vb2_dvb_frontends *f, int id)
+{
+	struct list_head *list, *q;
+	struct vb2_dvb_frontend *fe, *ret = NULL;
+
+	mutex_lock(&f->lock);
+
+	list_for_each_safe(list, q, &f->felist) {
+		fe = list_entry(list, struct vb2_dvb_frontend, felist);
+		if (fe->id == id) {
+			ret = fe;
+			break;
+		}
+	}
+
+	mutex_unlock(&f->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(vb2_dvb_get_frontend);
+
+int vb2_dvb_find_frontend(struct vb2_dvb_frontends *f,
+	struct dvb_frontend *p)
+{
+	struct list_head *list, *q;
+	struct vb2_dvb_frontend *fe = NULL;
+	int ret = 0;
+
+	mutex_lock(&f->lock);
+
+	list_for_each_safe(list, q, &f->felist) {
+		fe = list_entry(list, struct vb2_dvb_frontend, felist);
+		if (fe->dvb.frontend == p) {
+			ret = fe->id;
+			break;
+		}
+	}
+
+	mutex_unlock(&f->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(vb2_dvb_find_frontend);
+
+struct vb2_dvb_frontend *vb2_dvb_alloc_frontend(
+	struct vb2_dvb_frontends *f, int id)
+{
+	struct vb2_dvb_frontend *fe;
+
+	fe = kzalloc(sizeof(struct vb2_dvb_frontend), GFP_KERNEL);
+	if (fe == NULL)
+		return NULL;
+
+	fe->id = id;
+	mutex_init(&fe->dvb.lock);
+
+	mutex_lock(&f->lock);
+	list_add_tail(&fe->felist, &f->felist);
+	mutex_unlock(&f->lock);
+	return fe;
+}
+EXPORT_SYMBOL(vb2_dvb_alloc_frontend);
+
+void vb2_dvb_dealloc_frontends(struct vb2_dvb_frontends *f)
+{
+	struct list_head *list, *q;
+	struct vb2_dvb_frontend *fe;
+
+	mutex_lock(&f->lock);
+	list_for_each_safe(list, q, &f->felist) {
+		fe = list_entry(list, struct vb2_dvb_frontend, felist);
+		if (fe->dvb.net.dvbdev) {
+			dvb_net_release(&fe->dvb.net);
+			fe->dvb.demux.dmx.remove_frontend(&fe->dvb.demux.dmx,
+				&fe->dvb.fe_mem);
+			fe->dvb.demux.dmx.remove_frontend(&fe->dvb.demux.dmx,
+				&fe->dvb.fe_hw);
+			dvb_dmxdev_release(&fe->dvb.dmxdev);
+			dvb_dmx_release(&fe->dvb.demux);
+			dvb_unregister_frontend(fe->dvb.frontend);
+		}
+		if (fe->dvb.frontend)
+			/* always allocated, may have been reset */
+			dvb_frontend_detach(fe->dvb.frontend);
+		list_del(list); /* remove list entry */
+		kfree(fe);	/* free frontend allocation */
+	}
+	mutex_unlock(&f->lock);
+}
+EXPORT_SYMBOL(vb2_dvb_dealloc_frontends);
diff --git a/include/media/videobuf2-dvb.h b/include/media/videobuf2-dvb.h
new file mode 100644
index 0000000..8f61456
--- /dev/null
+++ b/include/media/videobuf2-dvb.h
@@ -0,0 +1,58 @@
+#ifndef _VIDEOBUF2_DVB_H_
+#define	_VIDEOBUF2_DVB_H_
+
+#include <dvbdev.h>
+#include <dmxdev.h>
+#include <dvb_demux.h>
+#include <dvb_net.h>
+#include <dvb_frontend.h>
+#include <media/videobuf2-core.h>
+
+struct vb2_dvb {
+	/* filling that the job of the driver */
+	char			*name;
+	struct dvb_frontend	*frontend;
+	struct vb2_queue	dvbq;
+
+	/* video-buf-dvb state info */
+	struct mutex		lock;
+	int			nfeeds;
+
+	/* vb2_dvb_(un)register manages this */
+	struct dvb_demux	demux;
+	struct dmxdev		dmxdev;
+	struct dmx_frontend	fe_hw;
+	struct dmx_frontend	fe_mem;
+	struct dvb_net		net;
+};
+
+struct vb2_dvb_frontend {
+	struct list_head felist;
+	int id;
+	struct vb2_dvb dvb;
+};
+
+struct vb2_dvb_frontends {
+	struct list_head felist;
+	struct mutex lock;
+	struct dvb_adapter adapter;
+	int active_fe_id; /* Indicates which frontend in the felist is in use */
+	int gate; /* Frontend with gate control 0=!MFE,1=fe0,2=fe1 etc */
+};
+
+int vb2_dvb_register_bus(struct vb2_dvb_frontends *f,
+			 struct module *module,
+			 void *adapter_priv,
+			 struct device *device,
+			 short *adapter_nr,
+			 int mfe_shared);
+
+void vb2_dvb_unregister_bus(struct vb2_dvb_frontends *f);
+
+struct vb2_dvb_frontend *vb2_dvb_alloc_frontend(struct vb2_dvb_frontends *f, int id);
+void vb2_dvb_dealloc_frontends(struct vb2_dvb_frontends *f);
+
+struct vb2_dvb_frontend *vb2_dvb_get_frontend(struct vb2_dvb_frontends *f, int id);
+int vb2_dvb_find_frontend(struct vb2_dvb_frontends *f, struct dvb_frontend *p);
+
+#endif			/* _VIDEOBUF2_DVB_H_ */
-- 
1.8.4.rc3

