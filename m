Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43567 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab2IRO1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 10:27:34 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] rtl28xxu: add ID [0bda:2832] Realtek RTL2832U reference design
Date: Tue, 18 Sep 2012 17:27:05 +0300
Message-Id: <1347978425-10559-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also change location of other RTL2832 reference design ID 0bda:2838.
I just like to see reference design IDs at the first IDs in the list.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 843eeaf..70c2df1 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1328,14 +1328,16 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT_2,
 		&rtl2831u_props, "Freecom USB2.0 DVB-T", NULL) },
 
+	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2832,
+		&rtl2832u_props, "Realtek RTL2832U reference design", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2838,
+		&rtl2832u_props, "Realtek RTL2832U reference design", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_BLACK_REV1,
 		&rtl2832u_props, "Terratec Cinergy T Stick Black", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_DELOCK_USB2_DVBT,
 		&rtl2832u_props, "G-Tek Electronics Group Lifeview LV5TDLX DVB-T", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK,
 		&rtl2832u_props, "NOXON DAB/DAB+ USB dongle", NULL) },
-	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2838,
-		&rtl2832u_props, "Realtek RTL2832U reference design", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_TREKSTOR_TERRES_2_0,
 		&rtl2832u_props, "Trekstor DVB-T Stick Terres 2.0", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1101,
-- 
1.7.11.4

