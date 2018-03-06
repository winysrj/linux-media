Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59471 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750838AbeCFKP4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 05:15:56 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Colin Ian King <colin.king@canonical.com>,
        Oleh Kravchenko <oleg@kaa.org.ua>, Sean Young <sean@mess.org>,
        Olli Salonen <olli.salonen@iki.fi>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH v2] media: s5h14*.h: fix typos for CONTINUOUS
Date: Tue,  6 Mar 2018 05:15:49 -0500
Message-Id: <ad05ff091f004b621da1bb17f66181ef0ef4da0c.1520331323.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a typo at the several s5h14*.h headers: continuous were
spelled incorrectly.

Fix it with this script:

for i in $(git grep -l S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK); do
	sed s,S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,g -i $i
done
for i in $(git grep -l -i continous drivers/media); do sed s,CONTINOUS,CONTINUOUS,g -i $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/s5h1409.c       |  8 ++++----
 drivers/media/dvb-frontends/s5h1409.h       |  8 ++++----
 drivers/media/dvb-frontends/s5h1411.c       |  8 ++++----
 drivers/media/dvb-frontends/s5h1411.h       |  8 ++++----
 drivers/media/dvb-frontends/s5h1432.h       |  8 ++++----
 drivers/media/pci/cx18/cx18-dvb.c           |  4 ++--
 drivers/media/pci/cx23885/cx23885-dvb.c     | 16 ++++++++--------
 drivers/media/pci/cx88/cx88-dvb.c           |  8 ++++----
 drivers/media/pci/saa7134/saa7134-dvb.c     |  2 +-
 drivers/media/pci/saa7164/saa7164-dvb.c     |  2 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c     |  6 +++---
 drivers/media/usb/dvb-usb/dib0700_devices.c |  2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c       |  2 +-
 13 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/media/dvb-frontends/s5h1409.c b/drivers/media/dvb-frontends/s5h1409.c
