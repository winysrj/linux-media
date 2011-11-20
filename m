Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab1KTO4b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 09:56:31 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAKEuUVc028812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 20 Nov 2011 09:56:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 6/8] [media] em28xx: Fix CodingStyle issues introduced by changeset 82e7dbb
Date: Sun, 20 Nov 2011 12:56:16 -0200
Message-Id: <1321800978-27912-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1321800978-27912-5-git-send-email-mchehab@redhat.com>
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
 <1321800978-27912-2-git-send-email-mchehab@redhat.com>
 <1321800978-27912-3-git-send-email-mchehab@redhat.com>
 <1321800978-27912-4-git-send-email-mchehab@redhat.com>
 <1321800978-27912-5-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/drxk_hard.c   |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c |   17 +++++----
 drivers/media/video/em28xx/em28xx-dvb.c   |   57 +++++++++++------------------
 3 files changed, 32 insertions(+), 44 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 2392092..95cbc98 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -682,7 +682,7 @@ static int init_state(struct drxk_state *state)
 	state->m_hasAudio = false;
 
 	if (!state->m_ChunkSize)
-	    state->m_ChunkSize = 124;
+		state->m_ChunkSize = 124;
 
 	state->m_oscClockFreq = 0;
 	state->m_smartAntInverted = false;
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 705aedf..d92e0af 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -337,9 +337,8 @@ static struct em28xx_reg_seq pctv_460e[] = {
 };
 
 static struct em28xx_reg_seq hauppauge_930c_gpio[] = {
-// xc5000 reset
 	{EM2874_R80_GPIO,	0x6f,	0xff,	10},
-	{EM2874_R80_GPIO,	0x4f,	0xff,	10},
+	{EM2874_R80_GPIO,	0x4f,	0xff,	10}, /* xc5000 reset */
 	{EM2874_R80_GPIO,	0x6f,	0xff,	10},
 	{EM2874_R80_GPIO,	0x4f,	0xff,	10},
 	{ -1,			-1,	-1,	-1},
@@ -905,6 +904,8 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_addr   = 0x41,
 		.dvb_gpio     = terratec_h5_digital, /* FIXME: probably wrong */
 		.tuner_gpio   = terratec_h5_gpio,
+#else
+		.tuner_type   = TUNER_ABSENT,
 #endif
 		.i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
 				EM28XX_I2C_CLK_WAIT_ENABLE |
@@ -913,12 +914,14 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C] = {
 		.name         = "Hauppauge WinTV HVR 930C",
 		.has_dvb      = 1,
-//#if 0
-//		.tuner_type   = TUNER_XC5000,
-//		.tuner_addr   = 0x41,
-//		.dvb_gpio     = hauppauge_930c_digital, /* FIXME: probably wrong */
+#if 0 /* FIXME: Add analog support */
+		.tuner_type   = TUNER_XC5000,
+		.tuner_addr   = 0x41,
+		.dvb_gpio     = hauppauge_930c_digital,
 		.tuner_gpio   = hauppauge_930c_gpio,
-//#endif
+#else
+		.tuner_type   = TUNER_ABSENT,
+#endif
 		.i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
 				EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index d19939b..55a9008 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -347,42 +347,27 @@ static void hauppauge_hvr930c_init(struct em28xx *dev)
 	int i;
 
 	struct em28xx_reg_seq hauppauge_hvr930c_init[] = {
-		{EM2874_R80_GPIO,	0xff,	0xff,	101},  //11111111
-//		{0xd            ,	0xff,	0xff,	101},  //11111111
-		{EM2874_R80_GPIO,	0xfb,	0xff,	50},   //11111011  init bit 3
-		{EM2874_R80_GPIO,	0xff,	0xff,	184},  //11111111
+		{EM2874_R80_GPIO,	0xff,	0xff,	0x65},
+		{EM2874_R80_GPIO,	0xfb,	0xff,	0x32},
+		{EM2874_R80_GPIO,	0xff,	0xff,	0xb8},
 		{ -1,                   -1,     -1,     -1},
 	};
 	struct em28xx_reg_seq hauppauge_hvr930c_end[] = {
-		{EM2874_R80_GPIO,	0xef,	0xff,	1},    //11101111
-		{EM2874_R80_GPIO,	0xaf,	0xff,	101},  //10101111  init bit 7
-		{EM2874_R80_GPIO,	0xef,	0xff,	118},   //11101111
+		{EM2874_R80_GPIO,	0xef,	0xff,	0x01},
+		{EM2874_R80_GPIO,	0xaf,	0xff,	0x65},
+		{EM2874_R80_GPIO,	0xef,	0xff,	0x76},
+		{EM2874_R80_GPIO,	0xef,	0xff,	0x01},
+		{EM2874_R80_GPIO,	0xcf,	0xff,	0x0b},
+		{EM2874_R80_GPIO,	0xef,	0xff,	0x40},
+
+		{EM2874_R80_GPIO,	0xcf,	0xff,	0x65},
+		{EM2874_R80_GPIO,	0xef,	0xff,	0x65},
+		{EM2874_R80_GPIO,	0xcf,	0xff,	0x0b},
+		{EM2874_R80_GPIO,	0xef,	0xff,	0x65},
 
-
-//per il tuner?
-		{EM2874_R80_GPIO,	0xef,	0xff,	1},  //11101111
-		{EM2874_R80_GPIO,	0xcf,	0xff,	11},    //11001111  init bit 6
-		{EM2874_R80_GPIO,	0xef,	0xff,	64},  //11101111
-
-		{EM2874_R80_GPIO,	0xcf,	0xff,	101},  //11001111  init bit 6
-		{EM2874_R80_GPIO,	0xef,	0xff,	101},  //11101111
-		{EM2874_R80_GPIO,	0xcf,	0xff,	11},  //11001111  init bit 6
-		{EM2874_R80_GPIO,	0xef,	0xff,	101},  //11101111
-
-//		{EM2874_R80_GPIO,	0x6f,	0xff,	10},    //01101111
-//		{EM2874_R80_GPIO,	0x6d,	0xff,	100},  //01101101  init bit 2
 		{ -1,                   -1,     -1,     -1},
 	};
 
-	struct em28xx_reg_seq hauppauge_hvr930c_end2[] = {
-//		{EM2874_R80_GPIO,	0x6f,	0xff,	124},  //01101111
-//		{EM2874_R80_GPIO,	0x4f,	0xff,	11},   //01001111  init bit 6
-//		{EM2874_R80_GPIO,	0x6f,	0xff,	1},    //01101111
-//		{EM2874_R80_GPIO,	0x4f,	0xff,	10},   //01001111  init bit 6
-//		{EM2874_R80_GPIO,	0x6f,	0xff,	100},  //01101111
-//		{0xd            ,	0x42,	0xff,	101},  //11111111
-		{ -1,                   -1,     -1,     -1},
-	};
 	struct {
 		unsigned char r[4];
 		int len;
@@ -419,8 +404,6 @@ static void hauppauge_hvr930c_init(struct em28xx *dev)
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
 	msleep(30);
 
-	em28xx_gpio_set(dev, hauppauge_hvr930c_end2);
-	msleep(10);
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x45);
 	msleep(10);
 
@@ -885,7 +868,9 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 		dvb->dont_attach_fe1 = 1;
 
-		dvb->fe[0] = dvb_attach(drxk_attach, &hauppauge_930c_drxk, &dev->i2c_adap, &dvb->fe[1]);
+		dvb->fe[0] = dvb_attach(drxk_attach,
+					&hauppauge_930c_drxk, &dev->i2c_adap,
+					&dvb->fe[1]);
 		if (!dvb->fe[0]) {
 			result = -EINVAL;
 			goto out_free;
@@ -901,12 +886,12 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		struct xc5000_config cfg;
 		memset(&cfg, 0, sizeof(cfg));
 		cfg.i2c_address  = 0x61;
-		//cfg.if_khz = 4570; //FIXME
-		cfg.if_khz = 4000; //FIXME (should be ok) read from i2c traffic
+		cfg.if_khz = 4000;
 
 		if (dvb->fe[0]->ops.i2c_gate_ctrl)
 			dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 1);
-		if (!dvb_attach(xc5000_attach, dvb->fe[0], &dev->i2c_adap, &cfg)) {
+		if (!dvb_attach(xc5000_attach, dvb->fe[0], &dev->i2c_adap,
+				&cfg)) {
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -978,7 +963,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	/* define general-purpose callback pointer */
 	dvb->fe[0]->callback = em28xx_tuner_callback;
 	if (dvb->fe[1])
-	    dvb->fe[1]->callback = em28xx_tuner_callback;
+		dvb->fe[1]->callback = em28xx_tuner_callback;
 
 	/* register everything */
 	result = em28xx_register_dvb(dvb, THIS_MODULE, dev, &dev->udev->dev);
-- 
1.7.7.1

