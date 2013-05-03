Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:59963 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038Ab3ECT6y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 May 2013 15:58:54 -0400
Received: by mail-ea0-f172.google.com with SMTP id r16so929996ead.3
        for <linux-media@vger.kernel.org>; Fri, 03 May 2013 12:58:53 -0700 (PDT)
From: Alessandro Miceli <angelofsky1980@gmail.com>
Cc: Alessandro Miceli <angelofsky1980@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [it913x] Add support for 'Digital Dual TV Receiver CTVDIGDUAL v2
Date: Fri,  3 May 2013 21:58:21 +0200
Message-Id: <1367611101-15688-1-git-send-email-angelofsky1980@gmail.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested on a MIPSel box with 3.3.6 kernel
The kernel output when the device will be detected follows:

usbcore: registered new interface driver dvb_usb_it913x
it913x: Chip Version=01 Chip Type=9135
it913x: Remote propriety (raw) mode
it913x: Dual mode=3 Tuner Type=38
it913x: Chip Version=01 Chip Type=9135
usb 2-1: dvb_usb_v2: found a 'Digital Dual TV Receiver CTVDIGDUAL_V2' in cold state
usb 2-1: dvb_usb_v2: downloading firmware from file 'dvb-usb-it9137-01.fw'
it913x: FRM Starting Firmware Download
it913x: FRM Firmware Download Completed - Resetting Device
it913x: Chip Version=01 Chip Type=9135
it913x: Firmware Version 204147968
usb 2-1: dvb_usb_v2: found a 'Digital Dual TV Receiver CTVDIGDUAL_V2' in warm state
usb 2-1: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
DVB: registering new adapter (Digital Dual TV Receiver CTVDIGDUAL_V2)
it913x-fe: ADF table value      :00
it913x-fe: Crystal Frequency :12000000 Adc Frequency :20250000 ADC X2: 00
it913x-fe: Tuner LNA type :38
usb 2-1: DVB: registering adapter 1 frontend 0 (Digital Dual TV Receiver CTVDIGDUAL_V2_1)...
usb 2-1: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
DVB: registering new adapter (Digital Dual TV Receiver CTVDIGDUAL_V2)
it913x-fe: ADF table value      :00
it913x-fe: Crystal Frequency :12000000 Adc Frequency :20250000 ADC X2: 00
it913x-fe: Tuner LNA type :38
usb 2-1: DVB: registering adapter 2 frontend 0 (Digital Dual TV Receiver CTVDIGDUAL_V2_2)...
usb 2-1: dvb_usb_v2: 'Digital Dual TV Receiver CTVDIGDUAL_V2' successfully initialized and connected

RC part not tested

Signed-off-by: Alessandro Miceli <angelofsky1980@gmail.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h  |    1 +
 drivers/media/usb/dvb-usb-v2/it913x.c |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 335a8f4..2e0709a 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -367,4 +367,5 @@
 #define USB_PID_TECHNISAT_USB2_HDCI_V2			0x0002
 #define USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2		0x0004
 #define USB_PID_TECHNISAT_USB2_DVB_S2			0x0500
+#define USB_PID_CTVDIGDUAL_V2				0xe410
 #endif
diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
index e48cdeb..1cb6899 100644
--- a/drivers/media/usb/dvb-usb-v2/it913x.c
+++ b/drivers/media/usb/dvb-usb-v2/it913x.c
@@ -45,7 +45,7 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able)).");
 
 static int dvb_usb_it913x_firmware;
 module_param_named(firmware, dvb_usb_it913x_firmware, int, 0644);
-MODULE_PARM_DESC(firmware, "set firmware 0=auto"\
+MODULE_PARM_DESC(firmware, "set firmware 0=auto "\
 	"1=IT9137 2=IT9135 V1 3=IT9135 V2");
 #define FW_IT9137 "dvb-usb-it9137-01.fw"
 #define FW_IT9135_V1 "dvb-usb-it9135-01.fw"
@@ -796,6 +796,9 @@ static const struct usb_device_id it913x_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_4835,
 		&it913x_properties, "Avermedia A835B(4835)",
 			RC_MAP_IT913X_V2) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_CTVDIGDUAL_V2,
+		&it913x_properties, "Digital Dual TV Receiver CTVDIGDUAL_V2",
+			RC_MAP_IT913X_V1) },
 	{}		/* Terminating entry */
 };
 
-- 
1.7.9.5

