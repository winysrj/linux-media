Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:54215 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751421AbdBYMWI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 07:22:08 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 14/19] [media] lirc: implement scancode sending
Date: Sat, 25 Feb 2017 11:51:29 +0000
Message-Id: <0b91b24ac228df8adee17c9ba3a9ab24a1e47389.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This introduces a new lirc mode: scancode. Any device which can send raw IR
can also send scancodes.

int main()
{
	int fd, mode, rc;
	fd = open("/dev/lirc0", O_RDWR);

        mode = LIRC_MODE_SCANCODE;
	if (ioctl(fd, LIRC_SET_SEND_MODE, &mode)) {
		// kernel too old or lirc does not support transmit
	}
	struct lirc_scancode scancode = {
		.scancode = 0x1e3d,
		.rc_type = RC_TYPE_RC5,
		.flags = 0,
		.timestamp = 0
	};
	write(fd, &scancode, sizeof(scancode));
	close(fd);
}

Note that toggle (rc5, rc6) and repeats (nec) are not implemented. Nor is
there a method for holding down a key for a period.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 64 ++++++++++++++++++++++++++-------
 drivers/media/rc/rc-core-priv.h  |  1 +
 include/media/rc-map.h           | 54 +---------------------------
 include/uapi/linux/lirc.h        | 76 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 130 insertions(+), 65 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 74f7863..85f333d 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -91,6 +91,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	struct lirc_node *lirc;
 	struct rc_dev *dev;
 	unsigned int *txbuf; /* buffer with values to transmit */
+	struct ir_raw_event *raw = NULL;
 	ssize_t ret = -EINVAL;
 	size_t count;
 	ktime_t start;
@@ -104,16 +105,49 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	if (!lirc)
 		return -EFAULT;
 
