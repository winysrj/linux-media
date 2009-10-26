Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:42098 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbZJZLyG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 07:54:06 -0400
Received: by pzk26 with SMTP id 26so7367032pzk.4
        for <linux-media@vger.kernel.org>; Mon, 26 Oct 2009 04:54:10 -0700 (PDT)
Message-ID: <4AE58DDC.8000905@gmail.com>
Date: Mon, 26 Oct 2009 19:54:04 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: v4l-dvb <linux-media@vger.kernel.org>
Subject: [PATCH] CX23885 card Mygica X8558Pro DMB-TH
Content-Type: multipart/mixed;
 boundary="------------030001000807000109050504"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030001000807000109050504
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

   This patch add support for cx23885 card Mygica X8558 Pro DMB-TH

Regards,
David

Signed-off-by: David T. L. Wong <davidtlwong@gmail.com>

--------------030001000807000109050504
Content-Type: text/x-patch;
 name="cx23885_card_mygica_x8558pro.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cx23885_card_mygica_x8558pro.patch"

changeset:   13168:988f021b2bea
tag:         tip
user:        David T.L. Wong <davidtlwong@gmail.com>
date:        Mon Oct 26 18:20:30 2009 +0800
summary:     cx23885: add card Mygica X8558 Pro DMB-TH

diff --git a/linux/drivers/media/video/cx23885/cx23885-cards.c b/linux/drivers/media/video/cx23885/cx23885-cards.c
--- a/linux/drivers/media/video/cx23885/cx23885-cards.c
+++ b/linux/drivers/media/video/cx23885/cx23885-cards.c
@@ -216,6 +216,11 @@
 		.name		= "Compro VideoMate E800",
 		.portc		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_MYGICA_X8558PRO] = {
+		.name		= "Mygica X8558 PRO DMB-TH",
+		.portb		= CX23885_MPEG_DVB,
+		.portc		= CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -351,6 +356,10 @@
 		.subvendor = 0x1858,
 		.subdevice = 0xe800,
 		.card      = CX23885_BOARD_COMPRO_VIDEOMATE_E800,
+	}, {
+		.subvendor = 0x14f1,
+		.subdevice = 0x8578,
+		.card      = CX23885_BOARD_MYGICA_X8558PRO,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -768,6 +777,15 @@
 		cx_set(GP0_IO, 0x00060006);
 		mdelay(100);
 		break;
+	case CX23885_BOARD_MYGICA_X8558PRO:
+		/* GPIO-0 reset first ATBM8830 */
+		/* GPIO-1 reset second ATBM8830 */
+		cx23885_gpio_enable(dev, GPIO_0 | GPIO_1, 1);
+		cx23885_gpio_clear(dev, GPIO_0 | GPIO_1);
+		mdelay(100);
+		cx23885_gpio_set(dev, GPIO_0 | GPIO_1);
+		mdelay(100);
+		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 		/* GPIO-0 656_CLK */
 		/* GPIO-1 656_D0 */
@@ -938,6 +956,14 @@
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
+	case CX23885_BOARD_MYGICA_X8558PRO:
+		ts1->gen_ctrl_val  = 0x5; /* Parallel */
+		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
+		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
diff --git a/linux/drivers/media/video/cx23885/cx23885-dvb.c b/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c
@@ -39,6 +39,7 @@
 #include "tda18271.h"
 #include "lgdt330x.h"
 #include "xc5000.h"
+#include "max2165.h"
 #include "tda10048.h"
 #include "tuner-xc2028.h"
 #include "tuner-simple.h"
@@ -55,6 +56,7 @@
 #include "netup-eeprom.h"
 #include "netup-init.h"
 #include "lgdt3305.h"
+#include "atbm8830.h"
 
 static unsigned int debug;
 
@@ -536,6 +538,38 @@
 	.if_khz = 6500,
 };
 
+static struct atbm8830_config mygica_x8558pro_atbm8830_cfg1 = {
+	.prod = ATBM8830_PROD_8830,
+	.demod_address = 0x44,
+	.serial_ts = 0,
+	.ts_sampling_edge = 1,
+	.ts_clk_gated = 0,
+	.osc_clk_freq = 30400, /* in kHz */
+	.if_freq = 0, /* zero IF */
+	.zif_swap_iq = 1,
+};
+
+static struct max2165_config mygic_x8558pro_max2165_cfg1 = {
+	.i2c_address = 0x60,
+	.osc_clk = 20
+};
+
+static struct atbm8830_config mygica_x8558pro_atbm8830_cfg2 = {
+	.prod = ATBM8830_PROD_8830,
+	.demod_address = 0x44,
+	.serial_ts = 1,
+	.ts_sampling_edge = 1,
+	.ts_clk_gated = 0,
+	.osc_clk_freq = 30400, /* in kHz */
+	.if_freq = 0, /* zero IF */
+	.zif_swap_iq = 1,
+};
+
+static struct max2165_config mygic_x8558pro_max2165_cfg2 = {
+	.i2c_address = 0x60,
+	.osc_clk = 20
+};
+
 static int dvb_register(struct cx23885_tsport *port)
 {
 	struct cx23885_dev *dev = port->dev;
@@ -900,6 +934,36 @@
 				0x60, &dev->i2c_bus[0].i2c_adap,
 				&hauppauge_tda18271_config);
 		break;
+	case CX23885_BOARD_MYGICA_X8558PRO:
+		switch (port->nr) {
+		/* port B */
+		case 1:
+			i2c_bus = &dev->i2c_bus[0];
+			fe0->dvb.frontend = dvb_attach(atbm8830_attach,
+				&mygica_x8558pro_atbm8830_cfg1,
+				&i2c_bus->i2c_adap);
+			if (fe0->dvb.frontend != NULL) {
+				dvb_attach(max2165_attach,
+					fe0->dvb.frontend,
+					&i2c_bus->i2c_adap,
+					&mygic_x8558pro_max2165_cfg1);
+			}
+			break;
+		/* port C */
+		case 2:
+			i2c_bus = &dev->i2c_bus[1];
+			fe0->dvb.frontend = dvb_attach(atbm8830_attach,
+				&mygica_x8558pro_atbm8830_cfg2,
+				&i2c_bus->i2c_adap);
+			if (fe0->dvb.frontend != NULL) {
+				dvb_attach(max2165_attach,
+					fe0->dvb.frontend,
+					&i2c_bus->i2c_adap,
+					&mygic_x8558pro_max2165_cfg2);
+			}
+			break;
+		}
+		break;
 
 	default:
 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
diff --git a/linux/drivers/media/video/cx23885/cx23885.h b/linux/drivers/media/video/cx23885/cx23885.h
--- a/linux/drivers/media/video/cx23885/cx23885.h
+++ b/linux/drivers/media/video/cx23885/cx23885.h
@@ -80,6 +80,7 @@
 #define CX23885_BOARD_MAGICPRO_PROHDTVE2       23
 #define CX23885_BOARD_HAUPPAUGE_HVR1850        24
 #define CX23885_BOARD_COMPRO_VIDEOMATE_E800    25
+#define CX23885_BOARD_MYGICA_X8558PRO          26
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002


--------------030001000807000109050504--
