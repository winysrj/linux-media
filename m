Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:4910 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab2K1Qf3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 11:35:29 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 1/2] au0828: add missing model 72281, usb id 2040:7270 to the model matrix
Date: Wed, 28 Nov 2012 11:35:00 -0500
Message-Id: <1354120501-4819-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/usb/au0828/au0828-cards.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index 0cb7c28..d12bdd3 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -170,6 +170,7 @@ static void hauppauge_eeprom(struct au0828_dev *dev, u8 *eeprom_data)
 	case 72241: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM and analog video */
 	case 72251: /* WinTV-HVR950q (Retail, IR, ATSC/QAM and analog video */
 	case 72261: /* WinTV-HVR950q (OEM, IR, ATSC/QAM and analog video */
+	case 72281: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM */
 	case 72301: /* WinTV-HVR850 (Retail, IR, ATSC and analog video */
 	case 72500: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM */
 		break;
@@ -333,6 +334,8 @@ struct usb_device_id au0828_usb_id_table[] = {
 		.driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q },
 	{ USB_DEVICE(0x2040, 0x7213),
 		.driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q },
+	{ USB_DEVICE(0x2040, 0x7270),
+		.driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q },
 	{ },
 };
 
-- 
1.7.10.4

