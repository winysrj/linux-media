Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55569 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbaGAT4S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jul 2014 15:56:18 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 4/4] cx23885: Add si2165 support for HVR-5500
Date: Tue,  1 Jul 2014 21:55:18 +0200
Message-Id: <1404244518-8636-5-git-send-email-zzam@gentoo.org>
In-Reply-To: <1404244518-8636-1-git-send-email-zzam@gentoo.org>
References: <1404244518-8636-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The same card entry is used for HVR-4400 and HVR-5500.
Only HVR-5500 has been tested.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/pci/cx23885/Kconfig         |  1 +
 drivers/media/pci/cx23885/cx23885-cards.c | 17 +++++++++---
 drivers/media/pci/cx23885/cx23885-dvb.c   | 43 +++++++++++++++++++++++++++----
 3 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
index d1dcb1d..6cd1db2 100644
--- a/drivers/media/pci/cx23885/Kconfig
+++ b/drivers/media/pci/cx23885/Kconfig
@@ -31,6 +31,7 @@ config VIDEO_CX23885
 	select DVB_TDA10071 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_A8293 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_MB86A20S if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_SI2165 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2063 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2131 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 79f20c8..6ed0551 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -619,7 +619,12 @@ struct cx23885_board cx23885_boards[] = {
 	},
 	[CX23885_BOARD_HAUPPAUGE_HVR4400] = {
 		.name		= "Hauppauge WinTV-HVR4400",
+		.porta		= CX23885_ANALOG_VIDEO,
 		.portb		= CX23885_MPEG_DVB,
+		.portc		= CX23885_MPEG_DVB,
+		.tuner_type	= TUNER_NXP_TDA18271,
+		.tuner_addr	= 0x60, /* 0xc0 >> 1 */
+		.tuner_bus	= 1,
 	},
 	[CX23885_BOARD_AVERMEDIA_HC81R] = {
 		.name		= "AVerTV Hybrid Express Slim HC81R",
@@ -1449,13 +1454,16 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR4400:
 		/* GPIO-8 tda10071 demod reset */
+		/* GPIO-9 si2165 demod reset */
 
 		/* Put the parts into reset and back */
-		cx23885_gpio_enable(dev, GPIO_8, 1);
-		cx23885_gpio_clear(dev, GPIO_8);
+		cx23885_gpio_enable(dev, GPIO_8 | GPIO_9, 1);
+
+		cx23885_gpio_clear(dev, GPIO_8 | GPIO_9);
 		mdelay(100);
-		cx23885_gpio_set(dev, GPIO_8);
+		cx23885_gpio_set(dev, GPIO_8 | GPIO_9);
 		mdelay(100);
+
 		break;
 	case CX23885_BOARD_AVERMEDIA_HC81R:
 		cx_clear(MC417_CTL, 1);
@@ -1799,6 +1807,9 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		ts1->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
+		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index d037459..4822776 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -71,6 +71,7 @@
 #include "tda10071.h"
 #include "a8293.h"
 #include "mb86a20s.h"
+#include "si2165.h"
 
 static unsigned int debug;
 
@@ -302,6 +303,11 @@ static struct tda18271_config hauppauge_hvr1210_tuner_config = {
 	.output_opt = TDA18271_OUTPUT_LT_OFF,
 };
 
+static struct tda18271_config hauppauge_hvr4400_tuner_config = {
+	.gate    = TDA18271_GATE_DIGITAL,
+	.output_opt = TDA18271_OUTPUT_LT_OFF,
+};
+
 static struct tda18271_std_map hauppauge_hvr127x_std_map = {
 	.atsc_6   = { .if_freq = 3250, .agc_mode = 3, .std = 4,
 		      .if_lvl = 1, .rfagc_top = 0x58 },
@@ -702,6 +708,12 @@ static const struct a8293_config hauppauge_a8293_config = {
 	.i2c_addr = 0x0b,
 };
 
+static const struct si2165_config hauppauge_hvr4400_si2165_config = {
+	.i2c_addr	= 0x64,
+	.chip_mode	= SI2165_MODE_PLL_XTAL,
+	.ref_freq_Hz	= 16000000,
+};
+
 static int netup_altera_fpga_rw(void *device, int flag, int data, int read)
 {
 	struct cx23885_dev *dev = (struct cx23885_dev *)device;
@@ -1335,13 +1347,34 @@ static int dvb_register(struct cx23885_tsport *port)
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR4400:
 		i2c_bus = &dev->i2c_bus[0];
-		fe0->dvb.frontend = dvb_attach(tda10071_attach,
+		i2c_bus2 = &dev->i2c_bus[1];
+		switch (port->nr) {
+		/* port b */
+		case 1:
+			fe0->dvb.frontend = dvb_attach(tda10071_attach,
 						&hauppauge_tda10071_config,
 						&i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
-			dvb_attach(a8293_attach, fe0->dvb.frontend,
-				   &i2c_bus->i2c_adap,
-				   &hauppauge_a8293_config);
+			if (fe0->dvb.frontend != NULL) {
+				if (!dvb_attach(a8293_attach, fe0->dvb.frontend,
+						&i2c_bus->i2c_adap,
+						&hauppauge_a8293_config))
+					goto frontend_detach;
+			}
+			break;
+		/* port c */
+		case 2:
+			fe0->dvb.frontend = dvb_attach(si2165_attach,
+					&hauppauge_hvr4400_si2165_config,
+					&i2c_bus->i2c_adap);
+			if (fe0->dvb.frontend != NULL) {
+				fe0->dvb.frontend->ops.i2c_gate_ctrl = 0;
+				if (!dvb_attach(tda18271_attach,
+						fe0->dvb.frontend,
+						0x60, &i2c_bus2->i2c_adap,
+					  &hauppauge_hvr4400_tuner_config))
+					goto frontend_detach;
+			}
+			break;
 		}
 		break;
 	default:
-- 
2.0.0

