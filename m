Return-path: <mchehab@pedra>
Received: from einhorn.in-berlin.de ([192.109.42.8]:51220 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1BFOl5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Feb 2011 09:41:57 -0500
Date: Sun, 6 Feb 2011 15:41:44 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [PATCH] firedtv: drop obsolete backend abstraction
Message-ID: <20110206154144.2bb3afba@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Since the drivers/ieee1394/ backend was removed from firedtv, its I/O no
longer needs to be abstracted as exchangeable backend methods.

Also, ieee1394 variants of module and device probe and removal are no
longer there.  Move module probe and removal into firedtv-fw.c where
device probe and removal are implemented.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Applies after Hans' "firedtv: remove dependency on the deleted ieee1394
stack.",
http://git.linuxtv.org/hverkuil/media_tree.git?a=commitdiff;h=f02c316436eef3baf349c489545edc7ade419ff6

 drivers/media/dvb/firewire/firedtv-avc.c |   15 +-
 drivers/media/dvb/firewire/firedtv-dvb.c |  130 --------------------
 drivers/media/dvb/firewire/firedtv-fe.c  |    8 
 drivers/media/dvb/firewire/firedtv-fw.c  |  146 +++++++++++++++++++----
 drivers/media/dvb/firewire/firedtv.h     |   31 ++---
 5 files changed, 140 insertions(+), 190 deletions(-)

Index: b/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -241,8 +241,8 @@ static int avc_write(struct firedtv *fdt
 		if (unlikely(avc_debug))
 			debug_fcp(fdtv->avc_data, fdtv->avc_data_length);
 
-		err = fdtv->backend->write(fdtv, FCP_COMMAND_REGISTER,
-				fdtv->avc_data, fdtv->avc_data_length);
+		err = fdtv_write(fdtv, FCP_COMMAND_REGISTER,
+				 fdtv->avc_data, fdtv->avc_data_length);
 		if (err) {
 			dev_err(fdtv->device, "FCP command write failed\n");
 
@@ -1322,7 +1322,7 @@ static int cmp_read(struct firedtv *fdtv
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	ret = fdtv->backend->read(fdtv, addr, data);
+	ret = fdtv_read(fdtv, addr, data);
 	if (ret < 0)
 		dev_err(fdtv->device, "CMP: read I/O error\n");
 
@@ -1340,7 +1340,7 @@ static int cmp_lock(struct firedtv *fdtv
 	/* data[] is stack-allocated and should not be DMA-mapped. */
 	memcpy(fdtv->avc_data, data, 8);
 
-	ret = fdtv->backend->lock(fdtv, addr, fdtv->avc_data);
+	ret = fdtv_lock(fdtv, addr, fdtv->avc_data);
 	if (ret < 0)
 		dev_err(fdtv->device, "CMP: lock I/O error\n");
 	else
@@ -1405,10 +1405,7 @@ repeat:
 		/* FIXME: this is for the worst case - optimize */
 		set_opcr_overhead_id(opcr, 0);
 
-		/*
-		 * FIXME: allocate isochronous channel and bandwidth at IRM
-		 * fdtv->backend->alloc_resources(fdtv, channels_mask, bw);
-		 */
+		/* FIXME: allocate isochronous channel and bandwidth at IRM */
 	}
 
 	set_opcr_p2p_connections(opcr, get_opcr_p2p_connections(*opcr) + 1);
@@ -1424,8 +1421,6 @@ repeat:
 		/*
 		 * FIXME: if old_opcr.P2P_Connections > 0,
 		 * deallocate isochronous channel and bandwidth at IRM
-		 * if (...)
-		 *	fdtv->backend->dealloc_resources(fdtv, channel, bw);
 		 */
 
 		if (++attempts < 6) /* arbitrary limit */
Index: b/drivers/media/dvb/firewire/firedtv-dvb.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-dvb.c
+++ b/drivers/media/dvb/firewire/firedtv-dvb.c
@@ -14,14 +14,9 @@
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/slab.h>
-#include <linux/string.h>
 #include <linux/types.h>
-#include <linux/wait.h>
-#include <linux/workqueue.h>
 
 #include <dmxdev.h>
 #include <dvb_demux.h>
@@ -166,11 +161,11 @@ int fdtv_stop_feed(struct dvb_demux_feed
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-int fdtv_dvb_register(struct firedtv *fdtv)
+int fdtv_dvb_register(struct firedtv *fdtv, const char *name)
 {
 	int err;
 
-	err = dvb_register_adapter(&fdtv->adapter, fdtv_model_names[fdtv->type],
+	err = dvb_register_adapter(&fdtv->adapter, name,
 				   THIS_MODULE, fdtv->device, adapter_nr);
 	if (err < 0)
 		goto fail_log;
@@ -210,7 +205,7 @@ int fdtv_dvb_register(struct firedtv *fd
 
 	dvb_net_init(&fdtv->adapter, &fdtv->dvbnet, &fdtv->demux.dmx);
 
-	fdtv_frontend_init(fdtv);
+	fdtv_frontend_init(fdtv, name);
 	err = dvb_register_frontend(&fdtv->adapter, &fdtv->fe);
 	if (err)
 		goto fail_net_release;
@@ -248,122 +243,3 @@ void fdtv_dvb_unregister(struct firedtv 
 	dvb_dmx_release(&fdtv->demux);
 	dvb_unregister_adapter(&fdtv->adapter);
 }
-
-const char *fdtv_model_names[] = {
-	[FIREDTV_UNKNOWN] = "unknown type",
-	[FIREDTV_DVB_S]   = "FireDTV S/CI",
-	[FIREDTV_DVB_C]   = "FireDTV C/CI",
-	[FIREDTV_DVB_T]   = "FireDTV T/CI",
-	[FIREDTV_DVB_S2]  = "FireDTV S2  ",
-};
-
-struct firedtv *fdtv_alloc(struct device *dev,
-			   const struct firedtv_backend *backend,
-			   const char *name, size_t name_len)
-{
-	struct firedtv *fdtv;
-	int i;
-
-	fdtv = kzalloc(sizeof(*fdtv), GFP_KERNEL);
-	if (!fdtv)
-		return NULL;
-
-	dev_set_drvdata(dev, fdtv);
-	fdtv->device		= dev;
-	fdtv->isochannel	= -1;
-	fdtv->voltage		= 0xff;
-	fdtv->tone		= 0xff;
-	fdtv->backend		= backend;
-
-	mutex_init(&fdtv->avc_mutex);
-	init_waitqueue_head(&fdtv->avc_wait);
-	mutex_init(&fdtv->demux_mutex);
-	INIT_WORK(&fdtv->remote_ctrl_work, avc_remote_ctrl_work);
-
-	for (i = ARRAY_SIZE(fdtv_model_names); --i; )
-		if (strlen(fdtv_model_names[i]) <= name_len &&
-		    strncmp(name, fdtv_model_names[i], name_len) == 0)
-			break;
-	fdtv->type = i;
-
-	return fdtv;
-}
-
-#define MATCH_FLAGS (IEEE1394_MATCH_VENDOR_ID | IEEE1394_MATCH_MODEL_ID | \
-		     IEEE1394_MATCH_SPECIFIER_ID | IEEE1394_MATCH_VERSION)
-
-#define DIGITAL_EVERYWHERE_OUI	0x001287
-#define AVC_UNIT_SPEC_ID_ENTRY	0x00a02d
-#define AVC_SW_VERSION_ENTRY	0x010001
-
-const struct ieee1394_device_id fdtv_id_table[] = {
-	{
-		/* FloppyDTV S/CI and FloppyDTV S2 */
-		.match_flags	= MATCH_FLAGS,
-		.vendor_id	= DIGITAL_EVERYWHERE_OUI,
-		.model_id	= 0x000024,
-		.specifier_id	= AVC_UNIT_SPEC_ID_ENTRY,
-		.version	= AVC_SW_VERSION_ENTRY,
-	}, {
-		/* FloppyDTV T/CI */
-		.match_flags	= MATCH_FLAGS,
-		.vendor_id	= DIGITAL_EVERYWHERE_OUI,
-		.model_id	= 0x000025,
-		.specifier_id	= AVC_UNIT_SPEC_ID_ENTRY,
-		.version	= AVC_SW_VERSION_ENTRY,
-	}, {
-		/* FloppyDTV C/CI */
-		.match_flags	= MATCH_FLAGS,
-		.vendor_id	= DIGITAL_EVERYWHERE_OUI,
-		.model_id	= 0x000026,
-		.specifier_id	= AVC_UNIT_SPEC_ID_ENTRY,
-		.version	= AVC_SW_VERSION_ENTRY,
-	}, {
-		/* FireDTV S/CI and FloppyDTV S2 */
-		.match_flags	= MATCH_FLAGS,
-		.vendor_id	= DIGITAL_EVERYWHERE_OUI,
-		.model_id	= 0x000034,
-		.specifier_id	= AVC_UNIT_SPEC_ID_ENTRY,
-		.version	= AVC_SW_VERSION_ENTRY,
-	}, {
-		/* FireDTV T/CI */
-		.match_flags	= MATCH_FLAGS,
-		.vendor_id	= DIGITAL_EVERYWHERE_OUI,
-		.model_id	= 0x000035,
-		.specifier_id	= AVC_UNIT_SPEC_ID_ENTRY,
-		.version	= AVC_SW_VERSION_ENTRY,
-	}, {
-		/* FireDTV C/CI */
-		.match_flags	= MATCH_FLAGS,
-		.vendor_id	= DIGITAL_EVERYWHERE_OUI,
-		.model_id	= 0x000036,
-		.specifier_id	= AVC_UNIT_SPEC_ID_ENTRY,
-		.version	= AVC_SW_VERSION_ENTRY,
-	}, {}
-};
-MODULE_DEVICE_TABLE(ieee1394, fdtv_id_table);
-
-static int __init fdtv_init(void)
-{
-	int ret;
-
-	ret = fdtv_fw_init();
-	if (ret < 0)
-		return ret;
-
-	return ret;
-}
-
-static void __exit fdtv_exit(void)
-{
-	fdtv_fw_exit();
-}
-
-module_init(fdtv_init);
-module_exit(fdtv_exit);
-
-MODULE_AUTHOR("Andreas Monitzer <andy@monitzer.com>");
-MODULE_AUTHOR("Ben Backx <ben@bbackx.com>");
-MODULE_DESCRIPTION("FireDTV DVB Driver");
-MODULE_LICENSE("GPL");
-MODULE_SUPPORTED_DEVICE("FireDTV DVB");
Index: b/drivers/media/dvb/firewire/firedtv-fe.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-fe.c
+++ b/drivers/media/dvb/firewire/firedtv-fe.c
@@ -36,14 +36,14 @@ static int fdtv_dvb_init(struct dvb_fron
 		return err;
 	}
 
-	return fdtv->backend->start_iso(fdtv);
+	return fdtv_start_iso(fdtv);
 }
 
 static int fdtv_sleep(struct dvb_frontend *fe)
 {
 	struct firedtv *fdtv = fe->sec_priv;
 
-	fdtv->backend->stop_iso(fdtv);
+	fdtv_stop_iso(fdtv);
 	cmp_break_pp_connection(fdtv, fdtv->subunit, fdtv->isochannel);
 	fdtv->isochannel = -1;
 	return 0;
@@ -165,7 +165,7 @@ static int fdtv_set_property(struct dvb_
 	return 0;
 }
 
-void fdtv_frontend_init(struct firedtv *fdtv)
+void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 {
 	struct dvb_frontend_ops *ops = &fdtv->fe.ops;
 	struct dvb_frontend_info *fi = &ops->info;
@@ -266,7 +266,7 @@ void fdtv_frontend_init(struct firedtv *
 		dev_err(fdtv->device, "no frontend for model type %d\n",
 			fdtv->type);
 	}
-	strcpy(fi->name, fdtv_model_names[fdtv->type]);
+	strcpy(fi->name, name);
 
 	fdtv->fe.dvb = &fdtv->adapter;
 	fdtv->fe.sec_priv = fdtv;
Index: b/drivers/media/dvb/firewire/firedtv-fw.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-fw.c
+++ b/drivers/media/dvb/firewire/firedtv-fw.c
@@ -9,11 +9,18 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mm.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/string.h>
 #include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
 
 #include <asm/page.h>
+#include <asm/system.h>
 
 #include <dvb_demux.h>
 
@@ -41,17 +48,17 @@ static int node_req(struct firedtv *fdtv
 	return rcode != RCODE_COMPLETE ? -EIO : 0;
 }
 
-static int node_lock(struct firedtv *fdtv, u64 addr, void *data)
+int fdtv_lock(struct firedtv *fdtv, u64 addr, void *data)
 {
 	return node_req(fdtv, addr, data, 8, TCODE_LOCK_COMPARE_SWAP);
 }
 
-static int node_read(struct firedtv *fdtv, u64 addr, void *data)
+int fdtv_read(struct firedtv *fdtv, u64 addr, void *data)
 {
 	return node_req(fdtv, addr, data, 4, TCODE_READ_QUADLET_REQUEST);
 }
 
-static int node_write(struct firedtv *fdtv, u64 addr, void *data, size_t len)
+int fdtv_write(struct firedtv *fdtv, u64 addr, void *data, size_t len)
 {
 	return node_req(fdtv, addr, data, len, TCODE_WRITE_BLOCK_REQUEST);
 }
@@ -67,7 +74,7 @@ static int node_write(struct firedtv *fd
 #define N_PAGES			DIV_ROUND_UP(N_PACKETS, PACKETS_PER_PAGE)
 #define IRQ_INTERVAL		16
 
-struct firedtv_receive_context {
+struct fdtv_ir_context {
 	struct fw_iso_context *context;
 	struct fw_iso_buffer buffer;
 	int interrupt_packet;
@@ -75,7 +82,7 @@ struct firedtv_receive_context {
 	char *pages[N_PAGES];
 };
 
-static int queue_iso(struct firedtv_receive_context *ctx, int index)
+static int queue_iso(struct fdtv_ir_context *ctx, int index)
 {
 	struct fw_iso_packet p;
 
@@ -92,7 +99,7 @@ static void handle_iso(struct fw_iso_con
 		       size_t header_length, void *header, void *data)
 {
 	struct firedtv *fdtv = data;
-	struct firedtv_receive_context *ctx = fdtv->backend_data;
+	struct fdtv_ir_context *ctx = fdtv->ir_context;
 	__be32 *h, *h_end;
 	int length, err, i = ctx->current_packet;
 	char *p, *p_end;
@@ -121,9 +128,9 @@ static void handle_iso(struct fw_iso_con
 	ctx->current_packet = i;
 }
 
-static int start_iso(struct firedtv *fdtv)
+int fdtv_start_iso(struct firedtv *fdtv)
 {
-	struct firedtv_receive_context *ctx;
+	struct fdtv_ir_context *ctx;
 	struct fw_device *device = device_of(fdtv);
 	int i, err;
 
@@ -161,7 +168,7 @@ static int start_iso(struct firedtv *fdt
 	if (err)
 		goto fail;
 
-	fdtv->backend_data = ctx;
+	fdtv->ir_context = ctx;
 
 	return 0;
 fail:
@@ -174,9 +181,9 @@ fail_free:
 	return err;
 }
 
-static void stop_iso(struct firedtv *fdtv)
+void fdtv_stop_iso(struct firedtv *fdtv)
 {
-	struct firedtv_receive_context *ctx = fdtv->backend_data;
+	struct fdtv_ir_context *ctx = fdtv->ir_context;
 
 	fw_iso_context_stop(ctx->context);
 	fw_iso_buffer_destroy(&ctx->buffer, device_of(fdtv)->card);
@@ -184,14 +191,6 @@ static void stop_iso(struct firedtv *fdt
 	kfree(ctx);
 }
 
-static const struct firedtv_backend backend = {
-	.lock		= node_lock,
-	.read		= node_read,
-	.write		= node_write,
-	.start_iso	= start_iso,
-	.stop_iso	= stop_iso,
-};
-
 static void handle_fcp(struct fw_card *card, struct fw_request *request,
 		       int tcode, int destination, int source, int generation,
 		       unsigned long long offset, void *payload, size_t length,
@@ -238,6 +237,14 @@ static const struct fw_address_region fc
 	.end	= CSR_REGISTER_BASE + CSR_FCP_END,
 };
 
+static const char * const model_names[] = {
+	[FIREDTV_UNKNOWN] = "unknown type",
+	[FIREDTV_DVB_S]   = "FireDTV S/CI",
+	[FIREDTV_DVB_C]   = "FireDTV C/CI",
+	[FIREDTV_DVB_T]   = "FireDTV T/CI",
+	[FIREDTV_DVB_S2]  = "FireDTV S2  ",
+};
+
 /* Adjust the template string if models with longer names appear. */
 #define MAX_MODEL_NAME_LEN sizeof("FireDTV ????")
 
@@ -245,15 +252,31 @@ static int node_probe(struct device *dev
 {
 	struct firedtv *fdtv;
 	char name[MAX_MODEL_NAME_LEN];
-	int name_len, err;
-
-	name_len = fw_csr_string(fw_unit(dev)->directory, CSR_MODEL,
-				 name, sizeof(name));
+	int name_len, i, err;
 
-	fdtv = fdtv_alloc(dev, &backend, name, name_len >= 0 ? name_len : 0);
+	fdtv = kzalloc(sizeof(*fdtv), GFP_KERNEL);
 	if (!fdtv)
 		return -ENOMEM;
 
+	dev_set_drvdata(dev, fdtv);
+	fdtv->device		= dev;
+	fdtv->isochannel	= -1;
+	fdtv->voltage		= 0xff;
+	fdtv->tone		= 0xff;
+
+	mutex_init(&fdtv->avc_mutex);
+	init_waitqueue_head(&fdtv->avc_wait);
+	mutex_init(&fdtv->demux_mutex);
+	INIT_WORK(&fdtv->remote_ctrl_work, avc_remote_ctrl_work);
+
+	name_len = fw_csr_string(fw_unit(dev)->directory, CSR_MODEL,
+				 name, sizeof(name));
+	for (i = ARRAY_SIZE(model_names); --i; )
+		if (strlen(model_names[i]) <= name_len &&
+		    strncmp(name, model_names[i], name_len) == 0)
+			break;
+	fdtv->type = i;
+
 	err = fdtv_register_rc(fdtv, dev);
 	if (err)
 		goto fail_free;
@@ -266,7 +289,7 @@ static int node_probe(struct device *dev
 	if (err)
 		goto fail;
 
-	err = fdtv_dvb_register(fdtv);
+	err = fdtv_dvb_register(fdtv, model_names[fdtv->type]);
 	if (err)
 		goto fail;
 
@@ -309,6 +332,60 @@ static void node_update(struct fw_unit *
 					    fdtv->isochannel);
 }
 
+#define MATCH_FLAGS (IEEE1394_MATCH_VENDOR_ID | IEEE1394_MATCH_MODEL_ID | \
+		     IEEE1394_MATCH_SPECIFIER_ID | IEEE1394_MATCH_VERSION)
+
+#define DIGITAL_EVERYWHERE_OUI	0x001287
+#define AVC_UNIT_SPEC_ID_ENTRY	0x00a02d
+#define AVC_SW_VERSION_ENTRY	0x010001
+
+static const struct ieee1394_device_id fdtv_id_table[] = {
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
 static struct fw_driver fdtv_driver = {
 	.driver   = {
 		.owner  = THIS_MODULE,
@@ -321,7 +398,7 @@ static struct fw_driver fdtv_driver = {
 	.id_table = fdtv_id_table,
 };
 
-int __init fdtv_fw_init(void)
+static int __init fdtv_init(void)
 {
 	int ret;
 
@@ -329,11 +406,24 @@ int __init fdtv_fw_init(void)
 	if (ret < 0)
 		return ret;
 
-	return driver_register(&fdtv_driver.driver);
+	ret = driver_register(&fdtv_driver.driver);
+	if (ret < 0)
+		fw_core_remove_address_handler(&fcp_handler);
+
+	return ret;
 }
 
-void fdtv_fw_exit(void)
+static void __exit fdtv_exit(void)
 {
 	driver_unregister(&fdtv_driver.driver);
 	fw_core_remove_address_handler(&fcp_handler);
 }
+
+module_init(fdtv_init);
+module_exit(fdtv_exit);
+
+MODULE_AUTHOR("Andreas Monitzer <andy@monitzer.com>");
+MODULE_AUTHOR("Ben Backx <ben@bbackx.com>");
+MODULE_DESCRIPTION("FireDTV DVB Driver");
+MODULE_LICENSE("GPL");
+MODULE_SUPPORTED_DEVICE("FireDTV DVB");
Index: b/drivers/media/dvb/firewire/firedtv.h
===================================================================
--- a/drivers/media/dvb/firewire/firedtv.h
+++ b/drivers/media/dvb/firewire/firedtv.h
@@ -70,15 +70,7 @@ enum model_type {
 
 struct device;
 struct input_dev;
-struct firedtv;
-
-struct firedtv_backend {
-	int (*lock)(struct firedtv *fdtv, u64 addr, void *data);
-	int (*read)(struct firedtv *fdtv, u64 addr, void *data);
-	int (*write)(struct firedtv *fdtv, u64 addr, void *data, size_t len);
-	int (*start_iso)(struct firedtv *fdtv);
-	void (*stop_iso)(struct firedtv *fdtv);
-};
+struct fdtv_ir_context;
 
 struct firedtv {
 	struct device *device;
@@ -104,12 +96,11 @@ struct firedtv {
 	enum model_type		type;
 	char			subunit;
 	char			isochannel;
+	struct fdtv_ir_context	*ir_context;
+
 	fe_sec_voltage_t	voltage;
 	fe_sec_tone_mode_t	tone;
 
-	const struct firedtv_backend *backend;
-	void			*backend_data;
-
 	struct mutex		demux_mutex;
 	unsigned long		channel_active;
 	u16			channel_pid[16];
@@ -149,20 +140,18 @@ void fdtv_ca_release(struct firedtv *fdt
 /* firedtv-dvb.c */
 int fdtv_start_feed(struct dvb_demux_feed *dvbdmxfeed);
 int fdtv_stop_feed(struct dvb_demux_feed *dvbdmxfeed);
-int fdtv_dvb_register(struct firedtv *fdtv);
+int fdtv_dvb_register(struct firedtv *fdtv, const char *name);
 void fdtv_dvb_unregister(struct firedtv *fdtv);
-struct firedtv *fdtv_alloc(struct device *dev,
-			   const struct firedtv_backend *backend,
-			   const char *name, size_t name_len);
-extern const char *fdtv_model_names[];
-extern const struct ieee1394_device_id fdtv_id_table[];
 
 /* firedtv-fe.c */
-void fdtv_frontend_init(struct firedtv *fdtv);
+void fdtv_frontend_init(struct firedtv *fdtv, const char *name);
 
 /* firedtv-fw.c */
-int fdtv_fw_init(void);
-void fdtv_fw_exit(void);
+int fdtv_lock(struct firedtv *fdtv, u64 addr, void *data);
+int fdtv_read(struct firedtv *fdtv, u64 addr, void *data);
+int fdtv_write(struct firedtv *fdtv, u64 addr, void *data, size_t len);
+int fdtv_start_iso(struct firedtv *fdtv);
+void fdtv_stop_iso(struct firedtv *fdtv);
 
 /* firedtv-rc.c */
 #ifdef CONFIG_DVB_FIREDTV_INPUT

-- 
Stefan Richter
-=====-==-== --=- --==-
http://arcgraph.de/sr/