index aced6a956ec5..a23ba8727218 100644
--- a/drivers/media/dvb-frontends/s5h1409.c
+++ b/drivers/media/dvb-frontends/s5h1409.c
@@ -682,17 +682,17 @@ static int s5h1409_set_mpeg_timing(struct dvb_frontend *fe, int mode)
 
 	val = s5h1409_readreg(state, 0xac) & 0xcfff;
 	switch (mode) {
-	case S5H1409_MPEGTIMING_CONTINOUS_INVERTING_CLOCK:
+	case S5H1409_MPEGTIMING_CONTINUOUS_INVERTING_CLOCK:
 		val |= 0x0000;
 		break;
-	case S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK:
+	case S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK:
 		dprintk("%s(%d) Mode1 or Defaulting\n", __func__, mode);
 		val |= 0x1000;
 		break;
-	case S5H1409_MPEGTIMING_NONCONTINOUS_INVERTING_CLOCK:
+	case S5H1409_MPEGTIMING_NONCONTINUOUS_INVERTING_CLOCK:
 		val |= 0x2000;
 		break;
-	case S5H1409_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK:
+	case S5H1409_MPEGTIMING_NONCONTINUOUS_NONINVERTING_CLOCK:
 		val |= 0x3000;
 		break;
 	default:
diff --git a/drivers/media/dvb-frontends/s5h1409.h b/drivers/media/dvb-frontends/s5h1409.h
index b38557c451b9..87de58ffc822 100644
--- a/drivers/media/dvb-frontends/s5h1409.h
+++ b/drivers/media/dvb-frontends/s5h1409.h
@@ -52,10 +52,10 @@ struct s5h1409_config {
 	u8 status_mode;
 
 	/* MPEG signal timing */
-#define S5H1409_MPEGTIMING_CONTINOUS_INVERTING_CLOCK       0
-#define S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK    1
-#define S5H1409_MPEGTIMING_NONCONTINOUS_INVERTING_CLOCK    2
-#define S5H1409_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK 3
+#define S5H1409_MPEGTIMING_CONTINUOUS_INVERTING_CLOCK       0
+#define S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK    1
+#define S5H1409_MPEGTIMING_NONCONTINUOUS_INVERTING_CLOCK    2
+#define S5H1409_MPEGTIMING_NONCONTINUOUS_NONINVERTING_CLOCK 3
 	u16 mpeg_timing;
 
 	/* HVR-1600 optimizations (to better work with MXL5005s)
diff --git a/drivers/media/dvb-frontends/s5h1411.c b/drivers/media/dvb-frontends/s5h1411.c
index c4b1e9725f3e..af5962807f2c 100644
--- a/drivers/media/dvb-frontends/s5h1411.c
+++ b/drivers/media/dvb-frontends/s5h1411.c
@@ -433,17 +433,17 @@ static int s5h1411_set_mpeg_timing(struct dvb_frontend *fe, int mode)
 
 	val = s5h1411_readreg(state, S5H1411_I2C_TOP_ADDR, 0xbe) & 0xcfff;
 	switch (mode) {
-	case S5H1411_MPEGTIMING_CONTINOUS_INVERTING_CLOCK:
+	case S5H1411_MPEGTIMING_CONTINUOUS_INVERTING_CLOCK:
 		val |= 0x0000;
 		break;
-	case S5H1411_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK:
+	case S5H1411_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK:
 		dprintk("%s(%d) Mode1 or Defaulting\n", __func__, mode);
 		val |= 0x1000;
 		break;
-	case S5H1411_MPEGTIMING_NONCONTINOUS_INVERTING_CLOCK:
+	case S5H1411_MPEGTIMING_NONCONTINUOUS_INVERTING_CLOCK:
 		val |= 0x2000;
 		break;
-	case S5H1411_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK:
+	case S5H1411_MPEGTIMING_NONCONTINUOUS_NONINVERTING_CLOCK:
 		val |= 0x3000;
 		break;
 	default:
diff --git a/drivers/media/dvb-frontends/s5h1411.h b/drivers/media/dvb-frontends/s5h1411.h
index 791bab0e16e9..850ee713d64c 100644
--- a/drivers/media/dvb-frontends/s5h1411.h
+++ b/drivers/media/dvb-frontends/s5h1411.h
@@ -40,10 +40,10 @@ struct s5h1411_config {
 	u8 gpio;
 
 	/* MPEG signal timing */
-#define S5H1411_MPEGTIMING_CONTINOUS_INVERTING_CLOCK       0
-#define S5H1411_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK    1
-#define S5H1411_MPEGTIMING_NONCONTINOUS_INVERTING_CLOCK    2
-#define S5H1411_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK 3
+#define S5H1411_MPEGTIMING_CONTINUOUS_INVERTING_CLOCK       0
+#define S5H1411_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK    1
+#define S5H1411_MPEGTIMING_NONCONTINUOUS_INVERTING_CLOCK    2
+#define S5H1411_MPEGTIMING_NONCONTINUOUS_NONINVERTING_CLOCK 3
 	u16 mpeg_timing;
 
 	/* IF Freq for QAM and VSB in KHz */
diff --git a/drivers/media/dvb-frontends/s5h1432.h b/drivers/media/dvb-frontends/s5h1432.h
index af3a157b5e77..646dda36262b 100644
--- a/drivers/media/dvb-frontends/s5h1432.h
+++ b/drivers/media/dvb-frontends/s5h1432.h
@@ -42,10 +42,10 @@ struct s5h1432_config {
 	u8 gpio;
 
 	/* MPEG signal timing */
-#define S5H1432_MPEGTIMING_CONTINOUS_INVERTING_CLOCK       0
-#define S5H1432_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK    1
-#define S5H1432_MPEGTIMING_NONCONTINOUS_INVERTING_CLOCK    2
-#define S5H1432_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK 3
+#define S5H1432_MPEGTIMING_CONTINUOUS_INVERTING_CLOCK       0
+#define S5H1432_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK    1
+#define S5H1432_MPEGTIMING_NONCONTINUOUS_INVERTING_CLOCK    2
+#define S5H1432_MPEGTIMING_NONCONTINUOUS_NONINVERTING_CLOCK 3
 	u16 mpeg_timing;
 
 	/* IF Freq for QAM and VSB in KHz */
diff --git a/drivers/media/pci/cx18/cx18-dvb.c b/drivers/media/pci/cx18/cx18-dvb.c
index 53f4d6bf81fb..010f39eafce1 100644
--- a/drivers/media/pci/cx18/cx18-dvb.c
+++ b/drivers/media/pci/cx18/cx18-dvb.c
@@ -72,7 +72,7 @@ static struct s5h1409_config hauppauge_hvr1600_config = {
 	.qam_if        = 44000,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 	.hvr1600_opt   = S5H1409_HVR1600_OPTIMIZE
 };
 
@@ -86,7 +86,7 @@ static struct s5h1411_config hcw_s5h1411_config = {
 	.qam_if        = S5H1411_IF_4000,
 	.inversion     = S5H1411_INVERSION_ON,
 	.status_mode   = S5H1411_DEMODLOCKING,
-	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct tda18271_std_map hauppauge_tda18271_std_map = {
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 700422b538c0..6061e36d76b1 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -193,7 +193,7 @@ static struct s5h1409_config hauppauge_generic_config = {
 	.qam_if        = 44000,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct tda10048_config hauppauge_hvr1200_config = {
@@ -225,7 +225,7 @@ static struct s5h1409_config hauppauge_ezqam_config = {
 	.qam_if        = 4000,
 	.inversion     = S5H1409_INVERSION_ON,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct s5h1409_config hauppauge_hvr1800lp_config = {
@@ -235,7 +235,7 @@ static struct s5h1409_config hauppauge_hvr1800lp_config = {
 	.qam_if        = 44000,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct s5h1409_config hauppauge_hvr1500_config = {
@@ -244,7 +244,7 @@ static struct s5h1409_config hauppauge_hvr1500_config = {
 	.gpio          = S5H1409_GPIO_OFF,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct mt2131_config hauppauge_generic_tunerconfig = {
@@ -264,7 +264,7 @@ static struct s5h1409_config hauppauge_hvr1500q_config = {
 	.qam_if        = 44000,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct s5h1409_config dvico_s5h1409_config = {
@@ -274,7 +274,7 @@ static struct s5h1409_config dvico_s5h1409_config = {
 	.qam_if        = 44000,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct s5h1411_config dvico_s5h1411_config = {
@@ -284,7 +284,7 @@ static struct s5h1411_config dvico_s5h1411_config = {
 	.vsb_if        = S5H1411_IF_44000,
 	.inversion     = S5H1411_INVERSION_OFF,
 	.status_mode   = S5H1411_DEMODLOCKING,
-	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct s5h1411_config hcw_s5h1411_config = {
@@ -294,7 +294,7 @@ static struct s5h1411_config hcw_s5h1411_config = {
 	.qam_if        = S5H1411_IF_4000,
 	.inversion     = S5H1411_INVERSION_ON,
 	.status_mode   = S5H1411_DEMODLOCKING,
-	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct xc5000_config hauppauge_hvr1500q_tunerconfig = {
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 49a335f4603e..ec65eca713f9 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -558,7 +558,7 @@ static const struct s5h1409_config pinnacle_pctv_hd_800i_config = {
 	.qam_if	       = 44000,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_NONCONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static const struct s5h1409_config dvico_hdtv5_pci_nano_config = {
@@ -567,7 +567,7 @@ static const struct s5h1409_config dvico_hdtv5_pci_nano_config = {
 	.gpio          = S5H1409_GPIO_OFF,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static const struct s5h1409_config kworld_atsc_120_config = {
@@ -576,7 +576,7 @@ static const struct s5h1409_config kworld_atsc_120_config = {
 	.gpio	       = S5H1409_GPIO_OFF,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static const struct xc5000_config pinnacle_pctv_hd_800i_tuner_config = {
@@ -599,7 +599,7 @@ static const struct zl10353_config cx88_geniatech_x8000_mt = {
 static const struct s5h1411_config dvico_fusionhdtv7_config = {
 	.output_mode   = S5H1411_SERIAL_OUTPUT,
 	.gpio          = S5H1411_GPIO_ON,
-	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 	.qam_if        = S5H1411_IF_44000,
 	.vsb_if        = S5H1411_IF_44000,
 	.inversion     = S5H1411_INVERSION_OFF,
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index a7a63d608dde..3025d38ddb2b 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -1195,7 +1195,7 @@ static struct s5h1411_config kworld_s5h1411_config = {
 	.inversion     = S5H1411_INVERSION_ON,
 	.status_mode   = S5H1411_DEMODLOCKING,
 	.mpeg_timing   =
-		S5H1411_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+		S5H1411_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 
diff --git a/drivers/media/pci/saa7164/saa7164-dvb.c b/drivers/media/pci/saa7164/saa7164-dvb.c
index e76d3bafe2ce..4f9f03c3b252 100644
--- a/drivers/media/pci/saa7164/saa7164-dvb.c
+++ b/drivers/media/pci/saa7164/saa7164-dvb.c
@@ -78,7 +78,7 @@ static struct s5h1411_config hauppauge_s5h1411_config = {
 	.vsb_if        = S5H1411_IF_3250,
 	.inversion     = S5H1411_INVERSION_ON,
 	.status_mode   = S5H1411_DEMODLOCKING,
-	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct lgdt3306a_config hauppauge_hvr2255a_config = {
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index fb5654062b1a..4ec7da07c8d7 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -79,7 +79,7 @@ static struct s5h1432_config dvico_s5h1432_config = {
 	.vsb_if        = S5H1432_IF_4000,
 	.inversion     = S5H1432_INVERSION_OFF,
 	.status_mode   = S5H1432_DEMODLOCKING,
-	.mpeg_timing   = S5H1432_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1432_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct tda18271_std_map cnxt_rde253s_tda18271_std_map = {
@@ -108,7 +108,7 @@ static struct s5h1411_config tda18271_s5h1411_config = {
 	.qam_if        = S5H1411_IF_4000,
 	.inversion     = S5H1411_INVERSION_ON,
 	.status_mode   = S5H1411_DEMODLOCKING,
-	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 static struct s5h1411_config xc5000_s5h1411_config = {
 	.output_mode   = S5H1411_SERIAL_OUTPUT,
@@ -117,7 +117,7 @@ static struct s5h1411_config xc5000_s5h1411_config = {
 	.qam_if        = S5H1411_IF_3250,
 	.inversion     = S5H1411_INVERSION_OFF,
 	.status_mode   = S5H1411_DEMODLOCKING,
-	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK,
 };
 
 static struct lgdt3305_config hcw_lgdt3305_config = {
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 3d99e141d566..c53a969bc6be 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -3412,7 +3412,7 @@ static int novatd_frontend_attach(struct dvb_usb_adapter *adap)
 static struct s5h1411_config pinnacle_801e_config = {
 	.output_mode   = S5H1411_PARALLEL_OUTPUT,
 	.gpio          = S5H1411_GPIO_OFF,
-	.mpeg_timing   = S5H1411_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK,
+	.mpeg_timing   = S5H1411_MPEGTIMING_NONCONTINUOUS_NONINVERTING_CLOCK,
 	.qam_if        = S5H1411_IF_44000,
 	.vsb_if        = S5H1411_IF_44000,
 	.inversion     = S5H1411_INVERSION_OFF,
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 8b6eeb5c1f77..05d0abdb8758 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -356,7 +356,7 @@ static struct s5h1409_config em28xx_s5h1409_with_xc3028 = {
 	.gpio          = S5H1409_GPIO_OFF,
 	.inversion     = S5H1409_INVERSION_OFF,
 	.status_mode   = S5H1409_DEMODLOCKING,
-	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINUOUS_NONINVERTING_CLOCK
 };
 
 static struct tda18271_std_map kworld_a340_std_map = {
-- 
2.14.3
