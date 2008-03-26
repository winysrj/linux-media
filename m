Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+dfea913d6eb0b62529c6+1676+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JeYop-0003mc-3X
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 17:49:43 +0100
Date: Wed, 26 Mar 2008 13:49:12 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: gian luca rasponi <lucarasp@inwind.it>
Message-ID: <20080326134912.6f545b38@gaivota>
In-Reply-To: <47E9A539.1050706@inwind.it>
References: <47E030C1.2000805@inwind.it> <20080318182810.0189de8e@gaivota>
	<47E9A539.1050706@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/UUPPfpElDAabnYFOh76Wpax"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Any chance of help with v4l-dvb-experimental /
 Avermedia A16D please?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--MP_/UUPPfpElDAabnYFOh76Wpax
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 26 Mar 2008 02:22:01 +0100
gian luca rasponi <lucarasp@inwind.it> wrote:

> [13496.504000] saa7133[0]: i2c scan: found device @ 0x1e  [???]
> [13496.520000] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]

It didn't detect a tuner, at 0xc2. Are you using the enclosed patch? It enables
the device by using a command for the gpio port.

dvb shouldn't be working yet. It seems that this device uses some different
parameters for mt352.

Cheers,
Mauro

--MP_/UUPPfpElDAabnYFOh76Wpax
Content-Type: text/x-patch; name=add_aver_a16d.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=add_aver_a16d.patch

saa7134: Add DTV support for Avermedia A16D

From: Mauro Carvalho Chehab <mchehab@infradead.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

---
 linux/drivers/media/video/saa7134/saa7134-cards.c |   13 ++++++--
 linux/drivers/media/video/saa7134/saa7134-dvb.c   |   35 ++++++++++++++++++++++
 2 files changed, 45 insertions(+), 3 deletions(-)

--- master.orig/linux/drivers/media/video/saa7134/saa7134-cards.c
+++ master/linux/drivers/media/video/saa7134/saa7134-cards.c
@@ -4142,6 +4142,7 @@ struct saa7134_board saa7134_boards[] = 
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
+		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -5512,6 +5513,7 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
 	case SAA7134_BOARD_AVERMEDIA_M115:
 	case SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM:
+	case SAA7134_BOARD_AVERMEDIA_A16D:
 		/* power-up tuner chip */
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0xffffffff, 0xffffffff);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0xffffffff, 0xffffffff);
@@ -5808,9 +5810,14 @@ int saa7134_board_init2(struct saa7134_d
 		ctl.fname   = XC2028_DEFAULT_FIRMWARE;
 		ctl.max_len = 64;
 
-		/* FIXME: This should be device-dependent */
-		ctl.demod = XC3028_FE_OREN538;
-		ctl.mts = 1;
+		switch (dev->board) {
+		case SAA7134_BOARD_AVERMEDIA_A16D:
+			ctl.demod = XC3028_FE_ZARLINK456;
+			break;
+		default:
+			ctl.demod = XC3028_FE_OREN538;
+			ctl.mts = 1;
+		}
 
 		xc2028_cfg.tuner = TUNER_XC2028;
 		xc2028_cfg.priv  = &ctl;
--- master.orig/linux/drivers/media/video/saa7134/saa7134-dvb.c
+++ master/linux/drivers/media/video/saa7134/saa7134-dvb.c
@@ -150,6 +150,26 @@ static int mt352_aver777_init(struct dvb
 	return 0;
 }
 
+static int mt352_aver_a16d_init(struct dvb_frontend* fe)
+{
+	static u8 clock_config []  = { CLOCK_CTL,  0x38, 0x2d };
+	static u8 reset []         = { RESET,      0x80 };
+	static u8 adc_ctl_1_cfg [] = { ADC_CTL_1,  0x40 };
+	static u8 agc_cfg []       = { AGC_TARGET, 0x28, 0xa0 };
+	static u8 capt_range_cfg[] = { CAPT_RANGE, 0x33 };
+
+	mt352_write(fe, clock_config,   sizeof(clock_config));
+	udelay(200);
+	mt352_write(fe, reset,          sizeof(reset));
+	mt352_write(fe, adc_ctl_1_cfg,  sizeof(adc_ctl_1_cfg));
+	mt352_write(fe, agc_cfg,        sizeof(agc_cfg));
+	mt352_write(fe, capt_range_cfg, sizeof(capt_range_cfg));
+
+	return 0;
+}
+
+
+
 static int mt352_pinnacle_tuner_set_params(struct dvb_frontend* fe,
 					   struct dvb_frontend_parameters* params)
 {
@@ -192,6 +212,11 @@ static struct mt352_config avermedia_777
 	.demod_init    = mt352_aver777_init,
 };
 
+static struct mt352_config avermedia_16d = {
+	.demod_address = 0xf,
+	.demod_init    = mt352_aver_a16d_init,
+};
+
 static struct mt352_config avermedia_e506r_mt352_dev = {
 	.demod_address   = (0x1e >> 1),
 #if 0
@@ -936,6 +961,12 @@ static int dvb_init(struct saa7134_dev *
 				   NULL, DVB_PLL_PHILIPS_TD1316);
 		}
 		break;
+	case SAA7134_BOARD_AVERMEDIA_A16D:
+		dprintk("avertv A16D dvb setup\n");
+		dev->dvb.frontend = dvb_attach(mt352_attach, &avermedia_16d,
+					       &dev->i2c_adap);
+		attach_xc3028 = 1;
+		break;
 	case SAA7134_BOARD_MD7134:
 		dev->dvb.frontend = dvb_attach(tda10046_attach,
 					       &medion_cardbus,
@@ -1207,6 +1238,10 @@ static int dvb_init(struct saa7134_dev *
 			.i2c_adap  = &dev->i2c_adap,
 			.i2c_addr  = 0x61,
 		};
+
+		if (!dev->dvb.frontend)
+			return -1;
+
 		fe = dvb_attach(xc2028_attach, dev->dvb.frontend, &cfg);
 		if (!fe) {
 			printk(KERN_ERR "%s/2: xc3028 attach failed\n",

--MP_/UUPPfpElDAabnYFOh76Wpax
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--MP_/UUPPfpElDAabnYFOh76Wpax--
