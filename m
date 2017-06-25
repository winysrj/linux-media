Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56445 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdFYMcd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:32:33 -0400
Subject: [PATCH 15/19] lirc_zilog: use a dynamically allocated lirc_dev
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:32:31 +0200
Message-ID: <149839395101.28811.3073976253776587620.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lirc_zilog currently embeds a struct lirc_dev in its own struct IR, but
subsequent patches will make the lifetime of struct lirc_dev dynamic (i.e.
it will be free():d once lirc_dev is sure there are no users of the struct).

Therefore, change lirc_zilog to use a pointer to a dynamically allocated
struct lirc_dev.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/staging/media/lirc/lirc_zilog.c |   69 ++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 51512ba7f5b8..bbbba25ae574 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -102,8 +102,8 @@ struct IR {
 	struct kref ref;
 	struct list_head list;
 
-	/* FIXME spinlock access to l.features */
-	struct lirc_dev l;
+	/* FIXME spinlock access to l->features */
+	struct lirc_dev *l;
 	struct lirc_buffer rbuf;
 
 	struct mutex ir_lock;
@@ -187,7 +187,10 @@ static void release_ir_device(struct kref *ref)
 	 * ir->open_count ==  0 - happens on final close()
 	 * ir_lock, tx_ref_lock, rx_ref_lock, all released
 	 */
-	lirc_unregister_device(&ir->l);
+	if (ir->l) {
+		lirc_unregister_device(ir->l);
+		lirc_free_device(ir->l);
+	}
 
