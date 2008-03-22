Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+0af2e7848fb42186027e+1672+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1Jd6bF-0000uO-49
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 17:29:41 +0100
Date: Sat, 22 Mar 2008 13:28:46 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080322132846.74cd99bd@gaivota>
In-Reply-To: <1206200253.6403.11.camel@ubuntu>
References: <47A5D8AF.2090800@googlemail.com> <47ACA9AA.4090702@googlemail.com>
	<47AE20BD.7090503@googlemail.com> <20080212124734.62cd451d@gaivota>
	<47B1E22D.4090901@googlemail.com> <20080313114633.494bc7b1@gaivota>
	<1205457408.6358.5.camel@ubuntu> <20080314121423.670f31a0@gaivota>
	<1205518856.6094.14.camel@ubuntu> <20080314155851.52677f28@gaivota>
	<1205523274.6364.5.camel@ubuntu> <20080314172143.62390b1f@gaivota>
	<1205573636.5941.1.camel@ubuntu> <20080318103044.4363fefd@gaivota>
	<1205864312.11231.11.camel@ubuntu>
	<20080318161729.6da782ee@gaivota>
	<1205873332.11231.17.camel@ubuntu>
	<20080318180415.5dfc4319@gaivota>
	<1205875868.3385.133.camel@pc08.localdom.local>
	<1205904196.6510.3.camel@ubuntu> <20080320115531.7ab450ba@gaivota>
	<1206030503.5997.2.camel@ubuntu> <20080320140715.4204ec78@gaivota>
	<20080322083435.2432256b@gaivota> <47E51CBD.1000906@googlemail.com>
	<20080322115925.69cc5b38@gaivota> <1206200253.6403.11.camel@ubuntu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/oCQaA4FlyEnZ17dcjC3YAVg"
Cc: Hackmann <hartmut.hackmann@t-online.de>, lucarasp <lucarasp@inwind.it>,
	linux-dvb@linuxtv.org, "Richard \(MQ\)" <osl2008@googlemail.com>
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

--MP_/oCQaA4FlyEnZ17dcjC3YAVg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, 23 Mar 2008 00:37:33 +0900
timf <timf@iinet.net.au> wrote:

> Hi again,
> 

> Something strange happening here:
> 
> [   24.528000] mt352_read_register: readreg error (reg=127, ret==-5)
> [   24.528000] xc2028: Xcv2028/3028 init called!
> [   24.528000] xc2028: No frontend!
> [   24.528000] saa7133[0]/2: xc3028 attach failed
> [   24.528000] BUG: unable to handle kernel NULL pointer dereference at
> virtual address 000000ac
> [   24.528000]  printing eip:
> [   24.528000] f8b70074
> [   24.528000] *pde = 00000000
> [   24.528000] Oops: 0000 [#1]
> 
> Regards,
> Tim

Complementing my previous e-mail, the enclosed patch fixes the OOPS. It also
forks the mt352 tables.

The first point is: I don't have this board. All I know about it is what I've
seen at the net. Could you double check if this is using an mt352 chip? Maybe
it uses another demod, instead.

If the board is really based on mt352, and for DVB to work, you'll need to
figure-out the proper parameters for mt352 initialization:

+static int mt352_aver_a16d_init(struct dvb_frontend* fe)
+{
+       static u8 clock_config []  = { CLOCK_CTL,  0x38, 0x2d };
+       static u8 reset []         = { RESET,      0x80 };
+       static u8 adc_ctl_1_cfg [] = { ADC_CTL_1,  0x40 };
+       static u8 agc_cfg []       = { AGC_TARGET, 0x28, 0xa0 };
+       static u8 capt_range_cfg[] = { CAPT_RANGE, 0x33 };
+
+       mt352_write(fe, clock_config,   sizeof(clock_config));
+       udelay(200);
+       mt352_write(fe, reset,          sizeof(reset));
+       mt352_write(fe, adc_ctl_1_cfg,  sizeof(adc_ctl_1_cfg));
+       mt352_write(fe, agc_cfg,        sizeof(agc_cfg));
+       mt352_write(fe, capt_range_cfg, sizeof(capt_range_cfg));
+
+       return 0;
+}

The above routine contains mt352 initialization procedure.
...

+static struct mt352_config avermedia_16d = {
+       .demod_address = 0xf,
+       .demod_init    = mt352_aver_a16d_init,
+};

The above struct contains the demod address for mt352 (address 0x1e, at 8-bit
notation - or 0x0f, at 7bit notation). The demod could be on another address.
For example, Pinnacle 300i has it at address 0x3c (8bit notation).

You'll need to make sure that mt352 address is 0x1e on your board. Modprobing
saa7134 with i2c_scan=1 will allow you to see what i2c addresses are in use.

Cheers,
Mauro


--MP_/oCQaA4FlyEnZ17dcjC3YAVg
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

--MP_/oCQaA4FlyEnZ17dcjC3YAVg
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--MP_/oCQaA4FlyEnZ17dcjC3YAVg--
