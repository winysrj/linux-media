Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39312 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933973AbcBDP6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 10:58:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Jemma Denson <jdenson@gmail.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>,
	Sergey Kozlov <serjk@netup.ru>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jiri Kosina <jkosina@suse.com>,
	"David S. Miller" <davem@davemloft.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Fred Richter <frichter@hauppauge.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Abhilash Jindal <klock.android@gmail.com>,
	Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH 6/7] [media] dvb_frontend: pass the props cache to get_frontend() as arg
Date: Thu,  4 Feb 2016 13:57:31 -0200
Message-Id: <2612145d4e46ee78d7e1c38386c43d9c3f597600.1454600641.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using the DTV properties cache directly, pass the get
frontend data as an argument. For now, everything should remain
the same, but the next patch will prevent get_frontend to
affect the global cache.

This is needed because several drivers don't care enough to only
change the properties if locked. Due to that, calling
G_PROPERTY before locking on those drivers will make them to
never lock. Ok, those drivers are crap and should never be
merged like that, but the core should not rely that the drivers
would be doing the right thing.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c         |  2 +-
 drivers/media/dvb-core/dvb_frontend.h         |  3 +-
 drivers/media/dvb-frontends/af9013.c          |  4 +-
 drivers/media/dvb-frontends/af9033.c          |  4 +-
 drivers/media/dvb-frontends/as102_fe.c        |  4 +-
 drivers/media/dvb-frontends/atbm8830.c        |  4 +-
 drivers/media/dvb-frontends/au8522_dig.c      |  4 +-
 drivers/media/dvb-frontends/cx22700.c         |  4 +-
 drivers/media/dvb-frontends/cx22702.c         |  4 +-
 drivers/media/dvb-frontends/cx24110.c         |  4 +-
 drivers/media/dvb-frontends/cx24117.c         |  4 +-
 drivers/media/dvb-frontends/cx24120.c         |  4 +-
 drivers/media/dvb-frontends/cx24123.c         |  4 +-
 drivers/media/dvb-frontends/cxd2820r_c.c      |  4 +-
 drivers/media/dvb-frontends/cxd2820r_core.c   |  9 ++--
 drivers/media/dvb-frontends/cxd2820r_priv.h   |  9 ++--
 drivers/media/dvb-frontends/cxd2820r_t.c      |  4 +-
 drivers/media/dvb-frontends/cxd2820r_t2.c     |  6 +--
 drivers/media/dvb-frontends/cxd2841er.c       |  4 +-
 drivers/media/dvb-frontends/dib3000mb.c       |  9 ++--
 drivers/media/dvb-frontends/dib3000mc.c       |  6 +--
 drivers/media/dvb-frontends/dib7000m.c        |  6 +--
 drivers/media/dvb-frontends/dib7000p.c        |  6 +--
 drivers/media/dvb-frontends/dib8000.c         | 75 ++++++++++++++-------------
 drivers/media/dvb-frontends/dib9000.c         | 23 ++++----
 drivers/media/dvb-frontends/dvb_dummy_fe.c    |  7 ++-
 drivers/media/dvb-frontends/hd29l2.c          |  4 +-
 drivers/media/dvb-frontends/l64781.c          |  4 +-
 drivers/media/dvb-frontends/lg2160.c          | 62 +++++++++++-----------
 drivers/media/dvb-frontends/lgdt3305.c        |  4 +-
 drivers/media/dvb-frontends/lgdt3306a.c       |  4 +-
 drivers/media/dvb-frontends/lgdt330x.c        |  5 +-
 drivers/media/dvb-frontends/lgs8gl5.c         |  5 +-
 drivers/media/dvb-frontends/m88ds3103.c       |  4 +-
 drivers/media/dvb-frontends/m88rs2000.c       |  5 +-
 drivers/media/dvb-frontends/mt312.c           |  4 +-
 drivers/media/dvb-frontends/mt352.c           |  4 +-
 drivers/media/dvb-frontends/or51132.c         |  4 +-
 drivers/media/dvb-frontends/rtl2830.c         |  4 +-
 drivers/media/dvb-frontends/rtl2832.c         |  4 +-
 drivers/media/dvb-frontends/s5h1409.c         |  4 +-
 drivers/media/dvb-frontends/s5h1411.c         |  4 +-
 drivers/media/dvb-frontends/s5h1420.c         |  4 +-
 drivers/media/dvb-frontends/s921.c            |  4 +-
 drivers/media/dvb-frontends/stb0899_drv.c     |  4 +-
 drivers/media/dvb-frontends/stb6100.c         |  2 +-
 drivers/media/dvb-frontends/stv0297.c         |  4 +-
 drivers/media/dvb-frontends/stv0299.c         |  4 +-
 drivers/media/dvb-frontends/stv0367.c         |  8 +--
 drivers/media/dvb-frontends/stv0900_core.c    |  4 +-
 drivers/media/dvb-frontends/tc90522.c         | 10 ++--
 drivers/media/dvb-frontends/tda10021.c        |  4 +-
 drivers/media/dvb-frontends/tda10023.c        |  4 +-
 drivers/media/dvb-frontends/tda10048.c        |  4 +-
 drivers/media/dvb-frontends/tda1004x.c        |  4 +-
 drivers/media/dvb-frontends/tda10071.c        |  4 +-
 drivers/media/dvb-frontends/tda10086.c        |  4 +-
 drivers/media/dvb-frontends/tda8083.c         |  4 +-
 drivers/media/dvb-frontends/ves1820.c         |  4 +-
 drivers/media/dvb-frontends/ves1x93.c         |  4 +-
 drivers/media/dvb-frontends/zl10353.c         |  4 +-
 drivers/media/pci/bt8xx/dst.c                 |  4 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c |  4 +-
 drivers/media/usb/dvb-usb/af9005-fe.c         |  4 +-
 drivers/media/usb/dvb-usb/dtt200u-fe.c        |  5 +-
 65 files changed, 230 insertions(+), 213 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index ca6d60f9d492..d009478f16c4 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1361,7 +1361,7 @@ static int dtv_get_frontend(struct dvb_frontend *fe,
 	int r;
 
 	if (fe->ops.get_frontend) {
-		r = fe->ops.get_frontend(fe);
+		r = fe->ops.get_frontend(fe, c);
 		if (unlikely(r < 0))
 			return r;
 		if (p_out)
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 458bcce20e38..9592573a0b41 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -449,7 +449,8 @@ struct dvb_frontend_ops {
 	int (*set_frontend)(struct dvb_frontend *fe);
 	int (*get_tune_settings)(struct dvb_frontend* fe, struct dvb_frontend_tune_settings* settings);
 
-	int (*get_frontend)(struct dvb_frontend *fe);
+	int (*get_frontend)(struct dvb_frontend *fe,
+			    struct dtv_frontend_properties *props);
 
 	int (*read_status)(struct dvb_frontend *fe, enum fe_status *status);
 	int (*read_ber)(struct dvb_frontend* fe, u32* ber);
diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 41ab5defb798..8bcde336ffd7 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -866,9 +866,9 @@ err:
 	return ret;
 }
 
-static int af9013_get_frontend(struct dvb_frontend *fe)
+static int af9013_get_frontend(struct dvb_frontend *fe,
+			       struct dtv_frontend_properties *c)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct af9013_state *state = fe->demodulator_priv;
 	int ret;
 	u8 buf[3];
diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 8b328d1ca8d3..efebe5ce2429 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -691,10 +691,10 @@ err:
 	return ret;
 }
 
-static int af9033_get_frontend(struct dvb_frontend *fe)
+static int af9033_get_frontend(struct dvb_frontend *fe,
+			       struct dtv_frontend_properties *c)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[8];
 
diff --git a/drivers/media/dvb-frontends/as102_fe.c b/drivers/media/dvb-frontends/as102_fe.c
index 544c5f65d19a..9412fcd1bddb 100644
--- a/drivers/media/dvb-frontends/as102_fe.c
+++ b/drivers/media/dvb-frontends/as102_fe.c
@@ -190,10 +190,10 @@ static int as102_fe_set_frontend(struct dvb_frontend *fe)
 	return state->ops->set_tune(state->priv, &tune_args);
 }
 
