Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:58275 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZBPTe2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 14:34:28 -0500
Date: Mon, 16 Feb 2009 20:33:17 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [review patch 0/1] add firedtv driver for FireWire-attached DVB
 receivers
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net
cc: Christian Dolzer <c.dolzer@digital-everywhere.com>,
	Andreas Monitzer <andy@monitzer.com>,
	Manu Abraham <manu@linuxtv.org>,
	Fabio De Lorenzo <delorenzo.fabio@gmail.com>,
	Robert Berger <robert.berger@reliableembeddedsystems.com>,
	Ben Backx <ben@bbackx.com>, Henrik Kurelid <henrik@kurelid.se>,
	Rambaldi <Rambaldi@xs4all.nl>
In-Reply-To: <tkrat.265ed076d414bd49@s5r6.in-berlin.de>
Message-ID: <tkrat.63c8bdca2465364b@s5r6.in-berlin.de>
References: <tkrat.265ed076d414bd49@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

firedtv is a driver for FireWire-attached DVB receivers from Digital
Everywhere GmbH.  The devices are known as FireDTV (external boxes) and
FloppyDTV (internal cards, also connected through FireWire).  The driver
supports
  - the DVB-C, DVB-S/S2, and DVB-T range of FireDTV and FloppyDTV
    models,
  - control and reception through Linux' common DVB userspace ABI,
  - standard definition video reception (MPEG2-TS, to be decoded
    by userspace client software),
  - Common Interface for Conditional Access Modules,
  - input from infrared remote control.

High definition support has yet to be added.  Also, firedtv still
requires the ieee1394 kernel API but alternative support of the new
firewire kernel API is in progress.

The driver, formerly known as firesat, was originally written by Andreas
Monitzer.  Manu Abraham, Ben Backx, and Henrik Kurelid updated and
extended the driver; I did trivial cleanups, refactoring and small
fixes.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
The patch, including its entire history since it was picked up for
Greg KH's staging tree, is also available at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git firedtv

and also at alternative places as mentioned in the parent posting.

 drivers/ieee1394/dma.h                    |    1 +
 drivers/ieee1394/ieee1394_core.c          |    1 +
 drivers/ieee1394/ieee1394_transactions.c  |   29 +
 drivers/ieee1394/ieee1394_transactions.h  |    2 +
 drivers/ieee1394/iso.h                    |    1 +
 drivers/ieee1394/nodemgr.c                |   10 +-
 drivers/ieee1394/nodemgr.h                |   18 +
 drivers/media/dvb/Kconfig                 |    4 +
 drivers/media/dvb/Makefile                |    2 +
 drivers/media/dvb/firewire/Kconfig        |   22 +
 drivers/media/dvb/firewire/Makefile       |    8 +
 drivers/media/dvb/firewire/firedtv-1394.c |  285 +++++++
 drivers/media/dvb/firewire/firedtv-avc.c  | 1235 +++++++++++++++++++++++++++++
 drivers/media/dvb/firewire/firedtv-ci.c   |  260 ++++++
 drivers/media/dvb/firewire/firedtv-dvb.c  |  364 +++++++++
 drivers/media/dvb/firewire/firedtv-fe.c   |  246 ++++++
 drivers/media/dvb/firewire/firedtv-rc.c   |  190 +++++
 drivers/media/dvb/firewire/firedtv.h      |  182 +++++
 18 files changed, 2857 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/dvb/firewire/Kconfig
 create mode 100644 drivers/media/dvb/firewire/Makefile
 create mode 100644 drivers/media/dvb/firewire/firedtv-1394.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-avc.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-ci.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-dvb.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-fe.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-rc.c
 create mode 100644 drivers/media/dvb/firewire/firedtv.h

diff --git a/drivers/ieee1394/dma.h b/drivers/ieee1394/dma.h
index 2727bcd..467373c 100644
--- a/drivers/ieee1394/dma.h
+++ b/drivers/ieee1394/dma.h
@@ -12,6 +12,7 @@
 
 #include <asm/types.h>
 
+struct file;
 struct pci_dev;
 struct scatterlist;
 struct vm_area_struct;
diff --git a/drivers/ieee1394/ieee1394_core.c b/drivers/ieee1394/ieee1394_core.c
index dcdb71a..9ee0a97 100644
--- a/drivers/ieee1394/ieee1394_core.c
+++ b/drivers/ieee1394/ieee1394_core.c
@@ -1314,6 +1314,7 @@ EXPORT_SYMBOL(hpsb_make_lock64packet);
 EXPORT_SYMBOL(hpsb_make_phypacket);
 EXPORT_SYMBOL(hpsb_read);
 EXPORT_SYMBOL(hpsb_write);
+EXPORT_SYMBOL(hpsb_lock);
 EXPORT_SYMBOL(hpsb_packet_success);
 
 /** highlevel.c **/
diff --git a/drivers/ieee1394/ieee1394_transactions.c b/drivers/ieee1394/ieee1394_transactions.c
index 10c3d9f..24021d2 100644
--- a/drivers/ieee1394/ieee1394_transactions.c
+++ b/drivers/ieee1394/ieee1394_transactions.c
@@ -570,3 +570,32 @@ int hpsb_write(struct hpsb_host *host, nodeid_t node, unsigned int generation,
 
 	return retval;
 }
+
+int hpsb_lock(struct hpsb_host *host, nodeid_t node, unsigned int generation,
+	      u64 addr, int extcode, quadlet_t *data, quadlet_t arg)
+{
+	struct hpsb_packet *packet;
+	int retval = 0;
+
+	BUG_ON(in_interrupt());
+
+	packet = hpsb_make_lockpacket(host, node, addr, extcode, data, arg);
+	if (!packet)
+		return -ENOMEM;
+
+	packet->generation = generation;
+	retval = hpsb_send_packet_and_wait(packet);
+	if (retval < 0)
+		goto hpsb_lock_fail;
+
+	retval = hpsb_packet_success(packet);
+
+	if (retval == 0)
+		*data = packet->data[0];
+
+hpsb_lock_fail:
+	hpsb_free_tlabel(packet);
+	hpsb_free_packet(packet);
+
+	return retval;
+}
diff --git a/drivers/ieee1394/ieee1394_transactions.h b/drivers/ieee1394/ieee1394_transactions.h
index d2d5bc3..20b693b 100644
--- a/drivers/ieee1394/ieee1394_transactions.h
+++ b/drivers/ieee1394/ieee1394_transactions.h
@@ -30,6 +30,8 @@ int hpsb_read(struct hpsb_host *host, nodeid_t node, unsigned int generation,
 	      u64 addr, quadlet_t *buffer, size_t length);
 int hpsb_write(struct hpsb_host *host, nodeid_t node, unsigned int generation,
 	       u64 addr, quadlet_t *buffer, size_t length);
+int hpsb_lock(struct hpsb_host *host, nodeid_t node, unsigned int generation,
+	      u64 addr, int extcode, quadlet_t *data, quadlet_t arg);
 
 #ifdef HPSB_DEBUG_TLABELS
 extern spinlock_t hpsb_tlabel_lock;
diff --git a/drivers/ieee1394/iso.h b/drivers/ieee1394/iso.h
index b5de5f2..c2089c0 100644
--- a/drivers/ieee1394/iso.h
+++ b/drivers/ieee1394/iso.h
@@ -13,6 +13,7 @@
 #define IEEE1394_ISO_H
 
 #include <linux/spinlock_types.h>
+#include <linux/wait.h>
 #include <asm/atomic.h>
 #include <asm/types.h>
 
diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 906c5a9..53aada5 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -971,6 +971,9 @@ static struct unit_directory *nodemgr_process_unit_directory
 	ud->ud_kv = ud_kv;
 	ud->id = (*id)++;
 
