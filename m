Return-path: <mchehab@gaivota>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:58294 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0LPIit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 03:38:49 -0500
Received: by eyg5 with SMTP id 5so1764925eyg.2
        for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 00:38:47 -0800 (PST)
Date: Thu, 16 Dec 2010 18:38:44 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Felipe Sanches <juca@members.fsf.org>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 and IR
Message-ID: <20101216183844.6258734e@glory.local>
In-Reply-To: <4D08E43C.8080002@arcor.de>
References: <4CAD5A78.3070803@redhat.com>
	<20101008150301.2e3ceaff@glory.local>
	<4CAF0602.6050002@redhat.com>
	<20101012142856.2b4ee637@glory.local>
	<4CB492D4.1000609@arcor.de>
	<20101129174412.08f2001c@glory.local>
	<4CF51C9E.6040600@arcor.de>
	<20101201144704.43b58f2c@glory.local>
	<4CF67AB9.6020006@arcor.de>
	<20101202134128.615bbfa0@glory.local>
	<4CF71CF6.7080603@redhat.com>
	<20101206010934.55d07569@glory.local>
	<4CFBF62D.7010301@arcor.de>
	<20101206190230.2259d7ab@glory.local>
	<4CFEA3D2.4050309@arcor.de>
	<20101208125539.739e2ed2@glory.local>
	<4CFFAD1E.7040004@arcor.de>
	<20101214122325.5cdea67e@glory.local>
	<4D079ADF.2000705@arcor.de>
	<20101215164634.44846128@glory.local>
	<4D08E43C.8080002@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/wT4H8/YDoAalaUswDQ8xfMV"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

--MP_/wT4H8/YDoAalaUswDQ8xfMV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

> > I think your mean is wrong. Our IR remotes send extended NEC it is
> > 4 bytes. We removed inverted 4 byte and now we have 3 bytes from
> > remotes. I think we must have full RCMAP with this 3 bytes from
> > remotes. And use this remotes with some different IR recievers like
> > some TV cards and LIRC-hardware and other. No need different RCMAP
> > for the same remotes to different IR recievers like now.
> Your change doesn't work with my terratec remote control !!

I found what happens. Try my new patch.

What about NEC. Original NEC send
address (inverted address) key (inverted key)
this is realy old standart now all remotes use extended NEC 
(adress high) (address low) key (inverted key)
The trident 5600/6000/6010 use old protocol but didn't test inverted address byte.

I think much better discover really address value and write it to keytable.
For your remotes I add low address byte. This value is incorrent but usefull for tm6000.
When you found correct value update keytable.

> >> Then the function call usb_set_interface in tm6000_video, can write
> >> for example:
> >>
> >> stop_ir_pipe
> >> usb_set_interface
> >> start_ir_pipe
> > Ok, I'll try.

See dmesg. I was add function for start/stop interrupt urbs
All works well.

With my best regards, Dmitry.

--MP_/wT4H8/YDoAalaUswDQ8xfMV
Content-Type: text/x-c++src
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=rc-behold-wander.c

/* behold-wander.h - Keytable for behold_wander Remote Controller
 *
 * keymap imported from ir-keymaps.c
 *
 * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

#include <media/rc-map.h>

/* Beholder Intl. Ltd. 2010
 * Dmitry Belimov d.belimov@google.com
 * Keytable is used by BeholdTV Wander/Voyage
 * The "ascii-art picture" below (in comments, first row
 * is the keycode in hex, and subsequent row(s) shows
 * the button labels (several variants when appropriate)
 * helps to descide which keycodes to assign to the buttons.
 */

static struct rc_map_table behold_wander[] = {

	/*  0x13   0x11   0x1C   0x12  *
	 *  Mute  Source  TV/FM  Power *
	 *                             */

	{ 0x866b13, KEY_MUTE },
	{ 0x866b11, KEY_PROPS },
	{ 0x866b1C, KEY_TUNER },	/* KEY_TV/KEY_RADIO	*/
	{ 0x866b12, KEY_POWER },

