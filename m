Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab1KTO4d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 09:56:33 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Eddi De Pieri <eddi@depieri.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 5/8] [media] em28xx: initial support for HAUPPAUGE HVR-930C again
Date: Sun, 20 Nov 2011 12:56:15 -0200
Message-Id: <1321800978-27912-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1321800978-27912-4-git-send-email-mchehab@redhat.com>
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
 <1321800978-27912-2-git-send-email-mchehab@redhat.com>
 <1321800978-27912-3-git-send-email-mchehab@redhat.com>
 <1321800978-27912-4-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Eddi De Pieri <eddi@depieri.net>

With this patch I try again to add initial support for HVR930C.

Tested only DVB-T, since in Italy Analog service is stopped.

Actually "scan -a0 -f1", find only about 50 channel while 400 should
be available.

[mchehab@redhat.com: Tested with DVB-C and fixed a few whitespace issues]
Tested-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Eddi De Pieri <eddi@depieri.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/xc5000.c      |    4 +
 drivers/media/dvb/frontends/drxk.h        |    2 +
 drivers/media/dvb/frontends/drxk_hard.c   |    4 +-
 drivers/media/video/em28xx/em28xx-cards.c |   37 ++++++++-
 drivers/media/video/em28xx/em28xx-dvb.c   |  136 ++++++++++++++++++++++++++++-
 drivers/media/video/em28xx/em28xx.h       |    2 +
 6 files changed, 181 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index ecd1f95..048f489 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -1004,6 +1004,8 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret = 0;
 
+	mutex_lock(&xc5000_list_mutex);
+
 	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
 		ret = xc5000_fwupload(fe);
 		if (ret != XC_RESULT_SUCCESS)
@@ -1023,6 +1025,8 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
 	/* Default to "CABLE" mode */
 	ret |= xc_write_reg(priv, XREG_SIGNALSOURCE, XC_RF_MODE_CABLE);
 
+	mutex_unlock(&xc5000_list_mutex);
+
 	return ret;
 }
 
diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb/frontends/drxk.h
index 58baf41..e6d42e2 100644
--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -26,6 +26,8 @@ struct drxk_config {
 	bool	antenna_dvbt;
 	u16	antenna_gpio;
 
+	int    chunk_size;
+
 	const char *microcode_name;
 };
 
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index dc13fd8..2392092 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -681,7 +681,8 @@ static int init_state(struct drxk_state *state)
 	state->m_hasOOB = false;
 	state->m_hasAudio = false;
 
-	state->m_ChunkSize = 124;
+	if (!state->m_ChunkSize)
+	    state->m_ChunkSize = 124;
 
 	state->m_oscClockFreq = 0;
 	state->m_smartAntInverted = false;
@@ -6430,6 +6431,7 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	state->no_i2c_bridge = config->no_i2c_bridge;
 	state->antenna_gpio = config->antenna_gpio;
 	state->antenna_dvbt = config->antenna_dvbt;
+	state->m_ChunkSize = config->chunk_size;
 
 	/* NOTE: as more UIO bits will be used, add them to the mask */
 	state->UIO_mask = config->antenna_gpio;
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 19a5be3..705aedf 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -336,6 +336,24 @@ static struct em28xx_reg_seq pctv_460e[] = {
 	{             -1,   -1,   -1,  -1},
 };
 
