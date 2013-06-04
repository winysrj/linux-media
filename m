Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53225 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3FDULr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jun 2013 16:11:47 -0400
Received: by mail-wi0-f180.google.com with SMTP id hn14so600934wib.7
        for <linux-media@vger.kernel.org>; Tue, 04 Jun 2013 13:11:46 -0700 (PDT)
From: Alessandro Miceli <angelofsky1980@gmail.com>
Cc: Alessandro Miceli <angelofsky1980@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [rtl28xxu] Add support for Crypto Redi PC50A device (rtl2832u + FC0012 tuner)
Date: Tue,  4 Jun 2013 22:10:34 +0200
Message-Id: <1370376634-3033-1-git-send-email-angelofsky1980@gmail.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device has been tested on a MIPSel box with kernel 3.1.1 and backported media_tree drivers

The kernel detects the device with the following output:

usbcore: registered new interface driver dvb_usb_rtl28xxu
usb 1-2: dvb_usb_v2: found a 'Crypto Redi PC50A' in warm state
usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
DVB: registering new adapter (Crypto Redi PC50A)
usb 1-2: DVB: registering adapter 1 frontend 0 (Realtek RTL2832 (DVB-T))...
i2c i2c-4: fc0012: Fitipower FC0012 successfully identified
usb 1-2: dvb_usb_v2: 'Crypto Redi PC50A' successfully initialized and connected

Signed-off-by: Alessandro Miceli <angelofsky1980@gmail.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h    |    1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 2e0709a..87bf2eb 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -368,4 +368,5 @@
 #define USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2		0x0004
 #define USB_PID_TECHNISAT_USB2_DVB_S2			0x0500
 #define USB_PID_CTVDIGDUAL_V2				0xe410
+#define USB_PID_CPYTO_REDI_PC50A			0xa803
 #endif
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 22015fe..9a0ad1e 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1408,6 +1408,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Compro VideoMate U620F", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd394,
 		&rtl2832u_props, "MaxMedia HU394-T", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_CPYTO_REDI_PC50A,
+		&rtl2832u_props, "Crypto Redi PC50A", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.7.9.5

