Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:36886 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757561Ab0LMNCa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 08:02:30 -0500
Date: Mon, 13 Dec 2010 14:04:30 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 6/6] gspca - sonixj: Better handling of the bridge registers
 0x01 and 0x17
Message-ID: <20101213140430.576c0fc1@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


The initial values of the registers 0x01 and 0x17 are taken from the
senso table at capture start and updated according to the flag PDN_INV.

Their values are updated at each step of the capture initialization and
memorized for reuse in capture stop.

This patch also fixed automatically some bad hardcoded values of these
registers.

Signed-off-by: Jean-François Moine <moinejf@free.fr>

diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index 4c10324..880e931 100644
--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -63,6 +63,8 @@ struct sd {
 #define QUALITY_DEF 80
 	u8 jpegqual;			/* webcam quality */
 
+	u8 reg01;
+	u8 reg17;
 	u8 reg18;
 	u8 flags;
 
@@ -2306,8 +2308,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i;
+	u8 reg01, reg17;
 	u8 reg0102[2];
-	u8 reg1, reg17;
 	const u8 *sn9c1xx;
 	const u8 (*init)[8];
 	const u8 *reg9a;
@@ -2341,10 +2343,13 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	/* sensor clock already enabled in sd_init */
 	/* reg_w1(gspca_dev, 0xf1, 0x00); */
-	reg_w1(gspca_dev, 0x01, sn9c1xx[1]);
+	reg01 = sn9c1xx[1];
+	if (sd->flags & PDN_INV)
+		reg01 ^= S_PDN_INV;		/* power down inverted */
+	reg_w1(gspca_dev, 0x01, reg01);
 
 	/* configure gpio */
-	reg0102[0] = sn9c1xx[1];
+	reg0102[0] = reg01;
 	reg0102[1] = sn9c1xx[2];
 	if (gspca_dev->audio)
 		reg0102[1] |= 0x04;	/* keep the audio connection */
@@ -2370,95 +2375,49 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	reg_w(gspca_dev, 0x03, &sn9c1xx[3], 0x0f);
 
+	reg17 = sn9c1xx[0x17];
 	switch (sd->sensor) {
-	case SENSOR_ADCM1700:
-		reg_w1(gspca_dev, 0x01, 0x43);
-		reg_w1(gspca_dev, 0x17, 0x62);
-		reg_w1(gspca_dev, 0x01, 0x42);
-		reg_w1(gspca_dev, 0x01, 0x42);
-		break;
 	case SENSOR_GC0307:
-		msleep(50);
-		reg_w1(gspca_dev, 0x01, 0x61);
-		reg_w1(gspca_dev, 0x17, 0x22);
-		reg_w1(gspca_dev, 0x01, 0x60);
-		reg_w1(gspca_dev, 0x01, 0x40);
-		msleep(50);
-		break;
-	case SENSOR_MI0360B:
-		reg_w1(gspca_dev, 0x01, 0x61);
-		reg_w1(gspca_dev, 0x17, 0x60);
-		reg_w1(gspca_dev, 0x01, 0x60);
-		reg_w1(gspca_dev, 0x01, 0x40);
-		break;
-	case SENSOR_MT9V111:
-		reg_w1(gspca_dev, 0x01, 0x61);
-		reg_w1(gspca_dev, 0x17, 0x61);
-		reg_w1(gspca_dev, 0x01, 0x60);
-		reg_w1(gspca_dev, 0x01, 0x40);
+		msleep(50);		/*fixme: is it useful? */
 		break;
 	case SENSOR_OM6802:
 		msleep(10);
 		reg_w1(gspca_dev, 0x02, 0x73);
-		reg_w1(gspca_dev, 0x17, 0x60);
+		reg17 |= SEN_CLK_EN;
+		reg_w1(gspca_dev, 0x17, reg17);
 		reg_w1(gspca_dev, 0x01, 0x22);
 		msleep(100);
-		reg_w1(gspca_dev, 0x01, 0x62);
-		reg_w1(gspca_dev, 0x17, 0x64);
-		reg_w1(gspca_dev, 0x17, 0x64);
-		reg_w1(gspca_dev, 0x01, 0x42);
+		reg01 = SCL_SEL_OD | S_PDN_INV;
+		reg17 &= MCK_SIZE_MASK;
+		reg17 |= 0x04;		/* clock / 4 */
+		break;
+	}
+	reg01 |= SYS_SEL_48M;
+	reg_w1(gspca_dev, 0x01, reg01);
+	reg17 |= SEN_CLK_EN;
+	reg_w1(gspca_dev, 0x17, reg17);
+	reg01 &= ~S_PWR_DN;		/* sensor power on */
+	reg_w1(gspca_dev, 0x01, reg01);
+	reg01 &= ~SYS_SEL_48M;
+	reg_w1(gspca_dev, 0x01, reg01);
+
+	switch (sd->sensor) {
+	case SENSOR_HV7131R:
+		hv7131r_probe(gspca_dev);	/*fixme: is it useful? */
+		break;
+	case SENSOR_OM6802:
 		msleep(10);
-		reg_w1(gspca_dev, 0x01, 0x42);
+		reg_w1(gspca_dev, 0x01, reg01);
 		i2c_w8(gspca_dev, om6802_init0[0]);
 		i2c_w8(gspca_dev, om6802_init0[1]);
 		msleep(15);
 		reg_w1(gspca_dev, 0x02, 0x71);
 		msleep(150);
 		break;
-	case SENSOR_OV7630:
-		reg_w1(gspca_dev, 0x01, 0x61);
-		reg_w1(gspca_dev, 0x17, 0xe2);
-		reg_w1(gspca_dev, 0x01, 0x60);
-		reg_w1(gspca_dev, 0x01, 0x40);
-		break;
-	case SENSOR_OV7648:
-		reg_w1(gspca_dev, 0x01, 0x63);
-		reg_w1(gspca_dev, 0x17, 0x20);
-		reg_w1(gspca_dev, 0x01, 0x62);
-		reg_w1(gspca_dev, 0x01, 0x42);
-		break;
-	case SENSOR_PO1030:
-	case SENSOR_SOI768:
-		reg_w1(gspca_dev, 0x01, 0x61);
-		reg_w1(gspca_dev, 0x17, 0x20);
-		reg_w1(gspca_dev, 0x01, 0x60);
-		reg_w1(gspca_dev, 0x01, 0x40);
-		break;
-	case SENSOR_PO2030N:
-	case SENSOR_OV7660:
-		reg_w1(gspca_dev, 0x01, 0x63);
-		reg_w1(gspca_dev, 0x17, 0x20);
-		reg_w1(gspca_dev, 0x01, 0x62);
-		reg_w1(gspca_dev, 0x01, 0x42);
-		break;
 	case SENSOR_SP80708:
-		reg_w1(gspca_dev, 0x01, 0x63);
-		reg_w1(gspca_dev, 0x17, 0x20);
-		reg_w1(gspca_dev, 0x01, 0x62);
-		reg_w1(gspca_dev, 0x01, 0x42);
 		msleep(100);
 		reg_w1(gspca_dev, 0x02, 0x62);
 		break;
-	default:
-/*	case SENSOR_HV7131R: */
-/*	case SENSOR_MI0360: */
-/*	case SENSOR_MO4000: */
-		reg_w1(gspca_dev, 0x01, 0x43);
-		reg_w1(gspca_dev, 0x17, 0x61);
-		reg_w1(gspca_dev, 0x01, 0x42);
-		if (sd->sensor == SENSOR_HV7131R)
-			hv7131r_probe(gspca_dev);
-		break;
 	}
 
 	/* initialize the sensor */
@@ -2487,30 +2446,11 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	}
 	reg_w1(gspca_dev, 0x18, sn9c1xx[0x18]);
 	switch (sd->sensor) {
-	case SENSOR_GC0307:
-		reg17 = 0xa2;
-		break;
-	case SENSOR_MT9V111:
-	case SENSOR_MI0360B:
-		reg17 = 0xe0;
-		break;
-	case SENSOR_ADCM1700:
-	case SENSOR_OV7630:
-		reg17 = 0xe2;
-		break;
-	case SENSOR_OV7648:
-		reg17 = 0x20;
-		break;
-	case SENSOR_OV7660:
-	case SENSOR_SOI768:
-		reg17 = 0xa0;
-		break;
-	case SENSOR_PO1030:
-	case SENSOR_PO2030N:
-		reg17 = 0xa0;
+	case SENSOR_OM6802:
+/*	case SENSOR_OV7648:		* fixme: sometimes */
 		break;
 	default:
-		reg17 = 0x60;
+		reg17 |= DEF_EN;
 		break;
 	}
 	reg_w1(gspca_dev, 0x17, reg17);
