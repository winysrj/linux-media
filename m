Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34305 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750749AbeELKzd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 06:55:33 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] media: rc: winbond: do not send reset and timeout raw events on startup
Date: Sat, 12 May 2018 11:55:31 +0100
Message-Id: <20180512105531.30482-3-sean@mess.org>
In-Reply-To: <20180512105531.30482-1-sean@mess.org>
References: <20180512105531.30482-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ir_raw_event_set_idle() sends a timeout event which is not needed, and
on startup no reset event is needed either.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/winbond-cir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 0adf0991f5ab..851acba9b436 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -989,8 +989,7 @@ wbcir_init_hw(struct wbcir_data *data)
 
 	/* Clear RX state */
 	data->rxstate = WBCIR_RXSTATE_INACTIVE;
-	ir_raw_event_reset(data->dev);
-	ir_raw_event_set_idle(data->dev, true);
+	wbcir_idle_rx(data->dev, true);
 
 	/* Clear TX state */
 	if (data->txstate == WBCIR_TXSTATE_ACTIVE) {
@@ -1009,6 +1008,7 @@ wbcir_resume(struct pnp_dev *device)
 	struct wbcir_data *data = pnp_get_drvdata(device);
 
 	wbcir_init_hw(data);
+	ir_raw_event_reset(data->dev);
 	enable_irq(data->irq);
 	led_classdev_resume(&data->led);
 
-- 
2.17.0
