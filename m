Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:4286 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171Ab1BRBOa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:14:30 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by mango.metrocast.net (8.13.8/8.13.8) with ESMTP id p1I1EMr6017077
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 01:14:27 GMT
Subject: [PATCH 03/13] lirc_zilog: Convert ir_device instance array to a
 linked list
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1297991502.9399.16.camel@localhost>
References: <1297991502.9399.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 20:14:35 -0500
Message-ID: <1297991675.9399.19.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/staging/lirc/lirc_zilog.c |   59 +++++++++++++++++++-----------------
 1 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 3a91257..39f7b53 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -89,6 +89,8 @@ struct IR_tx {
 };
 
 struct IR {
+	struct list_head list;
+
 	struct lirc_driver l;
 
 	struct mutex ir_lock;
@@ -99,9 +101,9 @@ struct IR {
 	struct IR_tx *tx;
 };
 
-/* Minor -> data mapping */
-static struct mutex ir_devices_lock;
-static struct IR *ir_devices[MAX_IRCTL_DEVICES];
+/* IR transceiver instance object list */
+static DEFINE_MUTEX(ir_devices_lock);
+static LIST_HEAD(ir_devices_list);
 
 /* Block size for IR transmitter */
 #define TX_BLOCK_SIZE	99
@@ -1063,10 +1065,16 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 /* ir_devices_lock must be held */
 static struct IR *find_ir_device_by_minor(unsigned int minor)
 {
-	if (minor >= MAX_IRCTL_DEVICES)
+	struct IR *ir;
+
+	if (list_empty(&ir_devices_list))
 		return NULL;
 
-	return ir_devices[minor];
+	list_for_each_entry(ir, &ir_devices_list, list)
+		if (ir->l.minor == minor)
+			return ir;
+
+	return NULL;
 }
 
 /*
@@ -1172,25 +1180,21 @@ static void destroy_rx_kthread(struct IR_rx *rx)
 /* ir_devices_lock must be held */
 static int add_ir_device(struct IR *ir)
 {
-	int i;
-
-	for (i = 0; i < MAX_IRCTL_DEVICES; i++)
-		if (ir_devices[i] == NULL) {
-			ir_devices[i] = ir;
-			break;
-		}
-
-	return i == MAX_IRCTL_DEVICES ? -ENOMEM : i;
+	list_add_tail(&ir->list, &ir_devices_list);
+	return 0;
 }
 
 /* ir_devices_lock must be held */
 static void del_ir_device(struct IR *ir)
 {
-	int i;
+	struct IR *p;
+
+	if (list_empty(&ir_devices_list))
+		return;
 
-	for (i = 0; i < MAX_IRCTL_DEVICES; i++)
-		if (ir_devices[i] == ir) {
-			ir_devices[i] = NULL;
+	list_for_each_entry(p, &ir_devices_list, list)
+		if (p == ir) {
+			list_del(&p->list);
 			break;
 		}
 }
@@ -1237,17 +1241,16 @@ static int ir_remove(struct i2c_client *client)
 /* ir_devices_lock must be held */
 static struct IR *find_ir_device_by_adapter(struct i2c_adapter *adapter)
 {
-	int i;
-	struct IR *ir = NULL;
+	struct IR *ir;
 
-	for (i = 0; i < MAX_IRCTL_DEVICES; i++)
-		if (ir_devices[i] != NULL &&
-		    ir_devices[i]->adapter == adapter) {
-			ir = ir_devices[i];
-			break;
-		}
+	if (list_empty(&ir_devices_list))
+		return NULL;
+
+	list_for_each_entry(ir, &ir_devices_list, list)
+		if (ir->adapter == adapter)
+			return ir;
 
-	return ir;
+	return NULL;
 }
 
 static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
@@ -1284,6 +1287,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			goto out_no_ir;
 		}
 		/* store for use in ir_probe() again, and open() later on */
+		INIT_LIST_HEAD(&ir->list);
 		ret = add_ir_device(ir);
 		if (ret)
 			goto out_free_ir;
@@ -1421,7 +1425,6 @@ static int __init zilog_init(void)
 	zilog_notify("Zilog/Hauppauge IR driver initializing\n");
 
 	mutex_init(&tx_data_lock);
-	mutex_init(&ir_devices_lock);
 
 	request_module("firmware_class");
 
-- 
1.7.2.1



