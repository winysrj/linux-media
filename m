Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:39245 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933292AbcGJQek (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 12:34:40 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Chris Dodge <chris@redrat.co.uk>, linux-media@vger.kernel.org
Subject: [PATCH 3/5] [media] redrat3: fix timeout handling
Date: Sun, 10 Jul 2016 17:34:37 +0100
Message-Id: <1468168479-27543-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The redrat3 sends an usb packet to the host either when the minimum pause
or the timeout occurs, so we can always add a trailing space in our
processing.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c | 48 +++++++++++-----------------------------------
 1 file changed, 11 insertions(+), 37 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 6adea78..1e65f7a 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -188,8 +188,7 @@ struct redrat3_dev {
 	/* usb dma */
 	dma_addr_t dma_in;
 
-	/* rx signal timeout timer */
-	struct timer_list rx_timeout;
+	/* rx signal timeout */
 	u32 hw_timeout;
 
 	/* Is the device currently transmitting?*/
@@ -330,22 +329,11 @@ static u32 redrat3_us_to_len(u32 microsec)
 	return result ? result : 1;
 }
 
-/* timer callback to send reset event */
-static void redrat3_rx_timeout(unsigned long data)
-{
-	struct redrat3_dev *rr3 = (struct redrat3_dev *)data;
-
-	dev_dbg(rr3->dev, "calling ir_raw_event_reset\n");
-	ir_raw_event_reset(rr3->rc);
-}
-
 static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 {
 	DEFINE_IR_RAW_EVENT(rawir);
 	struct device *dev;
-	unsigned i, trailer = 0;
-	unsigned sig_size, single_len, offset, val;
-	unsigned long delay;
+	unsigned int i, sig_size, single_len, offset, val;
 	u32 mod_freq;
 
 	if (!rr3) {
@@ -355,10 +343,6 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 
 	dev = rr3->dev;
 
-	/* Make sure we reset the IR kfifo after a bit of inactivity */
-	delay = usecs_to_jiffies(rr3->hw_timeout);
-	mod_timer(&rr3->rx_timeout, jiffies + delay);
-
 	mod_freq = redrat3_val_to_mod_freq(&rr3->irdata);
 	dev_dbg(dev, "Got mod_freq of %u\n", mod_freq);
 
@@ -376,9 +360,6 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 			rawir.pulse = true;
 
 		rawir.duration = US_TO_NS(single_len);
-		/* Save initial pulse length to fudge trailer */
-		if (i == 0)
-			trailer = rawir.duration;
 		/* cap the value to IR_MAX_DURATION */
 		rawir.duration = (rawir.duration > IR_MAX_DURATION) ?
 				 IR_MAX_DURATION : rawir.duration;
@@ -388,18 +369,13 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 		ir_raw_event_store_with_filter(rr3->rc, &rawir);
 	}
 
-	/* add a trailing space, if need be */
-	if (i % 2) {
-		rawir.pulse = false;
-		/* this duration is made up, and may not be ideal... */
-		if (trailer < US_TO_NS(1000))
-			rawir.duration = US_TO_NS(2800);
-		else
-			rawir.duration = trailer;
-		dev_dbg(dev, "storing trailing space with duration %d\n",
-			rawir.duration);
-		ir_raw_event_store_with_filter(rr3->rc, &rawir);
-	}
+	/* add a trailing space */
+	rawir.pulse = false;
+	rawir.timeout = true;
+	rawir.duration = US_TO_NS(rr3->hw_timeout);
+	dev_dbg(dev, "storing trailing timeout with duration %d\n",
+							rawir.duration);
+	ir_raw_event_store_with_filter(rr3->rc, &rawir);
 
 	dev_dbg(dev, "calling ir_raw_event_handle\n");
 	ir_raw_event_handle(rr3->rc);
@@ -880,7 +856,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	rc->priv = rr3;
 	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protocols = RC_BIT_ALL;
-	rc->timeout = US_TO_NS(2750);
+	rc->timeout = US_TO_NS(rr3->hw_timeout);
 	rc->tx_ir = redrat3_transmit_ir;
 	rc->s_tx_carrier = redrat3_set_tx_carrier;
 	rc->driver_name = DRIVER_NAME;
@@ -990,7 +966,7 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	if (retval < 0)
 		goto error;
 
-	/* store current hardware timeout, in us, will use for kfifo resets */
+	/* store current hardware timeout, in µs */
 	rr3->hw_timeout = redrat3_get_timeout(rr3);
 
 	/* default.. will get overridden by any sends with a freq defined */
@@ -1026,7 +1002,6 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 		retval = -ENOMEM;
 		goto led_free_error;
 	}
-	setup_timer(&rr3->rx_timeout, redrat3_rx_timeout, (unsigned long)rr3);
 
 	/* we can register the device now, as it is ready */
 	usb_set_intfdata(intf, rr3);
@@ -1055,7 +1030,6 @@ static void redrat3_dev_disconnect(struct usb_interface *intf)
 	usb_set_intfdata(intf, NULL);
 	rc_unregister_device(rr3->rc);
 	led_classdev_unregister(&rr3->led);
-	del_timer_sync(&rr3->rx_timeout);
 	redrat3_delete(rr3, udev);
 }
 
-- 
2.7.4

