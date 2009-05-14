Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110806.mail.gq1.yahoo.com ([67.195.13.229]:33649 "HELO
	web110806.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752164AbZENTaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 15:30:15 -0400
Message-ID: <281154.25774.qm@web110806.mail.gq1.yahoo.com>
Date: Thu, 14 May 2009 12:30:16 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_15] Siano: smscards - add two more targets
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242325845 -10800
# Node ID 0f7ae5e8b09ff516f35f299e81aacbba237ba038
# Parent  fe5ecbb828340406923d06b4ea93a210aafb5c7e
[0905_15] Siano: smscards - add two more targets

From: Uri Shkolnik <uris@siano-ms.com>

Add two more target to the cards, Nice and Venice

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r fe5ecbb82834 -r 0f7ae5e8b09f linux/drivers/media/dvb/siano/sms-cards.c
--- a/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 21:24:26 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 21:30:45 2009 +0300
@@ -60,8 +60,13 @@ struct usb_device_id smsusb_id_table[] =
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
 
 static int sms_dbg;
diff -r fe5ecbb82834 -r 0f7ae5e8b09f linux/drivers/media/dvb/siano/sms-cards.h
--- a/linux/drivers/media/dvb/siano/sms-cards.h	Thu May 14 21:24:26 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.h	Thu May 14 21:30:45 2009 +0300
@@ -34,6 +34,8 @@
 #define SMS1XXX_BOARD_HAUPPAUGE_WINDHAM 8
 #define SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD 9
 #define SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2 10
+#define SMS1XXX_BOARD_SIANO_NICE	11
+#define SMS1XXX_BOARD_SIANO_VENICE	12
 
 struct sms_board {
 	enum sms_device_type_st type;



      
