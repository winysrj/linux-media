Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:6291 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932094Ab1ITKSw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 06:18:52 -0400
Subject: [PATCH 11/17]DVB:Siano drivers - Improve debug capabilities - add
 and change debug prints
From: Doron Cohen <doronc@siano-ms.com>
Reply-To: doronc@siano-ms.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Sep 2011 13:31:34 +0300
Message-ID: <1316514694.5199.89.camel@Doron-Ubuntu>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,
This patch Improve debug capabilities - add and change debug prints.
Thanks,
Doron Cohen

--------------


>From 33055c84a25faa1bde70a8417c2138381f49f498 Mon Sep 17 00:00:00 2001
From: Doron Cohen <doronc@siano-ms.com>
Date: Tue, 20 Sep 2011 08:05:35 +0300
Subject: [PATCH 15/21] Improve debug capabilities - add and change debug
prints

---
 drivers/media/dvb/siano/smscoreapi.c |   91
++++++++++++++++++++++++++-------
 1 files changed, 71 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb/siano/smscoreapi.c
b/drivers/media/dvb/siano/smscoreapi.c
index 9738bad..db24391 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -42,8 +42,10 @@
 #include "smsendian.h"
 
 #define MAX_GPIO_PIN_NUMBER	31
+static struct smsmdtv_version_t version =
{MAJOR_VERSION,MINOR_VERSION,SUB_VERSION};
 
 int sms_debug;