+	/* inherit vendor_id from root directory if none exists in unit dir */
+	ud->vendor_id = ne->vendor_id;
+
 	csr1212_for_each_dir_entry(ne->csr, kv, ud_kv, dentry) {
 		switch (kv->key.id) {
 		case CSR1212_KV_ID_VENDOR:
@@ -1265,7 +1268,8 @@ static void nodemgr_update_node(struct node_entry *ne, struct csr1212_csr *csr,
 		csr1212_destroy_csr(csr);
 	}
 
-	/* Mark the node current */
+	/* Finally, mark the node current */
+	smp_wmb();
 	ne->generation = generation;
 
 	if (ne->in_limbo) {
@@ -1798,7 +1802,7 @@ void hpsb_node_fill_packet(struct node_entry *ne, struct hpsb_packet *packet)
 {
 	packet->host = ne->host;
 	packet->generation = ne->generation;
-	barrier();
+	smp_rmb();
 	packet->node_id = ne->nodeid;
 }
 
@@ -1807,7 +1811,7 @@ int hpsb_node_write(struct node_entry *ne, u64 addr,
 {
 	unsigned int generation = ne->generation;
 
-	barrier();
+	smp_rmb();
 	return hpsb_write(ne->host, ne->nodeid, generation,
 			  addr, buffer, length);
 }
diff --git a/drivers/ieee1394/nodemgr.h b/drivers/ieee1394/nodemgr.h
index 15ea097..ee5acdb 100644
--- a/drivers/ieee1394/nodemgr.h
+++ b/drivers/ieee1394/nodemgr.h
@@ -21,9 +21,11 @@
 #define _IEEE1394_NODEMGR_H
 
 #include <linux/device.h>
+#include <asm/system.h>
 #include <asm/types.h>
 
 #include "ieee1394_core.h"
+#include "ieee1394_transactions.h"
 #include "ieee1394_types.h"
 
 struct csr1212_csr;
@@ -154,6 +156,22 @@ static inline int hpsb_node_entry_valid(struct node_entry *ne)
 void hpsb_node_fill_packet(struct node_entry *ne, struct hpsb_packet *packet);
 int hpsb_node_write(struct node_entry *ne, u64 addr,
 		    quadlet_t *buffer, size_t length);
+static inline int hpsb_node_read(struct node_entry *ne, u64 addr,
+				 quadlet_t *buffer, size_t length)
+{
+	unsigned int g = ne->generation;
+
+	smp_rmb();
+	return hpsb_read(ne->host, ne->nodeid, g, addr, buffer, length);
+}
+static inline int hpsb_node_lock(struct node_entry *ne, u64 addr, int extcode,
+				 quadlet_t *buffer, quadlet_t arg)
+{
+	unsigned int g = ne->generation;
+
+	smp_rmb();
+	return hpsb_lock(ne->host, ne->nodeid, g, addr, extcode, buffer, arg);
+}
 int nodemgr_for_each_host(void *data, int (*cb)(struct hpsb_host *, void *));
 
 int init_ieee1394_nodemgr(void);
diff --git a/drivers/media/dvb/Kconfig b/drivers/media/dvb/Kconfig
index 40ebde5..b019869 100644
--- a/drivers/media/dvb/Kconfig
+++ b/drivers/media/dvb/Kconfig
@@ -51,6 +51,10 @@ comment "Supported SDMC DM1105 Adapters"
 	depends on DVB_CORE && PCI && I2C
 source "drivers/media/dvb/dm1105/Kconfig"
 
+comment "Supported FireWire (IEEE 1394) Adapters"
+	depends on DVB_CORE && IEEE1394
+source "drivers/media/dvb/firewire/Kconfig"
+
 comment "Supported DVB Frontends"
 	depends on DVB_CORE
 source "drivers/media/dvb/frontends/Kconfig"
diff --git a/drivers/media/dvb/Makefile b/drivers/media/dvb/Makefile
index f91e9eb..6092a5b 100644
--- a/drivers/media/dvb/Makefile
+++ b/drivers/media/dvb/Makefile
@@ -3,3 +3,5 @@
 #
 
 obj-y        := dvb-core/ frontends/ ttpci/ ttusb-dec/ ttusb-budget/ b2c2/ bt8xx/ dvb-usb/ pluto2/ siano/ dm1105/
+
+obj-$(CONFIG_DVB_FIREDTV)	+= firewire/
diff --git a/drivers/media/dvb/firewire/Kconfig b/drivers/media/dvb/firewire/Kconfig
new file mode 100644
index 0000000..b0ab40f
--- /dev/null
+++ b/drivers/media/dvb/firewire/Kconfig
@@ -0,0 +1,22 @@
+config DVB_FIREDTV
+	tristate "FireDTV and FloppyDTV"
+	depends on DVB_CORE && IEEE1394
+	help
+	  Support for DVB receivers from Digital Everywhere
+	  which are connected via IEEE 1394 (FireWire).
+
+	  These devices don't have an MPEG decoder built in,
+	  so you need an external software decoder to watch TV.
+
+	  To compile this driver as a module, say M here:
+	  the module will be called firedtv.
+
+if DVB_FIREDTV
+
+config DVB_FIREDTV_IEEE1394
+	def_bool IEEE1394
+
+config DVB_FIREDTV_INPUT
+	def_bool INPUT
+
+endif # DVB_FIREDTV
diff --git a/drivers/media/dvb/firewire/Makefile b/drivers/media/dvb/firewire/Makefile
new file mode 100644
index 0000000..2034695
--- /dev/null
+++ b/drivers/media/dvb/firewire/Makefile
@@ -0,0 +1,8 @@
+obj-$(CONFIG_DVB_FIREDTV) += firedtv.o
+
+firedtv-y := firedtv-avc.o firedtv-ci.o firedtv-dvb.o firedtv-fe.o
+firedtv-$(CONFIG_DVB_FIREDTV_IEEE1394) += firedtv-1394.o
+firedtv-$(CONFIG_DVB_FIREDTV_INPUT)    += firedtv-rc.o
+
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-$(CONFIG_DVB_FIREDTV_IEEE1394) += -Idrivers/ieee1394
diff --git a/drivers/media/dvb/firewire/firedtv-1394.c b/drivers/media/dvb/firewire/firedtv-1394.c
new file mode 100644
index 0000000..4e20765
--- /dev/null
+++ b/drivers/media/dvb/firewire/firedtv-1394.c
@@ -0,0 +1,285 @@
+/*
+ * FireDTV driver (formerly known as FireSAT)
+ *
+ * Copyright (C) 2004 Andreas Monitzer <andy@monitzer.com>
+ * Copyright (C) 2007-2008 Ben Backx <ben@bbackx.com>
+ * Copyright (C) 2008 Henrik Kurelid <henrik@kurelid.se>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation; either version 2 of
+ *	the License, or (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+#include <dma.h>
+#include <csr1212.h>
+#include <highlevel.h>
+#include <hosts.h>
+#include <ieee1394.h>
+#include <iso.h>
+#include <nodemgr.h>
+
+#include "firedtv.h"
+
+static LIST_HEAD(node_list);
+static DEFINE_SPINLOCK(node_list_lock);
+
+#define FIREWIRE_HEADER_SIZE	4
+#define CIP_HEADER_SIZE		8
+
+static void rawiso_activity_cb(struct hpsb_iso *iso)
+{
+	struct firedtv *f, *fdtv = NULL;
+	unsigned int i, num, packet;
+	unsigned char *buf;
+	unsigned long flags;
+	int count;
+
+	spin_lock_irqsave(&node_list_lock, flags);
+	list_for_each_entry(f, &node_list, list)
+		if (f->backend_data == iso) {
+			fdtv = f;
+			break;
+		}
+	spin_unlock_irqrestore(&node_list_lock, flags);
+
+	packet = iso->first_packet;
+	num = hpsb_iso_n_ready(iso);
+
+	if (!fdtv) {
+		dev_err(fdtv->device, "received at unknown iso channel\n");
+		goto out;
+	}
+
+	for (i = 0; i < num; i++, packet = (packet + 1) % iso->buf_packets) {
+		buf = dma_region_i(&iso->data_buf, unsigned char,
+			iso->infos[packet].offset + CIP_HEADER_SIZE);
+		count = (iso->infos[packet].len - CIP_HEADER_SIZE) /
+			(188 + FIREWIRE_HEADER_SIZE);
+
+		/* ignore empty packet */
+		if (iso->infos[packet].len <= CIP_HEADER_SIZE)
+			continue;
+
+		while (count--) {
+			if (buf[FIREWIRE_HEADER_SIZE] == 0x47)
+				dvb_dmx_swfilter_packets(&fdtv->demux,
+						&buf[FIREWIRE_HEADER_SIZE], 1);
+			else
+				dev_err(fdtv->device,
+					"skipping invalid packet\n");
+			buf += 188 + FIREWIRE_HEADER_SIZE;
+		}
+	}
+out:
+	hpsb_iso_recv_release_packets(iso, num);
+}
+
+static inline struct node_entry *node_of(struct firedtv *fdtv)
+{
+	return container_of(fdtv->device, struct unit_directory, device)->ne;
+}
+
+static int node_lock(struct firedtv *fdtv, u64 addr, void *data, __be32 arg)
+{
+	return hpsb_node_lock(node_of(fdtv), addr, EXTCODE_COMPARE_SWAP, data,
+			      (__force quadlet_t)arg);
+}
+
+static int node_read(struct firedtv *fdtv, u64 addr, void *data, size_t len)
+{
+	return hpsb_node_read(node_of(fdtv), addr, data, len);
+}
+
+static int node_write(struct firedtv *fdtv, u64 addr, void *data, size_t len)
+{
+	return hpsb_node_write(node_of(fdtv), addr, data, len);
+}
+
+#define FDTV_ISO_BUFFER_PACKETS 256
+#define FDTV_ISO_BUFFER_SIZE (FDTV_ISO_BUFFER_PACKETS * 200)
+
+static int start_iso(struct firedtv *fdtv)
+{
+	struct hpsb_iso *iso_handle;
+	int ret;
+
+	iso_handle = hpsb_iso_recv_init(node_of(fdtv)->host,
+				FDTV_ISO_BUFFER_SIZE, FDTV_ISO_BUFFER_PACKETS,
+				fdtv->isochannel, HPSB_ISO_DMA_DEFAULT,
+				-1, /* stat.config.irq_interval */
+				rawiso_activity_cb);
+	if (iso_handle == NULL) {
+		dev_err(fdtv->device, "cannot initialize iso receive\n");
+		return -ENOMEM;
+	}
+	fdtv->backend_data = iso_handle;
+
+	ret = hpsb_iso_recv_start(iso_handle, -1, -1, 0);
+	if (ret != 0) {
+		dev_err(fdtv->device, "cannot start iso receive\n");
+		hpsb_iso_shutdown(iso_handle);
+		fdtv->backend_data = NULL;
+	}
+	return ret;
+}
+
+static void stop_iso(struct firedtv *fdtv)
+{
+	struct hpsb_iso *iso_handle = fdtv->backend_data;
+
+	if (iso_handle != NULL) {
+		hpsb_iso_stop(iso_handle);
+		hpsb_iso_shutdown(iso_handle);
+	}
+	fdtv->backend_data = NULL;
+}
+
+static const struct firedtv_backend fdtv_1394_backend = {
+	.lock		= node_lock,
+	.read		= node_read,
+	.write		= node_write,
+	.start_iso	= start_iso,
+	.stop_iso	= stop_iso,
+};
+
+static void fcp_request(struct hpsb_host *host, int nodeid, int direction,
+			int cts, u8 *data, size_t length)
+{
+	struct firedtv *f, *fdtv = NULL;
+	unsigned long flags;
+	int su;
+
+	if (length == 0 || (data[0] & 0xf0) != 0)
+		return;
+
+	su = data[1] & 0x7;
+
+	spin_lock_irqsave(&node_list_lock, flags);
+	list_for_each_entry(f, &node_list, list)
+		if (node_of(f)->host == host &&
+		    node_of(f)->nodeid == nodeid &&
+		    (f->subunit == su || (f->subunit == 0 && su == 0x7))) {
+			fdtv = f;
+			break;
+		}
+	spin_unlock_irqrestore(&node_list_lock, flags);
+
+	if (fdtv)
+		avc_recv(fdtv, data, length);
+}
+
+static int node_probe(struct device *dev)
+{
+	struct unit_directory *ud =
+			container_of(dev, struct unit_directory, device);
+	struct firedtv *fdtv;
+	int kv_len, err;
+	void *kv_str;
+
+	kv_len = (ud->model_name_kv->value.leaf.len - 2) * sizeof(quadlet_t);
+	kv_str = CSR1212_TEXTUAL_DESCRIPTOR_LEAF_DATA(ud->model_name_kv);
+
+	fdtv = fdtv_alloc(dev, &fdtv_1394_backend, kv_str, kv_len);
+	if (!fdtv)
+		return -ENOMEM;
+
+	/*
+	 * Work around a bug in udev's path_id script:  Use the fw-host's dev
+	 * instead of the unit directory's dev as parent of the input device.
+	 */
+	err = fdtv_register_rc(fdtv, dev->parent->parent);
+	if (err)
+		goto fail_free;
+
+	spin_lock_irq(&node_list_lock);
+	list_add_tail(&fdtv->list, &node_list);
+	spin_unlock_irq(&node_list_lock);
+
+	err = avc_identify_subunit(fdtv);
+	if (err)
+		goto fail;
+
+	err = fdtv_dvb_register(fdtv);
+	if (err)
+		goto fail;
+
+	avc_register_remote_control(fdtv);
+	return 0;
+fail:
+	spin_lock_irq(&node_list_lock);
+	list_del(&fdtv->list);
+	spin_unlock_irq(&node_list_lock);
+	fdtv_unregister_rc(fdtv);
+fail_free:
+	kfree(fdtv);
+	return err;
+}
+
+static int node_remove(struct device *dev)
+{
+	struct firedtv *fdtv = dev->driver_data;
+
+	fdtv_dvb_unregister(fdtv);
+
+	spin_lock_irq(&node_list_lock);
+	list_del(&fdtv->list);
+	spin_unlock_irq(&node_list_lock);
+
+	cancel_work_sync(&fdtv->remote_ctrl_work);
+	fdtv_unregister_rc(fdtv);
+
+	kfree(fdtv);
+	return 0;
+}
+
+static int node_update(struct unit_directory *ud)
+{
+	struct firedtv *fdtv = ud->device.driver_data;
+
+	if (fdtv->isochannel >= 0)
+		cmp_establish_pp_connection(fdtv, fdtv->subunit,
+					    fdtv->isochannel);
+	return 0;
+}
+
+static struct hpsb_protocol_driver fdtv_driver = {
+	.name		= "firedtv",
+	.update		= node_update,
+	.driver         = {
+		.probe  = node_probe,
+		.remove = node_remove,
+	},
+};
+
+static struct hpsb_highlevel fdtv_highlevel = {
+	.name		= "firedtv",
+	.fcp_request	= fcp_request,
+};
+
+int __init fdtv_1394_init(struct ieee1394_device_id id_table[])
+{
+	int ret;
+
+	hpsb_register_highlevel(&fdtv_highlevel);
+	fdtv_driver.id_table = id_table;
+	ret = hpsb_register_protocol(&fdtv_driver);
+	if (ret) {
+		printk(KERN_ERR "firedtv: failed to register protocol\n");
+		hpsb_unregister_highlevel(&fdtv_highlevel);
+	}
+	return ret;
+}
+
+void __exit fdtv_1394_exit(void)
+{
+	hpsb_unregister_protocol(&fdtv_driver);
+	hpsb_unregister_highlevel(&fdtv_highlevel);
+}
diff --git a/drivers/media/dvb/firewire/firedtv-avc.c b/drivers/media/dvb/firewire/firedtv-avc.c
new file mode 100644
index 0000000..044d1aa
--- /dev/null
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -0,0 +1,1235 @@
+/*
+ * FireDTV driver (formerly known as FireSAT)
+ *
+ * Copyright (C) 2004 Andreas Monitzer <andy@monitzer.com>
+ * Copyright (C) 2008 Ben Backx <ben@bbackx.com>
+ * Copyright (C) 2008 Henrik Kurelid <henrik@kurelid.se>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation; either version 2 of
+ *	the License, or (at your option) any later version.
+ */
+
+#include <linux/bug.h>
+#include <linux/crc32.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/string.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+
+#include "firedtv.h"
+
+#define FCP_COMMAND_REGISTER		0xfffff0000b00ULL
+
+#define AVC_CTYPE_CONTROL		0x0
+#define AVC_CTYPE_STATUS		0x1
+#define AVC_CTYPE_NOTIFY		0x3
+
+#define AVC_RESPONSE_ACCEPTED		0x9
+#define AVC_RESPONSE_STABLE		0xc
+#define AVC_RESPONSE_CHANGED		0xd
+#define AVC_RESPONSE_INTERIM		0xf
+
+#define AVC_SUBUNIT_TYPE_TUNER		(0x05 << 3)
+#define AVC_SUBUNIT_TYPE_UNIT		(0x1f << 3)
+
+#define AVC_OPCODE_VENDOR		0x00
+#define AVC_OPCODE_READ_DESCRIPTOR	0x09
+#define AVC_OPCODE_DSIT			0xc8
+#define AVC_OPCODE_DSD			0xcb
+
+#define DESCRIPTOR_TUNER_STATUS 	0x80
+#define DESCRIPTOR_SUBUNIT_IDENTIFIER	0x00
+
+#define SFE_VENDOR_DE_COMPANYID_0	0x00 /* OUI of Digital Everywhere */
+#define SFE_VENDOR_DE_COMPANYID_1	0x12
+#define SFE_VENDOR_DE_COMPANYID_2	0x87
+
+#define SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL 0x0a
+#define SFE_VENDOR_OPCODE_LNB_CONTROL		0x52
+#define SFE_VENDOR_OPCODE_TUNE_QPSK		0x58 /* for DVB-S */
+
+#define SFE_VENDOR_OPCODE_GET_FIRMWARE_VERSION	0x00
+#define SFE_VENDOR_OPCODE_HOST2CA		0x56
+#define SFE_VENDOR_OPCODE_CA2HOST		0x57
+#define SFE_VENDOR_OPCODE_CISTATUS		0x59
+#define SFE_VENDOR_OPCODE_TUNE_QPSK2		0x60 /* for DVB-S2 */
+
+#define SFE_VENDOR_TAG_CA_RESET			0x00
+#define SFE_VENDOR_TAG_CA_APPLICATION_INFO	0x01
+#define SFE_VENDOR_TAG_CA_PMT			0x02
+#define SFE_VENDOR_TAG_CA_DATE_TIME		0x04
+#define SFE_VENDOR_TAG_CA_MMI			0x05
+#define SFE_VENDOR_TAG_CA_ENTER_MENU		0x07
+
+#define EN50221_LIST_MANAGEMENT_ONLY	0x03
+#define EN50221_TAG_APP_INFO		0x9f8021
+#define EN50221_TAG_CA_INFO		0x9f8031
+
+struct avc_command_frame {
+	int length;
+	u8 ctype;
+	u8 subunit;
+	u8 opcode;
+	u8 operand[509];
+};
+
+struct avc_response_frame {
+	int length;
+	u8 response;
+	u8 subunit;
+	u8 opcode;
+	u8 operand[509];
+};
+
+static int __avc_write(struct firedtv *fdtv,
+		const struct avc_command_frame *c, struct avc_response_frame *r)
+{
+	int err, retry;
+
+	if (r)
+		fdtv->avc_reply_received = false;
+
+	for (retry = 0; retry < 6; retry++) {
+		err = fdtv->backend->write(fdtv, FCP_COMMAND_REGISTER,
+					   (void *)&c->ctype, c->length);
+		if (err) {
+			fdtv->avc_reply_received = true;
+			dev_err(fdtv->device, "FCP command write failed\n");
+			return err;
+		}
+
+		if (!r)
+			return 0;
+
+		/*
+		 * AV/C specs say that answers should be sent within 150 ms.
+		 * Time out after 200 ms.
+		 */
+		if (wait_event_timeout(fdtv->avc_wait,
+				       fdtv->avc_reply_received,
+				       HZ / 5) != 0) {
+			r->length = fdtv->response_length;
+			memcpy(&r->response, fdtv->response, r->length);
+
+			return 0;
+		}
+	}
+	dev_err(fdtv->device, "FCP response timed out\n");
+	return -ETIMEDOUT;
+}
+
+static int avc_write(struct firedtv *fdtv,
+		const struct avc_command_frame *c, struct avc_response_frame *r)
+{
+	int ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
+
+	ret = __avc_write(fdtv, c, r);
+
+	mutex_unlock(&fdtv->avc_mutex);
+	return ret;
+}
+
+int avc_recv(struct firedtv *fdtv, void *data, size_t length)
+{
+	struct avc_response_frame *r =
+			data - offsetof(struct avc_response_frame, response);
+
+	if (length >= 8 &&
+	    r->operand[0] == SFE_VENDOR_DE_COMPANYID_0 &&
+	    r->operand[1] == SFE_VENDOR_DE_COMPANYID_1 &&
+	    r->operand[2] == SFE_VENDOR_DE_COMPANYID_2 &&
+	    r->operand[3] == SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL) {
+		if (r->response == AVC_RESPONSE_CHANGED) {
+			fdtv_handle_rc(fdtv,
+			    r->operand[4] << 8 | r->operand[5]);
+			schedule_work(&fdtv->remote_ctrl_work);
+		} else if (r->response != AVC_RESPONSE_INTERIM) {
+			dev_info(fdtv->device,
+				 "remote control result = %d\n", r->response);
+		}
+		return 0;
+	}
+
+	if (fdtv->avc_reply_received) {
+		dev_err(fdtv->device, "out-of-order AVC response, ignored\n");
+		return -EIO;
+	}
+
+	memcpy(fdtv->response, data, length);
+	fdtv->response_length = length;
+
+	fdtv->avc_reply_received = true;
+	wake_up(&fdtv->avc_wait);
+
+	return 0;
+}
+
+/*
+ * tuning command for setting the relative LNB frequency
+ * (not supported by the AVC standard)
+ */
+static void avc_tuner_tuneqpsk(struct firedtv *fdtv,
+			       struct dvb_frontend_parameters *params,
+			       struct avc_command_frame *c)
+{
+	c->opcode = AVC_OPCODE_VENDOR;
+
+	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
+	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
+	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
+	c->operand[3] = SFE_VENDOR_OPCODE_TUNE_QPSK;
+
+	c->operand[4] = (params->frequency >> 24) & 0xff;
+	c->operand[5] = (params->frequency >> 16) & 0xff;
+	c->operand[6] = (params->frequency >> 8) & 0xff;
+	c->operand[7] = params->frequency & 0xff;
+
+	c->operand[8] = ((params->u.qpsk.symbol_rate / 1000) >> 8) & 0xff;
+	c->operand[9] = (params->u.qpsk.symbol_rate / 1000) & 0xff;
+
+	switch (params->u.qpsk.fec_inner) {
+	case FEC_1_2:	c->operand[10] = 0x1; break;
+	case FEC_2_3:	c->operand[10] = 0x2; break;
+	case FEC_3_4:	c->operand[10] = 0x3; break;
+	case FEC_5_6:	c->operand[10] = 0x4; break;
+	case FEC_7_8:	c->operand[10] = 0x5; break;
+	case FEC_4_5:
+	case FEC_8_9:
+	case FEC_AUTO:
+	default:	c->operand[10] = 0x0;
+	}
+
+	if (fdtv->voltage == 0xff)
+		c->operand[11] = 0xff;
+	else if (fdtv->voltage == SEC_VOLTAGE_18) /* polarisation */
+		c->operand[11] = 0;
+	else
+		c->operand[11] = 1;
+
+	if (fdtv->tone == 0xff)
+		c->operand[12] = 0xff;
+	else if (fdtv->tone == SEC_TONE_ON) /* band */
+		c->operand[12] = 1;
+	else
+		c->operand[12] = 0;
+
+	if (fdtv->type == FIREDTV_DVB_S2) {
+		c->operand[13] = 0x1;
+		c->operand[14] = 0xff;
+		c->operand[15] = 0xff;
+		c->length = 20;
+	} else {
+		c->length = 16;
+	}
+}
+
+static void avc_tuner_dsd_dvb_c(struct dvb_frontend_parameters *params,
+				struct avc_command_frame *c)
+{
+	c->opcode = AVC_OPCODE_DSD;
+
+	c->operand[0] = 0;    /* source plug */
+	c->operand[1] = 0xd2; /* subfunction replace */
+	c->operand[2] = 0x20; /* system id = DVB */
+	c->operand[3] = 0x00; /* antenna number */
+	c->operand[4] = 0x11; /* system_specific_multiplex selection_length */
+
+	/* multiplex_valid_flags, high byte */
+	c->operand[5] =   0 << 7 /* reserved */
+			| 0 << 6 /* Polarisation */
+			| 0 << 5 /* Orbital_Pos */
+			| 1 << 4 /* Frequency */
+			| 1 << 3 /* Symbol_Rate */
+			| 0 << 2 /* FEC_outer */
+			| (params->u.qam.fec_inner  != FEC_AUTO ? 1 << 1 : 0)
+			| (params->u.qam.modulation != QAM_AUTO ? 1 << 0 : 0);
+
+	/* multiplex_valid_flags, low byte */
+	c->operand[6] =   0 << 7 /* NetworkID */
+			| 0 << 0 /* reserved */ ;
+
+	c->operand[7]  = 0x00;
+	c->operand[8]  = 0x00;
+	c->operand[9]  = 0x00;
+	c->operand[10] = 0x00;
+
+	c->operand[11] = (((params->frequency / 4000) >> 16) & 0xff) | (2 << 6);
+	c->operand[12] = ((params->frequency / 4000) >> 8) & 0xff;
+	c->operand[13] = (params->frequency / 4000) & 0xff;
+	c->operand[14] = ((params->u.qpsk.symbol_rate / 1000) >> 12) & 0xff;
+	c->operand[15] = ((params->u.qpsk.symbol_rate / 1000) >> 4) & 0xff;
+	c->operand[16] = ((params->u.qpsk.symbol_rate / 1000) << 4) & 0xf0;
+	c->operand[17] = 0x00;
+
+	switch (params->u.qpsk.fec_inner) {
+	case FEC_1_2:	c->operand[18] = 0x1; break;
+	case FEC_2_3:	c->operand[18] = 0x2; break;
+	case FEC_3_4:	c->operand[18] = 0x3; break;
+	case FEC_5_6:	c->operand[18] = 0x4; break;
+	case FEC_7_8:	c->operand[18] = 0x5; break;
+	case FEC_8_9:	c->operand[18] = 0x6; break;
+	case FEC_4_5:	c->operand[18] = 0x8; break;
+	case FEC_AUTO:
+	default:	c->operand[18] = 0x0;
+	}
+
+	switch (params->u.qam.modulation) {
+	case QAM_16:	c->operand[19] = 0x08; break;
+	case QAM_32:	c->operand[19] = 0x10; break;
+	case QAM_64:	c->operand[19] = 0x18; break;
+	case QAM_128:	c->operand[19] = 0x20; break;
+	case QAM_256:	c->operand[19] = 0x28; break;
+	case QAM_AUTO:
+	default:	c->operand[19] = 0x00;
+	}
+
+	c->operand[20] = 0x00;
+	c->operand[21] = 0x00;
+	/* Nr_of_dsd_sel_specs = 0 -> no PIDs are transmitted */
+	c->operand[22] = 0x00;
+
+	c->length = 28;
+}
+
+static void avc_tuner_dsd_dvb_t(struct dvb_frontend_parameters *params,
+				struct avc_command_frame *c)
+{
+	struct dvb_ofdm_parameters *ofdm = &params->u.ofdm;
+
+	c->opcode = AVC_OPCODE_DSD;
+
+	c->operand[0] = 0;    /* source plug */
+	c->operand[1] = 0xd2; /* subfunction replace */
+	c->operand[2] = 0x20; /* system id = DVB */
+	c->operand[3] = 0x00; /* antenna number */
+	c->operand[4] = 0x0c; /* system_specific_multiplex selection_length */
+
+	/* multiplex_valid_flags, high byte */
+	c->operand[5] =
+	      0 << 7 /* reserved */
+	    | 1 << 6 /* CenterFrequency */
+	    | (ofdm->bandwidth      != BANDWIDTH_AUTO        ? 1 << 5 : 0)
+	    | (ofdm->constellation  != QAM_AUTO              ? 1 << 4 : 0)
+	    | (ofdm->hierarchy_information != HIERARCHY_AUTO ? 1 << 3 : 0)
+	    | (ofdm->code_rate_HP   != FEC_AUTO              ? 1 << 2 : 0)
+	    | (ofdm->code_rate_LP   != FEC_AUTO              ? 1 << 1 : 0)
+	    | (ofdm->guard_interval != GUARD_INTERVAL_AUTO   ? 1 << 0 : 0);
+
+	/* multiplex_valid_flags, low byte */
+	c->operand[6] =
+	      0 << 7 /* NetworkID */
+	    | (ofdm->transmission_mode != TRANSMISSION_MODE_AUTO ? 1 << 6 : 0)
+	    | 0 << 5 /* OtherFrequencyFlag */
+	    | 0 << 0 /* reserved */ ;
+
+	c->operand[7]  = 0x0;
+	c->operand[8]  = (params->frequency / 10) >> 24;
+	c->operand[9]  = ((params->frequency / 10) >> 16) & 0xff;
+	c->operand[10] = ((params->frequency / 10) >>  8) & 0xff;
+	c->operand[11] = (params->frequency / 10) & 0xff;
+
+	switch (ofdm->bandwidth) {
+	case BANDWIDTH_7_MHZ:	c->operand[12] = 0x20; break;
+	case BANDWIDTH_8_MHZ:
+	case BANDWIDTH_6_MHZ:	/* not defined by AVC spec */
+	case BANDWIDTH_AUTO:
+	default:		c->operand[12] = 0x00;
+	}
+
+	switch (ofdm->constellation) {
+	case QAM_16:	c->operand[13] = 1 << 6; break;
+	case QAM_64:	c->operand[13] = 2 << 6; break;
+	case QPSK:
+	default:	c->operand[13] = 0x00;
+	}
+
+	switch (ofdm->hierarchy_information) {
+	case HIERARCHY_1:	c->operand[13] |= 1 << 3; break;
+	case HIERARCHY_2:	c->operand[13] |= 2 << 3; break;
+	case HIERARCHY_4:	c->operand[13] |= 3 << 3; break;
+	case HIERARCHY_AUTO:
+	case HIERARCHY_NONE:
+	default:		break;
+	}
+
+	switch (ofdm->code_rate_HP) {
+	case FEC_2_3:	c->operand[13] |= 1; break;
+	case FEC_3_4:	c->operand[13] |= 2; break;
+	case FEC_5_6:	c->operand[13] |= 3; break;
+	case FEC_7_8:	c->operand[13] |= 4; break;
+	case FEC_1_2:
+	default:	break;
+	}
+
+	switch (ofdm->code_rate_LP) {
+	case FEC_2_3:	c->operand[14] = 1 << 5; break;
+	case FEC_3_4:	c->operand[14] = 2 << 5; break;
+	case FEC_5_6:	c->operand[14] = 3 << 5; break;
+	case FEC_7_8:	c->operand[14] = 4 << 5; break;
+	case FEC_1_2:
+	default:	c->operand[14] = 0x00; break;
+	}
+
+	switch (ofdm->guard_interval) {
+	case GUARD_INTERVAL_1_16:	c->operand[14] |= 1 << 3; break;
+	case GUARD_INTERVAL_1_8:	c->operand[14] |= 2 << 3; break;
+	case GUARD_INTERVAL_1_4:	c->operand[14] |= 3 << 3; break;
+	case GUARD_INTERVAL_1_32:
+	case GUARD_INTERVAL_AUTO:
+	default:			break;
+	}
+
+	switch (ofdm->transmission_mode) {
+	case TRANSMISSION_MODE_8K:	c->operand[14] |= 1 << 1; break;
+	case TRANSMISSION_MODE_2K:
+	case TRANSMISSION_MODE_AUTO:
+	default:			break;
+	}
+
+	c->operand[15] = 0x00; /* network_ID[0] */
+	c->operand[16] = 0x00; /* network_ID[1] */
+	/* Nr_of_dsd_sel_specs = 0 -> no PIDs are transmitted */
+	c->operand[17] = 0x00;
+
+	c->length = 24;
+}
+
+int avc_tuner_dsd(struct firedtv *fdtv,
+		  struct dvb_frontend_parameters *params)
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+	struct avc_response_frame *r = (void *)buffer; /* FIXME: unused */
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_CONTROL;
+	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
+
+	switch (fdtv->type) {
+	case FIREDTV_DVB_S:
+	case FIREDTV_DVB_S2: avc_tuner_tuneqpsk(fdtv, params, c); break;
+	case FIREDTV_DVB_C: avc_tuner_dsd_dvb_c(params, c); break;
+	case FIREDTV_DVB_T: avc_tuner_dsd_dvb_t(params, c); break;
+	default:
+		BUG();
+	}
+
+	if (avc_write(fdtv, c, r) < 0)
+		return -EIO;
+
+	msleep(500);
+#if 0
+	/* FIXME: */
+	/* u8 *status was an out-parameter of avc_tuner_dsd, unused by caller */
+	if (status)
+		*status = r->operand[2];
+#endif
+	return 0;
+}
+
+int avc_tuner_set_pids(struct firedtv *fdtv, unsigned char pidc, u16 pid[])
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+	struct avc_response_frame *r = (void *)buffer; /* FIXME: unused */
+	int pos, k;
+
+	if (pidc > 16 && pidc != 0xff)
+		return -EINVAL;
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_CONTROL;
+	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
+	c->opcode  = AVC_OPCODE_DSD;
+
+	c->operand[0] = 0;	/* source plug */
+	c->operand[1] = 0xd2;	/* subfunction replace */
+	c->operand[2] = 0x20;	/* system id = DVB */
+	c->operand[3] = 0x00;	/* antenna number */
+	c->operand[4] = 0x00;	/* system_specific_multiplex selection_length */
+	c->operand[5] = pidc;	/* Nr_of_dsd_sel_specs */
+
+	pos = 6;
+	if (pidc != 0xff)
+		for (k = 0; k < pidc; k++) {
+			c->operand[pos++] = 0x13; /* flowfunction relay */
+			c->operand[pos++] = 0x80; /* dsd_sel_spec_valid_flags -> PID */
+			c->operand[pos++] = (pid[k] >> 8) & 0x1f;
+			c->operand[pos++] = pid[k] & 0xff;
+			c->operand[pos++] = 0x00; /* tableID */
+			c->operand[pos++] = 0x00; /* filter_length */
+		}
+
+	c->length = ALIGN(3 + pos, 4);
+
+	if (avc_write(fdtv, c, r) < 0)
+		return -EIO;
+
+	msleep(50);
+	return 0;
+}
+
+int avc_tuner_get_ts(struct firedtv *fdtv)
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+	struct avc_response_frame *r = (void *)buffer; /* FIXME: unused */
+	int sl;
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_CONTROL;
+	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
+	c->opcode  = AVC_OPCODE_DSIT;
+
+	sl = fdtv->type == FIREDTV_DVB_T ? 0x0c : 0x11;
+
+	c->operand[0] = 0;	/* source plug */
+	c->operand[1] = 0xd2;	/* subfunction replace */
+	c->operand[2] = 0xff;	/* status */
+	c->operand[3] = 0x20;	/* system id = DVB */
+	c->operand[4] = 0x00;	/* antenna number */
+	c->operand[5] = 0x0; 	/* system_specific_search_flags */
+	c->operand[6] = sl;	/* system_specific_multiplex selection_length */
+	c->operand[7] = 0x00;	/* valid_flags [0] */
+	c->operand[8] = 0x00;	/* valid_flags [1] */
+	c->operand[7 + sl] = 0x00; /* nr_of_dsit_sel_specs (always 0) */
+
+	c->length = fdtv->type == FIREDTV_DVB_T ? 24 : 28;
+
+	if (avc_write(fdtv, c, r) < 0)
+		return -EIO;
+
+	msleep(250);
+	return 0;
+}
+
+int avc_identify_subunit(struct firedtv *fdtv)
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+	struct avc_response_frame *r = (void *)buffer;
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_CONTROL;
+	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
+	c->opcode  = AVC_OPCODE_READ_DESCRIPTOR;
+
+	c->operand[0] = DESCRIPTOR_SUBUNIT_IDENTIFIER;
+	c->operand[1] = 0xff;
+	c->operand[2] = 0x00;
+	c->operand[3] = 0x00; /* length highbyte */
+	c->operand[4] = 0x08; /* length lowbyte  */
+	c->operand[5] = 0x00; /* offset highbyte */
+	c->operand[6] = 0x0d; /* offset lowbyte  */
+
+	c->length = 12;
+
+	if (avc_write(fdtv, c, r) < 0)
+		return -EIO;
+
+	if ((r->response != AVC_RESPONSE_STABLE &&
+	     r->response != AVC_RESPONSE_ACCEPTED) ||
+	    (r->operand[3] << 8) + r->operand[4] != 8) {
+		dev_err(fdtv->device, "cannot read subunit identifier\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+#define SIZEOF_ANTENNA_INPUT_INFO 22
+
+int avc_tuner_status(struct firedtv *fdtv, struct firedtv_tuner_status *stat)
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+	struct avc_response_frame *r = (void *)buffer;
+	int length;
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_CONTROL;
+	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
+	c->opcode  = AVC_OPCODE_READ_DESCRIPTOR;
+
+	c->operand[0] = DESCRIPTOR_TUNER_STATUS;
+	c->operand[1] = 0xff;	/* read_result_status */
+	c->operand[2] = 0x00;	/* reserved */
+	c->operand[3] = 0;	/* SIZEOF_ANTENNA_INPUT_INFO >> 8; */
+	c->operand[4] = 0;	/* SIZEOF_ANTENNA_INPUT_INFO & 0xff; */
+	c->operand[5] = 0x00;
+	c->operand[6] = 0x00;
+
+	c->length = 12;
+
+	if (avc_write(fdtv, c, r) < 0)
+		return -EIO;
+
+	if (r->response != AVC_RESPONSE_STABLE &&
+	    r->response != AVC_RESPONSE_ACCEPTED) {
+		dev_err(fdtv->device, "cannot read tuner status\n");
+		return -EINVAL;
+	}
+
+	length = r->operand[9];
+	if (r->operand[1] != 0x10 || length != SIZEOF_ANTENNA_INPUT_INFO) {
+		dev_err(fdtv->device, "got invalid tuner status\n");
+		return -EINVAL;
+	}
+
+	stat->active_system		= r->operand[10];
+	stat->searching			= r->operand[11] >> 7 & 1;
+	stat->moving			= r->operand[11] >> 6 & 1;
+	stat->no_rf			= r->operand[11] >> 5 & 1;
+	stat->input			= r->operand[12] >> 7 & 1;
+	stat->selected_antenna		= r->operand[12] & 0x7f;
+	stat->ber			= r->operand[13] << 24 |
+					  r->operand[14] << 16 |
+					  r->operand[15] << 8 |
+					  r->operand[16];
+	stat->signal_strength		= r->operand[17];
+	stat->raster_frequency		= r->operand[18] >> 6 & 2;
+	stat->rf_frequency		= (r->operand[18] & 0x3f) << 16 |
+					  r->operand[19] << 8 |
+					  r->operand[20];
+	stat->man_dep_info_length	= r->operand[21];
+	stat->front_end_error		= r->operand[22] >> 4 & 1;
+	stat->antenna_error		= r->operand[22] >> 3 & 1;
+	stat->front_end_power_status	= r->operand[22] >> 1 & 1;
+	stat->power_supply		= r->operand[22] & 1;
+	stat->carrier_noise_ratio	= r->operand[23] << 8 |
+					  r->operand[24];
+	stat->power_supply_voltage	= r->operand[27];
+	stat->antenna_voltage		= r->operand[28];
+	stat->firewire_bus_voltage	= r->operand[29];
+	stat->ca_mmi			= r->operand[30] & 1;
+	stat->ca_pmt_reply		= r->operand[31] >> 7 & 1;
+	stat->ca_date_time_request	= r->operand[31] >> 6 & 1;
+	stat->ca_application_info	= r->operand[31] >> 5 & 1;
+	stat->ca_module_present_status	= r->operand[31] >> 4 & 1;
+	stat->ca_dvb_flag		= r->operand[31] >> 3 & 1;
+	stat->ca_error_flag		= r->operand[31] >> 2 & 1;
+	stat->ca_initialization_status	= r->operand[31] >> 1 & 1;
+
+	return 0;
+}
+
+int avc_lnb_control(struct firedtv *fdtv, char voltage, char burst,
+		    char conttone, char nrdiseq,
+		    struct dvb_diseqc_master_cmd *diseqcmd)
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+	struct avc_response_frame *r = (void *)buffer;
+	int i, j, k;
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_CONTROL;
+	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
+	c->opcode  = AVC_OPCODE_VENDOR;
+
+	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
+	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
+	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
+	c->operand[3] = SFE_VENDOR_OPCODE_LNB_CONTROL;
+
+	c->operand[4] = voltage;
+	c->operand[5] = nrdiseq;
+
+	i = 6;
+
+	for (j = 0; j < nrdiseq; j++) {
+		c->operand[i++] = diseqcmd[j].msg_len;
+
+		for (k = 0; k < diseqcmd[j].msg_len; k++)
+			c->operand[i++] = diseqcmd[j].msg[k];
+	}
+
+	c->operand[i++] = burst;
+	c->operand[i++] = conttone;
+
+	c->length = ALIGN(3 + i, 4);
+
+	if (avc_write(fdtv, c, r) < 0)
+		return -EIO;
+
+	if (r->response != AVC_RESPONSE_ACCEPTED) {
+		dev_err(fdtv->device, "LNB control failed\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int avc_register_remote_control(struct firedtv *fdtv)
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_NOTIFY;
+	c->subunit = AVC_SUBUNIT_TYPE_UNIT | 7;
+	c->opcode  = AVC_OPCODE_VENDOR;
+
+	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
+	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
+	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
+	c->operand[3] = SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL;
+
+	c->length = 8;
+
+	return avc_write(fdtv, c, NULL);
+}
+
+void avc_remote_ctrl_work(struct work_struct *work)
+{
+	struct firedtv *fdtv =
+			container_of(work, struct firedtv, remote_ctrl_work);
+
+	/* Should it be rescheduled in failure cases? */
+	avc_register_remote_control(fdtv);
+}
+
+#if 0 /* FIXME: unused */
+int avc_tuner_host2ca(struct firedtv *fdtv)
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+	struct avc_response_frame *r = (void *)buffer; /* FIXME: unused */
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_CONTROL;
+	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
+	c->opcode  = AVC_OPCODE_VENDOR;
+
+	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
+	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
+	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
+	c->operand[3] = SFE_VENDOR_OPCODE_HOST2CA;
+	c->operand[4] = 0; /* slot */
+	c->operand[5] = SFE_VENDOR_TAG_CA_APPLICATION_INFO; /* ca tag */
+	c->operand[6] = 0; /* more/last */
+	c->operand[7] = 0; /* length */
+
+	c->length = 12;
+
+	if (avc_write(fdtv, c, r) < 0)
+		return -EIO;
+
+	return 0;
+}
+#endif
+
+static int get_ca_object_pos(struct avc_response_frame *r)
+{
+	int length = 1;
+
+	/* Check length of length field */
+	if (r->operand[7] & 0x80)
+		length = (r->operand[7] & 0x7f) + 1;
+	return length + 7;
+}
+
+static int get_ca_object_length(struct avc_response_frame *r)
+{
+#if 0 /* FIXME: unused */
+	int size = 0;
+	int i;
+
+	if (r->operand[7] & 0x80)
+		for (i = 0; i < (r->operand[7] & 0x7f); i++) {
+			size <<= 8;
+			size += r->operand[8 + i];
+		}
+#endif
+	return r->operand[7];
+}
+
+int avc_ca_app_info(struct firedtv *fdtv, char *app_info, unsigned int *len)
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+	struct avc_response_frame *r = (void *)buffer;
+	int pos;
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_STATUS;
+	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
+	c->opcode  = AVC_OPCODE_VENDOR;
+
+	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
+	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
+	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
+	c->operand[3] = SFE_VENDOR_OPCODE_CA2HOST;
+	c->operand[4] = 0; /* slot */
+	c->operand[5] = SFE_VENDOR_TAG_CA_APPLICATION_INFO; /* ca tag */
+
+	c->length = 12;
+
+	if (avc_write(fdtv, c, r) < 0)
+		return -EIO;
+
+	/* FIXME: check response code and validate response data */
+
+	pos = get_ca_object_pos(r);
+	app_info[0] = (EN50221_TAG_APP_INFO >> 16) & 0xff;
+	app_info[1] = (EN50221_TAG_APP_INFO >>  8) & 0xff;
+	app_info[2] = (EN50221_TAG_APP_INFO >>  0) & 0xff;
+	app_info[3] = 6 + r->operand[pos + 4];
+	app_info[4] = 0x01;
+	memcpy(&app_info[5], &r->operand[pos], 5 + r->operand[pos + 4]);
+	*len = app_info[3] + 4;
+
+	return 0;
+}
+
+int avc_ca_info(struct firedtv *fdtv, char *app_info, unsigned int *len)
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+	struct avc_response_frame *r = (void *)buffer;
+	int pos;
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_STATUS;
+	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
+	c->opcode  = AVC_OPCODE_VENDOR;
+
+	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
+	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
+	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
+	c->operand[3] = SFE_VENDOR_OPCODE_CA2HOST;
+	c->operand[4] = 0; /* slot */
+	c->operand[5] = SFE_VENDOR_TAG_CA_APPLICATION_INFO; /* ca tag */
+
+	c->length = 12;
+
+	if (avc_write(fdtv, c, r) < 0)
+		return -EIO;
+
+	pos = get_ca_object_pos(r);
+	app_info[0] = (EN50221_TAG_CA_INFO >> 16) & 0xff;
+	app_info[1] = (EN50221_TAG_CA_INFO >>  8) & 0xff;
+	app_info[2] = (EN50221_TAG_CA_INFO >>  0) & 0xff;
+	app_info[3] = 2;
+	app_info[4] = r->operand[pos + 0];
+	app_info[5] = r->operand[pos + 1];
+	*len = app_info[3] + 4;
+
+	return 0;
+}
+
+int avc_ca_reset(struct firedtv *fdtv)
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+	struct avc_response_frame *r = (void *)buffer; /* FIXME: unused */
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_CONTROL;
+	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
+	c->opcode  = AVC_OPCODE_VENDOR;
+
+	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
+	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
+	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
+	c->operand[3] = SFE_VENDOR_OPCODE_HOST2CA;
+	c->operand[4] = 0; /* slot */
+	c->operand[5] = SFE_VENDOR_TAG_CA_RESET; /* ca tag */
+	c->operand[6] = 0; /* more/last */
+	c->operand[7] = 1; /* length */
+	c->operand[8] = 0; /* force hardware reset */
+
+	c->length = 12;
+
+	if (avc_write(fdtv, c, r) < 0)
+		return -EIO;
+
+	return 0;
+}
+
+int avc_ca_pmt(struct firedtv *fdtv, char *msg, int length)
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+	struct avc_response_frame *r = (void *)buffer;
+	int list_management;
+	int program_info_length;
+	int pmt_cmd_id;
+	int read_pos;
+	int write_pos;
+	int es_info_length;
+	int crc32_csum;
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_CONTROL;
+	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
+	c->opcode  = AVC_OPCODE_VENDOR;
+
+	if (msg[0] != EN50221_LIST_MANAGEMENT_ONLY) {
+		dev_info(fdtv->device, "forcing list_management to ONLY\n");
+		msg[0] = EN50221_LIST_MANAGEMENT_ONLY;
+	}
+	/* We take the cmd_id from the programme level only! */
+	list_management = msg[0];
+	program_info_length = ((msg[4] & 0x0f) << 8) + msg[5];
+	if (program_info_length > 0)
+		program_info_length--; /* Remove pmt_cmd_id */
+	pmt_cmd_id = msg[6];
+
+	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
+	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
+	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
+	c->operand[3] = SFE_VENDOR_OPCODE_HOST2CA;
+	c->operand[4] = 0; /* slot */
+	c->operand[5] = SFE_VENDOR_TAG_CA_PMT; /* ca tag */
+	c->operand[6] = 0; /* more/last */
+	/* c->operand[7] = XXXprogram_info_length + 17; */ /* length */
+	c->operand[8] = list_management;
+	c->operand[9] = 0x01; /* pmt_cmd=OK_descramble */
+
+	/* TS program map table */
+
+	c->operand[10] = 0x02; /* Table id=2 */
+	c->operand[11] = 0x80; /* Section syntax + length */
+	/* c->operand[12] = XXXprogram_info_length + 12; */
+	c->operand[13] = msg[1]; /* Program number */
+	c->operand[14] = msg[2];
+	c->operand[15] = 0x01; /* Version number=0 + current/next=1 */
+	c->operand[16] = 0x00; /* Section number=0 */
+	c->operand[17] = 0x00; /* Last section number=0 */
+	c->operand[18] = 0x1f; /* PCR_PID=1FFF */
+	c->operand[19] = 0xff;
+	c->operand[20] = (program_info_length >> 8); /* Program info length */
+	c->operand[21] = (program_info_length & 0xff);
+
+	/* CA descriptors at programme level */
+	read_pos = 6;
+	write_pos = 22;
+	if (program_info_length > 0) {
+		pmt_cmd_id = msg[read_pos++];
+		if (pmt_cmd_id != 1 && pmt_cmd_id != 4)
+			dev_err(fdtv->device,
+				"invalid pmt_cmd_id %d\n", pmt_cmd_id);
+
+		memcpy(&c->operand[write_pos], &msg[read_pos],
+		       program_info_length);
+		read_pos += program_info_length;
+		write_pos += program_info_length;
+	}
+	while (read_pos < length) {
+		c->operand[write_pos++] = msg[read_pos++];
+		c->operand[write_pos++] = msg[read_pos++];
+		c->operand[write_pos++] = msg[read_pos++];
+		es_info_length =
+			((msg[read_pos] & 0x0f) << 8) + msg[read_pos + 1];
+		read_pos += 2;
+		if (es_info_length > 0)
+			es_info_length--; /* Remove pmt_cmd_id */
+		c->operand[write_pos++] = es_info_length >> 8;
+		c->operand[write_pos++] = es_info_length & 0xff;
+		if (es_info_length > 0) {
+			pmt_cmd_id = msg[read_pos++];
+			if (pmt_cmd_id != 1 && pmt_cmd_id != 4)
+				dev_err(fdtv->device, "invalid pmt_cmd_id %d "
+					"at stream level\n", pmt_cmd_id);
+
+			memcpy(&c->operand[write_pos], &msg[read_pos],
+			       es_info_length);
+			read_pos += es_info_length;
+			write_pos += es_info_length;
+		}
+	}
+
+	/* CRC */
+	c->operand[write_pos++] = 0x00;
+	c->operand[write_pos++] = 0x00;
+	c->operand[write_pos++] = 0x00;
+	c->operand[write_pos++] = 0x00;
+
+	c->operand[7] = write_pos - 8;
+	c->operand[12] = write_pos - 13;
+
+	crc32_csum = crc32_be(0, &c->operand[10], c->operand[12] - 1);
+	c->operand[write_pos - 4] = (crc32_csum >> 24) & 0xff;
+	c->operand[write_pos - 3] = (crc32_csum >> 16) & 0xff;
+	c->operand[write_pos - 2] = (crc32_csum >>  8) & 0xff;
+	c->operand[write_pos - 1] = (crc32_csum >>  0) & 0xff;
+
+	c->length = ALIGN(3 + write_pos, 4);
+
+	if (avc_write(fdtv, c, r) < 0)
+		return -EIO;
+
+	if (r->response != AVC_RESPONSE_ACCEPTED) {
+		dev_err(fdtv->device,
+			"CA PMT failed with response 0x%x\n", r->response);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+int avc_ca_get_time_date(struct firedtv *fdtv, int *interval)
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+	struct avc_response_frame *r = (void *)buffer;
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_STATUS;
+	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
+	c->opcode  = AVC_OPCODE_VENDOR;
+
+	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
+	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
+	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
+	c->operand[3] = SFE_VENDOR_OPCODE_CA2HOST;
+	c->operand[4] = 0; /* slot */
+	c->operand[5] = SFE_VENDOR_TAG_CA_DATE_TIME; /* ca tag */
+	c->operand[6] = 0; /* more/last */
+	c->operand[7] = 0; /* length */
+
+	c->length = 12;
+
+	if (avc_write(fdtv, c, r) < 0)
+		return -EIO;
+
+	/* FIXME: check response code and validate response data */
+
+	*interval = r->operand[get_ca_object_pos(r)];
+
+	return 0;
+}
+
+int avc_ca_enter_menu(struct firedtv *fdtv)
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+	struct avc_response_frame *r = (void *)buffer; /* FIXME: unused */
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_STATUS;
+	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
+	c->opcode  = AVC_OPCODE_VENDOR;
+
+	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
+	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
+	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
+	c->operand[3] = SFE_VENDOR_OPCODE_HOST2CA;
+	c->operand[4] = 0; /* slot */
+	c->operand[5] = SFE_VENDOR_TAG_CA_ENTER_MENU;
+	c->operand[6] = 0; /* more/last */
+	c->operand[7] = 0; /* length */
+
+	c->length = 12;
+
+	if (avc_write(fdtv, c, r) < 0)
+		return -EIO;
+
+	return 0;
+}
+
+int avc_ca_get_mmi(struct firedtv *fdtv, char *mmi_object, unsigned int *len)
+{
+	char buffer[sizeof(struct avc_command_frame)];
+	struct avc_command_frame *c = (void *)buffer;
+	struct avc_response_frame *r = (void *)buffer;
+
+	memset(c, 0, sizeof(*c));
+
+	c->ctype   = AVC_CTYPE_STATUS;
+	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
+	c->opcode  = AVC_OPCODE_VENDOR;
+
+	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
+	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
+	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
+	c->operand[3] = SFE_VENDOR_OPCODE_CA2HOST;
+	c->operand[4] = 0; /* slot */
+	c->operand[5] = SFE_VENDOR_TAG_CA_MMI;
+	c->operand[6] = 0; /* more/last */
+	c->operand[7] = 0; /* length */
+
+	c->length = 12;
+
+	if (avc_write(fdtv, c, r) < 0)
+		return -EIO;
+
+	/* FIXME: check response code and validate response data */
+
+	*len = get_ca_object_length(r);
+	memcpy(mmi_object, &r->operand[get_ca_object_pos(r)], *len);
+
+	return 0;
+}
+
+#define CMP_OUTPUT_PLUG_CONTROL_REG_0	0xfffff0000904ULL
+
+static int cmp_read(struct firedtv *fdtv, void *buf, u64 addr, size_t len)
+{
+	int ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
+
+	ret = fdtv->backend->read(fdtv, addr, buf, len);
+	if (ret < 0)
+		dev_err(fdtv->device, "CMP: read I/O error\n");
+
+	mutex_unlock(&fdtv->avc_mutex);
+	return ret;
+}
+
+static int cmp_lock(struct firedtv *fdtv, void *data, u64 addr, __be32 arg)
+{
+	int ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
+
+	ret = fdtv->backend->lock(fdtv, addr, data, arg);
+	if (ret < 0)
+		dev_err(fdtv->device, "CMP: lock I/O error\n");
+
+	mutex_unlock(&fdtv->avc_mutex);
+	return ret;
+}
+
+static inline u32 get_opcr(__be32 opcr, u32 mask, u32 shift)
+{
+	return (be32_to_cpu(opcr) >> shift) & mask;
+}
+
+static inline void set_opcr(__be32 *opcr, u32 value, u32 mask, u32 shift)
+{
+	*opcr &= ~cpu_to_be32(mask << shift);
+	*opcr |= cpu_to_be32((value & mask) << shift);
+}
+
+#define get_opcr_online(v)		get_opcr((v), 0x1, 31)
+#define get_opcr_p2p_connections(v)	get_opcr((v), 0x3f, 24)
+#define get_opcr_channel(v)		get_opcr((v), 0x3f, 16)
+
+#define set_opcr_p2p_connections(p, v)	set_opcr((p), (v), 0x3f, 24)
+#define set_opcr_channel(p, v)		set_opcr((p), (v), 0x3f, 16)
+#define set_opcr_data_rate(p, v)	set_opcr((p), (v), 0x3, 14)
+#define set_opcr_overhead_id(p, v)	set_opcr((p), (v), 0xf, 10)
+
+int cmp_establish_pp_connection(struct firedtv *fdtv, int plug, int channel)
+{
+	__be32 old_opcr, opcr;
+	u64 opcr_address = CMP_OUTPUT_PLUG_CONTROL_REG_0 + (plug << 2);
+	int attempts = 0;
+	int ret;
+
+	ret = cmp_read(fdtv, &opcr, opcr_address, 4);
+	if (ret < 0)
+		return ret;
+
+repeat:
+	if (!get_opcr_online(opcr)) {
+		dev_err(fdtv->device, "CMP: output offline\n");
+		return -EBUSY;
+	}
+
+	old_opcr = opcr;
+
+	if (get_opcr_p2p_connections(opcr)) {
+		if (get_opcr_channel(opcr) != channel) {
+			dev_err(fdtv->device, "CMP: cannot change channel\n");
+			return -EBUSY;
+		}
+		dev_info(fdtv->device, "CMP: overlaying connection\n");
+
+		/* We don't allocate isochronous resources. */
+	} else {
+		set_opcr_channel(&opcr, channel);
+		set_opcr_data_rate(&opcr, 2); /* S400 */
+
+		/* FIXME: this is for the worst case - optimize */
+		set_opcr_overhead_id(&opcr, 0);
+
+		/*
+		 * FIXME: allocate isochronous channel and bandwidth at IRM
+		 * fdtv->backend->alloc_resources(fdtv, channels_mask, bw);
+		 */
+	}
+
+	set_opcr_p2p_connections(&opcr, get_opcr_p2p_connections(opcr) + 1);
+
+	ret = cmp_lock(fdtv, &opcr, opcr_address, old_opcr);
+	if (ret < 0)
+		return ret;
+
+	if (old_opcr != opcr) {
+		/*
+		 * FIXME: if old_opcr.P2P_Connections > 0,
+		 * deallocate isochronous channel and bandwidth at IRM
+		 * if (...)
+		 *	fdtv->backend->dealloc_resources(fdtv, channel, bw);
+		 */
+
+		if (++attempts < 6) /* arbitrary limit */
+			goto repeat;
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+void cmp_break_pp_connection(struct firedtv *fdtv, int plug, int channel)
+{
+	__be32 old_opcr, opcr;
+	u64 opcr_address = CMP_OUTPUT_PLUG_CONTROL_REG_0 + (plug << 2);
+	int attempts = 0;
+
+	if (cmp_read(fdtv, &opcr, opcr_address, 4) < 0)
+		return;
+
+repeat:
+	if (!get_opcr_online(opcr) || !get_opcr_p2p_connections(opcr) ||
+	    get_opcr_channel(opcr) != channel) {
+		dev_err(fdtv->device, "CMP: no connection to break\n");
+		return;
+	}
+
+	old_opcr = opcr;
+	set_opcr_p2p_connections(&opcr, get_opcr_p2p_connections(opcr) - 1);
+
+	if (cmp_lock(fdtv, &opcr, opcr_address, old_opcr) < 0)
+		return;
+
+	if (old_opcr != opcr) {
+		/*
+		 * FIXME: if old_opcr.P2P_Connections == 1, i.e. we were last
+		 * owner, deallocate isochronous channel and bandwidth at IRM
+		 * if (...)
+		 *	fdtv->backend->dealloc_resources(fdtv, channel, bw);
+		 */
+
+		if (++attempts < 6) /* arbitrary limit */
+			goto repeat;
+	}
+}
diff --git a/drivers/media/dvb/firewire/firedtv-ci.c b/drivers/media/dvb/firewire/firedtv-ci.c
new file mode 100644
index 0000000..eeb80d0
--- /dev/null
+++ b/drivers/media/dvb/firewire/firedtv-ci.c
@@ -0,0 +1,260 @@
+/*
+ * FireDTV driver (formerly known as FireSAT)
+ *
+ * Copyright (C) 2004 Andreas Monitzer <andy@monitzer.com>
+ * Copyright (C) 2008 Henrik Kurelid <henrik@kurelid.se>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation; either version 2 of
+ *	the License, or (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/dvb/ca.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+
+#include <dvbdev.h>
+
+#include "firedtv.h"
+
+#define EN50221_TAG_APP_INFO_ENQUIRY	0x9f8020
+#define EN50221_TAG_CA_INFO_ENQUIRY	0x9f8030
+#define EN50221_TAG_CA_PMT		0x9f8032
+#define EN50221_TAG_ENTER_MENU		0x9f8022
+
+static int fdtv_ca_ready(struct firedtv_tuner_status *stat)
+{
+	return stat->ca_initialization_status	== 1 &&
+	       stat->ca_error_flag		== 0 &&
+	       stat->ca_dvb_flag		== 1 &&
+	       stat->ca_module_present_status	== 1;
+}
+
+static int fdtv_get_ca_flags(struct firedtv_tuner_status *stat)
+{
+	int flags = 0;
+
+	if (stat->ca_module_present_status == 1)
+		flags |= CA_CI_MODULE_PRESENT;
+	if (stat->ca_initialization_status == 1 &&
+	    stat->ca_error_flag            == 0 &&
+	    stat->ca_dvb_flag              == 1)
+		flags |= CA_CI_MODULE_READY;
+	return flags;
+}
+
+static int fdtv_ca_reset(struct firedtv *fdtv)
+{
+	return avc_ca_reset(fdtv) ? -EFAULT : 0;
+}
+
+static int fdtv_ca_get_caps(void *arg)
+{
+	struct ca_caps *cap = arg;
+
+	cap->slot_num = 1;
+	cap->slot_type = CA_CI;
+	cap->descr_num = 1;
+	cap->descr_type = CA_ECD;
+	return 0;
+}
+
+static int fdtv_ca_get_slot_info(struct firedtv *fdtv, void *arg)
+{
+	struct firedtv_tuner_status stat;
+	struct ca_slot_info *slot = arg;
+
+	if (avc_tuner_status(fdtv, &stat))
+		return -EFAULT;
+
+	if (slot->num != 0)
+		return -EFAULT;
+
+	slot->type = CA_CI;
+	slot->flags = fdtv_get_ca_flags(&stat);
+	return 0;
+}
+
+static int fdtv_ca_app_info(struct firedtv *fdtv, void *arg)
+{
+	struct ca_msg *reply = arg;
+
+	return avc_ca_app_info(fdtv, reply->msg, &reply->length) ? -EFAULT : 0;
+}
+
+static int fdtv_ca_info(struct firedtv *fdtv, void *arg)
+{
+	struct ca_msg *reply = arg;
+
+	return avc_ca_info(fdtv, reply->msg, &reply->length) ? -EFAULT : 0;
+}
+
+static int fdtv_ca_get_mmi(struct firedtv *fdtv, void *arg)
+{
+	struct ca_msg *reply = arg;
+
+	return avc_ca_get_mmi(fdtv, reply->msg, &reply->length) ? -EFAULT : 0;
+}
+
+static int fdtv_ca_get_msg(struct firedtv *fdtv, void *arg)
+{
+	struct firedtv_tuner_status stat;
+	int err;
+
+	switch (fdtv->ca_last_command) {
+	case EN50221_TAG_APP_INFO_ENQUIRY:
+		err = fdtv_ca_app_info(fdtv, arg);
+		break;
+	case EN50221_TAG_CA_INFO_ENQUIRY:
+		err = fdtv_ca_info(fdtv, arg);
+		break;
+	default:
+		if (avc_tuner_status(fdtv, &stat))
+			err = -EFAULT;
+		else if (stat.ca_mmi == 1)
+			err = fdtv_ca_get_mmi(fdtv, arg);
+		else {
+			dev_info(fdtv->device, "unhandled CA message 0x%08x\n",
+				 fdtv->ca_last_command);
+			err = -EFAULT;
+		}
+	}
+	fdtv->ca_last_command = 0;
+	return err;
+}
+
+static int fdtv_ca_pmt(struct firedtv *fdtv, void *arg)
+{
+	struct ca_msg *msg = arg;
+	int data_pos;
+	int data_length;
+	int i;
+
+	data_pos = 4;
+	if (msg->msg[3] & 0x80) {
+		data_length = 0;
+		for (i = 0; i < (msg->msg[3] & 0x7f); i++)
+			data_length = (data_length << 8) + msg->msg[data_pos++];
+	} else {
+		data_length = msg->msg[3];
+	}
+
+	return avc_ca_pmt(fdtv, &msg->msg[data_pos], data_length) ? -EFAULT : 0;
+}
+
+static int fdtv_ca_send_msg(struct firedtv *fdtv, void *arg)
+{
+	struct ca_msg *msg = arg;
+	int err;
+
+	/* Do we need a semaphore for this? */
+	fdtv->ca_last_command =
+		(msg->msg[0] << 16) + (msg->msg[1] << 8) + msg->msg[2];
+	switch (fdtv->ca_last_command) {
+	case EN50221_TAG_CA_PMT:
+		err = fdtv_ca_pmt(fdtv, arg);
+		break;
+	case EN50221_TAG_APP_INFO_ENQUIRY:
+		/* handled in ca_get_msg */
+		err = 0;
+		break;
+	case EN50221_TAG_CA_INFO_ENQUIRY:
+		/* handled in ca_get_msg */
+		err = 0;
+		break;
+	case EN50221_TAG_ENTER_MENU:
+		err = avc_ca_enter_menu(fdtv);
+		break;
+	default:
+		dev_err(fdtv->device, "unhandled CA message 0x%08x\n",
+			fdtv->ca_last_command);
+		err = -EFAULT;
+	}
+	return err;
+}
+
+static int fdtv_ca_ioctl(struct inode *inode, struct file *file,
+			    unsigned int cmd, void *arg)
+{
+	struct dvb_device *dvbdev = file->private_data;
+	struct firedtv *fdtv = dvbdev->priv;
+	struct firedtv_tuner_status stat;
+	int err;
+
+	switch (cmd) {
+	case CA_RESET:
+		err = fdtv_ca_reset(fdtv);
+		break;
+	case CA_GET_CAP:
+		err = fdtv_ca_get_caps(arg);
+		break;
+	case CA_GET_SLOT_INFO:
+		err = fdtv_ca_get_slot_info(fdtv, arg);
+		break;
+	case CA_GET_MSG:
+		err = fdtv_ca_get_msg(fdtv, arg);
+		break;
+	case CA_SEND_MSG:
+		err = fdtv_ca_send_msg(fdtv, arg);
+		break;
+	default:
+		dev_info(fdtv->device, "unhandled CA ioctl %u\n", cmd);
+		err = -EOPNOTSUPP;
+	}
+
+	/* FIXME Is this necessary? */
+	avc_tuner_status(fdtv, &stat);
+
+	return err;
+}
+
+static unsigned int fdtv_ca_io_poll(struct file *file, poll_table *wait)
+{
+	return POLLIN;
+}
+
+static struct file_operations fdtv_ca_fops = {
+	.owner		= THIS_MODULE,
+	.ioctl		= dvb_generic_ioctl,
+	.open		= dvb_generic_open,
+	.release	= dvb_generic_release,
+	.poll		= fdtv_ca_io_poll,
+};
+
+static struct dvb_device fdtv_ca = {
+	.users		= 1,
+	.readers	= 1,
+	.writers	= 1,
+	.fops		= &fdtv_ca_fops,
+	.kernel_ioctl	= fdtv_ca_ioctl,
+};
+
+int fdtv_ca_register(struct firedtv *fdtv)
+{
+	struct firedtv_tuner_status stat;
+	int err;
+
+	if (avc_tuner_status(fdtv, &stat))
+		return -EINVAL;
+
+	if (!fdtv_ca_ready(&stat))
+		return -EFAULT;
+
+	err = dvb_register_device(&fdtv->adapter, &fdtv->cadev,
+				  &fdtv_ca, fdtv, DVB_DEVICE_CA);
+
+	if (stat.ca_application_info == 0)
+		dev_err(fdtv->device, "CaApplicationInfo is not set\n");
+	if (stat.ca_date_time_request == 1)
+		avc_ca_get_time_date(fdtv, &fdtv->ca_time_interval);
+
+	return err;
+}
+
+void fdtv_ca_release(struct firedtv *fdtv)
+{
+	if (fdtv->cadev)
+		dvb_unregister_device(fdtv->cadev);
+}
diff --git a/drivers/media/dvb/firewire/firedtv-dvb.c b/drivers/media/dvb/firewire/firedtv-dvb.c
new file mode 100644
index 0000000..9d308dd
--- /dev/null
+++ b/drivers/media/dvb/firewire/firedtv-dvb.c
@@ -0,0 +1,364 @@
+/*
+ * FireDTV driver (formerly known as FireSAT)
+ *
+ * Copyright (C) 2004 Andreas Monitzer <andy@monitzer.com>
+ * Copyright (C) 2008 Henrik Kurelid <henrik@kurelid.se>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation; either version 2 of
+ *	the License, or (at your option) any later version.
+ */
+
+#include <linux/bitops.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+
+#include <dmxdev.h>
+#include <dvb_demux.h>
+#include <dvbdev.h>
+#include <dvb_frontend.h>
+
+#include "firedtv.h"
+
+static int alloc_channel(struct firedtv *fdtv)
+{
+	int i;
+
+	for (i = 0; i < 16; i++)
+		if (!__test_and_set_bit(i, &fdtv->channel_active))
+			break;
+	return i;
+}
+
+static void collect_channels(struct firedtv *fdtv, int *pidc, u16 pid[])
+{
+	int i, n;
+
+	for (i = 0, n = 0; i < 16; i++)
+		if (test_bit(i, &fdtv->channel_active))
+			pid[n++] = fdtv->channel_pid[i];
+	*pidc = n;
+}
+
+static inline void dealloc_channel(struct firedtv *fdtv, int i)
+{
+	__clear_bit(i, &fdtv->channel_active);
+}
+
+int fdtv_start_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
+	struct firedtv *fdtv = dvbdmxfeed->demux->priv;
+	int pidc, c, ret;
+	u16 pids[16];
+
+	switch (dvbdmxfeed->type) {
+	case DMX_TYPE_TS:
+	case DMX_TYPE_SEC:
+		break;
+	default:
+		dev_err(fdtv->device, "can't start dmx feed: invalid type %u\n",
+			dvbdmxfeed->type);
+		return -EINVAL;
+	}
+
+	if (mutex_lock_interruptible(&fdtv->demux_mutex))
+		return -EINTR;
+
+	if (dvbdmxfeed->type == DMX_TYPE_TS) {
+		switch (dvbdmxfeed->pes_type) {
+		case DMX_TS_PES_VIDEO:
+		case DMX_TS_PES_AUDIO:
+		case DMX_TS_PES_TELETEXT:
+		case DMX_TS_PES_PCR:
+		case DMX_TS_PES_OTHER:
+			c = alloc_channel(fdtv);
+			break;
+		default:
+			dev_err(fdtv->device,
+				"can't start dmx feed: invalid pes type %u\n",
+				dvbdmxfeed->pes_type);
+			ret = -EINVAL;
+			goto out;
+		}
+	} else {
+		c = alloc_channel(fdtv);
+	}
+
+	if (c > 15) {
+		dev_err(fdtv->device, "can't start dmx feed: busy\n");
+		ret = -EBUSY;
+		goto out;
+	}
+
+	dvbdmxfeed->priv = (typeof(dvbdmxfeed->priv))(unsigned long)c;
+	fdtv->channel_pid[c] = dvbdmxfeed->pid;
+	collect_channels(fdtv, &pidc, pids);
+
+	if (dvbdmxfeed->pid == 8192) {
+		ret = avc_tuner_get_ts(fdtv);
+		if (ret) {
+			dealloc_channel(fdtv, c);
+			dev_err(fdtv->device, "can't get TS\n");
+			goto out;
+		}
+	} else {
+		ret = avc_tuner_set_pids(fdtv, pidc, pids);
+		if (ret) {
+			dealloc_channel(fdtv, c);
+			dev_err(fdtv->device, "can't set PIDs\n");
+			goto out;
+		}
+	}
+out:
+	mutex_unlock(&fdtv->demux_mutex);
+
+	return ret;
+}
+
+int fdtv_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
+	struct dvb_demux *demux = dvbdmxfeed->demux;
+	struct firedtv *fdtv = demux->priv;
+	int pidc, c, ret;
+	u16 pids[16];
+
+	if (dvbdmxfeed->type == DMX_TYPE_TS &&
+	    !((dvbdmxfeed->ts_type & TS_PACKET) &&
+	      (demux->dmx.frontend->source != DMX_MEMORY_FE))) {
+
+		if (dvbdmxfeed->ts_type & TS_DECODER) {
+			if (dvbdmxfeed->pes_type >= DMX_TS_PES_OTHER ||
+			    !demux->pesfilter[dvbdmxfeed->pes_type])
+				return -EINVAL;
+
+			demux->pids[dvbdmxfeed->pes_type] |= 0x8000;
+			demux->pesfilter[dvbdmxfeed->pes_type] = NULL;
+		}
+
+		if (!(dvbdmxfeed->ts_type & TS_DECODER &&
+		      dvbdmxfeed->pes_type < DMX_TS_PES_OTHER))
+			return 0;
+	}
+
+	if (mutex_lock_interruptible(&fdtv->demux_mutex))
+		return -EINTR;
+
+	c = (unsigned long)dvbdmxfeed->priv;
+	dealloc_channel(fdtv, c);
+	collect_channels(fdtv, &pidc, pids);
+
+	ret = avc_tuner_set_pids(fdtv, pidc, pids);
+
+	mutex_unlock(&fdtv->demux_mutex);
+
+	return ret;
+}
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+int fdtv_dvb_register(struct firedtv *fdtv)
+{
+	int err;
+
+	err = dvb_register_adapter(&fdtv->adapter, fdtv_model_names[fdtv->type],
+				   THIS_MODULE, fdtv->device, adapter_nr);
+	if (err < 0)
+		goto fail_log;
+
+	/*DMX_TS_FILTERING | DMX_SECTION_FILTERING*/
+	fdtv->demux.dmx.capabilities = 0;
+
+	fdtv->demux.priv	= fdtv;
+	fdtv->demux.filternum	= 16;
+	fdtv->demux.feednum	= 16;
+	fdtv->demux.start_feed	= fdtv_start_feed;
+	fdtv->demux.stop_feed	= fdtv_stop_feed;
+	fdtv->demux.write_to_decoder = NULL;
+
+	err = dvb_dmx_init(&fdtv->demux);
+	if (err)
+		goto fail_unreg_adapter;
+
+	fdtv->dmxdev.filternum    = 16;
+	fdtv->dmxdev.demux        = &fdtv->demux.dmx;
+	fdtv->dmxdev.capabilities = 0;
+
+	err = dvb_dmxdev_init(&fdtv->dmxdev, &fdtv->adapter);
+	if (err)
+		goto fail_dmx_release;
+
+	fdtv->frontend.source = DMX_FRONTEND_0;
+
+	err = fdtv->demux.dmx.add_frontend(&fdtv->demux.dmx, &fdtv->frontend);
+	if (err)
+		goto fail_dmxdev_release;
+
+	err = fdtv->demux.dmx.connect_frontend(&fdtv->demux.dmx,
+					       &fdtv->frontend);
+	if (err)
+		goto fail_rem_frontend;
+
+	dvb_net_init(&fdtv->adapter, &fdtv->dvbnet, &fdtv->demux.dmx);
+
+	fdtv_frontend_init(fdtv);
+	err = dvb_register_frontend(&fdtv->adapter, &fdtv->fe);
+	if (err)
+		goto fail_net_release;
+
+	err = fdtv_ca_register(fdtv);
+	if (err)
+		dev_info(fdtv->device,
+			 "Conditional Access Module not enabled\n");
+	return 0;
+
+fail_net_release:
+	dvb_net_release(&fdtv->dvbnet);
+	fdtv->demux.dmx.close(&fdtv->demux.dmx);
+fail_rem_frontend:
+	fdtv->demux.dmx.remove_frontend(&fdtv->demux.dmx, &fdtv->frontend);
+fail_dmxdev_release:
+	dvb_dmxdev_release(&fdtv->dmxdev);
+fail_dmx_release:
+	dvb_dmx_release(&fdtv->demux);
+fail_unreg_adapter:
+	dvb_unregister_adapter(&fdtv->adapter);
+fail_log:
+	dev_err(fdtv->device, "DVB initialization failed\n");
+	return err;
+}
+
+void fdtv_dvb_unregister(struct firedtv *fdtv)
+{
+	fdtv_ca_release(fdtv);
+	dvb_unregister_frontend(&fdtv->fe);
+	dvb_net_release(&fdtv->dvbnet);
+	fdtv->demux.dmx.close(&fdtv->demux.dmx);
+	fdtv->demux.dmx.remove_frontend(&fdtv->demux.dmx, &fdtv->frontend);
+	dvb_dmxdev_release(&fdtv->dmxdev);
+	dvb_dmx_release(&fdtv->demux);
+	dvb_unregister_adapter(&fdtv->adapter);
+}
+
+const char *fdtv_model_names[] = {
+	[FIREDTV_UNKNOWN] = "unknown type",
+	[FIREDTV_DVB_S]   = "FireDTV S/CI",
+	[FIREDTV_DVB_C]   = "FireDTV C/CI",
+	[FIREDTV_DVB_T]   = "FireDTV T/CI",
+	[FIREDTV_DVB_S2]  = "FireDTV S2  ",
+};
+
+struct firedtv *fdtv_alloc(struct device *dev,
+			   const struct firedtv_backend *backend,
+			   const char *name, size_t name_len)
+{
+	struct firedtv *fdtv;
+	int i;
+
+	fdtv = kzalloc(sizeof(*fdtv), GFP_KERNEL);
+	if (!fdtv)
+		return NULL;
+
+	dev->driver_data	= fdtv;
+	fdtv->device		= dev;
+	fdtv->isochannel	= -1;
+	fdtv->voltage		= 0xff;
+	fdtv->tone		= 0xff;
+	fdtv->backend		= backend;
+
+	mutex_init(&fdtv->avc_mutex);
+	init_waitqueue_head(&fdtv->avc_wait);
+	fdtv->avc_reply_received = true;
+	mutex_init(&fdtv->demux_mutex);
+	INIT_WORK(&fdtv->remote_ctrl_work, avc_remote_ctrl_work);
+
+	for (i = ARRAY_SIZE(fdtv_model_names); --i; )
+		if (strlen(fdtv_model_names[i]) <= name_len &&
+		    strncmp(name, fdtv_model_names[i], name_len) == 0)
+			break;
+	fdtv->type = i;
+
+	return fdtv;
+}
+
+#define MATCH_FLAGS (IEEE1394_MATCH_VENDOR_ID | IEEE1394_MATCH_MODEL_ID | \
+		     IEEE1394_MATCH_SPECIFIER_ID | IEEE1394_MATCH_VERSION)
+
+#define DIGITAL_EVERYWHERE_OUI	0x001287
+#define AVC_UNIT_SPEC_ID_ENTRY	0x00a02d
+#define AVC_SW_VERSION_ENTRY	0x010001
+
+static struct ieee1394_device_id fdtv_id_table[] = {
+	{
+		/* FloppyDTV S/CI and FloppyDTV S2 */
+		.match_flags	= MATCH_FLAGS,
+		.vendor_id	= DIGITAL_EVERYWHERE_OUI,
+		.model_id	= 0x000024,
+		.specifier_id	= AVC_UNIT_SPEC_ID_ENTRY,
+		.version	= AVC_SW_VERSION_ENTRY,
+	}, {
+		/* FloppyDTV T/CI */
+		.match_flags	= MATCH_FLAGS,
+		.vendor_id	= DIGITAL_EVERYWHERE_OUI,
+		.model_id	= 0x000025,
+		.specifier_id	= AVC_UNIT_SPEC_ID_ENTRY,
+		.version	= AVC_SW_VERSION_ENTRY,
+	}, {
+		/* FloppyDTV C/CI */
+		.match_flags	= MATCH_FLAGS,
+		.vendor_id	= DIGITAL_EVERYWHERE_OUI,
+		.model_id	= 0x000026,
+		.specifier_id	= AVC_UNIT_SPEC_ID_ENTRY,
+		.version	= AVC_SW_VERSION_ENTRY,
+	}, {
+		/* FireDTV S/CI and FloppyDTV S2 */
+		.match_flags	= MATCH_FLAGS,
+		.vendor_id	= DIGITAL_EVERYWHERE_OUI,
+		.model_id	= 0x000034,
+		.specifier_id	= AVC_UNIT_SPEC_ID_ENTRY,
+		.version	= AVC_SW_VERSION_ENTRY,
+	}, {
+		/* FireDTV T/CI */
+		.match_flags	= MATCH_FLAGS,
+		.vendor_id	= DIGITAL_EVERYWHERE_OUI,
+		.model_id	= 0x000035,
+		.specifier_id	= AVC_UNIT_SPEC_ID_ENTRY,
+		.version	= AVC_SW_VERSION_ENTRY,
+	}, {
+		/* FireDTV C/CI */
+		.match_flags	= MATCH_FLAGS,
+		.vendor_id	= DIGITAL_EVERYWHERE_OUI,
+		.model_id	= 0x000036,
+		.specifier_id	= AVC_UNIT_SPEC_ID_ENTRY,
+		.version	= AVC_SW_VERSION_ENTRY,
+	}, {}
+};
+MODULE_DEVICE_TABLE(ieee1394, fdtv_id_table);
+
+static int __init fdtv_init(void)
+{
+	return fdtv_1394_init(fdtv_id_table);
+}
+
+static void __exit fdtv_exit(void)
+{
+	fdtv_1394_exit();
+}
+
+module_init(fdtv_init);
+module_exit(fdtv_exit);
+
+MODULE_AUTHOR("Andreas Monitzer <andy@monitzer.com>");
+MODULE_AUTHOR("Ben Backx <ben@bbackx.com>");
+MODULE_DESCRIPTION("FireDTV DVB Driver");
+MODULE_LICENSE("GPL");
+MODULE_SUPPORTED_DEVICE("FireDTV DVB");
diff --git a/drivers/media/dvb/firewire/firedtv-fe.c b/drivers/media/dvb/firewire/firedtv-fe.c
new file mode 100644
index 0000000..9b9539c
--- /dev/null
+++ b/drivers/media/dvb/firewire/firedtv-fe.c
@@ -0,0 +1,246 @@
+/*
+ * FireDTV driver (formerly known as FireSAT)
+ *
+ * Copyright (C) 2004 Andreas Monitzer <andy@monitzer.com>
+ * Copyright (C) 2008 Henrik Kurelid <henrik@kurelid.se>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation; either version 2 of
+ *	the License, or (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <dvb_frontend.h>
+
+#include "firedtv.h"
+
+static int fdtv_dvb_init(struct dvb_frontend *fe)
+{
+	struct firedtv *fdtv = fe->sec_priv;
+	int err;
+
+	/* FIXME - allocate free channel at IRM */
+	fdtv->isochannel = fdtv->adapter.num;
+
+	err = cmp_establish_pp_connection(fdtv, fdtv->subunit,
+					  fdtv->isochannel);
+	if (err) {
+		dev_err(fdtv->device,
+			"could not establish point to point connection\n");
+		return err;
+	}
+
+	return fdtv->backend->start_iso(fdtv);
+}
+
+static int fdtv_sleep(struct dvb_frontend *fe)
+{
+	struct firedtv *fdtv = fe->sec_priv;
+
+	fdtv->backend->stop_iso(fdtv);
+	cmp_break_pp_connection(fdtv, fdtv->subunit, fdtv->isochannel);
+	fdtv->isochannel = -1;
+	return 0;
+}
+
+#define LNBCONTROL_DONTCARE 0xff
+
+static int fdtv_diseqc_send_master_cmd(struct dvb_frontend *fe,
+				       struct dvb_diseqc_master_cmd *cmd)
+{
+	struct firedtv *fdtv = fe->sec_priv;
+
+	return avc_lnb_control(fdtv, LNBCONTROL_DONTCARE, LNBCONTROL_DONTCARE,
+			       LNBCONTROL_DONTCARE, 1, cmd);
+}
+
+static int fdtv_diseqc_send_burst(struct dvb_frontend *fe,
+				  fe_sec_mini_cmd_t minicmd)
+{
+	return 0;
+}
+
+static int fdtv_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
+{
+	struct firedtv *fdtv = fe->sec_priv;
+
+	fdtv->tone = tone;
+	return 0;
+}
+
+static int fdtv_set_voltage(struct dvb_frontend *fe,
+			    fe_sec_voltage_t voltage)
+{
+	struct firedtv *fdtv = fe->sec_priv;
+
+	fdtv->voltage = voltage;
+	return 0;
+}
+
+static int fdtv_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct firedtv *fdtv = fe->sec_priv;
+	struct firedtv_tuner_status stat;
+
+	if (avc_tuner_status(fdtv, &stat))
+		return -EINVAL;
+
+	if (stat.no_rf)
+		*status = 0;
+	else
+		*status = FE_HAS_SIGNAL | FE_HAS_VITERBI | FE_HAS_SYNC |
+			  FE_HAS_CARRIER | FE_HAS_LOCK;
+	return 0;
+}
+
+static int fdtv_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct firedtv *fdtv = fe->sec_priv;
+	struct firedtv_tuner_status stat;
+
+	if (avc_tuner_status(fdtv, &stat))
+		return -EINVAL;
+
+	*ber = stat.ber;
+	return 0;
+}
+
+static int fdtv_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
+{
+	struct firedtv *fdtv = fe->sec_priv;
+	struct firedtv_tuner_status stat;
+
+	if (avc_tuner_status(fdtv, &stat))
+		return -EINVAL;
+
+	*strength = stat.signal_strength << 8;
+	return 0;
+}
+
+static int fdtv_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct firedtv *fdtv = fe->sec_priv;
+	struct firedtv_tuner_status stat;
+
+	if (avc_tuner_status(fdtv, &stat))
+		return -EINVAL;
+
+	/* C/N[dB] = -10 * log10(snr / 65535) */
+	*snr = stat.carrier_noise_ratio * 257;
+	return 0;
+}
+
+static int fdtv_read_uncorrected_blocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	return -EOPNOTSUPP;
+}
+
+#define ACCEPTED 0x9
+
+static int fdtv_set_frontend(struct dvb_frontend *fe,
+			     struct dvb_frontend_parameters *params)
+{
+	struct firedtv *fdtv = fe->sec_priv;
+
+	/* FIXME: avc_tuner_dsd never returns ACCEPTED. Check status? */
+	if (avc_tuner_dsd(fdtv, params) != ACCEPTED)
+		return -EINVAL;
+	else
+		return 0; /* not sure of this... */
+}
+
+static int fdtv_get_frontend(struct dvb_frontend *fe,
+			     struct dvb_frontend_parameters *params)
+{
+	return -EOPNOTSUPP;
+}
+
+void fdtv_frontend_init(struct firedtv *fdtv)
+{
+	struct dvb_frontend_ops *ops = &fdtv->fe.ops;
+	struct dvb_frontend_info *fi = &ops->info;
+
+	ops->init			= fdtv_dvb_init;
+	ops->sleep			= fdtv_sleep;
+
+	ops->set_frontend		= fdtv_set_frontend;
+	ops->get_frontend		= fdtv_get_frontend;
+
+	ops->read_status		= fdtv_read_status;
+	ops->read_ber			= fdtv_read_ber;
+	ops->read_signal_strength	= fdtv_read_signal_strength;
+	ops->read_snr			= fdtv_read_snr;
+	ops->read_ucblocks		= fdtv_read_uncorrected_blocks;
+
+	ops->diseqc_send_master_cmd 	= fdtv_diseqc_send_master_cmd;
+	ops->diseqc_send_burst		= fdtv_diseqc_send_burst;
+	ops->set_tone			= fdtv_set_tone;
+	ops->set_voltage		= fdtv_set_voltage;
+
+	switch (fdtv->type) {
+	case FIREDTV_DVB_S:
+		fi->type		= FE_QPSK;
+
+		fi->frequency_min	= 950000;
+		fi->frequency_max	= 2150000;
+		fi->frequency_stepsize	= 125;
+		fi->symbol_rate_min	= 1000000;
+		fi->symbol_rate_max	= 40000000;
+
+		fi->caps 		= FE_CAN_INVERSION_AUTO	|
+					  FE_CAN_FEC_1_2	|
+					  FE_CAN_FEC_2_3	|
+					  FE_CAN_FEC_3_4	|
+					  FE_CAN_FEC_5_6	|
+					  FE_CAN_FEC_7_8	|
+					  FE_CAN_FEC_AUTO	|
+					  FE_CAN_QPSK;
+		break;
+
+	case FIREDTV_DVB_C:
+		fi->type		= FE_QAM;
+
+		fi->frequency_min	= 47000000;
+		fi->frequency_max	= 866000000;
+		fi->frequency_stepsize	= 62500;
+		fi->symbol_rate_min	= 870000;
+		fi->symbol_rate_max	= 6900000;
+
+		fi->caps 		= FE_CAN_INVERSION_AUTO |
+					  FE_CAN_QAM_16		|
+					  FE_CAN_QAM_32		|
+					  FE_CAN_QAM_64		|
+					  FE_CAN_QAM_128	|
+					  FE_CAN_QAM_256	|
+					  FE_CAN_QAM_AUTO;
+		break;
+
+	case FIREDTV_DVB_T:
+		fi->type		= FE_OFDM;
+
+		fi->frequency_min	= 49000000;
+		fi->frequency_max	= 861000000;
+		fi->frequency_stepsize	= 62500;
+
+		fi->caps 		= FE_CAN_INVERSION_AUTO		|
+					  FE_CAN_FEC_2_3		|
+					  FE_CAN_TRANSMISSION_MODE_AUTO |
+					  FE_CAN_GUARD_INTERVAL_AUTO	|
+					  FE_CAN_HIERARCHY_AUTO;
+		break;
+
+	default:
+		dev_err(fdtv->device, "no frontend for model type %d\n",
+			fdtv->type);
+	}
+	strcpy(fi->name, fdtv_model_names[fdtv->type]);
+
+	fdtv->fe.dvb = &fdtv->adapter;
+	fdtv->fe.sec_priv = fdtv;
+}
diff --git a/drivers/media/dvb/firewire/firedtv-rc.c b/drivers/media/dvb/firewire/firedtv-rc.c
new file mode 100644
index 0000000..46a6324
--- /dev/null
+++ b/drivers/media/dvb/firewire/firedtv-rc.c
@@ -0,0 +1,190 @@
+/*
+ * FireDTV driver (formerly known as FireSAT)
+ *
+ * Copyright (C) 2004 Andreas Monitzer <andy@monitzer.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation; either version 2 of
+ *	the License, or (at your option) any later version.
+ */
+
+#include <linux/bitops.h>
+#include <linux/input.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include "firedtv.h"
+
+/* fixed table with older keycodes, geared towards MythTV */
+const static u16 oldtable[] = {
+
+	/* code from device: 0x4501...0x451f */
+
+	KEY_ESC,
+	KEY_F9,
+	KEY_1,
+	KEY_2,
+	KEY_3,
+	KEY_4,
+	KEY_5,
+	KEY_6,
+	KEY_7,
+	KEY_8,
+	KEY_9,
+	KEY_I,
+	KEY_0,
+	KEY_ENTER,
+	KEY_RED,
+	KEY_UP,
+	KEY_GREEN,
+	KEY_F10,
+	KEY_SPACE,
+	KEY_F11,
+	KEY_YELLOW,
+	KEY_DOWN,
+	KEY_BLUE,
+	KEY_Z,
+	KEY_P,
+	KEY_PAGEDOWN,
+	KEY_LEFT,
+	KEY_W,
+	KEY_RIGHT,
+	KEY_P,
+	KEY_M,
+
+	/* code from device: 0x4540...0x4542 */
+
+	KEY_R,
+	KEY_V,
+	KEY_C,
+};
+
+/* user-modifiable table for a remote as sold in 2008 */
+const static u16 keytable[] = {
+
+	/* code from device: 0x0300...0x031f */
+
+	[0x00] = KEY_POWER,
+	[0x01] = KEY_SLEEP,
+	[0x02] = KEY_STOP,
+	[0x03] = KEY_OK,
+	[0x04] = KEY_RIGHT,
+	[0x05] = KEY_1,
+	[0x06] = KEY_2,
+	[0x07] = KEY_3,
+	[0x08] = KEY_LEFT,
+	[0x09] = KEY_4,
+	[0x0a] = KEY_5,
+	[0x0b] = KEY_6,
+	[0x0c] = KEY_UP,
+	[0x0d] = KEY_7,
+	[0x0e] = KEY_8,
+	[0x0f] = KEY_9,
+	[0x10] = KEY_DOWN,
+	[0x11] = KEY_TITLE,	/* "OSD" - fixme */
+	[0x12] = KEY_0,
+	[0x13] = KEY_F20,	/* "16:9" - fixme */
+	[0x14] = KEY_SCREEN,	/* "FULL" - fixme */
+	[0x15] = KEY_MUTE,
+	[0x16] = KEY_SUBTITLE,
+	[0x17] = KEY_RECORD,
+	[0x18] = KEY_TEXT,
+	[0x19] = KEY_AUDIO,
+	[0x1a] = KEY_RED,
+	[0x1b] = KEY_PREVIOUS,
+	[0x1c] = KEY_REWIND,
+	[0x1d] = KEY_PLAYPAUSE,
+	[0x1e] = KEY_NEXT,
+	[0x1f] = KEY_VOLUMEUP,
+
+	/* code from device: 0x0340...0x0354 */
+
+	[0x20] = KEY_CHANNELUP,
+	[0x21] = KEY_F21,	/* "4:3" - fixme */
+	[0x22] = KEY_TV,
+	[0x23] = KEY_DVD,
+	[0x24] = KEY_VCR,
+	[0x25] = KEY_AUX,
+	[0x26] = KEY_GREEN,
+	[0x27] = KEY_YELLOW,
+	[0x28] = KEY_BLUE,
+	[0x29] = KEY_CHANNEL,	/* "CH.LIST" */
+	[0x2a] = KEY_VENDOR,	/* "CI" - fixme */
+	[0x2b] = KEY_VOLUMEDOWN,
+	[0x2c] = KEY_CHANNELDOWN,
+	[0x2d] = KEY_LAST,
+	[0x2e] = KEY_INFO,
+	[0x2f] = KEY_FORWARD,
+	[0x30] = KEY_LIST,
+	[0x31] = KEY_FAVORITES,
+	[0x32] = KEY_MENU,
+	[0x33] = KEY_EPG,
+	[0x34] = KEY_EXIT,
+};
+
+int fdtv_register_rc(struct firedtv *fdtv, struct device *dev)
+{
+	struct input_dev *idev;
+	int i, err;
+
+	idev = input_allocate_device();
+	if (!idev)
+		return -ENOMEM;
+
+	fdtv->remote_ctrl_dev = idev;
+	idev->name = "FireDTV remote control";
+	idev->dev.parent = dev;
+	idev->evbit[0] = BIT_MASK(EV_KEY);
+	idev->keycode = kmemdup(keytable, sizeof(keytable), GFP_KERNEL);
+	if (!idev->keycode) {
+		err = -ENOMEM;
+		goto fail;
+	}
+	idev->keycodesize = sizeof(keytable[0]);
+	idev->keycodemax = ARRAY_SIZE(keytable);
+
+	for (i = 0; i < ARRAY_SIZE(keytable); i++)
+		set_bit(keytable[i], idev->keybit);
+
+	err = input_register_device(idev);
+	if (err)
+		goto fail_free_keymap;
+
+	return 0;
+
+fail_free_keymap:
+	kfree(idev->keycode);
+fail:
+	input_free_device(idev);
+	return err;
+}
+
+void fdtv_unregister_rc(struct firedtv *fdtv)
+{
+	kfree(fdtv->remote_ctrl_dev->keycode);
+	input_unregister_device(fdtv->remote_ctrl_dev);
+}
+
+void fdtv_handle_rc(struct firedtv *fdtv, unsigned int code)
+{
+	u16 *keycode = fdtv->remote_ctrl_dev->keycode;
+
+	if (code >= 0x0300 && code <= 0x031f)
+		code = keycode[code - 0x0300];
+	else if (code >= 0x0340 && code <= 0x0354)
+		code = keycode[code - 0x0320];
+	else if (code >= 0x4501 && code <= 0x451f)
+		code = oldtable[code - 0x4501];
+	else if (code >= 0x4540 && code <= 0x4542)
+		code = oldtable[code - 0x4521];
+	else {
+		printk(KERN_DEBUG "firedtv: invalid key code 0x%04x "
+		       "from remote control\n", code);
+		return;
+	}
+
+	input_report_key(fdtv->remote_ctrl_dev, code, 1);
+	input_report_key(fdtv->remote_ctrl_dev, code, 0);
+}
diff --git a/drivers/media/dvb/firewire/firedtv.h b/drivers/media/dvb/firewire/firedtv.h
new file mode 100644
index 0000000..d48530b
--- /dev/null
+++ b/drivers/media/dvb/firewire/firedtv.h
@@ -0,0 +1,182 @@
+/*
+ * FireDTV driver (formerly known as FireSAT)
+ *
+ * Copyright (C) 2004 Andreas Monitzer <andy@monitzer.com>
+ * Copyright (C) 2008 Henrik Kurelid <henrik@kurelid.se>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation; either version 2 of
+ *	the License, or (at your option) any later version.
+ */
+
+#ifndef _FIREDTV_H
+#define _FIREDTV_H
+
+#include <linux/dvb/dmx.h>
+#include <linux/dvb/frontend.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spinlock_types.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+
+#include <demux.h>
+#include <dmxdev.h>
+#include <dvb_demux.h>
+#include <dvb_frontend.h>
+#include <dvb_net.h>
+#include <dvbdev.h>
+
+struct firedtv_tuner_status {
+	unsigned active_system:8;
+	unsigned searching:1;
+	unsigned moving:1;
+	unsigned no_rf:1;
+	unsigned input:1;
+	unsigned selected_antenna:7;
+	unsigned ber:32;
+	unsigned signal_strength:8;
+	unsigned raster_frequency:2;
+	unsigned rf_frequency:22;
+	unsigned man_dep_info_length:8;
+	unsigned front_end_error:1;
+	unsigned antenna_error:1;
+	unsigned front_end_power_status:1;
+	unsigned power_supply:1;
+	unsigned carrier_noise_ratio:16;
+	unsigned power_supply_voltage:8;
+	unsigned antenna_voltage:8;
+	unsigned firewire_bus_voltage:8;
+	unsigned ca_mmi:1;
+	unsigned ca_pmt_reply:1;
+	unsigned ca_date_time_request:1;
+	unsigned ca_application_info:1;
+	unsigned ca_module_present_status:1;
+	unsigned ca_dvb_flag:1;
+	unsigned ca_error_flag:1;
+	unsigned ca_initialization_status:1;
+};
+
+enum model_type {
+	FIREDTV_UNKNOWN = 0,
+	FIREDTV_DVB_S   = 1,
+	FIREDTV_DVB_C   = 2,
+	FIREDTV_DVB_T   = 3,
+	FIREDTV_DVB_S2  = 4,
+};
+
+struct device;
+struct input_dev;
+struct firedtv;
+
+struct firedtv_backend {
+	int (*lock)(struct firedtv *fdtv, u64 addr, void *data, __be32 arg);
+	int (*read)(struct firedtv *fdtv, u64 addr, void *data, size_t len);
+	int (*write)(struct firedtv *fdtv, u64 addr, void *data, size_t len);
+	int (*start_iso)(struct firedtv *fdtv);
+	void (*stop_iso)(struct firedtv *fdtv);
+};
+
+struct firedtv {
+	struct device *device;
+	struct list_head list;
+
+	struct dvb_adapter	adapter;
+	struct dmxdev		dmxdev;
+	struct dvb_demux	demux;
+	struct dmx_frontend	frontend;
+	struct dvb_net		dvbnet;
+	struct dvb_frontend	fe;
+
+	struct dvb_device	*cadev;
+	int			ca_last_command;
+	int			ca_time_interval;
+
+	struct mutex		avc_mutex;
+	wait_queue_head_t	avc_wait;
+	bool			avc_reply_received;
+	struct work_struct	remote_ctrl_work;
+	struct input_dev	*remote_ctrl_dev;
+
+	enum model_type		type;
+	char			subunit;
+	char			isochannel;
+	fe_sec_voltage_t	voltage;
+	fe_sec_tone_mode_t	tone;
+
+	const struct firedtv_backend *backend;
+	void			*backend_data;
+
+	struct mutex		demux_mutex;
+	unsigned long		channel_active;
+	u16			channel_pid[16];
+
+	size_t			response_length;
+	u8			response[512];
+};
+
+/* firedtv-1394.c */
+#ifdef CONFIG_DVB_FIREDTV_IEEE1394
+int fdtv_1394_init(struct ieee1394_device_id id_table[]);
+void fdtv_1394_exit(void);
+#else
+static inline int fdtv_1394_init(struct ieee1394_device_id it[]) { return 0; }
+static inline void fdtv_1394_exit(void) {}
+#endif
+
+/* firedtv-avc.c */
+int avc_recv(struct firedtv *fdtv, void *data, size_t length);
+int avc_tuner_status(struct firedtv *fdtv, struct firedtv_tuner_status *stat);
+struct dvb_frontend_parameters;
+int avc_tuner_dsd(struct firedtv *fdtv, struct dvb_frontend_parameters *params);
+int avc_tuner_set_pids(struct firedtv *fdtv, unsigned char pidc, u16 pid[]);
+int avc_tuner_get_ts(struct firedtv *fdtv);
+int avc_identify_subunit(struct firedtv *fdtv);
+struct dvb_diseqc_master_cmd;
+int avc_lnb_control(struct firedtv *fdtv, char voltage, char burst,
+		    char conttone, char nrdiseq,
+		    struct dvb_diseqc_master_cmd *diseqcmd);
+void avc_remote_ctrl_work(struct work_struct *work);
+int avc_register_remote_control(struct firedtv *fdtv);
+int avc_ca_app_info(struct firedtv *fdtv, char *app_info, unsigned int *len);
+int avc_ca_info(struct firedtv *fdtv, char *app_info, unsigned int *len);
+int avc_ca_reset(struct firedtv *fdtv);
+int avc_ca_pmt(struct firedtv *fdtv, char *app_info, int length);
+int avc_ca_get_time_date(struct firedtv *fdtv, int *interval);
+int avc_ca_enter_menu(struct firedtv *fdtv);
+int avc_ca_get_mmi(struct firedtv *fdtv, char *mmi_object, unsigned int *len);
+int cmp_establish_pp_connection(struct firedtv *fdtv, int plug, int channel);
+void cmp_break_pp_connection(struct firedtv *fdtv, int plug, int channel);
+
+/* firedtv-ci.c */
+int fdtv_ca_register(struct firedtv *fdtv);
+void fdtv_ca_release(struct firedtv *fdtv);
+
+/* firedtv-dvb.c */
+int fdtv_start_feed(struct dvb_demux_feed *dvbdmxfeed);
+int fdtv_stop_feed(struct dvb_demux_feed *dvbdmxfeed);
+int fdtv_dvb_register(struct firedtv *fdtv);
+void fdtv_dvb_unregister(struct firedtv *fdtv);
+struct firedtv *fdtv_alloc(struct device *dev,
+			   const struct firedtv_backend *backend,
+			   const char *name, size_t name_len);
+extern const char *fdtv_model_names[];
+
+/* firedtv-fe.c */
+void fdtv_frontend_init(struct firedtv *fdtv);
+
+/* firedtv-rc.c */
+#ifdef CONFIG_DVB_FIREDTV_INPUT
+int fdtv_register_rc(struct firedtv *fdtv, struct device *dev);
+void fdtv_unregister_rc(struct firedtv *fdtv);
+void fdtv_handle_rc(struct firedtv *fdtv, unsigned int code);
+#else
+static inline int fdtv_register_rc(struct firedtv *fdtv,
+				   struct device *dev) { return 0; }
+static inline void fdtv_unregister_rc(struct firedtv *fdtv) {}
+static inline void fdtv_handle_rc(struct firedtv *fdtv, unsigned int code) {}
+#endif
+
+#endif /* _FIREDTV_H */

-- 
Stefan Richter
-=====-==--= --=- =----
http://arcgraph.de/sr/

