Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout01.plus.net ([84.93.230.227]:46722 "EHLO
        avasout01.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbeCWTyq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 15:54:46 -0400
From: Chris Mayo <aklhfex@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: em28xx-cards: output regular messages as info
Date: Fri, 23 Mar 2018 19:47:13 +0000
Message-Id: <20180323194713.32435-1-aklhfex@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Messages expected during device probe were being marked as errors.

Signed-off-by: Chris Mayo <aklhfex@gmail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 6e0e67d23..8977c2be3 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3736,7 +3736,7 @@ static int em28xx_usb_probe(struct usb_interface *intf,
 		speed = "unknown";
 	}
 
-	dev_err(&intf->dev,
+	dev_info(&intf->dev,
 		"New device %s %s @ %s Mbps (%04x:%04x, interface %d, class %d)\n",
 		udev->manufacturer ? udev->manufacturer : "",
 		udev->product ? udev->product : "",
@@ -3771,7 +3771,7 @@ static int em28xx_usb_probe(struct usb_interface *intf,
 	dev->dev_next = NULL;
 
 	if (has_vendor_audio) {
-		dev_err(&intf->dev,
+		dev_info(&intf->dev,
 			"Audio interface %i found (Vendor Class)\n", ifnum);
 		dev->usb_audio_type = EM28XX_USB_AUDIO_VENDOR;
 	}
@@ -3790,12 +3790,12 @@ static int em28xx_usb_probe(struct usb_interface *intf,
 	}
 
 	if (has_video)
-		dev_err(&intf->dev, "Video interface %i found:%s%s\n",
+		dev_info(&intf->dev, "Video interface %i found:%s%s\n",
 			ifnum,
 			dev->analog_ep_bulk ? " bulk" : "",
 			dev->analog_ep_isoc ? " isoc" : "");
 	if (has_dvb)
-		dev_err(&intf->dev, "DVB interface %i found:%s%s\n",
+		dev_info(&intf->dev, "DVB interface %i found:%s%s\n",
 			ifnum,
 			dev->dvb_ep_bulk ? " bulk" : "",
 			dev->dvb_ep_isoc ? " isoc" : "");
@@ -3837,13 +3837,13 @@ static int em28xx_usb_probe(struct usb_interface *intf,
 	if (has_video) {
 		if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
 			dev->analog_xfer_bulk = 1;
-		dev_err(&intf->dev, "analog set to %s mode.\n",
+		dev_info(&intf->dev, "analog set to %s mode.\n",
 			dev->analog_xfer_bulk ? "bulk" : "isoc");
 	}
 	if (has_dvb) {
 		if (!dev->dvb_ep_isoc || (try_bulk && dev->dvb_ep_bulk))
 			dev->dvb_xfer_bulk = 1;
-		dev_err(&intf->dev, "dvb set to %s mode.\n",
+		dev_info(&intf->dev, "dvb set to %s mode.\n",
 			dev->dvb_xfer_bulk ? "bulk" : "isoc");
 	}
 
-- 
2.16.1
