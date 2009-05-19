Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110815.mail.gq1.yahoo.com ([67.195.13.238]:44415 "HELO
	web110815.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751696AbZESPYD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 11:24:03 -0400
Message-ID: <573374.98762.qm@web110815.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 08:24:03 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_46] Siano: smsusb - remove redundant ifdef
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242746858 -10800
# Node ID 98895daafb42f8b0757fd608b29c53c80327520e
# Parent  37df2d513a68b920ba4ceed0220cf6915d2d574e
[09051_46] Siano: smsusb - remove redundant ifdef

From: Uri Shkolnik <uris@siano-ms.com>

Remove a redundant ifdef

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 37df2d513a68 -r 98895daafb42 linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Tue May 19 18:23:41 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Tue May 19 18:27:38 2009 +0300
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



      