+static struct em28xx_reg_seq hauppauge_930c_gpio[] = {
+// xc5000 reset
+	{EM2874_R80_GPIO,	0x6f,	0xff,	10},
+	{EM2874_R80_GPIO,	0x4f,	0xff,	10},
+	{EM2874_R80_GPIO,	0x6f,	0xff,	10},
+	{EM2874_R80_GPIO,	0x4f,	0xff,	10},
+	{ -1,			-1,	-1,	-1},
+};
+
+#if 0
+static struct em28xx_reg_seq hauppauge_930c_digital[] = {
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
@@ -892,6 +910,19 @@ struct em28xx_board em28xx_boards[] = {
 				EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
 	},
+	[EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C] = {
+		.name         = "Hauppauge WinTV HVR 930C",
+		.has_dvb      = 1,
+//#if 0
+//		.tuner_type   = TUNER_XC5000,
+//		.tuner_addr   = 0x41,
+//		.dvb_gpio     = hauppauge_930c_digital, /* FIXME: probably wrong */
+		.tuner_gpio   = hauppauge_930c_gpio,
+//#endif
+		.i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
+				EM28XX_I2C_CLK_WAIT_ENABLE |
+				EM28XX_I2C_FREQ_400_KHZ,
+	},
 	[EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900] = {
 		.name         = "Hauppauge WinTV HVR 900",
 		.tda9887_conf = TDA9887_PRESENT,
@@ -1975,6 +2006,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM28174_BOARD_PCTV_290E },
 	{ USB_DEVICE(0x2013, 0x024c),
 			.driver_info = EM28174_BOARD_PCTV_460E },
+	{ USB_DEVICE(0x2040, 0x1605),
+			.driver_info = EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
@@ -2028,10 +2061,10 @@ int em28xx_tuner_callback(void *ptr, int component, int command, int arg)
 	int rc = 0;
 	struct em28xx *dev = ptr;
 
-	if (dev->tuner_type != TUNER_XC2028)
+	if (dev->tuner_type != TUNER_XC2028 && dev->tuner_type != TUNER_XC5000)
 		return 0;
 
-	if (command != XC2028_TUNER_RESET)
+	if (command != XC2028_TUNER_RESET && command != XC5000_TUNER_RESET)
 		return 0;
 
 	rc = em28xx_gpio_set(dev, dev->board.tuner_gpio);
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index cef7a2d..d19939b 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -316,6 +316,14 @@ struct drxk_config terratec_h5_drxk = {
 	.microcode_name = "dvb-usb-terratec-h5-drxk.fw",
 };
 
+struct drxk_config hauppauge_930c_drxk = {
+	.adr = 0x29,
+	.single_master = 1,
+	.no_i2c_bridge = 1,
+	.microcode_name = "dvb-usb-hauppauge-hvr930c-drxk.fw",
+	.chunk_size = 56,
+};
+
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct em28xx_dvb *dvb = fe->sec_priv;
@@ -334,6 +342,90 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 	return status;
 }
 
+static void hauppauge_hvr930c_init(struct em28xx *dev)
+{
+	int i;
+
+	struct em28xx_reg_seq hauppauge_hvr930c_init[] = {
+		{EM2874_R80_GPIO,	0xff,	0xff,	101},  //11111111
+//		{0xd            ,	0xff,	0xff,	101},  //11111111
+		{EM2874_R80_GPIO,	0xfb,	0xff,	50},   //11111011  init bit 3
+		{EM2874_R80_GPIO,	0xff,	0xff,	184},  //11111111
+		{ -1,                   -1,     -1,     -1},
+	};
+	struct em28xx_reg_seq hauppauge_hvr930c_end[] = {
+		{EM2874_R80_GPIO,	0xef,	0xff,	1},    //11101111
+		{EM2874_R80_GPIO,	0xaf,	0xff,	101},  //10101111  init bit 7
+		{EM2874_R80_GPIO,	0xef,	0xff,	118},   //11101111
+
+
+//per il tuner?
+		{EM2874_R80_GPIO,	0xef,	0xff,	1},  //11101111
+		{EM2874_R80_GPIO,	0xcf,	0xff,	11},    //11001111  init bit 6
+		{EM2874_R80_GPIO,	0xef,	0xff,	64},  //11101111
+
+		{EM2874_R80_GPIO,	0xcf,	0xff,	101},  //11001111  init bit 6
+		{EM2874_R80_GPIO,	0xef,	0xff,	101},  //11101111
+		{EM2874_R80_GPIO,	0xcf,	0xff,	11},  //11001111  init bit 6
+		{EM2874_R80_GPIO,	0xef,	0xff,	101},  //11101111
+
+//		{EM2874_R80_GPIO,	0x6f,	0xff,	10},    //01101111
+//		{EM2874_R80_GPIO,	0x6d,	0xff,	100},  //01101101  init bit 2
+		{ -1,                   -1,     -1,     -1},
+	};
+
+	struct em28xx_reg_seq hauppauge_hvr930c_end2[] = {
+//		{EM2874_R80_GPIO,	0x6f,	0xff,	124},  //01101111
+//		{EM2874_R80_GPIO,	0x4f,	0xff,	11},   //01001111  init bit 6
+//		{EM2874_R80_GPIO,	0x6f,	0xff,	1},    //01101111
+//		{EM2874_R80_GPIO,	0x4f,	0xff,	10},   //01001111  init bit 6
+//		{EM2874_R80_GPIO,	0x6f,	0xff,	100},  //01101111
+//		{0xd            ,	0x42,	0xff,	101},  //11111111
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
+	em28xx_gpio_set(dev, hauppauge_hvr930c_init);
+	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
+	msleep(10);
+	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
+	msleep(10);
+
+	dev->i2c_client.addr = 0x82 >> 1;
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++)
+		i2c_master_send(&dev->i2c_client, regs[i].r, regs[i].len);
+	em28xx_gpio_set(dev, hauppauge_hvr930c_end);
+
+	msleep(100);
+
+	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
+	msleep(30);
+
+	em28xx_gpio_set(dev, hauppauge_hvr930c_end2);
+	msleep(10);
+	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x45);
+	msleep(10);
+
+}
+
 static void terratec_h5_init(struct em28xx *dev)
 {
 	int i;
@@ -788,6 +880,47 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			mfe_shared = 1;
 		}
 		break;
