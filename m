Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34381 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965046AbdEOTmt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 May 2017 15:42:49 -0400
Received: by mail-wm0-f66.google.com with SMTP id d127so31071184wmf.1
        for <linux-media@vger.kernel.org>; Mon, 15 May 2017 12:42:48 -0700 (PDT)
From: Ricardo Silva <rjpdasilva@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Ricardo Silva <rjpdasilva@gmail.com>
Subject: [PATCH 1/5] staging: media: lirc: Fix whitespace style checks
Date: Mon, 15 May 2017 20:40:12 +0100
Message-Id: <20170515194016.10246-2-rjpdasilva@gmail.com>
In-Reply-To: <20170515194016.10246-1-rjpdasilva@gmail.com>
References: <20170515194016.10246-1-rjpdasilva@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix style issues reported by checkpatch, affecting whitespace only:

 * CHECK: "Please don't use multiple blank lines".
   Two of these still triggering and left untouched because used for
   separating logical blocks (vars from functions, etc.).

 * CHECK: "spaces preferred around that '<operator>'".
   All fixed.

 * CHECK: "Alignment should match open parenthesis".
   All fixed except one on line 1161, left untouched for readability.

Move towards recommended coding style without compromising readability.

Signed-off-by: Ricardo Silva <rjpdasilva@gmail.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 37 ++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 8ce1db04414a..0cb974461cd2 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -472,7 +472,7 @@ static int lirc_thread(void *arg)
 
 		/* if device not opened, we can sleep half a second */
 		if (atomic_read(&ir->open_count) == 0) {
-			schedule_timeout(HZ/2);
+			schedule_timeout(HZ / 2);
 			continue;
 		}
 
@@ -508,7 +508,7 @@ static void set_use_dec(void *data)
 
 /* safe read of a uint32 (always network byte order) */
 static int read_uint32(unsigned char **data,
-				     unsigned char *endp, unsigned int *val)
+		       unsigned char *endp, unsigned int *val)
 {
 	if (*data + 4 > endp)
 		return 0;
@@ -520,7 +520,7 @@ static int read_uint32(unsigned char **data,
 
 /* safe read of a uint8 */
 static int read_uint8(unsigned char **data,
-				    unsigned char *endp, unsigned char *val)
+		      unsigned char *endp, unsigned char *val)
 {
 	if (*data + 1 > endp)
 		return 0;
@@ -530,7 +530,7 @@ static int read_uint8(unsigned char **data,
 
 /* safe skipping of N bytes */
 static int skip(unsigned char **data,
-			      unsigned char *endp, unsigned int distance)
+		unsigned char *endp, unsigned int distance)
 {
 	if (*data + distance > endp)
 		return 0;
@@ -540,7 +540,7 @@ static int skip(unsigned char **data,
 
 /* decompress key data into the given buffer */
 static int get_key_data(unsigned char *buf,
-			     unsigned int codeset, unsigned int key)
+			unsigned int codeset, unsigned int key)
 {
 	unsigned char *data, *endp, *diffs, *key_block;
 	unsigned char keys, ndiffs, id;
@@ -810,7 +810,7 @@ static int fw_load(struct IR_tx *tx)
 		goto corrupt;
 
 	if (!read_uint32(&data, tx_data->endp,
-			      &tx_data->num_code_sets))
+			 &tx_data->num_code_sets))
 		goto corrupt;
 
 	dev_dbg(tx->ir->l.dev, "%u IR blaster codesets loaded\n",
@@ -866,12 +866,12 @@ static int fw_load(struct IR_tx *tx)
 		 * global fixed
 		 */
 		if (!skip(&data, tx_data->endp,
-			       1 + TX_BLOCK_SIZE - num_global_fixed))
+			  1 + TX_BLOCK_SIZE - num_global_fixed))
 			goto corrupt;
 
 		/* Then we have keys-1 blocks of key id+diffs */
 		if (!skip(&data, tx_data->endp,
-			       (ndiffs + 1) * (keys - 1)))
+			  (ndiffs + 1) * (keys - 1)))
 			goto corrupt;
 	}
 	ret = 0;
@@ -1065,7 +1065,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 			break;
 		dev_dbg(tx->ir->l.dev,
 			"NAK expected: i2c_master_send failed with %d (try %d)\n",
-			ret, i+1);
+			ret, i + 1);
 	}
 	if (ret != 1) {
 		dev_err(tx->ir->l.dev,
@@ -1231,7 +1231,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 	poll_wait(filep, &rbuf->wait_poll, wait);
 
 	/* Indicate what ops could happen immediately without blocking */
-	ret = lirc_buffer_empty(rbuf) ? 0 : (POLLIN|POLLRDNORM);
+	ret = lirc_buffer_empty(rbuf) ? 0 : (POLLIN | POLLRDNORM);
 
 	dev_dbg(ir->l.dev, "poll result = %s\n",
 		ret ? "POLLIN|POLLRDNORM" : "none");
@@ -1255,15 +1255,15 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		result = put_user(features, uptr);
 		break;
 	case LIRC_GET_REC_MODE:
-		if (!(features&LIRC_CAN_REC_MASK))
+		if (!(features & LIRC_CAN_REC_MASK))
 			return -ENOSYS;
 
 		result = put_user(LIRC_REC2MODE
-				  (features&LIRC_CAN_REC_MASK),
+				  (features & LIRC_CAN_REC_MASK),
 				  uptr);
 		break;
 	case LIRC_SET_REC_MODE:
-		if (!(features&LIRC_CAN_REC_MASK))
+		if (!(features & LIRC_CAN_REC_MASK))
 			return -ENOSYS;
 
 		result = get_user(mode, uptr);
@@ -1271,13 +1271,13 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 			result = -EINVAL;
 		break;
 	case LIRC_GET_SEND_MODE:
-		if (!(features&LIRC_CAN_SEND_MASK))
+		if (!(features & LIRC_CAN_SEND_MASK))
 			return -ENOSYS;
 
 		result = put_user(LIRC_MODE_PULSE, uptr);
 		break;
 	case LIRC_SET_SEND_MODE:
-		if (!(features&LIRC_CAN_SEND_MASK))
+		if (!(features & LIRC_CAN_SEND_MASK))
 			return -ENOSYS;
 
 		result = get_user(mode, uptr);
@@ -1426,7 +1426,6 @@ static int ir_remove(struct i2c_client *client)
 	return 0;
 }
 
-
 /* ir_devices_lock must be held */
 static struct IR *get_ir_device_by_adapter(struct i2c_adapter *adapter)
 {
@@ -1467,7 +1466,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return -ENXIO;
 
 	pr_info("probing IR %s on %s (i2c-%d)\n",
-		   tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
+		tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
 
 	mutex_lock(&ir_devices_lock);
 
@@ -1603,7 +1602,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		/* Proceed only if the Tx client is also ready */
 		if (tx == NULL) {
 			pr_info("probe of IR Rx on %s (i2c-%d) done. Waiting on IR Tx.\n",
-				   adap->name, adap->nr);
+				adap->name, adap->nr);
 			goto out_ok;
 		}
 	}
@@ -1614,7 +1613,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (ir->l.minor < 0 || ir->l.minor >= MAX_IRCTL_DEVICES) {
 		dev_err(tx->ir->l.dev,
 			"%s: \"minor\" must be between 0 and %d (%d)!\n",
-			__func__, MAX_IRCTL_DEVICES-1, ir->l.minor);
+			__func__, MAX_IRCTL_DEVICES - 1, ir->l.minor);
 		ret = -EBADRQC;
 		goto out_put_xx;
 	}
-- 
2.12.2
