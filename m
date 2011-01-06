Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:10972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1AFL3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 06:29:17 -0500
Date: Thu, 6 Jan 2011 09:28:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: stable@kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	moinejf@free.fr
Subject: [PATCH 1/4] [media] gspca - sonixj: Move bridge init to sd start
Message-ID: <20110106092835.0d300343@gaivota>
In-Reply-To: <cover.1294312927.git.mchehab@redhat.com>
References: <cover.1294312927.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Backports changeset 5e68f400aad4e2c29e2531cc4413c459fa88cb62

Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index 248c2e6..63f789d 100644
--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -1643,136 +1643,6 @@ static void po2030n_probe(struct gspca_dev *gspca_dev)
 	}
 }
 
-static void bridge_init(struct gspca_dev *gspca_dev,
-			  const u8 *sn9c1xx)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	u8 reg0102[2];
-	const u8 *reg9a;
-	static const u8 reg9a_def[] =
-		{0x00, 0x40, 0x20, 0x00, 0x00, 0x00};
-	static const u8 reg9a_spec[] =
-		{0x00, 0x40, 0x38, 0x30, 0x00, 0x20};
-	static const u8 regd4[] = {0x60, 0x00, 0x00};
-
-	/* sensor clock already enabled in sd_init */
-	/* reg_w1(gspca_dev, 0xf1, 0x00); */
-	reg_w1(gspca_dev, 0x01, sn9c1xx[1]);
-
-	/* configure gpio */
-	reg0102[0] = sn9c1xx[1];
-	reg0102[1] = sn9c1xx[2];
-	if (gspca_dev->audio)
-		reg0102[1] |= 0x04;	/* keep the audio connection */
-	reg_w(gspca_dev, 0x01, reg0102, 2);
-	reg_w(gspca_dev, 0x08, &sn9c1xx[8], 2);
-	reg_w(gspca_dev, 0x17, &sn9c1xx[0x17], 5);
-	switch (sd->sensor) {
-	case SENSOR_GC0307:
-	case SENSOR_OV7660:
-	case SENSOR_PO1030:
-	case SENSOR_PO2030N:
-	case SENSOR_SOI768:
-	case SENSOR_SP80708:
-		reg9a = reg9a_spec;
-		break;
-	default:
-		reg9a = reg9a_def;
-		break;
-	}
-	reg_w(gspca_dev, 0x9a, reg9a, 6);
-
-	reg_w(gspca_dev, 0xd4, regd4, sizeof regd4);
-
-	reg_w(gspca_dev, 0x03, &sn9c1xx[3], 0x0f);
-
-	switch (sd->sensor) {
-	case SENSOR_ADCM1700:
-		reg_w1(gspca_dev, 0x01, 0x43);
-		reg_w1(gspca_dev, 0x17, 0x62);
-		reg_w1(gspca_dev, 0x01, 0x42);
-		reg_w1(gspca_dev, 0x01, 0x42);
-		break;
-	case SENSOR_GC0307:
-		msleep(50);
-		reg_w1(gspca_dev, 0x01, 0x61);
-		reg_w1(gspca_dev, 0x17, 0x22);
-		reg_w1(gspca_dev, 0x01, 0x60);
-		reg_w1(gspca_dev, 0x01, 0x40);
-		msleep(50);
-		break;
-	case SENSOR_MT9V111:
-		reg_w1(gspca_dev, 0x01, 0x61);
-		reg_w1(gspca_dev, 0x17, 0x61);
-		reg_w1(gspca_dev, 0x01, 0x60);
-		reg_w1(gspca_dev, 0x01, 0x40);
-		break;
-	case SENSOR_OM6802:
-		msleep(10);
-		reg_w1(gspca_dev, 0x02, 0x73);
-		reg_w1(gspca_dev, 0x17, 0x60);
-		reg_w1(gspca_dev, 0x01, 0x22);
-		msleep(100);
-		reg_w1(gspca_dev, 0x01, 0x62);
-		reg_w1(gspca_dev, 0x17, 0x64);
-		reg_w1(gspca_dev, 0x17, 0x64);
-		reg_w1(gspca_dev, 0x01, 0x42);
-		msleep(10);
-		reg_w1(gspca_dev, 0x01, 0x42);
-		i2c_w8(gspca_dev, om6802_init0[0]);
-		i2c_w8(gspca_dev, om6802_init0[1]);
-		msleep(15);
-		reg_w1(gspca_dev, 0x02, 0x71);
-		msleep(150);
-		break;
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
-	case SENSOR_SP80708:
-		reg_w1(gspca_dev, 0x01, 0x63);
-		reg_w1(gspca_dev, 0x17, 0x20);
-		reg_w1(gspca_dev, 0x01, 0x62);
-		reg_w1(gspca_dev, 0x01, 0x42);
-		msleep(100);
-		reg_w1(gspca_dev, 0x02, 0x62);
-		break;
-	default:
-/*	case SENSOR_HV7131R: */
-/*	case SENSOR_MI0360: */
-/*	case SENSOR_MO4000: */
-		reg_w1(gspca_dev, 0x01, 0x43);
-		reg_w1(gspca_dev, 0x17, 0x61);
-		reg_w1(gspca_dev, 0x01, 0x42);
-		if (sd->sensor == SENSOR_HV7131R
-		    && sd->bridge == BRIDGE_SN9C102P)
-			hv7131r_probe(gspca_dev);
-		break;
-	}
-}
-
 /* this function is called at probe time */
 static int sd_config(struct gspca_dev *gspca_dev,
 			const struct usb_device_id *id)
