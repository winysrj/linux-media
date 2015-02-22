Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48097 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbbBVQLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 11:11:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 05/10] [media] siano: replace sms_log() by pr_debug()
Date: Sun, 22 Feb 2015 13:11:36 -0300
Message-Id: <1424621501-17466-6-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
References: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Despite its name, those functions are acutally debug
prints for the IR part of the driver. So, properly
map them using pr_debug()

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/smscoreapi.h | 1 -
 drivers/media/common/siano/smsir.c      | 8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 9ea6a10757d5..ab6506fd65c8 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -1179,7 +1179,6 @@ int smscore_led_state(struct smscore_device_t *core, int led);
 #define DBG_INFO 1
 #define DBG_ADV  2
 
-#define sms_log(fmt, arg...) pr_info(fmt "\n", ##arg)
 #define sms_info(fmt, arg...) do {\
 	if (sms_dbg & DBG_INFO) \
 		pr_info(fmt "\n", ##arg); \
diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
index 2e0f96ff5594..825e1ca0f9d8 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -57,14 +57,14 @@ int sms_ir_init(struct smscore_device_t *coredev)
 	int board_id = smscore_get_board_id(coredev);
 	struct rc_dev *dev;
 
-	sms_log("Allocating rc device");
+	pr_debug("Allocating rc device\n");
 	dev = rc_allocate_device();
 	if (!dev)
 		return -ENOMEM;
 
 	coredev->ir.controller = 0;	/* Todo: vega/nova SPI number */
 	coredev->ir.timeout = IR_DEFAULT_TIMEOUT;
-	sms_log("IR port %d, timeout %d ms",
+	pr_debug("IR port %d, timeout %d ms\n",
 			coredev->ir.controller, coredev->ir.timeout);
 
 	snprintf(coredev->ir.name, sizeof(coredev->ir.name),
@@ -91,7 +91,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 	dev->map_name = sms_get_board(board_id)->rc_codes;
 	dev->driver_name = MODULE_NAME;
 
-	sms_log("Input device (IR) %s is set for key events", dev->input_name);
+	pr_debug("Input device (IR) %s is set for key events\n", dev->input_name);
 
 	err = rc_register_device(dev);
 	if (err < 0) {
@@ -108,5 +108,5 @@ void sms_ir_exit(struct smscore_device_t *coredev)
 {
 	rc_unregister_device(coredev->ir.dev);
 
-	sms_log("");
+	pr_debug("\n");
 }
-- 
2.1.0

