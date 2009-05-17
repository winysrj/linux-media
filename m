Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110808.mail.gq1.yahoo.com ([67.195.13.231]:44384 "HELO
	web110808.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751865AbZEQMRv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 08:17:51 -0400
Message-ID: <166097.37467.qm@web110808.mail.gq1.yahoo.com>
Date: Sun, 17 May 2009 05:17:51 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_30] Siano: smsusb - fix typo in module description
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242562875 -10800
# Node ID 7d204069642b6608bb3b0d6a96d1de5848df2a16
# Parent  1c7b6db1a3399ffbb7f9b6758cae6572c24b51ef
[0905_30] Siano: smsusb - fix typo in module description

From: Uri Shkolnik <uris@siano-ms.com>

Fix small typo in the module description

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 1c7b6db1a339 -r 7d204069642b linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Sun May 17 11:57:48 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Sun May 17 15:21:15 2009 +0300
@@ -569,6 +569,6 @@ module_init(smsusb_module_init);
 module_init(smsusb_module_init);
 module_exit(smsusb_module_exit);
 
-MODULE_DESCRIPTION("Driver for the Siano SMS1XXX USB dongle");
+MODULE_DESCRIPTION("Driver for the Siano SMS1xxx USB dongle");
 MODULE_AUTHOR("Siano Mobile Silicon, INC. (uris@siano-ms.com)");
 MODULE_LICENSE("GPL");



      
