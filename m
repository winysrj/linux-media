Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110811.mail.gq1.yahoo.com ([67.195.13.234]:28956 "HELO
	web110811.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752380AbZESPni (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 11:43:38 -0400
Message-ID: <886732.24607.qm@web110811.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 08:43:38 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_49] Siano: smscore - upgrade firmware loading engine
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242748115 -10800
# Node ID 4d75f9d1c4f96d65a8ad312c21e488a212ee58a3
# Parent  cfb4106f3ceaee9fe8f7e3acc9d4adec1baffe5e
[09051_49] Siano: smscore - upgrade firmware loading engine

From: Uri Shkolnik <uris@siano-ms.com>

Upgrade the firmware loading (download and switching) engine.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r cfb4106f3cea -r 4d75f9d1c4f9 linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Tue May 19 18:38:07 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Tue May 19 18:48:35 2009 +0300
@@ -28,7 +28,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/io.h>
-
+#include <linux/uaccess.h>
 #include <linux/firmware.h>
 #include <linux/wait.h>
 #include <asm/byteorder.h>
@@ -36,7 +36,13 @@
 #include "smscoreapi.h"
 #include "sms-cards.h"
 #include "smsir.h"
-#include "smsendian.h"
+#define MAX_GPIO_PIN_NUMBER	31
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 10)
+#define REQUEST_FIRMWARE_SUPPORTED
+#else
+#define DEFAULT_FW_FILE_PATH "/lib/firmware"
+#endif
 
 static int sms_dbg;
 module_param_named(debug, sms_dbg, int, 0644);
