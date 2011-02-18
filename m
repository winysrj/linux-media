Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:13750 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758214Ab1BRBUj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:20:39 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by mango.metrocast.net (8.13.8/8.13.8) with ESMTP id p1I1Kbss022104
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 01:20:37 GMT
Subject: [PATCH 11/13] lirc_zilog: Add locking of the i2c_clients when in
 use
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1297991502.9399.16.camel@localhost>
References: <1297991502.9399.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 20:20:50 -0500
Message-ID: <1297992050.9399.27.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

 
Lock the i2c_client pointers and prevent i2c_client removal when
lirc_zilog is perfoming a series of operations that require valid
i2c_client pointers.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/staging/lirc/lirc_zilog.c |   41 +++++++++++++++++++++++++++++++++---
 1 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 755cb39..a59d32d 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -70,7 +70,7 @@ struct IR_rx {
 	struct IR *ir;
 
 	/* RX device */
-	/* FIXME mutex lock access to this pointer */
+	struct mutex client_lock;
 	struct i2c_client *c;
 
 	/* RX polling thread data */
@@ -86,7 +86,7 @@ struct IR_tx {
 	struct IR *ir;
 
 	/* TX device */
-	/* FIXME mutex lock access to this pointer */
+	struct mutex client_lock;
 	struct i2c_client *c;
 
 	/* TX additional actions needed */
@@ -341,6 +341,14 @@ static int add_to_buf(struct IR *ir)
 	if (rx == NULL)
 		return -ENXIO;
 
+	/* Ensure our rx->c i2c_client remains valid for the duration */
+	mutex_lock(&rx->client_lock);
+	if (rx->c == NULL) {
+		mutex_unlock(&rx->client_lock);
+		put_ir_rx(rx, false);
+		return -ENXIO;
+	}
+
 	tx = get_ir_tx(ir);
 
 	/*
@@ -442,6 +450,7 @@ static int add_to_buf(struct IR *ir)
 		ret = 0;
 	} while (!lirc_buffer_full(rbuf));
 
+	mutex_unlock(&rx->client_lock);
 	if (tx != NULL)
 		put_ir_tx(tx, false);
 	put_ir_rx(rx, false);
@@ -1089,6 +1098,14 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
 	if (tx == NULL)
 		return -ENXIO;
 
+	/* Ensure our tx->c i2c_client remains valid for the duration */
+	mutex_lock(&tx->client_lock);
+	if (tx->c == NULL) {
+		mutex_unlock(&tx->client_lock);
+		put_ir_tx(tx, false);
+		return -ENXIO;
+	}
+
 	/* Lock i2c bus for the duration */
 	mutex_lock(&ir->ir_lock);
 
@@ -1099,6 +1116,7 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
 
 		if (copy_from_user(&command, buf + i, sizeof(command))) {
 			mutex_unlock(&ir->ir_lock);
+			mutex_unlock(&tx->client_lock);
 			put_ir_tx(tx, false);
 			return -EFAULT;
 		}
@@ -1109,6 +1127,7 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
 			ret = fw_load(tx);
 			if (ret != 0) {
 				mutex_unlock(&ir->ir_lock);
+				mutex_unlock(&tx->client_lock);
 				put_ir_tx(tx, false);
 				if (ret != -ENOMEM)
 					ret = -EIO;
@@ -1126,6 +1145,7 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
 					    (unsigned)command & 0xFFFF);
 			if (ret == -EPROTO) {
 				mutex_unlock(&ir->ir_lock);
+				mutex_unlock(&tx->client_lock);
 				put_ir_tx(tx, false);
 				return ret;
 			}
@@ -1144,6 +1164,7 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
 				zilog_error("unable to send to the IR chip "
 					    "after 3 resets, giving up\n");
 				mutex_unlock(&ir->ir_lock);
+				mutex_unlock(&tx->client_lock);
 				put_ir_tx(tx, false);
 				return ret;
 			}
@@ -1158,6 +1179,8 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
 	/* Release i2c bus */
 	mutex_unlock(&ir->ir_lock);
 
+	mutex_unlock(&tx->client_lock);
+
 	/* Give back our struct IR_tx reference */
 	put_ir_tx(tx, false);
 
@@ -1367,12 +1390,20 @@ static int ir_remove(struct i2c_client *client)
 {
 	if (strncmp("ir_tx_z8", client->name, 8) == 0) {
 		struct IR_tx *tx = i2c_get_clientdata(client);
-		if (tx != NULL)
+		if (tx != NULL) {
+			mutex_lock(&tx->client_lock);
+			tx->c = NULL;
+			mutex_unlock(&tx->client_lock);
 			put_ir_tx(tx, false);
+		}
 	} else if (strncmp("ir_rx_z8", client->name, 8) == 0) {
 		struct IR_rx *rx = i2c_get_clientdata(client);
-		if (rx != NULL)
+		if (rx != NULL) {
+			mutex_lock(&rx->client_lock);
+			rx->c = NULL;
+			mutex_unlock(&rx->client_lock);
 			put_ir_rx(rx, false);
+		}
 	}
 	return 0;
 }
@@ -1474,6 +1505,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		ir->tx = tx;
 
 		ir->l.features |= LIRC_CAN_SEND_PULSE;
+		mutex_init(&tx->client_lock);
 		tx->c = client;
 		tx->need_boot = 1;
 		tx->post_tx_ready_poll =
@@ -1516,6 +1548,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		ir->rx = rx;
 
 		ir->l.features |= LIRC_CAN_REC_LIRCCODE;
+		mutex_init(&rx->client_lock);
 		rx->c = client;
 		rx->hdpvr_data_fmt =
 			       (id->driver_data & ID_FLAG_HDPVR) ? true : false;
-- 
1.7.2.1



