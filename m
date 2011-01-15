Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:3220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab1AOQKe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 11:10:34 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0FGAYrZ021907
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 11:10:34 -0500
Received: from pedra (vpn-234-251.phx2.redhat.com [10.3.234.251])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p0FG5PXx001803
	for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 11:10:33 -0500
Date: Sat, 15 Jan 2011 16:04:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 7/8] [media] saa7134: Fix digital mode on Kworld SBTVD
Message-ID: <20110115160423.37980983@pedra>
In-Reply-To: <cover.1295114145.git.mchehab@redhat.com>
References: <cover.1295114145.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch fixes digital mode on Kworld SBTVD. Unfortunately, it disables
analog mode.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index b242600..dea90a1 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5179,7 +5179,11 @@ struct saa7134_board saa7134_boards[] = {
 	[SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG] = {
 		.name           = "Kworld PCI SBTVD/ISDB-T Full-Seg Hybrid",
 		.audio_clock    = 0x00187de7,
+#if 0
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
+#else
+		.tuner_type	= UNSET,
+#endif
 		.tuner_addr     = ADDR_UNSET,
 		.radio_type     = UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -5191,7 +5195,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
-			.gpio	= 0x4000,
 #if 0	/* FIXME */
 		}, {
 			.name   = name_comp1,
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index 064bf2c..d2a12df 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -236,13 +236,38 @@ static struct tda18271_std_map mb86a20s_tda18271_std_map = {
 
 static struct tda18271_config kworld_tda18271_config = {
 	.std_map = &mb86a20s_tda18271_std_map,
-	.gate    = TDA18271_GATE_ANALOG,
+	.gate    = TDA18271_GATE_DIGITAL,
 };
 
 static const struct mb86a20s_config kworld_mb86a20s_config = {
 	.demod_address = 0x10,
 };
 
+static int kworld_sbtvd_gate_ctrl(struct dvb_frontend* fe, int enable)
+{
+	struct saa7134_dev *dev = fe->dvb->priv;
+
+	unsigned char initmsg[] = {0x45, 0x97};
+	unsigned char msg_enable[] = {0x45, 0xc1};
+	unsigned char msg_disable[] = {0x45, 0x81};
+	struct i2c_msg msg = {.addr = 0x4b, .flags = 0, .buf = initmsg, .len = 2};
+
+	if (i2c_transfer(&dev->i2c_adap, &msg, 1) != 1) {
+		wprintk("could not access the I2C gate\n");
+		return -EIO;
+	}
+	if (enable)
+		msg.buf = msg_enable;
+	else
+		msg.buf = msg_disable;
+	if (i2c_transfer(&dev->i2c_adap, &msg, 1) != 1) {
+		wprintk("could not access the I2C gate\n");
+		return -EIO;
+	}
+	msleep(20);
+	return 0;
+}
+
 /* ==================================================================
  * tda1004x based DVB-T cards, helper functions
  */
@@ -1639,10 +1664,21 @@ static int dvb_init(struct saa7134_dev *dev)
 					       &kworld_mb86a20s_config,
 					       &dev->i2c_adap);
 		if (fe0->dvb.frontend != NULL) {
+#if 0
+			dvb_attach(tda829x_attach, fe0->dvb.frontend,
+				   &dev->i2c_adap, 0x4b,
+				   &tda829x_no_probe);
+#else
+			dvb_attach(tda829x_attach, fe0->dvb.frontend,
+				   &dev->i2c_adap, 0x4b, NULL);
+#endif
 			dvb_attach(tda18271_attach, fe0->dvb.frontend,
 				   0x60, &dev->i2c_adap,
 				   &kworld_tda18271_config);
+			fe0->dvb.frontend->ops.i2c_gate_ctrl = kworld_sbtvd_gate_ctrl;
 		}
+
+		/* mb86a20s need to use the I2C gateway */
 		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
-- 
1.7.1


