Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab0D1Rhb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 13:37:31 -0400
Date: Wed, 28 Apr 2010 13:37:29 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org
Subject: [PATCH] IR/imon: minor change_protocol fixups
Message-ID: <20100428173729.GA14256@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a follow-up to my prior patch implementing ir-core's
change_protocol functionality in the imon driver, which eliminates
a false warning when change_protocol is called without a specific
protocol selected yet (i.e., still IR_TYPE_UNKNOWN). It also removes
some extraneous blank lines getting spewn into dmesg.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 drivers/media/IR/imon.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index 16e2e7f..6fb3b05 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -999,7 +999,7 @@ int imon_ir_change_protocol(void *priv, u64 ir_type)
 	unsigned char ir_proto_packet[] = {
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86 };
 
-	if (!(ir_type & ictx->props->allowed_protos))
+	if (ir_type && !(ir_type & ictx->props->allowed_protos))
 		dev_warn(dev, "Looks like you're trying to use an IR protocol "
 			 "this device does not support\n");
 
@@ -1014,12 +1014,11 @@ int imon_ir_change_protocol(void *priv, u64 ir_type)
 		break;
 	case IR_TYPE_UNKNOWN:
 	case IR_TYPE_OTHER:
-		dev_dbg(dev, "Configuring IR receiver for iMON protocol");
-		if (pad_stabilize) {
-			printk(KERN_CONT "\n");
+		dev_dbg(dev, "Configuring IR receiver for iMON protocol\n");
+		if (pad_stabilize)
 			pad_mouse = true;
-		} else {
-			printk(KERN_CONT " (without PAD stabilization)\n");
+		else {
+			dev_dbg(dev, "PAD stabilize functionality disabled\n");
 			pad_mouse = false;
 		}
 		/* ir_proto_packet[0] = 0x00; // already the default */
@@ -1027,12 +1026,11 @@ int imon_ir_change_protocol(void *priv, u64 ir_type)
 		break;
 	default:
 		dev_warn(dev, "Unsupported IR protocol specified, overriding "
-			 "to iMON IR protocol");
-		if (pad_stabilize) {
-			printk(KERN_CONT "\n");
+			 "to iMON IR protocol\n");
+		if (pad_stabilize)
 			pad_mouse = true;
-		} else {
-			printk(KERN_CONT " (without PAD stabilization)\n");
+		else {
+			dev_dbg(dev, "PAD stabilize functionality disabled\n");
 			pad_mouse = false;
 		}
 		/* ir_proto_packet[0] = 0x00; // already the default */

-- 
Jarod Wilson
jarod@redhat.com

