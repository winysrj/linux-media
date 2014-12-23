Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35125 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418AbaLWVCN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 16:02:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 64/66] rtl28xxu: merge rtl2831u and rtl2832u properties
Date: Tue, 23 Dec 2014 22:49:57 +0200
Message-Id: <1419367799-14263-64-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As all the callbacks are already same we could merge device
properties struct too and save space.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 93 +++++++++++----------------------
 1 file changed, 31 insertions(+), 62 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 821dcba..23ded77 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1661,38 +1661,7 @@ static int rtl28xxu_pid_filter(struct dvb_usb_adapter *adap, int index,
 	}
 }
 
-static const struct dvb_usb_device_properties rtl2831u_props = {
-	.driver_name = KBUILD_MODNAME,
-	.owner = THIS_MODULE,
-	.adapter_nr = adapter_nr,
-	.size_of_priv = sizeof(struct rtl28xxu_dev),
-
-	.identify_state = rtl28xxu_identify_state,
-	.power_ctrl = rtl28xxu_power_ctrl,
-	.i2c_algo = &rtl28xxu_i2c_algo,
-	.read_config = rtl28xxu_read_config,
-	.frontend_attach = rtl28xxu_frontend_attach,
-	.frontend_detach = rtl28xxu_frontend_detach,
-	.tuner_attach = rtl28xxu_tuner_attach,
-	.init = rtl28xxu_init,
-	.get_rc_config = rtl28xxu_get_rc_config,
-
-	.num_adapters = 1,
-	.adapter = {
-		{
-			.caps = DVB_USB_ADAP_HAS_PID_FILTER |
-				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
-
-			.pid_filter_count = 32,
-			.pid_filter_ctrl = rtl28xxu_pid_filter_ctrl,
-			.pid_filter = rtl28xxu_pid_filter,
-
-			.stream = DVB_USB_STREAM_BULK(0x81, 6, 8 * 512),
-		},
-	},
-};
-
-static const struct dvb_usb_device_properties rtl2832u_props = {
+static const struct dvb_usb_device_properties rtl28xxu_props = {
 	.driver_name = KBUILD_MODNAME,
 	.owner = THIS_MODULE,
 	.adapter_nr = adapter_nr,
@@ -1728,69 +1697,69 @@ static const struct dvb_usb_device_properties rtl2832u_props = {
 static const struct usb_device_id rtl28xxu_id_table[] = {
 	/* RTL2831U devices: */
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, USB_PID_REALTEK_RTL2831U,
-		&rtl2831u_props, "Realtek RTL2831U reference design", NULL) },
+		&rtl28xxu_props, "Realtek RTL2831U reference design", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT,
-		&rtl2831u_props, "Freecom USB2.0 DVB-T", NULL) },
+		&rtl28xxu_props, "Freecom USB2.0 DVB-T", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT_2,
-		&rtl2831u_props, "Freecom USB2.0 DVB-T", NULL) },
+		&rtl28xxu_props, "Freecom USB2.0 DVB-T", NULL) },
 
 	/* RTL2832U devices: */
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2832,
-		&rtl2832u_props, "Realtek RTL2832U reference design", NULL) },
+		&rtl28xxu_props, "Realtek RTL2832U reference design", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2838,
-		&rtl2832u_props, "Realtek RTL2832U reference design", NULL) },
+		&rtl28xxu_props, "Realtek RTL2832U reference design", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_BLACK_REV1,
-		&rtl2832u_props, "TerraTec Cinergy T Stick Black", RC_MAP_TERRATEC_SLIM) },
+		&rtl28xxu_props, "TerraTec Cinergy T Stick Black", RC_MAP_TERRATEC_SLIM) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_DELOCK_USB2_DVBT,
-		&rtl2832u_props, "G-Tek Electronics Group Lifeview LV5TDLX DVB-T", NULL) },
+		&rtl28xxu_props, "G-Tek Electronics Group Lifeview LV5TDLX DVB-T", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK,
-		&rtl2832u_props, "TerraTec NOXON DAB Stick", NULL) },
+		&rtl28xxu_props, "TerraTec NOXON DAB Stick", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK_REV2,
-		&rtl2832u_props, "TerraTec NOXON DAB Stick (rev 2)", NULL) },
+		&rtl28xxu_props, "TerraTec NOXON DAB Stick (rev 2)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK_REV3,
-		&rtl2832u_props, "TerraTec NOXON DAB Stick (rev 3)", NULL) },
+		&rtl28xxu_props, "TerraTec NOXON DAB Stick (rev 3)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_TREKSTOR_TERRES_2_0,
-		&rtl2832u_props, "Trekstor DVB-T Stick Terres 2.0", NULL) },
+		&rtl28xxu_props, "Trekstor DVB-T Stick Terres 2.0", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1101,
-		&rtl2832u_props, "Dexatek DK DVB-T Dongle", NULL) },
+		&rtl28xxu_props, "Dexatek DK DVB-T Dongle", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6680,
-		&rtl2832u_props, "DigitalNow Quad DVB-T Receiver", NULL) },
+		&rtl28xxu_props, "DigitalNow Quad DVB-T Receiver", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_LEADTEK, USB_PID_WINFAST_DTV_DONGLE_MINID,
-		&rtl2832u_props, "Leadtek Winfast DTV Dongle Mini D", NULL) },
+		&rtl28xxu_props, "Leadtek Winfast DTV Dongle Mini D", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d3,
-		&rtl2832u_props, "TerraTec Cinergy T Stick RC (Rev. 3)", NULL) },
+		&rtl28xxu_props, "TerraTec Cinergy T Stick RC (Rev. 3)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1102,
-		&rtl2832u_props, "Dexatek DK mini DVB-T Dongle", NULL) },
+		&rtl28xxu_props, "Dexatek DK mini DVB-T Dongle", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d7,
-		&rtl2832u_props, "TerraTec Cinergy T Stick+", NULL) },
+		&rtl28xxu_props, "TerraTec Cinergy T Stick+", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd3a8,
-		&rtl2832u_props, "ASUS My Cinema-U3100Mini Plus V2", NULL) },
+		&rtl28xxu_props, "ASUS My Cinema-U3100Mini Plus V2", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd393,
-		&rtl2832u_props, "GIGABYTE U7300", NULL) },
+		&rtl28xxu_props, "GIGABYTE U7300", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1104,
-		&rtl2832u_props, "MSI DIGIVOX Micro HD", NULL) },
+		&rtl28xxu_props, "MSI DIGIVOX Micro HD", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_COMPRO, 0x0620,
-		&rtl2832u_props, "Compro VideoMate U620F", NULL) },
+		&rtl28xxu_props, "Compro VideoMate U620F", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd394,
-		&rtl2832u_props, "MaxMedia HU394-T", NULL) },
+		&rtl28xxu_props, "MaxMedia HU394-T", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a03,
-		&rtl2832u_props, "Leadtek WinFast DTV Dongle mini", NULL) },
+		&rtl28xxu_props, "Leadtek WinFast DTV Dongle mini", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_CPYTO_REDI_PC50A,
-		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
+		&rtl28xxu_props, "Crypto ReDi PC 50 A", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
-		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
+		&rtl28xxu_props, "Genius TVGo DVB-T03", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd395,
-		&rtl2832u_props, "Peak DVB-T USB", NULL) },
+		&rtl28xxu_props, "Peak DVB-T USB", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20_RTL2832U,
-		&rtl2832u_props, "Sveon STV20", NULL) },
+		&rtl28xxu_props, "Sveon STV20", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV21,
-		&rtl2832u_props, "Sveon STV21", NULL) },
+		&rtl28xxu_props, "Sveon STV21", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV27,
-		&rtl2832u_props, "Sveon STV27", NULL) },
+		&rtl28xxu_props, "Sveon STV27", NULL) },
 
 	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
-		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
+		&rtl28xxu_props, "Astrometa DVB-T2", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
http://palosaari.fi/

