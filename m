Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.techmunk.com ([209.141.61.243]:46455 "EHLO
	mail.techmunk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbbCIFR4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 01:17:56 -0400
From: Christian Dale <cdale@aspedia.net>
To: mchehab@osg.samsung.com, crope@iki.fi
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christian Dale <kernel@techmunk.com>
Subject: [PATCH] [media] rtl28xxu: add [0413:6f12] WinFast DTV2000 DS Plus
Date: Mon,  9 Mar 2015 15:09:42 +1000
Message-Id: <1425877782-2696-1-git-send-email-cdale@aspedia.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Christian Dale <kernel@techmunk.com>

Add Leadtek WinFast DTV2000DS Plus device based on Realtek RTL2832U.

I have not tested the remote, but it is the Y04G0051 model.

Signed-off-by: Christian Dale <kernel@techmunk.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 80ab8d0..339ee5c 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -318,6 +318,7 @@
 #define USB_PID_GRANDTEC_DVBT_USB2_COLD			0x0bc6
 #define USB_PID_GRANDTEC_DVBT_USB2_WARM			0x0bc7
 #define USB_PID_WINFAST_DTV2000DS			0x6a04
+#define USB_PID_WINFAST_DTV2000DS_PLUS			0x6f12
 #define USB_PID_WINFAST_DTV_DONGLE_COLD			0x6025
 #define USB_PID_WINFAST_DTV_DONGLE_WARM			0x6026
 #define USB_PID_WINFAST_DTV_DONGLE_STK7700P		0x6f00
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 77dcfdf..aa5e58b 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1726,6 +1726,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl28xxu_props, "DigitalNow Quad DVB-T Receiver", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_LEADTEK, USB_PID_WINFAST_DTV_DONGLE_MINID,
 		&rtl28xxu_props, "Leadtek Winfast DTV Dongle Mini D", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_LEADTEK, USB_PID_WINFAST_DTV2000DS_PLUS,
+		&rtl28xxu_props, "Leadtek WinFast DTV2000DS Plus", RC_MAP_LEADTEK_Y04G0051) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d3,
 		&rtl28xxu_props, "TerraTec Cinergy T Stick RC (Rev. 3)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1102,
-- 
2.3.2

