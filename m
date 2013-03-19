Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933233Ab3CSQvT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:51:19 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/46] [media] siano: remove a duplicated structure definition
Date: Tue, 19 Mar 2013 13:48:52 -0300
Message-Id: <1363711775-2120-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The same GPIO config struct was declared twice at the
driver, with different names and different macros:
	struct smscore_config_gpio
	struct smscore_config_gpio

Remove the one that uses CamelCase and fix the references to
its attributes/macros.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/sms-cards.c  | 18 +++++------
 drivers/media/common/siano/smscoreapi.c | 20 ++++++------
 drivers/media/common/siano/smscoreapi.h | 55 +++++++--------------------------
 3 files changed, 30 insertions(+), 63 deletions(-)

diff --git a/drivers/media/common/siano/sms-cards.c b/drivers/media/common/siano/sms-cards.c
index 8ee2e92..b22b61d 100644
--- a/drivers/media/common/siano/sms-cards.c
+++ b/drivers/media/common/siano/sms-cards.c
@@ -109,18 +109,18 @@ struct sms_board *sms_get_board(unsigned id)
 }
 EXPORT_SYMBOL_GPL(sms_get_board);
 static inline void sms_gpio_assign_11xx_default_led_config(
-		struct smscore_gpio_config *pGpioConfig) {
-	pGpioConfig->Direction = SMS_GPIO_DIRECTION_OUTPUT;
-	pGpioConfig->InputCharacteristics =
-		SMS_GPIO_INPUT_CHARACTERISTICS_NORMAL;
-	pGpioConfig->OutputDriving = SMS_GPIO_OUTPUT_DRIVING_4mA;
-	pGpioConfig->OutputSlewRate = SMS_GPIO_OUTPUT_SLEW_RATE_0_45_V_NS;
-	pGpioConfig->PullUpDown = SMS_GPIO_PULL_UP_DOWN_NONE;
+		struct smscore_config_gpio *pGpioConfig) {
+	pGpioConfig->direction = SMS_GPIO_DIRECTION_OUTPUT;
+	pGpioConfig->inputcharacteristics =
+		SMS_GPIO_INPUTCHARACTERISTICS_NORMAL;
+	pGpioConfig->outputdriving = SMS_GPIO_OUTPUTDRIVING_4mA;
+	pGpioConfig->outputslewrate = SMS_GPIO_OUTPUT_SLEW_RATE_0_45_V_NS;
+	pGpioConfig->pullupdown = SMS_GPIO_PULLUPDOWN_NONE;
 }
 
 int sms_board_event(struct smscore_device_t *coredev,
 		enum SMS_BOARD_EVENTS gevent) {
-	struct smscore_gpio_config MyGpioConfig;
+	struct smscore_config_gpio MyGpioConfig;
 
 	sms_gpio_assign_11xx_default_led_config(&MyGpioConfig);
 
@@ -182,7 +182,7 @@ static int sms_set_gpio(struct smscore_device_t *coredev, int pin, int enable)
 		.direction            = SMS_GPIO_DIRECTION_OUTPUT,
 		.pullupdown           = SMS_GPIO_PULLUPDOWN_NONE,
 		.inputcharacteristics = SMS_GPIO_INPUTCHARACTERISTICS_NORMAL,
-		.outputslewrate       = SMS_GPIO_OUTPUTSLEWRATE_FAST,
+		.outputslewrate       = SMS_GPIO_OUTPUT_SLEW_RATE_FAST,
 		.outputdriving        = SMS_GPIO_OUTPUTDRIVING_S_4mA,
 	};
 
diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index d0592b5..58371c3 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1406,7 +1406,7 @@ static int GetGpioPinParams(u32 PinNum, u32 *pTranslatedPinNum,
 }
 
 int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
