Return-path: <linux-media-owner@vger.kernel.org>
Received: from gelbbaer.kn-bremen.de ([78.46.108.116]:46211 "EHLO
	smtp.kn-bremen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab2KMSUM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 13:20:12 -0500
From: Juergen Lock <nox@jelal.kn-bremen.de>
Date: Tue, 13 Nov 2012 19:09:28 +0100
To: linux-media@vger.kernel.org
Cc: hselasky@c2i.net
Subject: [PATCH] [media] rtl28xxu: add NOXON DAB/DAB+ USB dongle rev 2
Message-ID: <20121113180928.GA40337@triton8.kn-bremen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This just adds the usbid to the rtl28xxu driver, that's all that's
needed to make the stick work for DVB.

Signed-off-by: Juergen Lock <nox@jelal.kn-bremen.de>

--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -250,6 +250,7 @@
 #define USB_PID_TERRATEC_T3				0x10a0
 #define USB_PID_TERRATEC_T5				0x10a1
 #define USB_PID_NOXON_DAB_STICK				0x00b3
+#define USB_PID_NOXON_DAB_STICK_REV2			0x00e0
 #define USB_PID_PINNACLE_EXPRESSCARD_320CX		0x022e
 #define USB_PID_PINNACLE_PCTV2000E			0x022c
 #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1338,6 +1338,8 @@ static const struct usb_device_id rtl28x
 		&rtl2832u_props, "G-Tek Electronics Group Lifeview LV5TDLX DVB-T", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK,
 		&rtl2832u_props, "NOXON DAB/DAB+ USB dongle", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK_REV2,
+		&rtl2832u_props, "NOXON DAB/DAB+ USB dongle (rev 2)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_TREKSTOR_TERRES_2_0,
 		&rtl2832u_props, "Trekstor DVB-T Stick Terres 2.0", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1101,
