Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110812.mail.gq1.yahoo.com ([67.195.13.235]:45096 "HELO
	web110812.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750841AbZDEMHU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 08:07:20 -0400
Message-ID: <20771.44005.qm@web110812.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 05:07:17 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_19] Siano: sms-cards - update cards (targets) component header
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238760946 -10800
# Node ID 8377a5e61286b90e293e287cefc9638d2ddd938e
# Parent  ab731e3cec5cb076b8f87f827c3c97a4dd84e0ca
[PATCH] [0904_19] Siano: sms-cards - update cards (targets) component header

From: Uri Shkolnik <uris@siano-ms.com>

sms-cards component holds all target-specific information.
The component' header has been added with:
1) Include the infra-red header
2) More target types (definitions)
3) Structure for various GPIO usage
4) Extend "sms_board" struct to include
    a) GPIO structure
    b) IR structure
5) Some 'extern' declartion (for future commits usage)
6) "Board Events" structure
7) "board event" function prototype.

All modifications are in the declaration level only.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r ab731e3cec5c -r 8377a5e61286 linux/drivers/media/dvb/siano/sms-cards.h
--- a/linux/drivers/media/dvb/siano/sms-cards.h	Fri Apr 03 15:00:32 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.h	Fri Apr 03 15:15:46 2009 +0300
@@ -22,6 +22,7 @@
 
 #include <linux/usb.h>
 #include "smscoreapi.h"
+#include "smsir.h"
 
 #define SMS_BOARD_UNKNOWN 0
 #define SMS1XXX_BOARD_SIANO_STELLAR 1
@@ -34,6 +35,41 @@
 #define SMS1XXX_BOARD_HAUPPAUGE_WINDHAM 8
 #define SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD 9
 #define SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2 10
+#define SMS1XXX_BOARD_SIANO_NICE	11
+#define SMS1XXX_BOARD_SIANO_VENICE	12
+
+struct sms_board_gpio_cfg {
+	int lna_vhf_exist;
+	int lna_vhf_ctrl;
+	int lna_uhf_exist;
+	int lna_uhf_ctrl;
+	int lna_uhf_d_ctrl;
+	int lna_sband_exist;
+	int lna_sband_ctrl;
+	int lna_sband_d_ctrl;
+	int foreign_lna0_ctrl;
+	int foreign_lna1_ctrl;
+	int foreign_lna2_ctrl;
+	int rf_switch_vhf;
+	int rf_switch_uhf;
+	int rf_switch_sband;
+	int leds_power;
+	int led0;
+	int led1;
+	int led2;
+	int led3;
+	int led4;
+	int ir;
+	int eeprom_wp;
+	int mrc_sense;
+	int mrc_pdn_resetn;
+	int mrc_gp0; /* mrcs spi int */
+	int mrc_gp1;
+	int mrc_gp2;
+	int mrc_gp3;
+	int mrc_gp4;
+	int host_spi_gsp_ts_int;
+};
 
 struct sms_board {
 	enum sms_device_type_st type;
@@ -41,9 +77,14 @@ struct sms_board {
 
 	/* gpios */
 	int led_power, led_hi, led_lo, lna_ctrl, rf_switch;
+	struct sms_board_gpio_cfg board_cfg;
+	enum ir_kb_type ir_kb_type;
 };
 
 struct sms_board *sms_get_board(int id);
+
+extern struct usb_device_id smsusb_id_table[];
+extern struct smscore_device_t *coredev;
 
 int sms_board_setup(struct smscore_device_t *coredev);
 
@@ -56,4 +97,28 @@ int sms_board_lna_control(struct smscore
 
 extern int sms_board_load_modules(int id);
 
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
 #endif /* __SMS_CARDS_H__ */



      
