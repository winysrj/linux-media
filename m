Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:45446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab1GKB70 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:26 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xQVd023429
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:26 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKR030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:25 -0400
Date: Sun, 10 Jul 2011 22:58:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 09/21] [media] Add initial support for Terratec H5
Message-ID: <20110710225847.7e45c12d@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Not working yet. There are some fixes at the DRX-K that are needed
for it to work.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/Kconfig b/drivers/media/video/em28xx/Kconfig
index 49878fd..281ee42 100644
--- a/drivers/media/video/em28xx/Kconfig
+++ b/drivers/media/video/em28xx/Kconfig
@@ -39,6 +39,8 @@ config VIDEO_EM28XX_DVB
 	select DVB_S921 if !DVB_FE_CUSTOMISE
 	select DVB_DRXD if !DVB_FE_CUSTOMISE
 	select DVB_CXD2820R if !DVB_FE_CUSTOMISE
+	select DVB_DRXK if !DVB_FE_CUSTOMISE
+	select DVB_TDA18271C2DD if !DVB_FE_CUSTOMISE
 	select VIDEOBUF_DVB
 	---help---
 	  This adds support for DVB cards based on the
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index c892a1e..cc0b9a3 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -300,6 +300,23 @@ static struct em28xx_reg_seq pctv_290e[] = {
 	{-1,			-1,	-1,		-1},
 };
 
+#if 0
+static struct em28xx_reg_seq terratec_h5_gpio[] = {
+	{EM28XX_R08_GPIO,	0xff,	0xff,	10},
+	{EM2874_R80_GPIO,	0xf6,	0xff,	100},
+	{EM2874_R80_GPIO,	0xf2,	0xff,	50},
+	{EM2874_R80_GPIO,	0xf6,	0xff,	50},
+	{ -1,			-1,	-1,	-1},
+};
+
+static struct em28xx_reg_seq terratec_h5_digital[] = {
+	{EM2874_R80_GPIO,	0xf6,	0xff,	10},
+	{EM2874_R80_GPIO,	0xe6,	0xff,	100},
+	{EM2874_R80_GPIO,	0xa6,	0xff,	10},
+	{ -1,			-1,	-1,	-1},
+};
+#endif
+
 /*
  *  Board definitions
  */
@@ -843,6 +860,19 @@ struct em28xx_board em28xx_boards[] = {
 			.gpio     = terratec_cinergy_USB_XS_FR_analog,
 		} },
 	},
