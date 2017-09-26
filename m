Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:52107 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S970471AbdIZUYM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:24:12 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 01/20] media: lirc: implement scancode sending
Date: Tue, 26 Sep 2017 21:13:40 +0100
Message-Id: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
In-Reply-To: <cover.1506455086.git.sean@mess.org>
References: <cover.1506455086.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This introduces a new lirc mode: scancode. Any device which can send raw IR
can now also send scancodes.

int main()
{
	int mode, fd = open("/dev/lirc0", O_RDWR);

        mode = LIRC_MODE_SCANCODE;
	if (ioctl(fd, LIRC_SET_SEND_MODE, &mode)) {
		// kernel too old or lirc does not support transmit
	}
	struct lirc_scancode scancode = {
		.scancode = 0x1e3d,
		.rc_proto = RC_TYPE_RC5,
	};
	write(fd, &scancode, sizeof(scancode));
	close(fd);
}

The other fields of lirc_scancode must be set to 0.

Note that toggle (rc5, rc6) and repeats (nec) are not implemented. Nor is
there a method for holding down a key for a period.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 72 +++++++++++++++++++++++++------
 drivers/media/rc/rc-core-priv.h  |  2 +-
 include/media/rc-map.h           | 54 +----------------------
 include/uapi/linux/lirc.h        | 93 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 153 insertions(+), 68 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index bd046c41a53a..770d768824f4 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -107,7 +107,8 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 {
 	struct lirc_codec *lirc;
 	struct rc_dev *dev;
-	unsigned int *txbuf; /* buffer with values to transmit */
+	unsigned int *txbuf = NULL;
+	struct ir_raw_event *raw = NULL;
 	ssize_t ret = -EINVAL;
 	size_t count;
 	ktime_t start;
@@ -121,16 +122,51 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
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
+		if (scan.flags || scan.source || scan.target || scan.unused ||
+		    scan.timestamp)
+			return -EINVAL;
 
-	txbuf = memdup_user(buf, n);
-	if (IS_ERR(txbuf))
-		return PTR_ERR(txbuf);
+		raw = kmalloc_array(LIRCBUF_SIZE, sizeof(*raw), GFP_KERNEL);
+		if (!raw)
+			return -ENOMEM;
+
+		ret = ir_raw_encode_scancode(scan.rc_proto, scan.scancode,
+					     raw, LIRCBUF_SIZE);
+		if (ret < 0)
+			goto out;
+
+		count = ret;
+
+		txbuf = kmalloc_array(count, sizeof(unsigned int), GFP_KERNEL);
+		if (!txbuf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		for (i = 0; i < count; i++)
+			/* Convert from NS to US */
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
@@ -159,7 +195,10 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	for (duration = i = 0; i < ret; i++)
 		duration += txbuf[i];
 
-	ret *= sizeof(unsigned int);
+	if (lirc->send_mode == LIRC_MODE_SCANCODE)
+		ret = n;
+	else
+		ret *= sizeof(unsigned int);
 
 	/*
 	 * The lircd gap calculation expects the write function to
@@ -174,6 +213,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 
 out:
 	kfree(txbuf);
+	kfree(raw);
 	return ret;
 }
 
@@ -202,20 +242,22 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 
 	switch (cmd) {
 
-	/* legacy support */
+	/* mode support */
 	case LIRC_GET_SEND_MODE:
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
@@ -358,7 +400,7 @@ static int ir_lirc_register(struct rc_dev *dev)
 	}
 
 	if (dev->tx_ir) {
-		features |= LIRC_CAN_SEND_PULSE;
+		features |= LIRC_CAN_SEND_PULSE | LIRC_CAN_SEND_SCANCODE;
 		if (dev->s_tx_mask)
 			features |= LIRC_CAN_SET_TRANSMITTER_MASK;
 		if (dev->s_tx_carrier)
@@ -397,6 +439,8 @@ static int ir_lirc_register(struct rc_dev *dev)
 	if (rc < 0)
 		goto out;
 
+	dev->raw->lirc.send_mode = LIRC_MODE_PULSE;
+
 	dev->raw->lirc.ldev = ldev;
 	dev->raw->lirc.dev = dev;
 	return 0;
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index ae4dd0c27731..43eabea9f152 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -113,7 +113,7 @@ struct ir_raw_event_ctrl {
 		u64 gap_duration;
 		bool gap;
 		bool send_timeout_reports;
-
+		u8 send_mode;
 	} lirc;
 	struct xmp_dec {
 		int state;
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 2a160e6e823c..00e033975eed 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -10,59 +10,7 @@
  */
 
 #include <linux/input.h>
-
-/**
- * enum rc_proto - the Remote Controller protocol
- *
- * @RC_PROTO_UNKNOWN: Protocol not known
- * @RC_PROTO_OTHER: Protocol known but proprietary
- * @RC_PROTO_RC5: Philips RC5 protocol
- * @RC_PROTO_RC5X_20: Philips RC5x 20 bit protocol
- * @RC_PROTO_RC5_SZ: StreamZap variant of RC5
- * @RC_PROTO_JVC: JVC protocol
- * @RC_PROTO_SONY12: Sony 12 bit protocol
- * @RC_PROTO_SONY15: Sony 15 bit protocol
- * @RC_PROTO_SONY20: Sony 20 bit protocol
- * @RC_PROTO_NEC: NEC protocol
- * @RC_PROTO_NECX: Extended NEC protocol
- * @RC_PROTO_NEC32: NEC 32 bit protocol
- * @RC_PROTO_SANYO: Sanyo protocol
- * @RC_PROTO_MCIR2_KBD: RC6-ish MCE keyboard
- * @RC_PROTO_MCIR2_MSE: RC6-ish MCE mouse
- * @RC_PROTO_RC6_0: Philips RC6-0-16 protocol
- * @RC_PROTO_RC6_6A_20: Philips RC6-6A-20 protocol
- * @RC_PROTO_RC6_6A_24: Philips RC6-6A-24 protocol
- * @RC_PROTO_RC6_6A_32: Philips RC6-6A-32 protocol
- * @RC_PROTO_RC6_MCE: MCE (Philips RC6-6A-32 subtype) protocol
- * @RC_PROTO_SHARP: Sharp protocol
- * @RC_PROTO_XMP: XMP protocol
- * @RC_PROTO_CEC: CEC protocol
- */
-enum rc_proto {
-	RC_PROTO_UNKNOWN	= 0,
-	RC_PROTO_OTHER		= 1,
-	RC_PROTO_RC5		= 2,
-	RC_PROTO_RC5X_20	= 3,
-	RC_PROTO_RC5_SZ		= 4,
-	RC_PROTO_JVC		= 5,
-	RC_PROTO_SONY12		= 6,
-	RC_PROTO_SONY15		= 7,
-	RC_PROTO_SONY20		= 8,
-	RC_PROTO_NEC		= 9,
-	RC_PROTO_NECX		= 10,
-	RC_PROTO_NEC32		= 11,
-	RC_PROTO_SANYO		= 12,
-	RC_PROTO_MCIR2_KBD	= 13,
-	RC_PROTO_MCIR2_MSE	= 14,
-	RC_PROTO_RC6_0		= 15,
-	RC_PROTO_RC6_6A_20	= 16,
-	RC_PROTO_RC6_6A_24	= 17,
-	RC_PROTO_RC6_6A_32	= 18,
-	RC_PROTO_RC6_MCE	= 19,
-	RC_PROTO_SHARP		= 20,
-	RC_PROTO_XMP		= 21,
-	RC_PROTO_CEC		= 22,
-};
+#include <uapi/linux/lirc.h>
 
 #define RC_PROTO_BIT_NONE		0ULL
 #define RC_PROTO_BIT_UNKNOWN		BIT_ULL(RC_PROTO_UNKNOWN)
diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
index 991ab4570b8e..312e37812783 100644
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
@@ -130,4 +133,94 @@
 
 #define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
 
+/*
+ * For raw IR devices, both raw IR (LIRC_MODE_MODE2) and decodes scancodes
+ * (LIRC_MODE_SCANCODE) can be read. By default, poll will show read
+ * ready for the last mode set by LIRC_SET_REC_MODE. Use LIRC_SET_POLL_MODE
+ * LIRC_MODE_SCANCODE | LIRC_MODE_MODE2 to show read ready for both
+ * modes.
+ */
+#define LIRC_SET_POLL_MODE	       _IOW('i', 0x00000024, __u32)
+
+/*
+ * struct lirc_scancode - decoded scancode with protocol for use with
+ *	LIRC_MODE_SCANCODE
+ *
+ * @timestamp: Timestamp in nanoseconds using CLOCK_MONOTONIC when IR
+ *	was decoded.
+ * @flags: should be 0 for transmit. When receiving scancodes,
+ *	LIRC_SCANCODE_FLAG_TOGGLE or LIRC_SCANCODE_FLAG_REPEAT can be set
+ *	depending on the protocol
+ * @target: target for transmit. Unused, set to 0.
+ * @source: source for receive. Unused, set to 0.
+ * @unused: set to 0.
+ * @rc_proto: see enum rc_proto
+ * @scancode: the scancode received or to be sent
+ */
+struct lirc_scancode {
+	__u64	timestamp;
+	__u32	flags;
+	__u8	target;
+	__u8	source;
+	__u8	unused;
+	__u8	rc_proto;
+	__u64	scancode;
+};
+
+#define LIRC_SCANCODE_FLAG_TOGGLE	1
+#define LIRC_SCANCODE_FLAG_REPEAT	2
+
+/**
+ * enum rc_proto - the Remote Controller protocol
+ *
+ * @RC_PROTO_UNKNOWN: Protocol not known
+ * @RC_PROTO_OTHER: Protocol known but proprietary
+ * @RC_PROTO_RC5: Philips RC5 protocol
+ * @RC_PROTO_RC5X_20: Philips RC5x 20 bit protocol
+ * @RC_PROTO_RC5_SZ: StreamZap variant of RC5
+ * @RC_PROTO_JVC: JVC protocol
+ * @RC_PROTO_SONY12: Sony 12 bit protocol
+ * @RC_PROTO_SONY15: Sony 15 bit protocol
+ * @RC_PROTO_SONY20: Sony 20 bit protocol
+ * @RC_PROTO_NEC: NEC protocol
+ * @RC_PROTO_NECX: Extended NEC protocol
+ * @RC_PROTO_NEC32: NEC 32 bit protocol
+ * @RC_PROTO_SANYO: Sanyo protocol
+ * @RC_PROTO_MCIR2_KBD: RC6-ish MCE keyboard
+ * @RC_PROTO_MCIR2_MSE: RC6-ish MCE mouse
+ * @RC_PROTO_RC6_0: Philips RC6-0-16 protocol
+ * @RC_PROTO_RC6_6A_20: Philips RC6-6A-20 protocol
+ * @RC_PROTO_RC6_6A_24: Philips RC6-6A-24 protocol
+ * @RC_PROTO_RC6_6A_32: Philips RC6-6A-32 protocol
+ * @RC_PROTO_RC6_MCE: MCE (Philips RC6-6A-32 subtype) protocol
+ * @RC_PROTO_SHARP: Sharp protocol
+ * @RC_PROTO_XMP: XMP protocol
+ * @RC_PROTO_CEC: CEC protocol
+ */
+enum rc_proto {
+	RC_PROTO_UNKNOWN	= 0,
+	RC_PROTO_OTHER		= 1,
+	RC_PROTO_RC5		= 2,
+	RC_PROTO_RC5X_20	= 3,
+	RC_PROTO_RC5_SZ		= 4,
+	RC_PROTO_JVC		= 5,
+	RC_PROTO_SONY12		= 6,
+	RC_PROTO_SONY15		= 7,
+	RC_PROTO_SONY20		= 8,
+	RC_PROTO_NEC		= 9,
+	RC_PROTO_NECX		= 10,
+	RC_PROTO_NEC32		= 11,
+	RC_PROTO_SANYO		= 12,
+	RC_PROTO_MCIR2_KBD	= 13,
+	RC_PROTO_MCIR2_MSE	= 14,
+	RC_PROTO_RC6_0		= 15,
+	RC_PROTO_RC6_6A_20	= 16,
+	RC_PROTO_RC6_6A_24	= 17,
+	RC_PROTO_RC6_6A_32	= 18,
+	RC_PROTO_RC6_MCE	= 19,
+	RC_PROTO_SHARP		= 20,
+	RC_PROTO_XMP		= 21,
+	RC_PROTO_CEC		= 22,
+};
+
 #endif
-- 
2.13.5
