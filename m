Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110803.mail.gq1.yahoo.com ([67.195.13.226]:44677 "HELO
	web110803.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752060AbZESMvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 08:51:40 -0400
Message-ID: <176275.71324.qm@web110803.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 05:51:41 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_42] Siano: cards - add two additional (USB) devices
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242737787 -10800
# Node ID f8e348f2f312e23c42b263738d555221fba844b2
# Parent  c405857480bae1fa471dedc6fe86c4a897edd696
[09051_42] Siano: cards - add two additional (USB) devices

From: Uri Shkolnik <uris@siano-ms.com>

Add two additional USB targets, add these to the 'cards' modules
and to the 'smsusb' module.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r c405857480ba -r f8e348f2f312 linux/drivers/media/dvb/siano/sms-cards.c
--- a/linux/drivers/media/dvb/siano/sms-cards.c	Tue May 19 15:48:20 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.c	Tue May 19 15:56:27 2009 +0300
@@ -84,6 +84,16 @@ static struct sms_board sms_boards[] = {
 		.type	= SMS_NOVA_B0,
 		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
 		.lna_ctrl  = -1,
+	},
+	[SMS1XXX_BOARD_SIANO_NICE] = {
+	/* 11 */
+		.name = "Siano Nice Digital Receiver",
+		.type = SMS_NOVA_B0,
+	},
+	[SMS1XXX_BOARD_SIANO_VENICE] = {
+	/* 12 */
+		.name = "Siano Venice Digital Receiver",
+		.type = SMS_VEGA,
 	},
 };
 
diff -r c405857480ba -r f8e348f2f312 linux/drivers/media/dvb/siano/sms-cards.h
--- a/linux/drivers/media/dvb/siano/sms-cards.h	Tue May 19 15:48:20 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.h	Tue May 19 15:56:27 2009 +0300
@@ -35,6 +35,8 @@
 #define SMS1XXX_BOARD_HAUPPAUGE_WINDHAM 8
 #define SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD 9
 #define SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2 10
+#define SMS1XXX_BOARD_SIANO_NICE	11
+#define SMS1XXX_BOARD_SIANO_VENICE	12
 
 struct sms_board_gpio_cfg {
 	int lna_vhf_exist;
diff -r c405857480ba -r f8e348f2f312 linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Tue May 19 15:48:20 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Tue May 19 15:56:27 2009 +0300
@@ -531,8 +531,13 @@ struct usb_device_id smsusb_id_table[] =
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



      