+	[EM2884_BOARD_TERRATEC_H5] = {
+		.name         = "Terratec Cinergy H5",
+		.has_dvb      = 1,
+#if 0
+		.tuner_type   = TUNER_PHILIPS_TDA8290,
+		.tuner_addr   = 0x41,
+		.dvb_gpio     = terratec_h5_digital, /* FIXME: probably wrong */
+		.tuner_gpio   = terratec_h5_gpio,
+#endif
+		.i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
+				EM28XX_I2C_CLK_WAIT_ENABLE |
+				EM28XX_I2C_FREQ_400_KHZ,
+	},
 	[EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900] = {
 		.name         = "Hauppauge WinTV HVR 900",
 		.tda9887_conf = TDA9887_PRESENT,
@@ -1855,6 +1885,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
 	{ USB_DEVICE(0x0ccd, 0x0043),
 			.driver_info = EM2870_BOARD_TERRATEC_XS },
+	{ USB_DEVICE(0x0ccd, 0x10a2),
+			.driver_info = EM2884_BOARD_TERRATEC_H5 },
 	{ USB_DEVICE(0x0ccd, 0x0047),
 			.driver_info = EM2880_BOARD_TERRATEC_PRODIGY_XS },
 	{ USB_DEVICE(0x0ccd, 0x0084),
@@ -2840,6 +2872,11 @@ static int em28xx_init_dev(struct em28xx **devhandle, struct usb_device *udev,
 			em28xx_info("chip ID is em2882/em2883\n");
 			dev->wait_after_write = 0;
 			break;
+		case CHIP_ID_EM2884:
+			em28xx_info("chip ID is em2884\n");
+			dev->reg_gpio_num = EM2874_R80_GPIO;
+			dev->wait_after_write = 0;
+			break;
 		default:
 			em28xx_info("em28xx chip ID = %d\n", dev->chip_id);
 		}
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 16c9b73..01b8910 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -211,6 +211,7 @@ int em28xx_write_reg(struct em28xx *dev, u16 reg, u8 val)
 {
 	return em28xx_write_regs(dev, reg, &val, 1);
 }
+EXPORT_SYMBOL_GPL(em28xx_write_reg);
 
 /*
  * em28xx_write_reg_bits()
@@ -618,7 +619,9 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 {
 	int rc;
 
-	if (dev->chip_id == CHIP_ID_EM2874 || dev->chip_id == CHIP_ID_EM28174) {
+	if (dev->chip_id == CHIP_ID_EM2874 ||
+	    dev->chip_id == CHIP_ID_EM2884 ||
+	    dev->chip_id == CHIP_ID_EM28174) {
 		/* The Transport Stream Enable Register moved in em2874 */
 		if (!start) {
 			rc = em28xx_write_reg_bits(dev, EM2874_R5F_TS_ENABLE,
@@ -887,6 +890,7 @@ int em28xx_gpio_set(struct em28xx *dev, struct em28xx_reg_seq *gpio)
 	}
 	return rc;
 }
+EXPORT_SYMBOL_GPL(em28xx_gpio_set);
 
 int em28xx_set_mode(struct em28xx *dev, enum em28xx_mode set_mode)
 {
@@ -1111,7 +1115,7 @@ int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev)
 	unsigned int chip_cfg2;
 	unsigned int packet_size = 564;
 
-	if (dev->chip_id == CHIP_ID_EM2874) {
+	if (dev->chip_id == CHIP_ID_EM2874 || dev->chip_id == CHIP_ID_EM2884) {
 		/* FIXME - for now assume 564 like it was before, but the
 		   em2874 code should be added to return the proper value... */
 		packet_size = 564;
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 012ab8e..b8686c1 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -1,7 +1,7 @@
 /*
  DVB device driver for em28xx
 
- (c) 2008 Mauro Carvalho Chehab <mchehab@infradead.org>
+ (c) 2008-2011 Mauro Carvalho Chehab <mchehab@infradead.org>
 
  (c) 2008 Devin Heitmueller <devin.heitmueller@gmail.com>
 	- Fixes for the driver to properly work with HVR-950
@@ -40,6 +40,8 @@
 #include "s921.h"
 #include "drxd.h"
 #include "cxd2820r.h"
+#include "tda18271c2dd.h"
+#include "drxk.h"
 
 MODULE_DESCRIPTION("driver for em28xx based DVB cards");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
@@ -73,6 +75,10 @@ struct em28xx_dvb {
 	struct dmx_frontend        fe_hw;
 	struct dmx_frontend        fe_mem;
 	struct dvb_net             net;
+
+	/* Due to DRX-D - probably need changes */
+	int (*gate_ctrl)(struct dvb_frontend *, int);
+	struct semaphore      pll_mutex;
 };
 
 
@@ -295,6 +301,78 @@ static struct drxd_config em28xx_drxd = {
 	.disable_i2c_gate_ctrl = 1,
 };
 
+#define TERRATEC_H5_DRXK_I2C_ADDR	0x29
+
+struct drxk_config terratec_h5_drxk = {
+	.adr = 0x29,
+};
+
+static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct em28xx_dvb *dvb = fe->sec_priv;
+	int status;
+
+	if (!dvb)
+		return -EINVAL;
+
+	if (enable) {
+		down(&dvb->pll_mutex);
+		status = dvb->gate_ctrl(fe, 1);
+	} else {
+		status = dvb->gate_ctrl(fe, 0);
+		up(&dvb->pll_mutex);
+	}
+	return status;
+}
+
+static void terratec_h5_init(struct em28xx *dev)
+{
+	int i;
+	struct em28xx_reg_seq terratec_h5_init[] = {
+		{EM28XX_R08_GPIO,	0xff,	0xff,	10},
+		{EM2874_R80_GPIO,	0xf6,	0xff,	100},
+		{EM2874_R80_GPIO,	0xf2,	0xff,	50},
+		{EM2874_R80_GPIO,	0xf6,	0xff,	100},
+		{ -1,                   -1,     -1,     -1},
+	};
+	struct em28xx_reg_seq terratec_h5_end[] = {
+		{EM2874_R80_GPIO,	0xe6,	0xff,	100},
+		{EM2874_R80_GPIO,	0xa6,	0xff,	50},
+		{EM2874_R80_GPIO,	0xe6,	0xff,	100},
+		{ -1,                   -1,     -1,     -1},
+	};
+	struct {
+		unsigned char r[4];
+		int len;
+	} regs[] = {
+		{{ 0x06, 0x02, 0x00, 0x31 }, 4},
+		{{ 0x01, 0x02 }, 2},
+		{{ 0x01, 0x02, 0x00, 0xc6 }, 4},
+		{{ 0x01, 0x00 }, 2},
+		{{ 0x01, 0x00, 0xff, 0xaf }, 4},
+		{{ 0x01, 0x00, 0x03, 0xa0 }, 4},
+		{{ 0x01, 0x00 }, 2},
+		{{ 0x01, 0x00, 0x73, 0xaf }, 4},
+		{{ 0x04, 0x00 }, 2},
+		{{ 0x00, 0x04 }, 2},
+		{{ 0x00, 0x04, 0x00, 0x0a }, 4},
+		{{ 0x04, 0x14 }, 2},
+		{{ 0x04, 0x14, 0x00, 0x00 }, 4},
+	};
+
+	em28xx_gpio_set(dev, terratec_h5_init);
+	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
+	msleep(10);
+	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x45);
+	msleep(10);
+
+	dev->i2c_client.addr = 0x82 >> 1;
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++)
+		i2c_master_send(&dev->i2c_client, regs[i].r, regs[i].len);
+	em28xx_gpio_set(dev, terratec_h5_end);
+};
+
 static int mt352_terratec_xs_init(struct dvb_frontend *fe)
 {
 	/* Values extracted from a USB trace of the Terratec Windows driver */
@@ -689,6 +767,36 @@ static int dvb_init(struct em28xx *dev)
 			}
 		}
 		break;
