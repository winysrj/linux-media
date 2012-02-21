Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61365 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab2BUQ0e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Feb 2012 11:26:34 -0500
Received: by bkcjm19 with SMTP id jm19so5486995bkc.19
        for <linux-media@vger.kernel.org>; Tue, 21 Feb 2012 08:26:32 -0800 (PST)
Message-ID: <4F43C5B5.9020506@googlemail.com>
Date: Tue, 21 Feb 2012 17:26:29 +0100
From: =?ISO-8859-15?Q?Paolo_Pant=F2?= <munix9@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] rtl28xxu: add another Freecom usb id
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Besides sticks with the usb id 14AA:0160, there exists also some
with 14AA:0161 - this is the output in /var/log/messages:

usb 1-1: new high-speed USB device number 2 using ehci_hcd
usb 1-1: New USB device found, idVendor=14aa, idProduct=0161
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: Freecom DVB-T
usb 1-1: Manufacturer: Freecom DVB-T
usb 1-1: SerialNumber: 00000000000036742

The patch is based on the code at
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/realtek


Signed-off-by: Paolo Pantò <munix9@googlemail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 drivers/media/dvb/dvb-usb/rtl28xxu.c    |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 3d9a166..ba330ed 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -128,6 +128,7 @@
 #define USB_PID_E3C_EC168_4				0x1001
 #define USB_PID_E3C_EC168_5				0x1002
 #define USB_PID_FREECOM_DVBT				0x0160
+#define USB_PID_FREECOM_DVBT_2				0x0161
 #define USB_PID_UNIWILL_STK7700P			0x6003
 #define USB_PID_GENIUS_TVGO_DVB_T03			0x4012
 #define USB_PID_GRANDTEC_DVBT_USB_COLD			0x0fa0
diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
index 548e3ee..5124231 100644
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
@@ -767,6 +767,7 @@ err:
 enum rtl28xxu_usb_table_entry {
 	RTL2831U_0BDA_2831,
 	RTL2831U_14AA_0160,
+	RTL2831U_14AA_0161,
 };

 static struct usb_device_id rtl28xxu_table[] = {
@@ -775,6 +776,8 @@ static struct usb_device_id rtl28xxu_table[] = {
 		USB_DEVICE(USB_VID_REALTEK, USB_PID_REALTEK_RTL2831U)},
 	[RTL2831U_14AA_0160] = {
 		USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT)},
+	[RTL2831U_14AA_0161] = {
+		USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT_2)},

 	/* RTL2832U */
 	{} /* terminating entry */
@@ -840,6 +843,7 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 				.name = "Freecom USB2.0 DVB-T",
 				.warm_ids = {
 					&rtl28xxu_table[RTL2831U_14AA_0160],
+					&rtl28xxu_table[RTL2831U_14AA_0161],
 				},
 			},
 		}
--

