Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56857 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbZGVB2Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 21:28:24 -0400
Subject: [PATCH v2 3/4] cx18: Add i2c initialization for Z8F0811/Hauppage
 IR transceivers
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Mark Lord <lkml@rtr.ca>,
	Jarod Wilson <jarod@redhat.com>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Janne Grunau <j@jannau.net>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 21:30:04 -0400
Message-Id: <1248226204.3191.61.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add support to the cx18 driver for setting up the
Z8F0811/Hauppauge IR Tx/Rx chip with the i2c binding model in newer
kernels.


Signed-off-by: Andy Walls <awalls@radix.net>
Reviewed-by: Jean Delvare <khali@linux-fr.org>


diff -r 6477aa1782d5 linux/drivers/media/video/cx18/cx18-cards.c
--- a/linux/drivers/media/video/cx18/cx18-cards.c	Tue Jul 21 09:17:24 2009 -0300
+++ b/linux/drivers/media/video/cx18/cx18-cards.c	Tue Jul 21 20:55:54 2009 -0400
@@ -56,7 +56,8 @@
 	.hw_audio_ctrl = CX18_HW_418_AV,
 	.hw_muxer = CX18_HW_CS5345,
 	.hw_all = CX18_HW_TVEEPROM | CX18_HW_418_AV | CX18_HW_TUNER |
-		  CX18_HW_CS5345 | CX18_HW_DVB | CX18_HW_GPIO_RESET_CTRL,
+		  CX18_HW_CS5345 | CX18_HW_DVB | CX18_HW_GPIO_RESET_CTRL |
+		  CX18_HW_Z8F0811_IR_HAUP,
 	.video_inputs = {
 		{ CX18_CARD_INPUT_VID_TUNER,  0, CX18_AV_COMPOSITE7 },
 		{ CX18_CARD_INPUT_SVIDEO1,    1, CX18_AV_SVIDEO1    },
@@ -102,7 +103,8 @@
 	.hw_audio_ctrl = CX18_HW_418_AV,
 	.hw_muxer = CX18_HW_CS5345,
 	.hw_all = CX18_HW_TVEEPROM | CX18_HW_418_AV | CX18_HW_TUNER |
-		  CX18_HW_CS5345 | CX18_HW_DVB | CX18_HW_GPIO_RESET_CTRL,
+		  CX18_HW_CS5345 | CX18_HW_DVB | CX18_HW_GPIO_RESET_CTRL |
+		  CX18_HW_Z8F0811_IR_HAUP,
 	.video_inputs = {
 		{ CX18_CARD_INPUT_VID_TUNER,  0, CX18_AV_COMPOSITE7 },
 		{ CX18_CARD_INPUT_SVIDEO1,    1, CX18_AV_SVIDEO1    },
diff -r 6477aa1782d5 linux/drivers/media/video/cx18/cx18-cards.h
--- a/linux/drivers/media/video/cx18/cx18-cards.h	Tue Jul 21 09:17:24 2009 -0300
+++ b/linux/drivers/media/video/cx18/cx18-cards.h	Tue Jul 21 20:55:54 2009 -0400
@@ -22,13 +22,17 @@
  */
 
 /* hardware flags */
-#define CX18_HW_TUNER		(1 << 0)
-#define CX18_HW_TVEEPROM	(1 << 1)
-#define CX18_HW_CS5345		(1 << 2)
-#define CX18_HW_DVB		(1 << 3)
-#define CX18_HW_418_AV		(1 << 4)
-#define CX18_HW_GPIO_MUX	(1 << 5)
-#define CX18_HW_GPIO_RESET_CTRL	(1 << 6)
+#define CX18_HW_TUNER			(1 << 0)
+#define CX18_HW_TVEEPROM		(1 << 1)
+#define CX18_HW_CS5345			(1 << 2)
+#define CX18_HW_DVB			(1 << 3)
+#define CX18_HW_418_AV			(1 << 4)
+#define CX18_HW_GPIO_MUX		(1 << 5)
+#define CX18_HW_GPIO_RESET_CTRL		(1 << 6)
+#define CX18_HW_Z8F0811_IR_TX_HAUP	(1 << 7)
+#define CX18_HW_Z8F0811_IR_RX_HAUP	(1 << 8)
+#define CX18_HW_Z8F0811_IR_HAUP	(CX18_HW_Z8F0811_IR_RX_HAUP | \
+				 CX18_HW_Z8F0811_IR_TX_HAUP)
 
 /* video inputs */
 #define	CX18_CARD_INPUT_VID_TUNER	1
diff -r 6477aa1782d5 linux/drivers/media/video/cx18/cx18-i2c.c
--- a/linux/drivers/media/video/cx18/cx18-i2c.c	Tue Jul 21 09:17:24 2009 -0300
+++ b/linux/drivers/media/video/cx18/cx18-i2c.c	Tue Jul 21 20:55:54 2009 -0400
@@ -28,6 +28,9 @@
 #include "cx18-gpio.h"
 #include "cx18-i2c.h"
 #include "cx18-irq.h"
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
+#include <media/ir-kbd-i2c.h>
+#endif
 
 #define CX18_REG_I2C_1_WR   0xf15000
 #define CX18_REG_I2C_1_RD   0xf15008
@@ -40,16 +43,20 @@
 #define GETSDL_BIT      0x0008
 
 #define CX18_CS5345_I2C_ADDR		0x4c
+#define CX18_Z8F0811_IR_TX_I2C_ADDR	0x70
+#define CX18_Z8F0811_IR_RX_I2C_ADDR	0x71
 
 /* This array should match the CX18_HW_ defines */
 static const u8 hw_addrs[] = {
-	0,			/* CX18_HW_TUNER */
-	0,			/* CX18_HW_TVEEPROM */
-	CX18_CS5345_I2C_ADDR,	/* CX18_HW_CS5345 */
-	0,			/* CX18_HW_DVB */
-	0,			/* CX18_HW_418_AV */
-	0,			/* CX18_HW_GPIO_MUX */
-	0,			/* CX18_HW_GPIO_RESET_CTRL */
+	0,				/* CX18_HW_TUNER */
+	0,				/* CX18_HW_TVEEPROM */
+	CX18_CS5345_I2C_ADDR,		/* CX18_HW_CS5345 */
+	0,				/* CX18_HW_DVB */
+	0,				/* CX18_HW_418_AV */
+	0,				/* CX18_HW_GPIO_MUX */
+	0,				/* CX18_HW_GPIO_RESET_CTRL */
+	CX18_Z8F0811_IR_TX_I2C_ADDR,	/* CX18_HW_Z8F0811_IR_TX_HAUP */
+	CX18_Z8F0811_IR_RX_I2C_ADDR,	/* CX18_HW_Z8F0811_IR_RX_HAUP */
 };
 
 /* This array should match the CX18_HW_ defines */
@@ -62,6 +69,8 @@
 	0,	/* CX18_HW_418_AV */
 	0,	/* CX18_HW_GPIO_MUX */
 	0,	/* CX18_HW_GPIO_RESET_CTRL */
+	0,	/* CX18_HW_Z8F0811_IR_TX_HAUP */
+	0,	/* CX18_HW_Z8F0811_IR_RX_HAUP */
 };
 
 /* This array should match the CX18_HW_ defines */