+	case EM2884_BOARD_TERRATEC_H5:
+		terratec_h5_init(dev);
+
+		/* dvb->fe[1] will be DVB-C, and dvb->fe[0] will be DVB-T */
+		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_h5_drxk, &dev->i2c_adap, &dvb->fe[1]);
+		if (!dvb->fe[0] || !dvb->fe[1]) {
+			result = -EINVAL;
+			goto out_free;
+		}
+		/* FIXME: do we need a pll semaphore? */
+		dvb->fe[0]->sec_priv = dvb;
+		sema_init(&dvb->pll_mutex, 1);
+		dvb->gate_ctrl = dvb->fe[0]->ops.i2c_gate_ctrl;
+		dvb->fe[0]->ops.i2c_gate_ctrl = drxk_gate_ctrl;
+		dvb->fe[1]->ops.i2c_gate_ctrl = drxk_gate_ctrl;
+		dvb->fe[1]->id = 1;
+
+		/* Attach tda18271 */
+		if (dvb->fe[0]->ops.i2c_gate_ctrl)
+			dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 1);
+		if (!dvb_attach(tda18271c2dd_attach, dvb->fe[0], &dev->i2c_adap, 0x60)) {
+			result = -EINVAL;
+			goto out_free;
+		}
+		if (dvb->fe[0]->ops.i2c_gate_ctrl)
+			dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 0);
+		if (dvb->fe[1]->ops.i2c_gate_ctrl)
+			dvb->fe[1]->ops.i2c_gate_ctrl(dvb->fe[1], 1);
+
+		break;
 	default:
 		em28xx_errdev("/2: The frontend of your DVB/ATSC card"
 				" isn't supported yet\n");
diff --git a/drivers/media/video/em28xx/em28xx-i2c.c b/drivers/media/video/em28xx/em28xx-i2c.c
index 4ece685..548d2df 100644
--- a/drivers/media/video/em28xx/em28xx-i2c.c
+++ b/drivers/media/video/em28xx/em28xx-i2c.c
@@ -330,7 +330,9 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
 	struct em28xx_eeprom *em_eeprom = (void *)eedata;
 	int i, err, size = len, block;
 
-	if (dev->chip_id == CHIP_ID_EM2874 || dev->chip_id == CHIP_ID_EM28174) {
+	if (dev->chip_id == CHIP_ID_EM2874 ||
+	    dev->chip_id == CHIP_ID_EM28174 ||
+	    dev->chip_id == CHIP_ID_EM2884) {
 		/* Empia switched to a 16-bit addressable eeprom in newer
 		   devices.  While we could certainly write a routine to read
 		   the eeprom, there is nothing of use in there that cannot be
diff --git a/drivers/media/video/em28xx/em28xx-reg.h b/drivers/media/video/em28xx/em28xx-reg.h
index e92a28e..66f7923 100644
--- a/drivers/media/video/em28xx/em28xx-reg.h
+++ b/drivers/media/video/em28xx/em28xx-reg.h
@@ -201,6 +201,7 @@ enum em28xx_chip_id {
 	CHIP_ID_EM2870 = 35,
 	CHIP_ID_EM2883 = 36,
 	CHIP_ID_EM2874 = 65,
+	CHIP_ID_EM2884 = 68,
 	CHIP_ID_EM28174 = 113,
 };
 
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index e03849f..d80658b 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -117,9 +117,9 @@
 #define EM2800_BOARD_VC211A			  74
 #define EM2882_BOARD_DIKOM_DK300		  75
 #define EM2870_BOARD_KWORLD_A340		  76
-#define EM2874_BOARD_LEADERSHIP_ISDBT			  77
+#define EM2874_BOARD_LEADERSHIP_ISDBT		  77
 #define EM28174_BOARD_PCTV_290E                   78
-
+#define EM2884_BOARD_TERRATEC_H5		  79
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.7.1


