Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:35476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675Ab1AMSQS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 13:16:18 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0DIGIsE022555
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 13 Jan 2011 13:16:18 -0500
Received: from pedra (vpn-234-99.phx2.redhat.com [10.3.234.99])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0DIECc2016438
	for <linux-media@vger.kernel.org>; Thu, 13 Jan 2011 13:16:17 -0500
Date: Thu, 13 Jan 2011 16:13:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] [media] saa7134: Fix analog mode for Kworld SBTVD
Message-ID: <20110113161346.22264631@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There were some issues at tda8290 that were preventing this device
to work. Now that those fixes were fixed, we can enable analog
mode.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index e7aa588..b242600 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5179,18 +5179,8 @@ struct saa7134_board saa7134_boards[] = {
 	[SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG] = {
 		.name           = "Kworld PCI SBTVD/ISDB-T Full-Seg Hybrid",
 		.audio_clock    = 0x00187de7,
-#if 0
-	/*
-	 * FIXME: Analog mode doesn't work, if digital is enabled. The proper
-	 * fix is to use tda8290 driver, but Kworld seems to use an
-	 * unsupported version of tda8295.
-	 */
-		.tuner_type     = TUNER_NXP_TDA18271,	/* TUNER_PHILIPS_TDA8290 */
-		.tuner_addr     = 0x60,
-#else
-		.tuner_type     = UNSET,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
 		.tuner_addr     = ADDR_UNSET,
-#endif
 		.radio_type     = UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask       = 0x8e054000,
@@ -5201,6 +5191,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
+			.gpio	= 0x4000,
 #if 0	/* FIXME */
 		}, {
 			.name   = name_comp1,
@@ -7659,36 +7650,11 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 		break;
 	}
 	case SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG:
-	{
-		struct i2c_msg msg = { .addr = 0x4b, .flags = 0 };
-		int i;
-		static u8 buffer[][2] = {
-			{0x30, 0x31},
-			{0xff, 0x00},
-			{0x41, 0x03},
-			{0x41, 0x1a},
-			{0xff, 0x02},
-			{0x34, 0x00},
-			{0x45, 0x97},
-			{0x45, 0xc1},
-		};
 		saa_writel(SAA7134_GPIO_GPMODE0 >> 2, 0x4000);
 		saa_writel(SAA7134_GPIO_GPSTATUS0 >> 2, 0x4000);
 
-		/*
-		 * FIXME: identify what device is at addr 0x4b and what means
-		 * this initialization
-		 */
-		for (i = 0; i < ARRAY_SIZE(buffer); i++) {
-			msg.buf = &buffer[i][0];
-			msg.len = ARRAY_SIZE(buffer[0]);
-			if (i2c_transfer(&dev->i2c_adap, &msg, 1) != 1)
-				printk(KERN_WARNING
-				       "%s: Unable to enable tuner(%i).\n",
-				       dev->name, i);
-		}
+		saa7134_set_gpio(dev, 27, 0);
 		break;
-	}
 	} /* switch() */
 
 	/* initialize tuner */
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index 3315a48..064bf2c 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -236,7 +236,7 @@ static struct tda18271_std_map mb86a20s_tda18271_std_map = {
 
 static struct tda18271_config kworld_tda18271_config = {
 	.std_map = &mb86a20s_tda18271_std_map,
-	.gate    = TDA18271_GATE_DIGITAL,
+	.gate    = TDA18271_GATE_ANALOG,
 };
 
 static const struct mb86a20s_config kworld_mb86a20s_config = {
@@ -623,37 +623,6 @@ static struct tda827x_config tda827x_cfg_2_sw42 = {
 
 /* ------------------------------------------------------------------ */
 
-static int __kworld_sbtvd_i2c_gate_ctrl(struct saa7134_dev *dev, int enable)
-{
-	unsigned char initmsg[] = {0x45, 0x97};
-	unsigned char msg_enable[] = {0x45, 0xc1};
-	unsigned char msg_disable[] = {0x45, 0x81};
-	struct i2c_msg msg = {.addr = 0x4b, .flags = 0, .buf = initmsg, .len = 2};
-
-	if (i2c_transfer(&dev->i2c_adap, &msg, 1) != 1) {
-		wprintk("could not access the I2C gate\n");
-		return -EIO;
-	}
-	if (enable)
-		msg.buf = msg_enable;
-	else
-		msg.buf = msg_disable;
-	if (i2c_transfer(&dev->i2c_adap, &msg, 1) != 1) {
-		wprintk("could not access the I2C gate\n");
-		return -EIO;
-	}
-	msleep(20);
-	return 0;
-}
-static int kworld_sbtvd_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
-{
-	struct saa7134_dev *dev = fe->dvb->priv;
-
-	return __kworld_sbtvd_i2c_gate_ctrl(dev, enable);
-}
-
-/* ------------------------------------------------------------------ */
-
 static struct tda1004x_config tda827x_lifeview_config = {
 	.demod_address = 0x08,
 	.invert        = 1,
@@ -1660,7 +1629,6 @@ static int dvb_init(struct saa7134_dev *dev)
 		}
 		break;
 	case SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG:
-		__kworld_sbtvd_i2c_gate_ctrl(dev, 0);
 		saa_writel(SAA7134_GPIO_GPMODE0 >> 2, 0x14000);
 		saa_writel(SAA7134_GPIO_GPSTATUS0 >> 2, 0x14000);
 		msleep(20);
@@ -1670,16 +1638,10 @@ static int dvb_init(struct saa7134_dev *dev)
 		fe0->dvb.frontend = dvb_attach(mb86a20s_attach,
 					       &kworld_mb86a20s_config,
 					       &dev->i2c_adap);
-		__kworld_sbtvd_i2c_gate_ctrl(dev, 1);
 		if (fe0->dvb.frontend != NULL) {
 			dvb_attach(tda18271_attach, fe0->dvb.frontend,
 				   0x60, &dev->i2c_adap,
 				   &kworld_tda18271_config);
-			/*
-			 * Only after success, it can initialize the gate, otherwise
-			 * an OOPS will hit, due to kfree(fe0->dvb.frontend)
-			 */
-			fe0->dvb.frontend->ops.i2c_gate_ctrl = kworld_sbtvd_i2c_gate_ctrl;
 		}
 		break;
 	default:
-- 
1.7.1


