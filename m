Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52764 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752743AbdFVTX5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 15:23:57 -0400
Subject: [PATCH 1/2] rc-core: consistent use of rc_repeat()
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Thu, 22 Jun 2017 21:23:54 +0200
Message-ID: <149815943494.22167.1097240093419552448.stgit@zeus.hardeman.nu>
In-Reply-To: <149815927618.22167.7035029052539207589.stgit@zeus.hardeman.nu>
References: <149815927618.22167.7035029052539207589.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The NEC decoder and the Sanyo decoders check if dev->keypressed is true
before calling rc_repeat (without holding dev->keylock).

Meanwhile, the XMP and JVC decoders do no such checks.

This patch makes sure all users of rc_repeat() do so consistently by removing
extra checks in NEC/Sanyo and modifying the check a bit in rc_repeat() so that
no input event is generated if the key isn't pressed.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-nec-decoder.c   |   10 +++-------
 drivers/media/rc/ir-sanyo-decoder.c |   10 +++-------
 drivers/media/rc/rc-main.c          |    6 +++---
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 3ce850314dca..75b9137f6faf 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -88,13 +88,9 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			data->state = STATE_BIT_PULSE;
 			return 0;
 		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
-			if (!dev->keypressed) {
-				IR_dprintk(1, "Discarding last key repeat: event after key up\n");
-			} else {
-				rc_repeat(dev);
-				IR_dprintk(1, "Repeat last key\n");
-				data->state = STATE_TRAILER_PULSE;
-			}
+			rc_repeat(dev);
+			IR_dprintk(1, "Repeat last key\n");
+			data->state = STATE_TRAILER_PULSE;
 			return 0;
 		}
 
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 520bb77dcb62..e6a906a34f90 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -110,13 +110,9 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			break;
 
 		if (!data->count && geq_margin(ev.duration, SANYO_REPEAT_SPACE, SANYO_UNIT / 2)) {
-			if (!dev->keypressed) {
-				IR_dprintk(1, "SANYO discarding last key repeat: event after key up\n");
-			} else {
-				rc_repeat(dev);
-				IR_dprintk(1, "SANYO repeat last key\n");
-				data->state = STATE_INACTIVE;
-			}
+			rc_repeat(dev);
+			IR_dprintk(1, "SANYO repeat last key\n");
+			data->state = STATE_INACTIVE;
 			return 0;
 		}
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index a9eba0013525..7387bd4d75b0 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -616,12 +616,12 @@ void rc_repeat(struct rc_dev *dev)
 
 	spin_lock_irqsave(&dev->keylock, flags);
 
-	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
-	input_sync(dev->input_dev);
-
 	if (!dev->keypressed)
 		goto out;
 
+	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
+	input_sync(dev->input_dev);
+
 	dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
 	mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
 
