Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36337 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbZKHVbC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 16:31:02 -0500
Date: Sun, 8 Nov 2009 22:30:54 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/4] firedtv: port to new firewire core
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ce889fb60854a648@s5r6.in-berlin.de>
Message-ID: <tkrat.98bddb190a0431be@s5r6.in-berlin.de>
References: <tkrat.ce889fb60854a648@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The firedtv DVB driver will now work not only on top of the old ieee1394
driver stack but also on the new firewire driver stack.

Alongside to the firedtv-1394.c backend for driver binding and I/O, the
firedtv-fw.c backend is added.  Depending on which of the two 1394
stacks is configured, one or the other or both backends will be built
into the firedtv driver.

This has been tested with a DVB-T and a DVB-C box on x86-64 and x86-32
together with a few different controllers (Agere FW323, a NEC chip, TI
TSB82AA2, TSB43AB22/A, VIA VT6306).

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/Kconfig        |    7 +
 drivers/media/dvb/firewire/Makefile       |    1 +
 drivers/media/dvb/firewire/firedtv-1394.c |    6 
 drivers/media/dvb/firewire/firedtv-dvb.c  |   15 +
 drivers/media/dvb/firewire/firedtv-fw.c   |  385 ++++++++++++++++++++++
 drivers/media/dvb/firewire/firedtv.h      |   15 +
 6 files changed, 420 insertions(+), 9 deletions(-)

Index: linux-2.6.31.4/drivers/media/dvb/firewire/Kconfig
===================================================================
--- linux-2.6.31.4.orig/drivers/media/dvb/firewire/Kconfig
+++ linux-2.6.31.4/drivers/media/dvb/firewire/Kconfig
@@ -1,6 +1,6 @@
 config DVB_FIREDTV
 	tristate "FireDTV and FloppyDTV"
-	depends on DVB_CORE && IEEE1394
+	depends on DVB_CORE && (FIREWIRE || IEEE1394)
 	help
 	  Support for DVB receivers from Digital Everywhere
 	  which are connected via IEEE 1394 (FireWire).
@@ -13,8 +13,11 @@ config DVB_FIREDTV
 
 if DVB_FIREDTV
 
+config DVB_FIREDTV_FIREWIRE
+	def_bool FIREWIRE = y || (FIREWIRE = m && DVB_FIREDTV = m)
+
 config DVB_FIREDTV_IEEE1394
-	def_bool IEEE1394
+	def_bool IEEE1394 = y || (IEEE1394 = m && DVB_FIREDTV = m)
 
 config DVB_FIREDTV_INPUT
 	def_bool INPUT = y || (INPUT = m && DVB_FIREDTV = m)
Index: linux-2.6.31.4/drivers/media/dvb/firewire/Makefile
===================================================================
--- linux-2.6.31.4.orig/drivers/media/dvb/firewire/Makefile
+++ linux-2.6.31.4/drivers/media/dvb/firewire/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_DVB_FIREDTV) += firedtv.o
 
 firedtv-y := firedtv-avc.o firedtv-ci.o firedtv-dvb.o firedtv-fe.o
+firedtv-$(CONFIG_DVB_FIREDTV_FIREWIRE) += firedtv-fw.o
 firedtv-$(CONFIG_DVB_FIREDTV_IEEE1394) += firedtv-1394.o
 firedtv-$(CONFIG_DVB_FIREDTV_INPUT)    += firedtv-rc.o
 
