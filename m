Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:6299 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932161Ab1ITKTP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 06:19:15 -0400
Subject: [PATCH  14/17]DVB:Siano drivers -  support platform whcih doesn't
 have request firmware deamon (used in android)
From: Doron Cohen <doronc@siano-ms.com>
Reply-To: doronc@siano-ms.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Sep 2011 13:31:58 +0300
Message-ID: <1316514718.5199.92.camel@Doron-Ubuntu>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
This patch step support platform whcih doesn't have request firmware
deamon (used in android).
Thanks,
Doron Cohen

-----------------------
>From 3e0060fc7cfdbd5844e9a644b6d2927a406cde20 Mon Sep 17 00:00:00 2001
From: Doron Cohen <doronc@siano-ms.com>
Date: Tue, 20 Sep 2011 08:37:43 +0300
Subject: [PATCH 18/21] Support platform which doesn't have
request_firmware deamon. Allow loading firmware from application without
using request_firmware API

---
 drivers/media/dvb/siano/smscoreapi.c |   77
++++++++++++++++++++++++++++++++-
 1 files changed, 74 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/siano/smscoreapi.c
b/drivers/media/dvb/siano/smscoreapi.c
index 459c6e9..bb92351 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -507,12 +507,83 @@ static int smscore_init_ir(struct smscore_device_t
*coredev)
  */
 int smscore_start_device(struct smscore_device_t *coredev)
 {
-	int rc = smscore_set_device_mode(
-			coredev, smscore_registry_getmode(coredev->devpath));
+	int rc = 0;
+	int board_id = smscore_get_board_id(coredev);
+
+#ifdef REQUEST_FIRMWARE_SUPPORTED
+	int mode;
+	int type = sms_get_board(board_id)->type;
+	if (type == SMS_UNKNOWN_TYPE)
+		type = smscore_registry_gettype(coredev->devpath);
+	sms_info ("starting device type %d", type);
+	/*
+	 * first, search operation mode in the registry, with 
+	 * the limitation of type-mode compatability.
+	 * if firmware donload fails, get operation mode from
+	 * sms_boards
+	 * for spi, type = SMS_UNKNOWN_TYPE and board_id = SMS_BOARD_UNKNOWN
+	 * so always default_mode is set
+	 */
+	switch (type) {
+		case SMS_UNKNOWN_TYPE: 
+			mode = default_mode;
+			break;
+		case SMS_STELLAR:
+		case SMS_NOVA_A0:
+		case SMS_NOVA_B0:
+		case SMS_PELE:
+        	case SMS_RIO:
+			mode = smscore_registry_getmode(coredev->devpath);
+			sms_info ("mode for path %s in registry %d", coredev->devpath,
mode);
+			if (mode == SMSHOSTLIB_DEVMD_CMMB)
+				mode = (default_mode == SMSHOSTLIB_DEVMD_CMMB) ?
SMSHOSTLIB_DEVMD_NONE : default_mode;
+			break;	
+        case SMS_DENVER_1530:
+            mode = SMSHOSTLIB_DEVMD_ATSC;
+            break;
+        case SMS_DENVER_2160:
+            mode = SMSHOSTLIB_DEVMD_DAB_TDMB;
+            break;
+        case SMS_VEGA:
+		case SMS_VENICE:
+		case SMS_MING:
+			mode = SMSHOSTLIB_DEVMD_CMMB;
+			break;
+		default:
+			mode = SMSHOSTLIB_DEVMD_NONE;	
+	}
+
+	/* first try */
+	sms_info ("mode after adjustment %d", mode);
+	rc = smscore_set_device_mode(coredev, mode);	
+
+	if (rc < 0) {
+		sms_info("set device mode to %d failed", mode);
+
+		/* 
+		 * don't try again on spi mode, or if the mode from 
+		 * sms_boards is identical to the previous mode
+		 */
+		if ((board_id == SMS_BOARD_UNKNOWN) ||
+		    (mode == sms_get_board(board_id)->default_mode))
+			return -ENOEXEC;
+
+		/* second try */
+		mode = sms_get_board(board_id)->default_mode;
+		rc = smscore_set_device_mode(coredev, mode);	
+		if (rc < 0) {
+			sms_info("set device mode to %d failed", mode);
+			return -ENOEXEC ;
+		}
+	}
+	sms_info("set device mode succeeded");
+	
+	rc = smscore_configure_board(coredev);
 	if (rc < 0) {
 		sms_info("configure board failed , rc %d", rc);
 		return rc;
 	}
+#endif
 
 	kmutex_lock(&g_smscore_deviceslock);
 
@@ -1614,7 +1685,7 @@ void smscore_unregister_client(struct
smscore_client_t *client)
 		kfree(identry);
 	}
 
-	sms_info("%p", client->context);
+	sms_info("unregister client 0x%p", client->context);
 
 	list_del(&client->entry);
 	kfree(client);
-- 
1.7.4.1

