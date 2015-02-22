Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbbBVQLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 11:11:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 03/10] [media] siano: replace sms_warn() by pr_warn()
Date: Sun, 22 Feb 2015 13:11:34 -0300
Message-Id: <1424621501-17466-4-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
References: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no reason for a sms' own sms_warn macro. Just replace
it by the standard pr_warn().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/smscoreapi.h | 1 -
 drivers/media/usb/siano/smsusb.c        | 6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index b5d85fd0bee8..13bd7ef7a588 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -1181,7 +1181,6 @@ int smscore_led_state(struct smscore_device_t *core, int led);
 
 #define sms_log(fmt, arg...) pr_info(fmt "\n", ##arg)
 #define sms_err(fmt, arg...) pr_err(fmt " on line: %d\n", ##arg, __LINE__)
-#define sms_warn(fmt, arg...) pr_warn(fmt "\n", ##arg)
 #define sms_info(fmt, arg...) do {\
 	if (sms_dbg & DBG_INFO) \
 		pr_info(fmt "\n", ##arg); \
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 426455118d02..244674599878 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -258,13 +258,13 @@ static int smsusb1_load_firmware(struct usb_device *udev, int id, int board_id)
 
 	rc = request_firmware(&fw, fw_filename, &udev->dev);
 	if (rc < 0) {
-		sms_warn("failed to open \"%s\" mode %d, "
-			 "trying again with default firmware", fw_filename, id);
+		pr_warn("failed to open '%s' mode %d, trying again with default firmware\n",
+			fw_filename, id);
 
 		fw_filename = smsusb1_fw_lkup[id];
 		rc = request_firmware(&fw, fw_filename, &udev->dev);
 		if (rc < 0) {
-			sms_warn("failed to open \"%s\" mode %d",
+			pr_warn("failed to open '%s' mode %d\n",
 				 fw_filename, id);
 
 			return rc;
-- 
2.1.0

