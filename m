Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110806.mail.gq1.yahoo.com ([67.195.13.229]:27189 "HELO
	web110806.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752223AbZESOPC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 10:15:02 -0400
Message-ID: <518988.76052.qm@web110806.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 07:15:01 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_43] Siano: smssdio - revert to stand alone module
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242739840 -10800
# Node ID 08e292f80f37496d8d4b43a542f518196eaa4dc0
# Parent  f8e348f2f312e23c42b263738d555221fba844b2
[09051_43] Siano: smssdio - revert to stand alone module

From: Uri Shkolnik <uris@siano-ms.com>

Make the SDIO interface driver a stand alone module.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r f8e348f2f312 -r 08e292f80f37 linux/drivers/media/dvb/siano/smssdio.c
--- a/linux/drivers/media/dvb/siano/smssdio.c	Tue May 19 15:56:27 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smssdio.c	Tue May 19 16:30:40 2009 +0300
@@ -332,7 +332,7 @@ static struct sdio_driver smssdio_driver
 /* Module functions                                                */
 /*******************************************************************/
 
-int smssdio_register(void)
+int smssdio_module_init(void)
 {
 	int ret = 0;
 
@@ -344,11 +344,14 @@ int smssdio_register(void)
 	return ret;
 }
 
-void smssdio_unregister(void)
+void smssdio_module_exit(void)
 {
 	sdio_unregister_driver(&smssdio_driver);
 }
 
+module_init(smssdio_module_init);
+module_exit(smssdio_module_exit);
+
 MODULE_DESCRIPTION("Siano SMS1xxx SDIO driver");
 MODULE_AUTHOR("Pierre Ossman");
 MODULE_LICENSE("GPL");



      