	/*  0x01    0x02    0x03  0x0D    *
	 *   1       2       3   Stereo   *
	 *                        	  *
	 *  0x04    0x05    0x06  0x19    *
	 *   4       5       6   Snapshot *
	 *                        	  *
	 *  0x07    0x08    0x09  0x10    *
	 *   7       8       9    Zoom 	  *
	 *                                */
	{ 0x866b01, KEY_1 },
	{ 0x866b02, KEY_2 },
	{ 0x866b03, KEY_3 },
	{ 0x866b0D, KEY_SETUP },	  /* Setup key */
	{ 0x866b04, KEY_4 },
	{ 0x866b05, KEY_5 },
	{ 0x866b06, KEY_6 },
	{ 0x866b19, KEY_CAMERA },	/* Snapshot key */
	{ 0x866b07, KEY_7 },
	{ 0x866b08, KEY_8 },
	{ 0x866b09, KEY_9 },
	{ 0x866b10, KEY_ZOOM },

	/*  0x0A    0x00    0x0B       0x0C   *
	 * RECALL    0    ChannelUp  VolumeUp *
	 *                                    */
	{ 0x866b0A, KEY_AGAIN },
	{ 0x866b00, KEY_0 },
	{ 0x866b0B, KEY_CHANNELUP },
	{ 0x866b0C, KEY_VOLUMEUP },

	/*   0x1B      0x1D      0x15        0x18     *
	 * Timeshift  Record  ChannelDown  VolumeDown *
	 *                                            */

	{ 0x866b1B, KEY_TIME },
	{ 0x866b1D, KEY_RECORD },
	{ 0x866b15, KEY_CHANNELDOWN },
	{ 0x866b18, KEY_VOLUMEDOWN },

	/*   0x0E   0x1E     0x0F     0x1A  *
	 *   Stop   Pause  Previouse  Next  *
	 *                                  */

	{ 0x866b0E, KEY_STOP },
	{ 0x866b1E, KEY_PAUSE },
	{ 0x866b0F, KEY_PREVIOUS },
	{ 0x866b1A, KEY_NEXT },

};

static struct rc_map_list behold_wander_map = {
	.map = {
		.scan    = behold_wander,
		.size    = ARRAY_SIZE(behold_wander),
		.rc_type = RC_TYPE_NEC,	/* Legacy IR type */
		.name    = RC_MAP_BEHOLD_WANDER,
	}
};

static int __init init_rc_map_behold_wander(void)
{
	return rc_map_register(&behold_wander_map);
}

static void __exit exit_rc_map_behold_wander(void)
{
	rc_map_unregister(&behold_wander_map);
}

module_init(init_rc_map_behold_wander)
module_exit(exit_rc_map_behold_wander)

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");

--MP_/wT4H8/YDoAalaUswDQ8xfMV
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6000_ir_behold_04.diff

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 3194d39..cf7622f 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-azurewave-ad-tu700.o \
 			rc-behold.o \
 			rc-behold-columbus.o \
+			rc-behold-wander.o \
 			rc-budget-ci-old.o \
 			rc-cinergy-1400.o \
 			rc-cinergy.o \