-static int as102_fe_get_frontend(struct dvb_frontend *fe)
+static int as102_fe_get_frontend(struct dvb_frontend *fe,
+				 struct dtv_frontend_properties *c)
 {
 	struct as102_state *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret = 0;
 	struct as10x_tps tps = { 0 };
 
diff --git a/drivers/media/dvb-frontends/atbm8830.c b/drivers/media/dvb-frontends/atbm8830.c
index 8fe552e293ed..47248b868e38 100644
--- a/drivers/media/dvb-frontends/atbm8830.c
+++ b/drivers/media/dvb-frontends/atbm8830.c
@@ -297,9 +297,9 @@ static int atbm8830_set_fe(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int atbm8830_get_fe(struct dvb_frontend *fe)
+static int atbm8830_get_fe(struct dvb_frontend *fe,
+			   struct dtv_frontend_properties *c)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	dprintk("%s\n", __func__);
 
 	/* TODO: get real readings from device */
diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
index 6c1e97640f3f..e676b9461a59 100644
--- a/drivers/media/dvb-frontends/au8522_dig.c
+++ b/drivers/media/dvb-frontends/au8522_dig.c
@@ -816,9 +816,9 @@ static int au8522_read_ber(struct dvb_frontend *fe, u32 *ber)
 	return au8522_read_ucblocks(fe, ber);
 }
 
-static int au8522_get_frontend(struct dvb_frontend *fe)
+static int au8522_get_frontend(struct dvb_frontend *fe,
+			       struct dtv_frontend_properties *c)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct au8522_state *state = fe->demodulator_priv;
 
 	c->frequency = state->current_frequency;
diff --git a/drivers/media/dvb-frontends/cx22700.c b/drivers/media/dvb-frontends/cx22700.c
index fd033cca6e11..5cad925609e0 100644
--- a/drivers/media/dvb-frontends/cx22700.c
+++ b/drivers/media/dvb-frontends/cx22700.c
@@ -345,9 +345,9 @@ static int cx22700_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int cx22700_get_frontend(struct dvb_frontend *fe)
+static int cx22700_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *c)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct cx22700_state* state = fe->demodulator_priv;
 	u8 reg09 = cx22700_readreg (state, 0x09);
 
diff --git a/drivers/media/dvb-frontends/cx22702.c b/drivers/media/dvb-frontends/cx22702.c
index d2d06dcd7683..c0e54c59cccf 100644
--- a/drivers/media/dvb-frontends/cx22702.c
+++ b/drivers/media/dvb-frontends/cx22702.c
@@ -562,9 +562,9 @@ static int cx22702_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	return 0;
 }
 
-static int cx22702_get_frontend(struct dvb_frontend *fe)
+static int cx22702_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *c)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct cx22702_state *state = fe->demodulator_priv;
 
 	u8 reg0C = cx22702_readreg(state, 0x0C);
diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
index cb36475e322b..6cb81ec12847 100644
--- a/drivers/media/dvb-frontends/cx24110.c
+++ b/drivers/media/dvb-frontends/cx24110.c
@@ -550,9 +550,9 @@ static int cx24110_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int cx24110_get_frontend(struct dvb_frontend *fe)
+static int cx24110_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cx24110_state *state = fe->demodulator_priv;
 	s32 afc; unsigned sclk;
 
diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index 5f77bc80a896..a3f7eb4e609d 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -1560,10 +1560,10 @@ static int cx24117_get_algo(struct dvb_frontend *fe)
 	return DVBFE_ALGO_HW;
 }
 
-static int cx24117_get_frontend(struct dvb_frontend *fe)
+static int cx24117_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *c)
 {
 	struct cx24117_state *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct cx24117_cmd cmd;
 	u8 reg, st, inv;
 	int ret, idx;
diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index 3b0ef52bb834..6ccbd86c9490 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -1502,9 +1502,9 @@ static int cx24120_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int cx24120_get_frontend(struct dvb_frontend *fe)
+static int cx24120_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *c)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct cx24120_state *state = fe->demodulator_priv;
 	u8 freq1, freq2, freq3;
 
diff --git a/drivers/media/dvb-frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
index 0fe7fb11124b..113b0949408a 100644
--- a/drivers/media/dvb-frontends/cx24123.c
+++ b/drivers/media/dvb-frontends/cx24123.c
@@ -945,9 +945,9 @@ static int cx24123_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int cx24123_get_frontend(struct dvb_frontend *fe)
+static int cx24123_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cx24123_state *state = fe->demodulator_priv;
 
 	dprintk("\n");
diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c b/drivers/media/dvb-frontends/cxd2820r_c.c
index 42fad6aa3958..a674a6312c38 100644
--- a/drivers/media/dvb-frontends/cxd2820r_c.c
+++ b/drivers/media/dvb-frontends/cxd2820r_c.c
@@ -101,10 +101,10 @@ error:
 	return ret;
 }
 
-int cxd2820r_get_frontend_c(struct dvb_frontend *fe)
+int cxd2820r_get_frontend_c(struct dvb_frontend *fe,
+			    struct dtv_frontend_properties *c)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[2];
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index ba4cb7557aa5..314d3b8c1080 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -313,7 +313,8 @@ static int cxd2820r_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	return ret;
 }
 
