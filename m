Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:57388 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3F3P5X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Jun 2013 11:57:23 -0400
Received: by mail-qa0-f47.google.com with SMTP id i13so1573337qae.20
        for <linux-media@vger.kernel.org>; Sun, 30 Jun 2013 08:57:23 -0700 (PDT)
Received: from vujade (207-38-182-96.c3-0.wsd-ubr1.qens-wsd.ny.cable.rcn.com. [207.38.182.96])
        by mx.google.com with ESMTPSA id y4sm24633184qai.5.2013.06.30.08.57.22
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Sun, 30 Jun 2013 08:57:22 -0700 (PDT)
Date: Sun, 30 Jun 2013 11:57:54 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] dib0700: add support for PCTV 2002e & PCTV 2002e SE
Message-ID: <20130630115754.5f0e8a8f@vujade>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/XlCFCAw5YuJ=QkhVyzlW2xP"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/XlCFCAw5YuJ=QkhVyzlW2xP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--MP_/XlCFCAw5YuJ=QkhVyzlW2xP
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-dib0700-add-support-for-PCTV-2002e-PCTV-2002e-SE.patch

>From b5a7481571163fc1c83a12987be8a6ebd88bc91a Mon Sep 17 00:00:00 2001
From: Michael Krufky <mkrufky@linuxtv.org>
Date: Sun, 30 Jun 2013 11:43:58 -0400
Subject: [PATCH] dib0700: add support for PCTV 2002e & PCTV 2002e SE

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb-core/dvb-usb-ids.h        |  2 ++
 drivers/media/usb/dvb-usb/dib0700_devices.c | 12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 886da16..419a2d6 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -369,4 +369,6 @@
 #define USB_PID_TECHNISAT_USB2_DVB_S2			0x0500
 #define USB_PID_CPYTO_REDI_PC50A			0xa803
 #define USB_PID_CTVDIGDUAL_V2				0xe410
+#define USB_PID_PCTV_2002E                              0x025c
+#define USB_PID_PCTV_2002E_SE                           0x025d
 #endif
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index f081360..829323e 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -3589,6 +3589,8 @@ struct usb_device_id dib0700_usb_id_table[] = {
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE7790P) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE8096P) },
 /* 80 */{ USB_DEVICE(USB_VID_ELGATO,	USB_PID_ELGATO_EYETV_DTT_2) },
+	{ USB_DEVICE(USB_VID_PCTV,      USB_PID_PCTV_2002E) },
+	{ USB_DEVICE(USB_VID_PCTV,      USB_PID_PCTV_2002E_SE) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -3993,12 +3995,20 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			}
 		},
 
-		.num_device_descs = 1,
+		.num_device_descs = 3,
 		.devices = {
 			{   "Hauppauge Nova-TD Stick (52009)",
 				{ &dib0700_usb_id_table[35], NULL },
 				{ NULL },
 			},
+			{   "PCTV 2002e",
+				{ &dib0700_usb_id_table[81], NULL },
+				{ NULL },
+			},
+			{   "PCTV 2002e SE",
+				{ &dib0700_usb_id_table[82], NULL },
+				{ NULL },
+			},
 		},
 
 		.rc.core = {
-- 
1.8.1.2


--MP_/XlCFCAw5YuJ=QkhVyzlW2xP--