diff --git a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
index 26f114c..bbcb698 100644
--- a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
@@ -14,69 +14,76 @@
 
 /* Terratec Cinergy Hybrid T USB XS FM
    Mauro Carvalho Chehab <mchehab@redhat.com>
+
+   TODO: This IR remote use extended NEC protocol
+         the tm6000 can read only 1 and 3 bytes of them
+         the 4 byte is invert of the 3 byte. We unknown the 2 byte.
+         Need test this remotes with much better IR receiver
+         and determine the 2 byte. Now the 2 byte is 0xff for compatibility.
+                             Dmitry Belimov <d.belimov@gmail.com>
  */
 
 static struct rc_map_table nec_terratec_cinergy_xs[] = {
-	{ 0x1441, KEY_HOME},
-	{ 0x1401, KEY_POWER2},
-
-	{ 0x1442, KEY_MENU},		/* DVD menu */
-	{ 0x1443, KEY_SUBTITLE},
-	{ 0x1444, KEY_TEXT},		/* Teletext */
-	{ 0x1445, KEY_DELETE},
-
-	{ 0x1402, KEY_1},
-	{ 0x1403, KEY_2},
-	{ 0x1404, KEY_3},
-	{ 0x1405, KEY_4},
-	{ 0x1406, KEY_5},
-	{ 0x1407, KEY_6},
-	{ 0x1408, KEY_7},
-	{ 0x1409, KEY_8},
-	{ 0x140a, KEY_9},
-	{ 0x140c, KEY_0},
-
-	{ 0x140b, KEY_TUNER},		/* AV */
-	{ 0x140d, KEY_MODE},		/* A.B */
-
-	{ 0x1446, KEY_TV},
-	{ 0x1447, KEY_DVD},
-	{ 0x1449, KEY_VIDEO},
-	{ 0x144a, KEY_RADIO},		/* Music */
-	{ 0x144b, KEY_CAMERA},		/* PIC */
-
-	{ 0x1410, KEY_UP},
-	{ 0x1411, KEY_LEFT},
-	{ 0x1412, KEY_OK},
-	{ 0x1413, KEY_RIGHT},
-	{ 0x1414, KEY_DOWN},
-
-	{ 0x140f, KEY_EPG},
-	{ 0x1416, KEY_INFO},
-	{ 0x144d, KEY_BACKSPACE},
-
-	{ 0x141c, KEY_VOLUMEUP},
-	{ 0x141e, KEY_VOLUMEDOWN},
-
-	{ 0x144c, KEY_PLAY},
-	{ 0x141d, KEY_MUTE},
-
-	{ 0x141b, KEY_CHANNELUP},
-	{ 0x141f, KEY_CHANNELDOWN},
-
-	{ 0x1417, KEY_RED},
-	{ 0x1418, KEY_GREEN},
-	{ 0x1419, KEY_YELLOW},
-	{ 0x141a, KEY_BLUE},
-
-	{ 0x1458, KEY_RECORD},
-	{ 0x1448, KEY_STOP},
-	{ 0x1440, KEY_PAUSE},
-
-	{ 0x1454, KEY_LAST},
-	{ 0x144e, KEY_REWIND},
-	{ 0x144f, KEY_FASTFORWARD},
-	{ 0x145c, KEY_NEXT},
+	{ 0x14ff41, KEY_HOME},
+	{ 0x14ff01, KEY_POWER2},
+
+	{ 0x14ff42, KEY_MENU},		/* DVD menu */
+	{ 0x14ff43, KEY_SUBTITLE},
+	{ 0x14ff44, KEY_TEXT},		/* Teletext */
+	{ 0x14ff45, KEY_DELETE},
+
+	{ 0x14ff02, KEY_1},
+	{ 0x14ff03, KEY_2},
+	{ 0x14ff04, KEY_3},
+	{ 0x14ff05, KEY_4},
+	{ 0x14ff06, KEY_5},
+	{ 0x14ff07, KEY_6},
+	{ 0x14ff08, KEY_7},
+	{ 0x14ff09, KEY_8},
+	{ 0x14ff0a, KEY_9},
+	{ 0x14ff0c, KEY_0},
+
+	{ 0x14ff0b, KEY_TUNER},		/* AV */
+	{ 0x14ff0d, KEY_MODE},		/* A.B */
+
+	{ 0x14ff46, KEY_TV},
+	{ 0x14ff47, KEY_DVD},
+	{ 0x14ff49, KEY_VIDEO},
+	{ 0x14ff4a, KEY_RADIO},		/* Music */
+	{ 0x14ff4b, KEY_CAMERA},		/* PIC */
+
+	{ 0x14ff10, KEY_UP},
+	{ 0x14ff11, KEY_LEFT},
+	{ 0x14ff12, KEY_OK},
+	{ 0x14ff13, KEY_RIGHT},
+	{ 0x14ff14, KEY_DOWN},
+
+	{ 0x14ff0f, KEY_EPG},
+	{ 0x14ff16, KEY_INFO},
+	{ 0x14ff4d, KEY_BACKSPACE},
+
+	{ 0x14ff1c, KEY_VOLUMEUP},
+	{ 0x14ff1e, KEY_VOLUMEDOWN},
+
+	{ 0x14ff4c, KEY_PLAY},
+	{ 0x14ff1d, KEY_MUTE},
+
+	{ 0x14ff1b, KEY_CHANNELUP},
+	{ 0x14ff1f, KEY_CHANNELDOWN},
+
+	{ 0x14ff17, KEY_RED},
+	{ 0x14ff18, KEY_GREEN},
+	{ 0x14ff19, KEY_YELLOW},
+	{ 0x14ff1a, KEY_BLUE},
+
+	{ 0x14ff58, KEY_RECORD},
+	{ 0x14ff48, KEY_STOP},
+	{ 0x14ff40, KEY_PAUSE},
+
+	{ 0x14ff54, KEY_LAST},
+	{ 0x14ff4e, KEY_REWIND},
+	{ 0x14ff4f, KEY_FASTFORWARD},
+	{ 0x14ff5c, KEY_NEXT},
 };
 
 static struct rc_map_list nec_terratec_cinergy_xs_map = {
diff --git a/drivers/staging/tm6000/TODO b/drivers/staging/tm6000/TODO
index 34780fc..135d0ea 100644
--- a/drivers/staging/tm6000/TODO
+++ b/drivers/staging/tm6000/TODO
@@ -1,4 +1,6 @@
 There a few things to do before putting this driver in production:
+	- IR NEC with tm5600/6000 TV cards
+	- IR RC5 with tm5600/6000/6010 TV cards
 	- CodingStyle;
 	- Fix audio;
 	- Fix some panic/OOPS conditions.
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 1c9374a..59ee241 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -239,6 +239,7 @@ struct tm6000_board tm6000_boards[] = {
 			.demod_reset	= TM6010_GPIO_1,
 			.power_led	= TM6010_GPIO_6,
 		},
+		.ir_codes = RC_MAP_BEHOLD_WANDER,
 	},
 	[TM6010_BOARD_BEHOLD_VOYAGER] = {
 		.name         = "Beholder Voyager TV/FM USB2.0",
@@ -256,6 +257,7 @@ struct tm6000_board tm6000_boards[] = {
 			.tuner_reset	= TM6010_GPIO_0,
 			.power_led	= TM6010_GPIO_6,
 		},
+		.ir_codes = RC_MAP_BEHOLD_WANDER,
 	},
 	[TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE] = {
 		.name         = "Terratec Cinergy Hybrid XE / Cinergy Hybrid-Stick",
@@ -328,6 +330,47 @@ struct usb_device_id tm6000_id_table[] = {
 	{ },
 };
 
+/* Control power led for show some activity */
+void tm6000_flash_led(struct tm6000_core *dev, u8 state)
+{
+	/* Power LED unconfigured */
+	if (!dev->gpio.power_led)
+		return;
+
+	/* ON Power LED */
+	if (state) {
+		switch (dev->model) {
+		case TM6010_BOARD_HAUPPAUGE_900H:
+		case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+		case TM6010_BOARD_TWINHAN_TU501:
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				dev->gpio.power_led, 0x00);
+			break;
+		case TM6010_BOARD_BEHOLD_WANDER:
+		case TM6010_BOARD_BEHOLD_VOYAGER:
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				dev->gpio.power_led, 0x01);
+			break;
+		}
+	}
+	/* OFF Power LED */
+	else {
+		switch (dev->model) {
+		case TM6010_BOARD_HAUPPAUGE_900H:
+		case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+		case TM6010_BOARD_TWINHAN_TU501:
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				dev->gpio.power_led, 0x01);
+			break;
+		case TM6010_BOARD_BEHOLD_WANDER:
+		case TM6010_BOARD_BEHOLD_VOYAGER:
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				dev->gpio.power_led, 0x00);
+			break;
+		}
+	}
+}
+
 /* Tuner callback to provide the proper gpio changes needed for xc5000 */
 int tm6000_xc5000_callback(void *ptr, int component, int command, int arg)
 {
diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index e02ea67..cae1f96 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -37,6 +37,10 @@ static unsigned int enable_ir = 1;
 module_param(enable_ir, int, 0644);
 MODULE_PARM_DESC(enable_ir, "enable ir (default is enable)");
 
+/* number of 50ms for ON-OFF-ON power led */
+/* show IR activity */
+#define PWLED_OFF 2
+
 #undef dprintk
 
 #define dprintk(fmt, arg...) \
@@ -45,7 +49,7 @@ MODULE_PARM_DESC(enable_ir, "enable ir (default is enable)");
 	}
 
 struct tm6000_ir_poll_result {
-	u16 rc_data;
+	u32 rc_data;
 };
 
 struct tm6000_IR {
@@ -59,6 +63,9 @@ struct tm6000_IR {
 	struct delayed_work	work;
 	u8			wait:1;
 	u8			key:1;
+	u8			pwled:1;
+	u8			pwledcnt;
+	u16			key_addr;
 	struct urb		*int_urb;
 	u8			*urb_data;
 
@@ -89,26 +96,49 @@ static int tm6000_ir_config(struct tm6000_IR *ir)
 	u8 buf[10];
 	int rc;
 
-	/* hack */
-	buf[0] = 0xff;
-	buf[1] = 0xff;
-	buf[2] = 0xf2;
-	buf[3] = 0x2b;
-	buf[4] = 0x20;
-	buf[5] = 0x35;
-	buf[6] = 0x60;
-	buf[7] = 0x04;
-	buf[8] = 0xc0;
-	buf[9] = 0x08;
-
-	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
-		USB_RECIP_DEVICE, REQ_00_SET_IR_VALUE, 0, 0, buf, 0x0a);
-	msleep(100);
-
-	if (rc < 0) {
-		printk(KERN_INFO "IR configuration failed");
-		return rc;
+	switch (ir->rc_type) {
+	case RC_TYPE_NEC:
+		/* Setup IR decoder for NEC standard 12MHz system clock */
+		/* IR_LEADER_CNT = 0.9ms             */
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_LEADER1, 0xaa);
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_LEADER0, 0x30);
+		/* IR_PULSE_CNT = 0.7ms              */
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_PULSE_CNT1, 0x20);
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_PULSE_CNT0, 0xd0);
+		/* Remote WAKEUP = enable */
+		tm6000_set_reg(dev, TM6010_REQ07_RE5_REMOTE_WAKEUP, 0xfe);
+		/* IR_WKUP_SEL = Low byte in decoded IR data */
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_WAKEUP_SEL, 0xff);
+		/* IR_WKU_ADD code */
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_WAKEUP_ADD, 0xff);
+		tm6000_flash_led(dev, 0);
+		msleep(100);
+		tm6000_flash_led(dev, 1);
+		break;
+	default:
+		/* hack */
+		buf[0] = 0xff;
+		buf[1] = 0xff;
+		buf[2] = 0xf2;
+		buf[3] = 0x2b;
+		buf[4] = 0x20;
+		buf[5] = 0x35;
+		buf[6] = 0x60;
+		buf[7] = 0x04;
+		buf[8] = 0xc0;
+		buf[9] = 0x08;
+
+		rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_00_SET_IR_VALUE, 0, 0, buf, 0x0a);
+		msleep(100);
+
+		if (rc < 0) {
+			printk(KERN_INFO "IR configuration failed");
+			return rc;
+		}
+		break;
 	}