+module_param_named(debug, sms_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
 
 struct smscore_device_notifyee_t {
@@ -415,7 +417,7 @@ int smscore_register_device(struct
smsdevice_params_t *params,
 
 	*coredev = dev;
 
-	sms_info("device %p created", dev);
+	sms_info("core device 0x%p created, mode %d, type %d devpath %s", dev,
dev->mode, params->device_type, dev->devpath);
 
 	return 0;
 }
@@ -499,7 +501,7 @@ int smscore_start_device(struct smscore_device_t
*coredev)
 	int rc = smscore_set_device_mode(
 			coredev, smscore_registry_getmode(coredev->devpath));
 	if (rc < 0) {
-		sms_info("set device mode faile , rc %d", rc);
+		sms_info("configure board failed , rc %d", rc);
 		return rc;
 	}
 
@@ -510,7 +512,7 @@ int smscore_start_device(struct smscore_device_t
*coredev)
 	smscore_init_ir(coredev);
 #endif /*SMS_RC_SUPPORT_SUBSYS*/
 
-	sms_info("device %p started, rc %d", coredev, rc);
+	sms_info("device 0x%p started, rc %d", coredev, rc);
 
 	kmutex_unlock(&g_smscore_deviceslock);
 
@@ -519,6 +521,15 @@ int smscore_start_device(struct smscore_device_t
*coredev)
 EXPORT_SYMBOL_GPL(smscore_start_device);
 
 
+/**
+ * injects firmware from a buffer to the device using data messages
+ * 
+ * @param coredev pointer to a coredev object returned by
+ * 		  smscore_register_device
+ * @param buffer pointer to a firmware buffer
+ * @param size size (in bytes) of the firmware buffer
+ * @return 0 on success, <0 on error.
+ */
 static int smscore_load_firmware_family2(struct smscore_device_t
*coredev,
 					 void *buffer, size_t size)
 {
@@ -625,8 +636,7 @@ static int smscore_load_firmware_family2(struct
smscore_device_t *coredev,
 	kfree(msg);
 
 	return ((rc >= 0) && coredev->postload_handler) ?
-		coredev->postload_handler(coredev->context) :
-		rc;
+			coredev->postload_handler(coredev->context) : rc;
 }
 
 /**
@@ -634,6 +644,9 @@ static int smscore_load_firmware_family2(struct
smscore_device_t *coredev,
  *
  * @param coredev pointer to a coredev object returned by
  *                smscore_register_device
+ * @param mode requested mode of operation
+ * @param lookup if 1, always get the fw filename from smscore_fw_lkup 
+ * 	  table. if 0, try first to get from sms_boards
  * @param filename null-terminated string specifies firmware file name
  * @param loadfirmware_handler device handler that loads firmware
  *
@@ -741,7 +754,7 @@ void smscore_unregister_device(struct
smscore_device_t *coredev)
 
 	kmutex_unlock(&g_smscore_deviceslock);
 
-	sms_info("device %p destroyed", coredev);
+	sms_info("device 0x%p destroyed", coredev);
 }
 EXPORT_SYMBOL_GPL(smscore_unregister_device);
 
@@ -761,6 +774,11 @@ static int smscore_detect_mode(struct
smscore_device_t *coredev)
 
 	rc = smscore_sendrequest_and_wait(coredev, msg, msg->msgLength,
 					  &coredev->version_ex_done);
+
+	if (rc < 0) {
+		sms_err("detect mode failed, rc %d", rc);
+	}
+
 	if (rc == -ETIME) {
 		sms_err("MSG_SMS_GET_VERSION_EX_REQ failed first try");
 
@@ -855,7 +873,7 @@ int smscore_set_device_mode(struct smscore_device_t
*coredev, int mode)
 			rc = smscore_load_firmware_from_file(coredev,
 							     fw_filename, NULL);
 			if (rc < 0) {
-				sms_warn("error %d loading firmware: %s, "
+				sms_debug("error %d loading firmware: %s, "
 					 "trying again with default firmware",
 					 rc, fw_filename);
 
@@ -865,9 +883,7 @@ int smscore_set_device_mode(struct smscore_device_t
*coredev, int mode)
 							     fw_filename, NULL);
 
 				if (rc < 0) {
-					sms_warn("error %d loading "
-						 "firmware: %s", rc,
-						 fw_filename);
+				        sms_debug("error %d loading firmware", rc);
 					return rc;
 				}
 			}
@@ -909,8 +925,13 @@ int smscore_set_device_mode(struct smscore_device_t
*coredev, int mode)
 			coredev->detectmode_handler(coredev->context,
 						    &coredev->mode);
 
-		if (coredev->mode != mode && coredev->setmode_handler)
+		if (coredev->mode != mode && coredev->setmode_handler) {
 			rc = coredev->setmode_handler(coredev->context, mode);
+
+			if (rc < 0) {
+				sms_err("return error code %d.", rc);
+			}
+		}
 	}
 
 	if (rc >= 0) {
@@ -1027,14 +1048,35 @@ void smscore_onresponse(struct smscore_device_t
*coredev,
 
 	if (rc < 0) {
 		switch (phdr->msgType) {
-		case MSG_SMS_GET_VERSION_EX_RES:
-		{
-			struct SmsVersionRes_S *ver =
-				(struct SmsVersionRes_S *) phdr;
+		case MSG_SMS_ISDBT_TUNE_RES:
+			sms_debug("MSG_SMS_ISDBT_TUNE_RES");
+			break;
+		case MSG_SMS_RF_TUNE_RES:
+			sms_debug("MSG_SMS_RF_TUNE_RES");
+			break;
+		case MSG_SMS_SIGNAL_DETECTED_IND:
+			sms_debug("MSG_SMS_SIGNAL_DETECTED_IND");
+			break;
+		case MSG_SMS_NO_SIGNAL_IND:
+			sms_debug("MSG_SMS_NO_SIGNAL_IND");
+			break;
+		case MSG_SMS_SPI_INT_LINE_SET_RES:
+			sms_debug("MSG_SMS_SPI_INT_LINE_SET_RES");
+			break;
+		case MSG_SMS_INTERFACE_LOCK_IND: 
+			sms_debug("MSG_SMS_INTERFACE_LOCK_IND");
+			break;
+		case MSG_SMS_INTERFACE_UNLOCK_IND:
+			sms_debug("MSG_SMS_INTERFACE_UNLOCK_IND");
+			break;
+		case MSG_SMS_GET_VERSION_EX_RES: {
+			struct SmsVersionRes_S *ver = (struct SmsVersionRes_S *)phdr;
 			sms_debug("MSG_SMS_GET_VERSION_EX_RES "
 				  "id %d prots 0x%x ver %d.%d",
-				  ver->xVersion.FirmwareId, ver->xVersion.SupportedProtocols,
-				  ver->xVersion.RomVer.Major, ver->xVersion.RomVer.Minor);
+					ver->xVersion.FirmwareId,
+					ver->xVersion.SupportedProtocols,
+					ver->xVersion.RomVer.Major,
+					ver->xVersion.RomVer.Minor);
 
 			coredev->mode = ver->xVersion.FirmwareId == 255 ?
 				SMSHOSTLIB_DEVMD_NONE : ver->xVersion.FirmwareId;
@@ -1062,6 +1104,7 @@ void smscore_onresponse(struct smscore_device_t
*coredev,
 			complete(&coredev->trigger_done);
 			break;
 		case MSG_SMS_SLEEP_RESUME_COMP_IND:
+			sms_debug("MSG_SMS_SLEEP_RESUME_COMP_IND");
 			complete(&coredev->resume_done);
 			break;
 		case MSG_SMS_GPIO_CONFIG_EX_RES:
@@ -1223,8 +1266,8 @@ int smscore_register_client(struct
smscore_device_t *coredev,
 	smscore_validate_client(coredev, newclient, params->data_type,
 				params->initial_id);
 	*client = newclient;
-	sms_debug("%p %d %d", params->context, params->data_type,
-		  params->initial_id);
+	sms_debug("register new client 0x%p DT=%d ID=%d",
+		params->context, params->data_type, params->initial_id);
 
 	return 0;
 }
@@ -1540,6 +1583,13 @@ static int __init smscore_module_init(void)
 {
 	int rc = 0;
 
+	sms_info("");
+	sms_info("smsmdtv register, version %d.%d.%d",
+		version.major, version.minor, version.revision);
+	/* 
+	 * first, create global core device global linked lists
+	 */
+
 	INIT_LIST_HEAD(&g_smscore_notifyees);
 	INIT_LIST_HEAD(&g_smscore_devices);
 	kmutex_init(&g_smscore_deviceslock);
@@ -1552,6 +1602,7 @@ static int __init smscore_module_init(void)
 
 static void __exit smscore_module_exit(void)
 {
+	sms_info("");
 	kmutex_lock(&g_smscore_deviceslock);
 	while (!list_empty(&g_smscore_notifyees)) {
 		struct smscore_device_notifyee_t *notifyee =
@@ -1574,7 +1625,7 @@ static void __exit smscore_module_exit(void)
 	}
 	kmutex_unlock(&g_smscore_registrylock);
 
-	sms_debug("");
+	sms_info("smsmdtv unregistered\n");
 }
 
 module_init(smscore_module_init);
-- 
1.7.4.1

