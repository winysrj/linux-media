Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483Ab3CSQua (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:30 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 15/46] [media] siano: cleanups at smscoreapi.c
Date: Tue, 19 Mar 2013 13:49:04 -0300
Message-Id: <1363711775-2120-16-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some cleanups at smscoreapi. Most are just CodingStyle.

Also, use kzalloc when allocating a new buffer, as it initializes
the allocated space with zero.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 25 ++++++++++++++++---------
 drivers/media/common/siano/smscoreapi.h |  1 -
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index d5883bb..d928c22 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -490,10 +490,10 @@ static enum sms_device_type_st smscore_registry_gettype(char *devpath)
 	else
 		sms_err("No registry found.");
 
-	return -1;
+	return -EINVAL;
 }
 
-void smscore_registry_setmode(char *devpath, int mode)
+static void smscore_registry_setmode(char *devpath, int mode)
 {
 	struct smscore_registry_entry_t *entry;
 
@@ -633,10 +633,11 @@ static struct
 smscore_buffer_t *smscore_createbuffer(u8 *buffer, void *common_buffer,
 				       dma_addr_t common_buffer_phys)
 {
-	struct smscore_buffer_t *cb =
-		kmalloc(sizeof(struct smscore_buffer_t), GFP_KERNEL);
+	struct smscore_buffer_t *cb;
+
+	cb = kzalloc(sizeof(struct smscore_buffer_t), GFP_KERNEL);
 	if (!cb) {
-		sms_info("kmalloc(...) failed");
+		sms_info("kzalloc(...) failed");
 		return NULL;
 	}
 
@@ -710,9 +711,10 @@ int smscore_register_device(struct smsdevice_params_t *params,
 	for (buffer = dev->common_buffer;
 	     dev->num_buffers < params->num_buffers;
 	     dev->num_buffers++, buffer += params->buffer_size) {
-		struct smscore_buffer_t *cb =
-			smscore_createbuffer(buffer, dev->common_buffer,
-					     dev->common_buffer_phys);
+		struct smscore_buffer_t *cb;
+
+		cb = smscore_createbuffer(buffer, dev->common_buffer,
+					  dev->common_buffer_phys);
 		if (!cb) {
 			smscore_unregister_device(dev);
 			return -ENOMEM;
@@ -1193,7 +1195,9 @@ static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
 {
 	char **fw;
 	int board_id = smscore_get_board_id(coredev);
-	enum sms_device_type_st type = smscore_registry_gettype(coredev->devpath);
+	enum sms_device_type_st type;
+
+	type = smscore_registry_gettype(coredev->devpath);
 
 	if ((board_id == SMS_BOARD_UNKNOWN) || (lookup == 1)) {
 		sms_debug("trying to get fw name from lookup table mode %d type %d",
@@ -1321,6 +1325,9 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 
 	if (rc < 0)
 		sms_err("return error code %d.", rc);
+	else
+		sms_debug("Success setting device mode.");
+
 	return rc;
 }
 
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 91db853..8af94c4 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -973,7 +973,6 @@ struct smscore_config_gpio {
 
 char *smscore_translate_msg(enum msg_types msgtype);
 
-extern void smscore_registry_setmode(char *devpath, int mode);
 extern int smscore_registry_getmode(char *devpath);
 
 extern int smscore_register_hotplug(hotplug_t hotplug);
-- 
1.8.1.4

