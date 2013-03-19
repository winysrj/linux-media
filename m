Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091Ab3CSQtr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:49:47 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 01/46] [media] siano: Change GPIO voltage setting names
Date: Tue, 19 Mar 2013 13:48:50 -0300
Message-Id: <1363711775-2120-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Siano changed the namespace on more recent API, and re-used some
of the old names. In order to be able to update the API to support
newer chips, the better is to follow this change.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/sms-cards.c  | 2 +-
 drivers/media/common/siano/smscoreapi.c | 8 ++++----
 drivers/media/common/siano/smscoreapi.h | 8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/common/siano/sms-cards.c b/drivers/media/common/siano/sms-cards.c
index 680c781..8ee2e92 100644
--- a/drivers/media/common/siano/sms-cards.c
+++ b/drivers/media/common/siano/sms-cards.c
@@ -183,7 +183,7 @@ static int sms_set_gpio(struct smscore_device_t *coredev, int pin, int enable)
 		.pullupdown           = SMS_GPIO_PULLUPDOWN_NONE,
 		.inputcharacteristics = SMS_GPIO_INPUTCHARACTERISTICS_NORMAL,
 		.outputslewrate       = SMS_GPIO_OUTPUTSLEWRATE_FAST,
-		.outputdriving        = SMS_GPIO_OUTPUTDRIVING_4mA,
+		.outputdriving        = SMS_GPIO_OUTPUTDRIVING_S_4mA,
 	};
 
 	if (pin == 0)
diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 1842e64..d0592b5 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1306,16 +1306,16 @@ int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
 		msg.data[2] = pinconfig->outputslewrate == 0 ? 3 : 0;
 
 		switch (pinconfig->outputdriving) {
-		case SMS_GPIO_OUTPUTDRIVING_16mA:
+		case SMS_GPIO_OUTPUTDRIVING_S_16mA:
 			msg.data[3] = 7; /* Nova - 16mA */
 			break;
-		case SMS_GPIO_OUTPUTDRIVING_12mA:
+		case SMS_GPIO_OUTPUTDRIVING_S_12mA:
 			msg.data[3] = 5; /* Nova - 11mA */
 			break;
-		case SMS_GPIO_OUTPUTDRIVING_8mA:
+		case SMS_GPIO_OUTPUTDRIVING_S_8mA:
 			msg.data[3] = 3; /* Nova - 7mA */
 			break;
-		case SMS_GPIO_OUTPUTDRIVING_4mA:
+		case SMS_GPIO_OUTPUTDRIVING_S_4mA:
 		default:
 			msg.data[3] = 2; /* Nova - 4mA */
 			break;
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index c592ae0..a6d29a2 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -642,10 +642,10 @@ struct smscore_config_gpio {
 #define SMS_GPIO_OUTPUTSLEWRATE_SLOW 1
 	u8 outputslewrate;
 
-#define SMS_GPIO_OUTPUTDRIVING_4mA  0
-#define SMS_GPIO_OUTPUTDRIVING_8mA  1
-#define SMS_GPIO_OUTPUTDRIVING_12mA 2
-#define SMS_GPIO_OUTPUTDRIVING_16mA 3
+#define SMS_GPIO_OUTPUTDRIVING_S_4mA  0
+#define SMS_GPIO_OUTPUTDRIVING_S_8mA  1
+#define SMS_GPIO_OUTPUTDRIVING_S_12mA 2
+#define SMS_GPIO_OUTPUTDRIVING_S_16mA 3
 	u8 outputdriving;
 };
 
-- 
1.8.1.4