Index: linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-1394.c
===================================================================
--- linux-2.6.31.4.orig/drivers/media/dvb/firewire/firedtv-1394.c
+++ linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-1394.c
@@ -1,5 +1,5 @@
 /*
- * FireDTV driver (formerly known as FireSAT)
+ * FireDTV driver -- ieee1394 I/O backend
  *
  * Copyright (C) 2004 Andreas Monitzer <andy@monitzer.com>
  * Copyright (C) 2007-2008 Ben Backx <ben@bbackx.com>
@@ -261,6 +261,7 @@ static int node_update(struct unit_direc
 
 static struct hpsb_protocol_driver fdtv_driver = {
 	.name		= "firedtv",
+	.id_table	= fdtv_id_table,
 	.update		= node_update,
 	.driver         = {
 		.probe  = node_probe,
@@ -273,12 +274,11 @@ static struct hpsb_highlevel fdtv_highle
 	.fcp_request	= fcp_request,
 };
 
-int __init fdtv_1394_init(struct ieee1394_device_id id_table[])
+int __init fdtv_1394_init(void)
 {
 	int ret;
 
 	hpsb_register_highlevel(&fdtv_highlevel);
-	fdtv_driver.id_table = id_table;
 	ret = hpsb_register_protocol(&fdtv_driver);
 	if (ret) {
 		printk(KERN_ERR "firedtv: failed to register protocol\n");
Index: linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-dvb.c
===================================================================
--- linux-2.6.31.4.orig/drivers/media/dvb/firewire/firedtv-dvb.c
+++ linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-dvb.c
@@ -297,7 +297,7 @@ struct firedtv *fdtv_alloc(struct device
 #define AVC_UNIT_SPEC_ID_ENTRY	0x00a02d
 #define AVC_SW_VERSION_ENTRY	0x010001
 
-static struct ieee1394_device_id fdtv_id_table[] = {
+const struct ieee1394_device_id fdtv_id_table[] = {
 	{
 		/* FloppyDTV S/CI and FloppyDTV S2 */
 		.match_flags	= MATCH_FLAGS,
