Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110811.mail.gq1.yahoo.com ([67.195.13.234]:23304 "HELO
	web110811.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752748AbZESPeI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 11:34:08 -0400
Message-ID: <763416.19374.qm@web110811.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 08:34:09 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_48] Siano: smscore - remove redundant code
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242747487 -10800
# Node ID cfb4106f3ceaee9fe8f7e3acc9d4adec1baffe5e
# Parent  971d4cc0d4009650bd4752c6a9fc09755ef77baf
[09051_48] Siano: smscore - remove redundant code

From: Uri Shkolnik <uris@siano-ms.com>

remove redundant code, which in the past handled the
various components (now independent modules) registrations.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 971d4cc0d400 -r cfb4106f3cea linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Tue May 19 18:32:44 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Tue May 19 18:38:07 2009 +0300
@@ -1645,99 +1645,11 @@ static int __init smscore_module_init(vo
 	INIT_LIST_HEAD(&g_smscore_registry);
 	kmutex_init(&g_smscore_registrylock);
 
-#if 0 /* def SMS_CHAR_CLIENT */
-	/* Char interface Register */
-	rc = smschar_register();
-	if (rc) {
-		sms_err("Error registering char device client.\n");
-		goto smschar_error;
-	}
-#endif
-
-#if 0 /* def SMS_DVB_CLIENT */
-	/* DVB Register */
-	rc = smsdvb_register();
-	if (rc) {
-		sms_err("Error registering DVB client.\n");
-		goto smsdvb_error;
-	}
-#endif
-
-#if 0 /* def SMS_NET_CLIENT */
-	/* DVB Register */
-	rc = smsnet_register();
-	if (rc) {
-		sms_err("Error registering Network client.\n");
-		goto smsnet_error;
-	}
-#endif
-
-#if 0 /* def SMS_USB_BUS_DRV */
-	/* USB Register */
-	rc = smsusb_register();
-	if (rc) {
-		sms_err("Error registering USB bus driver.\n");
-		goto sms_bus_drv_error;
-	}
-#endif
-
-#if 0 /* def SMS_SPI_BUS_DRV */
-	/* USB Register */
-	rc = smsspi_register();
-	if (rc) {
-		sms_err("Error registering spi bus driver.\n");
-		goto sms_bus_drv_error;
-	}
-#endif
-
-	return rc;
-#if 0
-sms_bus_drv_error:
-#endif /* 0 */
-#if 0 /* def SMS_NET_CLIENT */
-	smsnet_unregister();
-smsnet_error:
-#endif
-#if 0 /* def SMS_DVB_CLIENT */
-	smsdvb_unregister();
-smsdvb_error:
-#endif
-#if 0 /* def SMS_CHAR_CLIENT */
-	smschar_unregister();
-smschar_error:
-#endif
-	sms_debug("rc %d", rc);
-
 	return rc;
 }
 
 static void __exit smscore_module_exit(void)
 {
-#if 0 /* def SMS_CHAR_CLIENT */
-	/* Char interface UnRegister */
-	smschar_unregister();
-#endif
-
-#if 0 /* def SMS_DVB_CLIENT */
-	/* DVB UnRegister */
-	smsdvb_unregister();
-#endif
-
-#if 0 /* def SMS_NET_CLIENT */
-	/* NET UnRegister */
-	smsnet_unregister();
-#endif
-
-#if 0 /* def SMS_USB_BUS_DRV */
-	/* Unregister USB */
-	smsusb_unregister();
-#endif
-
-#if 0 /* def SMS_SPI_BUS_DRV */
-	/* Unregister SPI */
-	smsspi_unregister();
-#endif
-
 	kmutex_lock(&g_smscore_deviceslock);
 	while (!list_empty(&g_smscore_notifyees)) {
 		struct smscore_device_notifyee_t *notifyee =



      
