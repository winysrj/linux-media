Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab1GMV0Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 17:26:25 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Chris Dodge <chris@redrat.co.uk>,
	Andrew Vincer <andrew.vincer@redrat.co.uk>,
	Stephen Cox <scox_nz@yahoo.com>
Subject: [PATCH 3/3] [media] redrat3: improve compat with lirc userspace decode
Date: Wed, 13 Jul 2011 17:26:07 -0400
Message-Id: <1310592367-11501-4-git-send-email-jarod@redhat.com>
In-Reply-To: <1310592367-11501-1-git-send-email-jarod@redhat.com>
References: <1310592367-11501-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is admittedly a bit of a hack, but if we change our timeout value
to something longer and fudge our synthesized trailing space sample
based on the initial pulse sample, rc-core decode continues to work just
fine with both rc-6 and rc-5, and now lirc userspace decode shows proper
repeats for both of those protocols as well. Also tested NEC
successfully with both decode options.

We do still need a reset timer callback using the hardware's timeout
value to make sure we actually process samples correctly, regardless of
our somewhat hacky timeout and synthesized trailer above.

This also adds a missing del_timer_sync call to the module unload path.

CC: Chris Dodge <chris@redrat.co.uk>
CC: Andrew Vincer <andrew.vincer@redrat.co.uk>
CC: Stephen Cox <scox_nz@yahoo.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/redrat3.c |   43 ++++++++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 5312e34..5fc2f05 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -205,6 +205,7 @@ struct redrat3_dev {
 
 	/* rx signal timeout timer */
 	struct timer_list rx_timeout;
+	u32 hw_timeout;
 
 	/* Is the device currently receiving? */
 	bool recv_in_progress;
@@ -428,7 +429,7 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 	DEFINE_IR_RAW_EVENT(rawir);
 	struct redrat3_signal_header header;
 	struct device *dev;
-	int i;
+	int i, trailer = 0;
 	unsigned long delay;
 	u32 mod_freq, single_len;
 	u16 *len_vals;
@@ -454,7 +455,8 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 	if (!(header.length >= RR3_HEADER_LENGTH))
 		dev_warn(dev, "read returned less than rr3 header len\n");
 
-	delay = usecs_to_jiffies(rr3->rc->timeout / 1000);
+	/* Make sure we reset the IR kfifo after a bit of inactivity */
+	delay = usecs_to_jiffies(rr3->hw_timeout);
 	mod_timer(&rr3->rx_timeout, jiffies + delay);
 
 	memcpy(&tmp32, sig_data + RR3_PAUSE_OFFSET, sizeof(tmp32));
@@ -503,6 +505,9 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 			rawir.pulse = true;
 
 		rawir.duration = US_TO_NS(single_len);
+		/* Save initial pulse length to fudge trailer */
+		if (i == 0)
+			trailer = rawir.duration;
 		/* cap the value to IR_MAX_DURATION */
 		rawir.duration &= IR_MAX_DURATION;
 
@@ -515,7 +520,10 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 	if (i % 2) {
 		rawir.pulse = false;
 		/* this duration is made up, and may not be ideal... */
-		rawir.duration = rr3->rc->timeout / 2;
+		if (trailer < US_TO_NS(1000))
+			rawir.duration = US_TO_NS(2800);
+		else
+			rawir.duration = trailer;
 		rr3_dbg(dev, "storing trailing space with duration %d\n",
 			rawir.duration);
 		ir_raw_event_store_with_filter(rr3->rc, &rawir);
@@ -619,36 +627,31 @@ static inline void redrat3_delete(struct redrat3_dev *rr3,
 	kfree(rr3);
 }
 
-static u32 redrat3_get_timeout(struct device *dev,
-			       struct rc_dev *rc, struct usb_device *udev)
+static u32 redrat3_get_timeout(struct redrat3_dev *rr3)
 {
 	u32 *tmp;
-	u32 timeout = MS_TO_NS(150); /* a sane default, if things go haywire */
+	u32 timeout = MS_TO_US(150); /* a sane default, if things go haywire */
 	int len, ret, pipe;
 
 	len = sizeof(*tmp);
 	tmp = kzalloc(len, GFP_KERNEL);
 	if (!tmp) {
-		dev_warn(dev, "Memory allocation faillure\n");
+		dev_warn(rr3->dev, "Memory allocation faillure\n");
 		return timeout;
 	}
 
-	pipe = usb_rcvctrlpipe(udev, 0);
-	ret = usb_control_msg(udev, pipe, RR3_GET_IR_PARAM,
+	pipe = usb_rcvctrlpipe(rr3->udev, 0);
+	ret = usb_control_msg(rr3->udev, pipe, RR3_GET_IR_PARAM,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
 			      RR3_IR_IO_SIG_TIMEOUT, 0, tmp, len, HZ * 5);
 	if (ret != len) {
-		dev_warn(dev, "Failed to read timeout from hardware\n");
+		dev_warn(rr3->dev, "Failed to read timeout from hardware\n");
 		return timeout;
 	}
 
-	timeout = US_TO_NS(redrat3_len_to_us(be32_to_cpu(*tmp)));
-	if (timeout < rc->min_timeout)
-		timeout = rc->min_timeout;
-	else if (timeout > rc->max_timeout)
-		timeout = rc->max_timeout;
+	timeout = redrat3_len_to_us(be32_to_cpu(*tmp));
 
-	rr3_dbg(dev, "Got timeout of %d ms\n", timeout / (1000 * 1000));
+	rr3_dbg(rr3->dev, "Got timeout of %d ms\n", timeout / 1000);
 	return timeout;
 }
 
@@ -1100,9 +1103,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	rc->priv = rr3;
 	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protos = RC_TYPE_ALL;
-	rc->min_timeout = MS_TO_NS(RR3_RX_MIN_TIMEOUT);
-	rc->max_timeout = MS_TO_NS(RR3_RX_MAX_TIMEOUT);
-	rc->timeout = redrat3_get_timeout(dev, rc, rr3->udev);
+	rc->timeout = US_TO_NS(2750);
 	rc->tx_ir = redrat3_transmit_ir;
 	rc->s_tx_carrier = redrat3_set_tx_carrier;
 	rc->driver_name = DRIVER_NAME;
@@ -1232,6 +1233,9 @@ static int __devinit redrat3_dev_probe(struct usb_interface *intf,
 	if (retval < 0)
 		goto error;
 
+	/* store current hardware timeout, in us, will use for kfifo resets */
+	rr3->hw_timeout = redrat3_get_timeout(rr3);
+
 	/* default.. will get overridden by any sends with a freq defined */
 	rr3->carrier = 38000;
 
@@ -1270,6 +1274,7 @@ static void __devexit redrat3_dev_disconnect(struct usb_interface *intf)
 
 	usb_set_intfdata(intf, NULL);
 	rc_unregister_device(rr3->rc);
+	del_timer_sync(&rr3->rx_timeout);
 	redrat3_delete(rr3, udev);
 
 	rr3_ftr(&intf->dev, "RedRat3 IR Transceiver now disconnected\n");
-- 
1.7.1

