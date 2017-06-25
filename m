Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56442 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdFYMc2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:32:28 -0400
Subject: [PATCH 14/19] lirc_zilog: add a pointer to the parent device to
 struct IR
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:32:25 +0200
Message-ID: <149839394592.28811.14421406746665015410.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lirc_zilog stashes a pointer to the parent device in struct lirc_dev and uses
it for logging. It makes more sense to let lirc_zilog keep track of that
pointer in its own struct (this is in preparation for subsequent patches
which will remodel struct lirc_dev).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/staging/media/lirc/lirc_zilog.c |   98 ++++++++++++++++---------------
 1 file changed, 50 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index f54b66de4a27..51512ba7f5b8 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -109,6 +109,7 @@ struct IR {
 	struct mutex ir_lock;
 	atomic_t open_count;
 
+	struct device *dev;
 	struct i2c_adapter *adapter;
 
 	spinlock_t rx_ref_lock; /* struct IR_rx kref get()/put() */
@@ -322,7 +323,7 @@ static int add_to_buf(struct IR *ir)
 	struct IR_tx *tx;
 
 	if (lirc_buffer_full(rbuf)) {
-		dev_dbg(ir->l.dev, "buffer overflow\n");
+		dev_dbg(ir->dev, "buffer overflow\n");
 		return -EOVERFLOW;
 	}
 
@@ -368,17 +369,17 @@ static int add_to_buf(struct IR *ir)
 		 */
 		ret = i2c_master_send(rx->c, sendbuf, 1);
 		if (ret != 1) {
-			dev_err(ir->l.dev, "i2c_master_send failed with %d\n",
+			dev_err(ir->dev, "i2c_master_send failed with %d\n",
 				ret);
 			if (failures >= 3) {
 				mutex_unlock(&ir->ir_lock);
-				dev_err(ir->l.dev,
+				dev_err(ir->dev,
 					"unable to read from the IR chip after 3 resets, giving up\n");
 				break;
 			}
 
 			/* Looks like the chip crashed, reset it */
-			dev_err(ir->l.dev,
+			dev_err(ir->dev,
 				"polling the IR receiver chip failed, trying reset\n");
 
 			set_current_state(TASK_UNINTERRUPTIBLE);
@@ -405,14 +406,14 @@ static int add_to_buf(struct IR *ir)
 		ret = i2c_master_recv(rx->c, keybuf, sizeof(keybuf));
 		mutex_unlock(&ir->ir_lock);
 		if (ret != sizeof(keybuf)) {
-			dev_err(ir->l.dev,
+			dev_err(ir->dev,
 				"i2c_master_recv failed with %d -- keeping last read buffer\n",
 				ret);
 		} else {
 			rx->b[0] = keybuf[3];
 			rx->b[1] = keybuf[4];
 			rx->b[2] = keybuf[5];
-			dev_dbg(ir->l.dev,
+			dev_dbg(ir->dev,
 				"key (0x%02x/0x%02x)\n",
 				rx->b[0], rx->b[1]);
 		}
@@ -465,7 +466,7 @@ static int lirc_thread(void *arg)
 	struct IR *ir = arg;
 	struct lirc_buffer *rbuf = ir->l.rbuf;
 
-	dev_dbg(ir->l.dev, "poll thread started\n");
+	dev_dbg(ir->dev, "poll thread started\n");
 
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -493,7 +494,7 @@ static int lirc_thread(void *arg)
 			wake_up_interruptible(&rbuf->wait_poll);
 	}
 
-	dev_dbg(ir->l.dev, "poll thread ended\n");
+	dev_dbg(ir->dev, "poll thread ended\n");
 	return 0;
 }
 
@@ -646,10 +647,10 @@ static int send_data_block(struct IR_tx *tx, unsigned char *data_block)
 		buf[0] = (unsigned char)(i + 1);
 		for (j = 0; j < tosend; ++j)
 			buf[1 + j] = data_block[i + j];
-		dev_dbg(tx->ir->l.dev, "%*ph", 5, buf);
+		dev_dbg(tx->ir->dev, "%*ph", 5, buf);
 		ret = i2c_master_send(tx->c, buf, tosend + 1);
 		if (ret != tosend + 1) {
-			dev_err(tx->ir->l.dev,
+			dev_err(tx->ir->dev,
 				"i2c_master_send failed with %d\n", ret);
 			return ret < 0 ? ret : -EFAULT;
 		}
@@ -674,7 +675,7 @@ static int send_boot_data(struct IR_tx *tx)
 	buf[1] = 0x20;
 	ret = i2c_master_send(tx->c, buf, 2);
 	if (ret != 2) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(tx->ir->dev, "i2c_master_send failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
@@ -691,22 +692,22 @@ static int send_boot_data(struct IR_tx *tx)
 	}
 
 	if (ret != 1) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(tx->ir->dev, "i2c_master_send failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
 	/* Here comes the firmware version... (hopefully) */
 	ret = i2c_master_recv(tx->c, buf, 4);
 	if (ret != 4) {
-		dev_err(tx->ir->l.dev, "i2c_master_recv failed with %d\n", ret);
+		dev_err(tx->ir->dev, "i2c_master_recv failed with %d\n", ret);
 		return 0;
 	}
 	if ((buf[0] != 0x80) && (buf[0] != 0xa0)) {
-		dev_err(tx->ir->l.dev, "unexpected IR TX init response: %02x\n",
+		dev_err(tx->ir->dev, "unexpected IR TX init response: %02x\n",
 			buf[0]);
 		return 0;
 	}
-	dev_notice(tx->ir->l.dev,
+	dev_notice(tx->ir->dev,
 		   "Zilog/Hauppauge IR blaster firmware version %d.%d.%d loaded\n",
 		   buf[1], buf[2], buf[3]);
 
@@ -751,15 +752,15 @@ static int fw_load(struct IR_tx *tx)
 	}
 
 	/* Request codeset data file */
-	ret = request_firmware(&fw_entry, "haup-ir-blaster.bin", tx->ir->l.dev);
+	ret = request_firmware(&fw_entry, "haup-ir-blaster.bin", tx->ir->dev);
 	if (ret != 0) {
-		dev_err(tx->ir->l.dev,
+		dev_err(tx->ir->dev,
 			"firmware haup-ir-blaster.bin not available (%d)\n",
 			ret);
 		ret = ret < 0 ? ret : -EFAULT;
 		goto out;
 	}
-	dev_dbg(tx->ir->l.dev, "firmware of size %zu loaded\n", fw_entry->size);
+	dev_dbg(tx->ir->dev, "firmware of size %zu loaded\n", fw_entry->size);
 
 	/* Parse the file */
 	tx_data = vmalloc(sizeof(*tx_data));
@@ -787,7 +788,7 @@ static int fw_load(struct IR_tx *tx)
 	if (!read_uint8(&data, tx_data->endp, &version))
 		goto corrupt;
 	if (version != 1) {
-		dev_err(tx->ir->l.dev,
+		dev_err(tx->ir->dev,
 			"unsupported code set file version (%u, expected 1) -- please upgrade to a newer driver\n",
 			version);
 		fw_unload_locked();
@@ -804,7 +805,7 @@ static int fw_load(struct IR_tx *tx)
 			 &tx_data->num_code_sets))
 		goto corrupt;
 
-	dev_dbg(tx->ir->l.dev, "%u IR blaster codesets loaded\n",
+	dev_dbg(tx->ir->dev, "%u IR blaster codesets loaded\n",
 		tx_data->num_code_sets);
 
 	tx_data->code_sets = vmalloc(
@@ -869,7 +870,7 @@ static int fw_load(struct IR_tx *tx)
 	goto out;
 
 corrupt:
-	dev_err(tx->ir->l.dev, "firmware is corrupt\n");
+	dev_err(tx->ir->dev, "firmware is corrupt\n");
 	fw_unload_locked();
 	ret = -EFAULT;
 
@@ -889,9 +890,9 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 	unsigned int m;
 	DECLARE_WAITQUEUE(wait, current);
 
-	dev_dbg(ir->l.dev, "read called\n");
+	dev_dbg(ir->dev, "read called\n");
 	if (n % rbuf->chunk_size) {
-		dev_dbg(ir->l.dev, "read result = -EINVAL\n");
+		dev_dbg(ir->dev, "read result = -EINVAL\n");
 		return -EINVAL;
 	}
 
@@ -935,7 +936,7 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 			unsigned char buf[MAX_XFER_SIZE];
 
 			if (rbuf->chunk_size > sizeof(buf)) {
-				dev_err(ir->l.dev,
+				dev_err(ir->dev,
 					"chunk_size is too big (%d)!\n",
 					rbuf->chunk_size);
 				ret = -EINVAL;
@@ -950,7 +951,7 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 				retries++;
 			}
 			if (retries >= 5) {
-				dev_err(ir->l.dev, "Buffer read failed!\n");
+				dev_err(ir->dev, "Buffer read failed!\n");
 				ret = -EIO;
 			}
 		}
@@ -960,7 +961,7 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 	put_ir_rx(rx, false);
 	set_current_state(TASK_RUNNING);
 
-	dev_dbg(ir->l.dev, "read result = %d (%s)\n", ret,
+	dev_dbg(ir->dev, "read result = %d (%s)\n", ret,
 		ret ? "Error" : "OK");
 
 	return ret ? ret : written;
@@ -977,7 +978,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	ret = get_key_data(data_block, code, key);
 
 	if (ret == -EPROTO) {
-		dev_err(tx->ir->l.dev,
+		dev_err(tx->ir->dev,
 			"failed to get data for code %u, key %u -- check lircd.conf entries\n",
 			code, key);
 		return ret;
@@ -995,7 +996,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	buf[1] = 0x40;
 	ret = i2c_master_send(tx->c, buf, 2);
 	if (ret != 2) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(tx->ir->dev, "i2c_master_send failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
@@ -1008,18 +1009,18 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	}
 
 	if (ret != 1) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(tx->ir->dev, "i2c_master_send failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
 	/* Send finished download? */
 	ret = i2c_master_recv(tx->c, buf, 1);
 	if (ret != 1) {
-		dev_err(tx->ir->l.dev, "i2c_master_recv failed with %d\n", ret);
+		dev_err(tx->ir->dev, "i2c_master_recv failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 	if (buf[0] != 0xA0) {
-		dev_err(tx->ir->l.dev, "unexpected IR TX response #1: %02x\n",
+		dev_err(tx->ir->dev, "unexpected IR TX response #1: %02x\n",
 			buf[0]);
 		return -EFAULT;
 	}
@@ -1029,7 +1030,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	buf[1] = 0x80;
 	ret = i2c_master_send(tx->c, buf, 2);
 	if (ret != 2) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(tx->ir->dev, "i2c_master_send failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
@@ -1039,7 +1040,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	 * going to skip this whole mess and say we're done on the HD PVR
 	 */
 	if (!tx->post_tx_ready_poll) {
-		dev_dbg(tx->ir->l.dev, "sent code %u, key %u\n", code, key);
+		dev_dbg(tx->ir->dev, "sent code %u, key %u\n", code, key);
 		return 0;
 	}
 
@@ -1055,12 +1056,12 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 		ret = i2c_master_send(tx->c, buf, 1);
 		if (ret == 1)
 			break;
-		dev_dbg(tx->ir->l.dev,
+		dev_dbg(tx->ir->dev,
 			"NAK expected: i2c_master_send failed with %d (try %d)\n",
 			ret, i + 1);
 	}
 	if (ret != 1) {
-		dev_err(tx->ir->l.dev,
+		dev_err(tx->ir->dev,
 			"IR TX chip never got ready: last i2c_master_send failed with %d\n",
 			ret);
 		return ret < 0 ? ret : -EFAULT;
@@ -1069,17 +1070,17 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	/* Seems to be an 'ok' response */
 	i = i2c_master_recv(tx->c, buf, 1);
 	if (i != 1) {
-		dev_err(tx->ir->l.dev, "i2c_master_recv failed with %d\n", ret);
+		dev_err(tx->ir->dev, "i2c_master_recv failed with %d\n", ret);
 		return -EFAULT;
 	}
 	if (buf[0] != 0x80) {
-		dev_err(tx->ir->l.dev, "unexpected IR TX response #2: %02x\n",
+		dev_err(tx->ir->dev, "unexpected IR TX response #2: %02x\n",
 			buf[0]);
 		return -EFAULT;
 	}
 
 	/* Oh good, it worked */
-	dev_dbg(tx->ir->l.dev, "sent code %u, key %u\n", code, key);
+	dev_dbg(tx->ir->dev, "sent code %u, key %u\n", code, key);
 	return 0;
 }
 
@@ -1165,11 +1166,11 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
 		 */
 		if (ret != 0) {
 			/* Looks like the chip crashed, reset it */
-			dev_err(tx->ir->l.dev,
+			dev_err(tx->ir->dev,
 				"sending to the IR transmitter chip failed, trying reset\n");
 
 			if (failures >= 3) {
-				dev_err(tx->ir->l.dev,
+				dev_err(tx->ir->dev,
 					"unable to send to the IR chip after 3 resets, giving up\n");
 				mutex_unlock(&ir->ir_lock);
 				mutex_unlock(&tx->client_lock);
@@ -1205,7 +1206,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 	struct lirc_buffer *rbuf = ir->l.rbuf;
 	unsigned int ret;
 
-	dev_dbg(ir->l.dev, "%s called\n", __func__);
+	dev_dbg(ir->dev, "%s called\n", __func__);
 
 	rx = get_ir_rx(ir);
 	if (!rx) {
@@ -1213,7 +1214,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 		 * Revisit this, if our poll function ever reports writeable
 		 * status for Tx
 		 */
-		dev_dbg(ir->l.dev, "%s result = POLLERR\n", __func__);
+		dev_dbg(ir->dev, "%s result = POLLERR\n", __func__);
 		return POLLERR;
 	}
 
@@ -1226,7 +1227,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 	/* Indicate what ops could happen immediately without blocking */
 	ret = lirc_buffer_empty(rbuf) ? 0 : (POLLIN | POLLRDNORM);
 
-	dev_dbg(ir->l.dev, "%s result = %s\n", __func__,
+	dev_dbg(ir->dev, "%s result = %s\n", __func__,
 		ret ? "POLLIN|POLLRDNORM" : "none");
 	return ret;
 }
@@ -1438,6 +1439,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		list_add_tail(&ir->list, &ir_devices_list);
 
 		ir->adapter = adap;
+		ir->dev = &adap->dev;
 		mutex_init(&ir->ir_lock);
 		atomic_set(&ir->open_count, 0);
 		spin_lock_init(&ir->tx_ref_lock);
@@ -1501,7 +1503,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 		/* Proceed only if the Rx client is also ready or not needed */
 		if (!rx && !tx_only) {
-			dev_info(tx->ir->l.dev,
+			dev_info(tx->ir->dev,
 				 "probe of IR Tx on %s (i2c-%d) done. Waiting on IR Rx.\n",
 				 adap->name, adap->nr);
 			goto out_ok;
@@ -1541,7 +1543,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 				       "zilog-rx-i2c-%d", adap->nr);
 		if (IS_ERR(rx->task)) {
 			ret = PTR_ERR(rx->task);
-			dev_err(tx->ir->l.dev,
+			dev_err(tx->ir->dev,
 				"%s: could not start IR Rx polling thread\n",
 				__func__);
 			/* Failed kthread, so put back the ir ref */
@@ -1564,13 +1566,13 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	/* register with lirc */
 	ret = lirc_register_device(&ir->l);
 	if (ret < 0) {
-		dev_err(tx->ir->l.dev,
+		dev_err(tx->ir->dev,
 			"%s: lirc_register_device() failed: %i\n",
 			__func__, ret);
 		goto out_put_xx;
 	}
 
-	dev_info(ir->l.dev,
+	dev_info(ir->dev,
 		 "IR unit on %s (i2c-%d) registered as lirc%d and ready\n",
 		 adap->name, adap->nr, ir->l.minor);
 
@@ -1580,7 +1582,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (tx)
 		put_ir_tx(tx, true);
 	put_ir_device(ir, true);
-	dev_info(ir->l.dev,
+	dev_info(ir->dev,
 		 "probe of IR %s on %s (i2c-%d) done\n",
 		 tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
 	mutex_unlock(&ir_devices_lock);
