Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab1LXPvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:08 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp8a2017076
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:08 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 47/47] [media] tuners: remove dvb_frontend_parameters from set_params()
Date: Sat, 24 Dec 2011 13:50:52 -0200
Message-Id: <1324741852-26138-48-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-47-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
 <1324741852-26138-2-git-send-email-mchehab@redhat.com>
 <1324741852-26138-3-git-send-email-mchehab@redhat.com>
 <1324741852-26138-4-git-send-email-mchehab@redhat.com>
 <1324741852-26138-5-git-send-email-mchehab@redhat.com>
 <1324741852-26138-6-git-send-email-mchehab@redhat.com>
 <1324741852-26138-7-git-send-email-mchehab@redhat.com>
 <1324741852-26138-8-git-send-email-mchehab@redhat.com>
 <1324741852-26138-9-git-send-email-mchehab@redhat.com>
 <1324741852-26138-10-git-send-email-mchehab@redhat.com>
 <1324741852-26138-11-git-send-email-mchehab@redhat.com>
 <1324741852-26138-12-git-send-email-mchehab@redhat.com>
 <1324741852-26138-13-git-send-email-mchehab@redhat.com>
 <1324741852-26138-14-git-send-email-mchehab@redhat.com>
 <1324741852-26138-15-git-send-email-mchehab@redhat.com>
 <1324741852-26138-16-git-send-email-mchehab@redhat.com>
 <1324741852-26138-17-git-send-email-mchehab@redhat.com>
 <1324741852-26138-18-git-send-email-mchehab@redhat.com>
 <1324741852-26138-19-git-send-email-mchehab@redhat.com>
 <1324741852-26138-20-git-send-email-mchehab@redhat.com>
 <1324741852-26138-21-git-send-email-mchehab@redhat.com>
 <1324741852-26138-22-git-send-email-mchehab@redhat.com>
 <1324741852-26138-23-git-send-email-mchehab@redhat.com>
 <1324741852-26138-24-git-send-email-mchehab@redhat.com>
 <1324741852-26138-25-git-send-email-mchehab@redhat.com>
 <1324741852-26138-26-git-send-email-mchehab@redhat.com>
 <1324741852-26138-27-git-send-email-mchehab@redhat.com>
 <1324741852-26138-28-git-send-email-mchehab@redhat.com>
 <1324741852-26138-29-git-send-email-mchehab@redhat.com>
 <1324741852-26138-30-git-send-email-mchehab@redhat.com>
 <1324741852-26138-31-git-send-email-mchehab@redhat.com>
 <1324741852-26138-32-git-send-email-mchehab@redhat.com>
 <1324741852-26138-33-git-send-email-mchehab@redhat.com>
 <1324741852-26138-34-git-send-email-mchehab@redhat.com>
 <1324741852-26138-35-git-send-email-mchehab@redhat.com>
 <1324741852-26138-36-git-send-email-mchehab@redhat.com>
 <1324741852-26138-37-git-send-email-mchehab@redhat.com>
 <1324741852-26138-38-git-send-email-mchehab@redhat.com>
 <1324741852-26138-39-git-send-email-mchehab@redhat.com>
 <1324741852-26138-40-git-send-email-mchehab@redhat.com>
 <1324741852-26138-41-git-send-email-mchehab@redhat.com>
 <1324741852-26138-42-git-send-email-mchehab@redhat.com>
 <1324741852-26138-43-git-send-email-mchehab@redhat.com>
 <1324741852-26138-44-git-send-email-mchehab@redhat.com>
 <1324741852-26138-45-git-send-email-mchehab@redhat.com>
 <1324741852-26138-46-git-send-email-mchehab@redhat.com>
 <1324741852-26138-47-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a big patch, yet trivial: now that all tuners use the DVBv5
way to pass parameters (e. g. via fe->dtv_property_cache), the
extra parameter can be removed from set_params() call.

After this change, very few DVBv3 specific stuff are left at the
tuners.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/max2165.c             |    3 +-
 drivers/media/common/tuners/mc44s803.c            |    3 +-
 drivers/media/common/tuners/mt2060.c              |    2 +-
 drivers/media/common/tuners/mt2131.c              |    3 +-
 drivers/media/common/tuners/mt2266.c              |    2 +-
 drivers/media/common/tuners/mxl5005s.c            |    3 +-
 drivers/media/common/tuners/mxl5007t.c            |    3 +-
 drivers/media/common/tuners/qt1010.c              |    6 +---
 drivers/media/common/tuners/tda18212.c            |    3 +-
 drivers/media/common/tuners/tda18218.c            |    3 +-
 drivers/media/common/tuners/tda18271-fe.c         |    3 +-
 drivers/media/common/tuners/tda827x.c             |    6 +---
 drivers/media/common/tuners/tuner-simple.c        |    3 +-
 drivers/media/common/tuners/tuner-xc2028.c        |    3 +-
 drivers/media/common/tuners/xc4000.c              |    3 +-
 drivers/media/common/tuners/xc5000.c              |    3 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c               |    6 ++--
 drivers/media/dvb/dvb-core/dvb_frontend.h         |    2 +-
 drivers/media/dvb/dvb-usb/af9005-fe.c             |    2 +-
 drivers/media/dvb/dvb-usb/cxusb.c                 |    8 ++---
 drivers/media/dvb/dvb-usb/dib0700_devices.c       |   30 +++++++++------------
 drivers/media/dvb/dvb-usb/digitv.c                |    2 +-
 drivers/media/dvb/dvb-usb/mxl111sf-demod.c        |    2 +-
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c        |    3 +-
 drivers/media/dvb/frontends/af9013.c              |    2 +-
 drivers/media/dvb/frontends/atbm8830.c            |    2 +-
 drivers/media/dvb/frontends/au8522_dig.c          |    2 +-
 drivers/media/dvb/frontends/bsbe1.h               |    2 +-
 drivers/media/dvb/frontends/bsru6.h               |    2 +-
 drivers/media/dvb/frontends/cx22700.c             |    2 +-
 drivers/media/dvb/frontends/cx22702.c             |    2 +-
 drivers/media/dvb/frontends/cx24110.c             |    2 +-
 drivers/media/dvb/frontends/cx24113.c             |    3 +-
 drivers/media/dvb/frontends/cx24123.c             |    2 +-
 drivers/media/dvb/frontends/cxd2820r_c.c          |    2 +-
 drivers/media/dvb/frontends/cxd2820r_t.c          |    2 +-
 drivers/media/dvb/frontends/cxd2820r_t2.c         |    2 +-
 drivers/media/dvb/frontends/dib0070.c             |    2 +-
 drivers/media/dvb/frontends/dib0090.c             |    2 +-
 drivers/media/dvb/frontends/dib3000mb.c           |    2 +-
 drivers/media/dvb/frontends/dib3000mc.c           |    2 +-
 drivers/media/dvb/frontends/dib7000m.c            |    2 +-
 drivers/media/dvb/frontends/dib7000p.c            |    2 +-
 drivers/media/dvb/frontends/dib8000.c             |    2 +-
 drivers/media/dvb/frontends/drxd_hard.c           |    2 +-
 drivers/media/dvb/frontends/drxk_hard.c           |    2 +-
 drivers/media/dvb/frontends/dvb-pll.c             |    3 +-
 drivers/media/dvb/frontends/dvb_dummy_fe.c        |    2 +-
 drivers/media/dvb/frontends/ec100.c               |    2 +-
 drivers/media/dvb/frontends/it913x-fe.c           |    2 +-
 drivers/media/dvb/frontends/itd1000.c             |    2 +-
 drivers/media/dvb/frontends/ix2505v.c             |    3 +-
 drivers/media/dvb/frontends/l64781.c              |    2 +-
 drivers/media/dvb/frontends/lgdt3305.c            |    4 +-
 drivers/media/dvb/frontends/lgdt330x.c            |    2 +-
 drivers/media/dvb/frontends/lgs8gl5.c             |    2 +-
 drivers/media/dvb/frontends/lgs8gxx.c             |    2 +-
 drivers/media/dvb/frontends/mb86a20s.c            |    2 +-
 drivers/media/dvb/frontends/mt312.c               |    2 +-
 drivers/media/dvb/frontends/mt352.c               |    2 +-
 drivers/media/dvb/frontends/nxt6000.c             |    2 +-
 drivers/media/dvb/frontends/or51132.c             |    2 +-
 drivers/media/dvb/frontends/or51211.c             |    2 +-
 drivers/media/dvb/frontends/s5h1409.c             |    2 +-
 drivers/media/dvb/frontends/s5h1411.c             |    2 +-
 drivers/media/dvb/frontends/s5h1420.c             |    4 +-
 drivers/media/dvb/frontends/s5h1432.c             |    6 ++--
 drivers/media/dvb/frontends/sp8870.c              |    2 +-
 drivers/media/dvb/frontends/sp887x.c              |    2 +-
 drivers/media/dvb/frontends/stb6000.c             |    3 +-
 drivers/media/dvb/frontends/stv0288.c             |    2 +-
 drivers/media/dvb/frontends/stv0297.c             |    2 +-
 drivers/media/dvb/frontends/stv0299.c             |    2 +-
 drivers/media/dvb/frontends/stv0367.c             |    4 +-
 drivers/media/dvb/frontends/stv6110.c             |    3 +-
 drivers/media/dvb/frontends/tda10021.c            |    2 +-
 drivers/media/dvb/frontends/tda10023.c            |    2 +-
 drivers/media/dvb/frontends/tda10048.c            |    2 +-
 drivers/media/dvb/frontends/tda1004x.c            |    2 +-
 drivers/media/dvb/frontends/tda10086.c            |    2 +-
 drivers/media/dvb/frontends/tda18271c2dd.c        |    3 +-
 drivers/media/dvb/frontends/tda8083.c             |    2 +-
 drivers/media/dvb/frontends/tda826x.c             |    2 +-
 drivers/media/dvb/frontends/tdhd1.h               |    2 +-
 drivers/media/dvb/frontends/tua6100.c             |    3 +-
 drivers/media/dvb/frontends/ves1820.c             |    2 +-
 drivers/media/dvb/frontends/ves1x93.c             |    2 +-
 drivers/media/dvb/frontends/zl10036.c             |    3 +-
 drivers/media/dvb/frontends/zl10039.c             |    3 +-
 drivers/media/dvb/frontends/zl10353.c             |    2 +-
 drivers/media/dvb/mantis/mantis_vp1033.c          |    3 +-
 drivers/media/dvb/mantis/mantis_vp2033.c          |    2 +-
 drivers/media/dvb/mantis/mantis_vp2040.c          |    2 +-
 drivers/media/dvb/pluto2/pluto2.c                 |    3 +-
 drivers/media/dvb/ttpci/av7110.c                  |   14 +++++-----
 drivers/media/dvb/ttpci/budget-av.c               |    7 ++---
 drivers/media/dvb/ttpci/budget-ci.c               |    7 ++---
 drivers/media/dvb/ttpci/budget-patch.c            |    4 +-
 drivers/media/dvb/ttpci/budget.c                  |   10 +++---
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |   12 ++++----
 drivers/media/video/cx88/cx88-dvb.c               |    3 +-
 drivers/media/video/saa7134/saa7134-dvb.c         |    9 +++---
 102 files changed, 148 insertions(+), 186 deletions(-)

