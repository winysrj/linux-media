Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110802.mail.gq1.yahoo.com ([67.195.13.225]:33350 "HELO
	web110802.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753060AbZESQqG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 12:46:06 -0400
Message-ID: <281711.70090.qm@web110802.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 09:46:07 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_57] Siano: smscards - remove redundant code
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242751824 -10800
# Node ID fd16bcd8b9f1fffe0b605ca5b3b2138fc920e927
# Parent  f78cbc153c82ebe58a1bbe82271b91f5a4a90642
[09051_57] Siano: smscards - remove redundant code

From: Uri Shkolnik <uris@siano-ms.com>

Remove code that has been duplicate with the new boards events manager

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r f78cbc153c82 -r fd16bcd8b9f1 linux/drivers/media/dvb/siano/sms-cards.c
--- a/linux/drivers/media/dvb/siano/sms-cards.c	Tue May 19 19:45:05 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.c	Tue May 19 19:50:24 2009 +0300
@@ -281,98 +281,3 @@ int sms_board_event(struct smscore_devic
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sms_board_event);
-
-static int sms_set_gpio(struct smscore_device_t *coredev, int pin, int enable)
-{
-	int lvl, ret;
-	u32 gpio;
-	struct smscore_config_gpio gpioconfig = {
-		.direction            = SMS_GPIO_DIRECTION_OUTPUT,
-		.pullupdown           = SMS_GPIO_PULLUPDOWN_NONE,
-		.inputcharacteristics = SMS_GPIO_INPUTCHARACTERISTICS_NORMAL,
-		.outputslewrate       = SMS_GPIO_OUTPUTSLEWRATE_FAST,
-		.outputdriving        = SMS_GPIO_OUTPUTDRIVING_4mA,
-	};
-
-	if (pin == 0)
-		return -EINVAL;
-
-	if (pin < 0) {
-		/* inverted gpio */
-		gpio = pin * -1;
-		lvl = enable ? 0 : 1;
-	} else {
-		gpio = pin;
-		lvl = enable ? 1 : 0;
-	}
-
-	ret = smscore_configure_gpio(coredev, gpio, &gpioconfig);
-	if (ret < 0)
-		return ret;
-
-	return smscore_set_gpio(coredev, gpio, lvl);
-}
-
-int sms_board_power(struct smscore_device_t *coredev, int onoff)
-{
-	int board_id = smscore_get_board_id(coredev);
-	struct sms_board *board = sms_get_board(board_id);
-
-	switch (board_id) {
-	case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
-		/* power LED */
-		sms_set_gpio(coredev,
-			     board->led_power, onoff ? 1 : 0);
-		break;
-	case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
-	case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
-		/* LNA */
-		if (!onoff)
-			sms_set_gpio(coredev, board->lna_ctrl, 0);
-		break;
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(sms_board_power);
-
-int sms_board_led_feedback(struct smscore_device_t *coredev, int led)
-{
-	int board_id = smscore_get_board_id(coredev);
-	struct sms_board *board = sms_get_board(board_id);
-
-	/* dont touch GPIO if LEDs are already set */
-	if (smscore_led_state(coredev, -1) == led)
-		return 0;
-
-	switch (board_id) {
-	case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
-		sms_set_gpio(coredev,
-			     board->led_lo, (led & SMS_LED_LO) ? 1 : 0);
-		sms_set_gpio(coredev,
-			     board->led_hi, (led & SMS_LED_HI) ? 1 : 0);
-
-		smscore_led_state(coredev, led);
-		break;
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(sms_board_led_feedback);
-
-int sms_board_lna_control(struct smscore_device_t *coredev, int onoff)
-{
-	int board_id = smscore_get_board_id(coredev);
-	struct sms_board *board = sms_get_board(board_id);
-
-	sms_debug("%s: LNA %s", __func__, onoff ? "enabled" : "disabled");
-
-	switch (board_id) {
-	case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
-	case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
-		sms_set_gpio(coredev,
-			     board->rf_switch, onoff ? 1 : 0);
-		return sms_set_gpio(coredev,
-				    board->lna_ctrl, onoff ? 1 : 0);
-	}
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(sms_board_lna_control);
diff -r f78cbc153c82 -r fd16bcd8b9f1 linux/drivers/media/dvb/siano/sms-cards.h
--- a/linux/drivers/media/dvb/siano/sms-cards.h	Tue May 19 19:45:05 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.h	Tue May 19 19:50:24 2009 +0300
@@ -110,11 +110,4 @@ int sms_board_event(struct smscore_devic
 int sms_board_event(struct smscore_device_t *coredev,
 		enum SMS_BOARD_EVENTS gevent);
 
-#define SMS_LED_OFF 0
-#define SMS_LED_LO  1
-#define SMS_LED_HI  2
-int sms_board_led_feedback(struct smscore_device_t *coredev, int led);
-int sms_board_power(struct smscore_device_t *coredev, int onoff);
-int sms_board_lna_control(struct smscore_device_t *coredev, int onoff);
-
 #endif /* __SMS_CARDS_H__ */



      
