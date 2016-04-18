Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36529 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbcDRPqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2016 11:46:49 -0400
Received: by mail-qk0-f172.google.com with SMTP id x7so29402555qkd.3
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2016 08:46:49 -0700 (PDT)
From: Alejandro Torrado <aletorrado@gmail.com>
Cc: Alejandro Torrado <aletorrado@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] USB_PID_DIBCOM_STK8096GP also comes with USB_VID_DIBCOM vendor ID.
Date: Mon, 18 Apr 2016 12:46:41 -0300
Message-Id: <1460994401-25830-1-git-send-email-aletorrado@gmail.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Alejandro Torrado <aletorrado@gmail.com>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index ea0391e..ee7bafc 100644
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
-- 
1.9.1