diff --git a/drivers/media/common/tuners/max2165.c b/drivers/media/common/tuners/max2165.c
index 0343449..cb2c98f 100644
--- a/drivers/media/common/tuners/max2165.c
+++ b/drivers/media/common/tuners/max2165.c
@@ -257,8 +257,7 @@ static void max2165_debug_status(struct max2165_priv *priv)
 	dprintk("VCO: %d, VCO Sub-band: %d, ADC: %d\n", vco, vco_sub_band, adc);
 }
 
-static int max2165_set_params(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params)
+static int max2165_set_params(struct dvb_frontend *fe)
 {
 	struct max2165_priv *priv = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
diff --git a/drivers/media/common/tuners/mc44s803.c b/drivers/media/common/tuners/mc44s803.c
index 5a8758c..5ddce7e 100644
--- a/drivers/media/common/tuners/mc44s803.c
+++ b/drivers/media/common/tuners/mc44s803.c
@@ -214,8 +214,7 @@ exit:
 	return err;
 }
 
-static int mc44s803_set_params(struct dvb_frontend *fe,
-			       struct dvb_frontend_parameters *params)
+static int mc44s803_set_params(struct dvb_frontend *fe)
 {
 	struct mc44s803_priv *priv = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
diff --git a/drivers/media/common/tuners/mt2060.c b/drivers/media/common/tuners/mt2060.c
index 6fe2ef9..13381de 100644
--- a/drivers/media/common/tuners/mt2060.c
+++ b/drivers/media/common/tuners/mt2060.c
@@ -153,7 +153,7 @@ static int mt2060_spurcheck(u32 lo1,u32 lo2,u32 if2)
 #define IF2  36150       // IF2 frequency = 36.150 MHz
 #define FREF 16000       // Quartz oscillator 16 MHz
 
-static int mt2060_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int mt2060_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct mt2060_priv *priv;
diff --git a/drivers/media/common/tuners/mt2131.c b/drivers/media/common/tuners/mt2131.c
index d9cab1f..f83b0c1 100644
--- a/drivers/media/common/tuners/mt2131.c
+++ b/drivers/media/common/tuners/mt2131.c
@@ -92,8 +92,7 @@ static int mt2131_writeregs(struct mt2131_priv *priv,u8 *buf, u8 len)
 	return 0;
 }
 
-static int mt2131_set_params(struct dvb_frontend *fe,
-			     struct dvb_frontend_parameters *params)
+static int mt2131_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct mt2131_priv *priv;
diff --git a/drivers/media/common/tuners/mt2266.c b/drivers/media/common/tuners/mt2266.c
index dd883d7..2fb5a60 100644
--- a/drivers/media/common/tuners/mt2266.c
+++ b/drivers/media/common/tuners/mt2266.c
@@ -122,7 +122,7 @@ static u8 mt2266_vhf[] = { 0x1d, 0xfe, 0x00, 0x00, 0xb4, 0x03, 0xa5, 0xa5,
 
 #define FREF 30000       // Quartz oscillator 30 MHz
 
-static int mt2266_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int mt2266_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct mt2266_priv *priv;
diff --git a/drivers/media/common/tuners/mxl5005s.c b/drivers/media/common/tuners/mxl5005s.c
index c35d355..6133315 100644
--- a/drivers/media/common/tuners/mxl5005s.c
+++ b/drivers/media/common/tuners/mxl5005s.c
@@ -3979,8 +3979,7 @@ static int mxl5005s_AssignTunerMode(struct dvb_frontend *fe, u32 mod_type,
 	return 0;
 }
 
-static int mxl5005s_set_params(struct dvb_frontend *fe,
-			       struct dvb_frontend_parameters *params)
+static int mxl5005s_set_params(struct dvb_frontend *fe)
 {
 	struct mxl5005s_state *state = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
diff --git a/drivers/media/common/tuners/mxl5007t.c b/drivers/media/common/tuners/mxl5007t.c
index 6c45993..5d71e22 100644
--- a/drivers/media/common/tuners/mxl5007t.c
+++ b/drivers/media/common/tuners/mxl5007t.c
@@ -615,8 +615,7 @@ fail:
 
 /* ------------------------------------------------------------------------- */
 
-static int mxl5007t_set_params(struct dvb_frontend *fe,
-			       struct dvb_frontend_parameters *params)
+static int mxl5007t_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 delsys = c->delivery_system;
diff --git a/drivers/media/common/tuners/qt1010.c b/drivers/media/common/tuners/qt1010.c
index bd433ad..2d79b1f 100644
--- a/drivers/media/common/tuners/qt1010.c
+++ b/drivers/media/common/tuners/qt1010.c
@@ -82,8 +82,7 @@ static void qt1010_dump_regs(struct qt1010_priv *priv)
 	printk(KERN_CONT "\n");
 }
 
-static int qt1010_set_params(struct dvb_frontend *fe,
-			     struct dvb_frontend_parameters *params)
+static int qt1010_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct qt1010_priv *priv;
@@ -319,7 +318,6 @@ static u8 qt1010_init_meas2(struct qt1010_priv *priv,
 static int qt1010_init(struct dvb_frontend *fe)
 {
 	struct qt1010_priv *priv = fe->tuner_priv;
-	struct dvb_frontend_parameters params;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int err = 0;
 	u8 i, tmpval, *valptr = NULL;
@@ -399,7 +397,7 @@ static int qt1010_init(struct dvb_frontend *fe)
 
 	c->frequency = 545000000; /* Sigmatek DVB-110 545000000 */
 				      /* MSI Megasky 580 GL861 533000000 */
-	return qt1010_set_params(fe, &params);
+	return qt1010_set_params(fe);
 }
 
 static int qt1010_release(struct dvb_frontend *fe)
diff --git a/drivers/media/common/tuners/tda18212.c b/drivers/media/common/tuners/tda18212.c
index a58c74f..602c2e3 100644
--- a/drivers/media/common/tuners/tda18212.c
+++ b/drivers/media/common/tuners/tda18212.c
@@ -130,8 +130,7 @@ static void tda18212_dump_regs(struct tda18212_priv *priv)
 }
 #endif
 
-static int tda18212_set_params(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+static int tda18212_set_params(struct dvb_frontend *fe)
 {
 	struct tda18212_priv *priv = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
diff --git a/drivers/media/common/tuners/tda18218.c b/drivers/media/common/tuners/tda18218.c
index bbed0cf..917e718 100644
--- a/drivers/media/common/tuners/tda18218.c
+++ b/drivers/media/common/tuners/tda18218.c
@@ -109,8 +109,7 @@ static int tda18218_rd_reg(struct tda18218_priv *priv, u8 reg, u8 *val)
 	return tda18218_rd_regs(priv, reg, val, 1);
 }
 
-static int tda18218_set_params(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params)
+static int tda18218_set_params(struct dvb_frontend *fe)
 {
 	struct tda18218_priv *priv = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
diff --git a/drivers/media/common/tuners/tda18271-fe.c b/drivers/media/common/tuners/tda18271-fe.c
index 6348bb3..53299b0 100644
--- a/drivers/media/common/tuners/tda18271-fe.c
+++ b/drivers/media/common/tuners/tda18271-fe.c
@@ -928,8 +928,7 @@ fail:
 
 /* ------------------------------------------------------------------ */
 
-static int tda18271_set_params(struct dvb_frontend *fe,
-			       struct dvb_frontend_parameters *params)
+static int tda18271_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 delsys = c->delivery_system;
diff --git a/drivers/media/common/tuners/tda827x.c b/drivers/media/common/tuners/tda827x.c
index 7316308..d96d0b9 100644
--- a/drivers/media/common/tuners/tda827x.c
+++ b/drivers/media/common/tuners/tda827x.c
@@ -152,8 +152,7 @@ static int tuner_transfer(struct dvb_frontend *fe,
 	return rc;
 }
 
-static int tda827xo_set_params(struct dvb_frontend *fe,
-			       struct dvb_frontend_parameters *params)
+static int tda827xo_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct tda827x_priv *priv = fe->tuner_priv;
@@ -517,8 +516,7 @@ static void tda827xa_lna_gain(struct dvb_frontend *fe, int high,
 	}
 }
 
-static int tda827xa_set_params(struct dvb_frontend *fe,
-			       struct dvb_frontend_parameters *params)
+static int tda827xa_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct tda827x_priv *priv = fe->tuner_priv;
diff --git a/drivers/media/common/tuners/tuner-simple.c b/drivers/media/common/tuners/tuner-simple.c
index 1dad5fb..ce91c43 100644
--- a/drivers/media/common/tuners/tuner-simple.c
+++ b/drivers/media/common/tuners/tuner-simple.c
@@ -907,8 +907,7 @@ static int simple_dvb_calc_regs(struct dvb_frontend *fe,
 	return 5;
 }
 
-static int simple_dvb_set_params(struct dvb_frontend *fe,
-				 struct dvb_frontend_parameters *params)
+static int simple_dvb_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 delsys = c->delivery_system;
diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index 8c0dc6a1..a115657 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -1084,8 +1084,7 @@ static int xc2028_set_analog_freq(struct dvb_frontend *fe,
 				V4L2_TUNER_ANALOG_TV, type, p->std, 0);
 }
 
-static int xc2028_set_params(struct dvb_frontend *fe,
-			     struct dvb_frontend_parameters *p)
+static int xc2028_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 delsys = c->delivery_system;
diff --git a/drivers/media/common/tuners/xc4000.c b/drivers/media/common/tuners/xc4000.c
index e6acc7a..d17c0f5 100644
--- a/drivers/media/common/tuners/xc4000.c
+++ b/drivers/media/common/tuners/xc4000.c
@@ -1121,8 +1121,7 @@ static void xc_debug_dump(struct xc4000_priv *priv)
 	dprintk(1, "*** Quality (0:<8dB, 7:>56dB) = %d\n", quality);
 }
 