@@ -2282,10 +2152,17 @@ static int sd_start(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i;
+	u8 reg0102[2];
+	const u8 *reg9a;
 	u8 reg1, reg17;
 	const u8 *sn9c1xx;
 	const u8 (*init)[8];
 	int mode;
+	static const u8 reg9a_def[] =
+		{0x00, 0x40, 0x20, 0x00, 0x00, 0x00};
+	static const u8 reg9a_spec[] =
+		{0x00, 0x40, 0x38, 0x30, 0x00, 0x20};
+	static const u8 regd4[] = {0x60, 0x00, 0x00};
 	static const u8 C0[] = { 0x2d, 0x2d, 0x3a, 0x05, 0x04, 0x3f };
 	static const u8 CA[] = { 0x28, 0xd8, 0x14, 0xec };
 	static const u8 CA_adcm1700[] =
@@ -2307,7 +2184,128 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	/* initialize the bridge */
 	sn9c1xx = sn_tb[sd->sensor];
-	bridge_init(gspca_dev, sn9c1xx);
+
+	/* sensor clock already enabled in sd_init */
+	/* reg_w1(gspca_dev, 0xf1, 0x00); */
+	reg_w1(gspca_dev, 0x01, sn9c1xx[1]);
+
+	/* configure gpio */
+	reg0102[0] = sn9c1xx[1];
+	reg0102[1] = sn9c1xx[2];
+	if (gspca_dev->audio)
+		reg0102[1] |= 0x04;	/* keep the audio connection */
+	reg_w(gspca_dev, 0x01, reg0102, 2);
+	reg_w(gspca_dev, 0x08, &sn9c1xx[8], 2);
+	reg_w(gspca_dev, 0x17, &sn9c1xx[0x17], 5);
+	switch (sd->sensor) {
+	case SENSOR_GC0307:
+	case SENSOR_OV7660:
+	case SENSOR_PO1030:
+	case SENSOR_PO2030N:
+	case SENSOR_SOI768:
+	case SENSOR_SP80708:
+		reg9a = reg9a_spec;
+		break;
+	default:
+		reg9a = reg9a_def;
+		break;
+	}
+	reg_w(gspca_dev, 0x9a, reg9a, 6);
+
+	reg_w(gspca_dev, 0xd4, regd4, sizeof regd4);
+
+	reg_w(gspca_dev, 0x03, &sn9c1xx[3], 0x0f);
+
+	switch (sd->sensor) {
+	case SENSOR_ADCM1700:
+		reg_w1(gspca_dev, 0x01, 0x43);
+		reg_w1(gspca_dev, 0x17, 0x62);
+		reg_w1(gspca_dev, 0x01, 0x42);
+		reg_w1(gspca_dev, 0x01, 0x42);
+		break;
+	case SENSOR_GC0307:
+		msleep(50);
+		reg_w1(gspca_dev, 0x01, 0x61);
+		reg_w1(gspca_dev, 0x17, 0x22);
+		reg_w1(gspca_dev, 0x01, 0x60);
+		reg_w1(gspca_dev, 0x01, 0x40);
+		msleep(50);
+		break;
+	case SENSOR_MI0360B:
+		reg_w1(gspca_dev, 0x01, 0x61);
+		reg_w1(gspca_dev, 0x17, 0x60);
+		reg_w1(gspca_dev, 0x01, 0x60);
+		reg_w1(gspca_dev, 0x01, 0x40);
+		break;
+	case SENSOR_MT9V111:
+		reg_w1(gspca_dev, 0x01, 0x61);
+		reg_w1(gspca_dev, 0x17, 0x61);
+		reg_w1(gspca_dev, 0x01, 0x60);
+		reg_w1(gspca_dev, 0x01, 0x40);
+		break;
+	case SENSOR_OM6802:
+		msleep(10);
+		reg_w1(gspca_dev, 0x02, 0x73);
+		reg_w1(gspca_dev, 0x17, 0x60);
+		reg_w1(gspca_dev, 0x01, 0x22);
+		msleep(100);
+		reg_w1(gspca_dev, 0x01, 0x62);
+		reg_w1(gspca_dev, 0x17, 0x64);
+		reg_w1(gspca_dev, 0x17, 0x64);
+		reg_w1(gspca_dev, 0x01, 0x42);
+		msleep(10);
+		reg_w1(gspca_dev, 0x01, 0x42);
+		i2c_w8(gspca_dev, om6802_init0[0]);
+		i2c_w8(gspca_dev, om6802_init0[1]);
+		msleep(15);
+		reg_w1(gspca_dev, 0x02, 0x71);
+		msleep(150);
+		break;
+	case SENSOR_OV7630:
+		reg_w1(gspca_dev, 0x01, 0x61);
+		reg_w1(gspca_dev, 0x17, 0xe2);
+		reg_w1(gspca_dev, 0x01, 0x60);
+		reg_w1(gspca_dev, 0x01, 0x40);
+		break;
+	case SENSOR_OV7648:
+		reg_w1(gspca_dev, 0x01, 0x63);
+		reg_w1(gspca_dev, 0x17, 0x20);
+		reg_w1(gspca_dev, 0x01, 0x62);
+		reg_w1(gspca_dev, 0x01, 0x42);
+		break;
+	case SENSOR_PO1030:
+	case SENSOR_SOI768:
+		reg_w1(gspca_dev, 0x01, 0x61);
+		reg_w1(gspca_dev, 0x17, 0x20);
+		reg_w1(gspca_dev, 0x01, 0x60);
+		reg_w1(gspca_dev, 0x01, 0x40);
+		break;
+	case SENSOR_PO2030N:
+	case SENSOR_OV7660:
+		reg_w1(gspca_dev, 0x01, 0x63);
+		reg_w1(gspca_dev, 0x17, 0x20);
+		reg_w1(gspca_dev, 0x01, 0x62);
+		reg_w1(gspca_dev, 0x01, 0x42);
+		break;
+	case SENSOR_SP80708:
+		reg_w1(gspca_dev, 0x01, 0x63);
+		reg_w1(gspca_dev, 0x17, 0x20);
+		reg_w1(gspca_dev, 0x01, 0x62);
+		reg_w1(gspca_dev, 0x01, 0x42);
+		msleep(100);
+		reg_w1(gspca_dev, 0x02, 0x62);
+		break;
+	default:
+/*	case SENSOR_HV7131R: */
+/*	case SENSOR_MI0360: */
+/*	case SENSOR_MO4000: */
+		reg_w1(gspca_dev, 0x01, 0x43);
+		reg_w1(gspca_dev, 0x17, 0x61);
+		reg_w1(gspca_dev, 0x01, 0x42);
+		if (sd->sensor == SENSOR_HV7131R)
+			hv7131r_probe(gspca_dev);
+		break;
+	}
 
 	/* initialize the sensor */
 	i2c_w_seq(gspca_dev, sensor_init[sd->sensor]);
@@ -2530,7 +2528,6 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		break;
 	}
 
-
 	/* here change size mode 0 -> VGA; 1 -> CIF */
 	sd->reg18 = sn9c1xx[0x18] | (mode << 4) | 0x40;
 	reg_w1(gspca_dev, 0x18, sd->reg18);
-- 
1.7.3.4


