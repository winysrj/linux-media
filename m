Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63003 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3ENEpH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 00:45:07 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl13so163068pab.20
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 21:45:05 -0700 (PDT)
From: Jeff Hansen <x@jeffhansen.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jeff Hansen <x@jeffhansen.com>
Subject: [PATCH] [media] hdpvr: Disable IR receiver by default.
Date: Mon, 13 May 2013 22:44:19 -0600
Message-Id: <1368506659-13722-1-git-send-email-x@jeffhansen.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All of the firmwares I've tested, including 0x1e, will inevitably crash
before recording for even 10 minutes. There must be a race condition of
IR RX vs. video-encoding in the firmware, because if you disable IR receiver
polling, then the firmware is stable again. I'd guess that most people don't
use this feature anyway, so we might as well disable it by default, and
warn them that it might be unstable until Hauppauge fixes it in a future
firmware.

Signed-off-by: Jeff Hansen <x@jeffhansen.com>
---
 drivers/media/usb/hdpvr/hdpvr-core.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 8247c19..3e80202 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -53,6 +53,10 @@ static bool boost_audio;
 module_param(boost_audio, bool, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(boost_audio, "boost the audio signal");
 
+int ir_rx_enable;
+module_param(ir_rx_enable, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(ir_rx_enable, "Enable HDPVR IR receiver (firmware may be unstable)");
+
 
 /* table of devices that work with this driver */
 static struct usb_device_id hdpvr_table[] = {
@@ -394,11 +398,13 @@ static int hdpvr_probe(struct usb_interface *interface,
 		goto error;
 	}
 
-	client = hdpvr_register_ir_rx_i2c(dev);
-	if (!client) {
-		v4l2_err(&dev->v4l2_dev, "i2c IR RX device register failed\n");
-		retval = -ENODEV;
-		goto reg_fail;
+	if (ir_rx_enable) {
+		client = hdpvr_register_ir_rx_i2c(dev);
+		if (!client) {
+			v4l2_err(&dev->v4l2_dev, "i2c IR RX device register failed\n");
+			retval = -ENODEV;
+			goto reg_fail;
+		}
 	}
 
 	client = hdpvr_register_ir_tx_i2c(dev);
-- 
1.7.9.5

