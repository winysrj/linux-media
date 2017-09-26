Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:41587 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935367AbdIZUOD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:14:03 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 06/20] media: lirc_zilog: port to rc-core using scancode tx interface
Date: Tue, 26 Sep 2017 21:13:45 +0100
Message-Id: <3f73881229282cbd4918cadfaafb429fbe8839c1.1506455086.git.sean@mess.org>
In-Reply-To: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
References: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
In-Reply-To: <cover.1506455086.git.sean@mess.org>
References: <cover.1506455086.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that rc-core can send a scancode by rc protocol and scancode, port
the lirc_zilog to this interface. The firmware file needs updating
to contain the protocol and scancode, so we have haup-ir-blaster-v2.bin
for this.

The LIRC_MODE_LIRCCODE is no longer supported, and transmit can only
be done using the new LIRC_MODE_SCANCODE interface.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c        |  18 +-
 drivers/staging/media/lirc/lirc_zilog.c | 419 ++++++++++++--------------------
 include/media/rc-core.h                 |   2 +
 3 files changed, 166 insertions(+), 273 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index ff7c46cc201c..6fd19b816d92 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -122,6 +122,10 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	if (!lirc)
 		return -EFAULT;
 
+	dev = lirc->dev;
+	if (!dev)
+		return -EFAULT;
+
 	if (lirc->send_mode == LIRC_MODE_SCANCODE) {
 		struct lirc_scancode scan;
 
@@ -135,6 +139,11 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		    scan.timestamp)
 			return -EINVAL;
 
+		if (dev->tx_scancode) {
+			ret = dev->tx_scancode(dev, &scan);
+			return ret < 0 ? ret : n;
+		}
+
 		raw = kmalloc_array(LIRCBUF_SIZE, sizeof(*raw), GFP_KERNEL);
 		if (!raw)
 			return -ENOMEM;
@@ -175,12 +184,6 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 			return PTR_ERR(txbuf);
 	}
 
-	dev = lirc->dev;
-	if (!dev) {
-		ret = -EFAULT;
-		goto out;
-	}
-
 	if (!dev->tx_ir) {
 		ret = -EINVAL;
 		goto out;
@@ -406,6 +409,9 @@ static int ir_lirc_register(struct rc_dev *dev)
 			features |= LIRC_CAN_GET_REC_RESOLUTION;
 	}
 
