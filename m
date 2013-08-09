Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53029 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403Ab3HIMxl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 08:53:41 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?q?Alfredo=20Jes=C3=BAs=20Delaiti?=
	<alfredodelaiti@netscape.net>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 3/3] cx23885: Add DTV support for Mygica X8502/X8507 boards
Date: Fri,  9 Aug 2013 09:53:27 -0300
Message-Id: <1376052807-8215-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1376052807-8215-1-git-send-email-m.chehab@samsung.com>
References: <1376052807-8215-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those boards were missing the ISDB-T support.

Most of the work on this patch were done by Alfredo.

My work here were to port this patch from Kernel 3.2 to upstream,
fix the issue caused by the set_frontend bad hook, and add the
Kconfig bits.

Tested on a X8502 board rebranded as:
"Leadership - Placa PCI-e de Captura de Vídeo Híbrida" - product code 3800.

Thanks-to: Alfredo Delaiti <alfredodelaiti@netscape.net>
Tested-by: Alfredo Delaiti <alfredodelaiti@netscape.net>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/pci/cx23885/Kconfig         |  1 +
 drivers/media/pci/cx23885/cx23885-cards.c |  6 ++++--
 drivers/media/pci/cx23885/cx23885-dvb.c   | 25 +++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
index b3688aa..5104c80 100644
--- a/drivers/media/pci/cx23885/Kconfig
+++ b/drivers/media/pci/cx23885/Kconfig
@@ -29,6 +29,7 @@ config VIDEO_CX23885
 	select DVB_STV0367 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA10071 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_A8293 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MB86A20S if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2063 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2131 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 7e923f8..6a71a96 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -528,11 +528,12 @@ struct cx23885_board cx23885_boards[] = {
 		} },
 	},
 	[CX23885_BOARD_MYGICA_X8507] = {
-		.name		= "Mygica X8507",
+		.name		= "Mygica X8502/X8507 ISDB-T",
 		.tuner_type = TUNER_XC5000,
 		.tuner_addr = 0x61,
 		.tuner_bus	= 1,
 		.porta		= CX23885_ANALOG_VIDEO,
+		.portb		= CX23885_MPEG_DVB,
 		.input		= {
 			{
 				.type   = CX23885_VMUX_TELEVISION,
@@ -1281,7 +1282,7 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_MYGICA_X8507:
 		/* GPIO-0 (0)Analog / (1)Digital TV */
 		/* GPIO-1 reset XC5000 */
-		/* GPIO-2 reset LGS8GL5 / LGS8G75 */
+		/* GPIO-2 demod reset */
 		cx23885_gpio_enable(dev, GPIO_0 | GPIO_1 | GPIO_2, 1);
 		cx23885_gpio_clear(dev, GPIO_1 | GPIO_2);
 		mdelay(100);
@@ -1677,6 +1678,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		break;
 	case CX23885_BOARD_MYGICA_X8506:
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
+	case CX23885_BOARD_MYGICA_X8507:
 		ts1->gen_ctrl_val  = 0x5; /* Parallel */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index a25a037..971e4ff 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -69,6 +69,7 @@
 #include "stb6100_cfg.h"
 #include "tda10071.h"
 #include "a8293.h"
+#include "mb86a20s.h"
 
 static unsigned int debug;
 
@@ -492,6 +493,15 @@ static struct xc5000_config mygica_x8506_xc5000_config = {
 	.if_khz = 5380,
 };
 
+static struct mb86a20s_config mygica_x8507_mb86a20s_config = {
+	.demod_address = 0x10,
+};
+
+static struct xc5000_config mygica_x8507_xc5000_config = {
+	.i2c_address = 0x61,
+	.if_khz = 4000,
+};
+
 static struct stv090x_config prof_8000_stv090x_config = {
 	.device                 = STV0903,
 	.demod_mode             = STV090x_SINGLE,
@@ -548,6 +558,7 @@ static int cx23885_dvb_set_frontend(struct dvb_frontend *fe)
 		}
 		break;
 	case CX23885_BOARD_MYGICA_X8506:
+	case CX23885_BOARD_MYGICA_X8507:
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
 		/* Select Digital TV */
 		cx23885_gpio_set(dev, GPIO_0);
@@ -1114,6 +1125,20 @@ static int dvb_register(struct cx23885_tsport *port)
 		}
 		cx23885_set_frontend_hook(port, fe0->dvb.frontend);
 		break;
+	case CX23885_BOARD_MYGICA_X8507:
+		i2c_bus = &dev->i2c_bus[0];
+		i2c_bus2 = &dev->i2c_bus[1];
+		fe0->dvb.frontend = dvb_attach(mb86a20s_attach,
+			&mygica_x8507_mb86a20s_config,
+			&i2c_bus->i2c_adap);
+		if (fe0->dvb.frontend != NULL) {
+			dvb_attach(xc5000_attach,
+			fe0->dvb.frontend,
+			&i2c_bus2->i2c_adap,
+			&mygica_x8507_xc5000_config);
+		}
+		cx23885_set_frontend_hook(port, fe0->dvb.frontend);
+		break;
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
 		i2c_bus = &dev->i2c_bus[0];
 		i2c_bus2 = &dev->i2c_bus[1];
-- 
1.8.3.1

