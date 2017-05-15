Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35316 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965046AbdEOTmv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 May 2017 15:42:51 -0400
Received: by mail-wm0-f65.google.com with SMTP id v4so31118862wmb.2
        for <linux-media@vger.kernel.org>; Mon, 15 May 2017 12:42:51 -0700 (PDT)
From: Ricardo Silva <rjpdasilva@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Ricardo Silva <rjpdasilva@gmail.com>
Subject: [PATCH 2/5] staging: media: lirc: Fix NULL comparisons style
Date: Mon, 15 May 2017 20:40:13 +0100
Message-Id: <20170515194016.10246-3-rjpdasilva@gmail.com>
In-Reply-To: <20170515194016.10246-1-rjpdasilva@gmail.com>
References: <20170515194016.10246-1-rjpdasilva@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix all checkpatch reported issues for "CHECK: Comparison to NULL could
be written...".

Do these comparisons using the recommended coding style and consistent
with other similar cases in the file, which already used the recommended
way.

Signed-off-by: Ricardo Silva <rjpdasilva@gmail.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 48 ++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 0cb974461cd2..b33a2c820dc2 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -215,7 +215,7 @@ static struct IR_rx *get_ir_rx(struct IR *ir)
 
 	spin_lock(&ir->rx_ref_lock);
 	rx = ir->rx;
-	if (rx != NULL)
+	if (rx)
 		kref_get(&rx->ref);
 	spin_unlock(&ir->rx_ref_lock);
 	return rx;
@@ -277,7 +277,7 @@ static struct IR_tx *get_ir_tx(struct IR *ir)
 
 	spin_lock(&ir->tx_ref_lock);
 	tx = ir->tx;
-	if (tx != NULL)
+	if (tx)
 		kref_get(&tx->ref);
 	spin_unlock(&ir->tx_ref_lock);
 	return tx;
@@ -327,12 +327,12 @@ static int add_to_buf(struct IR *ir)
 	}
 
 	rx = get_ir_rx(ir);
-	if (rx == NULL)
+	if (!rx)
 		return -ENXIO;
 
 	/* Ensure our rx->c i2c_client remains valid for the duration */
 	mutex_lock(&rx->client_lock);
-	if (rx->c == NULL) {
+	if (!rx->c) {
 		mutex_unlock(&rx->client_lock);
 		put_ir_rx(rx, false);
 		return -ENXIO;
@@ -388,7 +388,7 @@ static int add_to_buf(struct IR *ir)
 				break;
 			}
 			schedule_timeout((100 * HZ + 999) / 1000);
-			if (tx != NULL)
+			if (tx)
 				tx->need_boot = 1;
 
 			++failures;
@@ -444,7 +444,7 @@ static int add_to_buf(struct IR *ir)
 	} while (!lirc_buffer_full(rbuf));
 
 	mutex_unlock(&rx->client_lock);
-	if (tx != NULL)
+	if (tx)
 		put_ir_tx(tx, false);
 	put_ir_rx(rx, false);
 	return ret;
@@ -772,7 +772,7 @@ static int fw_load(struct IR_tx *tx)
 
 	/* Parse the file */
 	tx_data = vmalloc(sizeof(*tx_data));
