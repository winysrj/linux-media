Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43744 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab0FOQUm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jun 2010 12:20:42 -0400
Received: by bwz7 with SMTP id 7so2784200bwz.19
        for <linux-media@vger.kernel.org>; Tue, 15 Jun 2010 09:20:40 -0700 (PDT)
Received: from rz by localhost.localdomain with local (Exim 4.69)
	(envelope-from <rz@linux-m68k.org>)
	id 1OOYun-0001vq-Cf
	for linux-media@vger.kernel.org; Tue, 15 Jun 2010 18:23:05 +0200
Date: Tue, 15 Jun 2010 18:23:05 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] support for Hauppauge WinTV MiniStic IR remote
Message-ID: <20100615162305.GA4585@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have guessed which gpio line to use and activated the ir-remote receiver.
The keymap seems to work fairly well with the supplied DSR-0112 remote, mostly
tested it with xev as I do not have a working lircd on this computer.

The patch is against 2.6.34.

Richard

Jun 15 16:46:27 localhost kernel: [24399.381936] usb 5-6: New USB device found, idVendor=2040, idProduct=5500
Jun 15 16:46:27 localhost kernel: [24399.381939] usb 5-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Jun 15 16:46:27 localhost kernel: [24399.381941] usb 5-6: Product: WinTV MiniStick
Jun 15 16:46:27 localhost kernel: [24399.381943] usb 5-6: Manufacturer: Hauppauge Computer Works
Jun 15 16:46:27 localhost kernel: [24399.381945] usb 5-6: SerialNumber: f069684c
Jun 15 16:46:27 localhost kernel: [24399.384194] usb 5-6: firmware: requesting sms1xxx-hcw-55xxx-dvbt-02.fw
Jun 15 16:46:28 localhost kernel: [24400.000075] smscore_set_device_mode: firmware download success: sms1xxx-hcw-55
xxx-dvbt-02.fw
Jun 15 16:46:28 localhost kernel: [24400.000303] DVB: registering new adapter (Hauppauge WinTV MiniStick)
Jun 15 16:46:28 localhost kernel: [24400.000796] DVB: registering adapter 0 frontend 0 (Siano Mobile Digital MDTV R
eceiver)...
Jun 15 16:46:28 localhost kernel: [24400.001798] sms_ir_init: Allocating input device
Jun 15 16:46:28 localhost kernel: [24400.001802] sms_ir_init: IR remote keyboard type is 1
Jun 15 16:46:28 localhost kernel: [24400.001804] sms_ir_init: IR port 0, timeout 100 ms
Jun 15 16:46:28 localhost kernel: [24400.001807] sms_ir_init: Input device (IR) SMS IR w/kbd type 1 is set for key 
events
Jun 15 16:46:28 localhost kernel: [24400.001887] input: SMS IR w/kbd type 1 as /devices/pci0000:00/0000:00:1d.7/usb
5/5-6/input/input9


--- linux-2.6.34/drivers/media/dvb/siano/smsir.h.rz	2010-06-11 11:24:20.000000000 +0200
+++ linux-2.6.34/drivers/media/dvb/siano/smsir.h	2010-06-11 01:12:54.000000000 +0200
@@ -30,6 +30,7 @@
 
 enum ir_kb_type {
 	SMS_IR_KB_DEFAULT_TV,
+	SMS_IR_KB_HCW_DSR0112,
 	SMS_IR_KB_HCW_SILVER
 };
 
--- linux-2.6.34/drivers/media/dvb/siano/smsir.c.rz	2010-06-11 10:07:32.000000000 +0200
+++ linux-2.6.34/drivers/media/dvb/siano/smsir.c	2010-06-15 18:08:37.000000000 +0200
@@ -54,6 +54,34 @@
 					0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 			}
 		},
+		[SMS_IR_KB_HCW_DSR0112] = {
+			.ir_protocol = IR_RC5,
+			.rc5_kbd_address = KEYBOARD_ADDRESS_LIGHTING,
+			.keyboard_layout_map = {
+					KEY_0, KEY_1, KEY_2,
+					KEY_3, KEY_4, KEY_5,
+					KEY_6, KEY_7, KEY_8,
+					KEY_9, KEY_TEXT, KEY_RED,
+					KEY_RADIO, KEY_MENU,
+					KEY_SUBTITLE,
+					KEY_MUTE, KEY_VOLUMEUP,
+					KEY_VOLUMEDOWN, KEY_PREVIOUS, 0,
+					KEY_UP, KEY_DOWN, KEY_LEFT,
+					KEY_RIGHT, KEY_VIDEO, KEY_AUDIO,
+					KEY_MHP, KEY_EPG, KEY_TV,
+					0, KEY_NEXTSONG, KEY_EXIT,
+					KEY_CHANNELUP, 	KEY_CHANNELDOWN,
+					KEY_CHANNEL, 0,
+					KEY_PREVIOUSSONG, KEY_ENTER,
+					KEY_SLEEP, 0, 0, KEY_BLUE,
+					0, 0, 0, 0, KEY_GREEN, 0,
+					KEY_PAUSE, 0, KEY_REWIND,
+					0, KEY_FASTFORWARD, KEY_PLAY,
+					KEY_STOP, KEY_RECORD,
+					KEY_YELLOW, 0, 0, KEY_SELECT,
+					KEY_ZOOM, KEY_POWER, 0, 0
+			}
+		},
 		[SMS_IR_KB_HCW_SILVER] = {
 			.ir_protocol = IR_RC5,
 			.rc5_kbd_address = KEYBOARD_ADDRESS_LIGHTING1,
@@ -120,6 +148,7 @@
 
 	sms_log("kernel input keycode (from ir) %d", keycode);
 	input_report_key(coredev->ir.input_dev, keycode, 1);
+	input_report_key(coredev->ir.input_dev, keycode, 0);
 	input_sync(coredev->ir.input_dev);
 
 }
@@ -247,6 +276,8 @@
 int sms_ir_init(struct smscore_device_t *coredev)
 {
 	struct input_dev *input_dev;
+	int i;
+	u16 *key_map;
 
 	sms_log("Allocating input device");
 	input_dev = input_allocate_device();
@@ -278,7 +309,14 @@
 
 	/* Key press events only */
 	input_dev->evbit[0] = BIT_MASK(EV_KEY);
-	input_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
+
+	key_map = keyboard_layout_maps[coredev->ir.ir_kb_type].keyboard_layout_map;
+		
+	memset (input_dev->keybit, 0, sizeof(input_dev->keybit));
+	for (i=0; i<IR_KEYBOARD_LAYOUT_SIZE; i++) {
+		if (key_map[i])
+			set_bit (key_map[i], input_dev->keybit);
+	}
 
 	sms_log("Input device (IR) %s is set for key events", input_dev->name);
 
--- linux-2.6.34/drivers/media/dvb/siano/sms-cards.c.rz	2010-06-09 14:37:19.000000000 +0200
+++ linux-2.6.34/drivers/media/dvb/siano/sms-cards.c	2010-06-11 01:08:49.000000000 +0200
@@ -64,6 +64,8 @@
 		.type	= SMS_NOVA_B0,
 		.fw[DEVICE_MODE_ISDBT_BDA] = "sms1xxx-hcw-55xxx-isdbt-02.fw",
 		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
+		.ir_kb_type = SMS_IR_KB_HCW_DSR0112,
+		.board_cfg.ir = 4,
 		.board_cfg.leds_power = 26,
 		.board_cfg.led0 = 27,
 		.board_cfg.led1 = 28,


