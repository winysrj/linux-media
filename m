Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:52238 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758746Ab2JXVWo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 17:22:44 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/3] [media] winbond-cir: fix idle mode
Date: Wed, 24 Oct 2012 22:22:40 +0100
Message-Id: <1351113762-5530-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The receiver is never disabled by idle mode since rxstate never gets set
to RXSTATE_ACTIVE, so we keep on getting interrupts after the first IR
activity ends. Note that ir_raw_event_reset() already calls
ir_raw_event_handle().

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/winbond-cir.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 43b5403..6f0f5ef 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -207,7 +207,6 @@ struct wbcir_data {
 	/* RX state */
 	enum wbcir_rxstate rxstate;
 	struct led_trigger *rxtrigger;
-	struct ir_raw_event rxev;
 
 	/* TX state */
 	enum wbcir_txstate txstate;
@@ -339,9 +338,12 @@ wbcir_idle_rx(struct rc_dev *dev, bool idle)
 		led_trigger_event(data->rxtrigger, LED_FULL);
 	}
 
-	if (idle && data->rxstate != WBCIR_RXSTATE_INACTIVE)
+	if (idle && data->rxstate != WBCIR_RXSTATE_INACTIVE) {
+		data->rxstate = WBCIR_RXSTATE_INACTIVE;
+		led_trigger_event(data->rxtrigger, LED_OFF);
 		/* Tell hardware to go idle by setting RXINACTIVE */
 		outb(WBCIR_RX_DISABLE, data->sbase + WBCIR_REG_SP3_ASCR);
+	}
 }
 
 static void
@@ -360,12 +362,6 @@ wbcir_irq_rx(struct wbcir_data *data, struct pnp_dev *device)
 		ir_raw_event_store_with_filter(data->dev, &rawir);
 	}
 
-	/* Check if we should go idle */
-	if (data->dev->idle) {
-		led_trigger_event(data->rxtrigger, LED_OFF);
-		data->rxstate = WBCIR_RXSTATE_INACTIVE;
-	}
-
 	ir_raw_event_handle(data->dev);
 }
 
@@ -915,9 +911,8 @@ wbcir_init_hw(struct wbcir_data *data)
 
 	/* Clear RX state */
 	data->rxstate = WBCIR_RXSTATE_INACTIVE;
-	data->rxev.duration = 0;
 	ir_raw_event_reset(data->dev);
-	ir_raw_event_handle(data->dev);
+	ir_raw_event_set_idle(data->dev, true);
 
 	/* Clear TX state */
 	if (data->txstate == WBCIR_TXSTATE_ACTIVE) {
-- 
1.7.11.7

