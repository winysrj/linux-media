Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:40928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab1AOQMh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 11:12:37 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0FGCaWO022114
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 11:12:37 -0500
Received: from pedra (vpn-234-251.phx2.redhat.com [10.3.234.251])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p0FG5PY1001803
	for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 11:12:36 -0500
Date: Sat, 15 Jan 2011 16:04:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 8/8] [media] saa7134: Kworld SBTVD: make both analog and
 digital to work
Message-ID: <20110115160424.4b474921@pedra>
In-Reply-To: <cover.1295114145.git.mchehab@redhat.com>
References: <cover.1295114145.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There are some weird bugs at tda8290/tda18271 initialization, as it
insits do do analog initialization during DVB frontend attach:

DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Fujitsu mb86A20s)...
mb86a20s: mb86a20s_initfe
tda18271_write_regs: [2-0060|M] ERROR: idx = 0x5, len = 1, i2c_transfer returned: -5
tda18271_init: [2-0060|M] error -5 on line 830
tda18271_tune: [2-0060|M] error -5 on line 908
tda18271_write_regs
tda18271_write_regs: [2-0060|M] ERROR: idx = 0x5, len = 1, i2c_transfer returned: -5
tda18271c2_rf_tracking_filters_correction: [2-0060|M] error -5 on line 265
tda18271_write_regs
tda18271_write_regs: [2-0060|M] ERROR: idx = 0x25, len = 1, i2c_transfer returned: -5
tda18271_channel_configuration: [2-0060|M] error -5 on line 119
tda18271_set_analog_params: [2-0060|M] error -5 on line 1045
tda18271_set_analog_params: [2-0060|M] error -5 on line 1045
tda829x 2-004b: tda8295 not locked, no signal?
tda829x 2-004b: tda8295_i2c_bridge: disable i2c gate
tda829x 2-004b: tda8295 not locked, no signal?
tda829x 2-004b: tda8295_i2c_bridge: disable i2c gate
mb86a20s_i2c_writereg: writereg error (rc == -5, reg == 0x29, data == 0x33)
mb86a20s: Init failed. Will try again later

The problem is that mb86a20s is only visible if the analog part is disabled.

However, due to a trick at mb86a20s, it will later initialize properly:

mb86a20s: mb86a20s_initfe: Initialization succeded.

This is hacky and ugly. However, I coldn't find any easy way to fix it.
A proper fix would be to have a resource locking schema, used by both
V4L and DVB parts that would block access to analog registers while
digital registers are in use, but this will probably put tda829x into
a dead lock.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/tda8290.c b/drivers/media/common/tuners/tda8290.c
index 419d064..bc6a677 100644
--- a/drivers/media/common/tuners/tda8290.c
+++ b/drivers/media/common/tuners/tda8290.c
@@ -232,6 +232,7 @@ static void tda8290_set_params(struct dvb_frontend *fe,
 		tuner_i2c_xfer_send(&priv->i2c_props, pll_bw_nom, 2);
 	}
 
+
 	tda8290_i2c_bridge(fe, 1);
 
 	if (fe->ops.tuner_ops.set_analog_params)
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index dea90a1..deb8fcf 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5179,11 +5179,7 @@ struct saa7134_board saa7134_boards[] = {
 	[SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG] = {
 		.name           = "Kworld PCI SBTVD/ISDB-T Full-Seg Hybrid",
 		.audio_clock    = 0x00187de7,
-#if 0
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-#else
-		.tuner_type	= UNSET,
-#endif
 		.tuner_addr     = ADDR_UNSET,
 		.radio_type     = UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -6926,10 +6922,17 @@ static inline int saa7134_kworld_sbtvd_toggle_agc(struct saa7134_dev *dev,
 	/* toggle AGC switch through GPIO 27 */
 	switch (mode) {
 	case TDA18271_ANALOG:
-		saa7134_set_gpio(dev, 27, 0);
+		saa_writel(SAA7134_GPIO_GPMODE0 >> 2, 0x4000);
+		saa_writel(SAA7134_GPIO_GPSTATUS0 >> 2, 0x4000);
+		msleep(20);
 		break;
 	case TDA18271_DIGITAL:
-		saa7134_set_gpio(dev, 27, 1);
+		saa_writel(SAA7134_GPIO_GPMODE0 >> 2, 0x14000);
+		saa_writel(SAA7134_GPIO_GPSTATUS0 >> 2, 0x14000);
+		msleep(20);
+		saa_writel(SAA7134_GPIO_GPMODE0 >> 2, 0x54000);
+		saa_writel(SAA7134_GPIO_GPSTATUS0 >> 2, 0x54000);
+		msleep(30);
 		break;
 	default:
 		return -EINVAL;
@@ -6987,6 +6990,7 @@ static int saa7134_tda8290_callback(struct saa7134_dev *dev,
 int saa7134_tuner_callback(void *priv, int component, int command, int arg)
 {
 	struct saa7134_dev *dev = priv;
+
 	if (dev != NULL) {
 		switch (dev->tuner_type) {
 		case TUNER_PHILIPS_TDA8290:
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index d2a12df..f65cad2 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -237,6 +237,8 @@ static struct tda18271_std_map mb86a20s_tda18271_std_map = {
 static struct tda18271_config kworld_tda18271_config = {
 	.std_map = &mb86a20s_tda18271_std_map,
 	.gate    = TDA18271_GATE_DIGITAL,
+	.config  = 3,	/* Use tuner callback for AGC */
+
 };
 
 static const struct mb86a20s_config kworld_mb86a20s_config = {
@@ -1654,24 +1656,16 @@ static int dvb_init(struct saa7134_dev *dev)
 		}
 		break;
 	case SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG:
-		saa_writel(SAA7134_GPIO_GPMODE0 >> 2, 0x14000);
-		saa_writel(SAA7134_GPIO_GPSTATUS0 >> 2, 0x14000);
-		msleep(20);
-		saa_writel(SAA7134_GPIO_GPMODE0 >> 2, 0x54000);
-		saa_writel(SAA7134_GPIO_GPSTATUS0 >> 2, 0x54000);
-		msleep(20);
+		/* Switch to digital mode */
+		saa7134_tuner_callback(dev, 0,
+				       TDA18271_CALLBACK_CMD_AGC_ENABLE, 1);
 		fe0->dvb.frontend = dvb_attach(mb86a20s_attach,
 					       &kworld_mb86a20s_config,
 					       &dev->i2c_adap);
 		if (fe0->dvb.frontend != NULL) {
-#if 0
 			dvb_attach(tda829x_attach, fe0->dvb.frontend,
 				   &dev->i2c_adap, 0x4b,
 				   &tda829x_no_probe);
-#else
-			dvb_attach(tda829x_attach, fe0->dvb.frontend,
-				   &dev->i2c_adap, 0x4b, NULL);
-#endif
 			dvb_attach(tda18271_attach, fe0->dvb.frontend,
 				   0x60, &dev->i2c_adap,
 				   &kworld_tda18271_config);
-- 
1.7.1

