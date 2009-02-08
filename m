Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110801.mail.gq1.yahoo.com ([67.195.13.224]:38426 "HELO
	web110801.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751160AbZBHP1d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Feb 2009 10:27:33 -0500
Date: Sun, 8 Feb 2009 07:27:32 -0800 (PST)
From: Uri Shkolnik <urishk@yahoo.com>
Reply-To: urishk@yahoo.com
Subject: [PATCH] Siano 10238 Add IR (remote controllers) support
To: linux-media@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho <mchehab@infradead.org>,
	linuxtv-commits@linuxtv.org, linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <956145.70006.qm@web110801.mail.gq1.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1234106917 -7200
# Node ID 3caff6dae0753d2adb581b7ef5e309a1954820b2
# Parent  56b506432a55cebe0f52eb28cc8b55584bc9a429
Add IR support for SMS based devices

From: Uri Shkolnik <uris@siano-ms.com>

Add IR support, which is used for remote controllers, including
kernel "input" device operations.
Requires all Siano's patches up to this patch.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 56b506432a55 -r 3caff6dae075 linux/drivers/media/dvb/siano/Makefile
--- a/linux/drivers/media/dvb/siano/Makefile	Sun Jan 18 11:32:50 2009 +0200
+++ b/linux/drivers/media/dvb/siano/Makefile	Sun Feb 08 17:28:37 2009 +0200
@@ -31,7 +31,7 @@ SMS_SPI_PXA310_DRV := 0
 
 
 # Default object, include in every build variant
-SMSOBJ := smscoreapi.o sms-cards.o smsendian.o
+SMSOBJ := smscoreapi.o sms-cards.o smsendian.o smsir.o
 
 EXTRA_CFLAGS += $(extra-cflags-y) $(extra-cflags-m)
 
diff -r 56b506432a55 -r 3caff6dae075 linux/drivers/media/dvb/siano/sms-cards.c
--- a/linux/drivers/media/dvb/siano/sms-cards.c	Sun Jan 18 11:32:50 2009 +0200
+++ b/linux/drivers/media/dvb/siano/sms-cards.c	Sun Feb 08 17:28:37 2009 +0200
@@ -18,6 +18,7 @@
  */
 
 #include "sms-cards.h"
+#include "smsir.h"
 
 struct usb_device_id smsusb_id_table[] = {
 	{ USB_DEVICE(0x187f, 0x0010),
@@ -77,22 +78,18 @@ static struct sms_board sms_boards[] = {
 		.name =
 		"Siano Stellar Digital Receiver",
 		.type = SMS_STELLAR,
-		.fw[DEVICE_MODE_DVBT_BDA] =
-		"sms1xxx-stellar-dvbt-01.fw",
 	},
 	[SMS1XXX_BOARD_SIANO_NOVA_A] = {
 	/* 2 */
 		.name = "Siano Nova A Digital Receiver",
 		.type = SMS_NOVA_A0,
-		.fw[DEVICE_MODE_DVBT_BDA] =
-		"sms1xxx-nova-a-dvbt-01.fw",
 	},
 	[SMS1XXX_BOARD_SIANO_NOVA_B] = {
 	/* 3 */
 		.name = "Siano Nova B Digital Receiver",
 		.type = SMS_NOVA_B0,
-		.fw[DEVICE_MODE_DVBT_BDA] =
-		"sms1xxx-nova-b-dvbt-01.fw",
+		.ir_kb_type = SMS_IR_KB_HCW_SILVER,
+		.board_cfg.ir = 4,
 	},
 	[SMS1XXX_BOARD_SIANO_VEGA] = {
 	/* 4 */
diff -r 56b506432a55 -r 3caff6dae075 linux/drivers/media/dvb/siano/sms-cards.h
--- a/linux/drivers/media/dvb/siano/sms-cards.h	Sun Jan 18 11:32:50 2009 +0200
+++ b/linux/drivers/media/dvb/siano/sms-cards.h	Sun Feb 08 17:28:37 2009 +0200
@@ -22,6 +22,7 @@
 
 #include <linux/usb.h>
 #include "smscoreapi.h"
+#include "smsir.h"
 
 #define SMS_BOARD_UNKNOWN 0
 #define SMS1XXX_BOARD_SIANO_STELLAR 1
@@ -71,6 +72,7 @@ struct sms_board {
 	enum sms_device_type_st type;
 	char *name, *fw[DEVICE_MODE_MAX];
 	struct sms_board_gpio_cfg board_cfg;
+	enum ir_kb_type ir_kb_type;
 };
 
 struct sms_board *sms_get_board(int id);
diff -r 56b506432a55 -r 3caff6dae075 linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Sun Jan 18 11:32:50 2009 +0200
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Sun Feb 08 17:28:37 2009 +0200
@@ -34,6 +34,7 @@
 #include "smscoreapi.h"
 #include "smsendian.h"
 #include "sms-cards.h"
+#include "smsir.h"
 
 #define MAX_GPIO_PIN_NUMBER	31
 
@@ -69,48 +70,6 @@ struct smscore_client_t {
 	struct list_head idlist;
 	onresponse_t onresponse_handler;
 	onremove_t onremove_handler;
-};
-
-struct smscore_device_t {
-	struct list_head entry;
-
-	struct list_head clients;
-	struct list_head subclients;
-	spinlock_t clientslock;
-
-	struct list_head buffers;
-	spinlock_t bufferslock;
-	int num_buffers;
-
-	void *common_buffer;
-	int common_buffer_size;
-	dma_addr_t common_buffer_phys;
-
-	void *context;
-	struct device *device;
-
-	char devpath[32];
-	unsigned long device_flags;
-
-	setmode_t setmode_handler;
-	detectmode_t detectmode_handler;
-	sendrequest_t sendrequest_handler;
-	preload_t preload_handler;
-	postload_t postload_handler;
-
-	int mode, modes_supported;
-
-	struct completion version_ex_done, data_download_done, trigger_done;
-	struct completion init_device_done, reload_start_done, resume_done;
-	struct completion gpio_configuration_done, gpio_set_level_done;
-	struct completion gpio_get_level_done;
-
-	int gpio_get_res;
-
-	int board_id;
-
-	u8 *fw_buf;
-	u32 fw_buf_size;
 };
 
 void smscore_set_board_id(struct smscore_device_t *core, int id)
@@ -377,6 +336,7 @@ int smscore_register_device(struct smsde
 	init_completion(&dev->gpio_configuration_done);
 	init_completion(&dev->gpio_set_level_done);
 	init_completion(&dev->gpio_get_level_done);
+	init_completion(&dev->ir_init_done);
 
 	/* alloc common buffer */
 	dev->common_buffer_size = params->buffer_size * params->num_buffers;
@@ -429,6 +389,69 @@ int smscore_register_device(struct smsde
 	return 0;
 }
 
+static int smscore_sendrequest_and_wait(struct smscore_device_t *coredev,
+		void *buffer, size_t size, struct completion *completion) {
+	int rc = coredev->sendrequest_handler(coredev->context, buffer, size);
+	if (rc < 0) {
+		sms_info("sendrequest returned error %d", rc);
+		return rc;
+	}
+
+	return wait_for_completion_timeout(completion,
+			msecs_to_jiffies(10000)) ? 0 : -ETIME;
+}
+
+/**
+ * Starts & enables IR operations
+ *
+ * @return 0 on success, < 0 on error.
+ */
+static int smscore_init_ir(struct smscore_device_t *coredev)
+{
+	int ir_io;
+	int rc;
+	void *buffer;
+
+	coredev->ir.input_dev = NULL;
+	ir_io = sms_get_board(smscore_get_board_id(coredev))->board_cfg.ir;
+	if (ir_io) {/* only if IR port exist we use IR sub-module */
+		sms_info("IR loading");
+		rc = sms_ir_init(coredev);
+
+		if	(rc != 0)
+			sms_err("Error initialization DTV IR sub-module");
+		else {
+			buffer = kmalloc(sizeof(struct SmsMsgData_ST2) +
+						SMS_DMA_ALIGNMENT,
+						GFP_KERNEL | GFP_DMA);
+			if (buffer) {
+				struct SmsMsgData_ST2 *msg =
+				(struct SmsMsgData_ST2 *)
+				SMS_ALIGN_ADDRESS(buffer);
+
+				SMS_INIT_MSG(&msg->xMsgHeader,
+						MSG_SMS_START_IR_REQ,
+						sizeof(struct SmsMsgData_ST2));
+				msg->msgData[0] = coredev->ir.controller;
+				msg->msgData[1] = coredev->ir.timeout;
+
+				smsendian_handle_tx_message(
+					(struct SmsMsgHdr_ST2 *)msg);
+				rc = smscore_sendrequest_and_wait(coredev, msg,
+						msg->xMsgHeader. msgLength,
+						&coredev->ir_init_done);
+
+				kfree(buffer);
+			} else
+				sms_err
+				("Sending IR initialization message failed");
+		}
+	} else
+		sms_info("IR port has not been detected");
+
+	return 0;
+}
+
 /**
  * sets initial device mode and notifies client hotplugs that device is ready
  *
@@ -445,7 +468,7 @@ int smscore_start_device(struct smscore_
 	rc = smscore_set_device_mode(coredev, smscore_registry_getmode(
 			coredev->devpath));
 	if (rc < 0) {
-		sms_info("set device mode faile , rc %d", rc);
+		sms_info("set device mode failed , rc %d", rc);
 		return rc;
 	}
 #endif
@@ -453,24 +476,13 @@ int smscore_start_device(struct smscore_
 	kmutex_lock(&g_smscore_deviceslock);
 
 	rc = smscore_notify_callbacks(coredev, coredev->device, 1);
+	smscore_init_ir(coredev);
 
 	sms_info("device %p started, rc %d", coredev, rc);
 
 	kmutex_unlock(&g_smscore_deviceslock);
 
 	return rc;
-}
-
-static int smscore_sendrequest_and_wait(struct smscore_device_t *coredev,
-		void *buffer, size_t size, struct completion *completion) {
-	int rc = coredev->sendrequest_handler(coredev->context, buffer, size);
-	if (rc < 0) {
-		sms_info("sendrequest returned error %d", rc);
-		return rc;
-	}
-
-	return wait_for_completion_timeout(completion,
-			msecs_to_jiffies(10000)) ? 0 : -ETIME;
 }
 
 static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
@@ -660,6 +672,9 @@ void smscore_unregister_device(struct sm
 	int retry = 0;
 
 	kmutex_lock(&g_smscore_deviceslock);
+
+	/* Release input device (IR) resources */
+	sms_ir_exit(coredev);
 
 	smscore_notify_clients(coredev);
 	smscore_notify_callbacks(coredev, NULL, 0);
@@ -1095,6 +1110,17 @@ void smscore_onresponse(struct smscore_d
 			complete(&coredev->gpio_get_level_done);
 			break;
 		}
+		case MSG_SMS_START_IR_RES:
+			complete(&coredev->ir_init_done);
+			break;
+		case MSG_SMS_IR_SAMPLES_IND:
+			sms_ir_event(coredev,
+				(const char *)
+				((char *)phdr
+				+ sizeof(struct SmsMsgHdr_ST)),
+				(int)phdr->msgLength
+				- sizeof(struct SmsMsgHdr_ST));
+			break;
 		default:
 #if 0
 			sms_info("no client (%p) or error (%d), "
diff -r 56b506432a55 -r 3caff6dae075 linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Sun Jan 18 11:32:50 2009 +0200
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Sun Feb 08 17:28:37 2009 +0200
@@ -31,6 +31,7 @@ along with this program.  If not, see <h
 #include <asm/page.h>
 #include <linux/mutex.h>
 #include "compat.h"
+#include "smsir.h"
 
 #ifdef SMS_DVB3_SUBSYS
 #include "dmxdev.h"
@@ -122,6 +123,55 @@ struct smsclient_params_t {
 	void *context;
 };
 
+struct smscore_device_t {
+	struct list_head entry;
+
+	struct list_head clients;
+	struct list_head subclients;
+	spinlock_t clientslock;
+
+	struct list_head buffers;
+	spinlock_t bufferslock;
+	int num_buffers;
+
+	void *common_buffer;
+	int common_buffer_size;
+	dma_addr_t common_buffer_phys;
+
+	void *context;
+	struct device *device;
+
+	char devpath[32];
+	unsigned long device_flags;
+
+	setmode_t setmode_handler;
+	detectmode_t detectmode_handler;
+	sendrequest_t sendrequest_handler;
+	preload_t preload_handler;
+	postload_t postload_handler;
+
+	int mode, modes_supported;
+
+	/* host <--> device messages */
+	struct completion version_ex_done, data_download_done, trigger_done;
+	struct completion init_device_done, reload_start_done, resume_done;
+	struct completion gpio_configuration_done, gpio_set_level_done;
+	struct completion gpio_get_level_done, ir_init_done;
+
+	/* GPIO */
+	int gpio_get_res;
+
+	/* Target hardware board */
+	int board_id;
+
+	/* Firmware */
+	u8 *fw_buf;
+	u32 fw_buf_size;
+
+	/* Infrared (IR) */
+	struct ir_t ir;
+};
+
 /* GPIO definitions for antenna frequency domain control (SMS8021) */
 #define SMS_ANTENNA_GPIO_0				1
 #define SMS_ANTENNA_GPIO_1				0
@@ -192,6 +242,10 @@ struct smsclient_params_t {
 #define MSG_SMS_GPIO_CONFIG_EX_RES			713
 #define MSG_SMS_ISDBT_TUNE_REQ				776
 #define MSG_SMS_ISDBT_TUNE_RES				777
+#define MSG_SMS_START_IR_REQ				800
+#define MSG_SMS_START_IR_RES				801
+#define MSG_SMS_IR_SAMPLES_IND				802
+
 
 #define SMS_INIT_MSG_EX(ptr, type, src, dst, len) do { \
 	(ptr)->msgType = type; (ptr)->msgSrcId = src; (ptr)->msgDstId = dst; \
@@ -235,6 +289,11 @@ struct SmsMsgData_ST {
 struct SmsMsgData_ST {
 	struct SmsMsgHdr_ST xMsgHeader;
 	u32 msgData[1];
+};
+
+struct SmsMsgData_ST2 {
+	struct SmsMsgHdr_ST xMsgHeader;
+	u32 msgData[2];
 };
 
 struct SmsDataDownload_ST {
diff -r 56b506432a55 -r 3caff6dae075 linux/drivers/media/dvb/siano/smsir.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/siano/smsir.c	Sun Feb 08 17:28:37 2009 +0200
@@ -0,0 +1,301 @@
+/****************************************************************
+
+ Siano Mobile Silicon, Inc.
+ MDTV receiver kernel modules.
+ Copyright (C) 2006-2009, Uri Shkolnik
+
+ This program is free software: you can redistribute it and/or modify
+ it under the terms of the GNU General Public License as published by
+ the Free Software Foundation, either version 2 of the License, or
+ (at your option) any later version.
+
+ This program is distributed in the hope that it will be useful,
+ but WITHOUT ANY WARRANTY; without even the implied warranty of
+ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ GNU General Public License for more details.
+
+ You should have received a copy of the GNU General Public License
+ along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+ ****************************************************************/
+
+
+#include <linux/types.h>
+#include <linux/input.h>
+
+#include "smscoreapi.h"
+#include "smsir.h"
+#include "sms-cards.h"
+
+/* In order to add new IR remote control -
+ * 1) Add it to the <enum ir_kb_type> @ smsir,h,
+ * 2) Add its map to keyboard_layout_maps below
+ * 3) Set your board (sms-cards sub-module) to use it
+ */
+
+static struct keyboard_layout_map_t keyboard_layout_maps[] = {
+		[SMS_IR_KB_DEFAULT_TV] = {
+			.ir_protocol = IR_RC5,
+			.rc5_kbd_address = KEYBOARD_ADDRESS_TV1,
+			.keyboard_layout_map = {
+					KEY_0, KEY_1, KEY_2,
+					KEY_3, KEY_4, KEY_5,
+					KEY_6, KEY_7, KEY_8,
+					KEY_9, 0, 0, KEY_POWER,
+					KEY_MUTE, 0, 0,
+					KEY_VOLUMEUP, KEY_VOLUMEDOWN,
+					KEY_BRIGHTNESSUP,
+					KEY_BRIGHTNESSDOWN, KEY_CHANNELUP,
+					KEY_CHANNELDOWN,
+					0, 0, 0, 0, 0, 0, 0, 0,
+					0, 0, 0, 0, 0, 0, 0, 0,
+					0, 0, 0, 0, 0, 0, 0, 0,
+					0, 0, 0, 0, 0, 0, 0, 0,
+					0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+			}
+		},
+		[SMS_IR_KB_HCW_SILVER] = {
+			.ir_protocol = IR_RC5,
+			.rc5_kbd_address = KEYBOARD_ADDRESS_LIGHTING1,
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
+		{ } /* Terminating entry */
+};
+
+u32 ir_pos;
+u32	ir_word;
+u32 ir_toggle;
+
+#define RC5_PUSH_BIT(dst, bit, pos)	\
+	{ dst <<= 1; dst |= bit; pos++; }
+
+
+static void sms_ir_rc5_event(struct smscore_device_t *coredev,
+				u32 toggle, u32 addr, u32 cmd)
+{
+	bool toggle_changed;
+	u16 keycode;
+
+	sms_info("IR RC5 word: address %d, command %d, toggle %d",
+				addr, cmd, toggle);
+
+	toggle_changed = ir_toggle != toggle;
+	/* keep toggle */
+	ir_toggle = toggle;
+
+	if (addr !=
+		keyboard_layout_maps[coredev->ir.ir_kb_type].rc5_kbd_address)
+		return; /* Check for valid address */
+
+	keycode =
+		keyboard_layout_maps
+		[coredev->ir.ir_kb_type].keyboard_layout_map[cmd];
+
+	if (!toggle_changed &&
+			(keycode != KEY_VOLUMEUP && keycode != KEY_VOLUMEDOWN))
+		return; /* accept only repeated volume, reject other keys */
+
+	sms_info("kernel input keycode (from ir) %d", keycode);
+	input_report_key(coredev->ir.input_dev, keycode, 1);
+	input_sync(coredev->ir.input_dev);
+
+}
+
+/* decode raw bit pattern to RC5 code */
+/* taken from ir-functions.c */
+static u32 ir_rc5_decode(unsigned int code)
+{
+/*	unsigned int org_code = code;*/
+	unsigned int pair;
+	unsigned int rc5 = 0;
+	int i;
+
+	for (i = 0; i < 14; ++i) {
+		pair = code & 0x3;
+		code >>= 2;
+
+		rc5 <<= 1;
+		switch (pair) {
+		case 0:
+		case 2:
+			break;
+		case 1:
+			rc5 |= 1;
+			break;
+		case 3:
+/*	dprintk(1, "ir-common: ir_rc5_decode(%x) bad code\n", org_code);*/
+			sms_info("bad code");
+			return 0;
+		}
+	}
+/*
+	dprintk(1, "ir-common: code=%x, rc5=%x, start=%x,
+		toggle=%x, address=%x, "
+		"instr=%x\n", rc5, org_code, RC5_START(rc5),
+		RC5_TOGGLE(rc5), RC5_ADDR(rc5), RC5_INSTR(rc5));
+*/
+	return rc5;
+}
+
+static void sms_rc5_parse_word(struct smscore_device_t *coredev)
+{
+	#define RC5_START(x)    (((x)>>12)&3)
+	#define RC5_TOGGLE(x)   (((x)>>11)&1)
+	#define RC5_ADDR(x)     (((x)>>6)&0x1F)
+	#define RC5_INSTR(x)    ((x)&0x3F)
+
+	int i, j;
+	u32 rc5_word = 0;
+
+	/* Reverse the IR word direction */
+	for (i = 0 ; i < 28 ; i++)
+		RC5_PUSH_BIT(rc5_word, (ir_word>>i)&1, j)
+
+	rc5_word = ir_rc5_decode(rc5_word);
+	/* sms_info("temp = 0x%x, rc5_code = 0x%x", ir_word, rc5_word); */
+
+	sms_ir_rc5_event(coredev,
+				RC5_TOGGLE(rc5_word),
+				RC5_ADDR(rc5_word),
+				RC5_INSTR(rc5_word));
+}
+
+
+static void sms_rc5_accumulate_bits(struct smscore_device_t *coredev,
+		s32 ir_sample)
+{
+	#define RC5_TIME_GRANULARITY	200
+	#define RC5_DEF_BIT_TIME		889
+	#define RC5_MAX_SAME_BIT_CONT	4
+	#define RC5_WORD_LEN			27 /* 28 bit */
+
+	u32 i, j;
+	s32 delta_time;
+	u32 time = (ir_sample > 0) ? ir_sample : (0-ir_sample);
+	u32 level = (ir_sample < 0) ? 0 : 1;
+
+	for (i = RC5_MAX_SAME_BIT_CONT; i > 0; i--) {
+		delta_time = time - (i*RC5_DEF_BIT_TIME) + RC5_TIME_GRANULARITY;
+		if (delta_time < 0)
+			continue; /* not so many consecutive bits */
+		if (delta_time > (2 * RC5_TIME_GRANULARITY)) {
+			/* timeout */
+			if (ir_pos == (RC5_WORD_LEN-1))
+				/* complete last bit */
+				RC5_PUSH_BIT(ir_word, level, ir_pos)
+
+			if (ir_pos == RC5_WORD_LEN)
+				sms_rc5_parse_word(coredev);
+			else if (ir_pos) /* timeout within a word */
+				sms_info("IR error parsing a word");
+
+			ir_pos = 0;
+			ir_word = 0;
+			/* sms_info("timeout %d", time); */
+			break;
+		}
+		/* The time is within the range of this number of bits */
+		for (j = 0 ; j < i ; j++)
+			RC5_PUSH_BIT(ir_word, level, ir_pos)
+
+		break;
+	}
+}
+
+void sms_ir_event(struct smscore_device_t *coredev, const char *buf, int len)
+{
+	#define IR_DATA_RECEIVE_MAX_LEN	520 /* 128*4 + 4 + 4 */
+	u32 i;
+	enum ir_protocol ir_protocol =
+			keyboard_layout_maps[coredev->ir.ir_kb_type]
+					     .ir_protocol;
+	s32 *samples;
+	int count = len>>2;
+
+	samples = (s32 *)buf;
+/*	sms_info("IR buffer received, length = %d", count);*/
+
+	for (i = 0; i < count; i++)
+		if (ir_protocol == IR_RC5)
+			sms_rc5_accumulate_bits(coredev, samples[i]);
+	/*  IR_RCMM not implemented */
+}
+
+int sms_ir_init(struct smscore_device_t *coredev)
+{
+	struct input_dev *input_dev;
+
+	sms_info("Allocating input device");
+	input_dev = input_allocate_device();
+	if (!input_dev)	{
+		sms_err("Not enough memory");
+		return -ENOMEM;
+	}
+
+	coredev->ir.input_dev = input_dev;
+	coredev->ir.ir_kb_type =
+		sms_get_board(smscore_get_board_id(coredev))->ir_kb_type;
+	coredev->ir.keyboard_layout_map =
+		keyboard_layout_maps[coredev->ir.ir_kb_type].
+				keyboard_layout_map;
+	sms_info("IR remote keyboard type is %d", coredev->ir.ir_kb_type);
+
+	coredev->ir.controller = 0;	/* Todo: vega/nova SPI number */
+	coredev->ir.timeout = IR_DEFAULT_TIMEOUT;
+	sms_info("IR port %d, timeout %d ms",
+			coredev->ir.controller, coredev->ir.timeout);
+
+	snprintf(coredev->ir.name,
+				IR_DEV_NAME_MAX_LEN,
+				"SMS IR w/kbd type %d",
+				coredev->ir.ir_kb_type);
+	input_dev->name = coredev->ir.name;
+	input_dev->phys = coredev->ir.name;
+	input_dev->dev.parent = coredev->device;
+
+	/* Key press events only */
+	input_dev->evbit[0] = BIT_MASK(EV_KEY);
+	input_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
+
+	sms_info("Input device (IR) %s is set for key events", input_dev->name);
+
+	if (input_register_device(input_dev)) {
+		sms_err("Failed to register device");
+		input_free_device(input_dev);
+		return -EACCES;
+	}
+
+	return 0;
+}
+
+void sms_ir_exit(struct smscore_device_t *coredev)
+{
+	if (coredev->ir.input_dev)
+		input_unregister_device(coredev->ir.input_dev);
+
+	sms_info("");
+}
+
diff -r 56b506432a55 -r 3caff6dae075 linux/drivers/media/dvb/siano/smsir.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/siano/smsir.h	Sun Feb 08 17:28:37 2009 +0200
@@ -0,0 +1,93 @@
+/****************************************************************
+
+Siano Mobile Silicon, Inc.
+MDTV receiver kernel modules.
+Copyright (C) 2006-2009, Uri Shkolnik
+
+This program is free software: you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation, either version 2 of the License, or
+(at your option) any later version.
+
+ This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+****************************************************************/
+
+#ifndef __SMS_IR_H__
+#define __SMS_IR_H__
+
+#include <linux/input.h>
+
+#define IR_DEV_NAME_MAX_LEN		23 /* "SMS IR kbd type nn\0" */
+#define IR_KEYBOARD_LAYOUT_SIZE	64
+#define IR_DEFAULT_TIMEOUT		100
+
+enum ir_kb_type {
+	SMS_IR_KB_DEFAULT_TV,
+	SMS_IR_KB_HCW_SILVER
+};
+
+enum rc5_keyboard_address {
+	KEYBOARD_ADDRESS_TV1 = 0,
+	KEYBOARD_ADDRESS_TV2 = 1,
+	KEYBOARD_ADDRESS_TELETEXT = 2,
+	KEYBOARD_ADDRESS_VIDEO = 3,
+	KEYBOARD_ADDRESS_LV1 = 4,
+	KEYBOARD_ADDRESS_VCR1 = 5,
+	KEYBOARD_ADDRESS_VCR2 = 6,
+	KEYBOARD_ADDRESS_EXPERIMENTAL = 7,
+	KEYBOARD_ADDRESS_SAT1 = 8,
+	KEYBOARD_ADDRESS_CAMERA = 9,
+	KEYBOARD_ADDRESS_SAT2 = 10,
+	KEYBOARD_ADDRESS_CDV = 12,
+	KEYBOARD_ADDRESS_CAMCORDER = 13,
+	KEYBOARD_ADDRESS_PRE_AMP = 16,
+	KEYBOARD_ADDRESS_TUNER = 17,
+	KEYBOARD_ADDRESS_RECORDER1 = 18,
+	KEYBOARD_ADDRESS_PRE_AMP1 = 19,
+	KEYBOARD_ADDRESS_CD_PLAYER = 20,
+	KEYBOARD_ADDRESS_PHONO = 21,
+	KEYBOARD_ADDRESS_SATA = 22,
+	KEYBOARD_ADDRESS_RECORDER2 = 23,
+	KEYBOARD_ADDRESS_CDR = 26,
+	KEYBOARD_ADDRESS_LIGHTING = 29,
+	KEYBOARD_ADDRESS_LIGHTING1 = 30, /* KEYBOARD_ADDRESS_HCW_SILVER */
+	KEYBOARD_ADDRESS_PHONE = 31,
+	KEYBOARD_ADDRESS_NOT_RC5 = 0xFFFF
+};
+
+enum ir_protocol {
+	IR_RC5,
+	IR_RCMM
+};
+
+struct keyboard_layout_map_t {
+	enum ir_protocol ir_protocol;
+	enum rc5_keyboard_address rc5_kbd_address;
+	u16 keyboard_layout_map[IR_KEYBOARD_LAYOUT_SIZE];
+};
+
+struct smscore_device_t;
+
+struct ir_t {
+	struct input_dev *input_dev;
+	enum ir_kb_type ir_kb_type;
+	char name[IR_DEV_NAME_MAX_LEN+1];
+	u16 *keyboard_layout_map;
+	u32 timeout;
+	u32 controller;
+};
+
+int sms_ir_init(struct smscore_device_t *coredev);
+void sms_ir_exit(struct smscore_device_t *coredev);
+void sms_ir_event(struct smscore_device_t *coredev,
+			const char *buf, int len);
+
+#endif /* __SMS_IR_H__ */
+
diff -r 56b506432a55 -r 3caff6dae075 linux/drivers/media/dvb/siano/smsspicommon.c
--- a/linux/drivers/media/dvb/siano/smsspicommon.c	Sun Jan 18 11:32:50 2009 +0200
+++ b/linux/drivers/media/dvb/siano/smsspicommon.c	Sun Feb 08 17:28:37 2009 +0200
@@ -28,7 +28,8 @@ static int smsspi_common_find_msg(struct
 	int i, missing_bytes;
 	int recieved_bytes, padded_msg_len;
 	int align_fix;
-	char *ptr = (char *)buf->ptr + offset;
+	int msg_offset;
+	unsigned char *ptr = (unsigned char *)buf->ptr + offset;
 
 	PRN_DBG((TXT("entering with %d bytes.\n"), len));
 	missing_bytes = 0;
@@ -108,15 +109,17 @@ static int smsspi_common_find_msg(struct
 			dev->rxState = RxsWait_a5;
 			if (dev->cb.msg_found_cb) {
 				align_fix = 0;
-		if (dev->rxPacket.msg_flags & MSG_HDR_FLAG_SPLIT_MSG_HDR) {
-			align_fix = (dev->rxPacket.msg_flags >> 8) & 0x3;
-					/* The FW alligned the message data
-					therefore - alligment bytes should be
-					thrown away. Throw the aligment bytes
-					by moving the header ahead over the
-					alligment bytes. */
+				if (dev->rxPacket.
+				    msg_flags & MSG_HDR_FLAG_SPLIT_MSG_HDR) {
+					align_fix =
+					    (dev->rxPacket.
+					     msg_flags >> 8) & 0x3;
+	/* The FW aligned the message data therefore -
+	* alignment bytes should be thrown away.
+	* Throw the alignment bytes by moving the
+	* header ahead over the alignment bytes. */
 					if (align_fix) {
-						u16 length;
+						int length;
 						ptr =
 						    (char *)dev->rxPacket.
 						    msg_buf->ptr +
@@ -145,11 +148,26 @@ static int smsspi_common_find_msg(struct
 
 				PRN_DBG((TXT
 				("Msg found and sent to callback func.\n")));
+
+				/* force all messages to start on
+					4-byte boundary */
+				msg_offset = dev->rxPacket.msg_offset;
+				if (msg_offset & 0x3)	{
+					msg_offset &= (~0x3);
+					memmove((unsigned char *)
+						(dev->rxPacket.msg_buf->ptr) +
+						msg_offset,
+						(unsigned char *)
+						(dev->rxPacket.msg_buf->ptr) +
+						dev->rxPacket.msg_offset,
+						dev->rxPacket.msg_len -
+						align_fix);
+				}
 				dev->cb.msg_found_cb(dev->context,
-						     dev->rxPacket.msg_buf,
-						     dev->rxPacket.msg_offset,
-						     dev->rxPacket.msg_len -
-						     align_fix);
+							 dev->rxPacket.msg_buf,
+							 msg_offset,
+							 dev->rxPacket.msg_len -
+							 align_fix);
 				*unused_bytes =
 				    len + offset - dev->rxPacket.msg_offset -
 				    dev->rxPacket.msg_len;



      
