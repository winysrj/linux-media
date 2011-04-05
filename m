Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:49724 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1DEKJQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 06:09:16 -0400
Subject: [PATCH] rc-core: int to bool conversion for winbond-cir
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, skandalfo@gmail.com
Date: Tue, 05 Apr 2011 12:08:27 +0200
Message-ID: <20110405100827.5202.52169.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Using bool instead of an int helps readability a bit.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/winbond-cir.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index b0a5fdc..cdb5ef4 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -382,7 +382,7 @@ wbcir_shutdown(struct pnp_dev *device)
 {
 	struct device *dev = &device->dev;
 	struct wbcir_data *data = pnp_get_drvdata(device);
-	int do_wake = 1;
+	bool do_wake = true;
 	u8 match[11];
 	u8 mask[11];
 	u8 rc6_csl = 0;
@@ -392,14 +392,14 @@ wbcir_shutdown(struct pnp_dev *device)
 	memset(mask, 0, sizeof(mask));
 
 	if (wake_sc == INVALID_SCANCODE || !device_may_wakeup(dev)) {
-		do_wake = 0;
+		do_wake = false;
 		goto finish;
 	}
 
 	switch (protocol) {
 	case IR_PROTOCOL_RC5:
 		if (wake_sc > 0xFFF) {
-			do_wake = 0;
+			do_wake = false;
 			dev_err(dev, "RC5 - Invalid wake scancode\n");
 			break;
 		}
@@ -418,7 +418,7 @@ wbcir_shutdown(struct pnp_dev *device)
 
 	case IR_PROTOCOL_NEC:
 		if (wake_sc > 0xFFFFFF) {
-			do_wake = 0;
+			do_wake = false;
 			dev_err(dev, "NEC - Invalid wake scancode\n");
 			break;
 		}
@@ -440,7 +440,7 @@ wbcir_shutdown(struct pnp_dev *device)
 
 		if (wake_rc6mode == 0) {
 			if (wake_sc > 0xFFFF) {
-				do_wake = 0;
+				do_wake = false;
 				dev_err(dev, "RC6 - Invalid wake scancode\n");
 				break;
 			}
@@ -496,7 +496,7 @@ wbcir_shutdown(struct pnp_dev *device)
 			} else if (wake_sc <= 0x007FFFFF) {
 				rc6_csl = 60;
 			} else {
-				do_wake = 0;
+				do_wake = false;
 				dev_err(dev, "RC6 - Invalid wake scancode\n");
 				break;
 			}
@@ -508,14 +508,14 @@ wbcir_shutdown(struct pnp_dev *device)
 			mask[i++] = 0x0F;
 
 		} else {
-			do_wake = 0;
+			do_wake = false;
 			dev_err(dev, "RC6 - Invalid wake mode\n");
 		}
 
 		break;
 
 	default:
-		do_wake = 0;
+		do_wake = false;
 		break;
 	}
 

