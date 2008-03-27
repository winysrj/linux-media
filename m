Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+29c84a3af63de8e07a22+1677+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1Jev6z-0005xM-6r
	for linux-dvb@linuxtv.org; Thu, 27 Mar 2008 17:37:57 +0100
Date: Thu, 27 Mar 2008 13:37:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080327133717.7eb9171f@gaivota>
In-Reply-To: <1206604694.6098.14.camel@ubuntu>
References: <1206604694.6098.14.camel@ubuntu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/ed3ZDjmdYVAOrcUUS4p+IE5"
Cc: linux-dvb <linux-dvb@linuxtv.org>
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

--MP_/ed3ZDjmdYVAOrcUUS4p+IE5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, 27 Mar 2008 16:58:14 +0900
timf <timf@iinet.net.au> wrote:

> Hi Mauro,
> 
> 3) From syslog:
> These lines repeat, no matter what firmware,
> 
> <snip>
> Mar 27 16:25:45 ubuntu kernel: [  133.324808] xc2028 2-0061: Loading
> firmware for type=BASE F8MHZ (3), id 0000000000000000.
> Mar 27 16:25:45 ubuntu kernel: [  133.324957] xc2028 2-0061: i2c output
> error: rc = -5 (should be 64)
> Mar 27 16:25:45 ubuntu kernel: [  133.324961] xc2028 2-0061: -5 returned
> from send
> Mar 27 16:25:45 ubuntu kernel: [  133.324965] xc2028 2-0061: Error -22
> while loading base firmware
> <snip>
> 
> And it finishes loading with this line:
> 
> <snip>
> Mar 27 16:25:49 ubuntu kernel: [  137.252503] xc2028 2-0061: Error on
> line 1080: -5
> <snip>

After the first moment where tuner-xc2028 returns a negative value, it stops
receiving later commands. this explains the error on line 1080. On USB devices,
it only recovers after unplugging/replugging it. I'm not sure if just removing
saa7134 and reinserting will revive the tuner.

I did a small change on the enclosed patch. Hopefully, this way, the tuner will
reborn. Otherwise, you may need to reboot the machine.

> And by the way, many, many thanks for helping while you're
> very busy!

You're welcome.

Cheers,
Mauro

--MP_/ed3ZDjmdYVAOrcUUS4p+IE5
Content-Type: text/x-patch; name=add_aver_a16d.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=add_aver_a16d.patch

saa7134: Add DTV support for Avermedia A16D

From: Mauro Carvalho Chehab <mchehab@infradead.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

---
 linux/drivers/media/video/saa7134/saa7134-cards.c |   24 ++++++++++++---
 linux/drivers/media/video/saa7134/saa7134-dvb.c   |   35 ++++++++++++++++++++++
 2 files changed, 55 insertions(+), 4 deletions(-)

--- master.orig/linux/drivers/media/video/saa7134/saa7134-cards.c
+++ master/linux/drivers/media/video/saa7134/saa7134-cards.c
@@ -4142,6 +4142,10 @@ struct saa7134_board saa7134_boards[] = 
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
+#if 0
+		/* Not working yet */
+		.mpeg           = SAA7134_MPEG_DVB,
+#endif
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -5512,10 +5516,17 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
 	case SAA7134_BOARD_AVERMEDIA_M115:
 	case SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM:
+	case SAA7134_BOARD_AVERMEDIA_A16D:
+#if 1
+		/* power-down tuner chip */
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0xffffffff, 0);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0xffffffff, 0);
+#endif
+		msleep(10);
 		/* power-up tuner chip */
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0xffffffff, 0xffffffff);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0xffffffff, 0xffffffff);
-		msleep(1);
+		msleep(10);
 		break;
 	case SAA7134_BOARD_RTD_VFG7350:
 
@@ -5808,9 +5819,14 @@ int saa7134_board_init2(struct saa7134_d
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
@@ -151,6 +151,26 @@ static int mt352_aver777_init(struct dvb
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
@@ -193,6 +213,11 @@ static struct mt352_config avermedia_777
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
@@ -938,6 +963,12 @@ static int dvb_init(struct saa7134_dev *
 				   TUNER_PHILIPS_TD1316);
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
@@ -1212,6 +1243,10 @@ static int dvb_init(struct saa7134_dev *
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

--MP_/ed3ZDjmdYVAOrcUUS4p+IE5
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--MP_/ed3ZDjmdYVAOrcUUS4p+IE5--
