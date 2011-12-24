Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hnelson.de ([83.169.43.49]:49481 "EHLO mail.hnelson.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab1LXDY6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Dec 2011 22:24:58 -0500
Received: from nova-wlan.fritz.box (91-67-142-84-dynip.superkabel.de [91.67.142.84])
	by mail.hnelson.de (Postfix) with ESMTPSA id 4F8EE1B4181BE
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 04:15:40 +0100 (CET)
Date: Sat, 24 Dec 2011 04:15:32 +0100 (CET)
From: Holger Nelson <hnelson@hnelson.de>
To: linux-media@vger.kernel.org
Subject: [PATCH] em28xx: Add Terratec Cinergy HTC USB XS to em28xx-cards.c
Message-ID: <4EF542DA.8030800@hnelson.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for the Terratec Cinergy HTC USB XS which is similar to 
the Terratec H5 by adding the USB-ids to the table. According to 
http://linux.terratec.de it uses the same ICs and DVB-C works for me
using the firmware of the H5.

Signed-off-by: Holger Nelson <hnelson@hnelson.de>
---
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 1704da0..a7cfded 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1963,6 +1963,10 @@ struct usb_device_id em28xx_id_table[] = {
  			.driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
  	{ USB_DEVICE(0x0ccd, 0x0043),
  			.driver_info = EM2870_BOARD_TERRATEC_XS },
+	{ USB_DEVICE(0x0ccd, 0x008e),	/* Cinergy HTC USB XS Rev. 1 */
+			.driver_info = EM2884_BOARD_TERRATEC_H5 },
+	{ USB_DEVICE(0x0ccd, 0x00ac),	/* Cinergy HTC USB XS Rev. 2 */
+			.driver_info = EM2884_BOARD_TERRATEC_H5 },
  	{ USB_DEVICE(0x0ccd, 0x10a2),	/* H5 Rev. 1 */
  			.driver_info = EM2884_BOARD_TERRATEC_H5 },
  	{ USB_DEVICE(0x0ccd, 0x10ad),	/* H5 Rev. 2 */
