Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110803.mail.gq1.yahoo.com ([67.195.13.226]:34334 "HELO
	web110803.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752038AbZENTcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 15:32:12 -0400
Message-ID: <954612.64011.qm@web110803.mail.gq1.yahoo.com>
Date: Thu, 14 May 2009 12:32:12 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_17] Siano: bind infra-red component
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242327012 -10800
# Node ID 438275c8cf1084ed8983b084a8d4d7ef03c05022
# Parent  dd2de98ad42c1328d24e7bf90903fab1e1368b0b
[0905_17] Siano: bind infra-red component

From: Uri Shkolnik <uris@siano-ms.com>

Add the infra-red to the makefile and declare
the assignment in the cards components.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r dd2de98ad42c -r 438275c8cf10 linux/drivers/media/dvb/siano/Makefile
--- a/linux/drivers/media/dvb/siano/Makefile	Thu May 14 21:35:50 2009 +0300
+++ b/linux/drivers/media/dvb/siano/Makefile	Thu May 14 21:50:12 2009 +0300
@@ -1,4 +1,4 @@ smsmdtv-objs := smscoreapi.o sms-cards.o
-smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o
+smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o smsir.o
 
 obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o
 obj-$(CONFIG_SMS_USB_DRV) += smsusb.o
diff -r dd2de98ad42c -r 438275c8cf10 linux/drivers/media/dvb/siano/sms-cards.c
--- a/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 21:35:50 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 21:50:12 2009 +0300
@@ -18,6 +18,7 @@
  */
 
 #include "sms-cards.h"
