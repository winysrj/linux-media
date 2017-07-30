Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750991AbdG3NYm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 09:24:42 -0400
From: Shawn Guo <shawnguo@kernel.org>
To: Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>
Cc: Baoyou Xie <xie.baoyou@sanechips.com.cn>,
        Xin Zhou <zhou.xin8@sanechips.com.cn>,
        Jun Nie <jun.nie@linaro.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v2 1/3] rc: ir-nec-decoder: move scancode composing code into a shared function
Date: Sun, 30 Jul 2017 21:23:11 +0800
Message-Id: <1501420993-21977-2-git-send-email-shawnguo@kernel.org>
In-Reply-To: <1501420993-21977-1-git-send-email-shawnguo@kernel.org>
References: <1501420993-21977-1-git-send-email-shawnguo@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shawn Guo <shawn.guo@linaro.org>

The NEC scancode composing and protocol type detection in
ir_nec_decode() is generic enough to be a shared function.  Let's create
an inline function in rc-core.h, so that other remote control drivers
can reuse this function to save some code.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/media/rc/ir-nec-decoder.c | 32 +++-----------------------------
 include/media/rc-core.h           | 31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 3ce850314dca..b578c1e27c04 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -51,7 +51,6 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	enum rc_type rc_type;
 	u8 address, not_address, command, not_command;
-	bool send_32bits = false;
 
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
@@ -161,34 +160,9 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		command	    = bitrev8((data->bits >>  8) & 0xff);
 		not_command = bitrev8((data->bits >>  0) & 0xff);
 
-		if ((command ^ not_command) != 0xff) {
-			IR_dprintk(1, "NEC checksum error: received 0x%08x\n",
-				   data->bits);
-			send_32bits = true;
-		}
-
-		if (send_32bits) {
-			/* NEC transport, but modified protocol, used by at
-			 * least Apple and TiVo remotes */
-			scancode = not_address << 24 |
-				address     << 16 |
-				not_command <<  8 |
-				command;
-			IR_dprintk(1, "NEC (modified) scancode 0x%08x\n", scancode);
-			rc_type = RC_TYPE_NEC32;
-		} else if ((address ^ not_address) != 0xff) {
-			/* Extended NEC */
-			scancode = address     << 16 |
-				   not_address <<  8 |
-				   command;
-			IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
-			rc_type = RC_TYPE_NECX;
-		} else {
-			/* Normal NEC */
-			scancode = address << 8 | command;
-			IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
-			rc_type = RC_TYPE_NEC;
-		}
+		scancode = ir_nec_bytes_to_scancode(address, not_address,
+						    command, not_command,
+						    &rc_type);
 
 		if (data->is_nec_x)
 			data->necx_repeat = true;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 78dea39a9b39..204f7785b8e7 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -340,4 +340,35 @@ static inline u32 ir_extract_bits(u32 data, u32 mask)
 	return value;
 }
 
+/* Get NEC scancode and protocol type from address and command bytes */
+static inline u32 ir_nec_bytes_to_scancode(u8 address, u8 not_address,
+					   u8 command, u8 not_command,
+					   enum rc_type *protocol)
+{
+	u32 scancode;
+
+	if ((command ^ not_command) != 0xff) {
+		/* NEC transport, but modified protocol, used by at
+		 * least Apple and TiVo remotes
+		 */
+		scancode = not_address << 24 |
+			address     << 16 |
+			not_command <<  8 |
+			command;
+		*protocol = RC_TYPE_NEC32;
+	} else if ((address ^ not_address) != 0xff) {
+		/* Extended NEC */
+		scancode = address     << 16 |
+			   not_address <<  8 |
+			   command;
+		*protocol = RC_TYPE_NECX;
+	} else {
+		/* Normal NEC */
+		scancode = address << 8 | command;
+		*protocol = RC_TYPE_NEC;
+	}
+
+	return scancode;
+}
+
 #endif /* _RC_CORE */
-- 
1.9.1
