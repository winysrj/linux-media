Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:40358 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab2HYVrB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Aug 2012 17:47:01 -0400
Subject: [PATCH 2/8] winbond-cir: asynchronous tx
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jwilson@redhat.com, mchehab@redhat.com, sean@mess.org
Date: Sat, 25 Aug 2012 23:46:58 +0200
Message-ID: <20120825214658.22603.2294.stgit@localhost.localdomain>
In-Reply-To: <20120825214520.22603.37194.stgit@localhost.localdomain>
References: <20120825214520.22603.37194.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change winbond-cir's tx support to be asynchronous and not to mess with
the TX buffer. Essentially the winbond-cir counterpart to the patch
Sean Young sent for iguanair.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/winbond-cir.c |   47 +++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 29e6769..30ae1f2 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -180,7 +180,6 @@ enum wbcir_rxstate {
 enum wbcir_txstate {
 	WBCIR_TXSTATE_INACTIVE = 0,
 	WBCIR_TXSTATE_ACTIVE,
-	WBCIR_TXSTATE_DONE,
 	WBCIR_TXSTATE_ERROR
 };
 
@@ -216,7 +215,6 @@ struct wbcir_data {
 	u32 txlen;
 	u32 txoff;
 	u32 *txbuf;
-	wait_queue_head_t txwaitq;
 	u8 txmask;
 	u32 txcarrier;
 };
@@ -424,11 +422,11 @@ wbcir_irq_tx(struct wbcir_data *data)
 		if (data->txstate == WBCIR_TXSTATE_ERROR)
 			/* Clear TX underrun bit */
 			outb(WBCIR_TX_UNDERRUN, data->sbase + WBCIR_REG_SP3_ASCR);
-		else
-			data->txstate = WBCIR_TXSTATE_DONE;
 		wbcir_set_irqmask(data, WBCIR_IRQ_RX | WBCIR_IRQ_ERR);
 		led_trigger_event(data->txtrigger, LED_OFF);
-		wake_up(&data->txwaitq);
+		kfree(data->txbuf);
+		data->txbuf = NULL;
+		data->txstate = WBCIR_TXSTATE_INACTIVE;
 	} else if (data->txoff == data->txlen) {
 		/* At the end of transmission, tell the hw before last byte */
 		outsb(data->sbase + WBCIR_REG_SP3_TXDATA, bytes, used - 1);
@@ -579,43 +577,37 @@ wbcir_txmask(struct rc_dev *dev, u32 mask)
 }
 
 static int
-wbcir_tx(struct rc_dev *dev, unsigned *buf, unsigned count)
+wbcir_tx(struct rc_dev *dev, unsigned *b, unsigned count)
 {
 	struct wbcir_data *data = dev->priv;
+	unsigned *buf;
 	unsigned i;
 	unsigned long flags;
 
+	buf = kmalloc(count * sizeof(*b), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	/* Convert values to multiples of 10us */
+	for (i = 0; i < count; i++)
+		buf[i] = DIV_ROUND_CLOSEST(b[i], 10);
+
 	/* Not sure if this is possible, but better safe than sorry */
 	spin_lock_irqsave(&data->spinlock, flags);
 	if (data->txstate != WBCIR_TXSTATE_INACTIVE) {
 		spin_unlock_irqrestore(&data->spinlock, flags);
+		kfree(buf);
 		return -EBUSY;
 	}
 
-	/* Convert values to multiples of 10us */
-	for (i = 0; i < count; i++)
-		buf[i] = DIV_ROUND_CLOSEST(buf[i], 10);
-
 	/* Fill the TX fifo once, the irq handler will do the rest */
 	data->txbuf = buf;
 	data->txlen = count;
 	data->txoff = 0;
 	wbcir_irq_tx(data);
 
-	/* Wait for the TX to complete */
-	while (data->txstate == WBCIR_TXSTATE_ACTIVE) {
-		spin_unlock_irqrestore(&data->spinlock, flags);
-		wait_event(data->txwaitq, data->txstate != WBCIR_TXSTATE_ACTIVE);
-		spin_lock_irqsave(&data->spinlock, flags);
-	}
-
 	/* We're done */
-	if (data->txstate == WBCIR_TXSTATE_ERROR)
-		count = -EAGAIN;
-	data->txstate = WBCIR_TXSTATE_INACTIVE;
-	data->txbuf = NULL;
 	spin_unlock_irqrestore(&data->spinlock, flags);
-
 	return count;
 }
 
@@ -927,13 +919,11 @@ wbcir_init_hw(struct wbcir_data *data)
 	ir_raw_event_reset(data->dev);
 	ir_raw_event_handle(data->dev);
 
-	/*
-	 * Check TX state, if we did a suspend/resume cycle while TX was
-	 * active, we will have a process waiting in txwaitq.
-	 */
+	/* Clear TX state */
 	if (data->txstate == WBCIR_TXSTATE_ACTIVE) {
-		data->txstate = WBCIR_TXSTATE_ERROR;
-		wake_up(&data->txwaitq);
+		kfree(data->txbuf);
+		data->txbuf = NULL;
+		data->txstate = WBCIR_TXSTATE_INACTIVE;
 	}
 
 	/* Enable interrupts */
@@ -974,7 +964,6 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	pnp_set_drvdata(device, data);
 
 	spin_lock_init(&data->spinlock);
-	init_waitqueue_head(&data->txwaitq);
 	data->ebase = pnp_port_start(device, 0);
 	data->wbase = pnp_port_start(device, 1);
 	data->sbase = pnp_port_start(device, 2);