+#include "smsir.h"
 
 struct usb_device_id smsusb_id_table[] = {
 	{ USB_DEVICE(0x187f, 0x0010),
diff -r dd2de98ad42c -r 438275c8cf10 linux/drivers/media/dvb/siano/sms-cards.h
--- a/linux/drivers/media/dvb/siano/sms-cards.h	Thu May 14 21:35:50 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.h	Thu May 14 21:50:12 2009 +0300
@@ -22,6 +22,7 @@
 
 #include <linux/usb.h>
 #include "smscoreapi.h"
+#include "smsir.h"
 
 #define SMS_BOARD_UNKNOWN 0
 #define SMS1XXX_BOARD_SIANO_STELLAR 1
@@ -74,6 +75,7 @@ struct sms_board {
 	enum sms_device_type_st type;
 	char *name, *fw[DEVICE_MODE_MAX];
 	struct sms_board_gpio_cfg board_cfg;
+	enum ir_kb_type ir_kb_type;
 
 	/* gpios */
 	int led_power, led_hi, led_lo, lna_ctrl, rf_switch;
@@ -82,6 +84,7 @@ struct sms_board *sms_get_board(int id);
 struct sms_board *sms_get_board(int id);
 
 extern struct usb_device_id smsusb_id_table[];
+extern struct smscore_device_t *coredev;
 
 int sms_board_setup(struct smscore_device_t *coredev);
 
diff -r dd2de98ad42c -r 438275c8cf10 linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Thu May 14 21:35:50 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Thu May 14 21:50:12 2009 +0300
@@ -35,6 +35,7 @@ along with this program.  If not, see <h
 #include <asm/page.h>
 #include "compat.h"
 
+#include "smsir.h"
 
 #define kmutex_init(_p_) mutex_init(_p_)
 #define kmutex_lock(_p_) mutex_lock(_p_)
@@ -168,7 +169,7 @@ struct smscore_device_t {
 	u32 fw_buf_size;
 
 	/* Infrared (IR) */
-	/* struct ir_t ir; */
+	struct ir_t ir;
 
 	int led_state;
 };
diff -r dd2de98ad42c -r 438275c8cf10 linux/drivers/media/dvb/siano/smsir.c
--- a/linux/drivers/media/dvb/siano/smsir.c	Thu May 14 21:35:50 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsir.c	Thu May 14 21:50:12 2009 +0300
@@ -99,7 +99,7 @@ static void sms_ir_rc5_event(struct smsc
 	bool toggle_changed;
 	u16 keycode;
 
-	sms_info("IR RC5 word: address %d, command %d, toggle %d",
+	sms_log("IR RC5 word: address %d, command %d, toggle %d",
 				addr, cmd, toggle);
 
 	toggle_changed = ir_toggle != toggle;
@@ -118,7 +118,7 @@ static void sms_ir_rc5_event(struct smsc
 			(keycode != KEY_VOLUMEUP && keycode != KEY_VOLUMEDOWN))
 		return; /* accept only repeated volume, reject other keys */
 
-	sms_info("kernel input keycode (from ir) %d", keycode);
+	sms_log("kernel input keycode (from ir) %d", keycode);
 	input_report_key(coredev->ir.input_dev, keycode, 1);
 	input_sync(coredev->ir.input_dev);
 
@@ -147,7 +147,7 @@ static u32 ir_rc5_decode(unsigned int co
 			break;
 		case 3:
 /*	dprintk(1, "ir-common: ir_rc5_decode(%x) bad code\n", org_code);*/
-			sms_info("bad code");
+			sms_log("bad code");
 			return 0;
 		}
 	}
@@ -175,7 +175,7 @@ static void sms_rc5_parse_word(struct sm
 		RC5_PUSH_BIT(rc5_word, (ir_word>>i)&1, j)
 
 	rc5_word = ir_rc5_decode(rc5_word);
-	/* sms_info("temp = 0x%x, rc5_code = 0x%x", ir_word, rc5_word); */
+	/* sms_log("temp = 0x%x, rc5_code = 0x%x", ir_word, rc5_word); */
 
 	sms_ir_rc5_event(coredev,
 				RC5_TOGGLE(rc5_word),
@@ -210,11 +210,11 @@ static void sms_rc5_accumulate_bits(stru
 			if (ir_pos == RC5_WORD_LEN)
 				sms_rc5_parse_word(coredev);
 			else if (ir_pos) /* timeout within a word */
-				sms_info("IR error parsing a word");
+				sms_log("IR error parsing a word");
 
 			ir_pos = 0;
 			ir_word = 0;
-			/* sms_info("timeout %d", time); */
+			/* sms_log("timeout %d", time); */
 			break;
 		}
 		/* The time is within the range of this number of bits */
@@ -236,7 +236,7 @@ void sms_ir_event(struct smscore_device_
 	int count = len>>2;
 
 	samples = (s32 *)buf;
-/*	sms_info("IR buffer received, length = %d", count);*/
+/*	sms_log("IR buffer received, length = %d", count);*/
 
 	for (i = 0; i < count; i++)
 		if (ir_protocol == IR_RC5)
@@ -248,7 +248,7 @@ int sms_ir_init(struct smscore_device_t 
 {
 	struct input_dev *input_dev;
 
-	sms_info("Allocating input device");
+	sms_log("Allocating input device");
 	input_dev = input_allocate_device();
 	if (!input_dev)	{
 		sms_err("Not enough memory");
@@ -261,11 +261,11 @@ int sms_ir_init(struct smscore_device_t 
 	coredev->ir.keyboard_layout_map =
 		keyboard_layout_maps[coredev->ir.ir_kb_type].
 				keyboard_layout_map;
-	sms_info("IR remote keyboard type is %d", coredev->ir.ir_kb_type);
+	sms_log("IR remote keyboard type is %d", coredev->ir.ir_kb_type);
 
 	coredev->ir.controller = 0;	/* Todo: vega/nova SPI number */
 	coredev->ir.timeout = IR_DEFAULT_TIMEOUT;
-	sms_info("IR port %d, timeout %d ms",
+	sms_log("IR port %d, timeout %d ms",
 			coredev->ir.controller, coredev->ir.timeout);
 
 	snprintf(coredev->ir.name,
@@ -280,7 +280,7 @@ int sms_ir_init(struct smscore_device_t 
 	input_dev->evbit[0] = BIT_MASK(EV_KEY);
 	input_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
 
-	sms_info("Input device (IR) %s is set for key events", input_dev->name);
+	sms_log("Input device (IR) %s is set for key events", input_dev->name);
 
 	if (input_register_device(input_dev)) {
 		sms_err("Failed to register device");
@@ -296,6 +296,6 @@ void sms_ir_exit(struct smscore_device_t
 	if (coredev->ir.input_dev)
 		input_unregister_device(coredev->ir.input_dev);
 
-	sms_info("");
+	sms_log("");
 }
 



      