+	if (dev->tx_scancode)
+		features |= LIRC_CAN_SEND_SCANCODE;
+
 	if (dev->tx_ir) {
 		features |= LIRC_CAN_SEND_PULSE | LIRC_CAN_SEND_SCANCODE;
 		if (dev->s_tx_mask)
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index d3225bd1b3a6..c7f1636abf38 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -41,11 +41,11 @@
 #include <linux/firmware.h>
 #include <linux/vmalloc.h>
 
-#include <media/lirc_dev.h>
-#include <media/lirc.h>
+#include <media/rc-core.h>
 
+#define DEVICE_NAME	"Zilog/Hauppauge i2c IR TX"
 /* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
+#define MAX_XFER_SIZE	64
 
 struct IR_tx {
 	/* TX device */
@@ -55,7 +55,8 @@ struct IR_tx {
 	/* TX additional actions needed */
 	bool need_boot;
 	bool post_tx_ready_poll;
-	struct lirc_dev *l;
+	struct rc_dev *rc;
+	char phys[32];
 };
 
 /* Block size for IR transmitter */
@@ -115,102 +116,99 @@ static int skip(u8 **data,
 }
 
 /* decompress key data into the given buffer */
-static int get_key_data(u8 *buf,
-			unsigned int codeset, unsigned int key)
+static int get_key_data(u8 *buf, enum rc_proto proto, u32 scancode)
 {
 	u8 *data, *endp, *diffs, *key_block;
-	u8 keys, ndiffs, id;
-	unsigned int base, lim, pos, i;
+	unsigned int lim, i, k, codeset;
+	u8 keys, ndiffs, p;
+	u32 protocols, s;
 
 	/* Binary search for the codeset */
-	for (base = 0, lim = tx_data->num_code_sets; lim; lim >>= 1) {
-		pos = base + (lim >> 1);
-		data = tx_data->code_sets[pos];
+	for (codeset = 0; codeset < tx_data->num_code_sets; codeset++) {
+		data = tx_data->code_sets[codeset];
 
-		if (!read_u32(&data, tx_data->endp, &i))
+		/* bitset protocols contained in this codeset */
+		if (!read_u32(&data, tx_data->endp, &protocols))
 			goto corrupt;
 
-		if (i == codeset) {
-			break;
-		} else if (codeset > i) {
-			base = pos + 1;
-			--lim;
-		}
-	}
-	/* Not found? */
-	if (!lim)
-		return -EPROTO;
-
-	/* Set end of data block */
-	endp = pos < tx_data->num_code_sets - 1 ?
-		tx_data->code_sets[pos + 1] : tx_data->endp;
-
-	/* Read the block header */
-	if (!read_u8(&data, endp, &keys) ||
-	    !read_u8(&data, endp, &ndiffs) ||
-	    ndiffs > TX_BLOCK_SIZE || keys == 0)
-		goto corrupt;
+		if (!(BIT(proto) & protocols))
+			continue;
 
-	/* Save diffs & skip */
-	diffs = data;
-	if (!skip(&data, endp, ndiffs))
-		goto corrupt;
+		/* Set end of data block */
+		endp = codeset < tx_data->num_code_sets - 1 ?
+			tx_data->code_sets[codeset] : tx_data->endp;
 
-	/* Read the id of the first key */
-	if (!read_u8(&data, endp, &id))
-		goto corrupt;
+		/* Read the block header */
+		if (!read_u8(&data, endp, &keys) ||
+		    !read_u8(&data, endp, &ndiffs) ||
+		    ndiffs > TX_BLOCK_SIZE || keys == 0)
+			goto corrupt;
 
-	/* Unpack the first key's data */
-	for (i = 0; i < TX_BLOCK_SIZE; ++i) {
-		if (tx_data->fixed[i] == -1) {
-			if (!read_u8(&data, endp, &buf[i]))
-				goto corrupt;
-		} else {
-			buf[i] = tx_data->fixed[i];
+		/* Save diffs & skip */
+		diffs = data;
+		if (!skip(&data, endp, ndiffs))
+			goto corrupt;
+
+		/* Read the protocol/scancode of the first key */
+		if (!read_u8(&data, endp, &p))
+			goto corrupt;
+
+		if (!read_u32(&data, endp, &s))
+			goto corrupt;
+
+		/* Unpack the first key's data */
+		for (i = 0; i < TX_BLOCK_SIZE; ++i) {
+			if (tx_data->fixed[i] == -1) {
+				if (!read_u8(&data, endp, &buf[i]))
+					goto corrupt;
+			} else {
+				buf[i] = tx_data->fixed[i];
+			}
 		}
-	}
 
-	/* Early out key found/not found */
-	if (key == id)
-		return 0;
-	if (keys == 1)
-		return -EPROTO;
+		/* Early out key found/not found */
+		if (p == proto && s == scancode)
+			return 0;
+		if (keys == 1)
+			continue;
 
-	/* Sanity check */
-	key_block = data;
-	if (!skip(&data, endp, (keys - 1) * (ndiffs + 1)))
-		goto corrupt;
+		/* Sanity check */
+		key_block = data;
+		if (!skip(&data, endp, (keys - 1) * (ndiffs + 1)))
+			goto corrupt;
+
+		/* Binary search for the key */
+		for (k = 0, lim = keys - 1; k < lim; k++) {
+			/* Seek to block */
+			u8 *key_data;
+
+			key_data = key_block + (ndiffs + 1) * k;
 
-	/* Binary search for the key */
-	for (base = 0, lim = keys - 1; lim; lim >>= 1) {
-		/* Seek to block */
-		u8 *key_data;
+			/* Read the protocol/scancode of the first key */
+			if (!read_u8(&key_data, endp, &p))
+				goto corrupt;
 
-		pos = base + (lim >> 1);
-		key_data = key_block + (ndiffs + 1) * pos;
+			if (!read_u32(&key_data, endp, &s))
+				goto corrupt;
 
-		if (*key_data == key) {
-			/* skip key id */
-			++key_data;
+			if (p == proto && s == scancode) {
+				/* found, so unpack the diffs */
+				for (i = 0; i < ndiffs; ++i) {
+					u8 val;
 
-			/* found, so unpack the diffs */
-			for (i = 0; i < ndiffs; ++i) {
-				u8 val;
+					if (!read_u8(&key_data, endp, &val) ||
+					    diffs[i] >= TX_BLOCK_SIZE)
+						goto corrupt;
+					buf[diffs[i]] = val;
+				}
 
-				if (!read_u8(&key_data, endp, &val) ||
-				    diffs[i] >= TX_BLOCK_SIZE)
-					goto corrupt;
-				buf[diffs[i]] = val;
+				return 0;
 			}
-
-			return 0;
-		} else if (key > *key_data) {
-			base = pos + 1;
-			--lim;
 		}
 	}
+
 	/* Key not found */
-	return -EPROTO;
+	return -EINVAL;
 
 corrupt:
 	pr_err("firmware is corrupt\n");
@@ -231,10 +229,10 @@ static int send_data_block(struct IR_tx *tx, u8 *data_block)
 		buf[0] = i + 1;
 		for (j = 0; j < tosend; ++j)
 			buf[1 + j] = data_block[i + j];
-		dev_dbg(&tx->l->dev, "%*ph", 5, buf);
+		dev_dbg(&tx->rc->dev, "%*ph", 5, buf);
 		ret = i2c_master_send(tx->c, buf, tosend + 1);
 		if (ret != tosend + 1) {
-			dev_err(&tx->l->dev,
+			dev_err(&tx->rc->dev,
 				"i2c_master_send failed with %d\n", ret);
 			return ret < 0 ? ret : -EFAULT;
 		}
@@ -259,7 +257,7 @@ static int send_boot_data(struct IR_tx *tx)
 	buf[1] = 0x20;
 	ret = i2c_master_send(tx->c, buf, 2);
 	if (ret != 2) {
-		dev_err(&tx->l->dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(&tx->rc->dev, "i2c_master_send failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
@@ -276,22 +274,22 @@ static int send_boot_data(struct IR_tx *tx)
 	}
 
 	if (ret != 1) {
-		dev_err(&tx->l->dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(&tx->rc->dev, "i2c_master_send failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
 	/* Here comes the firmware version... (hopefully) */
 	ret = i2c_master_recv(tx->c, buf, 4);
 	if (ret != 4) {
-		dev_err(&tx->l->dev, "i2c_master_recv failed with %d\n", ret);
+		dev_err(&tx->rc->dev, "i2c_master_recv failed with %d\n", ret);
 		return 0;
 	}
 	if ((buf[0] != 0x80) && (buf[0] != 0xa0)) {
-		dev_err(&tx->l->dev, "unexpected IR TX init response: %02x\n",
+		dev_err(&tx->rc->dev, "unexpected IR TX init response: %02x\n",
 			buf[0]);
 		return 0;
 	}
-	dev_notice(&tx->l->dev,
+	dev_notice(&tx->rc->dev,
 		   "Zilog/Hauppauge IR blaster firmware version %d.%d.%d loaded\n",
 		   buf[1], buf[2], buf[3]);
 
@@ -336,15 +334,16 @@ static int fw_load(struct IR_tx *tx)
 	}
 
 	/* Request codeset data file */
-	ret = request_firmware(&fw_entry, "haup-ir-blaster.bin", &tx->l->dev);
+	ret = request_firmware(&fw_entry, "haup-ir-blaster-v2.bin",
+			       &tx->rc->dev);
 	if (ret != 0) {
-		dev_err(&tx->l->dev,
+		dev_err(&tx->rc->dev,
 			"firmware haup-ir-blaster.bin not available (%d)\n",
 			ret);
 		ret = ret < 0 ? ret : -EFAULT;
 		goto out;
 	}
-	dev_dbg(&tx->l->dev, "firmware of size %zu loaded\n", fw_entry->size);
+	dev_dbg(&tx->rc->dev, "firmware of size %zu loaded\n", fw_entry->size);
 
 	/* Parse the file */
 	tx_data = vmalloc(sizeof(*tx_data));
@@ -371,9 +370,9 @@ static int fw_load(struct IR_tx *tx)
 	data = tx_data->datap;
 	if (!read_u8(&data, tx_data->endp, &version))
 		goto corrupt;
-	if (version != 1) {
-		dev_err(&tx->l->dev,
-			"unsupported code set file version (%u, expected 1) -- please upgrade to a newer driver\n",
+	if (version != 2) {
+		dev_err(&tx->rc->dev,
+			"unsupported code set file version (%u, expected 2)\n",
 			version);
 		fw_unload_locked();
 		ret = -EFAULT;
@@ -389,7 +388,7 @@ static int fw_load(struct IR_tx *tx)
 		      &tx_data->num_code_sets))
 		goto corrupt;
 
-	dev_dbg(&tx->l->dev, "%u IR blaster codesets loaded\n",
+	dev_dbg(&tx->rc->dev, "%u IR blaster codesets loaded\n",
 		tx_data->num_code_sets);
 
 	tx_data->code_sets = vmalloc(
@@ -454,7 +453,7 @@ static int fw_load(struct IR_tx *tx)
 	goto out;
 
 corrupt:
-	dev_err(&tx->l->dev, "firmware is corrupt\n");
+	dev_err(&tx->rc->dev, "firmware is corrupt\n");
 	fw_unload_locked();
 	ret = -EFAULT;
 
@@ -474,7 +473,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	ret = get_key_data(data_block, code, key);
 
 	if (ret == -EPROTO) {
-		dev_err(&tx->l->dev,
+		dev_err(&tx->rc->dev,
 			"failed to get data for code %u, key %u -- check lircd.conf entries\n",
 			code, key);
 		return ret;
@@ -492,7 +491,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	buf[1] = 0x40;
 	ret = i2c_master_send(tx->c, buf, 2);
 	if (ret != 2) {
-		dev_err(&tx->l->dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(&tx->rc->dev, "i2c_master_send failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
@@ -505,18 +504,18 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	}
 
 	if (ret != 1) {
-		dev_err(&tx->l->dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(&tx->rc->dev, "i2c_master_send failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
 	/* Send finished download? */
 	ret = i2c_master_recv(tx->c, buf, 1);
 	if (ret != 1) {
-		dev_err(&tx->l->dev, "i2c_master_recv failed with %d\n", ret);
+		dev_err(&tx->rc->dev, "i2c_master_recv failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 	if (buf[0] != 0xA0) {
-		dev_err(&tx->l->dev, "unexpected IR TX response #1: %02x\n",
+		dev_err(&tx->rc->dev, "unexpected IR TX response #1: %02x\n",
 			buf[0]);
 		return -EFAULT;
 	}
@@ -526,7 +525,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	buf[1] = 0x80;
 	ret = i2c_master_send(tx->c, buf, 2);
 	if (ret != 2) {
-		dev_err(&tx->l->dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(&tx->rc->dev, "i2c_master_send failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
@@ -536,7 +535,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	 * going to skip this whole mess and say we're done on the HD PVR
 	 */
 	if (!tx->post_tx_ready_poll) {
-		dev_dbg(&tx->l->dev, "sent code %u, key %u\n", code, key);
+		dev_dbg(&tx->rc->dev, "sent code %u, key %u\n", code, key);
 		return 0;
 	}
 
@@ -552,12 +551,12 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 		ret = i2c_master_send(tx->c, buf, 1);
 		if (ret == 1)
 			break;
-		dev_dbg(&tx->l->dev,
+		dev_dbg(&tx->rc->dev,
 			"NAK expected: i2c_master_send failed with %d (try %d)\n",
 			ret, i + 1);
 	}
 	if (ret != 1) {
-		dev_err(&tx->l->dev,
+		dev_err(&tx->rc->dev,
 			"IR TX chip never got ready: last i2c_master_send failed with %d\n",
 			ret);
 		return ret < 0 ? ret : -EFAULT;
@@ -566,78 +565,47 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	/* Seems to be an 'ok' response */
 	i = i2c_master_recv(tx->c, buf, 1);
 	if (i != 1) {
-		dev_err(&tx->l->dev, "i2c_master_recv failed with %d\n", ret);
+		dev_err(&tx->rc->dev, "i2c_master_recv failed with %d\n", ret);
 		return -EFAULT;
 	}
 	if (buf[0] != 0x80) {
-		dev_err(&tx->l->dev, "unexpected IR TX response #2: %02x\n",
+		dev_err(&tx->rc->dev, "unexpected IR TX response #2: %02x\n",
 			buf[0]);
 		return -EFAULT;
 	}
 
 	/* Oh good, it worked */
-	dev_dbg(&tx->l->dev, "sent code %u, key %u\n", code, key);
+	dev_dbg(&tx->rc->dev, "sent code %u, key %u\n", code, key);
 	return 0;
 }
 
-/*
- * Write a code to the device.  We take in a 32-bit number (an int) and then
- * decode this to a codeset/key index.  The key data is then decompressed and
- * sent to the device.  We have a spin lock as per i2c documentation to prevent
- * multiple concurrent sends which would probably cause the device to explode.
- */
-static ssize_t write(struct file *filep, const char __user *buf, size_t n,
-		     loff_t *ppos)
+static int tx_scancode(struct rc_dev *rcdev, struct lirc_scancode *lsc)
 {
-	struct IR_tx *tx = lirc_get_pdata(filep);
-	size_t i;
+	struct IR_tx *tx = rcdev->priv;
 	int failures = 0;
+	int ret;
 
-	/* Validate user parameters */
-	if (n % sizeof(int))
-		return -EINVAL;
-
-	/* Ensure our tx->c i2c_client remains valid for the duration */
 	mutex_lock(&tx->client_lock);
-	if (!tx->c) {
-		mutex_unlock(&tx->client_lock);
-		return -ENXIO;
-	}
-
-	/* Send each keypress */
-	for (i = 0; i < n;) {
-		int ret = 0;
-		int command;
 
-		if (copy_from_user(&command, buf + i, sizeof(command))) {
+	/* Send boot data first if required */
+	if (tx->need_boot) {
+		/* Make sure we have the 'firmware' loaded, first */
+		ret = fw_load(tx);
+		if (ret != 0) {
 			mutex_unlock(&tx->client_lock);
-			return -EFAULT;
-		}
-
-		/* Send boot data first if required */
-		if (tx->need_boot) {
-			/* Make sure we have the 'firmware' loaded, first */
-			ret = fw_load(tx);
-			if (ret != 0) {
-				mutex_unlock(&tx->client_lock);
-				if (ret != -ENOMEM)
-					ret = -EIO;
-				return ret;
-			}
-			/* Prep the chip for transmitting codes */
-			ret = send_boot_data(tx);
-			if (ret == 0)
-				tx->need_boot = false;
+			return ret;
 		}
+		/* Prep the chip for transmitting codes */
+		ret = send_boot_data(tx);
+		if (ret == 0)
+			tx->need_boot = false;
+	}
 
-		/* Send the code */
-		if (ret == 0) {
-			ret = send_code(tx, (unsigned int)command >> 16,
-					(unsigned int)command & 0xFFFF);
-			if (ret == -EPROTO) {
-				mutex_unlock(&tx->client_lock);
-				return ret;
-			}
+	do {
+		ret = send_code(tx, lsc->rc_proto, lsc->scancode);
+		if (ret == -EINVAL) {
+			mutex_unlock(&tx->client_lock);
+			return ret;
 		}
 
 		/*
@@ -646,11 +614,11 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
 		 */
 		if (ret != 0) {
 			/* Looks like the chip crashed, reset it */
-			dev_err(&tx->l->dev,
+			dev_err(&rcdev->dev,
 				"sending to the IR transmitter chip failed, trying reset\n");
 
 			if (failures >= 3) {
-				dev_err(&tx->l->dev,
+				dev_err(&rcdev->dev,
 					"unable to send to the IR chip after 3 resets, giving up\n");
 				mutex_unlock(&tx->client_lock);
 				return ret;
@@ -659,83 +627,12 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
 			schedule_timeout((100 * HZ + 999) / 1000);
 			tx->need_boot = true;
 			++failures;
-		} else {
-			i += sizeof(int);
 		}
-	}
+	} while (ret != 0);
 
 	mutex_unlock(&tx->client_lock);
 
-	/* All looks good */
-	return n;
-}
-
-static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
-{
-	struct IR_tx *tx = lirc_get_pdata(filep);
-	unsigned long __user *uptr = (unsigned long __user *)arg;
-	int result;
-	unsigned long mode, features;
-
-	features = tx->l->features;
-
-	switch (cmd) {
-	case LIRC_GET_LENGTH:
-		result = put_user(13UL, uptr);
-		break;
-	case LIRC_GET_FEATURES:
-		result = put_user(features, uptr);
-		break;
-	case LIRC_GET_REC_MODE:
-		if (!(features & LIRC_CAN_REC_MASK))
-			return -ENOTTY;
-
-		result = put_user(LIRC_REC2MODE
-				  (features & LIRC_CAN_REC_MASK),
-				  uptr);
-		break;
-	case LIRC_SET_REC_MODE:
-		if (!(features & LIRC_CAN_REC_MASK))
-			return -ENOTTY;
-
-		result = get_user(mode, uptr);
-		if (!result && !(LIRC_MODE2REC(mode) & features))
-			result = -ENOTTY;
-		break;
-	case LIRC_GET_SEND_MODE:
-		if (!(features & LIRC_CAN_SEND_MASK))
-			return -ENOTTY;
-
-		result = put_user(LIRC_MODE_LIRCCODE, uptr);
-		break;
-	case LIRC_SET_SEND_MODE:
-		if (!(features & LIRC_CAN_SEND_MASK))
-			return -ENOTTY;
-
-		result = get_user(mode, uptr);
-		if (!result && mode != LIRC_MODE_LIRCCODE)
-			return -EINVAL;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return result;
-}
-
-/*
- * Open the IR device.
- */
-static int open(struct inode *node, struct file *filep)
-{
-	lirc_init_pdata(node, filep);
-	nonseekable_open(node, filep);
-	return 0;
-}
-
-/* Close the IR device */
-static int close(struct inode *node, struct file *filep)
-{
-	return 0;
+	return ret;
 }
 
 static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id);
@@ -751,28 +648,17 @@ MODULE_DEVICE_TABLE(i2c, ir_transceiver_id);
 
 static struct i2c_driver zilog_driver = {
 	.driver = {
-		.name	= "Zilog/Hauppauge i2c IR",
+		.name	= DEVICE_NAME,
 	},
 	.probe		= ir_probe,
 	.id_table	= ir_transceiver_id,
 };
 
-static const struct file_operations lirc_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= write,
-	.unlocked_ioctl	= ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= ioctl,
-#endif
-	.open		= open,
-	.release	= close
-};
-
 static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct IR_tx *tx;
 	struct i2c_adapter *adap = client->adapter;
+	struct rc_dev *rcdev;
 	int ret;
 
 	dev_dbg(&client->dev, "%s: %s on i2c-%d (%s), client addr=0x%02x\n",
@@ -786,43 +672,42 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (!tx)
 		return -ENOMEM;
 
+	rcdev = devm_rc_allocate_device(&client->dev, RC_DRIVER_IR_RAW_TX);
+	if (!rcdev)
+		return -ENOMEM;
+
+	snprintf(tx->phys, sizeof(tx->phys), "%s/%s/tx0", dev_name(&adap->dev),
+		 dev_name(&client->dev));
+
+	rcdev->driver_name = KBUILD_MODNAME;
+	rcdev->device_name = DEVICE_NAME;
+	rcdev->input_id.bustype = BUS_I2C;
+	rcdev->input_phys = tx->phys;
+	rcdev->tx_scancode = tx_scancode;
+	rcdev->priv = tx;
+
+	tx->rc = rcdev;
+
+	printk(KBUILD_MODNAME ": " DEVICE_NAME " detected at %s [%s]\n",
+	       tx->phys, adap->name);
+
 	mutex_init(&tx->client_lock);
 	tx->c = client;
 	tx->need_boot = true;
 	tx->post_tx_ready_poll = !(id->driver_data & ID_FLAG_HDPVR);
 
-	/* set lirc_dev stuff */
-	tx->l = lirc_allocate_device();
-	if (!tx->l)
-		return -ENOMEM;
-
-	snprintf(tx->l->name, sizeof(tx->l->name), "lirc_zilog");
-	tx->l->features |= LIRC_CAN_SEND_LIRCCODE;
-	tx->l->code_length = 13;
-	tx->l->fops = &lirc_fops;
-	tx->l->owner = THIS_MODULE;
-	tx->l->dev.parent = &client->dev;
-
-	/* register with lirc */
-	ret = lirc_register_device(tx->l);
-	if (ret < 0) {
-		dev_err(&tx->l->dev, "%s: lirc_register_device() failed: %i\n",
-			__func__, ret);
-		lirc_free_device(tx->l);
-		tx->l = NULL;
+	ret = devm_rc_register_device(&client->dev, rcdev);
+	if (ret)
 		return ret;
-	}
 
 	/*
 	 * Load the 'firmware'.  We do this before registering with
-	 * lirc_dev, so the first firmware load attempt does not happen
+	 * rc_dev, so the first firmware load attempt does not happen
 	 * after a open() or write() call on the device.
 	 */
 	ret = fw_load(tx);
-	if (ret < 0) {
-		lirc_unregister_device(tx->l);
+	if (ret < 0)
 		return ret;
-	}
 
 	/* A tx ref goes to the i2c_client */
 	i2c_set_clientdata(client, tx);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index ca48632ec8e2..b74b3165dc78 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -125,6 +125,7 @@ enum rc_filter_type {
  * @s_tx_duty_cycle: set transmit duty cycle (0% - 100%)
  * @s_rx_carrier_range: inform driver about carrier it is expected to handle
  * @tx_ir: transmit IR
+ * @tx_scancode: transmit scancode
  * @s_idle: enable/disable hardware idle mode, upon which,
  *	device doesn't interrupt host until it sees IR pulses
  * @s_learning_mode: enable wide band receiver used for learning
@@ -182,6 +183,7 @@ struct rc_dev {
 	int				(*s_tx_duty_cycle)(struct rc_dev *dev, u32 duty_cycle);
 	int				(*s_rx_carrier_range)(struct rc_dev *dev, u32 min, u32 max);
 	int				(*tx_ir)(struct rc_dev *dev, unsigned *txbuf, unsigned n);
+	int				(*tx_scancode)(struct rc_dev *dev, struct lirc_scancode *scancode);
 	void				(*s_idle)(struct rc_dev *dev, bool enable);
 	int				(*s_learning_mode)(struct rc_dev *dev, int enable);
 	int				(*s_carrier_report) (struct rc_dev *dev, int enable);
-- 
2.13.5