+
 	return 0;
 }
 
@@ -143,10 +173,21 @@ static int default_polling_getkey(struct tm6000_IR *ir,
 		return 0;
 
 	if (&dev->int_in) {
-		if (ir->rc_type == RC_TYPE_RC5)
+		switch (ir->rc_type) {
+		case RC_TYPE_RC5:
 			poll_result->rc_data = ir->urb_data[0];
-		else
-			poll_result->rc_data = ir->urb_data[0] | ir->urb_data[1] << 8;
+			break;
+		case RC_TYPE_NEC:
+			if (ir->urb_data[1] == ((ir->key_addr >> 8) & 0xff)) {
+				poll_result->rc_data = ir->urb_data[0]
+							| ir->key_addr << 8;
+			}
+			break;
+		default:
+			poll_result->rc_data = ir->urb_data[0]
+					| ir->urb_data[1] << 8;
+			break;
+		}
 	} else {
 		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 0);
 		msleep(10);
@@ -186,6 +227,7 @@ static int default_polling_getkey(struct tm6000_IR *ir,
 
 static void tm6000_ir_handle_key(struct tm6000_IR *ir)
 {
+	struct tm6000_core *dev = ir->dev;
 	int result;
 	struct tm6000_ir_poll_result poll_result;
 
@@ -198,9 +240,22 @@ static void tm6000_ir_handle_key(struct tm6000_IR *ir)
 
 	dprintk("ir->get_key result data=%04x\n", poll_result.rc_data);
 
+	if (ir->pwled) {
+		if (ir->pwledcnt >= PWLED_OFF) {
+			ir->pwled = 0;
+			ir->pwledcnt = 0;
+			tm6000_flash_led(dev, 1);
+		}
+		else
+			ir->pwledcnt += 1;
+	}
+
 	if (ir->key) {
 		rc_keydown(ir->rc, poll_result.rc_data, 0);
 		ir->key = 0;
+		ir->pwled = 1;
+		ir->pwledcnt = 0;
+		tm6000_flash_led(dev, 0);
 	}
 	return;
 }
@@ -234,19 +289,80 @@ int tm6000_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 {
 	struct tm6000_IR *ir = rc->priv;
 
+	if (!ir)
+		return 0;
+
+	if ((rc->rc_map.scan) && (rc_type == RC_TYPE_NEC))
+		ir->key_addr = ((rc->rc_map.scan[0].scancode >> 8) & 0xffff);
+
 	ir->get_key = default_polling_getkey;
+	ir->rc_type = rc_type;
 
 	tm6000_ir_config(ir);
 	/* TODO */
 	return 0;
 }
 
+int tm6000_ir_int_start(struct tm6000_core *dev)
+{
+	struct tm6000_IR *ir = dev->ir;
+	int pipe, size;
+	int err = -ENOMEM;
+
+
+	if (!ir)
+		return -ENODEV;
+
+	ir->int_urb = usb_alloc_urb(0, GFP_KERNEL);
+
+	pipe = usb_rcvintpipe(dev->udev,
+		dev->int_in.endp->desc.bEndpointAddress
+		& USB_ENDPOINT_NUMBER_MASK);
+
+	size = usb_maxpacket(dev->udev, pipe, usb_pipeout(pipe));
+	dprintk("IR max size: %d\n", size);
+
+	ir->int_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
+	if (ir->int_urb->transfer_buffer == NULL) {
+		usb_free_urb(ir->int_urb);
+		return err;
+	}
+	dprintk("int interval: %d\n", dev->int_in.endp->desc.bInterval);
+	usb_fill_int_urb(ir->int_urb, dev->udev, pipe,
+		ir->int_urb->transfer_buffer, size,
+		tm6000_ir_urb_received, dev,
+		dev->int_in.endp->desc.bInterval);
+	err = usb_submit_urb(ir->int_urb, GFP_KERNEL);
+	if (err) {
+		kfree(ir->int_urb->transfer_buffer);
+		usb_free_urb(ir->int_urb);
+		return err;
+	}
+	ir->urb_data = kzalloc(size, GFP_KERNEL);
+
+	return 0;
+}
+
+void tm6000_ir_int_stop(struct tm6000_core *dev)
+{
+	struct tm6000_IR *ir = dev->ir;
+
+	if (!ir)
+		return;
+
+	usb_kill_urb(ir->int_urb);
+	kfree(ir->int_urb->transfer_buffer);
+	usb_free_urb(ir->int_urb);
+	ir->int_urb = NULL;
+	kfree(ir->urb_data);
+	ir->urb_data = NULL;
+}
+
 int tm6000_ir_init(struct tm6000_core *dev)
 {
 	struct tm6000_IR *ir;
 	struct rc_dev *rc;
 	int err = -ENOMEM;
-	int pipe, size;
 
 	if (!enable_ir)
 		return -ENODEV;
@@ -276,6 +392,9 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	rc->driver_type = RC_DRIVER_SCANCODE;
 
 	ir->polling = 50;
+	ir->pwled = 0;
+	ir->pwledcnt = 0;
+
 
 	snprintf(ir->name, sizeof(ir->name), "tm5600/60x0 IR (%s)",
 						dev->name);
@@ -298,32 +417,10 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	if (&dev->int_in) {
 		dprintk("IR over int\n");
 
-		ir->int_urb = usb_alloc_urb(0, GFP_KERNEL);
-
-		pipe = usb_rcvintpipe(dev->udev,
-			dev->int_in.endp->desc.bEndpointAddress
-			& USB_ENDPOINT_NUMBER_MASK);
+		err = tm6000_ir_int_start(dev);
 
-		size = usb_maxpacket(dev->udev, pipe, usb_pipeout(pipe));
-		dprintk("IR max size: %d\n", size);
-
-		ir->int_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
-		if (ir->int_urb->transfer_buffer == NULL) {
-			usb_free_urb(ir->int_urb);
-			goto out;
-		}
-		dprintk("int interval: %d\n", dev->int_in.endp->desc.bInterval);
-		usb_fill_int_urb(ir->int_urb, dev->udev, pipe,
-			ir->int_urb->transfer_buffer, size,
-			tm6000_ir_urb_received, dev,
-			dev->int_in.endp->desc.bInterval);
-		err = usb_submit_urb(ir->int_urb, GFP_KERNEL);
-		if (err) {
-			kfree(ir->int_urb->transfer_buffer);
-			usb_free_urb(ir->int_urb);
+		if (err)
 			goto out;
-		}
-		ir->urb_data = kzalloc(size, GFP_KERNEL);
 	}
 
 	/* ir register */
@@ -352,12 +449,7 @@ int tm6000_ir_fini(struct tm6000_core *dev)
 	rc_unregister_device(ir->rc);
 
 	if (ir->int_urb) {
-		usb_kill_urb(ir->int_urb);
-		kfree(ir->int_urb->transfer_buffer);
-		usb_free_urb(ir->int_urb);
-		ir->int_urb = NULL;
-		kfree(ir->urb_data);
-		ir->urb_data = NULL;
+		tm6000_ir_int_stop(dev);
 	}
 
 	kfree(ir);
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index c5690b2..b06701b 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -545,11 +545,16 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev, unsigned int framesize)
 
 	/* De-allocates all pending stuff */
 	tm6000_uninit_isoc(dev);
+	/* Stop interrupt USB pipe */
+	tm6000_ir_int_stop(dev);
 
 	usb_set_interface(dev->udev,
 			  dev->isoc_in.bInterfaceNumber,
 			  dev->isoc_in.bAlternateSetting);
 
+	/* Start interrupt USB pipe */
+	tm6000_ir_int_start(dev);
+
 	pipe = usb_rcvisocpipe(dev->udev,
 			       dev->isoc_in.endp->desc.bEndpointAddress &
 			       USB_ENDPOINT_NUMBER_MASK);
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 46017b6..bf11eee 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -266,6 +266,7 @@ struct tm6000_fh {
 int tm6000_tuner_callback(void *ptr, int component, int command, int arg);
 int tm6000_xc5000_callback(void *ptr, int component, int command, int arg);
 int tm6000_cards_setup(struct tm6000_core *dev);
+void tm6000_flash_led(struct tm6000_core *dev, u8 state);
 
 /* In tm6000-core.c */
 
@@ -332,6 +333,8 @@ int tm6000_queue_init(struct tm6000_core *dev);
 int tm6000_ir_init(struct tm6000_core *dev);
 int tm6000_ir_fini(struct tm6000_core *dev);
 void tm6000_ir_wait(struct tm6000_core *dev, u8 state);
+int tm6000_ir_int_start(struct tm6000_core *dev);
+void tm6000_ir_int_stop(struct tm6000_core *dev);
 
 /* Debug stuff */
 
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 1a3d51d..239a309 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -70,6 +70,7 @@ void rc_map_init(void);
 #define RC_MAP_AVERTV_303                "rc-avertv-303"
 #define RC_MAP_AZUREWAVE_AD_TU700        "rc-azurewave-ad-tu700"
 #define RC_MAP_BEHOLD_COLUMBUS           "rc-behold-columbus"
+#define RC_MAP_BEHOLD_WANDER             "rc-behold-wander"
 #define RC_MAP_BEHOLD                    "rc-behold"
 #define RC_MAP_BUDGET_CI_OLD             "rc-budget-ci-old"
 #define RC_MAP_CINERGY_1400              "rc-cinergy-1400"

--MP_/wT4H8/YDoAalaUswDQ8xfMV--
