Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48043 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1BBPPX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Feb 2011 10:15:23 -0500
Received: by fxm20 with SMTP id 20so60416fxm.19
        for <linux-media@vger.kernel.org>; Wed, 02 Feb 2011 07:15:22 -0800 (PST)
Date: Thu, 3 Feb 2011 00:15:52 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] tm6000: add new TV cards of Beholder
Message-ID: <20110203001552.3fc3f897@glory.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/sPAwDOfLZnaMOC2H3FFkgdC"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--MP_/sPAwDOfLZnaMOC2H3FFkgdC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Add two new TV cards of Beholder.

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 455038b..d25fd5e 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -50,6 +50,8 @@
 #define TM6010_BOARD_BEHOLD_VOYAGER		11
 #define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE	12
 #define TM6010_BOARD_TWINHAN_TU501		13
+#define TM6010_BOARD_BEHOLD_WANDER_LITE		14
+#define TM6010_BOARD_BEHOLD_VOYAGER_LITE	15
 
 #define TM6000_MAXBOARDS        16
 static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };
@@ -303,6 +305,40 @@ struct tm6000_board tm6000_boards[] = {
 			.dvb_led	= TM6010_GPIO_5,
 			.ir		= TM6010_GPIO_0,
 		},
+	},
+	[TM6010_BOARD_BEHOLD_WANDER_LITE] = {
+		.name         = "Beholder Wander Lite DVB-T/TV/FM USB2.0",
+		.tuner_type   = TUNER_XC5000,
+		.tuner_addr   = 0xc2 >> 1,
+		.demod_addr   = 0x1e >> 1,
+		.type         = TM6010,
+		.caps = {
+			.has_tuner    = 1,
+			.has_dvb      = 1,
+			.has_zl10353  = 1,
+			.has_eeprom   = 1,
+		},
+		.gpio = {
+			.tuner_reset	= TM6010_GPIO_0,
+			.demod_reset	= TM6010_GPIO_1,
+			.power_led	= TM6010_GPIO_6,
+		},
+	},
+	[TM6010_BOARD_BEHOLD_VOYAGER_LITE] = {
+		.name         = "Beholder Voyager Lite TV/FM USB2.0",
+		.tuner_type   = TUNER_XC5000,
+		.tuner_addr   = 0xc2 >> 1,
+		.type         = TM6010,
+		.caps = {
+			.has_tuner    = 1,
+			.has_dvb      = 0,
+			.has_zl10353  = 0,
+			.has_eeprom   = 1,
+		},
+		.gpio = {
+			.tuner_reset	= TM6010_GPIO_0,
+			.power_led	= TM6010_GPIO_6,
+		},
 	}
 };
 
@@ -325,6 +361,8 @@ struct usb_device_id tm6000_id_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3241), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
 	{ USB_DEVICE(0x13d3, 0x3243), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
 	{ USB_DEVICE(0x13d3, 0x3264), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
+	{ USB_DEVICE(0x6000, 0xdec2), .driver_info = TM6010_BOARD_BEHOLD_WANDER_LITE },
+	{ USB_DEVICE(0x6000, 0xdec3), .driver_info = TM6010_BOARD_BEHOLD_VOYAGER_LITE },
 	{ },
 };
 
@@ -346,6 +384,8 @@ void tm6000_flash_led(struct tm6000_core *dev, u8 state)
 			break;
 		case TM6010_BOARD_BEHOLD_WANDER:
 		case TM6010_BOARD_BEHOLD_VOYAGER:
+		case TM6010_BOARD_BEHOLD_WANDER_LITE:
+		case TM6010_BOARD_BEHOLD_VOYAGER_LITE:
 			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 				dev->gpio.power_led, 0x01);
 			break;
@@ -362,6 +402,8 @@ void tm6000_flash_led(struct tm6000_core *dev, u8 state)
 			break;
 		case TM6010_BOARD_BEHOLD_WANDER:
 		case TM6010_BOARD_BEHOLD_VOYAGER:
+		case TM6010_BOARD_BEHOLD_WANDER_LITE:
+		case TM6010_BOARD_BEHOLD_VOYAGER_LITE:
 			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 				dev->gpio.power_led, 0x00);
 			break;
@@ -520,6 +562,7 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 		msleep(15);
 		break;
 	case TM6010_BOARD_BEHOLD_WANDER:
+	case TM6010_BOARD_BEHOLD_WANDER_LITE:
 		/* Power led on (blue) */
 		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.power_led, 0x01);
 		msleep(15);
@@ -530,6 +573,7 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 		msleep(15);
 		break;
 	case TM6010_BOARD_BEHOLD_VOYAGER:
+	case TM6010_BOARD_BEHOLD_VOYAGER_LITE:
 		/* Power led on (blue) */
 		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.power_led, 0x01);
 		msleep(15);
@@ -957,6 +1001,8 @@ static void tm6000_usb_disconnect(struct usb_interface *interface)
 			break;
 		case TM6010_BOARD_BEHOLD_WANDER:
 		case TM6010_BOARD_BEHOLD_VOYAGER:
+		case TM6010_BOARD_BEHOLD_WANDER_LITE:
+		case TM6010_BOARD_BEHOLD_VOYAGER_LITE:
 			/* Power led off */
 			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 				dev->gpio.power_led, 0x00);

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
--MP_/sPAwDOfLZnaMOC2H3FFkgdC
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6000_behold_add_card.patch

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 455038b..d25fd5e 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -50,6 +50,8 @@
 #define TM6010_BOARD_BEHOLD_VOYAGER		11
 #define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE	12
 #define TM6010_BOARD_TWINHAN_TU501		13
+#define TM6010_BOARD_BEHOLD_WANDER_LITE		14
+#define TM6010_BOARD_BEHOLD_VOYAGER_LITE	15
 
 #define TM6000_MAXBOARDS        16
 static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };
@@ -303,6 +305,40 @@ struct tm6000_board tm6000_boards[] = {
 			.dvb_led	= TM6010_GPIO_5,
 			.ir		= TM6010_GPIO_0,
 		},
+	},
+	[TM6010_BOARD_BEHOLD_WANDER_LITE] = {
+		.name         = "Beholder Wander Lite DVB-T/TV/FM USB2.0",
+		.tuner_type   = TUNER_XC5000,
+		.tuner_addr   = 0xc2 >> 1,
+		.demod_addr   = 0x1e >> 1,
+		.type         = TM6010,
+		.caps = {
+			.has_tuner    = 1,
+			.has_dvb      = 1,
+			.has_zl10353  = 1,
+			.has_eeprom   = 1,
+		},
+		.gpio = {
+			.tuner_reset	= TM6010_GPIO_0,
+			.demod_reset	= TM6010_GPIO_1,
+			.power_led	= TM6010_GPIO_6,
+		},
+	},
+	[TM6010_BOARD_BEHOLD_VOYAGER_LITE] = {
+		.name         = "Beholder Voyager Lite TV/FM USB2.0",
+		.tuner_type   = TUNER_XC5000,
+		.tuner_addr   = 0xc2 >> 1,
+		.type         = TM6010,
+		.caps = {
+			.has_tuner    = 1,
+			.has_dvb      = 0,
+			.has_zl10353  = 0,
+			.has_eeprom   = 1,
+		},
+		.gpio = {
+			.tuner_reset	= TM6010_GPIO_0,
+			.power_led	= TM6010_GPIO_6,
+		},
 	}
 };
 
@@ -325,6 +361,8 @@ struct usb_device_id tm6000_id_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3241), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
 	{ USB_DEVICE(0x13d3, 0x3243), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
 	{ USB_DEVICE(0x13d3, 0x3264), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
+	{ USB_DEVICE(0x6000, 0xdec2), .driver_info = TM6010_BOARD_BEHOLD_WANDER_LITE },
+	{ USB_DEVICE(0x6000, 0xdec3), .driver_info = TM6010_BOARD_BEHOLD_VOYAGER_LITE },
 	{ },
 };
 
@@ -346,6 +384,8 @@ void tm6000_flash_led(struct tm6000_core *dev, u8 state)
 			break;
 		case TM6010_BOARD_BEHOLD_WANDER:
 		case TM6010_BOARD_BEHOLD_VOYAGER:
+		case TM6010_BOARD_BEHOLD_WANDER_LITE:
+		case TM6010_BOARD_BEHOLD_VOYAGER_LITE:
 			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 				dev->gpio.power_led, 0x01);
 			break;
@@ -362,6 +402,8 @@ void tm6000_flash_led(struct tm6000_core *dev, u8 state)
 			break;
 		case TM6010_BOARD_BEHOLD_WANDER:
 		case TM6010_BOARD_BEHOLD_VOYAGER:
+		case TM6010_BOARD_BEHOLD_WANDER_LITE:
+		case TM6010_BOARD_BEHOLD_VOYAGER_LITE:
 			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 				dev->gpio.power_led, 0x00);
 			break;
@@ -520,6 +562,7 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 		msleep(15);
 		break;
 	case TM6010_BOARD_BEHOLD_WANDER:
+	case TM6010_BOARD_BEHOLD_WANDER_LITE:
 		/* Power led on (blue) */
 		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.power_led, 0x01);
 		msleep(15);
@@ -530,6 +573,7 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 		msleep(15);
 		break;
 	case TM6010_BOARD_BEHOLD_VOYAGER:
+	case TM6010_BOARD_BEHOLD_VOYAGER_LITE:
 		/* Power led on (blue) */
 		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.power_led, 0x01);
 		msleep(15);
@@ -957,6 +1001,8 @@ static void tm6000_usb_disconnect(struct usb_interface *interface)
 			break;
 		case TM6010_BOARD_BEHOLD_WANDER:
 		case TM6010_BOARD_BEHOLD_VOYAGER:
+		case TM6010_BOARD_BEHOLD_WANDER_LITE:
+		case TM6010_BOARD_BEHOLD_VOYAGER_LITE:
 			/* Power led off */
 			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 				dev->gpio.power_led, 0x00);

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/sPAwDOfLZnaMOC2H3FFkgdC--