@@ -2557,95 +2497,64 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	init = NULL;
 	mode = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].priv;
+	reg01 |= V_TX_EN;
 	if (mode)
-		reg1 = 0x46;	/* 320x240: clk 48Mhz, video trf enable */
+		reg01 |= SYS_SEL_48M;	/* 320x240: clk 48Mhz */
 	else
-		reg1 = 0x06;	/* 640x480: clk 24Mhz, video trf enable */
-	reg17 = 0x61;		/* 0x:20: enable sensor clock */
+		reg01 &= ~SYS_SEL_48M;	/* 640x480: clk 24Mhz */
+	reg17 &= ~MCK_SIZE_MASK;
+	reg17 |= 0x02;			/* clock / 2 */
 	switch (sd->sensor) {
 	case SENSOR_ADCM1700:
 		init = adcm1700_sensor_param1;
-		reg1 = 0x46;
-		reg17 = 0xe2;
+		reg01 |= SYS_SEL_48M;
 		break;
 	case SENSOR_GC0307:
 		init = gc0307_sensor_param1;
-		reg17 = 0xa2;
-		reg1 = 0x44;
+		reg01 |= SYS_SEL_48M;
 		break;
 	case SENSOR_MI0360B:
 		init = mi0360b_sensor_param1;
-		reg1 &= ~0x02;		/* don't inverse pin S_PWR_DN */
-		reg17 = 0xe2;
 		break;
 	case SENSOR_MO4000:
 		if (mode) {
-/*			reg1 = 0x46;	 * 320 clk 48Mhz 60fp/s */
-			reg1 = 0x06;	/* clk 24Mz */
+			reg01 &= ~SYS_SEL_48M;	/* clk 24Mz */
 		} else {
-			reg17 = 0x22;	/* 640 MCKSIZE */
-/*			reg1 = 0x06;	 * 640 clk 24Mz (done) */
+			reg17 = SEN_CLK_EN | 0x02;	/* clock / 2 */
 		}
 		break;
 	case SENSOR_MT9V111:
 		init = mt9v111_sensor_param1;
-		if (mode) {
-			reg1 = 0x04;	/* 320 clk 48Mhz */
-		} else {
-/*			reg1 = 0x06;	 * 640 clk 24Mz (done) */
-			reg17 = 0xc2;
-		}
 		break;
 	case SENSOR_OM6802:
 		init = om6802_sensor_param1;
-		reg17 = 0x64;		/* 640 MCKSIZE */
 		break;
 	case SENSOR_OV7630:
 		init = ov7630_sensor_param1;
-		reg17 = 0xe2;
-		reg1 = 0x44;
+		reg01 |= SYS_SEL_48M;
 		break;
 	case SENSOR_OV7648:
 		init = ov7648_sensor_param1;
-		reg17 = 0x21;
-/*		reg1 = 0x42;		 * 42 - 46? */
+		reg17 &= ~MCK_SIZE_MASK;
+		reg17 |= 0x01;			/* clock / 1 */
 		break;
 	case SENSOR_OV7660:
 		init = ov7660_sensor_param1;
-		if (sd->bridge == BRIDGE_SN9C120) {
-			if (mode) {		/* 320x240 - 160x120 */
-				reg17 = 0xa2;
-				reg1 = 0x44;	/* 48 Mhz, video trf eneble */
-			}
-		} else {
-			reg17 = 0x22;
-			reg1 = 0x06;	/* 24 Mhz, video trf eneble
-					 * inverse power down */
-		}
 		break;
 	case SENSOR_PO1030:
 		init = po1030_sensor_param1;
-		reg17 = 0xa2;
-		reg1 = 0x44;
+		reg01 |= SYS_SEL_48M;
 		break;
 	case SENSOR_PO2030N:
 		init = po2030n_sensor_param1;
-		reg1 = 0x46;
-		reg17 = 0xa2;
+		reg01 |= SYS_SEL_48M;
 		break;
 	case SENSOR_SOI768:
 		init = soi768_sensor_param1;
-		reg1 = 0x44;
-		reg17 = 0xa2;
+		reg01 |= SYS_SEL_48M;
 		break;
 	case SENSOR_SP80708:
 		init = sp80708_sensor_param1;
-		if (mode) {
-/*??			reg1 = 0x04;	 * 320 clk 48Mhz */
-		} else {
-			reg1 = 0x46;	 /* 640 clk 48Mz */
-			reg17 = 0xa2;
-		}
 		break;
 	}
 
