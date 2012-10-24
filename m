Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:52240 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab2JXVWo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 17:22:44 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/3] [media] winbond-cir: increase IR receiver resolution
Date: Wed, 24 Oct 2012 22:22:41 +0100
Message-Id: <1351113762-5530-2-git-send-email-sean@mess.org>
In-Reply-To: <1351113762-5530-1-git-send-email-sean@mess.org>
References: <1351113762-5530-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is needed for carrier reporting.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/winbond-cir.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 6f0f5ef..1ff47eb 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -358,7 +358,7 @@ wbcir_irq_rx(struct wbcir_data *data, struct pnp_dev *device)
 		if (data->rxstate == WBCIR_RXSTATE_ERROR)
 			continue;
 		rawir.pulse = irdata & 0x80 ? false : true;
-		rawir.duration = US_TO_NS(((irdata & 0x7F) + 1) * 10);
+		rawir.duration = US_TO_NS(((irdata & 0x7F) + 1) * 2);
 		ir_raw_event_store_with_filter(data->dev, &rawir);
 	}
 
@@ -862,8 +862,8 @@ wbcir_init_hw(struct wbcir_data *data)
 	/* prescaler 1.0, tx/rx fifo lvl 16 */
 	outb(0x30, data->sbase + WBCIR_REG_SP3_EXCR2);
 
-	/* Set baud divisor to sample every 10 us */
-	outb(0x0F, data->sbase + WBCIR_REG_SP3_BGDL);
+	/* Set baud divisor to sample every 2 ns */
+	outb(0x03, data->sbase + WBCIR_REG_SP3_BGDL);
 	outb(0x00, data->sbase + WBCIR_REG_SP3_BGDH);
 
 	/* Set CEIR mode */
@@ -872,9 +872,12 @@ wbcir_init_hw(struct wbcir_data *data)
 	inb(data->sbase + WBCIR_REG_SP3_LSR); /* Clear LSR */
 	inb(data->sbase + WBCIR_REG_SP3_MSR); /* Clear MSR */
 
-	/* Disable RX demod, enable run-length enc/dec, set freq span */
+	/*
+	 * Disable RX demod, enable run-length enc/dec, set freq span and
+	 * enable over-sampling
+	 */
 	wbcir_select_bank(data, WBCIR_BANK_7);
-	outb(0x90, data->sbase + WBCIR_REG_SP3_RCCFG);
+	outb(0xd0, data->sbase + WBCIR_REG_SP3_RCCFG);
 
 	/* Disable timer */
 	wbcir_select_bank(data, WBCIR_BANK_4);
@@ -1017,6 +1020,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->priv = data;
 	data->dev->dev.parent = &device->dev;
 	data->dev->timeout = MS_TO_NS(100);
+	data->dev->rx_resolution = US_TO_NS(2);
 	data->dev->allowed_protos = RC_TYPE_ALL;
 
 	if (!request_region(data->wbase, WAKEUP_IOMEM_LEN, DRVNAME)) {
-- 
1.7.11.7

