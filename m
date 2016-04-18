Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:33627 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbcDRQhL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2016 12:37:11 -0400
Received: by mail-qg0-f50.google.com with SMTP id v14so28886438qge.0
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2016 09:37:11 -0700 (PDT)
From: Alejandro Torrado <aletorrado@gmail.com>
Cc: Alejandro Torrado <aletorrado@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] USB_PID_DIBCOM_STK8096GP also comes with USB_VID_DIBCOM vendor ID (FIXED PATCH)
Date: Mon, 18 Apr 2016 13:37:00 -0300
Message-Id: <1460997420-6530-1-git-send-email-aletorrado@gmail.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Alejandro Torrado <aletorrado@gmail.com>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index ea0391e..0857b56 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -3814,6 +3814,7 @@ struct usb_device_id dib0700_usb_id_table[] = {
 	{ USB_DEVICE(USB_VID_PCTV,      USB_PID_PCTV_2002E) },
 	{ USB_DEVICE(USB_VID_PCTV,      USB_PID_PCTV_2002E_SE) },
 	{ USB_DEVICE(USB_VID_PCTV,      USB_PID_DIBCOM_STK8096PVR) },
+	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK8096PVR) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -5017,7 +5018,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_device_descs = 1,
 		.devices = {
 			{   "DiBcom STK8096-PVR reference design",
-				{ &dib0700_usb_id_table[83], NULL },
+				{ &dib0700_usb_id_table[83],
+					&dib0700_usb_id_table[84], NULL},
 				{ NULL },
 			},
 		},
-- 
1.9.1