@@ -2695,7 +2604,9 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	setjpegqual(gspca_dev);
 
 	reg_w1(gspca_dev, 0x17, reg17);
-	reg_w1(gspca_dev, 0x01, reg1);
+	reg_w1(gspca_dev, 0x01, reg01);
+	sd->reg01 = reg01;
+	sd->reg17 = reg17;
 
 	sethvflip(gspca_dev);
 	setbrightness(gspca_dev);
@@ -2717,41 +2628,69 @@ static void sd_stopN(struct gspca_dev *gspca_dev)
 		{ 0xa1, 0x21, 0x76, 0x20, 0x00, 0x00, 0x00, 0x10 };
 	static const u8 stopsoi768[] =
 		{ 0xa1, 0x21, 0x12, 0x80, 0x00, 0x00, 0x00, 0x10 };
-	u8 data;
-	const u8 *sn9c1xx;
+	u8 reg01;
+	u8 reg17;
 
-	data = 0x0b;
+	reg01 = sd->reg01;
+	reg17 = sd->reg17 & ~SEN_CLK_EN;
 	switch (sd->sensor) {
+	case SENSOR_ADCM1700:
+	case SENSOR_PO2030N:
+	case SENSOR_SP80708:
+		reg01 |= LED;
+		reg_w1(gspca_dev, 0x01, reg01);
+		reg01 &= ~(LED | V_TX_EN);
+		reg_w1(gspca_dev, 0x01, reg01);
+/*		reg_w1(gspca_dev, 0x02, 0x??);	 * LED off ? */
+		break;
 	case SENSOR_GC0307:
-		data = 0x29;
+		reg01 |= LED | S_PDN_INV;
+		reg_w1(gspca_dev, 0x01, reg01);
+		reg01 &= ~(LED | V_TX_EN | S_PDN_INV);
+		reg_w1(gspca_dev, 0x01, reg01);
 		break;
 	case SENSOR_HV7131R:
+		reg01 &= ~V_TX_EN;
+		reg_w1(gspca_dev, 0x01, reg01);
 		i2c_w8(gspca_dev, stophv7131);
-		data = 0x2b;
 		break;
 	case SENSOR_MI0360:
 	case SENSOR_MI0360B:
+		reg01 &= ~V_TX_EN;
+		reg_w1(gspca_dev, 0x01, reg01);
+/*		reg_w1(gspca_dev, 0x02, 0x40);	  * LED off ? */
 		i2c_w8(gspca_dev, stopmi0360);
-		data = 0x29;
 		break;
-	case SENSOR_OV7648:
-		i2c_w8(gspca_dev, stopov7648);
-		/* fall thru */
 	case SENSOR_MT9V111:
-	case SENSOR_OV7630:
+	case SENSOR_OM6802:
 	case SENSOR_PO1030:
-		data = 0x29;
+		reg01 &= ~V_TX_EN;
+		reg_w1(gspca_dev, 0x01, reg01);
+		break;
+	case SENSOR_OV7630:
+	case SENSOR_OV7648:
+		reg01 &= ~V_TX_EN;
+		reg_w1(gspca_dev, 0x01, reg01);
+		i2c_w8(gspca_dev, stopov7648);
+		break;
+	case SENSOR_OV7660:
+		reg01 &= ~V_TX_EN;
+		reg_w1(gspca_dev, 0x01, reg01);
 		break;
 	case SENSOR_SOI768:
 		i2c_w8(gspca_dev, stopsoi768);
-		data = 0x29;
 		break;
 	}
-	sn9c1xx = sn_tb[sd->sensor];
-	reg_w1(gspca_dev, 0x01, sn9c1xx[1]);
-	reg_w1(gspca_dev, 0x17, sn9c1xx[0x17]);
-	reg_w1(gspca_dev, 0x01, sn9c1xx[1]);
-	reg_w1(gspca_dev, 0x01, data);
+
+	reg01 |= SCL_SEL_OD;
+	reg_w1(gspca_dev, 0x01, reg01);
+	reg01 |= S_PWR_DN;		/* sensor power down */
+	reg_w1(gspca_dev, 0x01, reg01);
+	reg_w1(gspca_dev, 0x17, reg17);
+	reg01 &= ~SYS_SEL_48M;		/* clock 24MHz */
+	reg_w1(gspca_dev, 0x01, reg01);
+	reg01 |= LED;
+	reg_w1(gspca_dev, 0x01, reg01);
 	/* Don't disable sensor clock as that disables the button on the cam */
 	/* reg_w1(gspca_dev, 0xf1, 0x01); */
 }
-- 
1.7.2.3

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
