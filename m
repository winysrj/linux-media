Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mynetfone.com.au ([125.213.165.10]:60050 "EHLO
	spam.symbionetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab3LMOIV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 09:08:21 -0500
Received: from spam.symbionetworks.com (localhost.localdomain [127.0.0.1])
	by localhost (Email Security Appliance) with SMTP id 2A0DF18BC3D3_2AB1182B
	for <linux-media@vger.kernel.org>; Fri, 13 Dec 2013 13:54:10 +0000 (GMT)
Received: from boffin.lan (unknown [115.187.242.125])
	by spam.symbionetworks.com (Sophos Email Appliance) with ESMTP id 352BA18BC3BB_2AB1181F
	for <linux-media@vger.kernel.org>; Fri, 13 Dec 2013 13:54:09 +0000 (GMT)
Received: (from robbak@localhost)
	by boffin.lan (8.14.6/8.14.6/Submit) id rBDE1qoF039531
	for linux-media@vger.kernel.org; Sat, 14 Dec 2013 00:01:52 +1000 (EST)
	(envelope-from robbak)
Date: Sat, 14 Dec 2013 00:01:52 +1000 (EST)
From: Robert Backhaus <robbak@robbak.com>
Message-Id: <201312131401.rBDE1qoF039531@boffin.lan>
To: linux-media@vger.kernel.org
Subject: [PATCH] Add USB IDs for Winfast DTV Dongle Mini-D
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Robert Backhaus <robbak@robbak.com>
Date:   Fri Dec 13 22:59:10 2013 +1000

    Add USB IDs for the WinFast DTV Dongle Mini.
    Device is tested and works fine under MythTV
    
    Signed-off-by: Robert Backhaus <robbak@robbak.com>

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 4a53454..6947621 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -317,6 +317,7 @@
 #define USB_PID_WINFAST_DTV_DONGLE_H			0x60f6
 #define USB_PID_WINFAST_DTV_DONGLE_STK7700P_2		0x6f01
 #define USB_PID_WINFAST_DTV_DONGLE_GOLD			0x6029
+#define USB_PID_WINFAST_DTV_DONGLE_MINID		0x6f0f
 #define USB_PID_GENPIX_8PSK_REV_1_COLD			0x0200
 #define USB_PID_GENPIX_8PSK_REV_1_WARM			0x0201
 #define USB_PID_GENPIX_8PSK_REV_2			0x0202
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index ecca036..fda5c64 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1407,6 +1407,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Dexatek DK DVB-T Dongle", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6680,
 		&rtl2832u_props, "DigitalNow Quad DVB-T Receiver", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_LEADTEK, USB_PID_WINFAST_DTV_DONGLE_MINID,
+		&rtl2832u_props, "Leadtek Winfast DTV Dongle Mini D", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d3,
 		&rtl2832u_props, "TerraTec Cinergy T Stick RC (Rev. 3)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1102,
