Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:57771 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbcGTRDx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 13:03:53 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Chris Dodge <chris@redrat.co.uk>, linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media] redrat3: remove hw_timeout member
Date: Wed, 20 Jul 2016 18:03:49 +0100
Message-Id: <1469034230-19978-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a duplicate of the timeout in rc_dev.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 399f44d..4739bce 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -188,9 +188,6 @@ struct redrat3_dev {
 	/* usb dma */
 	dma_addr_t dma_in;
 
-	/* rx signal timeout */
-	u32 hw_timeout;
-
 	/* Is the device currently transmitting?*/
 	bool transmitting;
 
@@ -372,7 +369,7 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 	/* add a trailing space */
 	rawir.pulse = false;
 	rawir.timeout = true;
-	rawir.duration = US_TO_NS(rr3->hw_timeout);
+	rawir.duration = rr3->rc->timeout;
 	dev_dbg(dev, "storing trailing timeout with duration %d\n",
 							rawir.duration);
 	ir_raw_event_store_with_filter(rr3->rc, &rawir);
@@ -495,10 +492,9 @@ static int redrat3_set_timeout(struct rc_dev *rc_dev, unsigned int timeoutns)
 	dev_dbg(dev, "set ir parm timeout %d ret 0x%02x\n",
 						be32_to_cpu(*timeout), ret);
 
-	if (ret == sizeof(*timeout)) {
-		rr3->hw_timeout = timeoutns / 1000;
+	if (ret == sizeof(*timeout))
 		ret = 0;
-	} else if (ret >= 0)
+	else if (ret >= 0)
 		ret = -EIO;
 
 	kfree(timeout);
@@ -889,7 +885,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	rc->allowed_protocols = RC_BIT_ALL;
 	rc->min_timeout = MS_TO_NS(RR3_RX_MIN_TIMEOUT);
 	rc->max_timeout = MS_TO_NS(RR3_RX_MAX_TIMEOUT);
-	rc->timeout = US_TO_NS(rr3->hw_timeout);
+	rc->timeout = US_TO_NS(redrat3_get_timeout(rr3));
 	rc->s_timeout = redrat3_set_timeout;
 	rc->tx_ir = redrat3_transmit_ir;
 	rc->s_tx_carrier = redrat3_set_tx_carrier;
@@ -1000,9 +996,6 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	if (retval < 0)
 		goto error;
 
-	/* store current hardware timeout, in µs */
-	rr3->hw_timeout = redrat3_get_timeout(rr3);
-
 	/* default.. will get overridden by any sends with a freq defined */
 	rr3->carrier = 38000;
 
-- 
2.7.4