@@ -459,8 +465,6 @@ static int smscore_init_ir(struct smscor
 				msg->msgData[0] = coredev->ir.controller;
 				msg->msgData[1] = coredev->ir.timeout;
 
-				smsendian_handle_tx_message(
-					(struct SmsMsgHdr_ST2 *)msg);
 				rc = smscore_sendrequest_and_wait(coredev, msg,
 						msg->xMsgHeader. msgLength,
 						&coredev->ir_init_done);
@@ -486,12 +490,16 @@ static int smscore_init_ir(struct smscor
  */
 int smscore_start_device(struct smscore_device_t *coredev)
 {
-	int rc = smscore_set_device_mode(
-			coredev, smscore_registry_getmode(coredev->devpath));
+	int rc;
+
+#ifdef REQUEST_FIRMWARE_SUPPORTED
+	rc = smscore_set_device_mode(coredev, smscore_registry_getmode(
+			coredev->devpath));
 	if (rc < 0) {
-		sms_info("set device mode faile , rc %d", rc);
+		sms_info("set device mode failed , rc %d", rc);
 		return rc;
 	}
+#endif
 
 	kmutex_lock(&g_smscore_deviceslock);
 
@@ -632,11 +640,14 @@ static int smscore_load_firmware_from_fi
 					   loadfirmware_t loadfirmware_handler)
 {
 	int rc = -ENOENT;
+	u8 *fw_buf;
+	u32 fw_buf_size;
+
+#ifdef REQUEST_FIRMWARE_SUPPORTED
 	const struct firmware *fw;
-	u8 *fw_buffer;
 
-	if (loadfirmware_handler == NULL && !(coredev->device_flags &
-					      SMS_DEVICE_FAMILY2))
+	if (loadfirmware_handler == NULL && !(coredev->device_flags
+			& SMS_DEVICE_FAMILY2))
 		return -EINVAL;
 
 	rc = request_firmware(&fw, filename, coredev->device);
@@ -645,26 +656,36 @@ static int smscore_load_firmware_from_fi
 		return rc;
 	}
 	sms_info("read FW %s, size=%zd", filename, fw->size);
-	fw_buffer = kmalloc(ALIGN(fw->size, SMS_ALLOC_ALIGNMENT),
-			    GFP_KERNEL | GFP_DMA);
-	if (fw_buffer) {
-		memcpy(fw_buffer, fw->data, fw->size);
+	fw_buf = kmalloc(ALIGN(fw->size, SMS_ALLOC_ALIGNMENT),
+				GFP_KERNEL | GFP_DMA);
+	if (!fw_buf) {
+		sms_info("failed to allocate firmware buffer");
+		return -ENOMEM;
+	}
+	memcpy(fw_buf, fw->data, fw->size);
+	fw_buf_size = fw->size;
+#else
+	if (!coredev->fw_buf) {
+		sms_info("missing fw file buffer");
+		return -EINVAL;
+	}
+	fw_buf = coredev->fw_buf;
+	fw_buf_size = coredev->fw_buf_size;
+#endif
 
-		rc = (coredev->device_flags & SMS_DEVICE_FAMILY2) ?
-		      smscore_load_firmware_family2(coredev,
-						    fw_buffer,
-						    fw->size) :
-		      loadfirmware_handler(coredev->context,
-					   fw_buffer, fw->size);
+	rc = (coredev->device_flags & SMS_DEVICE_FAMILY2) ?
+		smscore_load_firmware_family2(coredev, fw_buf, fw_buf_size)
+		: loadfirmware_handler(coredev->context, fw_buf,
+		fw_buf_size);
 
-		kfree(fw_buffer);
-	} else {
-		sms_info("failed to allocate firmware buffer");
-		rc = -ENOMEM;
-	}
+	kfree(fw_buf);
 
+#ifdef REQUEST_FIRMWARE_SUPPORTED
 	release_firmware(fw);
-
+#else
+	coredev->fw_buf = NULL;
+	coredev->fw_buf_size = 0;
+#endif
 	return rc;
 }
 
@@ -911,6 +932,74 @@ int smscore_set_device_mode(struct smsco
 }
 
 /**
+ * calls device handler to get fw file name
+ *
+ * @param coredev pointer to a coredev object returned by
+ *                smscore_register_device
+ * @param filename pointer to user buffer to fill the file name
+ *
+ * @return 0 on success, <0 on error.
+ */
+int smscore_get_fw_filename(struct smscore_device_t *coredev, int mode,
+		char *filename) {
+	int rc = 0;
+	enum sms_device_type_st type;
+	char tmpname[200];
+
+	type = smscore_registry_gettype(coredev->devpath);
+
+#ifdef REQUEST_FIRMWARE_SUPPORTED
+	/* driver not need file system services */
+	tmpname[0] = '\0';
+#else
+	sprintf(tmpname, "%s/%s", DEFAULT_FW_FILE_PATH,
+			smscore_fw_lkup[mode][type]);
+#endif
+	if (copy_to_user(filename, tmpname, strlen(tmpname) + 1)) {
+		sms_err("Failed copy file path to user buffer\n");
+		return -EFAULT;
+	}
+	return rc;
+}
+
+/**
+ * calls device handler to keep fw buff for later use
+ *
+ * @param coredev pointer to a coredev object returned by
+ *                smscore_register_device
+ * @param ufwbuf  pointer to user fw buffer
+ * @param size    size in bytes of buffer
+ *
+ * @return 0 on success, <0 on error.
+ */
+int smscore_send_fw_file(struct smscore_device_t *coredev, u8 *ufwbuf,
+		int size) {
+	int rc = 0;
+
+	/* free old buffer */
+	if (coredev->fw_buf != NULL) {
+		kfree(coredev->fw_buf);
+		coredev->fw_buf = NULL;
+	}
+
+	coredev->fw_buf = kmalloc(ALIGN(size, SMS_ALLOC_ALIGNMENT), GFP_KERNEL
+			| GFP_DMA);
+	if (!coredev->fw_buf) {
+		sms_err("Failed allocate FW buffer memory\n");
+		return -EFAULT;
+	}
+
+	if (copy_from_user(coredev->fw_buf, ufwbuf, size)) {
+		sms_err("Failed copy FW from user buffer\n");
+		kfree(coredev->fw_buf);
+		return -EFAULT;
+	}
+	coredev->fw_buf_size = size;
+
+	return rc;
+}
+
+/**
  * calls device handler to get current mode of operation
  *
  * @param coredev pointer to a coredev object returned by
@@ -1280,7 +1369,7 @@ int smsclient_sendrequest(struct smscore
 }
 EXPORT_SYMBOL_GPL(smsclient_sendrequest);
 
-#if 0
+#ifdef SMS_HOSTLIB_SUBSYS
 /**
  * return the size of large (common) buffer
  *
@@ -1329,7 +1418,7 @@ static int smscore_map_common_buffer(str
 
 	return 0;
 }
-#endif
+#endif /* SMS_HOSTLIB_SUBSYS */
 
 /* old GPIO managments implementation */
 int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
@@ -1515,7 +1604,6 @@ int smscore_gpio_configure(struct smscor
 		pMsg->msgData[5] = 0;
 	}
 
-	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
 	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
 			&coredev->gpio_configuration_done);
 
@@ -1565,7 +1653,6 @@ int smscore_gpio_set_level(struct smscor
 	pMsg->msgData[1] = NewLevel;
 
 	/* Send message to SMS */
-	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
 	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
 			&coredev->gpio_set_level_done);
 
@@ -1614,7 +1701,6 @@ int smscore_gpio_get_level(struct smscor
 	pMsg->msgData[1] = 0;
 
 	/* Send message to SMS */
-	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
 	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
 			&coredev->gpio_get_level_done);
 



      