-	if (tx_data == NULL) {
+	if (!tx_data) {
 		release_firmware(fw_entry);
 		ret = -ENOMEM;
 		goto out;
@@ -781,7 +781,7 @@ static int fw_load(struct IR_tx *tx)
 
 	/* Copy the data so hotplug doesn't get confused and timeout */
 	tx_data->datap = vmalloc(fw_entry->size);
-	if (tx_data->datap == NULL) {
+	if (!tx_data->datap) {
 		release_firmware(fw_entry);
 		vfree(tx_data);
 		ret = -ENOMEM;
@@ -818,7 +818,7 @@ static int fw_load(struct IR_tx *tx)
 
 	tx_data->code_sets = vmalloc(
 		tx_data->num_code_sets * sizeof(char *));
-	if (tx_data->code_sets == NULL) {
+	if (!tx_data->code_sets) {
 		fw_unload_locked();
 		ret = -ENOMEM;
 		goto out;
@@ -905,7 +905,7 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 	}
 
 	rx = get_ir_rx(ir);
-	if (rx == NULL)
+	if (!rx)
 		return -ENXIO;
 
 	/*
@@ -1111,12 +1111,12 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
 
 	/* Get a struct IR_tx reference */
 	tx = get_ir_tx(ir);
-	if (tx == NULL)
+	if (!tx)
 		return -ENXIO;
 
 	/* Ensure our tx->c i2c_client remains valid for the duration */
 	mutex_lock(&tx->client_lock);
-	if (tx->c == NULL) {
+	if (!tx->c) {
 		mutex_unlock(&tx->client_lock);
 		put_ir_tx(tx, false);
 		return -ENXIO;
@@ -1215,7 +1215,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 	dev_dbg(ir->l.dev, "poll called\n");
 
 	rx = get_ir_rx(ir);
-	if (rx == NULL) {
+	if (!rx) {
 		/*
 		 * Revisit this, if our poll function ever reports writeable
 		 * status for Tx
@@ -1322,7 +1322,7 @@ static int open(struct inode *node, struct file *filep)
 	/* find our IR struct */
 	ir = get_ir_device_by_minor(minor);
 
-	if (ir == NULL)
+	if (!ir)
 		return -ENODEV;
 
 	atomic_inc(&ir->open_count);
@@ -1340,7 +1340,7 @@ static int close(struct inode *node, struct file *filep)
 	/* find our IR struct */
 	struct IR *ir = filep->private_data;
 
-	if (ir == NULL) {
+	if (!ir) {
 		pr_err("ir: close: no private_data attached to the file!\n");
 		return -ENODEV;
 	}
@@ -1407,7 +1407,7 @@ static int ir_remove(struct i2c_client *client)
 	if (strncmp("ir_tx_z8", client->name, 8) == 0) {
 		struct IR_tx *tx = i2c_get_clientdata(client);
 
-		if (tx != NULL) {
+		if (tx) {
 			mutex_lock(&tx->client_lock);
 			tx->c = NULL;
 			mutex_unlock(&tx->client_lock);
@@ -1416,7 +1416,7 @@ static int ir_remove(struct i2c_client *client)
 	} else if (strncmp("ir_rx_z8", client->name, 8) == 0) {
 		struct IR_rx *rx = i2c_get_clientdata(client);
 
-		if (rx != NULL) {
+		if (rx) {
 			mutex_lock(&rx->client_lock);
 			rx->c = NULL;
 			mutex_unlock(&rx->client_lock);
@@ -1472,7 +1472,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	/* Use a single struct IR instance for both the Rx and Tx functions */
 	ir = get_ir_device_by_adapter(adap);
-	if (ir == NULL) {
+	if (!ir) {
 		ir = kzalloc(sizeof(struct IR), GFP_KERNEL);
 		if (!ir) {
 			ret = -ENOMEM;
@@ -1546,7 +1546,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		fw_load(tx);
 
 		/* Proceed only if the Rx client is also ready or not needed */
-		if (rx == NULL && !tx_only) {
+		if (!rx && !tx_only) {
 			dev_info(tx->ir->l.dev,
 				 "probe of IR Tx on %s (i2c-%d) done. Waiting on IR Rx.\n",
 				 adap->name, adap->nr);
@@ -1600,7 +1600,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		}
 
 		/* Proceed only if the Tx client is also ready */
-		if (tx == NULL) {
+		if (!tx) {
 			pr_info("probe of IR Rx on %s (i2c-%d) done. Waiting on IR Tx.\n",
 				adap->name, adap->nr);
 			goto out_ok;
@@ -1622,9 +1622,9 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		 adap->name, adap->nr, ir->l.minor);
 
 out_ok:
-	if (rx != NULL)
+	if (rx)
 		put_ir_rx(rx, true);
-	if (tx != NULL)
+	if (tx)
 		put_ir_tx(tx, true);
 	put_ir_device(ir, true);
 	dev_info(ir->l.dev,
@@ -1634,10 +1634,10 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	return 0;
 
 out_put_xx:
-	if (rx != NULL)
+	if (rx)
 		put_ir_rx(rx, true);
 out_put_tx:
-	if (tx != NULL)
+	if (tx)
 		put_ir_tx(tx, true);
 out_put_ir:
 	put_ir_device(ir, true);
-- 
2.12.2
