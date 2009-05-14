Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110804.mail.gq1.yahoo.com ([67.195.13.227]:35074 "HELO
	web110804.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752623AbZENTcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 15:32:48 -0400
Message-ID: <525880.36699.qm@web110804.mail.gq1.yahoo.com>
Date: Thu, 14 May 2009 12:32:49 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_18] Siano: IR - add SMS IR protocol
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242327653 -10800
# Node ID fdfd103426e8aeabb18aaa1e117238e3ca450d0e
# Parent  438275c8cf1084ed8983b084a8d4d7ef03c05022
[0905_18] Siano: IR - add SMS IR protocol

From: Uri Shkolnik <uris@siano-ms.com>

Add the SMS Infra-red protocol handling to the core component.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 438275c8cf10 -r fdfd103426e8 linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Thu May 14 21:50:12 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Thu May 14 22:00:53 2009 +0300
@@ -34,6 +34,7 @@
 #include "smscoreapi.h"
 #include "smsendian.h"
 #include "sms-cards.h"
+#include "smsir.h"
 
 static int sms_dbg;
 module_param_named(debug, sms_dbg, int, 0644);
@@ -349,6 +350,7 @@ int smscore_register_device(struct smsde
 	init_completion(&dev->init_device_done);
 	init_completion(&dev->reload_start_done);
 	init_completion(&dev->resume_done);
+	init_completion(&dev->ir_init_done);
 
 	/* alloc common buffer */
 	dev->common_buffer_size = params->buffer_size * params->num_buffers;
@@ -404,6 +406,71 @@ int smscore_register_device(struct smsde
 }
 EXPORT_SYMBOL_GPL(smscore_register_device);
 
+
+static int smscore_sendrequest_and_wait(struct smscore_device_t *coredev,
+		void *buffer, size_t size, struct completion *completion) {
+	int rc = coredev->sendrequest_handler(coredev->context, buffer, size);
+	if (rc < 0) {
+		sms_info("sendrequest returned error %d", rc);
+		return rc;
+	}
+
+	return wait_for_completion_timeout(completion,
+			msecs_to_jiffies(SMS_PROTOCOL_MAX_RAOUNDTRIP_MS)) ?
+			0 : -ETIME;
+}
+
+/**
+ * Starts & enables IR operations
+ *
+ * @return 0 on success, < 0 on error.
+ */
+static int smscore_init_ir(struct smscore_device_t *coredev)
+{
+	int ir_io;
+	int rc;
+	void *buffer;
+
+	coredev->ir.input_dev = NULL;
+	ir_io = sms_get_board(smscore_get_board_id(coredev))->board_cfg.ir;
+	if (ir_io) {/* only if IR port exist we use IR sub-module */
+		sms_info("IR loading");
+		rc = sms_ir_init(coredev);
+
+		if	(rc != 0)
+			sms_err("Error initialization DTV IR sub-module");
+		else {
+			buffer = kmalloc(sizeof(struct SmsMsgData_ST2) +
+						SMS_DMA_ALIGNMENT,
+						GFP_KERNEL | GFP_DMA);
+			if (buffer) {
+				struct SmsMsgData_ST2 *msg =
+				(struct SmsMsgData_ST2 *)
+				SMS_ALIGN_ADDRESS(buffer);
+
+				SMS_INIT_MSG(&msg->xMsgHeader,
+						MSG_SMS_START_IR_REQ,
+						sizeof(struct SmsMsgData_ST2));
+				msg->msgData[0] = coredev->ir.controller;
+				msg->msgData[1] = coredev->ir.timeout;
+
+				smsendian_handle_tx_message(
+					(struct SmsMsgHdr_ST2 *)msg);
+				rc = smscore_sendrequest_and_wait(coredev, msg,
+						msg->xMsgHeader. msgLength,
+						&coredev->ir_init_done);
+
+				kfree(buffer);
+			} else
+				sms_err
+				("Sending IR initialization message failed");
+		}
+	} else
+		sms_info("IR port has not been detected");
+
+	return 0;
+}
+
 /**
  * sets initial device mode and notifies client hotplugs that device is ready
  *
@@ -424,6 +491,7 @@ int smscore_start_device(struct smscore_
 	kmutex_lock(&g_smscore_deviceslock);
 
 	rc = smscore_notify_callbacks(coredev, coredev->device, 1);
+	smscore_init_ir(coredev);
 
 	sms_info("device %p started, rc %d", coredev, rc);
 
@@ -433,20 +501,6 @@ int smscore_start_device(struct smscore_
 }
 EXPORT_SYMBOL_GPL(smscore_start_device);
 
-static int smscore_sendrequest_and_wait(struct smscore_device_t *coredev,
-					void *buffer, size_t size,
-					struct completion *completion)
-{
-	int rc = coredev->sendrequest_handler(coredev->context, buffer, size);
-	if (rc < 0) {
-		sms_info("sendrequest returned error %d", rc);
-		return rc;
-	}
-
-	return wait_for_completion_timeout(completion,
-					   msecs_to_jiffies(10000)) ?
-						0 : -ETIME;
-}
 
 static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 					 void *buffer, size_t size)
@@ -624,6 +678,9 @@ void smscore_unregister_device(struct sm
 	int retry = 0;
 
 	kmutex_lock(&g_smscore_deviceslock);
+
+	/* Release input device (IR) resources */
+	sms_ir_exit(coredev);
 
 	smscore_notify_clients(coredev);
 	smscore_notify_callbacks(coredev, NULL, 0);
@@ -988,6 +1045,18 @@ void smscore_onresponse(struct smscore_d
 		case MSG_SMS_SLEEP_RESUME_COMP_IND:
 			complete(&coredev->resume_done);
 			break;
+		case MSG_SMS_START_IR_RES:
+			complete(&coredev->ir_init_done);
+			break;
+		case MSG_SMS_IR_SAMPLES_IND:
+			sms_ir_event(coredev,
+				(const char *)
+				((char *)phdr
+				+ sizeof(struct SmsMsgHdr_ST)),
+				(int)phdr->msgLength
+				- sizeof(struct SmsMsgHdr_ST));
+			break;
+
 		default:
 #if 0
 			sms_info("no client (%p) or error (%d), "



      
