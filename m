Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:35869 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751998AbcLBRRL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 12:17:11 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH 8/8] [media] rc5x: document that this is the 20 bit variant
Date: Fri,  2 Dec 2016 17:16:14 +0000
Message-Id: <1480698974-9093-8-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are many variants of extended rc5. This implements the 20 bit
version.

Signed-off-by: Sean Young <sean@mess.org>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-rc5-decoder.c | 6 +++---
 drivers/media/rc/rc-main.c        | 2 +-
 include/media/rc-map.h            | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index a95477c..484185e 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -124,7 +124,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (data->is_rc5x && data->count == RC5X_NBITS) {
 			/* RC5X */
 			u8 xdata, command, system;
-			if (!(dev->enabled_protocols & RC_BIT_RC5X)) {
+			if (!(dev->enabled_protocols & RC_BIT_RC5X_20)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
@@ -134,7 +134,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			toggle   = (data->bits & 0x20000) ? 1 : 0;
 			command += (data->bits & 0x40000) ? 0 : 0x40;
 			scancode = system << 16 | command << 8 | xdata;
-			protocol = RC_TYPE_RC5X;
+			protocol = RC_TYPE_RC5X_20;
 
 		} else if (!data->is_rc5x && data->count == RC5_NBITS) {
 			/* RC5 */
@@ -182,7 +182,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 }
 
 static struct ir_raw_handler rc5_handler = {
-	.protocols	= RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ,
+	.protocols	= RC_BIT_RC5 | RC_BIT_RC5X_20 | RC_BIT_RC5_SZ,
 	.decode		= ir_rc5_decode,
 };
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index dedaf38..75bdc49 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -796,7 +796,7 @@ static const struct {
 	{ RC_BIT_OTHER,		"other",	NULL			},
 	{ RC_BIT_UNKNOWN,	"unknown",	NULL			},
 	{ RC_BIT_RC5 |
-	  RC_BIT_RC5X,		"rc-5",		"ir-rc5-decoder"	},
+	  RC_BIT_RC5X_20,	"rc-5",		"ir-rc5-decoder"	},
 	{ RC_BIT_NEC |
 	  RC_BIT_NECX |
 	  RC_BIT_NEC32,		"nec",		"ir-nec-decoder"	},
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index e1cc14c..39c00ef 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -17,7 +17,7 @@
  * @RC_TYPE_UNKNOWN: Protocol not known
  * @RC_TYPE_OTHER: Protocol known but proprietary
  * @RC_TYPE_RC5: Philips RC5 protocol
- * @RC_TYPE_RC5X: Philips RC5x protocol
+ * @RC_TYPE_RC5X_20: Philips RC5x 20 bit protocol
  * @RC_TYPE_RC5_SZ: StreamZap variant of RC5
  * @RC_TYPE_JVC: JVC protocol
  * @RC_TYPE_SONY12: Sony 12 bit protocol
@@ -41,7 +41,7 @@ enum rc_type {
 	RC_TYPE_UNKNOWN		= 0,
 	RC_TYPE_OTHER		= 1,
 	RC_TYPE_RC5		= 2,
-	RC_TYPE_RC5X		= 3,
+	RC_TYPE_RC5X_20		= 3,
 	RC_TYPE_RC5_SZ		= 4,
 	RC_TYPE_JVC		= 5,
 	RC_TYPE_SONY12		= 6,
@@ -66,7 +66,7 @@ enum rc_type {
 #define RC_BIT_UNKNOWN		(1ULL << RC_TYPE_UNKNOWN)
 #define RC_BIT_OTHER		(1ULL << RC_TYPE_OTHER)
 #define RC_BIT_RC5		(1ULL << RC_TYPE_RC5)
-#define RC_BIT_RC5X		(1ULL << RC_TYPE_RC5X)
+#define RC_BIT_RC5X_20		(1ULL << RC_TYPE_RC5X_20)
 #define RC_BIT_RC5_SZ		(1ULL << RC_TYPE_RC5_SZ)
 #define RC_BIT_JVC		(1ULL << RC_TYPE_JVC)
 #define RC_BIT_SONY12		(1ULL << RC_TYPE_SONY12)
@@ -87,7 +87,7 @@ enum rc_type {
 #define RC_BIT_CEC		(1ULL << RC_TYPE_CEC)
 
 #define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | \
-			 RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
+			 RC_BIT_RC5 | RC_BIT_RC5X_20 | RC_BIT_RC5_SZ | \
 			 RC_BIT_JVC | \
 			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
 			 RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 | \
-- 
2.9.3

