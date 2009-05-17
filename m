Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110811.mail.gq1.yahoo.com ([67.195.13.234]:33071 "HELO
	web110811.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751580AbZEQI4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 04:56:31 -0400
Message-ID: <7723.19682.qm@web110811.mail.gq1.yahoo.com>
Date: Sun, 17 May 2009 01:56:31 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_14_1] Siano: smsusb - update supported USB IDs table
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242550293 -10800
# Node ID 59a05f4cb2769279a460f171250d3a7d3a85b81f
# Parent  12d6b7eaffa903f00c445d7102ded42610361ae6
[0905_14_1] Siano: smsusb - update supported USB IDs table

From: Uri Shkolnik <uris@siano-ms.com>

Update the list of supported USB devices, with IDs of
new devices, and remove the obsolete defines

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 12d6b7eaffa9 -r 59a05f4cb276 linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Sun May 17 11:49:44 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Sun May 17 11:51:33 2009 +0300
@@ -489,7 +489,6 @@ static int smsusb_resume(struct usb_inte
 }
 
 struct usb_device_id smsusb_id_table[] = {
-#ifdef CONFIG_DVB_SIANO_SMS1XXX_SMS_IDS
 	{ USB_DEVICE(0x187f, 0x0010),
 		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
 	{ USB_DEVICE(0x187f, 0x0100),
@@ -500,7 +499,6 @@ struct usb_device_id smsusb_id_table[] =
 		.driver_info = SMS1XXX_BOARD_SIANO_NOVA_B },
 	{ USB_DEVICE(0x187f, 0x0300),
 		.driver_info = SMS1XXX_BOARD_SIANO_VEGA },
-#endif
 	{ USB_DEVICE(0x2040, 0x1700),
 		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT },
 	{ USB_DEVICE(0x2040, 0x1800),
@@ -531,8 +529,13 @@ struct usb_device_id smsusb_id_table[] =
 		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
 	{ USB_DEVICE(0x2040, 0x5590),
 		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
-	{ }		/* Terminating entry */
-};
+	{ USB_DEVICE(0x187f, 0x0202),
+		.driver_info = SMS1XXX_BOARD_SIANO_NICE },
+	{ USB_DEVICE(0x187f, 0x0301),
+		.driver_info = SMS1XXX_BOARD_SIANO_VENICE },
+	{ } /* Terminating entry */
+	};
+
 MODULE_DEVICE_TABLE(usb, smsusb_id_table);
 
 static struct usb_driver smsusb_driver = {



      