-static int cxd2820r_get_frontend(struct dvb_frontend *fe)
+static int cxd2820r_get_frontend(struct dvb_frontend *fe,
+				 struct dtv_frontend_properties *p)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret;
@@ -326,13 +327,13 @@ static int cxd2820r_get_frontend(struct dvb_frontend *fe)
 
 	switch (fe->dtv_property_cache.delivery_system) {
 	case SYS_DVBT:
-		ret = cxd2820r_get_frontend_t(fe);
+		ret = cxd2820r_get_frontend_t(fe, p);
 		break;
 	case SYS_DVBT2:
-		ret = cxd2820r_get_frontend_t2(fe);
+		ret = cxd2820r_get_frontend_t2(fe, p);
 		break;
 	case SYS_DVBC_ANNEX_A:
-		ret = cxd2820r_get_frontend_c(fe);
+		ret = cxd2820r_get_frontend_c(fe, p);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/media/dvb-frontends/cxd2820r_priv.h b/drivers/media/dvb-frontends/cxd2820r_priv.h
index a0d53f01a8bf..e31c48e53097 100644
--- a/drivers/media/dvb-frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb-frontends/cxd2820r_priv.h
@@ -76,7 +76,8 @@ int cxd2820r_rd_reg(struct cxd2820r_priv *priv, u32 reg, u8 *val);
 
 /* cxd2820r_c.c */
 
-int cxd2820r_get_frontend_c(struct dvb_frontend *fe);
+int cxd2820r_get_frontend_c(struct dvb_frontend *fe,
+			    struct dtv_frontend_properties *p);
 
 int cxd2820r_set_frontend_c(struct dvb_frontend *fe);
 
@@ -99,7 +100,8 @@ int cxd2820r_get_tune_settings_c(struct dvb_frontend *fe,
 
 /* cxd2820r_t.c */
 
-int cxd2820r_get_frontend_t(struct dvb_frontend *fe);
+int cxd2820r_get_frontend_t(struct dvb_frontend *fe,
+			    struct dtv_frontend_properties *p);
 
 int cxd2820r_set_frontend_t(struct dvb_frontend *fe);
 
@@ -122,7 +124,8 @@ int cxd2820r_get_tune_settings_t(struct dvb_frontend *fe,
 
 /* cxd2820r_t2.c */
 
-int cxd2820r_get_frontend_t2(struct dvb_frontend *fe);
+int cxd2820r_get_frontend_t2(struct dvb_frontend *fe,
+			     struct dtv_frontend_properties *p);
 
 int cxd2820r_set_frontend_t2(struct dvb_frontend *fe);
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_t.c b/drivers/media/dvb-frontends/cxd2820r_t.c
index 21abf1b4ed4d..75ce7d8ded00 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t.c
@@ -138,10 +138,10 @@ error:
 	return ret;
 }
 
-int cxd2820r_get_frontend_t(struct dvb_frontend *fe)
+int cxd2820r_get_frontend_t(struct dvb_frontend *fe,
+			    struct dtv_frontend_properties *c)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[2];
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
index 4e028b41c0d5..704475676234 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t2.c
@@ -23,8 +23,8 @@
 
 int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 {
-	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret, i, bw_i;
 	u32 if_freq, if_ctl;
 	u64 num;
@@ -169,10 +169,10 @@ error:
 
 }
 
-int cxd2820r_get_frontend_t2(struct dvb_frontend *fe)
+int cxd2820r_get_frontend_t2(struct dvb_frontend *fe,
+			     struct dtv_frontend_properties *c)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[2];
 
diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index fdffb2f0ded8..900186ba8e62 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -2090,13 +2090,13 @@ static int cxd2841er_sleep_tc_to_active_c(struct cxd2841er_priv *priv,
 	return 0;
 }
 
-static int cxd2841er_get_frontend(struct dvb_frontend *fe)
+static int cxd2841er_get_frontend(struct dvb_frontend *fe,
+				  struct dtv_frontend_properties *p)
 {
 	enum fe_status status = 0;
 	u16 strength = 0, snr = 0;
 	u32 errors = 0, ber = 0;
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	if (priv->state == STATE_ACTIVE_S)
diff --git a/drivers/media/dvb-frontends/dib3000mb.c b/drivers/media/dvb-frontends/dib3000mb.c
index 3ca300939f79..6821ecb53d63 100644
--- a/drivers/media/dvb-frontends/dib3000mb.c
+++ b/drivers/media/dvb-frontends/dib3000mb.c
@@ -112,7 +112,8 @@ static u16 dib3000_seq[2][2][2] =     /* fft,gua,   inv   */
 		}
 	};
 
-static int dib3000mb_get_frontend(struct dvb_frontend* fe);
+static int dib3000mb_get_frontend(struct dvb_frontend* fe,
+				  struct dtv_frontend_properties *c);
 
 static int dib3000mb_set_frontend(struct dvb_frontend *fe, int tuner)
 {
@@ -359,7 +360,7 @@ static int dib3000mb_set_frontend(struct dvb_frontend *fe, int tuner)
 		deb_setf("search_state after autosearch %d after %d checks\n",search_state,as_count);
 
 		if (search_state == 1) {
-			if (dib3000mb_get_frontend(fe) == 0) {
+			if (dib3000mb_get_frontend(fe, c) == 0) {
 				deb_setf("reading tuning data from frontend succeeded.\n");
 				return dib3000mb_set_frontend(fe, 0);
 			}
@@ -450,9 +451,9 @@ static int dib3000mb_fe_init(struct dvb_frontend* fe, int mobile_mode)
 	return 0;
 }
 
-static int dib3000mb_get_frontend(struct dvb_frontend* fe)
+static int dib3000mb_get_frontend(struct dvb_frontend* fe,
+				  struct dtv_frontend_properties *c)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dib3000_state* state = fe->demodulator_priv;
 	enum fe_code_rate *cr;
 	u16 tps_val;
diff --git a/drivers/media/dvb-frontends/dib3000mc.c b/drivers/media/dvb-frontends/dib3000mc.c
index ac90ed3af37e..da0f1dc5aaf7 100644
--- a/drivers/media/dvb-frontends/dib3000mc.c
+++ b/drivers/media/dvb-frontends/dib3000mc.c
@@ -636,9 +636,9 @@ struct i2c_adapter * dib3000mc_get_tuner_i2c_master(struct dvb_frontend *demod,
 
 EXPORT_SYMBOL(dib3000mc_get_tuner_i2c_master);
 
-static int dib3000mc_get_frontend(struct dvb_frontend* fe)
+static int dib3000mc_get_frontend(struct dvb_frontend* fe,
+				  struct dtv_frontend_properties *fep)
 {
-	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct dib3000mc_state *state = fe->demodulator_priv;
 	u16 tps = dib3000mc_read_word(state,458);
 
@@ -726,7 +726,7 @@ static int dib3000mc_set_frontend(struct dvb_frontend *fe)
 		if (found == 0 || found == 1)
 			return 0; // no channel found
 
-		dib3000mc_get_frontend(fe);
+		dib3000mc_get_frontend(fe, fep);
 	}
 
 	ret = dib3000mc_tune(fe);
diff --git a/drivers/media/dvb-frontends/dib7000m.c b/drivers/media/dvb-frontends/dib7000m.c
index 8b21cccf3c3a..b3ddae8885ac 100644
--- a/drivers/media/dvb-frontends/dib7000m.c
+++ b/drivers/media/dvb-frontends/dib7000m.c
@@ -1151,9 +1151,9 @@ static int dib7000m_identify(struct dib7000m_state *state)
 }
 
 
-static int dib7000m_get_frontend(struct dvb_frontend* fe)
+static int dib7000m_get_frontend(struct dvb_frontend* fe,
+				 struct dtv_frontend_properties *fep)
 {
-	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct dib7000m_state *state = fe->demodulator_priv;
 	u16 tps = dib7000m_read_word(state,480);
 
@@ -1246,7 +1246,7 @@ static int dib7000m_set_frontend(struct dvb_frontend *fe)
 		if (found == 0 || found == 1)
 			return 0; // no channel found
 
-		dib7000m_get_frontend(fe);
+		dib7000m_get_frontend(fe, fep);
 	}
 
 	ret = dib7000m_tune(fe);
diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 65ab79ed5e3e..b861d4437f2a 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -1405,9 +1405,9 @@ static int dib7000p_identify(struct dib7000p_state *st)
 	return 0;
 }
 
-static int dib7000p_get_frontend(struct dvb_frontend *fe)
+static int dib7000p_get_frontend(struct dvb_frontend *fe,
+				 struct dtv_frontend_properties *fep)
 {
-	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct dib7000p_state *state = fe->demodulator_priv;
 	u16 tps = dib7000p_read_word(state, 463);
 
@@ -1540,7 +1540,7 @@ static int dib7000p_set_frontend(struct dvb_frontend *fe)
 		if (found == 0 || found == 1)
 			return 0;
 
-		dib7000p_get_frontend(fe);
+		dib7000p_get_frontend(fe, fep);
 	}
 
 	ret = dib7000p_tune(fe);
diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 349d2f1f62ce..ddf9c44877a2 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -3382,14 +3382,15 @@ static int dib8000_sleep(struct dvb_frontend *fe)
 
 static int dib8000_read_status(struct dvb_frontend *fe, enum fe_status *stat);
 
-static int dib8000_get_frontend(struct dvb_frontend *fe)
+static int dib8000_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *c)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	u16 i, val = 0;
 	enum fe_status stat = 0;
 	u8 index_frontend, sub_index_frontend;
 
-	fe->dtv_property_cache.bandwidth_hz = 6000000;
+	c->bandwidth_hz = 6000000;
 
 	/*
 	 * If called to early, get_frontend makes dib8000_tune to either
@@ -3406,7 +3407,7 @@ static int dib8000_get_frontend(struct dvb_frontend *fe)
 		if (stat&FE_HAS_SYNC) {
 			dprintk("TMCC lock on the slave%i", index_frontend);
 			/* synchronize the cache with the other frontends */
-			state->fe[index_frontend]->ops.get_frontend(state->fe[index_frontend]);
+			state->fe[index_frontend]->ops.get_frontend(state->fe[index_frontend], c);
 			for (sub_index_frontend = 0; (sub_index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[sub_index_frontend] != NULL); sub_index_frontend++) {
 				if (sub_index_frontend != index_frontend) {
 					state->fe[sub_index_frontend]->dtv_property_cache.isdbt_sb_mode = state->fe[index_frontend]->dtv_property_cache.isdbt_sb_mode;
@@ -3426,57 +3427,57 @@ static int dib8000_get_frontend(struct dvb_frontend *fe)
 		}
 	}
 
-	fe->dtv_property_cache.isdbt_sb_mode = dib8000_read_word(state, 508) & 0x1;
+	c->isdbt_sb_mode = dib8000_read_word(state, 508) & 0x1;
 
 	if (state->revision == 0x8090)
 		val = dib8000_read_word(state, 572);
 	else
 		val = dib8000_read_word(state, 570);
-	fe->dtv_property_cache.inversion = (val & 0x40) >> 6;
+	c->inversion = (val & 0x40) >> 6;
 	switch ((val & 0x30) >> 4) {
 	case 1:
-		fe->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_2K;
+		c->transmission_mode = TRANSMISSION_MODE_2K;
 		dprintk("dib8000_get_frontend: transmission mode 2K");
 		break;
 	case 2:
-		fe->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_4K;
+		c->transmission_mode = TRANSMISSION_MODE_4K;
 		dprintk("dib8000_get_frontend: transmission mode 4K");
 		break;
 	case 3:
 	default:
-		fe->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_8K;
+		c->transmission_mode = TRANSMISSION_MODE_8K;
 		dprintk("dib8000_get_frontend: transmission mode 8K");
 		break;
 	}
 
 	switch (val & 0x3) {
 	case 0:
-		fe->dtv_property_cache.guard_interval = GUARD_INTERVAL_1_32;
+		c->guard_interval = GUARD_INTERVAL_1_32;
 		dprintk("dib8000_get_frontend: Guard Interval = 1/32 ");
 		break;
 	case 1:
-		fe->dtv_property_cache.guard_interval = GUARD_INTERVAL_1_16;
+		c->guard_interval = GUARD_INTERVAL_1_16;
 		dprintk("dib8000_get_frontend: Guard Interval = 1/16 ");
 		break;
 	case 2:
 		dprintk("dib8000_get_frontend: Guard Interval = 1/8 ");
-		fe->dtv_property_cache.guard_interval = GUARD_INTERVAL_1_8;
+		c->guard_interval = GUARD_INTERVAL_1_8;
 		break;
 	case 3:
 		dprintk("dib8000_get_frontend: Guard Interval = 1/4 ");
-		fe->dtv_property_cache.guard_interval = GUARD_INTERVAL_1_4;
+		c->guard_interval = GUARD_INTERVAL_1_4;
 		break;
 	}
 
 	val = dib8000_read_word(state, 505);
-	fe->dtv_property_cache.isdbt_partial_reception = val & 1;
-	dprintk("dib8000_get_frontend: partial_reception = %d ", fe->dtv_property_cache.isdbt_partial_reception);
+	c->isdbt_partial_reception = val & 1;
+	dprintk("dib8000_get_frontend: partial_reception = %d ", c->isdbt_partial_reception);
 
 	for (i = 0; i < 3; i++) {
 		int show;
 
 		val = dib8000_read_word(state, 493 + i) & 0x0f;
-		fe->dtv_property_cache.layer[i].segment_count = val;
+		c->layer[i].segment_count = val;
 
 		if (val == 0 || val > 13)
 			show = 0;
@@ -3485,41 +3486,41 @@ static int dib8000_get_frontend(struct dvb_frontend *fe)
 
 		if (show)
 			dprintk("dib8000_get_frontend: Layer %d segments = %d ",
-				i, fe->dtv_property_cache.layer[i].segment_count);
+				i, c->layer[i].segment_count);
 
 		val = dib8000_read_word(state, 499 + i) & 0x3;
 		/* Interleaving can be 0, 1, 2 or 4 */
 		if (val == 3)
 			val = 4;
-		fe->dtv_property_cache.layer[i].interleaving = val;
+		c->layer[i].interleaving = val;
 		if (show)
 			dprintk("dib8000_get_frontend: Layer %d time_intlv = %d ",
-				i, fe->dtv_property_cache.layer[i].interleaving);
+				i, c->layer[i].interleaving);
 
 		val = dib8000_read_word(state, 481 + i);
 		switch (val & 0x7) {
 		case 1:
-			fe->dtv_property_cache.layer[i].fec = FEC_1_2;
+			c->layer[i].fec = FEC_1_2;
 			if (show)
 				dprintk("dib8000_get_frontend: Layer %d Code Rate = 1/2 ", i);
 			break;
 		case 2:
-			fe->dtv_property_cache.layer[i].fec = FEC_2_3;
+			c->layer[i].fec = FEC_2_3;
 			if (show)
 				dprintk("dib8000_get_frontend: Layer %d Code Rate = 2/3 ", i);
 			break;
 		case 3:
-			fe->dtv_property_cache.layer[i].fec = FEC_3_4;
+			c->layer[i].fec = FEC_3_4;
 			if (show)
 				dprintk("dib8000_get_frontend: Layer %d Code Rate = 3/4 ", i);
 			break;
 		case 5:
-			fe->dtv_property_cache.layer[i].fec = FEC_5_6;
+			c->layer[i].fec = FEC_5_6;
 			if (show)
 				dprintk("dib8000_get_frontend: Layer %d Code Rate = 5/6 ", i);
 			break;
 		default:
-			fe->dtv_property_cache.layer[i].fec = FEC_7_8;
+			c->layer[i].fec = FEC_7_8;
 			if (show)
 				dprintk("dib8000_get_frontend: Layer %d Code Rate = 7/8 ", i);
 			break;
@@ -3528,23 +3529,23 @@ static int dib8000_get_frontend(struct dvb_frontend *fe)
 		val = dib8000_read_word(state, 487 + i);
 		switch (val & 0x3) {
 		case 0:
-			fe->dtv_property_cache.layer[i].modulation = DQPSK;
+			c->layer[i].modulation = DQPSK;
 			if (show)
 				dprintk("dib8000_get_frontend: Layer %d DQPSK ", i);
 			break;
 		case 1:
-			fe->dtv_property_cache.layer[i].modulation = QPSK;
+			c->layer[i].modulation = QPSK;
 			if (show)
 				dprintk("dib8000_get_frontend: Layer %d QPSK ", i);
 			break;
 		case 2:
-			fe->dtv_property_cache.layer[i].modulation = QAM_16;
+			c->layer[i].modulation = QAM_16;
 			if (show)
 				dprintk("dib8000_get_frontend: Layer %d QAM16 ", i);
 			break;
 		case 3:
 		default:
-			fe->dtv_property_cache.layer[i].modulation = QAM_64;
+			c->layer[i].modulation = QAM_64;
 			if (show)
 				dprintk("dib8000_get_frontend: Layer %d QAM64 ", i);
 			break;
@@ -3553,16 +3554,16 @@ static int dib8000_get_frontend(struct dvb_frontend *fe)
 
 	/* synchronize the cache with the other frontends */
 	for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
-		state->fe[index_frontend]->dtv_property_cache.isdbt_sb_mode = fe->dtv_property_cache.isdbt_sb_mode;
-		state->fe[index_frontend]->dtv_property_cache.inversion = fe->dtv_property_cache.inversion;
-		state->fe[index_frontend]->dtv_property_cache.transmission_mode = fe->dtv_property_cache.transmission_mode;
-		state->fe[index_frontend]->dtv_property_cache.guard_interval = fe->dtv_property_cache.guard_interval;
-		state->fe[index_frontend]->dtv_property_cache.isdbt_partial_reception = fe->dtv_property_cache.isdbt_partial_reception;
+		state->fe[index_frontend]->dtv_property_cache.isdbt_sb_mode = c->isdbt_sb_mode;
+		state->fe[index_frontend]->dtv_property_cache.inversion = c->inversion;
+		state->fe[index_frontend]->dtv_property_cache.transmission_mode = c->transmission_mode;
+		state->fe[index_frontend]->dtv_property_cache.guard_interval = c->guard_interval;
+		state->fe[index_frontend]->dtv_property_cache.isdbt_partial_reception = c->isdbt_partial_reception;
 		for (i = 0; i < 3; i++) {
-			state->fe[index_frontend]->dtv_property_cache.layer[i].segment_count = fe->dtv_property_cache.layer[i].segment_count;
-			state->fe[index_frontend]->dtv_property_cache.layer[i].interleaving = fe->dtv_property_cache.layer[i].interleaving;
-			state->fe[index_frontend]->dtv_property_cache.layer[i].fec = fe->dtv_property_cache.layer[i].fec;
-			state->fe[index_frontend]->dtv_property_cache.layer[i].modulation = fe->dtv_property_cache.layer[i].modulation;
+			state->fe[index_frontend]->dtv_property_cache.layer[i].segment_count = c->layer[i].segment_count;
+			state->fe[index_frontend]->dtv_property_cache.layer[i].interleaving = c->layer[i].interleaving;
+			state->fe[index_frontend]->dtv_property_cache.layer[i].fec = c->layer[i].fec;
+			state->fe[index_frontend]->dtv_property_cache.layer[i].modulation = c->layer[i].modulation;
 		}
 	}
 	return 0;
@@ -3671,7 +3672,7 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 			if (state->channel_parameters_set == 0) { /* searching */
 				if ((dib8000_get_status(state->fe[index_frontend]) == FE_STATUS_DEMOD_SUCCESS) || (dib8000_get_status(state->fe[index_frontend]) == FE_STATUS_FFT_SUCCESS)) {
 					dprintk("autosearch succeeded on fe%i", index_frontend);
-					dib8000_get_frontend(state->fe[index_frontend]); /* we read the channel parameters from the frontend which was successful */
+					dib8000_get_frontend(state->fe[index_frontend], c); /* we read the channel parameters from the frontend which was successful */
 					state->channel_parameters_set = 1;
 
 					for (l = 0; (l < MAX_NUMBER_OF_FRONTENDS) && (state->fe[l] != NULL); l++) {
diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
index 91888a2f5301..bab8c5a980a2 100644
--- a/drivers/media/dvb-frontends/dib9000.c
+++ b/drivers/media/dvb-frontends/dib9000.c
@@ -1889,7 +1889,8 @@ static int dib9000_fe_get_tune_settings(struct dvb_frontend *fe, struct dvb_fron
 	return 0;
 }
 
-static int dib9000_get_frontend(struct dvb_frontend *fe)
+static int dib9000_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *c)
 {
 	struct dib9000_state *state = fe->demodulator_priv;
 	u8 index_frontend, sub_index_frontend;
@@ -1909,7 +1910,7 @@ static int dib9000_get_frontend(struct dvb_frontend *fe)
 			dprintk("TPS lock on the slave%i", index_frontend);
 
 			/* synchronize the cache with the other frontends */
-			state->fe[index_frontend]->ops.get_frontend(state->fe[index_frontend]);
+			state->fe[index_frontend]->ops.get_frontend(state->fe[index_frontend], c);
 			for (sub_index_frontend = 0; (sub_index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[sub_index_frontend] != NULL);
 			     sub_index_frontend++) {
 				if (sub_index_frontend != index_frontend) {
@@ -1943,14 +1944,14 @@ static int dib9000_get_frontend(struct dvb_frontend *fe)
 
 	/* synchronize the cache with the other frontends */
 	for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
-		state->fe[index_frontend]->dtv_property_cache.inversion = fe->dtv_property_cache.inversion;
-		state->fe[index_frontend]->dtv_property_cache.transmission_mode = fe->dtv_property_cache.transmission_mode;
-		state->fe[index_frontend]->dtv_property_cache.guard_interval = fe->dtv_property_cache.guard_interval;
-		state->fe[index_frontend]->dtv_property_cache.modulation = fe->dtv_property_cache.modulation;
-		state->fe[index_frontend]->dtv_property_cache.hierarchy = fe->dtv_property_cache.hierarchy;
-		state->fe[index_frontend]->dtv_property_cache.code_rate_HP = fe->dtv_property_cache.code_rate_HP;
-		state->fe[index_frontend]->dtv_property_cache.code_rate_LP = fe->dtv_property_cache.code_rate_LP;
-		state->fe[index_frontend]->dtv_property_cache.rolloff = fe->dtv_property_cache.rolloff;
+		state->fe[index_frontend]->dtv_property_cache.inversion = c->inversion;
+		state->fe[index_frontend]->dtv_property_cache.transmission_mode = c->transmission_mode;
+		state->fe[index_frontend]->dtv_property_cache.guard_interval = c->guard_interval;
+		state->fe[index_frontend]->dtv_property_cache.modulation = c->modulation;
+		state->fe[index_frontend]->dtv_property_cache.hierarchy = c->hierarchy;
+		state->fe[index_frontend]->dtv_property_cache.code_rate_HP = c->code_rate_HP;
+		state->fe[index_frontend]->dtv_property_cache.code_rate_LP = c->code_rate_LP;
+		state->fe[index_frontend]->dtv_property_cache.rolloff = c->rolloff;
 	}
 	ret = 0;
 
@@ -2083,7 +2084,7 @@ static int dib9000_set_frontend(struct dvb_frontend *fe)
 
 	/* synchronize all the channel cache */
 	state->get_frontend_internal = 1;
-	dib9000_get_frontend(state->fe[0]);
+	dib9000_get_frontend(state->fe[0], &state->fe[0]->dtv_property_cache);
 	state->get_frontend_internal = 0;
 
 	/* retune the other frontends with the found channel */
diff --git a/drivers/media/dvb-frontends/dvb_dummy_fe.c b/drivers/media/dvb-frontends/dvb_dummy_fe.c
index 14e996d45fac..e5bd8c62ad3a 100644
--- a/drivers/media/dvb-frontends/dvb_dummy_fe.c
+++ b/drivers/media/dvb-frontends/dvb_dummy_fe.c
@@ -70,9 +70,12 @@ static int dvb_dummy_fe_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 }
 
 /*
- * Only needed if it actually reads something from the hardware
+ * Should only be implemented if it actually reads something from the hardware.
+ * Also, it should check for the locks, in order to avoid report wrong data
+ * to userspace.
  */
-static int dvb_dummy_fe_get_frontend(struct dvb_frontend *fe)
+static int dvb_dummy_fe_get_frontend(struct dvb_frontend *fe,
+				     struct dtv_frontend_properties *p)
 {
 	return 0;
 }
diff --git a/drivers/media/dvb-frontends/hd29l2.c b/drivers/media/dvb-frontends/hd29l2.c
index 40e359f2d17d..1c7eb477e2cd 100644
--- a/drivers/media/dvb-frontends/hd29l2.c
+++ b/drivers/media/dvb-frontends/hd29l2.c
@@ -560,11 +560,11 @@ static int hd29l2_get_frontend_algo(struct dvb_frontend *fe)
 	return DVBFE_ALGO_CUSTOM;
 }
 
-static int hd29l2_get_frontend(struct dvb_frontend *fe)
+static int hd29l2_get_frontend(struct dvb_frontend *fe,
+			       struct dtv_frontend_properties *c)
 {
 	int ret;
 	struct hd29l2_priv *priv = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u8 buf[3];
 	u32 if_ctl;
 	char *str_constellation, *str_code_rate, *str_constellation_code_rate,
diff --git a/drivers/media/dvb-frontends/l64781.c b/drivers/media/dvb-frontends/l64781.c
index 0977871232a2..2f3d0519e19b 100644
--- a/drivers/media/dvb-frontends/l64781.c
+++ b/drivers/media/dvb-frontends/l64781.c
@@ -243,9 +243,9 @@ static int apply_frontend_param(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int get_frontend(struct dvb_frontend *fe)
+static int get_frontend(struct dvb_frontend *fe,
+			struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct l64781_state* state = fe->demodulator_priv;
 	int tmp;
 
diff --git a/drivers/media/dvb-frontends/lg2160.c b/drivers/media/dvb-frontends/lg2160.c
index 7880f71ccd8a..f51a3a0b3949 100644
--- a/drivers/media/dvb-frontends/lg2160.c
+++ b/drivers/media/dvb-frontends/lg2160.c
@@ -942,101 +942,102 @@ static int lg216x_read_rs_err_count(struct lg216x_state *state, u16 *err)
 
 /* ------------------------------------------------------------------------ */
 
-static int lg216x_get_frontend(struct dvb_frontend *fe)
+static int lg216x_get_frontend(struct dvb_frontend *fe,
+			       struct dtv_frontend_properties *c)
 {
 	struct lg216x_state *state = fe->demodulator_priv;
 	int ret;
 
 	lg_dbg("\n");
 
-	fe->dtv_property_cache.modulation = VSB_8;
-	fe->dtv_property_cache.frequency = state->current_frequency;
-	fe->dtv_property_cache.delivery_system = SYS_ATSCMH;
+	c->modulation = VSB_8;
+	c->frequency = state->current_frequency;
+	c->delivery_system = SYS_ATSCMH;
 
 	ret = lg216x_get_fic_version(state,
-				     &fe->dtv_property_cache.atscmh_fic_ver);
+				     &c->atscmh_fic_ver);
 	if (lg_fail(ret))
 		goto fail;
-	if (state->fic_ver != fe->dtv_property_cache.atscmh_fic_ver) {
-		state->fic_ver = fe->dtv_property_cache.atscmh_fic_ver;
+	if (state->fic_ver != c->atscmh_fic_ver) {
+		state->fic_ver = c->atscmh_fic_ver;
 
 #if 0
 		ret = lg2160_get_parade_id(state,
-				&fe->dtv_property_cache.atscmh_parade_id);
+				&c->atscmh_parade_id);
 		if (lg_fail(ret))
 			goto fail;
 /* #else */
-		fe->dtv_property_cache.atscmh_parade_id = state->parade_id;
+		c->atscmh_parade_id = state->parade_id;
 #endif
 		ret = lg216x_get_nog(state,
-				     &fe->dtv_property_cache.atscmh_nog);
+				     &c->atscmh_nog);
 		if (lg_fail(ret))
 			goto fail;
 		ret = lg216x_get_tnog(state,
-				      &fe->dtv_property_cache.atscmh_tnog);
+				      &c->atscmh_tnog);
 		if (lg_fail(ret))
 			goto fail;
 		ret = lg216x_get_sgn(state,
-				     &fe->dtv_property_cache.atscmh_sgn);
+				     &c->atscmh_sgn);
 		if (lg_fail(ret))
 			goto fail;
 		ret = lg216x_get_prc(state,
-				     &fe->dtv_property_cache.atscmh_prc);
+				     &c->atscmh_prc);
 		if (lg_fail(ret))
 			goto fail;
 
 		ret = lg216x_get_rs_frame_mode(state,
 			(enum atscmh_rs_frame_mode *)
-			&fe->dtv_property_cache.atscmh_rs_frame_mode);
+			&c->atscmh_rs_frame_mode);
 		if (lg_fail(ret))
 			goto fail;
 		ret = lg216x_get_rs_frame_ensemble(state,
 			(enum atscmh_rs_frame_ensemble *)
-			&fe->dtv_property_cache.atscmh_rs_frame_ensemble);
+			&c->atscmh_rs_frame_ensemble);
 		if (lg_fail(ret))
 			goto fail;
 		ret = lg216x_get_rs_code_mode(state,
 			(enum atscmh_rs_code_mode *)
-			&fe->dtv_property_cache.atscmh_rs_code_mode_pri,
+			&c->atscmh_rs_code_mode_pri,
 			(enum atscmh_rs_code_mode *)
-			&fe->dtv_property_cache.atscmh_rs_code_mode_sec);
+			&c->atscmh_rs_code_mode_sec);
 		if (lg_fail(ret))
 			goto fail;
 		ret = lg216x_get_sccc_block_mode(state,
 			(enum atscmh_sccc_block_mode *)
-			&fe->dtv_property_cache.atscmh_sccc_block_mode);
+			&c->atscmh_sccc_block_mode);
 		if (lg_fail(ret))
 			goto fail;
 		ret = lg216x_get_sccc_code_mode(state,
 			(enum atscmh_sccc_code_mode *)
-			&fe->dtv_property_cache.atscmh_sccc_code_mode_a,
+			&c->atscmh_sccc_code_mode_a,
 			(enum atscmh_sccc_code_mode *)
-			&fe->dtv_property_cache.atscmh_sccc_code_mode_b,
+			&c->atscmh_sccc_code_mode_b,
 			(enum atscmh_sccc_code_mode *)
-			&fe->dtv_property_cache.atscmh_sccc_code_mode_c,
+			&c->atscmh_sccc_code_mode_c,
 			(enum atscmh_sccc_code_mode *)
-			&fe->dtv_property_cache.atscmh_sccc_code_mode_d);
+			&c->atscmh_sccc_code_mode_d);
 		if (lg_fail(ret))
 			goto fail;
 	}
 #if 0
 	ret = lg216x_read_fic_err_count(state,
-				(u8 *)&fe->dtv_property_cache.atscmh_fic_err);
+				(u8 *)&c->atscmh_fic_err);
 	if (lg_fail(ret))
 		goto fail;
 	ret = lg216x_read_crc_err_count(state,
-				&fe->dtv_property_cache.atscmh_crc_err);
+				&c->atscmh_crc_err);
 	if (lg_fail(ret))
 		goto fail;
 	ret = lg216x_read_rs_err_count(state,
-				&fe->dtv_property_cache.atscmh_rs_err);
+				&c->atscmh_rs_err);
 	if (lg_fail(ret))
 		goto fail;
 
 	switch (state->cfg->lg_chip) {
 	case LG2160:
-		if (((fe->dtv_property_cache.atscmh_rs_err >= 240) &&
-		     (fe->dtv_property_cache.atscmh_crc_err >= 240)) &&
+		if (((c->atscmh_rs_err >= 240) &&
+		     (c->atscmh_crc_err >= 240)) &&
 		    ((jiffies_to_msecs(jiffies) - state->last_reset) > 6000))
 			ret = lg216x_soft_reset(state);
 		break;
@@ -1054,14 +1055,17 @@ fail:
 static int lg216x_get_property(struct dvb_frontend *fe,
 			       struct dtv_property *tvp)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
 	return (DTV_ATSCMH_FIC_VER == tvp->cmd) ?
-		lg216x_get_frontend(fe) : 0;
+		lg216x_get_frontend(fe, c) : 0;
 }
 
 
 static int lg2160_set_frontend(struct dvb_frontend *fe)
 {
 	struct lg216x_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
 	lg_dbg("(%d)\n", fe->dtv_property_cache.frequency);
@@ -1129,7 +1133,7 @@ static int lg2160_set_frontend(struct dvb_frontend *fe)
 	ret = lg216x_enable_fic(state, 1);
 	lg_fail(ret);
 
-	lg216x_get_frontend(fe);
+	lg216x_get_frontend(fe, c);
 fail:
 	return ret;
 }
diff --git a/drivers/media/dvb-frontends/lgdt3305.c b/drivers/media/dvb-frontends/lgdt3305.c
index 47121866163d..4503e8852fd1 100644
--- a/drivers/media/dvb-frontends/lgdt3305.c
+++ b/drivers/media/dvb-frontends/lgdt3305.c
@@ -812,9 +812,9 @@ fail:
 	return ret;
 }
 