@@ -346,12 +346,23 @@ MODULE_DEVICE_TABLE(ieee1394, fdtv_id_ta
 
 static int __init fdtv_init(void)
 {
-	return fdtv_1394_init(fdtv_id_table);
+	int ret;
+
+	ret = fdtv_fw_init();
+	if (ret < 0)
+		return ret;
+
+	ret = fdtv_1394_init();
+	if (ret < 0)
+		fdtv_fw_exit();
+
+	return ret;
 }
 
 static void __exit fdtv_exit(void)
 {
 	fdtv_1394_exit();
+	fdtv_fw_exit();
 }
 
 module_init(fdtv_init);
Index: linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-fw.c
===================================================================
--- /dev/null
+++ linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-fw.c
@@ -0,0 +1,385 @@
+/*
+ * FireDTV driver -- firewire I/O backend
+ */
+
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/firewire.h>
+#include <linux/firewire-constants.h>
+#include <linux/highmem.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+#include <asm/page.h>
+
+#include <dvb_demux.h>
+
+#include "firedtv.h"
+
+static LIST_HEAD(node_list);
+static DEFINE_SPINLOCK(node_list_lock);
+
+static inline struct fw_device *device_of(struct firedtv *fdtv)
+{
+	return fw_device(fdtv->device->parent);
+}
+
+static int node_req(struct firedtv *fdtv, u64 addr, void *data, size_t len,
+		    int tcode)
+{
+	struct fw_device *device = device_of(fdtv);
+	int rcode, generation = device->generation;
+
+	smp_rmb(); /* node_id vs. generation */
+
+	rcode = fw_run_transaction(device->card, tcode, device->node_id,
+			generation, device->max_speed, addr, data, len);
+
+	return rcode != RCODE_COMPLETE ? -EIO : 0;
+}
+
+static int node_lock(struct firedtv *fdtv, u64 addr, __be32 data[])
+{
+	return node_req(fdtv, addr, data, 8, TCODE_LOCK_COMPARE_SWAP);
+}
+
+static int node_read(struct firedtv *fdtv, u64 addr, void *data, size_t len)
+{
+	return node_req(fdtv, addr, data, len, len == 4 ?
+			TCODE_READ_QUADLET_REQUEST : TCODE_READ_BLOCK_REQUEST);
+}
+
+static int node_write(struct firedtv *fdtv, u64 addr, void *data, size_t len)
+{
+	return node_req(fdtv, addr, data, len, TCODE_WRITE_BLOCK_REQUEST);
+}
+
+#define ISO_HEADER_SIZE			4
+#define CIP_HEADER_SIZE			8
+#define MPEG2_TS_HEADER_SIZE		4
+#define MPEG2_TS_SOURCE_PACKET_SIZE	(4 + 188)
+
+#define MAX_PACKET_SIZE		1024  /* 776, rounded up to 2^n */
+#define PACKETS_PER_PAGE	(PAGE_SIZE / MAX_PACKET_SIZE)
+#define N_PACKETS		64    /* buffer size */
+#define N_PAGES			DIV_ROUND_UP(N_PACKETS, PACKETS_PER_PAGE)
+#define IRQ_INTERVAL		16
+
+struct firedtv_receive_context {
+	struct fw_iso_context *context;
+	struct fw_iso_buffer buffer;
+	int interrupt_packet;
+	int current_packet;
+	char *packets[N_PACKETS];
+};
+
+static int queue_iso(struct firedtv_receive_context *ctx, int index)
+{
+	struct fw_iso_packet p;
+	int err;
+
+	p.payload_length = MAX_PACKET_SIZE;
+	p.interrupt = !(ctx->interrupt_packet & (IRQ_INTERVAL - 1));
+	p.skip = 0;
+	p.header_length = ISO_HEADER_SIZE;
+
+	err = fw_iso_context_queue(ctx->context, &p, &ctx->buffer,
+				   index * MAX_PACKET_SIZE);
+	if (!err)
+		ctx->interrupt_packet++;
+
+	return err;
+}
+
+static void handle_iso(struct fw_iso_context *context, u32 cycle,
+		       size_t header_length, void *header, void *data)
+{
+	struct firedtv *fdtv = data;
+	struct firedtv_receive_context *ctx = fdtv->backend_data;
+	__be32 *h, *h_end;
+	int i = ctx->current_packet, length, err;
+	char *p, *p_end;
+
+	for (h = header, h_end = h + header_length / 4; h < h_end; h++) {
+		length = be32_to_cpup(h) >> 16;
+		if (unlikely(length > MAX_PACKET_SIZE)) {
+			dev_err(fdtv->device, "length = %d\n", length);
+			length = MAX_PACKET_SIZE;
+		}
+
+		p = ctx->packets[i];
+		p_end = p + length;
+
+		for (p += CIP_HEADER_SIZE + MPEG2_TS_HEADER_SIZE; p < p_end;
+		     p += MPEG2_TS_SOURCE_PACKET_SIZE)
+			dvb_dmx_swfilter_packets(&fdtv->demux, p, 1);
+
+		err = queue_iso(ctx, i);
+		if (unlikely(err))
+			dev_err(fdtv->device, "requeue failed\n");
+
+		i = (i + 1) & (N_PACKETS - 1);
+	}
+	ctx->current_packet = i;
+}
+
+static int start_iso(struct firedtv *fdtv)
+{
+	struct firedtv_receive_context *ctx;
+	struct fw_device *device = device_of(fdtv);
+	char *p;
+	int i, j, k, err;
+
+	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->context = fw_iso_context_create(device->card,
+			FW_ISO_CONTEXT_RECEIVE, fdtv->isochannel,
+			device->max_speed, ISO_HEADER_SIZE, handle_iso, fdtv);
+	if (IS_ERR(ctx->context)) {
+		err = PTR_ERR(ctx->context);
+		goto fail_free;
+	}
+
+	err = fw_iso_buffer_init(&ctx->buffer, device->card,
+				 N_PAGES, DMA_FROM_DEVICE);
+	if (err)
+		goto fail_context_destroy;
+
+	ctx->interrupt_packet = 1;
+	ctx->current_packet = 0;
+
+	for (i = 0, k = 0; k < N_PAGES; k++) {
+		p = kmap(ctx->buffer.pages[k]);
+		for (j = 0; j < PACKETS_PER_PAGE && i < N_PACKETS; j++, i++)
+			ctx->packets[i] = p + j * MAX_PACKET_SIZE;
+	}
+
+	for (i = 0; i < N_PACKETS; i++) {
+		err = queue_iso(ctx, i);
+		if (err)
+			goto fail;
+	}
+
+	err = fw_iso_context_start(ctx->context, -1, 0,
+				   FW_ISO_CONTEXT_MATCH_ALL_TAGS);
+	if (err)
+		goto fail;
+
+	fdtv->backend_data = ctx;
+
+	return 0;
+fail:
+	fw_iso_buffer_destroy(&ctx->buffer, device->card);
+fail_context_destroy:
+	fw_iso_context_destroy(ctx->context);
+fail_free:
+	kfree(ctx);
+
+	return err;
+}
+
+static void stop_iso(struct firedtv *fdtv)
+{
+	struct firedtv_receive_context *ctx = fdtv->backend_data;
+
+	fw_iso_context_stop(ctx->context);
+	fw_iso_buffer_destroy(&ctx->buffer, device_of(fdtv)->card);
+	fw_iso_context_destroy(ctx->context);
+	kfree(ctx);
+}
+
+static const struct firedtv_backend backend = {
+	.lock		= node_lock,
+	.read		= node_read,
+	.write		= node_write,
+	.start_iso	= start_iso,
+	.stop_iso	= stop_iso,
+};
+
+static void handle_fcp(struct fw_card *card, struct fw_request *request,
+		       int tcode, int destination, int source, int generation,
+		       int speed, unsigned long long offset,
+		       void *payload, size_t length, void *callback_data)
+{
+	struct firedtv *f, *fdtv = NULL;
+	struct fw_device *device;
+	unsigned long flags;
+	int su;
+
+	if ((tcode != TCODE_WRITE_QUADLET_REQUEST &&
+	     tcode != TCODE_WRITE_BLOCK_REQUEST) ||
+	    offset != CSR_REGISTER_BASE + CSR_FCP_RESPONSE ||
+	    length == 0 ||
+	    (((u8 *)payload)[0] & 0xf0) != 0) {
+		fw_send_response(card, request, RCODE_TYPE_ERROR);
+		return;
+	}
+
+	su = ((u8 *)payload)[1] & 0x7;
+
+	spin_lock_irqsave(&node_list_lock, flags);
+	list_for_each_entry(f, &node_list, list) {
+		device = device_of(f);
+		if (device->generation != generation)
+			continue;
+
+		smp_rmb(); /* node_id vs. generation */
+
+		if (device->card == card &&
+		    device->node_id == source &&
+		    (f->subunit == su || (f->subunit == 0 && su == 0x7))) {
+			fdtv = f;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&node_list_lock, flags);
+
+	if (fdtv) {
+		avc_recv(fdtv, payload, length);
+		fw_send_response(card, request, RCODE_COMPLETE);
+	}
+}
+
+static struct fw_address_handler fcp_handler = {
+	.length           = CSR_FCP_END - CSR_FCP_RESPONSE,
+	.address_callback = handle_fcp,
+};
+
+static const struct fw_address_region fcp_region = {
+	.start	= CSR_REGISTER_BASE + CSR_FCP_RESPONSE,
+	.end	= CSR_REGISTER_BASE + CSR_FCP_END,
+};
+
+/* Adjust the template string if models with longer names appear. */
+#define MAX_MODEL_NAME_LEN ((int)DIV_ROUND_UP(sizeof("FireDTV ????"), 4))
+
+static size_t model_name(u32 *directory, __be32 *buffer)
+{
+	struct fw_csr_iterator ci;
+	int i, length, key, value, last_key = 0;
+	u32 *block = NULL;
+
+	fw_csr_iterator_init(&ci, directory);
+	while (fw_csr_iterator_next(&ci, &key, &value)) {
+		if (last_key == CSR_MODEL &&
+		    key == (CSR_DESCRIPTOR | CSR_LEAF))
+			block = ci.p - 1 + value;
+		last_key = key;
+	}
+
+	if (block == NULL)
+		return 0;
+
+	length = min((int)(block[0] >> 16) - 2, MAX_MODEL_NAME_LEN);
+	if (length <= 0)
+		return 0;
+
+	/* fast-forward to text string */
+	block += 3;
+
+	for (i = 0; i < length; i++)
+		buffer[i] = cpu_to_be32(block[i]);
+
+	return length * 4;
+}
+
+static int node_probe(struct device *dev)
+{
+	struct firedtv *fdtv;
+	__be32 name[MAX_MODEL_NAME_LEN];
+	int name_len, err;
+
+	name_len = model_name(fw_unit(dev)->directory, name);
+
+	fdtv = fdtv_alloc(dev, &backend, (char *)name, name_len);
+	if (!fdtv)
+		return -ENOMEM;
+
+	err = fdtv_register_rc(fdtv, dev);
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
+
+	return 0;
+fail:
+	spin_lock_irq(&node_list_lock);
+	list_del(&fdtv->list);
+	spin_unlock_irq(&node_list_lock);
+	fdtv_unregister_rc(fdtv);
+fail_free:
+	kfree(fdtv);
+
+	return err;
+}
+
+static int node_remove(struct device *dev)
+{
+	struct firedtv *fdtv = dev_get_drvdata(dev);
+
+	fdtv_dvb_unregister(fdtv);
+
+	spin_lock_irq(&node_list_lock);
+	list_del(&fdtv->list);
+	spin_unlock_irq(&node_list_lock);
+
+	fdtv_unregister_rc(fdtv);
+
+	kfree(fdtv);
+	return 0;
+}
+
+static void node_update(struct fw_unit *unit)
+{
+	struct firedtv *fdtv = dev_get_drvdata(&unit->device);
+
+	if (fdtv->isochannel >= 0)
+		cmp_establish_pp_connection(fdtv, fdtv->subunit,
+					    fdtv->isochannel);
+}
+
+static struct fw_driver fdtv_driver = {
+	.driver   = {
+		.owner  = THIS_MODULE,
+		.name   = "firedtv",
+		.bus    = &fw_bus_type,
+		.probe  = node_probe,
+		.remove = node_remove,
+	},
+	.update   = node_update,
+	.id_table = fdtv_id_table,
+};
+
+int __init fdtv_fw_init(void)
+{
+	int ret;
+
+	ret = fw_core_add_address_handler(&fcp_handler, &fcp_region);
+	if (ret < 0)
+		return ret;
+
+	return driver_register(&fdtv_driver.driver);
+}
+
+void fdtv_fw_exit(void)
+{
+	driver_unregister(&fdtv_driver.driver);
+	fw_core_remove_address_handler(&fcp_handler);
+}
Index: linux-2.6.31.4/drivers/media/dvb/firewire/firedtv.h
===================================================================
--- linux-2.6.31.4.orig/drivers/media/dvb/firewire/firedtv.h
+++ linux-2.6.31.4/drivers/media/dvb/firewire/firedtv.h
@@ -16,6 +16,7 @@
 #include <linux/dvb/dmx.h>
 #include <linux/dvb/frontend.h>
 #include <linux/list.h>
+#include <linux/mod_devicetable.h>
 #include <linux/mutex.h>
 #include <linux/spinlock_types.h>
 #include <linux/types.h>
@@ -119,10 +120,10 @@ struct firedtv {
 
 /* firedtv-1394.c */
 #ifdef CONFIG_DVB_FIREDTV_IEEE1394
-int fdtv_1394_init(struct ieee1394_device_id id_table[]);
+int fdtv_1394_init(void);
 void fdtv_1394_exit(void);
 #else
-static inline int fdtv_1394_init(struct ieee1394_device_id it[]) { return 0; }
+static inline int fdtv_1394_init(void) { return 0; }
 static inline void fdtv_1394_exit(void) {}
 #endif
 
@@ -163,10 +164,20 @@ struct firedtv *fdtv_alloc(struct device
 			   const struct firedtv_backend *backend,
 			   const char *name, size_t name_len);
 extern const char *fdtv_model_names[];
+extern const struct ieee1394_device_id fdtv_id_table[];
 
 /* firedtv-fe.c */
 void fdtv_frontend_init(struct firedtv *fdtv);
 
+/* firedtv-fw.c */
+#ifdef CONFIG_DVB_FIREDTV_FIREWIRE
+int fdtv_fw_init(void);
+void fdtv_fw_exit(void);
+#else
+static inline int fdtv_fw_init(void) { return 0; }
+static inline void fdtv_fw_exit(void) {}
+#endif
+
 /* firedtv-rc.c */
 #ifdef CONFIG_DVB_FIREDTV_INPUT
 int fdtv_register_rc(struct firedtv *fdtv, struct device *dev);

-- 
Stefan Richter
-=====-==--= =-== -=---
http://arcgraph.de/sr/

