Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway12.websitewelcome.com ([70.85.6.5]:60196 "EHLO
	gateway.websitewelcome.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753436Ab1KRSwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Nov 2011 13:52:13 -0500
Received: from gator886.hostgator.com (gator886.hostgator.com [174.120.40.226])
	by gateway.websitewelcome.com (Postfix) with ESMTP id 7F0DD4D737026
	for <linux-media@vger.kernel.org>; Fri, 18 Nov 2011 12:29:16 -0600 (CST)
Received: from [50.43.67.106] (port=55938 helo=[10.140.1.40])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1RRTBc-0005tG-7E
	for linux-media@vger.kernel.org; Fri, 18 Nov 2011 12:29:16 -0600
Subject: [PATCH] go7007: Fix 2250 urb type
From: Pete Eberlein <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 10:29:16 -0800
Message-ID: <1321640956.2253.16.camel@pete-Aspire-M5700>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit a846d8fce9e8be30046be3c512982bd0345e7015
Author: Pete Eberlein <pete@sensoray.com>
Date:   Fri Nov 18 10:00:15 2011 -0800

go7007: Fix 2250 urb type

The 2250 board uses bulk endpoint for interrupt handling,
and should use a bulk urb instead of an int urb.

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 3db3b0a..cffb0b3 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1054,7 +1054,13 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	else
 		go->hpi_ops = &go7007_usb_onboard_hpi_ops;
 	go->hpi_context = usb;
-	usb_fill_int_urb(usb->intr_urb, usb->usbdev,
+	if (go->board_id == GO7007_BOARDID_SENSORAY_2250)
+		usb_fill_bulk_urb(usb->intr_urb, usb->usbdev,
+			usb_rcvbulkpipe(usb->usbdev, 4),
+			usb->intr_urb->transfer_buffer, 2*sizeof(u16),
+			go7007_usb_readinterrupt_complete, go);
+	else
+		usb_fill_int_urb(usb->intr_urb, usb->usbdev,
 			usb_rcvintpipe(usb->usbdev, 4),
 			usb->intr_urb->transfer_buffer, 2*sizeof(u16),
 			go7007_usb_readinterrupt_complete, go, 8);