-static int xc4000_set_params(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params)
+static int xc4000_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 delsys = c->delivery_system;
diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 5c56d3c..7796339 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -628,8 +628,7 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 	dprintk(1, "*** Quality (0:<8dB, 7:>56dB) = %d\n", quality);
 }
 
-static int xc5000_set_params(struct dvb_frontend *fe,
-			     struct dvb_frontend_parameters *params)
+static int xc5000_set_params(struct dvb_frontend *fe)
 {
 	int ret, b;
 	struct xc5000_priv *priv = fe->tuner_priv;
diff --git a/drivers/media/dvb/bt8xx/dvb-bt8xx.c b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
index 8275d7e..352b27f 100644
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -192,7 +192,7 @@ static struct zl10353_config thomson_dtt7579_zl10353_config = {
 	.demod_address = 0x0f,
 };
 
-static int cx24108_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
+static int cx24108_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 freq = c->frequency;
@@ -267,7 +267,7 @@ static struct cx24110_config pctvsat_config = {
 	.demod_address = 0x55,
 };
 
-static int microtune_mt7202dtf_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
+static int microtune_mt7202dtf_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_bt8xx_card *card = (struct dvb_bt8xx_card *) fe->dvb->priv;
@@ -463,7 +463,7 @@ static struct or51211_config or51211_config = {
 	.sleep = or51211_sleep,
 };
 
-static int vp3021_alps_tded4_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
+static int vp3021_alps_tded4_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_bt8xx_card *card = (struct dvb_bt8xx_card *) fe->dvb->priv;
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 99ae782..895f88f 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -198,7 +198,7 @@ struct dvb_tuner_ops {
 	int (*sleep)(struct dvb_frontend *fe);
 
 	/** This is for simple PLLs - set all parameters in one go. */
-	int (*set_params)(struct dvb_frontend *fe, struct dvb_frontend_parameters *p);
+	int (*set_params)(struct dvb_frontend *fe);
 	int (*set_analog_params)(struct dvb_frontend *fe, struct analog_parameters *p);
 
 	/** This is support for demods like the mt352 - fills out the supplied buffer with what to write. */
diff --git a/drivers/media/dvb/dvb-usb/af9005-fe.c b/drivers/media/dvb/dvb-usb/af9005-fe.c
index 3263e97..aa44f65 100644
--- a/drivers/media/dvb/dvb-usb/af9005-fe.c
+++ b/drivers/media/dvb/dvb-usb/af9005-fe.c
@@ -1189,7 +1189,7 @@ static int af9005_fe_set_frontend(struct dvb_frontend *fe,
 		return ret;
 	/* set tuner */
 	deb_info("set tuner\n");
-	ret = fe->ops.tuner_ops.set_params(fe, fep);
+	ret = fe->ops.tuner_ops.set_params(fe);
 	if (ret)
 		return ret;
 
diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index 4f9bfc5..e8e5a74 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -1067,12 +1067,10 @@ static struct dib0070_config dib7070p_dib0070_config = {
 };
 
 struct dib0700_adapter_state {
-	int (*set_param_save) (struct dvb_frontend *,
-			       struct dvb_frontend_parameters *);
+	int (*set_param_save) (struct dvb_frontend *);
 };
 
-static int dib7070_set_param_override(struct dvb_frontend *fe,
-				      struct dvb_frontend_parameters *fep)
+static int dib7070_set_param_override(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
@@ -1088,7 +1086,7 @@ static int dib7070_set_param_override(struct dvb_frontend *fe,
 
 	dib7000p_set_wbd_ref(fe, offset + dib0070_wbd_offset(fe));
 
-	return state->set_param_save(fe, fep);
+	return state->set_param_save(fe);
 }
 
 static int cxusb_dualdig4_rev2_tuner_attach(struct dvb_usb_adapter *adap)
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 70c3be6..81ef4b4 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -30,7 +30,7 @@ MODULE_PARM_DESC(force_lna_activation, "force the activation of Low-Noise-Amplif
 		"if applicable for the device (default: 0=automatic/off).");
 
 struct dib0700_adapter_state {
-	int (*set_param_save) (struct dvb_frontend *, struct dvb_frontend_parameters *);
+	int (*set_param_save) (struct dvb_frontend *);
 	const struct firmware *frontend_firmware;
 };
 
@@ -804,7 +804,7 @@ static struct dib0070_config dib7770p_dib0070_config = {
 	 .charge_pump = 2,
 };
 
-static int dib7070_set_param_override(struct dvb_frontend *fe, struct dvb_frontend_parameters *fep)
+static int dib7070_set_param_override(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
@@ -819,11 +819,10 @@ static int dib7070_set_param_override(struct dvb_frontend *fe, struct dvb_fronte
 	}
 	deb_info("WBD for DiB7000P: %d\n", offset + dib0070_wbd_offset(fe));
 	dib7000p_set_wbd_ref(fe, offset + dib0070_wbd_offset(fe));
-	return state->set_param_save(fe, fep);
+	return state->set_param_save(fe);
 }
 
-static int dib7770_set_param_override(struct dvb_frontend *fe,
-		struct dvb_frontend_parameters *fep)
+static int dib7770_set_param_override(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
@@ -844,7 +843,7 @@ static int dib7770_set_param_override(struct dvb_frontend *fe,
 	 }
 	 deb_info("WBD for DiB7000P: %d\n", offset + dib0070_wbd_offset(fe));
 	 dib7000p_set_wbd_ref(fe, offset + dib0070_wbd_offset(fe));
-	 return state->set_param_save(fe, fep);
+	 return state->set_param_save(fe);
 }
 
 static int dib7770p_tuner_attach(struct dvb_usb_adapter *adap)
@@ -1207,8 +1206,7 @@ static struct dib0070_config dib807x_dib0070_config[2] = {
 	}
 };
 
-static int dib807x_set_param_override(struct dvb_frontend *fe,
-		struct dvb_frontend_parameters *fep)
+static int dib807x_set_param_override(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
@@ -1227,7 +1225,7 @@ static int dib807x_set_param_override(struct dvb_frontend *fe,
 	deb_info("WBD for DiB8000: %d\n", offset);
 	dib8000_set_wbd_ref(fe, offset);
 
-	return state->set_param_save(fe, fep);
+	return state->set_param_save(fe);
 }
 
 static int dib807x_tuner_attach(struct dvb_usb_adapter *adap)
@@ -1506,8 +1504,7 @@ static struct dib0090_config dib809x_dib0090_config = {
 	.fref_clock_ratio = 6,
 };
 
-static int dib8096_set_param_override(struct dvb_frontend *fe,
-		struct dvb_frontend_parameters *fep)
+static int dib8096_set_param_override(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
@@ -1518,7 +1515,7 @@ static int dib8096_set_param_override(struct dvb_frontend *fe,
 	enum frontend_tune_state tune_state = CT_SHUTDOWN;
 	u16 ltgain, rf_gain_limit;
 
-	ret = state->set_param_save(fe, fep);
+	ret = state->set_param_save(fe);
 	if (ret < 0)
 		return ret;
 
@@ -1823,8 +1820,7 @@ struct dibx090p_adc dib8090p_adc_tab[] = {
 	{0xffffffff, 0, 0, 0}, /* 60 MHz */
 };
 
-static int dib8096p_agc_startup(struct dvb_frontend *fe,
-		struct dvb_frontend_parameters *fep)
+static int dib8096p_agc_startup(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
@@ -1834,7 +1830,7 @@ static int dib8096p_agc_startup(struct dvb_frontend *fe,
 	int better_sampling_freq = 0, ret;
 	struct dibx090p_adc *adc_table = &dib8090p_adc_tab[0];
 
-	ret = state->set_param_save(fe, fep);
+	ret = state->set_param_save(fe);
 	if (ret < 0)
 		return ret;
 	memset(&pll, 0, sizeof(struct dibx000_bandwidth_config));
@@ -2325,7 +2321,7 @@ static int dib7090p_get_best_sampling(struct dvb_frontend *fe , struct dib7090p_
 		return 0;
 }
 
-static int dib7090_agc_startup(struct dvb_frontend *fe, struct dvb_frontend_parameters *fep)
+static int dib7090_agc_startup(struct dvb_frontend *fe)
 {
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	struct dib0700_adapter_state *state = adap->priv;
@@ -2334,7 +2330,7 @@ static int dib7090_agc_startup(struct dvb_frontend *fe, struct dvb_frontend_para
 	struct dib7090p_best_adc adc;
 	int ret;
 
-	ret = state->set_param_save(fe, fep);
+	ret = state->set_param_save(fe);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/dvb/dvb-usb/digitv.c b/drivers/media/dvb/dvb-usb/digitv.c
index 2856ab7..00a446d 100644
--- a/drivers/media/dvb/dvb-usb/digitv.c
+++ b/drivers/media/dvb/dvb-usb/digitv.c
@@ -118,7 +118,7 @@ static struct mt352_config digitv_mt352_config = {
 	.demod_init = digitv_mt352_demod_init,
 };
 
-static int digitv_nxt6000_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *fep)
+static int digitv_nxt6000_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	u8 b[5];
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-demod.c b/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
index d1f5837..3ae7729 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
@@ -303,7 +303,7 @@ static int mxl111sf_demod_set_frontend(struct dvb_frontend *fe,
 	mxl_dbg("()");
 
 	if (fe->ops.tuner_ops.set_params) {
-		ret = fe->ops.tuner_ops.set_params(fe, param);
+		ret = fe->ops.tuner_ops.set_params(fe);
 		if (mxl_fail(ret))
 			goto fail;
 		msleep(50);
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c b/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
index aeac7a9..3a533df 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
@@ -272,8 +272,7 @@ static int mxl1x1sf_tuner_loop_thru_ctrl(struct mxl111sf_tuner_state *state,
 
 /* ------------------------------------------------------------------------ */
 
-static int mxl111sf_tuner_set_params(struct dvb_frontend *fe,
-				     struct dvb_frontend_parameters *params)
+static int mxl111sf_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 delsys  = c->delivery_system;
diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index f4276e4..889827d 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -608,7 +608,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe,
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe, params);
+		fe->ops.tuner_ops.set_params(fe);
 
 	/* program CFOE coefficients */
 	ret = af9013_set_coeff(state, params->u.ofdm.bandwidth);
diff --git a/drivers/media/dvb/frontends/atbm8830.c b/drivers/media/dvb/frontends/atbm8830.c
index 1539ea1..90480d3 100644
--- a/drivers/media/dvb/frontends/atbm8830.c
+++ b/drivers/media/dvb/frontends/atbm8830.c
@@ -279,7 +279,7 @@ static int atbm8830_set_fe(struct dvb_frontend *fe,
 	if (fe->ops.tuner_ops.set_params) {
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
-		fe->ops.tuner_ops.set_params(fe, fe_params);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
diff --git a/drivers/media/dvb/frontends/au8522_dig.c b/drivers/media/dvb/frontends/au8522_dig.c
index 5c0d398..1df9d9c 100644
--- a/drivers/media/dvb/frontends/au8522_dig.c
+++ b/drivers/media/dvb/frontends/au8522_dig.c
@@ -596,7 +596,7 @@ static int au8522_set_frontend(struct dvb_frontend *fe,
 	if (fe->ops.tuner_ops.set_params) {
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
-		ret = fe->ops.tuner_ops.set_params(fe, p);
+		ret = fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
diff --git a/drivers/media/dvb/frontends/bsbe1.h b/drivers/media/dvb/frontends/bsbe1.h
index e008946..f482b10 100644
--- a/drivers/media/dvb/frontends/bsbe1.h
+++ b/drivers/media/dvb/frontends/bsbe1.h
@@ -69,7 +69,7 @@ static int alps_bsbe1_set_symbol_rate(struct dvb_frontend* fe, u32 srate, u32 ra
 	return 0;
 }
 
-static int alps_bsbe1_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
+static int alps_bsbe1_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	int ret;
diff --git a/drivers/media/dvb/frontends/bsru6.h b/drivers/media/dvb/frontends/bsru6.h
index cd8c675..686df0c 100644
--- a/drivers/media/dvb/frontends/bsru6.h
+++ b/drivers/media/dvb/frontends/bsru6.h
@@ -101,7 +101,7 @@ static int alps_bsru6_set_symbol_rate(struct dvb_frontend *fe, u32 srate, u32 ra
 	return 0;
 }
 
-static int alps_bsru6_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int alps_bsru6_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	u8 buf[4];
diff --git a/drivers/media/dvb/frontends/cx22700.c b/drivers/media/dvb/frontends/cx22700.c
index 0142214..6ef82a1 100644
--- a/drivers/media/dvb/frontends/cx22700.c
+++ b/drivers/media/dvb/frontends/cx22700.c
@@ -326,7 +326,7 @@ static int cx22700_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 	cx22700_writereg (state, 0x00, 0x00);
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
diff --git a/drivers/media/dvb/frontends/cx22702.c b/drivers/media/dvb/frontends/cx22702.c
index 3139558..73dd87a 100644
--- a/drivers/media/dvb/frontends/cx22702.c
+++ b/drivers/media/dvb/frontends/cx22702.c
@@ -267,7 +267,7 @@ static int cx22702_set_tps(struct dvb_frontend *fe,
 	struct cx22702_state *state = fe->demodulator_priv;
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
diff --git a/drivers/media/dvb/frontends/cx24110.c b/drivers/media/dvb/frontends/cx24110.c
index bf9c999..1eb9253 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -537,7 +537,7 @@ static int cx24110_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
diff --git a/drivers/media/dvb/frontends/cx24113.c b/drivers/media/dvb/frontends/cx24113.c
index 07737e2..4b8794f 100644
--- a/drivers/media/dvb/frontends/cx24113.c
+++ b/drivers/media/dvb/frontends/cx24113.c
@@ -476,8 +476,7 @@ static int cx24113_init(struct dvb_frontend *fe)
 	return ret;
 }
 
-static int cx24113_set_params(struct dvb_frontend *fe,
-		struct dvb_frontend_parameters *p)
+static int cx24113_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct cx24113_state *state = fe->tuner_priv;
diff --git a/drivers/media/dvb/frontends/cx24123.c b/drivers/media/dvb/frontends/cx24123.c
index b1dd8ac..4d387d3 100644
--- a/drivers/media/dvb/frontends/cx24123.c
+++ b/drivers/media/dvb/frontends/cx24123.c
@@ -945,7 +945,7 @@ static int cx24123_set_frontend(struct dvb_frontend *fe,
 	if (!state->config->dont_use_pll)
 		cx24123_pll_tune(fe, p);
 	else if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 	else
 		err("it seems I don't have a tuner...");
 
diff --git a/drivers/media/dvb/frontends/cxd2820r_c.c b/drivers/media/dvb/frontends/cxd2820r_c.c
index 7016e27..26545d7 100644
--- a/drivers/media/dvb/frontends/cxd2820r_c.c
+++ b/drivers/media/dvb/frontends/cxd2820r_c.c
@@ -57,7 +57,7 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe,
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe, params);
+		fe->ops.tuner_ops.set_params(fe);
 
 	if (priv->delivery_system !=  SYS_DVBC_ANNEX_A) {
 		for (i = 0; i < ARRAY_SIZE(tab); i++) {
diff --git a/drivers/media/dvb/frontends/cxd2820r_t.c b/drivers/media/dvb/frontends/cxd2820r_t.c
index b1450ac..a12ba74 100644
--- a/drivers/media/dvb/frontends/cxd2820r_t.c
+++ b/drivers/media/dvb/frontends/cxd2820r_t.c
@@ -81,7 +81,7 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe,
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 
 	if (priv->delivery_system != SYS_DVBT) {
 		for (i = 0; i < ARRAY_SIZE(tab); i++) {
diff --git a/drivers/media/dvb/frontends/cxd2820r_t2.c b/drivers/media/dvb/frontends/cxd2820r_t2.c
index e21fc97..52ed2c4 100644
--- a/drivers/media/dvb/frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb/frontends/cxd2820r_t2.c
@@ -99,7 +99,7 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe,
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe, params);
+		fe->ops.tuner_ops.set_params(fe);
 
 	if (priv->delivery_system != SYS_DVBT2) {
 		for (i = 0; i < ARRAY_SIZE(tab); i++) {
diff --git a/drivers/media/dvb/frontends/dib0070.c b/drivers/media/dvb/frontends/dib0070.c
index 4ca3441..3b024bf 100644
--- a/drivers/media/dvb/frontends/dib0070.c
+++ b/drivers/media/dvb/frontends/dib0070.c
@@ -516,7 +516,7 @@ static int dib0070_tune_digital(struct dvb_frontend *fe)
 }
 
 
-static int dib0070_tune(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
+static int dib0070_tune(struct dvb_frontend *fe)
 {
     struct dib0070_state *state = fe->tuner_priv;
     uint32_t ret;
diff --git a/drivers/media/dvb/frontends/dib0090.c b/drivers/media/dvb/frontends/dib0090.c
index 2b30ab2..224d81e 100644
--- a/drivers/media/dvb/frontends/dib0090.c
+++ b/drivers/media/dvb/frontends/dib0090.c
@@ -2566,7 +2566,7 @@ static int dib0090_get_frequency(struct dvb_frontend *fe, u32 * frequency)
 	return 0;
 }
 
-static int dib0090_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
+static int dib0090_set_params(struct dvb_frontend *fe)
 {
 	struct dib0090_state *state = fe->tuner_priv;
 	u32 ret;
diff --git a/drivers/media/dvb/frontends/dib3000mb.c b/drivers/media/dvb/frontends/dib3000mb.c
index 437904c..7403198 100644
--- a/drivers/media/dvb/frontends/dib3000mb.c
+++ b/drivers/media/dvb/frontends/dib3000mb.c
@@ -124,7 +124,7 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 	int search_state, seq;
 
 	if (tuner && fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, fep);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 
 		deb_setf("bandwidth: ");
diff --git a/drivers/media/dvb/frontends/dib3000mc.c b/drivers/media/dvb/frontends/dib3000mc.c
index 088e7fa..32cd006 100644
--- a/drivers/media/dvb/frontends/dib3000mc.c
+++ b/drivers/media/dvb/frontends/dib3000mc.c
@@ -696,7 +696,7 @@ static int dib3000mc_set_frontend(struct dvb_frontend* fe,
 	state->sfn_workaround_active = buggy_sfn_workaround;
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, fep);
+		fe->ops.tuner_ops.set_params(fe);
 		msleep(100);
 	}
 
diff --git a/drivers/media/dvb/frontends/dib7000m.c b/drivers/media/dvb/frontends/dib7000m.c
index dbb76d7..a30a482 100644
--- a/drivers/media/dvb/frontends/dib7000m.c
+++ b/drivers/media/dvb/frontends/dib7000m.c
@@ -1217,7 +1217,7 @@ static int dib7000m_set_frontend(struct dvb_frontend* fe,
 	dib7000m_set_bandwidth(state, BANDWIDTH_TO_KHZ(fep->u.ofdm.bandwidth));
 
 	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe, fep);
+		fe->ops.tuner_ops.set_params(fe);
 
 	/* start up the AGC */
 	state->agc_state = 0;
diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
index b5f3fb4..9983207 100644
--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -1489,7 +1489,7 @@ static int dib7000p_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_pa
 	state->sfn_workaround_active = buggy_sfn_workaround;
 
 	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe, fep);
+		fe->ops.tuner_ops.set_params(fe);
 
 	/* start up the AGC */
 	state->agc_state = 0;
diff --git a/drivers/media/dvb/frontends/dib8000.c b/drivers/media/dvb/frontends/dib8000.c
index b8da0c9..2da2bb3 100644
--- a/drivers/media/dvb/frontends/dib8000.c
+++ b/drivers/media/dvb/frontends/dib8000.c
@@ -2986,7 +2986,7 @@ static int dib8000_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_par
 			dib8096p_set_output_mode(state->fe[index_frontend],
 					OUTMODE_HIGH_Z);
 		if (state->fe[index_frontend]->ops.tuner_ops.set_params)
-			state->fe[index_frontend]->ops.tuner_ops.set_params(state->fe[index_frontend], fep);
+			state->fe[index_frontend]->ops.tuner_ops.set_params(state->fe[index_frontend]);
 
 		dib8000_set_tune_state(state->fe[index_frontend], CT_AGC_START);
 	}
diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
index beb6775..955d3a5 100644
--- a/drivers/media/dvb/frontends/drxd_hard.c
+++ b/drivers/media/dvb/frontends/drxd_hard.c
@@ -2907,7 +2907,7 @@ static int drxd_set_frontend(struct dvb_frontend *fe,
 	DRX_Stop(state);
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, param);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index d795898..83b8474 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6240,7 +6240,7 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 	state->param = *p;
diff --git a/drivers/media/dvb/frontends/dvb-pll.c b/drivers/media/dvb/frontends/dvb-pll.c
index 21f425f..0625e61 100644
--- a/drivers/media/dvb/frontends/dvb-pll.c
+++ b/drivers/media/dvb/frontends/dvb-pll.c
@@ -608,8 +608,7 @@ static int dvb_pll_sleep(struct dvb_frontend *fe)
 	return -EINVAL;
 }
 
-static int dvb_pll_set_params(struct dvb_frontend *fe,
-			      struct dvb_frontend_parameters *params)
+static int dvb_pll_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_pll_priv *priv = fe->tuner_priv;
diff --git a/drivers/media/dvb/frontends/dvb_dummy_fe.c b/drivers/media/dvb/frontends/dvb_dummy_fe.c
index a7fc7e5..e3a7e42 100644
--- a/drivers/media/dvb/frontends/dvb_dummy_fe.c
+++ b/drivers/media/dvb/frontends/dvb_dummy_fe.c
@@ -76,7 +76,7 @@ static int dvb_dummy_fe_get_frontend(struct dvb_frontend* fe, struct dvb_fronten
 static int dvb_dummy_fe_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
 {
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
diff --git a/drivers/media/dvb/frontends/ec100.c b/drivers/media/dvb/frontends/ec100.c
index 2414dc6..1ef79f0 100644
--- a/drivers/media/dvb/frontends/ec100.c
+++ b/drivers/media/dvb/frontends/ec100.c
@@ -88,7 +88,7 @@ static int ec100_set_frontend(struct dvb_frontend *fe,
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe, params);
+		fe->ops.tuner_ops.set_params(fe);
 
 	ret = ec100_write_reg(state, 0x04, 0x06);
 	if (ret)
diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index 8088e62..8857710 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -642,7 +642,7 @@ static int it913x_fe_set_frontend(struct dvb_frontend *fe,
 		break;
 	default:
 		if (fe->ops.tuner_ops.set_params) {
-			fe->ops.tuner_ops.set_params(fe, p);
+			fe->ops.tuner_ops.set_params(fe);
 			if (fe->ops.i2c_gate_ctrl)
 				fe->ops.i2c_gate_ctrl(fe, 0);
 		}
diff --git a/drivers/media/dvb/frontends/itd1000.c b/drivers/media/dvb/frontends/itd1000.c
index afe7cc0..3164575 100644
--- a/drivers/media/dvb/frontends/itd1000.c
+++ b/drivers/media/dvb/frontends/itd1000.c
@@ -250,7 +250,7 @@ static void itd1000_set_lo(struct itd1000_state *state, u32 freq_khz)
 	itd1000_set_vco(state, freq_khz);
 }
 
-static int itd1000_set_parameters(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
+static int itd1000_set_parameters(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct itd1000_state *state = fe->tuner_priv;
diff --git a/drivers/media/dvb/frontends/ix2505v.c b/drivers/media/dvb/frontends/ix2505v.c
index aca4817..bc5a820 100644
--- a/drivers/media/dvb/frontends/ix2505v.c
+++ b/drivers/media/dvb/frontends/ix2505v.c
@@ -129,8 +129,7 @@ static int ix2505v_release(struct dvb_frontend *fe)
  *  1 -> 8 -> 6
  */
 
-static int ix2505v_set_params(struct dvb_frontend *fe,
-		struct dvb_frontend_parameters *params)
+static int ix2505v_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct ix2505v_state *state = fe->tuner_priv;
diff --git a/drivers/media/dvb/frontends/l64781.c b/drivers/media/dvb/frontends/l64781.c
index 445fa10..eee6bb5 100644
--- a/drivers/media/dvb/frontends/l64781.c
+++ b/drivers/media/dvb/frontends/l64781.c
@@ -140,7 +140,7 @@ static int apply_frontend_param (struct dvb_frontend* fe, struct dvb_frontend_pa
 	int bw = p->bandwidth - BANDWIDTH_8_MHZ;
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, param);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
diff --git a/drivers/media/dvb/frontends/lgdt3305.c b/drivers/media/dvb/frontends/lgdt3305.c
index 3272881..321f991 100644
--- a/drivers/media/dvb/frontends/lgdt3305.c
+++ b/drivers/media/dvb/frontends/lgdt3305.c
@@ -686,7 +686,7 @@ static int lgdt3304_set_parameters(struct dvb_frontend *fe,
 	lg_dbg("(%d, %d)\n", param->frequency, param->u.vsb.modulation);
 
 	if (fe->ops.tuner_ops.set_params) {
-		ret = fe->ops.tuner_ops.set_params(fe, param);
+		ret = fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 		if (lg_fail(ret))
@@ -756,7 +756,7 @@ static int lgdt3305_set_parameters(struct dvb_frontend *fe,
 	lg_dbg("(%d, %d)\n", param->frequency, param->u.vsb.modulation);
 
 	if (fe->ops.tuner_ops.set_params) {
-		ret = fe->ops.tuner_ops.set_params(fe, param);
+		ret = fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 		if (lg_fail(ret))
diff --git a/drivers/media/dvb/frontends/lgdt330x.c b/drivers/media/dvb/frontends/lgdt330x.c
index 43971e6..87b6a9c 100644
--- a/drivers/media/dvb/frontends/lgdt330x.c
+++ b/drivers/media/dvb/frontends/lgdt330x.c
@@ -415,7 +415,7 @@ static int lgdt330x_set_parameters(struct dvb_frontend* fe,
 
 	/* Tune to the specified frequency */
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, param);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
diff --git a/drivers/media/dvb/frontends/lgs8gl5.c b/drivers/media/dvb/frontends/lgs8gl5.c
index bb37ed2..4a9bd99 100644
--- a/drivers/media/dvb/frontends/lgs8gl5.c
+++ b/drivers/media/dvb/frontends/lgs8gl5.c
@@ -322,7 +322,7 @@ lgs8gl5_set_frontend(struct dvb_frontend *fe,
 		return -EINVAL;
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/frontends/lgs8gxx.c
index 1172b54..bf9b12b 100644
--- a/drivers/media/dvb/frontends/lgs8gxx.c
+++ b/drivers/media/dvb/frontends/lgs8gxx.c
@@ -678,7 +678,7 @@ static int lgs8gxx_set_fe(struct dvb_frontend *fe,
 
 	/* set frequency */
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, fe_params);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
diff --git a/drivers/media/dvb/frontends/mb86a20s.c b/drivers/media/dvb/frontends/mb86a20s.c
index 0f867a50..8c92070 100644
--- a/drivers/media/dvb/frontends/mb86a20s.c
+++ b/drivers/media/dvb/frontends/mb86a20s.c
@@ -496,7 +496,7 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe,
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	dprintk("Calling tuner set parameters\n");
-	fe->ops.tuner_ops.set_params(fe, p);
+	fe->ops.tuner_ops.set_params(fe);
 
 	/*
 	 * Make it more reliable: if, for some reason, the initial
diff --git a/drivers/media/dvb/frontends/mt312.c b/drivers/media/dvb/frontends/mt312.c
index 83e6f1a..302d72a 100644
--- a/drivers/media/dvb/frontends/mt312.c
+++ b/drivers/media/dvb/frontends/mt312.c
@@ -603,7 +603,7 @@ static int mt312_set_frontend(struct dvb_frontend *fe,
 	}
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
diff --git a/drivers/media/dvb/frontends/mt352.c b/drivers/media/dvb/frontends/mt352.c
index e2a86da..16a9fac 100644
--- a/drivers/media/dvb/frontends/mt352.c
+++ b/drivers/media/dvb/frontends/mt352.c
@@ -293,7 +293,7 @@ static int mt352_set_parameters(struct dvb_frontend* fe,
 
 	if (state->config.no_tuner) {
 		if (fe->ops.tuner_ops.set_params) {
-			fe->ops.tuner_ops.set_params(fe, param);
+			fe->ops.tuner_ops.set_params(fe);
 			if (fe->ops.i2c_gate_ctrl)
 				fe->ops.i2c_gate_ctrl(fe, 0);
 		}
diff --git a/drivers/media/dvb/frontends/nxt6000.c b/drivers/media/dvb/frontends/nxt6000.c
index 6599b8f..d17dd2d 100644
--- a/drivers/media/dvb/frontends/nxt6000.c
+++ b/drivers/media/dvb/frontends/nxt6000.c
@@ -463,7 +463,7 @@ static int nxt6000_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 	int result;
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, param);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
diff --git a/drivers/media/dvb/frontends/or51132.c b/drivers/media/dvb/frontends/or51132.c
index 38e67ac..5cd965b 100644
--- a/drivers/media/dvb/frontends/or51132.c
+++ b/drivers/media/dvb/frontends/or51132.c
@@ -363,7 +363,7 @@ static int or51132_set_parameters(struct dvb_frontend* fe,
 	}
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, param);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
diff --git a/drivers/media/dvb/frontends/or51211.c b/drivers/media/dvb/frontends/or51211.c
index c709ce6..92d4dd8 100644
--- a/drivers/media/dvb/frontends/or51211.c
+++ b/drivers/media/dvb/frontends/or51211.c
@@ -226,7 +226,7 @@ static int or51211_set_parameters(struct dvb_frontend* fe,
 	/* Change only if we are actually changing the channel */
 	if (state->current_frequency != param->frequency) {
 		if (fe->ops.tuner_ops.set_params) {
-			fe->ops.tuner_ops.set_params(fe, param);
+			fe->ops.tuner_ops.set_params(fe);
 			if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 		}
 
diff --git a/drivers/media/dvb/frontends/s5h1409.c b/drivers/media/dvb/frontends/s5h1409.c
index 0d6d5e3..5ffb19e 100644
--- a/drivers/media/dvb/frontends/s5h1409.c
+++ b/drivers/media/dvb/frontends/s5h1409.c
@@ -647,7 +647,7 @@ static int s5h1409_set_frontend(struct dvb_frontend *fe,
 	if (fe->ops.tuner_ops.set_params) {
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
diff --git a/drivers/media/dvb/frontends/s5h1411.c b/drivers/media/dvb/frontends/s5h1411.c
index 5fca113..6852abe 100644
--- a/drivers/media/dvb/frontends/s5h1411.c
+++ b/drivers/media/dvb/frontends/s5h1411.c
@@ -602,7 +602,7 @@ static int s5h1411_set_frontend(struct dvb_frontend *fe,
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
 
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
diff --git a/drivers/media/dvb/frontends/s5h1420.c b/drivers/media/dvb/frontends/s5h1420.c
index 3879d2e..c4a8a01 100644
--- a/drivers/media/dvb/frontends/s5h1420.c
+++ b/drivers/media/dvb/frontends/s5h1420.c
@@ -649,7 +649,7 @@ static int s5h1420_set_frontend(struct dvb_frontend* fe,
 			(state->symbol_rate == p->u.qpsk.symbol_rate)) {
 
 		if (fe->ops.tuner_ops.set_params) {
-			fe->ops.tuner_ops.set_params(fe, p);
+			fe->ops.tuner_ops.set_params(fe);
 			if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 		}
 		if (fe->ops.tuner_ops.get_frequency) {
@@ -744,7 +744,7 @@ static int s5h1420_set_frontend(struct dvb_frontend* fe,
 
 	/* set tuner PLL */
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 		s5h1420_setfreqoffset(state, 0);
diff --git a/drivers/media/dvb/frontends/s5h1432.c b/drivers/media/dvb/frontends/s5h1432.c
index 0c6dcb9..2717bae 100644
--- a/drivers/media/dvb/frontends/s5h1432.c
+++ b/drivers/media/dvb/frontends/s5h1432.c
@@ -188,7 +188,7 @@ static int s5h1432_set_frontend(struct dvb_frontend *fe,
 		/*current_frequency = p->frequency; */
 		/*state->current_frequency = p->frequency; */
 	} else {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		msleep(300);
 		s5h1432_set_channel_bandwidth(fe, dvb_bandwidth);
 		switch (p->u.ofdm.bandwidth) {
@@ -207,7 +207,7 @@ static int s5h1432_set_frontend(struct dvb_frontend *fe,
 		default:
 			return 0;
 		}
-		/*fe->ops.tuner_ops.set_params(fe, p); */
+		/*fe->ops.tuner_ops.set_params(fe); */
 /*Soft Reset chip*/
 		msleep(30);
 		s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x09, 0x1a);
@@ -231,7 +231,7 @@ static int s5h1432_set_frontend(struct dvb_frontend *fe,
 		default:
 			return 0;
 		}
-		/*fe->ops.tuner_ops.set_params(fe,p); */
+		/*fe->ops.tuner_ops.set_params(fe); */
 		/*Soft Reset chip*/
 		msleep(30);
 		s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x09, 0x1a);
diff --git a/drivers/media/dvb/frontends/sp8870.c b/drivers/media/dvb/frontends/sp8870.c
index b85eb60..9cff909 100644
--- a/drivers/media/dvb/frontends/sp8870.c
+++ b/drivers/media/dvb/frontends/sp8870.c
@@ -260,7 +260,7 @@ static int sp8870_set_frontend_parameters (struct dvb_frontend* fe,
 
 	// set tuner parameters
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
diff --git a/drivers/media/dvb/frontends/sp887x.c b/drivers/media/dvb/frontends/sp887x.c
index 4a7c3d8..efe0926 100644
--- a/drivers/media/dvb/frontends/sp887x.c
+++ b/drivers/media/dvb/frontends/sp887x.c
@@ -353,7 +353,7 @@ static int sp887x_setup_frontend_parameters (struct dvb_frontend* fe,
 
 	/* setup the PLL */
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 	if (fe->ops.tuner_ops.get_frequency) {
diff --git a/drivers/media/dvb/frontends/stb6000.c b/drivers/media/dvb/frontends/stb6000.c
index d4f4ebb..a0c3c52 100644
--- a/drivers/media/dvb/frontends/stb6000.c
+++ b/drivers/media/dvb/frontends/stb6000.c
@@ -75,8 +75,7 @@ static int stb6000_sleep(struct dvb_frontend *fe)
 	return (ret == 1) ? 0 : ret;
 }
 
-static int stb6000_set_params(struct dvb_frontend *fe,
-				struct dvb_frontend_parameters *params)
+static int stb6000_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stb6000_priv *priv = fe->tuner_priv;
diff --git a/drivers/media/dvb/frontends/stv0288.c b/drivers/media/dvb/frontends/stv0288.c
index 0aa3962..a1b4933 100644
--- a/drivers/media/dvb/frontends/stv0288.c
+++ b/drivers/media/dvb/frontends/stv0288.c
@@ -484,7 +484,7 @@ static int stv0288_set_frontend(struct dvb_frontend *fe,
 	dfp->frequency = c->frequency;
 	dfp->u.qpsk.symbol_rate = c->symbol_rate;
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, dfp);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
diff --git a/drivers/media/dvb/frontends/stv0297.c b/drivers/media/dvb/frontends/stv0297.c
index 84d88f33..daeaddf 100644
--- a/drivers/media/dvb/frontends/stv0297.c
+++ b/drivers/media/dvb/frontends/stv0297.c
@@ -455,7 +455,7 @@ static int stv0297_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_par
 
 	stv0297_init(fe);
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
diff --git a/drivers/media/dvb/frontends/stv0299.c b/drivers/media/dvb/frontends/stv0299.c
index 42684be..bd79e05 100644
--- a/drivers/media/dvb/frontends/stv0299.c
+++ b/drivers/media/dvb/frontends/stv0299.c
@@ -579,7 +579,7 @@ static int stv0299_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 	stv0299_writeregI(state, 0x0c, (stv0299_readreg(state, 0x0c) & 0xfe) | invval);
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb/frontends/stv0367.c
index e57ab53..586295d 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -1822,7 +1822,7 @@ static int stv0367ter_set_frontend(struct dvb_frontend *fe,
 	if (fe->ops.tuner_ops.set_params) {
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
-		fe->ops.tuner_ops.set_params(fe, param);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
@@ -3120,7 +3120,7 @@ static int stv0367cab_set_frontend(struct dvb_frontend *fe,
 	if (fe->ops.tuner_ops.set_params) {
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
-		fe->ops.tuner_ops.set_params(fe, param);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
diff --git a/drivers/media/dvb/frontends/stv6110.c b/drivers/media/dvb/frontends/stv6110.c
index 2dca7c8..20b5fa9 100644
--- a/drivers/media/dvb/frontends/stv6110.c
+++ b/drivers/media/dvb/frontends/stv6110.c
@@ -347,8 +347,7 @@ static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
 	return 0;
 }
 
-static int stv6110_set_params(struct dvb_frontend *fe,
-			      struct dvb_frontend_parameters *params)
+static int stv6110_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 bandwidth = carrier_width(c->symbol_rate, c->rolloff);
diff --git a/drivers/media/dvb/frontends/tda10021.c b/drivers/media/dvb/frontends/tda10021.c
index 2518c5a..a1629d1 100644
--- a/drivers/media/dvb/frontends/tda10021.c
+++ b/drivers/media/dvb/frontends/tda10021.c
@@ -283,7 +283,7 @@ static int tda10021_set_parameters (struct dvb_frontend *fe,
 	//printk("tda10021: set frequency to %d qam=%d symrate=%d\n", p->frequency,qam,p->u.qam.symbol_rate);
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
diff --git a/drivers/media/dvb/frontends/tda10023.c b/drivers/media/dvb/frontends/tda10023.c
index af7f1b8..ecc4b55 100644
--- a/drivers/media/dvb/frontends/tda10023.c
+++ b/drivers/media/dvb/frontends/tda10023.c
@@ -351,7 +351,7 @@ static int tda10023_set_parameters (struct dvb_frontend *fe,
 	}
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
diff --git a/drivers/media/dvb/frontends/tda10048.c b/drivers/media/dvb/frontends/tda10048.c
index 7f10594..d450385 100644
--- a/drivers/media/dvb/frontends/tda10048.c
+++ b/drivers/media/dvb/frontends/tda10048.c
@@ -756,7 +756,7 @@ static int tda10048_set_frontend(struct dvb_frontend *fe,
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
 
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
diff --git a/drivers/media/dvb/frontends/tda1004x.c b/drivers/media/dvb/frontends/tda1004x.c
index ea485d9..dbac35b 100644
--- a/drivers/media/dvb/frontends/tda1004x.c
+++ b/drivers/media/dvb/frontends/tda1004x.c
@@ -718,7 +718,7 @@ static int tda1004x_set_fe(struct dvb_frontend* fe,
 
 	// set frequency
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, fe_params);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
diff --git a/drivers/media/dvb/frontends/tda10086.c b/drivers/media/dvb/frontends/tda10086.c
index f2c8faa..7656ff7 100644
--- a/drivers/media/dvb/frontends/tda10086.c
+++ b/drivers/media/dvb/frontends/tda10086.c
@@ -425,7 +425,7 @@ static int tda10086_set_frontend(struct dvb_frontend* fe,
 
 	/* set params */
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, fe_params);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 
diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb/frontends/tda18271c2dd.c
index 0f8e962..ea6df8e 100644
--- a/drivers/media/dvb/frontends/tda18271c2dd.c
+++ b/drivers/media/dvb/frontends/tda18271c2dd.c
@@ -1124,8 +1124,7 @@ static int release(struct dvb_frontend *fe)
 }
 
 
-static int set_params(struct dvb_frontend *fe,
-		      struct dvb_frontend_parameters *params)
+static int set_params(struct dvb_frontend *fe)
 {
 	struct tda_state *state = fe->tuner_priv;
 	int status = 0;
diff --git a/drivers/media/dvb/frontends/tda8083.c b/drivers/media/dvb/frontends/tda8083.c
index 9369f74..3f2b1b8 100644
--- a/drivers/media/dvb/frontends/tda8083.c
+++ b/drivers/media/dvb/frontends/tda8083.c
@@ -320,7 +320,7 @@ static int tda8083_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 	struct tda8083_state* state = fe->demodulator_priv;
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
diff --git a/drivers/media/dvb/frontends/tda826x.c b/drivers/media/dvb/frontends/tda826x.c
index ab9122a..04bbcc2 100644
--- a/drivers/media/dvb/frontends/tda826x.c
+++ b/drivers/media/dvb/frontends/tda826x.c
@@ -71,7 +71,7 @@ static int tda826x_sleep(struct dvb_frontend *fe)
 	return (ret == 1) ? 0 : ret;
 }
 
-static int tda826x_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int tda826x_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct tda826x_priv *priv = fe->tuner_priv;
diff --git a/drivers/media/dvb/frontends/tdhd1.h b/drivers/media/dvb/frontends/tdhd1.h
index 9db221b..1775098 100644
--- a/drivers/media/dvb/frontends/tdhd1.h
+++ b/drivers/media/dvb/frontends/tdhd1.h
@@ -40,7 +40,7 @@ static struct tda1004x_config alps_tdhd1_204a_config = {
 	.request_firmware = alps_tdhd1_204_request_firmware
 };
 
-static int alps_tdhd1_204a_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int alps_tdhd1_204a_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct i2c_adapter *i2c = fe->tuner_priv;
diff --git a/drivers/media/dvb/frontends/tua6100.c b/drivers/media/dvb/frontends/tua6100.c
index 621d750..aebe260 100644
--- a/drivers/media/dvb/frontends/tua6100.c
+++ b/drivers/media/dvb/frontends/tua6100.c
@@ -67,8 +67,7 @@ static int tua6100_sleep(struct dvb_frontend *fe)
 	return (ret == 1) ? 0 : ret;
 }
 
-static int tua6100_set_params(struct dvb_frontend *fe,
-			      struct dvb_frontend_parameters *params)
+static int tua6100_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct tua6100_priv *priv = fe->tuner_priv;
diff --git a/drivers/media/dvb/frontends/ves1820.c b/drivers/media/dvb/frontends/ves1820.c
index 550a07a..270c7f9 100644
--- a/drivers/media/dvb/frontends/ves1820.c
+++ b/drivers/media/dvb/frontends/ves1820.c
@@ -219,7 +219,7 @@ static int ves1820_set_parameters(struct dvb_frontend* fe, struct dvb_frontend_p
 		return -EINVAL;
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
diff --git a/drivers/media/dvb/frontends/ves1x93.c b/drivers/media/dvb/frontends/ves1x93.c
index 8d7854c..5ffbf5e 100644
--- a/drivers/media/dvb/frontends/ves1x93.c
+++ b/drivers/media/dvb/frontends/ves1x93.c
@@ -389,7 +389,7 @@ static int ves1x93_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 	struct ves1x93_state* state = fe->demodulator_priv;
 
 	if (fe->ops.tuner_ops.set_params) {
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 	ves1x93_set_inversion (state, p->inversion);
diff --git a/drivers/media/dvb/frontends/zl10036.c b/drivers/media/dvb/frontends/zl10036.c
index 129d0f2..0903d46 100644
--- a/drivers/media/dvb/frontends/zl10036.c
+++ b/drivers/media/dvb/frontends/zl10036.c
@@ -305,8 +305,7 @@ static int zl10036_set_gain_params(struct zl10036_state *state,
 	return zl10036_write(state, buf, sizeof(buf));
 }
 
-static int zl10036_set_params(struct dvb_frontend *fe,
-		struct dvb_frontend_parameters *params)
+static int zl10036_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct zl10036_state *state = fe->tuner_priv;
diff --git a/drivers/media/dvb/frontends/zl10039.c b/drivers/media/dvb/frontends/zl10039.c
index 7fc8cef..eff9c5f 100644
--- a/drivers/media/dvb/frontends/zl10039.c
+++ b/drivers/media/dvb/frontends/zl10039.c
@@ -176,8 +176,7 @@ static int zl10039_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int zl10039_set_params(struct dvb_frontend *fe,
-			      struct dvb_frontend_parameters *params)
+static int zl10039_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct zl10039_state *state = fe->tuner_priv;
diff --git a/drivers/media/dvb/frontends/zl10353.c b/drivers/media/dvb/frontends/zl10353.c
index 9caccc0..0945aa0 100644
--- a/drivers/media/dvb/frontends/zl10353.c
+++ b/drivers/media/dvb/frontends/zl10353.c
@@ -362,7 +362,7 @@ static int zl10353_set_parameters(struct dvb_frontend *fe,
 	 */
 	if (state->config.no_tuner) {
 		if (fe->ops.tuner_ops.set_params) {
-			fe->ops.tuner_ops.set_params(fe, param);
+			fe->ops.tuner_ops.set_params(fe);
 			if (fe->ops.i2c_gate_ctrl)
 				fe->ops.i2c_gate_ctrl(fe, 0);
 		}
diff --git a/drivers/media/dvb/mantis/mantis_vp1033.c b/drivers/media/dvb/mantis/mantis_vp1033.c
index dfaca2a..ad013e9 100644
--- a/drivers/media/dvb/mantis/mantis_vp1033.c
+++ b/drivers/media/dvb/mantis/mantis_vp1033.c
@@ -83,8 +83,7 @@ u8 lgtdqcs001f_inittab[] = {
 #define MANTIS_MODEL_NAME	"VP-1033"
 #define MANTIS_DEV_TYPE		"DVB-S/DSS"
 
-int lgtdqcs001f_tuner_set(struct dvb_frontend *fe,
-			  struct dvb_frontend_parameters *params)
+int lgtdqcs001f_tuner_set(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct mantis_pci *mantis	= fe->dvb->priv;
diff --git a/drivers/media/dvb/mantis/mantis_vp2033.c b/drivers/media/dvb/mantis/mantis_vp2033.c
index f58ce60..1ca6837 100644
--- a/drivers/media/dvb/mantis/mantis_vp2033.c
+++ b/drivers/media/dvb/mantis/mantis_vp2033.c
@@ -65,7 +65,7 @@ static u8 read_pwm(struct mantis_pci *mantis)
 	return pwm;
 }
 
-static int tda1002x_cu1216_tuner_set(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int tda1002x_cu1216_tuner_set(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct mantis_pci *mantis = fe->dvb->priv;
diff --git a/drivers/media/dvb/mantis/mantis_vp2040.c b/drivers/media/dvb/mantis/mantis_vp2040.c
index beadfea..d480741 100644
--- a/drivers/media/dvb/mantis/mantis_vp2040.c
+++ b/drivers/media/dvb/mantis/mantis_vp2040.c
@@ -47,7 +47,7 @@ struct tda10023_config vp2040_tda10023_cu1216_config = {
 	.invert		= 1,
 };
 
-static int tda1002x_cu1216_tuner_set(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int tda1002x_cu1216_tuner_set(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct mantis_pci *mantis	= fe->dvb->priv;
diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
index 027da57..e1f20c2 100644
--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -445,8 +445,7 @@ static inline u32 divide(u32 numerator, u32 denominator)
 }
 
 /* LG Innotek TDTE-E001P (Infineon TUA6034) */
-static int lg_tdtpe001p_tuner_set_params(struct dvb_frontend *fe,
-					 struct dvb_frontend_parameters *foo)
+static int lg_tdtpe001p_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct pluto *pluto = frontend_to_pluto(fe);
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 37eb4ac..371fb29 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -1568,7 +1568,7 @@ static int get_firmware(struct av7110* av7110)
 	return ret;
 }
 
-static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
+static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
@@ -1605,7 +1605,7 @@ static struct ves1x93_config alps_bsrv2_config = {
 	.invert_pwm = 0,
 };
 
-static int alps_tdbe2_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
+static int alps_tdbe2_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
@@ -1637,7 +1637,7 @@ static struct ves1820_config alps_tdbe2_config = {
 
 
 
-static int grundig_29504_451_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
+static int grundig_29504_451_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
@@ -1664,7 +1664,7 @@ static struct tda8083_config grundig_29504_451_config = {
 
 
 
-static int philips_cd1516_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
+static int philips_cd1516_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
@@ -1696,7 +1696,7 @@ static struct ves1820_config philips_cd1516_config = {
 
 
 
-static int alps_tdlb7_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
+static int alps_tdlb7_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
@@ -1834,7 +1834,7 @@ static u8 nexusca_stv0297_inittab[] = {
 	0xff, 0xff,
 };
 
-static int nexusca_stv0297_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
+static int nexusca_stv0297_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
@@ -1890,7 +1890,7 @@ static struct stv0297_config nexusca_stv0297_config = {
 
 
 
-static int grundig_29504_401_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
+static int grundig_29504_401_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
diff --git a/drivers/media/dvb/ttpci/budget-av.c b/drivers/media/dvb/ttpci/budget-av.c
index ef03777..d6a083b 100644
--- a/drivers/media/dvb/ttpci/budget-av.c
+++ b/drivers/media/dvb/ttpci/budget-av.c
@@ -502,8 +502,7 @@ static int philips_su1278_ty_ci_set_symbol_rate(struct dvb_frontend *fe, u32 sra
 	return 0;
 }
 
-static int philips_su1278_ty_ci_tuner_set_params(struct dvb_frontend *fe,
-						 struct dvb_frontend_parameters *params)
+static int philips_su1278_ty_ci_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 div;
@@ -618,7 +617,7 @@ static struct stv0299_config cinergy_1200s_1894_0010_config = {
 	.set_symbol_rate = philips_su1278_ty_ci_set_symbol_rate,
 };
 
-static int philips_cu1216_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int philips_cu1216_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget *budget = (struct budget *) fe->dvb->priv;
@@ -699,7 +698,7 @@ static int philips_tu1216_tuner_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int philips_tu1216_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int philips_tu1216_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget *budget = (struct budget *) fe->dvb->priv;
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 9807968..9a2d3a0 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -660,8 +660,7 @@ static int philips_su1278_tt_set_symbol_rate(struct dvb_frontend *fe, u32 srate,
 	return 0;
 }
 
-static int philips_su1278_tt_tuner_set_params(struct dvb_frontend *fe,
-					   struct dvb_frontend_parameters *params)
+static int philips_su1278_tt_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct budget_ci *budget_ci = (struct budget_ci *) fe->dvb->priv;
@@ -742,7 +741,7 @@ static int philips_tdm1316l_tuner_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct budget_ci *budget_ci = (struct budget_ci *) fe->dvb->priv;
@@ -858,7 +857,7 @@ static struct tda1004x_config philips_tdm1316l_config_invert = {
 	.request_firmware = philips_tdm1316l_request_firmware,
 };
 
-static int dvbc_philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int dvbc_philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct budget_ci *budget_ci = (struct budget_ci *) fe->dvb->priv;
diff --git a/drivers/media/dvb/ttpci/budget-patch.c b/drivers/media/dvb/ttpci/budget-patch.c
index 1f14a7f..1dda7ed 100644
--- a/drivers/media/dvb/ttpci/budget-patch.c
+++ b/drivers/media/dvb/ttpci/budget-patch.c
@@ -261,7 +261,7 @@ static int budget_patch_diseqc_send_burst(struct dvb_frontend* fe, fe_sec_mini_c
 	return 0;
 }
 
-static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
+static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct budget_patch* budget = (struct budget_patch*) fe->dvb->priv;
@@ -298,7 +298,7 @@ static struct ves1x93_config alps_bsrv2_config = {
 	.invert_pwm = 0,
 };
 
-static int grundig_29504_451_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
+static int grundig_29504_451_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct budget_patch* budget = (struct budget_patch*) fe->dvb->priv;
diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c
index 719b965..10fcc02 100644
--- a/drivers/media/dvb/ttpci/budget.c
+++ b/drivers/media/dvb/ttpci/budget.c
@@ -200,7 +200,7 @@ static int budget_diseqc_send_burst(struct dvb_frontend* fe, fe_sec_mini_cmd_t m
 	return 0;
 }
 
-static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
+static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget* budget = (struct budget*) fe->dvb->priv;
@@ -237,7 +237,7 @@ static struct ves1x93_config alps_bsrv2_config =
 	.invert_pwm = 0,
 };
 
-static int alps_tdbe2_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
+static int alps_tdbe2_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget* budget = (struct budget*) fe->dvb->priv;
@@ -265,7 +265,7 @@ static struct ves1820_config alps_tdbe2_config = {
 	.selagc = VES1820_SELAGC_SIGNAMPERR,
 };
 
-static int grundig_29504_401_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
+static int grundig_29504_401_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget *budget = fe->dvb->priv;
@@ -315,7 +315,7 @@ static struct l64781_config grundig_29504_401_config_activy = {
 
 static u8 tuner_address_grundig_29504_401_activy = 0x60;
 
-static int grundig_29504_451_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
+static int grundig_29504_451_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget* budget = (struct budget*) fe->dvb->priv;
@@ -339,7 +339,7 @@ static struct tda8083_config grundig_29504_451_config = {
 	.demod_address = 0x68,
 };
 
-static int s5h1420_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
+static int s5h1420_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget* budget = (struct budget*) fe->dvb->priv;
diff --git a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
index 2379f38..514eff0 100644
--- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -1017,7 +1017,7 @@ static u32 functionality(struct i2c_adapter *adapter)
 
 
 
-static int alps_tdmb7_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
+static int alps_tdmb7_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb* ttusb = (struct ttusb*) fe->dvb->priv;
@@ -1072,7 +1072,7 @@ static int philips_tdm1316l_tuner_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int philips_tdm1316l_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
+static int philips_tdm1316l_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb* ttusb = (struct ttusb*) fe->dvb->priv;
@@ -1279,7 +1279,7 @@ static int alps_stv0299_set_symbol_rate(struct dvb_frontend *fe, u32 srate, u32
 	return 0;
 }
 
-static int philips_tsa5059_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int philips_tsa5059_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb* ttusb = (struct ttusb*) fe->dvb->priv;
@@ -1323,7 +1323,7 @@ static struct stv0299_config alps_stv0299_config = {
 	.set_symbol_rate = alps_stv0299_set_symbol_rate,
 };
 
-static int ttusb_novas_grundig_29504_491_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int ttusb_novas_grundig_29504_491_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb* ttusb = (struct ttusb*) fe->dvb->priv;
@@ -1351,7 +1351,7 @@ static struct tda8083_config ttusb_novas_grundig_29504_491_config = {
 	.demod_address = 0x68,
 };
 
-static int alps_tdbe2_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
+static int alps_tdbe2_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb* ttusb = fe->dvb->priv;
@@ -1396,7 +1396,7 @@ static u8 read_pwm(struct ttusb* ttusb)
 }
 
 
-static int dvbc_philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int dvbc_philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb *ttusb = (struct ttusb *) fe->dvb->priv;
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index 1311af0..91c02de 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -815,8 +815,7 @@ static const u8 samsung_smt_7020_inittab[] = {
 };
 
 
-static int samsung_smt_7020_tuner_set_params(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params)
+static int samsung_smt_7020_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct cx8802_dev *dev = fe->dvb->priv;
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index 5fdb845..2bfc866 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -183,8 +183,7 @@ static int mt352_avermedia_xc3028_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int mt352_pinnacle_tuner_set_params(struct dvb_frontend* fe,
-					   struct dvb_frontend_parameters* params)
+static int mt352_pinnacle_tuner_set_params(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u8 off[] = { 0x00, 0xf1};
@@ -288,7 +287,7 @@ static int philips_tda1004x_request_firmware(struct dvb_frontend *fe,
  * these tuners are tu1216, td1316(a)
  */
 
-static int philips_tda6651_pll_set(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int philips_tda6651_pll_set(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct saa7134_dev *dev = fe->dvb->priv;
@@ -438,9 +437,9 @@ static int philips_td1316_tuner_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int philips_td1316_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+static int philips_td1316_tuner_set_params(struct dvb_frontend *fe)
 {
-	return philips_tda6651_pll_set(fe, params);
+	return philips_tda6651_pll_set(fe);
 }
 
 static int philips_td1316_tuner_sleep(struct dvb_frontend *fe)
-- 
1.7.8.352.g876a6

