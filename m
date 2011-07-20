Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo13.poczta.onet.pl ([213.180.142.144]:42133 "EHLO
	smtpo13.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1GTUgE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2011 16:36:04 -0400
Received: from [10.2.240.219] (242.132.246.94.ip4.artcom.pl [94.246.132.242])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: chmooreck@poczta.onet.pl)
	by smtp.poczta.onet.pl (Onet) with ESMTPSA id 9DC6820262A93
	for <linux-media@vger.kernel.org>; Wed, 20 Jul 2011 22:29:45 +0200 (CEST)
Message-ID: <4E273AB5.7090405@poczta.onet.pl>
Date: Wed, 20 Jul 2011 22:29:41 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] dvb/as102 nBox DVB-T dongle
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just bought DVB-T USB dongle for one of polish digital platform. It 
works fine with as102 driver.
Here is patch adding vendor and product ID to as102 driver taken from 
http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102.
I tested it with kernel-3.0-rc7-git7 (had to change usb_buffer_alloc() 
to usb_alloc_coherent and usb_buffer_free to usb_free_coherent() ).

patch:

diff -Nur linux/drivers/media/dvb/as102/as102_usb_drv.c 
linux-mine/drivers/media/dvb/as102/as102_usb_drv.c
--- as102/as102_usb_drv.c    2011-07-20 21:37:33.924143297 +0200
+++ /usr/src/linux/drivers/media/dvb/as102/as102_usb_drv.c    2011-07-20 
20:40:21.000000000 +0200
@@ -39,6 +39,7 @@
  static struct usb_device_id as102_usb_id_table[] = {
      { USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001) },
      { USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
+    { USB_DEVICE(NBOX_USB_VID, NBOX_USB_PID) },
      { USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
      { } /* Terminating entry */
  };
@@ -48,6 +49,7 @@
  static const char *as102_device_names[] = {
      AS102_REFERENCE_DESIGN,
      AS102_PCTV_74E,
+    AS102_NBOX,
      AS102_ELGATO_EYETV_DTT_NAME,
      NULL /* Terminating entry */
  };
diff -Nur linux/drivers/media/dvb/as102/as102_usb_drv.h 
linux-mine/drivers/media/dvb/as102/as102_usb_drv.h
--- as102/as102_usb_drv.h    2011-07-20 21:37:33.925143297 +0200
+++ /usr/src/linux/drivers/media/dvb/as102/as102_usb_drv.h    2011-07-20 
20:39:46.000000000 +0200
@@ -36,6 +36,11 @@
  #define PCTV_74E_USB_VID        0x2013
  #define PCTV_74E_USB_PID        0x0246

+/* nBox DVB-T Stick */
+#define AS102_NBOX            "nBox DVB-T Stick"
+#define NBOX_USB_VID            0x0b89
+#define NBOX_USB_PID            0x0007
+
  /* Elgato: EyeTV DTT Deluxe */
  #define AS102_ELGATO_EYETV_DTT_NAME    "Elgato EyeTV DTT Deluxe"
  #define ELGATO_EYETV_DTT_USB_VID    0x0fd9


