Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:3245 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2LQBGZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 20:06:25 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 2/2] cx23885: add basic DVB-S2 support for Hauppauge HVR-4400
Date: Sun, 16 Dec 2012 20:05:51 -0500
Message-Id: <1355706351-25551-2-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1355706351-25551-1-git-send-email-mkrufky@linuxtv.org>
References: <1355706351-25551-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add basic DVB-S2 support for the Hauppauge HVR-4400 PCIe board.

Thanks to Antti Palosaari and Devin Heitmueller for their
suggestions and testing.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Reviewed-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Reviewed-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/cx23885/Kconfig         |    2 ++
 drivers/media/pci/cx23885/cx23885-cards.c |   38 ++++++++++++++++++++++++++++-
 drivers/media/pci/cx23885/cx23885-dvb.c   |   27 ++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885.h       |    1 +
 4 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
index eafa114..733d6c8 100644
--- a/drivers/media/pci/cx23885/Kconfig
+++ b/drivers/media/pci/cx23885/Kconfig
@@ -26,6 +26,8 @@ config VIDEO_CX23885
 	select DVB_STV0900 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DS3000 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_STV0367 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10071 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_A8293 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2063 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2131 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 6277e145..7a79a17 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -572,7 +572,11 @@ struct cx23885_board cx23885_boards[] = {
 	[CX23885_BOARD_PROF_8000] = {
 		.name		= "Prof Revolution DVB-S2 8000",
 		.portb		= CX23885_MPEG_DVB,
-	}
+	},
+	[CX23885_BOARD_HAUPPAUGE_HVR4400] = {
+		.name		= "Hauppauge WinTV-HVR4400",
+		.portb		= CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -788,6 +792,22 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x8000,
 		.subdevice = 0x3034,
 		.card      = CX23885_BOARD_PROF_8000,
+	}, {
+		.subvendor = 0x0070,
+		.subdevice = 0xc108,
+		.card      = CX23885_BOARD_HAUPPAUGE_HVR4400,
+	}, {
+		.subvendor = 0x0070,
+		.subdevice = 0xc138,
+		.card      = CX23885_BOARD_HAUPPAUGE_HVR4400,
+	}, {
+		.subvendor = 0x0070,
+		.subdevice = 0xc12a,
+		.card      = CX23885_BOARD_HAUPPAUGE_HVR4400,
+	}, {
+		.subvendor = 0x0070,
+		.subdevice = 0xc1f8,
+		.card      = CX23885_BOARD_HAUPPAUGE_HVR4400,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1301,6 +1321,16 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		/* enable irq */
 		cx_write(GPIO_ISM, 0x00000000);/* INTERRUPTS active low*/
 		break;
+	case CX23885_BOARD_HAUPPAUGE_HVR4400:
+		/* GPIO-8 tda10071 demod reset */
+
+		/* Put the parts into reset and back */
+		cx23885_gpio_enable(dev, GPIO_8, 1);
+		cx23885_gpio_clear(dev, GPIO_8);
+		mdelay(100);
+		cx23885_gpio_set(dev, GPIO_8);
+		mdelay(100);
+		break;
 	}
 }
 
@@ -1509,6 +1539,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1210:
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
+	case CX23885_BOARD_HAUPPAUGE_HVR4400:
 		if (dev->i2c_bus[0].i2c_rc == 0)
 			hauppauge_eeprom(dev, eeprom+0xc0);
 		break;
@@ -1581,6 +1612,11 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
+	case CX23885_BOARD_HAUPPAUGE_HVR4400:
+		ts1->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
+		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 2f5b902..cf84c53 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -66,6 +66,8 @@
 #include "stv090x.h"
 #include "stb6100.h"
 #include "stb6100_cfg.h"
+#include "tda10071.h"
+#include "a8293.h"
 
 static unsigned int debug;
 
@@ -659,6 +661,20 @@ static struct mt2063_config terratec_mt2063_config[] = {
 	},
 };
 
+static const struct tda10071_config hauppauge_tda10071_config = {
+	.i2c_address = 0x05,
+	.tuner_i2c_addr = 0x54,
+	.i2c_wr_max = 64,
+	.ts_mode = TDA10071_TS_SERIAL,
+	.spec_inv = 0,
+	.xtal = 40444000, /* 40.444 MHz */
+	.pll_multiplier = 20,
+};
+
+static const struct a8293_config hauppauge_a8293_config = {
+	.i2c_addr = 0x0b,
+};
+
 static int netup_altera_fpga_rw(void *device, int flag, int data, int read)
 {
 	struct cx23885_dev *dev = (struct cx23885_dev *)device;
@@ -1242,6 +1258,17 @@ static int dvb_register(struct cx23885_tsport *port)
 			fe0->dvb.frontend->ops.set_voltage = p8000_set_voltage;
 		}
 		break;
+	case CX23885_BOARD_HAUPPAUGE_HVR4400:
+		i2c_bus = &dev->i2c_bus[0];
+		fe0->dvb.frontend = dvb_attach(tda10071_attach,
+						&hauppauge_tda10071_config,
+						&i2c_bus->i2c_adap);
+		if (fe0->dvb.frontend != NULL) {
+			dvb_attach(a8293_attach, fe0->dvb.frontend,
+				   &i2c_bus->i2c_adap,
+				   &hauppauge_a8293_config);
+		}
+		break;
 	default:
 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
 			" isn't supported yet\n",
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 67f40d3..61889b2 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -91,6 +91,7 @@
 #define CX23885_BOARD_TEVII_S471               35
 #define CX23885_BOARD_HAUPPAUGE_HVR1255_22111  36
 #define CX23885_BOARD_PROF_8000                37
+#define CX23885_BOARD_HAUPPAUGE_HVR4400        38
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
1.7.10.4