-		struct smscore_gpio_config *pGpioConfig) {
+		struct smscore_config_gpio *pGpioConfig) {
 
 	u32 totalLen;
 	u32 TranslatedPinNum = 0;
@@ -1453,19 +1453,19 @@ int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
 
 		pMsg->msgData[1] = TranslatedPinNum;
 		pMsg->msgData[2] = GroupNum;
-		ElectricChar = (pGpioConfig->PullUpDown)
-				| (pGpioConfig->InputCharacteristics << 2)
-				| (pGpioConfig->OutputSlewRate << 3)
-				| (pGpioConfig->OutputDriving << 4);
+		ElectricChar = (pGpioConfig->pullupdown)
+				| (pGpioConfig->inputcharacteristics << 2)
+				| (pGpioConfig->outputslewrate << 3)
+				| (pGpioConfig->outputdriving << 4);
 		pMsg->msgData[3] = ElectricChar;
-		pMsg->msgData[4] = pGpioConfig->Direction;
+		pMsg->msgData[4] = pGpioConfig->direction;
 		pMsg->msgData[5] = groupCfg;
 	} else {
 		pMsg->xMsgHeader.msgType = MSG_SMS_GPIO_CONFIG_EX_REQ;
-		pMsg->msgData[1] = pGpioConfig->PullUpDown;
-		pMsg->msgData[2] = pGpioConfig->OutputSlewRate;
-		pMsg->msgData[3] = pGpioConfig->OutputDriving;
-		pMsg->msgData[4] = pGpioConfig->Direction;
+		pMsg->msgData[1] = pGpioConfig->pullupdown;
+		pMsg->msgData[2] = pGpioConfig->outputslewrate;
+		pMsg->msgData[3] = pGpioConfig->outputdriving;
+		pMsg->msgData[4] = pGpioConfig->direction;
 		pMsg->msgData[5] = 0;
 	}
 
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 62f05e8..f2510f5 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -638,8 +638,16 @@ struct smscore_config_gpio {
 #define SMS_GPIO_INPUTCHARACTERISTICS_SCHMITT 1
 	u8 inputcharacteristics;
 
-#define SMS_GPIO_OUTPUTSLEWRATE_FAST 0
-#define SMS_GPIO_OUTPUTSLEWRATE_SLOW 1
+	/* 10xx */
+#define SMS_GPIO_OUTPUT_SLEW_RATE_FAST 0
+#define SMS_GPIO_OUTPUT_SLEW_WRATE_SLOW 1
+
+	/* 11xx */
+#define SMS_GPIO_OUTPUT_SLEW_RATE_0_45_V_NS	0
+#define SMS_GPIO_OUTPUT_SLEW_RATE_0_9_V_NS	1
+#define SMS_GPIO_OUTPUT_SLEW_RATE_1_7_V_NS	2
+#define SMS_GPIO_OUTPUT_SLEW_RATE_3_3_V_NS	3
+
 	u8 outputslewrate;
 
 	/* 10xx */
@@ -661,47 +669,6 @@ struct smscore_config_gpio {
 	u8 outputdriving;
 };
 
-struct smscore_gpio_config {
-#define SMS_GPIO_DIRECTION_INPUT  0
-#define SMS_GPIO_DIRECTION_OUTPUT 1
-	u8 Direction;
-
-#define SMS_GPIO_PULL_UP_DOWN_NONE     0
-#define SMS_GPIO_PULL_UP_DOWN_PULLDOWN 1
-#define SMS_GPIO_PULL_UP_DOWN_PULLUP   2
-#define SMS_GPIO_PULL_UP_DOWN_KEEPER   3
-	u8 PullUpDown;
-
-#define SMS_GPIO_INPUT_CHARACTERISTICS_NORMAL  0
-#define SMS_GPIO_INPUT_CHARACTERISTICS_SCHMITT 1
-	u8 InputCharacteristics;
-
-#define SMS_GPIO_OUTPUT_SLEW_RATE_SLOW		1 /* 10xx */
-#define SMS_GPIO_OUTPUT_SLEW_RATE_FAST		0 /* 10xx */
-
-
-#define SMS_GPIO_OUTPUT_SLEW_RATE_0_45_V_NS	0 /* 11xx */
-#define SMS_GPIO_OUTPUT_SLEW_RATE_0_9_V_NS	1 /* 11xx */
-#define SMS_GPIO_OUTPUT_SLEW_RATE_1_7_V_NS	2 /* 11xx */
-#define SMS_GPIO_OUTPUT_SLEW_RATE_3_3_V_NS	3 /* 11xx */
-	u8 OutputSlewRate;
-
-#define SMS_GPIO_OUTPUT_DRIVING_S_4mA		0 /* 10xx */
-#define SMS_GPIO_OUTPUT_DRIVING_S_8mA		1 /* 10xx */
-#define SMS_GPIO_OUTPUT_DRIVING_S_12mA		2 /* 10xx */
-#define SMS_GPIO_OUTPUT_DRIVING_S_16mA		3 /* 10xx */
-
-#define SMS_GPIO_OUTPUT_DRIVING_1_5mA		0 /* 11xx */
-#define SMS_GPIO_OUTPUT_DRIVING_2_8mA		1 /* 11xx */
-#define SMS_GPIO_OUTPUT_DRIVING_4mA		2 /* 11xx */
-#define SMS_GPIO_OUTPUT_DRIVING_7mA		3 /* 11xx */
-#define SMS_GPIO_OUTPUT_DRIVING_10mA		4 /* 11xx */
-#define SMS_GPIO_OUTPUT_DRIVING_11mA		5 /* 11xx */
-#define SMS_GPIO_OUTPUT_DRIVING_14mA		6 /* 11xx */
-#define SMS_GPIO_OUTPUT_DRIVING_16mA		7 /* 11xx */
-	u8 OutputDriving;
-};
-
 extern void smscore_registry_setmode(char *devpath, int mode);
 extern int smscore_registry_getmode(char *devpath);
 
@@ -750,7 +717,7 @@ int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int level);
 
 /* new GPIO management */
 extern int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
-		struct smscore_gpio_config *pGpioConfig);
+		struct smscore_config_gpio *pGpioConfig);
 extern int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 PinNum,
 		u8 NewLevel);
 extern int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 PinNum,
-- 
1.8.1.4

