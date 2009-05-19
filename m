Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110805.mail.gq1.yahoo.com ([67.195.13.228]:40363 "HELO
	web110805.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753549AbZESPSj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 11:18:39 -0400
Message-ID: <365677.76291.qm@web110805.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 08:18:40 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_45_1] Siano: smscards - add board (target) events
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242746621 -10800
# Node ID 37df2d513a68b920ba4ceed0220cf6915d2d574e
# Parent  2b865fa7f195524bc9e8557dac472140755058dd
[09051_45_1] Siano: smscards - add board (target) events

From: Uri Shkolnik <uris@siano-ms.com>

Add events handling for targets. All board-specific
(target specific) should reside here.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 2b865fa7f195 -r 37df2d513a68 linux/drivers/media/dvb/siano/sms-cards.c
--- a/linux/drivers/media/dvb/siano/sms-cards.c	Tue May 19 18:15:21 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.c	Tue May 19 18:23:41 2009 +0300
@@ -104,6 +104,173 @@ struct sms_board *sms_get_board(int id)
 	return &sms_boards[id];
 }
 EXPORT_SYMBOL_GPL(sms_get_board);
+static inline void sms_gpio_assign_11xx_default_led_config(
+		struct smscore_gpio_config *pGpioConfig) {
+	pGpioConfig->Direction = SMS_GPIO_DIRECTION_OUTPUT;
+	pGpioConfig->InputCharacteristics =
+		SMS_GPIO_INPUT_CHARACTERISTICS_NORMAL;
+	pGpioConfig->OutputDriving = SMS_GPIO_OUTPUT_DRIVING_4mA;
+	pGpioConfig->OutputSlewRate = SMS_GPIO_OUTPUT_SLEW_RATE_0_45_V_NS;
+	pGpioConfig->PullUpDown = SMS_GPIO_PULL_UP_DOWN_NONE;
+}
+
+int sms_board_event(struct smscore_device_t *coredev,
+		enum SMS_BOARD_EVENTS gevent) {
+	int board_id = smscore_get_board_id(coredev);
+	struct sms_board *board = sms_get_board(board_id);
+	struct smscore_gpio_config MyGpioConfig;
+
+	sms_gpio_assign_11xx_default_led_config(&MyGpioConfig);
+
+	switch (gevent) {
+	case BOARD_EVENT_POWER_INIT: /* including hotplug */
+		switch (board_id) {
+		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
+			/* set I/O and turn off all LEDs */
+			smscore_gpio_configure(coredev,
+					board->board_cfg.leds_power,
+					&MyGpioConfig);
+			smscore_gpio_set_level(coredev,
+					board->board_cfg.leds_power, 0);
+			smscore_gpio_configure(coredev, board->board_cfg.led0,
+					&MyGpioConfig);
+			smscore_gpio_set_level(coredev,
+					board->board_cfg.led0, 0);
+			smscore_gpio_configure(coredev, board->board_cfg.led1,
+					&MyGpioConfig);
+			smscore_gpio_set_level(coredev,
+					board->board_cfg.led1, 0);
+			break;
+		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
+		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
+			/* set I/O and turn off LNA */
+			smscore_gpio_configure(coredev,
+					board->board_cfg.foreign_lna0_ctrl,
+					&MyGpioConfig);
+			smscore_gpio_set_level(coredev,
+					board->board_cfg.foreign_lna0_ctrl,
+					0);
+			break;
+		}
+		break; /* BOARD_EVENT_BIND */
+
+	case BOARD_EVENT_POWER_SUSPEND:
+		switch (board_id) {
+		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
+			smscore_gpio_set_level(coredev,
+						board->board_cfg.leds_power, 0);
+			smscore_gpio_set_level(coredev,
+						board->board_cfg.led0, 0);
+			smscore_gpio_set_level(coredev,
+						board->board_cfg.led1, 0);
+			break;
+		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
+		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
+			smscore_gpio_set_level(coredev,
+					board->board_cfg.foreign_lna0_ctrl,
+					0);
+			break;
+		}
+		break; /* BOARD_EVENT_POWER_SUSPEND */
+
+	case BOARD_EVENT_POWER_RESUME:
+		switch (board_id) {
+		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
+			smscore_gpio_set_level(coredev,
+						board->board_cfg.leds_power, 1);
+			smscore_gpio_set_level(coredev,
+						board->board_cfg.led0, 1);
+			smscore_gpio_set_level(coredev,
+						board->board_cfg.led1, 0);
+			break;
+		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
+		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
+			smscore_gpio_set_level(coredev,
+					board->board_cfg.foreign_lna0_ctrl,
+					1);
+			break;
+		}
+		break; /* BOARD_EVENT_POWER_RESUME */
+
+	case BOARD_EVENT_BIND:
+		switch (board_id) {
+		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
+			smscore_gpio_set_level(coredev,
+				board->board_cfg.leds_power, 1);
+			smscore_gpio_set_level(coredev,
+				board->board_cfg.led0, 1);
+			smscore_gpio_set_level(coredev,
+				board->board_cfg.led1, 0);
+			break;
+		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
+		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
+			smscore_gpio_set_level(coredev,
+					board->board_cfg.foreign_lna0_ctrl,
+					1);
+			break;
+		}
+		break; /* BOARD_EVENT_BIND */
+
+	case BOARD_EVENT_SCAN_PROG:
+		break; /* BOARD_EVENT_SCAN_PROG */
+	case BOARD_EVENT_SCAN_COMP:
+		break; /* BOARD_EVENT_SCAN_COMP */
+	case BOARD_EVENT_EMERGENCY_WARNING_SIGNAL:
+		break; /* BOARD_EVENT_EMERGENCY_WARNING_SIGNAL */
+	case BOARD_EVENT_FE_LOCK:
+		switch (board_id) {
+		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
+			smscore_gpio_set_level(coredev,
+			board->board_cfg.led1, 1);
+			break;
+		}
+		break; /* BOARD_EVENT_FE_LOCK */
+	case BOARD_EVENT_FE_UNLOCK:
+		switch (board_id) {
+		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
+			smscore_gpio_set_level(coredev,
+						board->board_cfg.led1, 0);
+			break;
+		}
+		break; /* BOARD_EVENT_FE_UNLOCK */
+	case BOARD_EVENT_DEMOD_LOCK:
+		break; /* BOARD_EVENT_DEMOD_LOCK */
+	case BOARD_EVENT_DEMOD_UNLOCK:
+		break; /* BOARD_EVENT_DEMOD_UNLOCK */
+	case BOARD_EVENT_RECEPTION_MAX_4:
+		break; /* BOARD_EVENT_RECEPTION_MAX_4 */
+	case BOARD_EVENT_RECEPTION_3:
+		break; /* BOARD_EVENT_RECEPTION_3 */
+	case BOARD_EVENT_RECEPTION_2:
+		break; /* BOARD_EVENT_RECEPTION_2 */
+	case BOARD_EVENT_RECEPTION_1:
+		break; /* BOARD_EVENT_RECEPTION_1 */
+	case BOARD_EVENT_RECEPTION_LOST_0:
+		break; /* BOARD_EVENT_RECEPTION_LOST_0 */
+	case BOARD_EVENT_MULTIPLEX_OK:
+		switch (board_id) {
+		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
+			smscore_gpio_set_level(coredev,
+						board->board_cfg.led1, 1);
+			break;
+		}
+		break; /* BOARD_EVENT_MULTIPLEX_OK */
+	case BOARD_EVENT_MULTIPLEX_ERRORS:
+		switch (board_id) {
+		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
+			smscore_gpio_set_level(coredev,
+						board->board_cfg.led1, 0);
+			break;
+		}
+		break; /* BOARD_EVENT_MULTIPLEX_ERRORS */
+
+	default:
+		sms_err("Unknown SMS board event");
+		break;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sms_board_event);
 
 static int sms_set_gpio(struct smscore_device_t *coredev, int pin, int enable)
 {
diff -r 2b865fa7f195 -r 37df2d513a68 linux/drivers/media/dvb/siano/sms-cards.h
--- a/linux/drivers/media/dvb/siano/sms-cards.h	Tue May 19 18:15:21 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.h	Tue May 19 18:23:41 2009 +0300
@@ -85,6 +85,30 @@ struct sms_board *sms_get_board(int id);
 
 extern struct smscore_device_t *coredev;
 
+enum SMS_BOARD_EVENTS {
+	BOARD_EVENT_POWER_INIT,
+	BOARD_EVENT_POWER_SUSPEND,
+	BOARD_EVENT_POWER_RESUME,
+	BOARD_EVENT_BIND,
+	BOARD_EVENT_SCAN_PROG,
+	BOARD_EVENT_SCAN_COMP,
+	BOARD_EVENT_EMERGENCY_WARNING_SIGNAL,
+	BOARD_EVENT_FE_LOCK,
+	BOARD_EVENT_FE_UNLOCK,
+	BOARD_EVENT_DEMOD_LOCK,
+	BOARD_EVENT_DEMOD_UNLOCK,
+	BOARD_EVENT_RECEPTION_MAX_4,
+	BOARD_EVENT_RECEPTION_3,
+	BOARD_EVENT_RECEPTION_2,
+	BOARD_EVENT_RECEPTION_1,
+	BOARD_EVENT_RECEPTION_LOST_0,
+	BOARD_EVENT_MULTIPLEX_OK,
+	BOARD_EVENT_MULTIPLEX_ERRORS
+};
+
+int sms_board_event(struct smscore_device_t *coredev,
+		enum SMS_BOARD_EVENTS gevent);
+
 int sms_board_setup(struct smscore_device_t *coredev);
 
 #define SMS_LED_OFF 0



      