+	case EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C:
+		hauppauge_hvr930c_init(dev);
+
+		dvb->dont_attach_fe1 = 1;
+
+		dvb->fe[0] = dvb_attach(drxk_attach, &hauppauge_930c_drxk, &dev->i2c_adap, &dvb->fe[1]);
+		if (!dvb->fe[0]) {
+			result = -EINVAL;
+			goto out_free;
+		}
+		/* FIXME: do we need a pll semaphore? */
+		dvb->fe[0]->sec_priv = dvb;
+		sema_init(&dvb->pll_mutex, 1);
+		dvb->gate_ctrl = dvb->fe[0]->ops.i2c_gate_ctrl;
+		dvb->fe[0]->ops.i2c_gate_ctrl = drxk_gate_ctrl;
+		dvb->fe[1]->id = 1;
+
+		/* Attach xc5000 */
+		struct xc5000_config cfg;
+		memset(&cfg, 0, sizeof(cfg));
+		cfg.i2c_address  = 0x61;
+		//cfg.if_khz = 4570; //FIXME
+		cfg.if_khz = 4000; //FIXME (should be ok) read from i2c traffic
+
+		if (dvb->fe[0]->ops.i2c_gate_ctrl)
+			dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 1);
+		if (!dvb_attach(xc5000_attach, dvb->fe[0], &dev->i2c_adap, &cfg)) {
+			result = -EINVAL;
+			goto out_free;
+		}
+
+		if (dvb->fe[0]->ops.i2c_gate_ctrl)
+			dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 0);
+
+		/* Hack - needed by drxk/tda18271c2dd */
+		dvb->fe[1]->tuner_priv = dvb->fe[0]->tuner_priv;
+		memcpy(&dvb->fe[1]->ops.tuner_ops,
+		       &dvb->fe[0]->ops.tuner_ops,
+		       sizeof(dvb->fe[0]->ops.tuner_ops));
+
+		break;
 	case EM2884_BOARD_TERRATEC_H5:
 		terratec_h5_init(dev);
 
@@ -798,7 +931,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			result = -EINVAL;
 			goto out_free;
 		}
-
 		/* FIXME: do we need a pll semaphore? */
 		dvb->fe[0]->sec_priv = dvb;
 		sema_init(&dvb->pll_mutex, 1);
@@ -845,6 +977,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	}
 	/* define general-purpose callback pointer */
 	dvb->fe[0]->callback = em28xx_tuner_callback;
+	if (dvb->fe[1])
+	    dvb->fe[1]->callback = em28xx_tuner_callback;
 
 	/* register everything */
 	result = em28xx_register_dvb(dvb, THIS_MODULE, dev, &dev->udev->dev);
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 2a2cb7e..c16ae8f 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -38,6 +38,7 @@
 #include <media/videobuf-dvb.h>
 #endif
 #include "tuner-xc2028.h"
+#include "xc5000.h"
 #include "em28xx-reg.h"
 
 /* Boards supported by driver */
@@ -121,6 +122,7 @@
 #define EM28174_BOARD_PCTV_290E                   78
 #define EM2884_BOARD_TERRATEC_H5		  79
 #define EM28174_BOARD_PCTV_460E                   80
+#define EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C	  81
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.7.7.1