 	if (kfifo_initialized(&ir->rbuf.fifo))
 		lirc_buffer_free(&ir->rbuf);
@@ -244,7 +247,7 @@ static void release_ir_rx(struct kref *ref)
 	 * and releasing the ir reference can cause a sleep.  That work is
 	 * performed by put_ir_rx()
 	 */
-	ir->l.features &= ~LIRC_CAN_REC_LIRCCODE;
+	ir->l->features &= ~LIRC_CAN_REC_LIRCCODE;
 	/* Don't put_ir_device(rx->ir) here; lock can't be freed yet */
 	ir->rx = NULL;
 	/* Don't do the kfree(rx) here; we still need to kill the poll thread */
@@ -289,7 +292,7 @@ static void release_ir_tx(struct kref *ref)
 	struct IR_tx *tx = container_of(ref, struct IR_tx, ref);
 	struct IR *ir = tx->ir;
 
-	ir->l.features &= ~LIRC_CAN_SEND_PULSE;
+	ir->l->features &= ~LIRC_CAN_SEND_PULSE;
 	/* Don't put_ir_device(tx->ir) here, so our lock doesn't get freed */
 	ir->tx = NULL;
 	kfree(tx);
@@ -318,7 +321,7 @@ static int add_to_buf(struct IR *ir)
 	int ret;
 	int failures = 0;
 	unsigned char sendbuf[1] = { 0 };
-	struct lirc_buffer *rbuf = ir->l.rbuf;
+	struct lirc_buffer *rbuf = ir->l->rbuf;
 	struct IR_rx *rx;
 	struct IR_tx *tx;
 
@@ -464,7 +467,7 @@ static int add_to_buf(struct IR *ir)
 static int lirc_thread(void *arg)
 {
 	struct IR *ir = arg;
-	struct lirc_buffer *rbuf = ir->l.rbuf;
+	struct lirc_buffer *rbuf = ir->l->rbuf;
 
 	dev_dbg(ir->dev, "poll thread started\n");
 
@@ -885,7 +888,7 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 {
 	struct IR *ir = lirc_get_pdata(filep);
 	struct IR_rx *rx;
-	struct lirc_buffer *rbuf = ir->l.rbuf;
+	struct lirc_buffer *rbuf = ir->l->rbuf;
 	int ret = 0, written = 0, retries = 0;
 	unsigned int m;
 	DECLARE_WAITQUEUE(wait, current);
@@ -1203,7 +1206,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 {
 	struct IR *ir = lirc_get_pdata(filep);
 	struct IR_rx *rx;
-	struct lirc_buffer *rbuf = ir->l.rbuf;
+	struct lirc_buffer *rbuf = ir->l->rbuf;
 	unsigned int ret;
 
 	dev_dbg(ir->dev, "%s called\n", __func__);
@@ -1239,7 +1242,7 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	int result;
 	unsigned long mode, features;
 
-	features = ir->l.features;
+	features = ir->l->features;
 
 	switch (cmd) {
 	case LIRC_GET_LENGTH:
@@ -1349,13 +1352,6 @@ static const struct file_operations lirc_fops = {
 	.release	= close
 };
 
-static struct lirc_dev lirc_template = {
-	.name		= "lirc_zilog",
-	.code_length	= 13,
-	.fops		= &lirc_fops,
-	.owner		= THIS_MODULE,
-};
-
 static int ir_remove(struct i2c_client *client)
 {
 	if (strncmp("ir_tx_z8", client->name, 8) == 0) {
@@ -1446,22 +1442,35 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		spin_lock_init(&ir->rx_ref_lock);
 
 		/* set lirc_dev stuff */
-		memcpy(&ir->l, &lirc_template, sizeof(struct lirc_dev));
+		ir->l = lirc_allocate_device();
+		if (!ir->l) {
+			ret = -ENOMEM;
+			goto out_put_ir;
+		}
+
+		snprintf(ir->l->name, sizeof(ir->l->name), "lirc_zilog");
+		ir->l->code_length = 13;
+		ir->l->fops = &lirc_fops;
+		ir->l->owner = THIS_MODULE;
+
 		/*
 		 * FIXME this is a pointer reference to us, but no refcount.
 		 *
 		 * This OK for now, since lirc_dev currently won't touch this
 		 * buffer as we provide our own lirc_fops.
 		 *
-		 * Currently our own lirc_fops rely on this ir->l.rbuf pointer
+		 * Currently our own lirc_fops rely on this ir->l->rbuf pointer
 		 */
-		ir->l.rbuf = &ir->rbuf;
-		ir->l.dev  = &adap->dev;
+		ir->l->rbuf = &ir->rbuf;
+		ir->l->dev  = &adap->dev;
 		/* This will be returned by lirc_get_pdata() */
-		ir->l.data = ir;
-		ret = lirc_buffer_init(ir->l.rbuf, 2, BUFLEN / 2);
-		if (ret)
+		ir->l->data = ir;
+		ret = lirc_buffer_init(ir->l->rbuf, 2, BUFLEN / 2);
+		if (ret) {
+			lirc_free_device(ir->l);
+			ir->l = NULL;
 			goto out_put_ir;
+		}
 	}
 
 	if (tx_probe) {
@@ -1477,7 +1486,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		kref_init(&tx->ref);
 		ir->tx = tx;
 
-		ir->l.features |= LIRC_CAN_SEND_PULSE;
+		ir->l->features |= LIRC_CAN_SEND_PULSE;
 		mutex_init(&tx->client_lock);
 		tx->c = client;
 		tx->need_boot = 1;
@@ -1521,7 +1530,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		kref_init(&rx->ref);
 		ir->rx = rx;
 
-		ir->l.features |= LIRC_CAN_REC_LIRCCODE;
+		ir->l->features |= LIRC_CAN_REC_LIRCCODE;
 		mutex_init(&rx->client_lock);
 		rx->c = client;
 		rx->hdpvr_data_fmt =
@@ -1551,7 +1560,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			/* Failure exit, so put back rx ref from i2c_client */
 			i2c_set_clientdata(client, NULL);
 			put_ir_rx(rx, true);
-			ir->l.features &= ~LIRC_CAN_REC_LIRCCODE;
+			ir->l->features &= ~LIRC_CAN_REC_LIRCCODE;
 			goto out_put_tx;
 		}
 
@@ -1564,17 +1573,19 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	/* register with lirc */
-	ret = lirc_register_device(&ir->l);
+	ret = lirc_register_device(ir->l);
 	if (ret < 0) {
 		dev_err(tx->ir->dev,
 			"%s: lirc_register_device() failed: %i\n",
 			__func__, ret);
+		lirc_free_device(ir->l);
+		ir->l = NULL;
 		goto out_put_xx;
 	}
 
 	dev_info(ir->dev,
 		 "IR unit on %s (i2c-%d) registered as lirc%d and ready\n",
-		 adap->name, adap->nr, ir->l.minor);
+		 adap->name, adap->nr, ir->l->minor);
 
 out_ok:
 	if (rx)
