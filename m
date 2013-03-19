Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933037Ab3CSQuP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:15 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 41/46] [media] siano: remove the bogus firmware lookup code
Date: Tue, 19 Mar 2013 13:49:30 -0300
Message-Id: <1363711775-2120-42-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is an special lookup code that is called when
SMS_BOARD_UNKNOWN. The logic there is bogus and will cause
an oops, as .type is SMS_UNKNOWN_TYPE (-1).

As the code would do:
	return smscore_fw_lkup[type][mode];

That would mean that it would try to go past the
smscore_fw_lkup table.

So, just remove that bogus code, simplifying the logic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 4fa3df2..f6619e0 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1048,7 +1048,7 @@ exit_fw_download:
 
 
 static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
-			      int mode, int lookup);
+				     int mode);
 
 /**
  * loads specified firmware into a buffer and calls device loadfirmware_handler
@@ -1061,7 +1061,7 @@ static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
  * @return 0 on success, <0 on error.
  */
 static int smscore_load_firmware_from_file(struct smscore_device_t *coredev,
-					   int mode, int lookup,
+					   int mode,
 					   loadfirmware_t loadfirmware_handler)
 {
 	int rc = -ENOENT;
@@ -1069,7 +1069,7 @@ static int smscore_load_firmware_from_file(struct smscore_device_t *coredev,
 	u32 fw_buf_size;
 	const struct firmware *fw;
 
-	char *fw_filename = smscore_get_fw_filename(coredev, mode, lookup);
+	char *fw_filename = smscore_get_fw_filename(coredev, mode);
 	if (!fw_filename) {
 		sms_info("mode %d not supported on this device", mode);
 		return -ENOENT;
@@ -1269,7 +1269,7 @@ static char *smscore_fw_lkup[][DEVICE_MODE_MAX] = {
  * @return 0 on success, <0 on error.
  */
 static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
-			      int mode, int lookup)
+			      int mode)
 {
 	char **fw;
 	int board_id = smscore_get_board_id(coredev);
@@ -1283,12 +1283,6 @@ static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
 	if (mode <= DEVICE_MODE_NONE || mode >= DEVICE_MODE_MAX)
 		return NULL;
 
-	if ((board_id == SMS_BOARD_UNKNOWN) || (lookup == 1)) {
-		sms_debug("trying to get fw name from lookup table mode %d type %d",
-			  mode, type);
-		return smscore_fw_lkup[type][mode];
-	}
-
 	sms_debug("trying to get fw name from sms_boards board_id %d mode %d",
 		  board_id, mode);
 	fw = sms_get_board(board_id)->fw;
@@ -1374,24 +1368,7 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 
 		if (!(coredev->modes_supported & (1 << mode))) {
 			rc = smscore_load_firmware_from_file(coredev,
-							     mode, 0, NULL);
-
-			/*
-			* try again with the default firmware -
-			* get the fw filename from look-up table
-			*/
-			if (rc < 0) {
-				sms_debug("error %d loading firmware, trying again with default firmware",
-					  rc);
-				rc = smscore_load_firmware_from_file(coredev,
-								     mode, 1,
-								     NULL);
-				if (rc < 0) {
-					sms_debug("error %d loading firmware",
-						  rc);
-					return rc;
-				}
-			}
+							     mode, NULL);
 			if (rc >= 0)
 				sms_info("firmware download success");
 		} else {
-- 
1.8.1.4