-	if (n < sizeof(unsigned) || n % sizeof(unsigned))
-		return -EINVAL;
+	if (lirc->send_mode == LIRC_MODE_SCANCODE) {
+		struct lirc_scancode scan;
 
-	count = n / sizeof(unsigned);
-	if (count > LIRCBUF_SIZE || count % 2 == 0)
-		return -EINVAL;
+		if (n != sizeof(scan))
+			return -EINVAL;
+
+		if (copy_from_user(&scan, buf, sizeof(scan)))
+			return -EFAULT;
+
+		if (scan.flags || scan.timestamp)
+			return -EINVAL;
+
+		raw = kmalloc_array(LIRCBUF_SIZE, sizeof(*raw), GFP_KERNEL);
+		if (!raw)
+			return -ENOMEM;
+
+		ret = ir_raw_encode_scancode(scan.rc_type, scan.scancode,
+					     raw, LIRCBUF_SIZE);
+		if (ret < 0)
+			goto out;
+
+		count = ret;
 
-	txbuf = memdup_user(buf, n);
-	if (IS_ERR(txbuf))
-		return PTR_ERR(txbuf);
+		txbuf = kmalloc_array(count, sizeof(unsigned int), GFP_KERNEL);
+		if (!txbuf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		for (i = 0; i < count; i++)
+			txbuf[i] = DIV_ROUND_UP(raw[i].duration, 1000);
+	} else {
+		if (n < sizeof(unsigned int) || n % sizeof(unsigned int))
+			return -EINVAL;
+
+		count = n / sizeof(unsigned int);
+		if (count > LIRCBUF_SIZE || count % 2 == 0)
+			return -EINVAL;
+
+		txbuf = memdup_user(buf, n);
+		if (IS_ERR(txbuf))
+			return PTR_ERR(txbuf);
+	}
 
 	dev = lirc->dev;
 	if (!dev) {
@@ -142,7 +176,10 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	for (duration = i = 0; i < ret; i++)
 		duration += txbuf[i];
 
-	ret *= sizeof(unsigned int);
+	if (lirc->send_mode == LIRC_MODE_SCANCODE)
+		ret = n;
+	else
+		ret *= sizeof(unsigned int);
 
 	/*
 	 * The lircd gap calculation expects the write function to
@@ -157,6 +194,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 
 out:
 	kfree(txbuf);
+	kfree(raw);
 	return ret;
 }
 
@@ -190,15 +228,17 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (!dev->tx_ir)
 			return -ENOTTY;
 
-		val = LIRC_MODE_PULSE;
+		val = lirc->send_mode;
 		break;
 
 	case LIRC_SET_SEND_MODE:
 		if (!dev->tx_ir)
 			return -ENOTTY;
 
-		if (val != LIRC_MODE_PULSE)
+		if (!(val == LIRC_MODE_PULSE || val == LIRC_MODE_SCANCODE))
 			return -EINVAL;
+
+		lirc->send_mode = val;
 		return 0;
 
 	/* TX settings */
@@ -407,7 +447,7 @@ int ir_lirc_register(struct rc_dev *dev)
 			features |= LIRC_CAN_GET_REC_RESOLUTION;
 	}
 	if (dev->tx_ir) {
-		features |= LIRC_CAN_SEND_PULSE;
+		features |= LIRC_CAN_SEND_PULSE | LIRC_CAN_SEND_SCANCODE;
 		if (dev->s_tx_mask)
 			features |= LIRC_CAN_SET_TRANSMITTER_MASK;
 		if (dev->s_tx_carrier)
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 9b561c3..6944d54 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -49,6 +49,7 @@ struct lirc_node {
 	u64 gap_duration;
 	bool gap;
 	bool send_timeout_reports;
+	int send_mode;
 };
 
 struct ir_raw_event_ctrl {
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 1a815a5..1880f47 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -10,59 +10,7 @@
  */
 
 #include <linux/input.h>
-
-/**
- * enum rc_type - type of the Remote Controller protocol
- *
- * @RC_TYPE_UNKNOWN: Protocol not known
- * @RC_TYPE_OTHER: Protocol known but proprietary
- * @RC_TYPE_RC5: Philips RC5 protocol
- * @RC_TYPE_RC5X_20: Philips RC5x 20 bit protocol
- * @RC_TYPE_RC5_SZ: StreamZap variant of RC5
- * @RC_TYPE_JVC: JVC protocol
- * @RC_TYPE_SONY12: Sony 12 bit protocol
- * @RC_TYPE_SONY15: Sony 15 bit protocol
- * @RC_TYPE_SONY20: Sony 20 bit protocol
- * @RC_TYPE_NEC: NEC protocol
- * @RC_TYPE_NECX: Extended NEC protocol
- * @RC_TYPE_NEC32: NEC 32 bit protocol
- * @RC_TYPE_SANYO: Sanyo protocol
- * @RC_TYPE_MCIR2_KBD: RC6-ish MCE keyboard
- * @RC_TYPE_MCIR2_MSE: RC6-ish MCE mouse
- * @RC_TYPE_RC6_0: Philips RC6-0-16 protocol
- * @RC_TYPE_RC6_6A_20: Philips RC6-6A-20 protocol
- * @RC_TYPE_RC6_6A_24: Philips RC6-6A-24 protocol
- * @RC_TYPE_RC6_6A_32: Philips RC6-6A-32 protocol
- * @RC_TYPE_RC6_MCE: MCE (Philips RC6-6A-32 subtype) protocol
- * @RC_TYPE_SHARP: Sharp protocol
- * @RC_TYPE_XMP: XMP protocol
- * @RC_TYPE_CEC: CEC protocol
- */
-enum rc_type {
-	RC_TYPE_UNKNOWN		= 0,
-	RC_TYPE_OTHER		= 1,
-	RC_TYPE_RC5		= 2,
-	RC_TYPE_RC5X_20		= 3,
-	RC_TYPE_RC5_SZ		= 4,
-	RC_TYPE_JVC		= 5,
-	RC_TYPE_SONY12		= 6,
-	RC_TYPE_SONY15		= 7,
-	RC_TYPE_SONY20		= 8,
-	RC_TYPE_NEC		= 9,
-	RC_TYPE_NECX		= 10,
-	RC_TYPE_NEC32		= 11,
-	RC_TYPE_SANYO		= 12,
-	RC_TYPE_MCIR2_KBD	= 13,
-	RC_TYPE_MCIR2_MSE	= 14,
-	RC_TYPE_RC6_0		= 15,
-	RC_TYPE_RC6_6A_20	= 16,
-	RC_TYPE_RC6_6A_24	= 17,
-	RC_TYPE_RC6_6A_32	= 18,
-	RC_TYPE_RC6_MCE		= 19,
-	RC_TYPE_SHARP		= 20,
-	RC_TYPE_XMP		= 21,
-	RC_TYPE_CEC		= 22,
-};
+#include <linux/lirc.h>
 
 #define RC_BIT_NONE		0ULL
 #define RC_BIT_UNKNOWN		BIT_ULL(RC_TYPE_UNKNOWN)
diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
index 991ab45..d04fc62 100644
--- a/include/uapi/linux/lirc.h
+++ b/include/uapi/linux/lirc.h
@@ -46,12 +46,14 @@
 #define LIRC_MODE_RAW                  0x00000001
 #define LIRC_MODE_PULSE                0x00000002
 #define LIRC_MODE_MODE2                0x00000004
+#define LIRC_MODE_SCANCODE             0x00000008
 #define LIRC_MODE_LIRCCODE             0x00000010
 
 
 #define LIRC_CAN_SEND_RAW              LIRC_MODE2SEND(LIRC_MODE_RAW)
 #define LIRC_CAN_SEND_PULSE            LIRC_MODE2SEND(LIRC_MODE_PULSE)
 #define LIRC_CAN_SEND_MODE2            LIRC_MODE2SEND(LIRC_MODE_MODE2)
+#define LIRC_CAN_SEND_SCANCODE         LIRC_MODE2SEND(LIRC_MODE_SCANCODE)
 #define LIRC_CAN_SEND_LIRCCODE         LIRC_MODE2SEND(LIRC_MODE_LIRCCODE)
 
 #define LIRC_CAN_SEND_MASK             0x0000003f
@@ -63,6 +65,7 @@
 #define LIRC_CAN_REC_RAW               LIRC_MODE2REC(LIRC_MODE_RAW)
 #define LIRC_CAN_REC_PULSE             LIRC_MODE2REC(LIRC_MODE_PULSE)
 #define LIRC_CAN_REC_MODE2             LIRC_MODE2REC(LIRC_MODE_MODE2)
+#define LIRC_CAN_REC_SCANCODE          LIRC_MODE2REC(LIRC_MODE_SCANCODE)
 #define LIRC_CAN_REC_LIRCCODE          LIRC_MODE2REC(LIRC_MODE_LIRCCODE)
 
 #define LIRC_CAN_REC_MASK              LIRC_MODE2REC(LIRC_CAN_SEND_MASK)
@@ -130,4 +133,77 @@
 
 #define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
 
+/*
+ * struct lirc_scancode - decoded scancodes with protocol
+ * @timestamp: Timestamp in nanoseconds using CLOCK_MONOTONIC when IR
+ *	was decoded.
+ * @flags: should be 0 for transmit. When receiving scancodes,
+ *	LIRC_SCANCODE_FLAG_TOGGLE or LIRC_SCANCODE_FLAG_REPEAT can be set
+ *	depending on the protocol
+ * @rc_type: see enum rc_type
+ * @scancode: the scancode received or to be sent
+ */
+struct lirc_scancode {
+	__u64	timestamp;
+	__u32	flags;
+	__u32	rc_type;
+	__u64	scancode;
+};
+
+#define LIRC_SCANCODE_FLAG_TOGGLE	1
+#define LIRC_SCANCODE_FLAG_REPEAT	2
+
+/**
+ * enum rc_type - type of the Remote Controller protocol
+ *
+ * @RC_TYPE_UNKNOWN: Protocol not known
+ * @RC_TYPE_OTHER: Protocol known but proprietary
+ * @RC_TYPE_RC5: Philips RC5 protocol
+ * @RC_TYPE_RC5X_20: Philips RC5x 20 bit protocol
+ * @RC_TYPE_RC5_SZ: StreamZap variant of RC5
+ * @RC_TYPE_JVC: JVC protocol
+ * @RC_TYPE_SONY12: Sony 12 bit protocol
+ * @RC_TYPE_SONY15: Sony 15 bit protocol
+ * @RC_TYPE_SONY20: Sony 20 bit protocol
+ * @RC_TYPE_NEC: NEC protocol
+ * @RC_TYPE_NECX: Extended NEC protocol
+ * @RC_TYPE_NEC32: NEC 32 bit protocol
+ * @RC_TYPE_SANYO: Sanyo protocol
+ * @RC_TYPE_MCIR2_KBD: RC6-ish MCE keyboard
+ * @RC_TYPE_MCIR2_MSE: RC6-ish MCE mouse
+ * @RC_TYPE_RC6_0: Philips RC6-0-16 protocol
+ * @RC_TYPE_RC6_6A_20: Philips RC6-6A-20 protocol
+ * @RC_TYPE_RC6_6A_24: Philips RC6-6A-24 protocol
+ * @RC_TYPE_RC6_6A_32: Philips RC6-6A-32 protocol
+ * @RC_TYPE_RC6_MCE: MCE (Philips RC6-6A-32 subtype) protocol
+ * @RC_TYPE_SHARP: Sharp protocol
+ * @RC_TYPE_XMP: XMP protocol
+ * @RC_TYPE_CEC: CEC protocol
+ */
+enum rc_type {
+	RC_TYPE_UNKNOWN		= 0,
+	RC_TYPE_OTHER		= 1,
+	RC_TYPE_RC5		= 2,
+	RC_TYPE_RC5X_20		= 3,
+	RC_TYPE_RC5_SZ		= 4,
+	RC_TYPE_JVC		= 5,
+	RC_TYPE_SONY12		= 6,
+	RC_TYPE_SONY15		= 7,
+	RC_TYPE_SONY20		= 8,
+	RC_TYPE_NEC		= 9,
+	RC_TYPE_NECX		= 10,
+	RC_TYPE_NEC32		= 11,
+	RC_TYPE_SANYO		= 12,
+	RC_TYPE_MCIR2_KBD	= 13,
+	RC_TYPE_MCIR2_MSE	= 14,
+	RC_TYPE_RC6_0		= 15,
+	RC_TYPE_RC6_6A_20	= 16,
+	RC_TYPE_RC6_6A_24	= 17,
+	RC_TYPE_RC6_6A_32	= 18,
+	RC_TYPE_RC6_MCE		= 19,
+	RC_TYPE_SHARP		= 20,
+	RC_TYPE_XMP		= 21,
+	RC_TYPE_CEC		= 22,
+};
+
 #endif
-- 
2.9.3
