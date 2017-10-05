Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60679 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751380AbdJEIpb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 04:45:31 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 10/25] media: lirc: validate scancode for transmit
Date: Thu,  5 Oct 2017 09:45:12 +0100
Message-Id: <46af0b140d94a0e4f192120e4e9c68e5bc18ff23.1507192752.git.sean@mess.org>
In-Reply-To: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
References: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
In-Reply-To: <cover.1507192751.git.sean@mess.org>
References: <cover.1507192751.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure we reject an attempt to transmit invalid scancodes.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c |  3 +++
 drivers/media/rc/rc-core-priv.h  |  1 +
 drivers/media/rc/rc-main.c       | 53 +++++++++++++++++++++++++---------------
 3 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 94561d8b0c0b..863d975d40fb 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -122,6 +122,9 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		    scan.timestamp)
 			return -EINVAL;
 
+		if (!rc_validate_scancode(scan.rc_proto, scan.scancode))
+			return -EINVAL;
+
 		if (dev->tx_scancode) {
 			ret = dev->tx_scancode(dev, &scan);
 			return ret < 0 ? ret : n;
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 21e515d34f64..a064c401fa38 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -160,6 +160,7 @@ static inline bool is_timing_event(struct ir_raw_event ev)
 #define TO_STR(is_pulse)		((is_pulse) ? "pulse" : "space")
 
 /* functions for IR encoders */
+bool rc_validate_scancode(enum rc_proto proto, u32 scancode);
 
 static inline void init_ir_raw_event_duration(struct ir_raw_event *ev,
 					      unsigned int pulse,
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 758c14b90a87..38393f13822f 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -776,6 +776,37 @@ void rc_keydown_notimeout(struct rc_dev *dev, enum rc_proto protocol,
 EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
 
 /**
+ * rc_validate_scancode() - checks that a scancode is valid for a protocol
+ * @proto:	protocol
+ * @scancode:	scancode
+ */
+bool rc_validate_scancode(enum rc_proto proto, u32 scancode)
+{
+	switch (proto) {
+	case RC_PROTO_NECX:
+		if ((((scancode >> 16) ^ ~(scancode >> 8)) & 0xff) == 0)
+			return false;
+		break;
+	case RC_PROTO_NEC32:
+		if ((((scancode >> 24) ^ ~(scancode >> 16)) & 0xff) == 0)
+			return false;
+		break;
+	case RC_PROTO_RC6_MCE:
+		if ((scancode & 0xffff0000) != 0x800f0000)
+			return false;
+		break;
+	case RC_PROTO_RC6_6A_32:
+		if ((scancode & 0xffff0000) == 0x800f0000)
+			return false;
+		break;
+	default:
+		break;
+	}
+
+	return true;
+}
+
+/**
  * rc_validate_filter() - checks that the scancode and mask are valid and
  *			  provides sensible defaults
  * @dev:	the struct rc_dev descriptor of the device
@@ -793,26 +824,8 @@ static int rc_validate_filter(struct rc_dev *dev,
 
 	mask = protocols[protocol].scancode_bits;
 
-	switch (protocol) {
-	case RC_PROTO_NECX:
-		if ((((s >> 16) ^ ~(s >> 8)) & 0xff) == 0)
-			return -EINVAL;
-		break;
-	case RC_PROTO_NEC32:
-		if ((((s >> 24) ^ ~(s >> 16)) & 0xff) == 0)
-			return -EINVAL;
-		break;
-	case RC_PROTO_RC6_MCE:
-		if ((s & 0xffff0000) != 0x800f0000)
-			return -EINVAL;
-		break;
-	case RC_PROTO_RC6_6A_32:
-		if ((s & 0xffff0000) == 0x800f0000)
-			return -EINVAL;
-		break;
-	default:
-		break;
-	}
+	if (!rc_validate_scancode(protocol, s))
+		return -EINVAL;
 
 	filter->data &= mask;
 	filter->mask &= mask;
-- 
2.13.6