@@ -73,6 +82,8 @@
 	NULL,		/* CX18_HW_418_AV */
 	NULL,		/* CX18_HW_GPIO_MUX */
 	NULL,		/* CX18_HW_GPIO_RESET_CTRL */
+	NULL,		/* CX18_HW_Z8F0811_IR_TX_HAUP */
+	NULL,		/* CX18_HW_Z8F0811_IR_RX_HAUP */
 };
 
 /* This array should match the CX18_HW_ defines */
@@ -84,8 +95,41 @@
 	"cx23418_AV",
 	"gpio_mux",
 	"gpio_reset_ctrl",
+	"ir_tx_z8f0811_haup",
+	"ir_rx_z8f0811_haup",
 };
 
+static int cx18_i2c_new_ir(struct i2c_adapter *adap, u32 hw, const char *type,
+			   u8 addr)
+{
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
+	struct i2c_board_info info;
+	struct IR_i2c_init_data ir_init_data;
+	unsigned short addr_list[2] = { addr, I2C_CLIENT_END };
+
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, type, I2C_NAME_SIZE);
+
+	/* Our default information for ir-kbd-i2c.c to use */
+	switch (hw) {
+	case CX18_HW_Z8F0811_IR_RX_HAUP:
+		memset(&ir_init_data, 0, sizeof(struct IR_i2c_init_data));
+		ir_init_data.ir_codes = ir_codes_hauppauge_new;
+		ir_init_data.internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
+		ir_init_data.type = IR_TYPE_RC5;
+		ir_init_data.name = "CX23418 Z8F0811 Hauppauge";
+		info.platform_data = &ir_init_data;
+		break;
+	default:
+		break;
+	}
+
+	return i2c_new_probed_device(adap, &info, addr_list) == NULL ? -1 : 0;
+#else
+	return -1;
+#endif
+}
+
 int cx18_i2c_register(struct cx18 *cx, unsigned idx)
 {
 	struct v4l2_subdev *sd;
@@ -115,11 +159,14 @@
 		return sd != NULL ? 0 : -1;
 	}
 
+	if (hw & CX18_HW_Z8F0811_IR_HAUP)
+		return cx18_i2c_new_ir(adap, hw, type, hw_addrs[idx]);
+
 	/* Is it not an I2C device or one we do not wish to register? */
 	if (!hw_addrs[idx])
 		return -1;
 
-	/* It's an I2C device other than an analog tuner */
+	/* It's an I2C device other than an analog tuner or IR chip */
 	sd = v4l2_i2c_new_subdev(&cx->v4l2_dev, adap, mod, type, hw_addrs[idx]);
 	if (sd != NULL)
 		sd->grp_id = hw;


