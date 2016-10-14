Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:63384 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755004AbcJNLoN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 07:44:13 -0400
Subject: [PATCH 4/5] [media] winbond-cir: One variable and its check less in
 wbcir_shutdown() after error detection
To: linux-media@vger.kernel.org,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <84757ae3-24d2-cf9b-2217-fd9793b86078@users.sourceforge.net>
Date: Fri, 14 Oct 2016 13:44:02 +0200
MIME-Version: 1.0
In-Reply-To: <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 14 Oct 2016 12:48:41 +0200

The local variable "do_wake" was set to "false" after an invalid system
setting was detected so that a bit of error handling was triggered.

* Replace these assignments by direct jumps to the source code with the
desired exception handling.

* Delete this status variable and a corresponding check which became
  unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/winbond-cir.c | 78 ++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 44 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 9d05e17..3d286b9 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -699,16 +699,13 @@ wbcir_shutdown(struct pnp_dev *device)
 {
 	struct device *dev = &device->dev;
 	struct wbcir_data *data = pnp_get_drvdata(device);
-	bool do_wake = true;
 	u8 match[11];
 	u8 mask[11];
 	u8 rc6_csl;
 	int i;
 
-	if (wake_sc == INVALID_SCANCODE || !device_may_wakeup(dev)) {
-		do_wake = false;
-		goto finish;
-	}
+	if (wake_sc == INVALID_SCANCODE || !device_may_wakeup(dev))
+		goto clear_bits;
 
 	rc6_csl = 0;
 	memset(match, 0, sizeof(match));
@@ -716,9 +713,8 @@ wbcir_shutdown(struct pnp_dev *device)
 	switch (protocol) {
 	case IR_PROTOCOL_RC5:
 		if (wake_sc > 0xFFF) {
-			do_wake = false;
 			dev_err(dev, "RC5 - Invalid wake scancode\n");
-			break;
+			goto clear_bits;
 		}
 
 		/* Mask = 13 bits, ex toggle */
@@ -735,9 +731,8 @@ wbcir_shutdown(struct pnp_dev *device)
 
 	case IR_PROTOCOL_NEC:
 		if (wake_sc > 0xFFFFFF) {
-			do_wake = false;
 			dev_err(dev, "NEC - Invalid wake scancode\n");
-			break;
+			goto clear_bits;
 		}
 
 		mask[0] = mask[1] = mask[2] = mask[3] = 0xFF;
@@ -757,9 +752,8 @@ wbcir_shutdown(struct pnp_dev *device)
 
 		if (wake_rc6mode == 0) {
 			if (wake_sc > 0xFFFF) {
-				do_wake = false;
 				dev_err(dev, "RC6 - Invalid wake scancode\n");
-				break;
+				goto clear_bits;
 			}
 
 			/* Command */
@@ -813,9 +807,8 @@ wbcir_shutdown(struct pnp_dev *device)
 			} else if (wake_sc <= 0x007FFFFF) {
 				rc6_csl = 60;
 			} else {
-				do_wake = false;
 				dev_err(dev, "RC6 - Invalid wake scancode\n");
-				break;
+				goto clear_bits;
 			}
 
 			/* Header */
@@ -825,49 +818,38 @@ wbcir_shutdown(struct pnp_dev *device)
 			mask[i++] = 0x0F;
 
 		} else {
-			do_wake = false;
 			dev_err(dev, "RC6 - Invalid wake mode\n");
+			goto clear_bits;
 		}
 
 		break;
 
 	default:
-		do_wake = false;
-		break;
+		goto clear_bits;
 	}
 
-finish:
-	if (do_wake) {
-		/* Set compare and compare mask */
-		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_INDEX,
-			       WBCIR_REGSEL_COMPARE | WBCIR_REG_ADDR0,
-			       0x3F);
-		outsb(data->wbase + WBCIR_REG_WCEIR_DATA, match, 11);
-		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_INDEX,
-			       WBCIR_REGSEL_MASK | WBCIR_REG_ADDR0,
-			       0x3F);
-		outsb(data->wbase + WBCIR_REG_WCEIR_DATA, mask, 11);
-
-		/* RC6 Compare String Len */
-		outb(rc6_csl, data->wbase + WBCIR_REG_WCEIR_CSL);
-
-		/* Clear status bits NEC_REP, BUFF, MSG_END, MATCH */
-		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_STS, 0x17, 0x17);
+	/* Set compare and compare mask */
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_INDEX,
+		       WBCIR_REGSEL_COMPARE | WBCIR_REG_ADDR0,
+		       0x3F);
+	outsb(data->wbase + WBCIR_REG_WCEIR_DATA, match, 11);
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_INDEX,
+		       WBCIR_REGSEL_MASK | WBCIR_REG_ADDR0,
+		       0x3F);
+	outsb(data->wbase + WBCIR_REG_WCEIR_DATA, mask, 11);
 
-		/* Clear BUFF_EN, Clear END_EN, Set MATCH_EN */
-		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x01, 0x07);
+	/* RC6 Compare String Len */
+	outb(rc6_csl, data->wbase + WBCIR_REG_WCEIR_CSL);
 
-		/* Set CEIR_EN */
-		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x01, 0x01);
-
-	} else {
-		/* Clear BUFF_EN, Clear END_EN, Clear MATCH_EN */
-		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x00, 0x07);
+	/* Clear status bits NEC_REP, BUFF, MSG_END, MATCH */
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_STS, 0x17, 0x17);
 
-		/* Clear CEIR_EN */
-		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x00, 0x01);
-	}
+	/* Clear BUFF_EN, Clear END_EN, Set MATCH_EN */
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x01, 0x07);
 
+	/* Set CEIR_EN */
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x01, 0x01);
+set_irqmask:
 	/*
 	 * ACPI will set the HW disable bit for SP3 which means that the
 	 * output signals are left in an undefined state which may cause
@@ -876,6 +858,14 @@ wbcir_shutdown(struct pnp_dev *device)
 	 */
 	wbcir_set_irqmask(data, WBCIR_IRQ_NONE);
 	disable_irq(data->irq);
+	return;
+clear_bits:
+	/* Clear BUFF_EN, Clear END_EN, Clear MATCH_EN */
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x00, 0x07);
+
+	/* Clear CEIR_EN */
+	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x00, 0x01);
+	goto set_irqmask;
 }
 
 static int
-- 
2.10.1

