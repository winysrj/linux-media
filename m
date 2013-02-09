Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout06.t-online.de ([194.25.134.19]:56469 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab3BIT4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 14:56:35 -0500
Message-ID: <5116A9E7.9050009@t-online.de>
Date: Sat, 09 Feb 2013 20:56:23 +0100
From: Christoph Nuscheler <christoph.nuscheler@t-online.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] media: Add 0x3009 USB PID to ttusb2 driver (fixed diff)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry about the mess in my last message; this time diff output should be 
formatted correctly.

The "Technisat SkyStar USB plus" is a TT-connect S-2400 clone, which the 
V4L-DVB drivers already support. However, some of these devices (like 
mine) come with a different USB PID 0x3009 instead of 0x3006.

There have already been patches simply overwriting the USB PID in 
dvb-usb-ids.h. Of course these patches were rejected because they would 
have disabled the 0x3006 PID.

This new patch adds the 0x3009 PID to dvb-usb-ids.h, and adds references 
to it within the ttusb2.c driver. PID 0x3006 devices will continue to work.

The only difference between the two hardware models seems to be the 
EEPROM chip. In fact, Windows BDA driver names the 0x3009 device with a 
"(8 kB EEPROM)" suffix. In spite of that, the 0x3009 device works 
absolutely flawlessly using the existing ttusb2 driver.

Signed-off-by: Christoph Nuscheler <christoph.nuscheler@t-online.de>

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h 
b/drivers/media/dvb-core/dvb-usb-ids.h
index 7e1597d..399e104 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -242,6 +242,7 @@
  #define USB_PID_AVERMEDIA_A867				0xa867
  #define USB_PID_AVERMEDIA_TWINSTAR			0x0825
  #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
+#define USB_PID_TECHNOTREND_CONNECT_S2400_8KEEPROM	0x3009
  #define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
  #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
  #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2	0x0081
diff --git a/drivers/media/usb/dvb-usb/ttusb2.c 
b/drivers/media/usb/dvb-usb/ttusb2.c
index bcdac22..07d4994 100644
--- a/drivers/media/usb/dvb-usb/ttusb2.c
+++ b/drivers/media/usb/dvb-usb/ttusb2.c
@@ -619,6 +619,8 @@ static struct usb_device_id ttusb2_table [] = {
  	{ USB_DEVICE(USB_VID_TECHNOTREND,
  		USB_PID_TECHNOTREND_CONNECT_S2400) },
  	{ USB_DEVICE(USB_VID_TECHNOTREND,
+		USB_PID_TECHNOTREND_CONNECT_S2400_8KEEPROM) },
+	{ USB_DEVICE(USB_VID_TECHNOTREND,
  		USB_PID_TECHNOTREND_CONNECT_CT3650) },
  	{}		/* Terminating entry */
  };
@@ -721,12 +723,16 @@ static struct dvb_usb_device_properties 
ttusb2_properties_s2400 = {

  	.generic_bulk_ctrl_endpoint = 0x01,

-	.num_device_descs = 1,
+	.num_device_descs = 2,
  	.devices = {
  		{   "Technotrend TT-connect S-2400",
  			{ &ttusb2_table[2], NULL },
  			{ NULL },
  		},
+		{   "Technotrend TT-connect S-2400 (8kB EEPROM)",
+			{&ttusb2_table[3], NULL },
+			{ NULL },
+		},
  	}
  };

@@ -800,7 +806,7 @@ static struct dvb_usb_device_properties 
ttusb2_properties_ct3650 = {
  	.num_device_descs = 1,
  	.devices = {
  		{   "Technotrend TT-connect CT-3650",
-			.warm_ids = { &ttusb2_table[3], NULL },
+			.warm_ids = { &ttusb2_table[4], NULL },
  		},
  	}
  };