-static int lgdt3305_get_frontend(struct dvb_frontend *fe)
+static int lgdt3305_get_frontend(struct dvb_frontend *fe,
+				 struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct lgdt3305_state *state = fe->demodulator_priv;
 
 	lg_dbg("\n");
diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 721fbc07e9ee..179c26e5eb4e 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -1040,10 +1040,10 @@ fail:
 	return ret;
 }
 
-static int lgdt3306a_get_frontend(struct dvb_frontend *fe)
+static int lgdt3306a_get_frontend(struct dvb_frontend *fe,
+				  struct dtv_frontend_properties *p)
 {
 	struct lgdt3306a_state *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
 	dbg_info("(%u, %d)\n",
 		 state->current_frequency, state->current_modulation);
diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index cf3cc20510da..96bf254da21e 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -439,10 +439,11 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int lgdt330x_get_frontend(struct dvb_frontend *fe)
+static int lgdt330x_get_frontend(struct dvb_frontend *fe,
+				 struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct lgdt330x_state *state = fe->demodulator_priv;
+
 	p->frequency = state->current_frequency;
 	return 0;
 }
diff --git a/drivers/media/dvb-frontends/lgs8gl5.c b/drivers/media/dvb-frontends/lgs8gl5.c
index 7bbb2c18c2dd..fbfd87b5b803 100644
--- a/drivers/media/dvb-frontends/lgs8gl5.c
+++ b/drivers/media/dvb-frontends/lgs8gl5.c
@@ -336,10 +336,11 @@ lgs8gl5_set_frontend(struct dvb_frontend *fe)
 
 
 static int
-lgs8gl5_get_frontend(struct dvb_frontend *fe)
+lgs8gl5_get_frontend(struct dvb_frontend *fe,
+		     struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct lgs8gl5_state *state = fe->demodulator_priv;
+
 	u8 inv = lgs8gl5_read_reg(state, REG_INVERSION);
 
 	p->inversion = (inv & REG_INVERSION_ON) ? INVERSION_ON : INVERSION_OFF;
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index ce73a5ec6036..76883600ec6f 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -791,11 +791,11 @@ err:
 	return ret;
 }
 
-static int m88ds3103_get_frontend(struct dvb_frontend *fe)
+static int m88ds3103_get_frontend(struct dvb_frontend *fe,
+				  struct dtv_frontend_properties *c)
 {
 	struct m88ds3103_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[3];
 
diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index 9b6f464c48bd..a09b12313a73 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -708,10 +708,11 @@ static int m88rs2000_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int m88rs2000_get_frontend(struct dvb_frontend *fe)
+static int m88rs2000_get_frontend(struct dvb_frontend *fe,
+				  struct dtv_frontend_properties *c)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct m88rs2000_state *state = fe->demodulator_priv;
+
 	c->fec_inner = state->fec_inner;
 	c->frequency = state->tuner_frequency;
 	c->symbol_rate = state->symbol_rate;
diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c
index c36e6764eead..fc08429c99b7 100644
--- a/drivers/media/dvb-frontends/mt312.c
+++ b/drivers/media/dvb-frontends/mt312.c
@@ -647,9 +647,9 @@ static int mt312_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int mt312_get_frontend(struct dvb_frontend *fe)
+static int mt312_get_frontend(struct dvb_frontend *fe,
+			      struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct mt312_state *state = fe->demodulator_priv;
 	int ret;
 
diff --git a/drivers/media/dvb-frontends/mt352.c b/drivers/media/dvb-frontends/mt352.c
index 123bb2f8e4b6..c0bb6328956b 100644
--- a/drivers/media/dvb-frontends/mt352.c
+++ b/drivers/media/dvb-frontends/mt352.c
@@ -311,9 +311,9 @@ static int mt352_set_parameters(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int mt352_get_parameters(struct dvb_frontend* fe)
+static int mt352_get_parameters(struct dvb_frontend* fe,
+				struct dtv_frontend_properties *op)
 {
-	struct dtv_frontend_properties *op = &fe->dtv_property_cache;
 	struct mt352_state* state = fe->demodulator_priv;
 	u16 tps;
 	u16 div;
diff --git a/drivers/media/dvb-frontends/or51132.c b/drivers/media/dvb-frontends/or51132.c
index 35b1053b3640..a165af990672 100644
--- a/drivers/media/dvb-frontends/or51132.c
+++ b/drivers/media/dvb-frontends/or51132.c
@@ -375,9 +375,9 @@ static int or51132_set_parameters(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int or51132_get_parameters(struct dvb_frontend* fe)
+static int or51132_get_parameters(struct dvb_frontend* fe,
+				  struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct or51132_state* state = fe->demodulator_priv;
 	int status;
 	int retry = 1;
diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 74b771218033..3f96429af0e5 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -279,11 +279,11 @@ err:
 	return ret;
 }
 
-static int rtl2830_get_frontend(struct dvb_frontend *fe)
+static int rtl2830_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *c)
 {
 	struct i2c_client *client = fe->demodulator_priv;
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[3];
 
diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 10f2119935da..c2469fb42f12 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -575,11 +575,11 @@ err:
 	return ret;
 }
 
-static int rtl2832_get_frontend(struct dvb_frontend *fe)
+static int rtl2832_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *c)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[3];
 
diff --git a/drivers/media/dvb-frontends/s5h1409.c b/drivers/media/dvb-frontends/s5h1409.c
index 10964848a2f1..c68965ad97c0 100644
--- a/drivers/media/dvb-frontends/s5h1409.c
+++ b/drivers/media/dvb-frontends/s5h1409.c
@@ -925,9 +925,9 @@ static int s5h1409_read_ber(struct dvb_frontend *fe, u32 *ber)
 	return s5h1409_read_ucblocks(fe, ber);
 }
 
-static int s5h1409_get_frontend(struct dvb_frontend *fe)
+static int s5h1409_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct s5h1409_state *state = fe->demodulator_priv;
 
 	p->frequency = state->current_frequency;
diff --git a/drivers/media/dvb-frontends/s5h1411.c b/drivers/media/dvb-frontends/s5h1411.c
index 9afc3f42290e..90f86e82b087 100644
--- a/drivers/media/dvb-frontends/s5h1411.c
+++ b/drivers/media/dvb-frontends/s5h1411.c
@@ -840,9 +840,9 @@ static int s5h1411_read_ber(struct dvb_frontend *fe, u32 *ber)
 	return s5h1411_read_ucblocks(fe, ber);
 }
 
-static int s5h1411_get_frontend(struct dvb_frontend *fe)
+static int s5h1411_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct s5h1411_state *state = fe->demodulator_priv;
 
 	p->frequency = state->current_frequency;
diff --git a/drivers/media/dvb-frontends/s5h1420.c b/drivers/media/dvb-frontends/s5h1420.c
index 9c22a4c70d87..d7d0b7d57ad7 100644
--- a/drivers/media/dvb-frontends/s5h1420.c
+++ b/drivers/media/dvb-frontends/s5h1420.c
@@ -756,9 +756,9 @@ static int s5h1420_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int s5h1420_get_frontend(struct dvb_frontend* fe)
+static int s5h1420_get_frontend(struct dvb_frontend* fe,
+				struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct s5h1420_state* state = fe->demodulator_priv;
 
 	p->frequency = state->tunedfreq + s5h1420_getfreqoffset(state);
diff --git a/drivers/media/dvb-frontends/s921.c b/drivers/media/dvb-frontends/s921.c
index d6a8fa63040b..b5e3d90eba5e 100644
--- a/drivers/media/dvb-frontends/s921.c
+++ b/drivers/media/dvb-frontends/s921.c
@@ -433,9 +433,9 @@ static int s921_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int s921_get_frontend(struct dvb_frontend *fe)
+static int s921_get_frontend(struct dvb_frontend *fe,
+			     struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct s921_state *state = fe->demodulator_priv;
 
 	/* FIXME: Probably it is possible to get it from regs f1 and f2 */
diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
index 756650f154ab..3d171b0e00c2 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.c
+++ b/drivers/media/dvb-frontends/stb0899_drv.c
@@ -1568,9 +1568,9 @@ static enum dvbfe_search stb0899_search(struct dvb_frontend *fe)
 	return DVBFE_ALGO_SEARCH_ERROR;
 }
 
-static int stb0899_get_frontend(struct dvb_frontend *fe)
+static int stb0899_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stb0899_state *state		= fe->demodulator_priv;
 	struct stb0899_internal *internal	= &state->internal;
 
diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
index c978c801c7aa..b9c2511bf019 100644
--- a/drivers/media/dvb-frontends/stb6100.c
+++ b/drivers/media/dvb-frontends/stb6100.c
@@ -346,7 +346,7 @@ static int stb6100_set_frequency(struct dvb_frontend *fe, u32 frequency)
 
 	if (fe->ops.get_frontend) {
 		dprintk(verbose, FE_DEBUG, 1, "Get frontend parameters");
-		fe->ops.get_frontend(fe);
+		fe->ops.get_frontend(fe, p);
 	}
 	srate = p->symbol_rate;
 
diff --git a/drivers/media/dvb-frontends/stv0297.c b/drivers/media/dvb-frontends/stv0297.c
index 75b4d8b25657..81b27b7c0c96 100644
--- a/drivers/media/dvb-frontends/stv0297.c
+++ b/drivers/media/dvb-frontends/stv0297.c
@@ -615,9 +615,9 @@ timeout:
 	return 0;
 }
 
-static int stv0297_get_frontend(struct dvb_frontend *fe)
+static int stv0297_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stv0297_state *state = fe->demodulator_priv;
 	int reg_00, reg_83;
 
diff --git a/drivers/media/dvb-frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
index c43f36d32340..7927fa925f2f 100644
--- a/drivers/media/dvb-frontends/stv0299.c
+++ b/drivers/media/dvb-frontends/stv0299.c
@@ -602,9 +602,9 @@ static int stv0299_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int stv0299_get_frontend(struct dvb_frontend *fe)
+static int stv0299_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stv0299_state* state = fe->demodulator_priv;
 	s32 derot_freq;
 	int invval;
diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 44cb73f68af6..abc379aea713 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -1938,9 +1938,9 @@ static int stv0367ter_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	return 0;
 }
 
-static int stv0367ter_get_frontend(struct dvb_frontend *fe)
+static int stv0367ter_get_frontend(struct dvb_frontend *fe,
+				   struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stv0367_state *state = fe->demodulator_priv;
 	struct stv0367ter_state *ter_state = state->ter_state;
 	enum stv0367_ter_mode mode;
@@ -3146,9 +3146,9 @@ static int stv0367cab_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int stv0367cab_get_frontend(struct dvb_frontend *fe)
+static int stv0367cab_get_frontend(struct dvb_frontend *fe,
+				   struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stv0367_state *state = fe->demodulator_priv;
 	struct stv0367cab_state *cab_state = state->cab_state;
 
diff --git a/drivers/media/dvb-frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
index fe31dd541955..28239b1fd954 100644
--- a/drivers/media/dvb-frontends/stv0900_core.c
+++ b/drivers/media/dvb-frontends/stv0900_core.c
@@ -1859,9 +1859,9 @@ static int stv0900_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int stv0900_get_frontend(struct dvb_frontend *fe)
+static int stv0900_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stv0900_state *state = fe->demodulator_priv;
 	struct stv0900_internal *intp = state->internal;
 	enum fe_stv0900_demod_num demod = state->demod;
diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index 456cdc7fb1e7..31cd32532387 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -201,10 +201,10 @@ static const enum fe_code_rate fec_conv_sat[] = {
 	FEC_2_3, /* for 8PSK. (trellis code) */
 };
 
-static int tc90522s_get_frontend(struct dvb_frontend *fe)
+static int tc90522s_get_frontend(struct dvb_frontend *fe,
+				 struct dtv_frontend_properties *c)
 {
 	struct tc90522_state *state;
-	struct dtv_frontend_properties *c;
 	struct dtv_fe_stats *stats;
 	int ret, i;
 	int layers;
@@ -212,7 +212,6 @@ static int tc90522s_get_frontend(struct dvb_frontend *fe)
 	u32 cndat;
 
 	state = fe->demodulator_priv;
-	c = &fe->dtv_property_cache;
 	c->delivery_system = SYS_ISDBS;
 	c->symbol_rate = 28860000;
 
@@ -337,10 +336,10 @@ static const enum fe_modulation mod_conv[] = {
 	DQPSK, QPSK, QAM_16, QAM_64, 0, 0, 0, 0
 };
 
-static int tc90522t_get_frontend(struct dvb_frontend *fe)
+static int tc90522t_get_frontend(struct dvb_frontend *fe,
+				 struct dtv_frontend_properties *c)
 {
 	struct tc90522_state *state;
-	struct dtv_frontend_properties *c;
 	struct dtv_fe_stats *stats;
 	int ret, i;
 	int layers;
@@ -348,7 +347,6 @@ static int tc90522t_get_frontend(struct dvb_frontend *fe)
 	u32 cndat;
 
 	state = fe->demodulator_priv;
-	c = &fe->dtv_property_cache;
 	c->delivery_system = SYS_ISDBT;
 	c->bandwidth_hz = 6000000;
 	mode = 1;
diff --git a/drivers/media/dvb-frontends/tda10021.c b/drivers/media/dvb-frontends/tda10021.c
index a684424e665a..806c56691ca5 100644
--- a/drivers/media/dvb-frontends/tda10021.c
+++ b/drivers/media/dvb-frontends/tda10021.c
@@ -387,9 +387,9 @@ static int tda10021_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int tda10021_get_frontend(struct dvb_frontend *fe)
+static int tda10021_get_frontend(struct dvb_frontend *fe,
+				 struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct tda10021_state* state = fe->demodulator_priv;
 	int sync;
 	s8 afc = 0;
diff --git a/drivers/media/dvb-frontends/tda10023.c b/drivers/media/dvb-frontends/tda10023.c
index 44a55656093f..3b8c7e499d0d 100644
--- a/drivers/media/dvb-frontends/tda10023.c
+++ b/drivers/media/dvb-frontends/tda10023.c
@@ -457,9 +457,9 @@ static int tda10023_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int tda10023_get_frontend(struct dvb_frontend *fe)
+static int tda10023_get_frontend(struct dvb_frontend *fe,
+				 struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct tda10023_state* state = fe->demodulator_priv;
 	int sync,inv;
 	s8 afc = 0;
diff --git a/drivers/media/dvb-frontends/tda10048.c b/drivers/media/dvb-frontends/tda10048.c
index 8451086c563f..c2bf89d0b0b0 100644
--- a/drivers/media/dvb-frontends/tda10048.c
+++ b/drivers/media/dvb-frontends/tda10048.c
@@ -1028,9 +1028,9 @@ static int tda10048_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	return 0;
 }
 
-static int tda10048_get_frontend(struct dvb_frontend *fe)
+static int tda10048_get_frontend(struct dvb_frontend *fe,
+				 struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct tda10048_state *state = fe->demodulator_priv;
 
 	dprintk(1, "%s()\n", __func__);
diff --git a/drivers/media/dvb-frontends/tda1004x.c b/drivers/media/dvb-frontends/tda1004x.c
index 0e209b56c76c..3137a9ba3a32 100644
--- a/drivers/media/dvb-frontends/tda1004x.c
+++ b/drivers/media/dvb-frontends/tda1004x.c
@@ -899,9 +899,9 @@ static int tda1004x_set_fe(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int tda1004x_get_fe(struct dvb_frontend *fe)
+static int tda1004x_get_fe(struct dvb_frontend *fe,
+			   struct dtv_frontend_properties *fe_params)
 {
-	struct dtv_frontend_properties *fe_params = &fe->dtv_property_cache;
 	struct tda1004x_state* state = fe->demodulator_priv;
 
 	dprintk("%s\n", __func__);
diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 119d47596ac8..37ebeef2bbd0 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -701,11 +701,11 @@ error:
 	return ret;
 }
 
-static int tda10071_get_frontend(struct dvb_frontend *fe)
+static int tda10071_get_frontend(struct dvb_frontend *fe,
+				 struct dtv_frontend_properties *c)
 {
 	struct tda10071_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u8 buf[5], tmp;
 
diff --git a/drivers/media/dvb-frontends/tda10086.c b/drivers/media/dvb-frontends/tda10086.c
index 95a33e187f8e..31d0acb54fe8 100644
--- a/drivers/media/dvb-frontends/tda10086.c
+++ b/drivers/media/dvb-frontends/tda10086.c
@@ -459,9 +459,9 @@ static int tda10086_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int tda10086_get_frontend(struct dvb_frontend *fe)
+static int tda10086_get_frontend(struct dvb_frontend *fe,
+				 struct dtv_frontend_properties *fe_params)
 {
-	struct dtv_frontend_properties *fe_params = &fe->dtv_property_cache;
 	struct tda10086_state* state = fe->demodulator_priv;
 	u8 val;
 	int tmp;
diff --git a/drivers/media/dvb-frontends/tda8083.c b/drivers/media/dvb-frontends/tda8083.c
index 796543fa2c8d..9072d6463094 100644
--- a/drivers/media/dvb-frontends/tda8083.c
+++ b/drivers/media/dvb-frontends/tda8083.c
@@ -342,9 +342,9 @@ static int tda8083_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int tda8083_get_frontend(struct dvb_frontend *fe)
+static int tda8083_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct tda8083_state* state = fe->demodulator_priv;
 
 	/*  FIXME: get symbolrate & frequency offset...*/
diff --git a/drivers/media/dvb-frontends/ves1820.c b/drivers/media/dvb-frontends/ves1820.c
index aacfdda3e005..b09fe88c40f8 100644
--- a/drivers/media/dvb-frontends/ves1820.c
+++ b/drivers/media/dvb-frontends/ves1820.c
@@ -312,9 +312,9 @@ static int ves1820_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int ves1820_get_frontend(struct dvb_frontend *fe)
+static int ves1820_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ves1820_state* state = fe->demodulator_priv;
 	int sync;
 	s8 afc = 0;
diff --git a/drivers/media/dvb-frontends/ves1x93.c b/drivers/media/dvb-frontends/ves1x93.c
index 526952396422..ed113e216e14 100644
--- a/drivers/media/dvb-frontends/ves1x93.c
+++ b/drivers/media/dvb-frontends/ves1x93.c
@@ -406,9 +406,9 @@ static int ves1x93_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int ves1x93_get_frontend(struct dvb_frontend *fe)
+static int ves1x93_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ves1x93_state* state = fe->demodulator_priv;
 	int afc;
 
diff --git a/drivers/media/dvb-frontends/zl10353.c b/drivers/media/dvb-frontends/zl10353.c
index ef9764a02d4c..1832c2f7695c 100644
--- a/drivers/media/dvb-frontends/zl10353.c
+++ b/drivers/media/dvb-frontends/zl10353.c
@@ -371,9 +371,9 @@ static int zl10353_set_parameters(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int zl10353_get_parameters(struct dvb_frontend *fe)
+static int zl10353_get_parameters(struct dvb_frontend *fe,
+				  struct dtv_frontend_properties *c)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct zl10353_state *state = fe->demodulator_priv;
 	int s6, s9;
 	u16 tps;
diff --git a/drivers/media/pci/bt8xx/dst.c b/drivers/media/pci/bt8xx/dst.c
index 4a90eee5e3bb..35bc9b2287b4 100644
--- a/drivers/media/pci/bt8xx/dst.c
+++ b/drivers/media/pci/bt8xx/dst.c
@@ -1688,9 +1688,9 @@ static int dst_get_tuning_algo(struct dvb_frontend *fe)
 	return dst_algo ? DVBFE_ALGO_HW : DVBFE_ALGO_SW;
 }
 
-static int dst_get_frontend(struct dvb_frontend *fe)
+static int dst_get_frontend(struct dvb_frontend *fe,
+			    struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct dst_state *state = fe->demodulator_priv;
 
 	p->frequency = state->decode_freq;
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
index 84f6de6fa07d..047a32fe43ea 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
@@ -507,9 +507,9 @@ static int mxl111sf_demod_read_signal_strength(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int mxl111sf_demod_get_frontend(struct dvb_frontend *fe)
+static int mxl111sf_demod_get_frontend(struct dvb_frontend *fe,
+				       struct dtv_frontend_properties *p)
 {
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct mxl111sf_demod_state *state = fe->demodulator_priv;
 
 	mxl_dbg("()");
diff --git a/drivers/media/usb/dvb-usb/af9005-fe.c b/drivers/media/usb/dvb-usb/af9005-fe.c
index ac97075d75f7..09db3d02bd82 100644
--- a/drivers/media/usb/dvb-usb/af9005-fe.c
+++ b/drivers/media/usb/dvb-usb/af9005-fe.c
@@ -1227,9 +1227,9 @@ static int af9005_fe_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int af9005_fe_get_frontend(struct dvb_frontend *fe)
+static int af9005_fe_get_frontend(struct dvb_frontend *fe,
+				  struct dtv_frontend_properties *fep)
 {
-	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct af9005_fe_state *state = fe->demodulator_priv;
 	int ret;
 	u8 temp;
diff --git a/drivers/media/usb/dvb-usb/dtt200u-fe.c b/drivers/media/usb/dvb-usb/dtt200u-fe.c
index 7e72a1bef76a..c09332bd99cb 100644
--- a/drivers/media/usb/dvb-usb/dtt200u-fe.c
+++ b/drivers/media/usb/dvb-usb/dtt200u-fe.c
@@ -140,10 +140,11 @@ static int dtt200u_fe_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int dtt200u_fe_get_frontend(struct dvb_frontend* fe)
+static int dtt200u_fe_get_frontend(struct dvb_frontend* fe,
+				   struct dtv_frontend_properties *fep)
 {
-	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
+
 	memcpy(fep, &state->fep, sizeof(struct dtv_frontend_properties));
 	return 0;
 }
-- 
2.5.0


