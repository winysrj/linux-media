Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:36243 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab3GHVlP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jul 2013 17:41:15 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH] [media] redrat3: errors on unplug
Date: Mon,  8 Jul 2013 22:33:08 +0100
Message-Id: <1373319192-26816-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In an usb disconnect handler, the urbs have already been cancelled so the
attempt to disable the IR receiver just results in errors:

[  899.638862] redrat3 7-2:1.0: redrat3_send_cmd: Error sending rr3 cmd res -110, data 0
[  899.638870] redrat3 7-2:1.0: redrat3_disable_detector: detector status: 251, should be 0

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 12167a6..3749443 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -206,8 +206,6 @@ struct redrat3_dev {
 	struct timer_list rx_timeout;
 	u32 hw_timeout;
 
-	/* is the detector enabled*/
-	bool det_enabled;
 	/* Is the device currently transmitting?*/
 	bool transmitting;
 
@@ -472,32 +470,11 @@ static int redrat3_enable_detector(struct redrat3_dev *rr3)
 		return -EIO;
 	}
 
-	rr3->det_enabled = true;
 	redrat3_issue_async(rr3);
 
 	return 0;
 }
 
-/* Disables the rr3 long range detector */
-static void redrat3_disable_detector(struct redrat3_dev *rr3)
-{
-	struct device *dev = rr3->dev;
-	u8 ret;
-
-	rr3_ftr(dev, "Entering %s\n", __func__);
-
-	ret = redrat3_send_cmd(RR3_RC_DET_DISABLE, rr3);
-	if (ret != 0)
-		dev_err(dev, "%s: failure!\n", __func__);
-
-	ret = redrat3_send_cmd(RR3_RC_DET_STATUS, rr3);
-	if (ret != 0)
-		dev_warn(dev, "%s: detector status: %d, should be 0\n",
-			 __func__, ret);
-
-	rr3->det_enabled = false;
-}
-
 static inline void redrat3_delete(struct redrat3_dev *rr3,
 				  struct usb_device *udev)
 {
@@ -788,7 +765,6 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 	count = min_t(unsigned, count, RR3_MAX_SIG_SIZE - RR3_TX_TRAILER_LEN);
 
 	/* rr3 will disable rc detector on transmit */
-	rr3->det_enabled = false;
 	rr3->transmitting = true;
 
 	sample_lens = kzalloc(sizeof(int) * RR3_DRIVER_MAXLENS, GFP_KERNEL);
@@ -868,7 +844,6 @@ out:
 
 	rr3->transmitting = false;
 	/* rr3 re-enables rc detector because it was enabled before */
-	rr3->det_enabled = true;
 
 	return ret;
 }
@@ -1048,8 +1023,6 @@ static void redrat3_dev_disconnect(struct usb_interface *intf)
 	if (!rr3)
 		return;
 
-	redrat3_disable_detector(rr3);
-
 	usb_set_intfdata(intf, NULL);
 	rc_unregister_device(rr3->rc);
 	del_timer_sync(&rr3->rx_timeout);
-- 
1.8.3.1

