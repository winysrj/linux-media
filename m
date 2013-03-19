Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935Ab3CSQuG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:06 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 40/46] [media] siano: honour per-card default mode
Date: Tue, 19 Mar 2013 13:49:29 -0300
Message-Id: <1363711775-2120-41-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using a global default_mode, passed via modprobe
parameter, use the one defined inside the cards struct.

That will prevent the need of manually specify it for each
board, except, of course, if the user wants to do something
different, on boards that accept multiple types.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 6db7fe5..4fa3df2 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -434,7 +434,7 @@ static struct mutex g_smscore_deviceslock;
 static struct list_head g_smscore_registry;
 static struct mutex g_smscore_registrylock;
 
-static int default_mode = 4;
+static int default_mode = DEVICE_MODE_NONE;
 
 module_param(default_mode, int, 0644);
 MODULE_PARM_DESC(default_mode, "default firmware id (device mode)");
@@ -880,8 +880,15 @@ int smscore_configure_board(struct smscore_device_t *coredev)
  */
 int smscore_start_device(struct smscore_device_t *coredev)
 {
-	int rc = smscore_set_device_mode(
-			coredev, smscore_registry_getmode(coredev->devpath));
+	int rc;
+	int board_id = smscore_get_board_id(coredev);
+	int mode = smscore_registry_getmode(coredev->devpath);
+
+	/* Device is initialized as DEVICE_MODE_NONE */
+	if (board_id != SMS_BOARD_UNKNOWN && mode == DEVICE_MODE_NONE)
+		mode = sms_get_board(board_id)->default_mode;
+
+	rc = smscore_set_device_mode(coredev, mode);
 	if (rc < 0) {
 		sms_info("set device mode faile , rc %d", rc);
 		return rc;
@@ -1270,6 +1277,12 @@ static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
 
 	type = smscore_registry_gettype(coredev->devpath);
 
+	/* Prevent looking outside the smscore_fw_lkup table */
+	if (type <= SMS_UNKNOWN_TYPE || type >= SMS_NUM_OF_DEVICE_TYPES)
+		return NULL;
+	if (mode <= DEVICE_MODE_NONE || mode >= DEVICE_MODE_MAX)
+		return NULL;
+
 	if ((board_id == SMS_BOARD_UNKNOWN) || (lookup == 1)) {
 		sms_debug("trying to get fw name from lookup table mode %d type %d",
 			  mode, type);
@@ -1339,7 +1352,7 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 
 	sms_debug("set device mode to %d", mode);
 	if (coredev->device_flags & SMS_DEVICE_FAMILY2) {
-		if (mode < DEVICE_MODE_DVBT || mode >= DEVICE_MODE_RAW_TUNER) {
+		if (mode <= DEVICE_MODE_NONE || mode >= DEVICE_MODE_MAX) {
 			sms_err("invalid mode specified %d", mode);
 			return -EINVAL;
 		}
@@ -1391,7 +1404,7 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 				sms_err("device init failed, rc %d.", rc);
 		}
 	} else {
-		if (mode < DEVICE_MODE_DVBT || mode > DEVICE_MODE_MAX) {
+		if (mode <= DEVICE_MODE_NONE || mode >= DEVICE_MODE_MAX) {
 			sms_err("invalid mode specified %d", mode);
 			return -EINVAL;
 		}
-- 
1.8.1.4

