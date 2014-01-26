Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:34329 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaAZVvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 16:51:14 -0500
Received: by mail-la0-f51.google.com with SMTP id c6so4003319lan.10
        for <linux-media@vger.kernel.org>; Sun, 26 Jan 2014 13:51:13 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sean Young <sean@mess.org>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFCv2 PATCH 5/5] winbond-cir: Add support for reading/writing wakeup scancodes via sysfs
Date: Sun, 26 Jan 2014 23:50:26 +0200
Message-Id: <1390773026-567-6-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1390773026-567-1-git-send-email-a.seppala@gmail.com>
References: <1390773026-567-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for reading/writing wakeup scancodes via sysfs
to nuvoton-cir hardware.

The existing mechanism of setting wakeup scancodes by using module
parameters is left untouched. If set the module parameters function as
default values for sysfs files.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/rc/winbond-cir.c | 66 ++++++++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 18 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 904baf4..c63a56e 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -683,6 +683,29 @@ wbcir_tx(struct rc_dev *dev, unsigned *b, unsigned count)
 	return count;
 }
 
+static int wbcir_wakeup_codes(struct rc_dev *dev,
+			      struct list_head *wakeup_code_list, int write)
+{
+	u32 value = 0x800F040C;
+	struct rc_wakeup_code *code;
+	if (write) {
+		code = list_first_entry_or_null(wakeup_code_list,
+						struct rc_wakeup_code,
+						list_item);
+		if (code)
+			value = code->value;
+
+		wake_sc = value;
+	} else {
+		code = kmalloc(sizeof(struct rc_wakeup_code), GFP_KERNEL);
+		if (!code)
+			return -ENOMEM;
+		code->value = wake_sc;
+		list_add_tail(&code->list_item, wakeup_code_list);
+	}
+	return 0;
+}
+
 /*****************************************************************************
  *
  * SETUP/INIT/SUSPEND/RESUME FUNCTIONS
@@ -708,12 +731,11 @@ wbcir_shutdown(struct pnp_dev *device)
 		goto finish;
 	}
 
-	switch (protocol) {
-	case IR_PROTOCOL_RC5:
+	if (data->dev->enabled_wake_protos & RC_BIT_RC5) {
 		if (wake_sc > 0xFFF) {
 			do_wake = false;
 			dev_err(dev, "RC5 - Invalid wake scancode\n");
-			break;
+			goto finish;
 		}
 
 		/* Mask = 13 bits, ex toggle */
@@ -726,13 +748,11 @@ wbcir_shutdown(struct pnp_dev *device)
 		if (!(wake_sc & 0x0040))             /* 2nd start bit  */
 			match[1] |= 0x10;
 
-		break;
-
-	case IR_PROTOCOL_NEC:
+	} else if (data->dev->enabled_wake_protos & RC_BIT_NEC) {
 		if (wake_sc > 0xFFFFFF) {
 			do_wake = false;
 			dev_err(dev, "NEC - Invalid wake scancode\n");
-			break;
+			goto finish;
 		}
 
 		mask[0] = mask[1] = mask[2] = mask[3] = 0xFF;
@@ -745,16 +765,12 @@ wbcir_shutdown(struct pnp_dev *device)
 			match[2] = bitrev8((wake_sc & 0xFF0000) >> 16);
 		else
 			match[2] = ~match[3];
-
-		break;
-
-	case IR_PROTOCOL_RC6:
-
+	} else if (data->dev->enabled_wake_protos & RC_BIT_RC6_0) {
 		if (wake_rc6mode == 0) {
 			if (wake_sc > 0xFFFF) {
 				do_wake = false;
 				dev_err(dev, "RC6 - Invalid wake scancode\n");
-				break;
+				goto finish;
 			}
 
 			/* Command */
@@ -810,7 +826,7 @@ wbcir_shutdown(struct pnp_dev *device)
 			} else {
 				do_wake = false;
 				dev_err(dev, "RC6 - Invalid wake scancode\n");
-				break;
+				goto finish;
 			}
 
 			/* Header */
@@ -824,11 +840,8 @@ wbcir_shutdown(struct pnp_dev *device)
 			dev_err(dev, "RC6 - Invalid wake mode\n");
 		}
 
-		break;
-
-	default:
+	} else {
 		do_wake = false;
-		break;
 	}
 
 finish:
@@ -1077,12 +1090,29 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->s_carrier_report = wbcir_set_carrier_report;
 	data->dev->s_tx_mask = wbcir_txmask;
 	data->dev->s_tx_carrier = wbcir_txcarrier;
+	data->dev->s_wakeup_codes = wbcir_wakeup_codes;
 	data->dev->tx_ir = wbcir_tx;
 	data->dev->priv = data;
 	data->dev->dev.parent = &device->dev;
 	data->dev->timeout = MS_TO_NS(100);
 	data->dev->rx_resolution = US_TO_NS(2);
 	data->dev->allowed_protos = RC_BIT_ALL;
+	data->dev->allowed_wake_protos = RC_BIT_RC5 | RC_BIT_RC6_0 | RC_BIT_NEC;
+	/* Utilize default protocol from module parameter */
+	switch (protocol) {
+	case IR_PROTOCOL_RC5:
+		data->dev->enabled_wake_protos = RC_BIT_RC5;
+		break;
+	case IR_PROTOCOL_RC6:
+		data->dev->enabled_wake_protos = RC_BIT_RC6_0;
+		break;
+	case IR_PROTOCOL_NEC:
+		data->dev->enabled_wake_protos = RC_BIT_NEC;
+		break;
+	default:
+		data->dev->enabled_wake_protos = RC_BIT_NONE;
+		break;
+	}
 
 	err = rc_register_device(data->dev);
 	if (err)
-- 
1.8.3.2

