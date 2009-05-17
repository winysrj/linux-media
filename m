Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110811.mail.gq1.yahoo.com ([67.195.13.234]:20263 "HELO
	web110811.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751511AbZEQM2y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 08:28:54 -0400
Message-ID: <887792.5451.qm@web110811.mail.gq1.yahoo.com>
Date: Sun, 17 May 2009 05:28:55 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_31] Siano: smsusb - change exit func debug msg
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242563388 -10800
# Node ID c09c5b8b253e4a74b9a32ce8db30d35d143dedfa
# Parent  7d204069642b6608bb3b0d6a96d1de5848df2a16
[0905_31] Siano: smsusb - change exit func debug msg

From: Uri Shkolnik <uris@siano-ms.com>

Change the debug message of the USB interface driver exit
function.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 7d204069642b -r c09c5b8b253e linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Sun May 17 15:21:15 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Sun May 17 15:29:48 2009 +0300
@@ -561,9 +561,9 @@ int smsusb_module_init(void)
 
 void smsusb_module_exit(void)
 {
-	sms_debug("");
 	/* Regular USB Cleanup */
 	usb_deregister(&smsusb_driver);
+	sms_info("end");
 }
 
 module_init(smsusb_module_init);



      
