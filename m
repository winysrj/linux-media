Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:41034 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932553AbcHIVlt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 17:41:49 -0400
Subject: [PATCH 04/12] [media] dvb: make DVB frontend *_ops instances "const"
From: Max Kellermann <max.kellermann@gmail.com>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 09 Aug 2016 23:32:21 +0200
Message-ID: <147077834127.21835.3114337621063867057.stgit@woodpecker.blarg.de>
In-Reply-To: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
References: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are immutable.  Making them "const" allows the compiler to move
them to the "rodata" section.

Note that cxd2841er_t_c_ops cannot be made "const", because
cxd2841er_attach() modifies it.  Ouch!

Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/media/common/siano/smsdvb-main.c      |    2 +-
 drivers/media/dvb-frontends/af9013.c          |    4 ++--
 drivers/media/dvb-frontends/af9033.c          |    2 +-
 drivers/media/dvb-frontends/as102_fe.c        |    2 +-
 drivers/media/dvb-frontends/ascot2e.c         |    2 +-
 drivers/media/dvb-frontends/atbm8830.c        |    2 +-
 drivers/media/dvb-frontends/au8522_dig.c      |    4 ++--
 drivers/media/dvb-frontends/bcm3510.c         |    4 ++--
 drivers/media/dvb-frontends/cx22700.c         |    4 ++--
 drivers/media/dvb-frontends/cx24110.c         |    4 ++--
 drivers/media/dvb-frontends/cx24116.c         |    4 ++--
 drivers/media/dvb-frontends/cx24117.c         |    4 ++--
 drivers/media/dvb-frontends/cx24120.c         |    4 ++--
 drivers/media/dvb-frontends/cx24123.c         |    4 ++--
 drivers/media/dvb-frontends/cxd2841er.c       |    4 ++--
 drivers/media/dvb-frontends/dib3000mb.c       |    4 ++--
 drivers/media/dvb-frontends/dib3000mc.c       |    4 ++--
 drivers/media/dvb-frontends/dib7000m.c        |    4 ++--
 drivers/media/dvb-frontends/dib7000p.c        |    4 ++--
 drivers/media/dvb-frontends/dib9000.c         |    4 ++--
 drivers/media/dvb-frontends/drx39xyj/drxj.c   |    4 ++--
 drivers/media/dvb-frontends/drxd_hard.c       |    2 +-
 drivers/media/dvb-frontends/drxk_hard.c       |    2 +-
 drivers/media/dvb-frontends/ds3000.c          |    4 ++--
 drivers/media/dvb-frontends/dvb-pll.c         |    2 +-
 drivers/media/dvb-frontends/dvb_dummy_fe.c    |   12 ++++++------
 drivers/media/dvb-frontends/ec100.c           |    4 ++--
 drivers/media/dvb-frontends/hd29l2.c          |    4 ++--
 drivers/media/dvb-frontends/helene.c          |    4 ++--
 drivers/media/dvb-frontends/horus3a.c         |    2 +-
 drivers/media/dvb-frontends/ix2505v.c         |    2 +-
 drivers/media/dvb-frontends/l64781.c          |    4 ++--
 drivers/media/dvb-frontends/lg2160.c          |    4 ++--
 drivers/media/dvb-frontends/lgdt3305.c        |    8 ++++----
 drivers/media/dvb-frontends/lgdt3306a.c       |    4 ++--
 drivers/media/dvb-frontends/lgdt330x.c        |    8 ++++----
 drivers/media/dvb-frontends/lgs8gl5.c         |    4 ++--
 drivers/media/dvb-frontends/lgs8gxx.c         |    2 +-
 drivers/media/dvb-frontends/m88ds3103.c       |    4 ++--
 drivers/media/dvb-frontends/m88rs2000.c       |    2 +-
 drivers/media/dvb-frontends/mb86a16.c         |    2 +-
 drivers/media/dvb-frontends/mb86a20s.c        |    4 ++--
 drivers/media/dvb-frontends/mn88472.c         |    2 +-
 drivers/media/dvb-frontends/mt312.c           |    2 +-
 drivers/media/dvb-frontends/mt352.c           |    4 ++--
 drivers/media/dvb-frontends/nxt200x.c         |    4 ++--
 drivers/media/dvb-frontends/nxt6000.c         |    4 ++--
 drivers/media/dvb-frontends/or51132.c         |    4 ++--
 drivers/media/dvb-frontends/or51211.c         |    4 ++--
 drivers/media/dvb-frontends/rtl2830.c         |    2 +-
 drivers/media/dvb-frontends/rtl2832.c         |    2 +-
 drivers/media/dvb-frontends/s5h1409.c         |    4 ++--
 drivers/media/dvb-frontends/s5h1411.c         |    4 ++--
 drivers/media/dvb-frontends/s5h1420.c         |    4 ++--
 drivers/media/dvb-frontends/s5h1432.c         |    4 ++--
 drivers/media/dvb-frontends/s921.c            |    4 ++--
 drivers/media/dvb-frontends/si2165.c          |    2 +-
 drivers/media/dvb-frontends/si21xx.c          |    2 +-
 drivers/media/dvb-frontends/sp8870.c          |    4 ++--
 drivers/media/dvb-frontends/sp887x.c          |    4 ++--
 drivers/media/dvb-frontends/stb0899_drv.c     |    2 +-
 drivers/media/dvb-frontends/stb6000.c         |    2 +-
 drivers/media/dvb-frontends/stb6100.c         |    2 +-
 drivers/media/dvb-frontends/stv0288.c         |    2 +-
 drivers/media/dvb-frontends/stv0297.c         |    4 ++--
 drivers/media/dvb-frontends/stv0299.c         |    4 ++--
 drivers/media/dvb-frontends/stv0367.c         |    4 ++--
 drivers/media/dvb-frontends/stv0900_core.c    |    2 +-
 drivers/media/dvb-frontends/stv090x.c         |    2 +-
 drivers/media/dvb-frontends/stv6110.c         |    2 +-
 drivers/media/dvb-frontends/stv6110x.c        |    2 +-
 drivers/media/dvb-frontends/tda10021.c        |    4 ++--
 drivers/media/dvb-frontends/tda10023.c        |    4 ++--
 drivers/media/dvb-frontends/tda10048.c        |    4 ++--
 drivers/media/dvb-frontends/tda1004x.c        |    4 ++--
 drivers/media/dvb-frontends/tda10071.c        |    4 ++--
 drivers/media/dvb-frontends/tda10086.c        |    2 +-
 drivers/media/dvb-frontends/tda18271c2dd.c    |    2 +-
 drivers/media/dvb-frontends/tda665x.c         |    2 +-
 drivers/media/dvb-frontends/tda8083.c         |    4 ++--
 drivers/media/dvb-frontends/tda8261.c         |    2 +-
 drivers/media/dvb-frontends/tda826x.c         |    2 +-
 drivers/media/dvb-frontends/ts2020.c          |    2 +-
 drivers/media/dvb-frontends/tua6100.c         |    2 +-
 drivers/media/dvb-frontends/ves1820.c         |    4 ++--
 drivers/media/dvb-frontends/ves1x93.c         |    4 ++--
 drivers/media/dvb-frontends/zl10036.c         |    2 +-
 drivers/media/dvb-frontends/zl10039.c         |    2 +-
 drivers/media/dvb-frontends/zl10353.c         |    4 ++--
 drivers/media/pci/bt8xx/dst.c                 |   16 ++++++++--------
 drivers/media/pci/pt1/va1j5jf8007s.c          |    2 +-
 drivers/media/pci/pt1/va1j5jf8007t.c          |    2 +-
 drivers/media/tuners/mt2063.c                 |    2 +-
 drivers/media/tuners/mt20xx.c                 |    4 ++--
 drivers/media/tuners/mxl5007t.c               |    2 +-
 drivers/media/tuners/tda827x.c                |    4 ++--
 drivers/media/tuners/tda8290.c                |    4 ++--
 drivers/media/tuners/tda9887.c                |    2 +-
 drivers/media/tuners/tea5761.c                |    2 +-
 drivers/media/tuners/tea5767.c                |    2 +-
 drivers/media/tuners/tuner-simple.c           |    2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c |    2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c |    2 +-
 drivers/media/usb/dvb-usb/af9005-fe.c         |    4 ++--
 drivers/media/usb/dvb-usb/cinergyT2-fe.c      |    4 ++--
 drivers/media/usb/dvb-usb/dtt200u-fe.c        |    4 ++--
 drivers/media/usb/dvb-usb/friio-fe.c          |    4 ++--
 drivers/media/usb/dvb-usb/gp8psk-fe.c         |    4 ++--
 drivers/media/usb/dvb-usb/vp702x-fe.c         |    4 ++--
 drivers/media/usb/dvb-usb/vp7045-fe.c         |    4 ++--
 drivers/media/usb/ttusb-dec/ttusbdecfe.c      |    8 ++++----
 111 files changed, 192 insertions(+), 192 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 9148e14..affde14 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1044,7 +1044,7 @@ static void smsdvb_release(struct dvb_frontend *fe)
 	/* do nothing */
 }
 
-static struct dvb_frontend_ops smsdvb_fe_ops = {
+static const struct dvb_frontend_ops smsdvb_fe_ops = {
 	.info = {
 		.name			= "Siano Mobile Digital MDTV Receiver",
 		.frequency_min		= 44250000,
diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 8bcde33..c6cb3bb 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -1351,7 +1351,7 @@ static void af9013_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops af9013_ops;
+static const struct dvb_frontend_ops af9013_ops;
 
 static int af9013_download_firmware(struct af9013_state *state)
 {
@@ -1516,7 +1516,7 @@ err:
 }
 EXPORT_SYMBOL(af9013_attach);
 
-static struct dvb_frontend_ops af9013_ops = {
+static const struct dvb_frontend_ops af9013_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Afatech AF9013",
diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 9a8157a..f881802 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -1198,7 +1198,7 @@ err:
 	return ret;
 }
 
-static struct dvb_frontend_ops af9033_ops = {
+static const struct dvb_frontend_ops af9033_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Afatech AF9033 (DVB-T)",
diff --git a/drivers/media/dvb-frontends/as102_fe.c b/drivers/media/dvb-frontends/as102_fe.c
index 9412fcd..98d575f 100644
--- a/drivers/media/dvb-frontends/as102_fe.c
+++ b/drivers/media/dvb-frontends/as102_fe.c
@@ -415,7 +415,7 @@ static void as102_fe_release(struct dvb_frontend *fe)
 }
 
 
-static struct dvb_frontend_ops as102_fe_ops = {
+static const struct dvb_frontend_ops as102_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Abilis AS102 DVB-T",
diff --git a/drivers/media/dvb-frontends/ascot2e.c b/drivers/media/dvb-frontends/ascot2e.c
index 8cc8c45..ad304ee 100644
--- a/drivers/media/dvb-frontends/ascot2e.c
+++ b/drivers/media/dvb-frontends/ascot2e.c
@@ -464,7 +464,7 @@ static int ascot2e_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops ascot2e_tuner_ops = {
+static const struct dvb_tuner_ops ascot2e_tuner_ops = {
 	.info = {
 		.name = "Sony ASCOT2E",
 		.frequency_min = 1000000,
diff --git a/drivers/media/dvb-frontends/atbm8830.c b/drivers/media/dvb-frontends/atbm8830.c
index 47248b8..07ce055 100644
--- a/drivers/media/dvb-frontends/atbm8830.c
+++ b/drivers/media/dvb-frontends/atbm8830.c
@@ -428,7 +428,7 @@ static int atbm8830_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	return atbm8830_write_reg(priv, REG_I2C_GATE, enable ? 1 : 0);
 }
 
-static struct dvb_frontend_ops atbm8830_ops = {
+static const struct dvb_frontend_ops atbm8830_ops = {
 	.delsys = { SYS_DTMB },
 	.info = {
 		.name = "AltoBeam ATBM8830/8831 DMB-TH",
diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
index e676b94..7ed326e 100644
--- a/drivers/media/dvb-frontends/au8522_dig.c
+++ b/drivers/media/dvb-frontends/au8522_dig.c
@@ -834,7 +834,7 @@ static int au8522_get_tune_settings(struct dvb_frontend *fe,
 	return 0;
 }
 
-static struct dvb_frontend_ops au8522_ops;
+static const struct dvb_frontend_ops au8522_ops;
 
 
 static void au8522_release(struct dvb_frontend *fe)
@@ -894,7 +894,7 @@ error:
 }
 EXPORT_SYMBOL(au8522_attach);
 
-static struct dvb_frontend_ops au8522_ops = {
+static const struct dvb_frontend_ops au8522_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Auvitek AU8522 QAM/8VSB Frontend",
diff --git a/drivers/media/dvb-frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
index bb69883..617c5e2 100644
--- a/drivers/media/dvb-frontends/bcm3510.c
+++ b/drivers/media/dvb-frontends/bcm3510.c
@@ -788,7 +788,7 @@ static int bcm3510_init(struct dvb_frontend* fe)
 }
 
 
-static struct dvb_frontend_ops bcm3510_ops;
+static const struct dvb_frontend_ops bcm3510_ops;
 
 struct dvb_frontend* bcm3510_attach(const struct bcm3510_config *config,
 				   struct i2c_adapter *i2c)
@@ -834,7 +834,7 @@ error:
 }
 EXPORT_SYMBOL(bcm3510_attach);
 
-static struct dvb_frontend_ops bcm3510_ops = {
+static const struct dvb_frontend_ops bcm3510_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "Broadcom BCM3510 VSB/QAM frontend",
diff --git a/drivers/media/dvb-frontends/cx22700.c b/drivers/media/dvb-frontends/cx22700.c
index 5cad925..2b629e2 100644
--- a/drivers/media/dvb-frontends/cx22700.c
+++ b/drivers/media/dvb-frontends/cx22700.c
@@ -380,7 +380,7 @@ static void cx22700_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops cx22700_ops;
+static const struct dvb_frontend_ops cx22700_ops;
 
 struct dvb_frontend* cx22700_attach(const struct cx22700_config* config,
 				    struct i2c_adapter* i2c)
@@ -408,7 +408,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops cx22700_ops = {
+static const struct dvb_frontend_ops cx22700_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Conexant CX22700 DVB-T",
diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
index 6cb81ec..5ee05b2 100644
--- a/drivers/media/dvb-frontends/cx24110.c
+++ b/drivers/media/dvb-frontends/cx24110.c
@@ -592,7 +592,7 @@ static void cx24110_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops cx24110_ops;
+static const struct dvb_frontend_ops cx24110_ops;
 
 struct dvb_frontend* cx24110_attach(const struct cx24110_config* config,
 				    struct i2c_adapter* i2c)
@@ -625,7 +625,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops cx24110_ops = {
+static const struct dvb_frontend_ops cx24110_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Conexant CX24110 DVB-S",
diff --git a/drivers/media/dvb-frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
index 8814f36..57928e0 100644
--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -1116,7 +1116,7 @@ static void cx24116_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops cx24116_ops;
+static const struct dvb_frontend_ops cx24116_ops;
 
 struct dvb_frontend *cx24116_attach(const struct cx24116_config *config,
 	struct i2c_adapter *i2c)
@@ -1467,7 +1467,7 @@ static int cx24116_get_algo(struct dvb_frontend *fe)
 	return DVBFE_ALGO_HW;
 }
 
-static struct dvb_frontend_ops cx24116_ops = {
+static const struct dvb_frontend_ops cx24116_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Conexant CX24116/CX24118",
diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index a3f7eb4..d0478bd 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -1164,7 +1164,7 @@ static void cx24117_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops cx24117_ops;
+static const struct dvb_frontend_ops cx24117_ops;
 
 struct dvb_frontend *cx24117_attach(const struct cx24117_config *config,
 	struct i2c_adapter *i2c)
@@ -1618,7 +1618,7 @@ static int cx24117_get_frontend(struct dvb_frontend *fe,
 	return 0;
 }
 
-static struct dvb_frontend_ops cx24117_ops = {
+static const struct dvb_frontend_ops cx24117_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Conexant CX24117/CX24132",
diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index 066ee38..79ede21 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -267,7 +267,7 @@ out:
 	return ret;
 }
 
-static struct dvb_frontend_ops cx24120_ops;
+static const struct dvb_frontend_ops cx24120_ops;
 
 struct dvb_frontend *cx24120_attach(const struct cx24120_config *config,
 				    struct i2c_adapter *i2c)
@@ -1552,7 +1552,7 @@ static int cx24120_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	return 0;
 }
 
-static struct dvb_frontend_ops cx24120_ops = {
+static const struct dvb_frontend_ops cx24120_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Conexant CX24120/CX24118",
diff --git a/drivers/media/dvb-frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
index 113b094..0e807c3 100644
--- a/drivers/media/dvb-frontends/cx24123.c
+++ b/drivers/media/dvb-frontends/cx24123.c
@@ -1049,7 +1049,7 @@ struct i2c_adapter *
 }
 EXPORT_SYMBOL(cx24123_get_tuner_i2c_adapter);
 
-static struct dvb_frontend_ops cx24123_ops;
+static const struct dvb_frontend_ops cx24123_ops;
 
 struct dvb_frontend *cx24123_attach(const struct cx24123_config *config,
 				    struct i2c_adapter *i2c)
@@ -1111,7 +1111,7 @@ error:
 }
 EXPORT_SYMBOL(cx24123_attach);
 
-static struct dvb_frontend_ops cx24123_ops = {
+static const struct dvb_frontend_ops cx24123_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Conexant CX24123/CX24109",
diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index ffe88bc..2f7f335 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -3641,7 +3641,7 @@ static int cxd2841er_init_tc(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct dvb_frontend_ops cxd2841er_dvbs_s2_ops;
+static const struct dvb_frontend_ops cxd2841er_dvbs_s2_ops;
 static struct dvb_frontend_ops cxd2841er_t_c_ops;
 
 static struct dvb_frontend *cxd2841er_attach(struct cxd2841er_config *cfg,
@@ -3723,7 +3723,7 @@ struct dvb_frontend *cxd2841er_attach_t_c(struct cxd2841er_config *cfg,
 }
 EXPORT_SYMBOL(cxd2841er_attach_t_c);
 
-static struct dvb_frontend_ops cxd2841er_dvbs_s2_ops = {
+static const struct dvb_frontend_ops cxd2841er_dvbs_s2_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name		= "Sony CXD2841ER DVB-S/S2 demodulator",
diff --git a/drivers/media/dvb-frontends/dib3000mb.c b/drivers/media/dvb-frontends/dib3000mb.c
index 6821ecb..5d7c55e 100644
--- a/drivers/media/dvb-frontends/dib3000mb.c
+++ b/drivers/media/dvb-frontends/dib3000mb.c
@@ -751,7 +751,7 @@ static int dib3000mb_tuner_pass_ctrl(struct dvb_frontend *fe, int onoff, u8 pll_
 	return 0;
 }
 
-static struct dvb_frontend_ops dib3000mb_ops;
+static const struct dvb_frontend_ops dib3000mb_ops;
 
 struct dvb_frontend* dib3000mb_attach(const struct dib3000_config* config,
 				      struct i2c_adapter* i2c, struct dib_fe_xfer_ops *xfer_ops)
@@ -791,7 +791,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops dib3000mb_ops = {
+static const struct dvb_frontend_ops dib3000mb_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "DiBcom 3000M-B DVB-T",
diff --git a/drivers/media/dvb-frontends/dib3000mc.c b/drivers/media/dvb-frontends/dib3000mc.c
index da0f1dc..564297d 100644
--- a/drivers/media/dvb-frontends/dib3000mc.c
+++ b/drivers/media/dvb-frontends/dib3000mc.c
@@ -873,7 +873,7 @@ int dib3000mc_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 defa
 }
 EXPORT_SYMBOL(dib3000mc_i2c_enumeration);
 
-static struct dvb_frontend_ops dib3000mc_ops;
+static const struct dvb_frontend_ops dib3000mc_ops;
 
 struct dvb_frontend * dib3000mc_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib3000mc_config *cfg)
 {
@@ -906,7 +906,7 @@ error:
 }
 EXPORT_SYMBOL(dib3000mc_attach);
 
-static struct dvb_frontend_ops dib3000mc_ops = {
+static const struct dvb_frontend_ops dib3000mc_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "DiBcom 3000MC/P",
diff --git a/drivers/media/dvb-frontends/dib7000m.c b/drivers/media/dvb-frontends/dib7000m.c
index b3ddae8..41e1ea6c 100644
--- a/drivers/media/dvb-frontends/dib7000m.c
+++ b/drivers/media/dvb-frontends/dib7000m.c
@@ -1394,7 +1394,7 @@ int dib7000m_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods,
 EXPORT_SYMBOL(dib7000m_i2c_enumeration);
 #endif
 
-static struct dvb_frontend_ops dib7000m_ops;
+static const struct dvb_frontend_ops dib7000m_ops;
 struct dvb_frontend * dib7000m_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000m_config *cfg)
 {
 	struct dvb_frontend *demod;
@@ -1432,7 +1432,7 @@ error:
 }
 EXPORT_SYMBOL(dib7000m_attach);
 
-static struct dvb_frontend_ops dib7000m_ops = {
+static const struct dvb_frontend_ops dib7000m_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "DiBcom 7000MA/MB/PA/PB/MC",
diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index b861d44..95fa6f3 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -2714,7 +2714,7 @@ static int dib7090_slave_reset(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct dvb_frontend_ops dib7000p_ops;
+static const struct dvb_frontend_ops dib7000p_ops;
 static struct dvb_frontend *dib7000p_init(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg)
 {
 	struct dvb_frontend *demod;
@@ -2804,7 +2804,7 @@ void *dib7000p_attach(struct dib7000p_ops *ops)
 }
 EXPORT_SYMBOL(dib7000p_attach);
 
-static struct dvb_frontend_ops dib7000p_ops = {
+static const struct dvb_frontend_ops dib7000p_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "DiBcom 7000PC",
diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
index 5897977..cd1f0e0 100644
--- a/drivers/media/dvb-frontends/dib9000.c
+++ b/drivers/media/dvb-frontends/dib9000.c
@@ -2483,7 +2483,7 @@ struct dvb_frontend *dib9000_get_slave_frontend(struct dvb_frontend *fe, int sla
 }
 EXPORT_SYMBOL(dib9000_get_slave_frontend);
 
-static struct dvb_frontend_ops dib9000_ops;
+static const struct dvb_frontend_ops dib9000_ops;
 struct dvb_frontend *dib9000_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, const struct dib9000_config *cfg)
 {
 	struct dvb_frontend *fe;
@@ -2560,7 +2560,7 @@ error:
 }
 EXPORT_SYMBOL(dib9000_attach);
 
-static struct dvb_frontend_ops dib9000_ops = {
+static const struct dvb_frontend_ops dib9000_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "DiBcom 9000",
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index bd6d2ee..f1c3e3b 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -12264,7 +12264,7 @@ static void drx39xxj_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops drx39xxj_ops;
+static const struct dvb_frontend_ops drx39xxj_ops;
 
 struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 {
@@ -12363,7 +12363,7 @@ error:
 }
 EXPORT_SYMBOL(drx39xxj_attach);
 
-static struct dvb_frontend_ops drx39xxj_ops = {
+static const struct dvb_frontend_ops drx39xxj_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		 .name = "Micronas DRX39xxj family Frontend",
diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 445a15c..4143f03 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -2912,7 +2912,7 @@ static void drxd_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops drxd_ops = {
+static const struct dvb_frontend_ops drxd_ops = {
 	.delsys = { SYS_DVBT},
 	.info = {
 		 .name = "Micronas DRXD DVB-T",
diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index b975da0..901b1f1 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6737,7 +6737,7 @@ static int drxk_get_tune_settings(struct dvb_frontend *fe,
 	}
 }
 
-static struct dvb_frontend_ops drxk_ops = {
+static const struct dvb_frontend_ops drxk_ops = {
 	/* .delsys will be filled dynamically */
 	.info = {
 		.name = "DRXK",
diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 447b518..3764e91 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -830,7 +830,7 @@ static void ds3000_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops ds3000_ops;
+static const struct dvb_frontend_ops ds3000_ops;
 
 struct dvb_frontend *ds3000_attach(const struct ds3000_config *config,
 				    struct i2c_adapter *i2c)
@@ -1104,7 +1104,7 @@ static int ds3000_initfe(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct dvb_frontend_ops ds3000_ops = {
+static const struct dvb_frontend_ops ds3000_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Montage Technology DS3000",
diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index 53089e1..735a966 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -739,7 +739,7 @@ static int dvb_pll_init(struct dvb_frontend *fe)
 	return -EINVAL;
 }
 
-static struct dvb_tuner_ops dvb_pll_tuner_ops = {
+static const struct dvb_tuner_ops dvb_pll_tuner_ops = {
 	.release = dvb_pll_release,
 	.sleep = dvb_pll_sleep,
 	.init = dvb_pll_init,
diff --git a/drivers/media/dvb-frontends/dvb_dummy_fe.c b/drivers/media/dvb-frontends/dvb_dummy_fe.c
index e5bd8c6..efc3c31 100644
--- a/drivers/media/dvb-frontends/dvb_dummy_fe.c
+++ b/drivers/media/dvb-frontends/dvb_dummy_fe.c
@@ -119,7 +119,7 @@ static void dvb_dummy_fe_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops dvb_dummy_fe_ofdm_ops;
+static const struct dvb_frontend_ops dvb_dummy_fe_ofdm_ops;
 
 struct dvb_frontend* dvb_dummy_fe_ofdm_attach(void)
 {
@@ -136,7 +136,7 @@ struct dvb_frontend* dvb_dummy_fe_ofdm_attach(void)
 	return &state->frontend;
 }
 
-static struct dvb_frontend_ops dvb_dummy_fe_qpsk_ops;
+static const struct dvb_frontend_ops dvb_dummy_fe_qpsk_ops;
 
 struct dvb_frontend *dvb_dummy_fe_qpsk_attach(void)
 {
@@ -153,7 +153,7 @@ struct dvb_frontend *dvb_dummy_fe_qpsk_attach(void)
 	return &state->frontend;
 }
 
-static struct dvb_frontend_ops dvb_dummy_fe_qam_ops;
+static const struct dvb_frontend_ops dvb_dummy_fe_qam_ops;
 
 struct dvb_frontend *dvb_dummy_fe_qam_attach(void)
 {
@@ -170,7 +170,7 @@ struct dvb_frontend *dvb_dummy_fe_qam_attach(void)
 	return &state->frontend;
 }
 
-static struct dvb_frontend_ops dvb_dummy_fe_ofdm_ops = {
+static const struct dvb_frontend_ops dvb_dummy_fe_ofdm_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Dummy DVB-T",
@@ -201,7 +201,7 @@ static struct dvb_frontend_ops dvb_dummy_fe_ofdm_ops = {
 	.read_ucblocks = dvb_dummy_fe_read_ucblocks,
 };
 
-static struct dvb_frontend_ops dvb_dummy_fe_qam_ops = {
+static const struct dvb_frontend_ops dvb_dummy_fe_qam_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name			= "Dummy DVB-C",
@@ -230,7 +230,7 @@ static struct dvb_frontend_ops dvb_dummy_fe_qam_ops = {
 	.read_ucblocks = dvb_dummy_fe_read_ucblocks,
 };
 
-static struct dvb_frontend_ops dvb_dummy_fe_qpsk_ops = {
+static const struct dvb_frontend_ops dvb_dummy_fe_qpsk_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Dummy DVB-S",
diff --git a/drivers/media/dvb-frontends/ec100.c b/drivers/media/dvb-frontends/ec100.c
index c9012e6..d97ce21 100644
--- a/drivers/media/dvb-frontends/ec100.c
+++ b/drivers/media/dvb-frontends/ec100.c
@@ -280,7 +280,7 @@ static void ec100_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops ec100_ops;
+static const struct dvb_frontend_ops ec100_ops;
 
 struct dvb_frontend *ec100_attach(const struct ec100_config *config,
 	struct i2c_adapter *i2c)
@@ -315,7 +315,7 @@ error:
 }
 EXPORT_SYMBOL(ec100_attach);
 
-static struct dvb_frontend_ops ec100_ops = {
+static const struct dvb_frontend_ops ec100_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "E3C EC100 DVB-T",
diff --git a/drivers/media/dvb-frontends/hd29l2.c b/drivers/media/dvb-frontends/hd29l2.c
index 1c7eb47..8b53633 100644
--- a/drivers/media/dvb-frontends/hd29l2.c
+++ b/drivers/media/dvb-frontends/hd29l2.c
@@ -793,7 +793,7 @@ static void hd29l2_release(struct dvb_frontend *fe)
 	kfree(priv);
 }
 
-static struct dvb_frontend_ops hd29l2_ops;
+static const struct dvb_frontend_ops hd29l2_ops;
 
 struct dvb_frontend *hd29l2_attach(const struct hd29l2_config *config,
 	struct i2c_adapter *i2c)
@@ -828,7 +828,7 @@ err:
 }
 EXPORT_SYMBOL(hd29l2_attach);
 
-static struct dvb_frontend_ops hd29l2_ops = {
+static const struct dvb_frontend_ops hd29l2_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "HDIC HD29L2 DMB-TH",
diff --git a/drivers/media/dvb-frontends/helene.c b/drivers/media/dvb-frontends/helene.c
index 97a8982..4cb0505 100644
--- a/drivers/media/dvb-frontends/helene.c
+++ b/drivers/media/dvb-frontends/helene.c
@@ -842,7 +842,7 @@ static int helene_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops helene_tuner_ops = {
+static const struct dvb_tuner_ops helene_tuner_ops = {
 	.info = {
 		.name = "Sony HELENE Ter tuner",
 		.frequency_min = 1000000,
@@ -856,7 +856,7 @@ static struct dvb_tuner_ops helene_tuner_ops = {
 	.get_frequency = helene_get_frequency,
 };
 
-static struct dvb_tuner_ops helene_tuner_ops_s = {
+static const struct dvb_tuner_ops helene_tuner_ops_s = {
 	.info = {
 		.name = "Sony HELENE Sat tuner",
 		.frequency_min = 500000,
diff --git a/drivers/media/dvb-frontends/horus3a.c b/drivers/media/dvb-frontends/horus3a.c
index a98bca5..0c089b5 100644
--- a/drivers/media/dvb-frontends/horus3a.c
+++ b/drivers/media/dvb-frontends/horus3a.c
@@ -326,7 +326,7 @@ static int horus3a_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops horus3a_tuner_ops = {
+static const struct dvb_tuner_ops horus3a_tuner_ops = {
 	.info = {
 		.name = "Sony Horus3a",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/ix2505v.c b/drivers/media/dvb-frontends/ix2505v.c
index 0e3387e..2826bbb 100644
--- a/drivers/media/dvb-frontends/ix2505v.c
+++ b/drivers/media/dvb-frontends/ix2505v.c
@@ -258,7 +258,7 @@ static int ix2505v_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops ix2505v_tuner_ops = {
+static const struct dvb_tuner_ops ix2505v_tuner_ops = {
 	.info = {
 		.name = "Sharp IX2505V (B0017)",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/l64781.c b/drivers/media/dvb-frontends/l64781.c
index 2f3d051..68923c8 100644
--- a/drivers/media/dvb-frontends/l64781.c
+++ b/drivers/media/dvb-frontends/l64781.c
@@ -496,7 +496,7 @@ static void l64781_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops l64781_ops;
+static const struct dvb_frontend_ops l64781_ops;
 
 struct dvb_frontend* l64781_attach(const struct l64781_config* config,
 				   struct i2c_adapter* i2c)
@@ -571,7 +571,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops l64781_ops = {
+static const struct dvb_frontend_ops l64781_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "LSI L64781 DVB-T",
diff --git a/drivers/media/dvb-frontends/lg2160.c b/drivers/media/dvb-frontends/lg2160.c
index f51a3a0..3b31e5f 100644
--- a/drivers/media/dvb-frontends/lg2160.c
+++ b/drivers/media/dvb-frontends/lg2160.c
@@ -1359,7 +1359,7 @@ static void lg216x_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops lg2160_ops = {
+static const struct dvb_frontend_ops lg2160_ops = {
 	.delsys = { SYS_ATSCMH },
 	.info = {
 		.name = "LG Electronics LG2160 ATSC/MH Frontend",
@@ -1387,7 +1387,7 @@ static struct dvb_frontend_ops lg2160_ops = {
 	.release              = lg216x_release,
 };
 
-static struct dvb_frontend_ops lg2161_ops = {
+static const struct dvb_frontend_ops lg2161_ops = {
 	.delsys = { SYS_ATSCMH },
 	.info = {
 		.name = "LG Electronics LG2161 ATSC/MH Frontend",
diff --git a/drivers/media/dvb-frontends/lgdt3305.c b/drivers/media/dvb-frontends/lgdt3305.c
index 4503e88..9f5d938 100644
--- a/drivers/media/dvb-frontends/lgdt3305.c
+++ b/drivers/media/dvb-frontends/lgdt3305.c
@@ -1103,8 +1103,8 @@ static void lgdt3305_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops lgdt3304_ops;
-static struct dvb_frontend_ops lgdt3305_ops;
+static const struct dvb_frontend_ops lgdt3304_ops;
+static const struct dvb_frontend_ops lgdt3305_ops;
 
 struct dvb_frontend *lgdt3305_attach(const struct lgdt3305_config *config,
 				     struct i2c_adapter *i2c_adap)
@@ -1164,7 +1164,7 @@ fail:
 }
 EXPORT_SYMBOL(lgdt3305_attach);
 
-static struct dvb_frontend_ops lgdt3304_ops = {
+static const struct dvb_frontend_ops lgdt3304_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "LG Electronics LGDT3304 VSB/QAM Frontend",
@@ -1187,7 +1187,7 @@ static struct dvb_frontend_ops lgdt3304_ops = {
 	.release              = lgdt3305_release,
 };
 
-static struct dvb_frontend_ops lgdt3305_ops = {
+static const struct dvb_frontend_ops lgdt3305_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "LG Electronics LGDT3305 VSB/QAM Frontend",
diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 179c26e..98ce182 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -1775,7 +1775,7 @@ static void lgdt3306a_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops lgdt3306a_ops;
+static const struct dvb_frontend_ops lgdt3306a_ops;
 
 struct dvb_frontend *lgdt3306a_attach(const struct lgdt3306a_config *config,
 				      struct i2c_adapter *i2c_adap)
@@ -2111,7 +2111,7 @@ static void lgdt3306a_DumpRegs(struct lgdt3306a_state *state)
 
 
 
-static struct dvb_frontend_ops lgdt3306a_ops = {
+static const struct dvb_frontend_ops lgdt3306a_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "LG Electronics LGDT3306A VSB/QAM Frontend",
diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index 96bf254..35b4772 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -729,8 +729,8 @@ static void lgdt330x_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops lgdt3302_ops;
-static struct dvb_frontend_ops lgdt3303_ops;
+static const struct dvb_frontend_ops lgdt3302_ops;
+static const struct dvb_frontend_ops lgdt3303_ops;
 
 struct dvb_frontend* lgdt330x_attach(const struct lgdt330x_config* config,
 				     struct i2c_adapter* i2c)
@@ -775,7 +775,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops lgdt3302_ops = {
+static const struct dvb_frontend_ops lgdt3302_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name= "LG Electronics LGDT3302 VSB/QAM Frontend",
@@ -798,7 +798,7 @@ static struct dvb_frontend_ops lgdt3302_ops = {
 	.release              = lgdt330x_release,
 };
 
-static struct dvb_frontend_ops lgdt3303_ops = {
+static const struct dvb_frontend_ops lgdt3303_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name= "LG Electronics LGDT3303 VSB/QAM Frontend",
diff --git a/drivers/media/dvb-frontends/lgs8gl5.c b/drivers/media/dvb-frontends/lgs8gl5.c
index fbfd87b..970e42f 100644
--- a/drivers/media/dvb-frontends/lgs8gl5.c
+++ b/drivers/media/dvb-frontends/lgs8gl5.c
@@ -376,7 +376,7 @@ lgs8gl5_release(struct dvb_frontend *fe)
 }
 
 
-static struct dvb_frontend_ops lgs8gl5_ops;
+static const struct dvb_frontend_ops lgs8gl5_ops;
 
 
 struct dvb_frontend*
@@ -412,7 +412,7 @@ error:
 EXPORT_SYMBOL(lgs8gl5_attach);
 
 
-static struct dvb_frontend_ops lgs8gl5_ops = {
+static const struct dvb_frontend_ops lgs8gl5_ops = {
 	.delsys = { SYS_DTMB },
 	.info = {
 		.name			= "Legend Silicon LGS-8GL5 DMB-TH",
diff --git a/drivers/media/dvb-frontends/lgs8gxx.c b/drivers/media/dvb-frontends/lgs8gxx.c
index 919daeb..6d2e624 100644
--- a/drivers/media/dvb-frontends/lgs8gxx.c
+++ b/drivers/media/dvb-frontends/lgs8gxx.c
@@ -985,7 +985,7 @@ static int lgs8gxx_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	return lgs8gxx_write_reg(priv, 0x01, 0);
 }
 
-static struct dvb_frontend_ops lgs8gxx_ops = {
+static const struct dvb_frontend_ops lgs8gxx_ops = {
 	.delsys = { SYS_DTMB },
 	.info = {
 		.name = "Legend Silicon LGS8913/LGS8GXX DMB-TH",
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index e0fe5bc..50bce68 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -16,7 +16,7 @@
 
 #include "m88ds3103_priv.h"
 
-static struct dvb_frontend_ops m88ds3103_ops;
+static const struct dvb_frontend_ops m88ds3103_ops;
 
 /* write single register with mask */
 static int m88ds3103_update_bits(struct m88ds3103_dev *dev,
@@ -1295,7 +1295,7 @@ struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *cfg,
 }
 EXPORT_SYMBOL(m88ds3103_attach);
 
-static struct dvb_frontend_ops m88ds3103_ops = {
+static const struct dvb_frontend_ops m88ds3103_ops = {
 	.delsys = {SYS_DVBS, SYS_DVBS2},
 	.info = {
 		.name = "Montage Technology M88DS3103",
diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index ef79a4e..5c94589 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -753,7 +753,7 @@ static void m88rs2000_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops m88rs2000_ops = {
+static const struct dvb_frontend_ops m88rs2000_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "M88RS2000 DVB-S",
diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
index 79bc671..9bb122c 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -1816,7 +1816,7 @@ static enum dvbfe_algo mb86a16_frontend_algo(struct dvb_frontend *fe)
 	return DVBFE_ALGO_CUSTOM;
 }
 
-static struct dvb_frontend_ops mb86a16_ops = {
+static const struct dvb_frontend_ops mb86a16_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Fujitsu MB86A16 DVB-S",
diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 4132532..caf9308 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -2058,7 +2058,7 @@ static void mb86a20s_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops mb86a20s_ops;
+static const struct dvb_frontend_ops mb86a20s_ops;
 
 struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 				    struct i2c_adapter *i2c)
@@ -2106,7 +2106,7 @@ error:
 }
 EXPORT_SYMBOL(mb86a20s_attach);
 
-static struct dvb_frontend_ops mb86a20s_ops = {
+static const struct dvb_frontend_ops mb86a20s_ops = {
 	.delsys = { SYS_ISDBT },
 	/* Use dib8000 values per default */
 	.info = {
diff --git a/drivers/media/dvb-frontends/mn88472.c b/drivers/media/dvb-frontends/mn88472.c
index 18fb2df..b6f5f83 100644
--- a/drivers/media/dvb-frontends/mn88472.c
+++ b/drivers/media/dvb-frontends/mn88472.c
@@ -411,7 +411,7 @@ err:
 	return ret;
 }
 
-static struct dvb_frontend_ops mn88472_ops = {
+static const struct dvb_frontend_ops mn88472_ops = {
 	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A},
 	.info = {
 		.name = "Panasonic MN88472",
diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c
index fc08429..f53ef10 100644
--- a/drivers/media/dvb-frontends/mt312.c
+++ b/drivers/media/dvb-frontends/mt312.c
@@ -748,7 +748,7 @@ static void mt312_release(struct dvb_frontend *fe)
 }
 
 #define MT312_SYS_CLK		90000000UL	/* 90 MHz */
-static struct dvb_frontend_ops mt312_ops = {
+static const struct dvb_frontend_ops mt312_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Zarlink ???? DVB-S",
diff --git a/drivers/media/dvb-frontends/mt352.c b/drivers/media/dvb-frontends/mt352.c
index c0bb632..48ea040 100644
--- a/drivers/media/dvb-frontends/mt352.c
+++ b/drivers/media/dvb-frontends/mt352.c
@@ -538,7 +538,7 @@ static void mt352_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops mt352_ops;
+static const struct dvb_frontend_ops mt352_ops;
 
 struct dvb_frontend* mt352_attach(const struct mt352_config* config,
 				  struct i2c_adapter* i2c)
@@ -566,7 +566,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops mt352_ops = {
+static const struct dvb_frontend_ops mt352_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Zarlink MT352 DVB-T",
diff --git a/drivers/media/dvb-frontends/nxt200x.c b/drivers/media/dvb-frontends/nxt200x.c
index 79c3040..9df76b9 100644
--- a/drivers/media/dvb-frontends/nxt200x.c
+++ b/drivers/media/dvb-frontends/nxt200x.c
@@ -1150,7 +1150,7 @@ static void nxt200x_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops nxt200x_ops;
+static const struct dvb_frontend_ops nxt200x_ops;
 
 struct dvb_frontend* nxt200x_attach(const struct nxt200x_config* config,
 				   struct i2c_adapter* i2c)
@@ -1213,7 +1213,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops nxt200x_ops = {
+static const struct dvb_frontend_ops nxt200x_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "Nextwave NXT200X VSB/QAM frontend",
diff --git a/drivers/media/dvb-frontends/nxt6000.c b/drivers/media/dvb-frontends/nxt6000.c
index 73f9505..e00c78a 100644
--- a/drivers/media/dvb-frontends/nxt6000.c
+++ b/drivers/media/dvb-frontends/nxt6000.c
@@ -548,7 +548,7 @@ static int nxt6000_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
 	}
 }
 
-static struct dvb_frontend_ops nxt6000_ops;
+static const struct dvb_frontend_ops nxt6000_ops;
 
 struct dvb_frontend* nxt6000_attach(const struct nxt6000_config* config,
 				    struct i2c_adapter* i2c)
@@ -576,7 +576,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops nxt6000_ops = {
+static const struct dvb_frontend_ops nxt6000_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "NxtWave NXT6000 DVB-T",
diff --git a/drivers/media/dvb-frontends/or51132.c b/drivers/media/dvb-frontends/or51132.c
index a165af9..b8b7b30 100644
--- a/drivers/media/dvb-frontends/or51132.c
+++ b/drivers/media/dvb-frontends/or51132.c
@@ -561,7 +561,7 @@ static void or51132_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops or51132_ops;
+static const struct dvb_frontend_ops or51132_ops;
 
 struct dvb_frontend* or51132_attach(const struct or51132_config* config,
 				    struct i2c_adapter* i2c)
@@ -585,7 +585,7 @@ struct dvb_frontend* or51132_attach(const struct or51132_config* config,
 	return &state->frontend;
 }
 
-static struct dvb_frontend_ops or51132_ops = {
+static const struct dvb_frontend_ops or51132_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Oren OR51132 VSB/QAM Frontend",
diff --git a/drivers/media/dvb-frontends/or51211.c b/drivers/media/dvb-frontends/or51211.c
index e82413b..94d643d 100644
--- a/drivers/media/dvb-frontends/or51211.c
+++ b/drivers/media/dvb-frontends/or51211.c
@@ -508,7 +508,7 @@ static void or51211_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops or51211_ops;
+static const struct dvb_frontend_ops or51211_ops;
 
 struct dvb_frontend* or51211_attach(const struct or51211_config* config,
 				    struct i2c_adapter* i2c)
@@ -532,7 +532,7 @@ struct dvb_frontend* or51211_attach(const struct or51211_config* config,
 	return &state->frontend;
 }
 
-static struct dvb_frontend_ops or51211_ops = {
+static const struct dvb_frontend_ops or51211_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name               = "Oren OR51211 VSB Frontend",
diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 8722605..7bbfe11 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -548,7 +548,7 @@ static int rtl2830_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	return 0;
 }
 
-static struct dvb_frontend_ops rtl2830_ops = {
+static const struct dvb_frontend_ops rtl2830_ops = {
 	.delsys = {SYS_DVBT},
 	.info = {
 		.name = "Realtek RTL2830 (DVB-T)",
diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 0ced01f..94bf5b7 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -837,7 +837,7 @@ static int rtl2832_deselect(struct i2c_mux_core *muxc, u32 chan_id)
 	return 0;
 }
 
-static struct dvb_frontend_ops rtl2832_ops = {
+static const struct dvb_frontend_ops rtl2832_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Realtek RTL2832 (DVB-T)",
diff --git a/drivers/media/dvb-frontends/s5h1409.c b/drivers/media/dvb-frontends/s5h1409.c
index c68965a..72d70b7 100644
--- a/drivers/media/dvb-frontends/s5h1409.c
+++ b/drivers/media/dvb-frontends/s5h1409.c
@@ -949,7 +949,7 @@ static void s5h1409_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops s5h1409_ops;
+static const struct dvb_frontend_ops s5h1409_ops;
 
 struct dvb_frontend *s5h1409_attach(const struct s5h1409_config *config,
 				    struct i2c_adapter *i2c)
@@ -995,7 +995,7 @@ error:
 }
 EXPORT_SYMBOL(s5h1409_attach);
 
-static struct dvb_frontend_ops s5h1409_ops = {
+static const struct dvb_frontend_ops s5h1409_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Samsung S5H1409 QAM/8VSB Frontend",
diff --git a/drivers/media/dvb-frontends/s5h1411.c b/drivers/media/dvb-frontends/s5h1411.c
index 90f86e8..14bf7e6 100644
--- a/drivers/media/dvb-frontends/s5h1411.c
+++ b/drivers/media/dvb-frontends/s5h1411.c
@@ -864,7 +864,7 @@ static void s5h1411_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops s5h1411_ops;
+static const struct dvb_frontend_ops s5h1411_ops;
 
 struct dvb_frontend *s5h1411_attach(const struct s5h1411_config *config,
 				    struct i2c_adapter *i2c)
@@ -914,7 +914,7 @@ error:
 }
 EXPORT_SYMBOL(s5h1411_attach);
 
-static struct dvb_frontend_ops s5h1411_ops = {
+static const struct dvb_frontend_ops s5h1411_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Samsung S5H1411 QAM/8VSB Frontend",
diff --git a/drivers/media/dvb-frontends/s5h1420.c b/drivers/media/dvb-frontends/s5h1420.c
index d7d0b7d..f9a18fe 100644
--- a/drivers/media/dvb-frontends/s5h1420.c
+++ b/drivers/media/dvb-frontends/s5h1420.c
@@ -880,7 +880,7 @@ struct i2c_adapter *s5h1420_get_tuner_i2c_adapter(struct dvb_frontend *fe)
 }
 EXPORT_SYMBOL(s5h1420_get_tuner_i2c_adapter);
 
-static struct dvb_frontend_ops s5h1420_ops;
+static const struct dvb_frontend_ops s5h1420_ops;
 
 struct dvb_frontend *s5h1420_attach(const struct s5h1420_config *config,
 				    struct i2c_adapter *i2c)
@@ -934,7 +934,7 @@ error:
 }
 EXPORT_SYMBOL(s5h1420_attach);
 
-static struct dvb_frontend_ops s5h1420_ops = {
+static const struct dvb_frontend_ops s5h1420_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name     = "Samsung S5H1420/PnpNetwork PN1010 DVB-S",
diff --git a/drivers/media/dvb-frontends/s5h1432.c b/drivers/media/dvb-frontends/s5h1432.c
index 4215652..97b9954 100644
--- a/drivers/media/dvb-frontends/s5h1432.c
+++ b/drivers/media/dvb-frontends/s5h1432.c
@@ -341,7 +341,7 @@ static void s5h1432_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops s5h1432_ops;
+static const struct dvb_frontend_ops s5h1432_ops;
 
 struct dvb_frontend *s5h1432_attach(const struct s5h1432_config *config,
 				    struct i2c_adapter *i2c)
@@ -370,7 +370,7 @@ struct dvb_frontend *s5h1432_attach(const struct s5h1432_config *config,
 }
 EXPORT_SYMBOL(s5h1432_attach);
 
-static struct dvb_frontend_ops s5h1432_ops = {
+static const struct dvb_frontend_ops s5h1432_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "Samsung s5h1432 DVB-T Frontend",
diff --git a/drivers/media/dvb-frontends/s921.c b/drivers/media/dvb-frontends/s921.c
index b5e3d90..d843455 100644
--- a/drivers/media/dvb-frontends/s921.c
+++ b/drivers/media/dvb-frontends/s921.c
@@ -477,7 +477,7 @@ static void s921_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops s921_ops;
+static const struct dvb_frontend_ops s921_ops;
 
 struct dvb_frontend *s921_attach(const struct s921_config *config,
 				    struct i2c_adapter *i2c)
@@ -505,7 +505,7 @@ struct dvb_frontend *s921_attach(const struct s921_config *config,
 }
 EXPORT_SYMBOL(s921_attach);
 
-static struct dvb_frontend_ops s921_ops = {
+static const struct dvb_frontend_ops s921_ops = {
 	.delsys = { SYS_ISDBT },
 	/* Use dib8000 values per default */
 	.info = {
diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 8bf716a..b005cf9 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -1011,7 +1011,7 @@ static void si2165_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops si2165_ops = {
+static const struct dvb_frontend_ops si2165_ops = {
 	.info = {
 		.name = "Silicon Labs ",
 		 /* For DVB-C */
diff --git a/drivers/media/dvb-frontends/si21xx.c b/drivers/media/dvb-frontends/si21xx.c
index 62ad7a7..6c11f10 100644
--- a/drivers/media/dvb-frontends/si21xx.c
+++ b/drivers/media/dvb-frontends/si21xx.c
@@ -866,7 +866,7 @@ static void si21xx_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops si21xx_ops = {
+static const struct dvb_frontend_ops si21xx_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "SL SI21XX DVB-S",
diff --git a/drivers/media/dvb-frontends/sp8870.c b/drivers/media/dvb-frontends/sp8870.c
index e87ac30..04454cb78 100644
--- a/drivers/media/dvb-frontends/sp8870.c
+++ b/drivers/media/dvb-frontends/sp8870.c
@@ -551,7 +551,7 @@ static void sp8870_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops sp8870_ops;
+static const struct dvb_frontend_ops sp8870_ops;
 
 struct dvb_frontend* sp8870_attach(const struct sp8870_config* config,
 				   struct i2c_adapter* i2c)
@@ -580,7 +580,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops sp8870_ops = {
+static const struct dvb_frontend_ops sp8870_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Spase SP8870 DVB-T",
diff --git a/drivers/media/dvb-frontends/sp887x.c b/drivers/media/dvb-frontends/sp887x.c
index 4378fe1..fff1ca4 100644
--- a/drivers/media/dvb-frontends/sp887x.c
+++ b/drivers/media/dvb-frontends/sp887x.c
@@ -562,7 +562,7 @@ static void sp887x_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops sp887x_ops;
+static const struct dvb_frontend_ops sp887x_ops;
 
 struct dvb_frontend* sp887x_attach(const struct sp887x_config* config,
 				   struct i2c_adapter* i2c)
@@ -591,7 +591,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops sp887x_ops = {
+static const struct dvb_frontend_ops sp887x_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Spase SP887x DVB-T",
diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
index 3d171b0..1d34e95 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.c
+++ b/drivers/media/dvb-frontends/stb0899_drv.c
@@ -1586,7 +1586,7 @@ static enum dvbfe_algo stb0899_frontend_algo(struct dvb_frontend *fe)
 	return DVBFE_ALGO_CUSTOM;
 }
 
-static struct dvb_frontend_ops stb0899_ops = {
+static const struct dvb_frontend_ops stb0899_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name 			= "STB0899 Multistandard",
diff --git a/drivers/media/dvb-frontends/stb6000.c b/drivers/media/dvb-frontends/stb6000.c
index a0c3c52..73347d5 100644
--- a/drivers/media/dvb-frontends/stb6000.c
+++ b/drivers/media/dvb-frontends/stb6000.c
@@ -186,7 +186,7 @@ static int stb6000_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops stb6000_tuner_ops = {
+static const struct dvb_tuner_ops stb6000_tuner_ops = {
 	.info = {
 		.name = "ST STB6000",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
index b9c2511..5add118 100644
--- a/drivers/media/dvb-frontends/stb6100.c
+++ b/drivers/media/dvb-frontends/stb6100.c
@@ -522,7 +522,7 @@ static int stb6100_set_params(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct dvb_tuner_ops stb6100_ops = {
+static const struct dvb_tuner_ops stb6100_ops = {
 	.info = {
 		.name			= "STB6100 Silicon Tuner",
 		.frequency_min		= 950000,
diff --git a/drivers/media/dvb-frontends/stv0288.c b/drivers/media/dvb-frontends/stv0288.c
index c93d9a4..2fed47b 100644
--- a/drivers/media/dvb-frontends/stv0288.c
+++ b/drivers/media/dvb-frontends/stv0288.c
@@ -536,7 +536,7 @@ static void stv0288_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops stv0288_ops = {
+static const struct dvb_frontend_ops stv0288_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "ST STV0288 DVB-S",
diff --git a/drivers/media/dvb-frontends/stv0297.c b/drivers/media/dvb-frontends/stv0297.c
index 81b27b7..0529b1e 100644
--- a/drivers/media/dvb-frontends/stv0297.c
+++ b/drivers/media/dvb-frontends/stv0297.c
@@ -658,7 +658,7 @@ static void stv0297_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops stv0297_ops;
+static const struct dvb_frontend_ops stv0297_ops;
 
 struct dvb_frontend *stv0297_attach(const struct stv0297_config *config,
 				    struct i2c_adapter *i2c)
@@ -690,7 +690,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops stv0297_ops = {
+static const struct dvb_frontend_ops stv0297_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		 .name = "ST STV0297 DVB-C",
diff --git a/drivers/media/dvb-frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
index 7927fa9..e1dc5c5 100644
--- a/drivers/media/dvb-frontends/stv0299.c
+++ b/drivers/media/dvb-frontends/stv0299.c
@@ -673,7 +673,7 @@ static void stv0299_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops stv0299_ops;
+static const struct dvb_frontend_ops stv0299_ops;
 
 struct dvb_frontend* stv0299_attach(const struct stv0299_config* config,
 				    struct i2c_adapter* i2c)
@@ -713,7 +713,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops stv0299_ops = {
+static const struct dvb_frontend_ops stv0299_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "ST STV0299 DVB-S",
diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index abc379a..4ac1ce2 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -2272,7 +2272,7 @@ static void stv0367_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops stv0367ter_ops = {
+static const struct dvb_frontend_ops stv0367ter_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "ST STV0367 DVB-T",
@@ -3390,7 +3390,7 @@ static int stv0367cab_read_ucblcks(struct dvb_frontend *fe, u32 *ucblocks)
 	return 0;
 };
 
-static struct dvb_frontend_ops stv0367cab_ops = {
+static const struct dvb_frontend_ops stv0367cab_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name = "ST STV0367 DVB-C",
diff --git a/drivers/media/dvb-frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
index f667005..43a0f69 100644
--- a/drivers/media/dvb-frontends/stv0900_core.c
+++ b/drivers/media/dvb-frontends/stv0900_core.c
@@ -1875,7 +1875,7 @@ static int stv0900_get_frontend(struct dvb_frontend *fe,
 	return 0;
 }
 
-static struct dvb_frontend_ops stv0900_ops = {
+static const struct dvb_frontend_ops stv0900_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name			= "STV0900 frontend",
diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index 25bdf6e..0e834aa 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -4886,7 +4886,7 @@ static int stv090x_set_gpio(struct dvb_frontend *fe, u8 gpio, u8 dir,
 	return stv090x_write_reg(state, STV090x_GPIOxCFG(gpio), reg);
 }
 
-static struct dvb_frontend_ops stv090x_ops = {
+static const struct dvb_frontend_ops stv090x_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name			= "STV090x Multistandard",
diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
index 91c6dcf..66a5a7f 100644
--- a/drivers/media/dvb-frontends/stv6110.c
+++ b/drivers/media/dvb-frontends/stv6110.c
@@ -382,7 +382,7 @@ static int stv6110_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 	return 0;
 }
 
-static struct dvb_tuner_ops stv6110_tuner_ops = {
+static const struct dvb_tuner_ops stv6110_tuner_ops = {
 	.info = {
 		.name = "ST STV6110",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/stv6110x.c b/drivers/media/dvb-frontends/stv6110x.c
index a62c01e..c611ad2 100644
--- a/drivers/media/dvb-frontends/stv6110x.c
+++ b/drivers/media/dvb-frontends/stv6110x.c
@@ -345,7 +345,7 @@ static int stv6110x_release(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct dvb_tuner_ops stv6110x_ops = {
+static const struct dvb_tuner_ops stv6110x_ops = {
 	.info = {
 		.name		= "STV6110(A) Silicon Tuner",
 		.frequency_min	=  950000,
diff --git a/drivers/media/dvb-frontends/tda10021.c b/drivers/media/dvb-frontends/tda10021.c
index 806c566..3556933 100644
--- a/drivers/media/dvb-frontends/tda10021.c
+++ b/drivers/media/dvb-frontends/tda10021.c
@@ -444,7 +444,7 @@ static void tda10021_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops tda10021_ops;
+static const struct dvb_frontend_ops tda10021_ops;
 
 struct dvb_frontend* tda10021_attach(const struct tda1002x_config* config,
 				     struct i2c_adapter* i2c,
@@ -484,7 +484,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops tda10021_ops = {
+static const struct dvb_frontend_ops tda10021_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBC_ANNEX_C },
 	.info = {
 		.name = "Philips TDA10021 DVB-C",
diff --git a/drivers/media/dvb-frontends/tda10023.c b/drivers/media/dvb-frontends/tda10023.c
index 3b8c7e4..2874581 100644
--- a/drivers/media/dvb-frontends/tda10023.c
+++ b/drivers/media/dvb-frontends/tda10023.c
@@ -516,7 +516,7 @@ static void tda10023_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops tda10023_ops;
+static const struct dvb_frontend_ops tda10023_ops;
 
 struct dvb_frontend *tda10023_attach(const struct tda10023_config *config,
 				     struct i2c_adapter *i2c,
@@ -573,7 +573,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops tda10023_ops = {
+static const struct dvb_frontend_ops tda10023_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBC_ANNEX_C },
 	.info = {
 		.name = "Philips TDA10023 DVB-C",
diff --git a/drivers/media/dvb-frontends/tda10048.c b/drivers/media/dvb-frontends/tda10048.c
index c2bf89d..285c39c 100644
--- a/drivers/media/dvb-frontends/tda10048.c
+++ b/drivers/media/dvb-frontends/tda10048.c
@@ -1094,7 +1094,7 @@ static void tda10048_establish_defaults(struct dvb_frontend *fe)
 	}
 }
 
-static struct dvb_frontend_ops tda10048_ops;
+static const struct dvb_frontend_ops tda10048_ops;
 
 struct dvb_frontend *tda10048_attach(const struct tda10048_config *config,
 	struct i2c_adapter *i2c)
@@ -1156,7 +1156,7 @@ error:
 }
 EXPORT_SYMBOL(tda10048_attach);
 
-static struct dvb_frontend_ops tda10048_ops = {
+static const struct dvb_frontend_ops tda10048_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "NXP TDA10048HN DVB-T",
diff --git a/drivers/media/dvb-frontends/tda1004x.c b/drivers/media/dvb-frontends/tda1004x.c
index b898483..e674508 100644
--- a/drivers/media/dvb-frontends/tda1004x.c
+++ b/drivers/media/dvb-frontends/tda1004x.c
@@ -1245,7 +1245,7 @@ static void tda1004x_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops tda10045_ops = {
+static const struct dvb_frontend_ops tda10045_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Philips TDA10045H DVB-T",
@@ -1315,7 +1315,7 @@ struct dvb_frontend* tda10045_attach(const struct tda1004x_config* config,
 	return &state->frontend;
 }
 
-static struct dvb_frontend_ops tda10046_ops = {
+static const struct dvb_frontend_ops tda10046_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Philips TDA10046H DVB-T",
diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 37ebeef2..a59f4fd 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -20,7 +20,7 @@
 
 #include "tda10071_priv.h"
 
-static struct dvb_frontend_ops tda10071_ops;
+static const struct dvb_frontend_ops tda10071_ops;
 
 /*
  * XXX: regmap_update_bits() does not fit our needs as it does not support
@@ -1102,7 +1102,7 @@ static int tda10071_get_tune_settings(struct dvb_frontend *fe,
 	return 0;
 }
 
-static struct dvb_frontend_ops tda10071_ops = {
+static const struct dvb_frontend_ops tda10071_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "NXP TDA10071",
diff --git a/drivers/media/dvb-frontends/tda10086.c b/drivers/media/dvb-frontends/tda10086.c
index 31d0acb..b6d16c0 100644
--- a/drivers/media/dvb-frontends/tda10086.c
+++ b/drivers/media/dvb-frontends/tda10086.c
@@ -706,7 +706,7 @@ static void tda10086_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops tda10086_ops = {
+static const struct dvb_frontend_ops tda10086_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name     = "Philips TDA10086 DVB-S",
diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
index de0a1c1..bc247f9 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.c
+++ b/drivers/media/dvb-frontends/tda18271c2dd.c
@@ -1217,7 +1217,7 @@ static int get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 }
 
 
-static struct dvb_tuner_ops tuner_ops = {
+static const struct dvb_tuner_ops tuner_ops = {
 	.info = {
 		.name = "NXP TDA18271C2D",
 		.frequency_min  =  47125000,
diff --git a/drivers/media/dvb-frontends/tda665x.c b/drivers/media/dvb-frontends/tda665x.c
index 82f8cc5..7ca9659 100644
--- a/drivers/media/dvb-frontends/tda665x.c
+++ b/drivers/media/dvb-frontends/tda665x.c
@@ -206,7 +206,7 @@ static int tda665x_release(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct dvb_tuner_ops tda665x_ops = {
+static const struct dvb_tuner_ops tda665x_ops = {
 	.get_status	= tda665x_get_status,
 	.set_params	= tda665x_set_params,
 	.get_frequency	= tda665x_get_frequency,
diff --git a/drivers/media/dvb-frontends/tda8083.c b/drivers/media/dvb-frontends/tda8083.c
index 9072d64..aa3200d 100644
--- a/drivers/media/dvb-frontends/tda8083.c
+++ b/drivers/media/dvb-frontends/tda8083.c
@@ -421,7 +421,7 @@ static void tda8083_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops tda8083_ops;
+static const struct dvb_frontend_ops tda8083_ops;
 
 struct dvb_frontend* tda8083_attach(const struct tda8083_config* config,
 				    struct i2c_adapter* i2c)
@@ -449,7 +449,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops tda8083_ops = {
+static const struct dvb_frontend_ops tda8083_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Philips TDA8083 DVB-S",
diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
index 3285b1b..e0df931 100644
--- a/drivers/media/dvb-frontends/tda8261.c
+++ b/drivers/media/dvb-frontends/tda8261.c
@@ -161,7 +161,7 @@ static int tda8261_release(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct dvb_tuner_ops tda8261_ops = {
+static const struct dvb_tuner_ops tda8261_ops = {
 
 	.info = {
 		.name		= "TDA8261",
diff --git a/drivers/media/dvb-frontends/tda826x.c b/drivers/media/dvb-frontends/tda826x.c
index 04bbcc2..2ec671d 100644
--- a/drivers/media/dvb-frontends/tda826x.c
+++ b/drivers/media/dvb-frontends/tda826x.c
@@ -129,7 +129,7 @@ static int tda826x_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops tda826x_tuner_ops = {
+static const struct dvb_tuner_ops tda826x_tuner_ops = {
 	.info = {
 		.name = "Philips TDA826X",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 14b410f..a9f6bbe 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -496,7 +496,7 @@ static int ts2020_read_signal_strength(struct dvb_frontend *fe,
 	return 0;
 }
 
-static struct dvb_tuner_ops ts2020_tuner_ops = {
+static const struct dvb_tuner_ops ts2020_tuner_ops = {
 	.info = {
 		.name = "TS2020",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/tua6100.c b/drivers/media/dvb-frontends/tua6100.c
index 029384d..6da12b9 100644
--- a/drivers/media/dvb-frontends/tua6100.c
+++ b/drivers/media/dvb-frontends/tua6100.c
@@ -157,7 +157,7 @@ static int tua6100_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops tua6100_tuner_ops = {
+static const struct dvb_tuner_ops tua6100_tuner_ops = {
 	.info = {
 		.name = "Infineon TUA6100",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/ves1820.c b/drivers/media/dvb-frontends/ves1820.c
index b09fe88..23787a9 100644
--- a/drivers/media/dvb-frontends/ves1820.c
+++ b/drivers/media/dvb-frontends/ves1820.c
@@ -369,7 +369,7 @@ static void ves1820_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops ves1820_ops;
+static const struct dvb_frontend_ops ves1820_ops;
 
 struct dvb_frontend* ves1820_attach(const struct ves1820_config* config,
 				    struct i2c_adapter* i2c,
@@ -408,7 +408,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops ves1820_ops = {
+static const struct dvb_frontend_ops ves1820_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name = "VLSI VES1820 DVB-C",
diff --git a/drivers/media/dvb-frontends/ves1x93.c b/drivers/media/dvb-frontends/ves1x93.c
index ed113e2..d0ee52f 100644
--- a/drivers/media/dvb-frontends/ves1x93.c
+++ b/drivers/media/dvb-frontends/ves1x93.c
@@ -454,7 +454,7 @@ static int ves1x93_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
 	}
 }
 
-static struct dvb_frontend_ops ves1x93_ops;
+static const struct dvb_frontend_ops ves1x93_ops;
 
 struct dvb_frontend* ves1x93_attach(const struct ves1x93_config* config,
 				    struct i2c_adapter* i2c)
@@ -512,7 +512,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops ves1x93_ops = {
+static const struct dvb_frontend_ops ves1x93_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "VLSI VES1x93 DVB-S",
diff --git a/drivers/media/dvb-frontends/zl10036.c b/drivers/media/dvb-frontends/zl10036.c
index 0903d46..7ed8131 100644
--- a/drivers/media/dvb-frontends/zl10036.c
+++ b/drivers/media/dvb-frontends/zl10036.c
@@ -446,7 +446,7 @@ static int zl10036_init(struct dvb_frontend *fe)
 	return ret;
 }
 
-static struct dvb_tuner_ops zl10036_tuner_ops = {
+static const struct dvb_tuner_ops zl10036_tuner_ops = {
 	.info = {
 		.name = "Zarlink ZL10036",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/zl10039.c b/drivers/media/dvb-frontends/zl10039.c
index ee09ec2..f8c271b 100644
--- a/drivers/media/dvb-frontends/zl10039.c
+++ b/drivers/media/dvb-frontends/zl10039.c
@@ -255,7 +255,7 @@ static int zl10039_release(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct dvb_tuner_ops zl10039_ops = {
+static const struct dvb_tuner_ops zl10039_ops = {
 	.release = zl10039_release,
 	.init = zl10039_init,
 	.sleep = zl10039_sleep,
diff --git a/drivers/media/dvb-frontends/zl10353.c b/drivers/media/dvb-frontends/zl10353.c
index 3b08176..4f3ff3e 100644
--- a/drivers/media/dvb-frontends/zl10353.c
+++ b/drivers/media/dvb-frontends/zl10353.c
@@ -602,7 +602,7 @@ static void zl10353_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops zl10353_ops;
+static const struct dvb_frontend_ops zl10353_ops;
 
 struct dvb_frontend *zl10353_attach(const struct zl10353_config *config,
 				    struct i2c_adapter *i2c)
@@ -634,7 +634,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops zl10353_ops = {
+static const struct dvb_frontend_ops zl10353_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Zarlink ZL10353 DVB-T",
diff --git a/drivers/media/pci/bt8xx/dst.c b/drivers/media/pci/bt8xx/dst.c
index 35bc9b2..b3a973f 100644
--- a/drivers/media/pci/bt8xx/dst.c
+++ b/drivers/media/pci/bt8xx/dst.c
@@ -1722,10 +1722,10 @@ static void bt8xx_dst_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops dst_dvbt_ops;
-static struct dvb_frontend_ops dst_dvbs_ops;
-static struct dvb_frontend_ops dst_dvbc_ops;
-static struct dvb_frontend_ops dst_atsc_ops;
+static const struct dvb_frontend_ops dst_dvbt_ops;
+static const struct dvb_frontend_ops dst_dvbs_ops;
+static const struct dvb_frontend_ops dst_dvbc_ops;
+static const struct dvb_frontend_ops dst_atsc_ops;
 
 struct dst_state *dst_attach(struct dst_state *state, struct dvb_adapter *dvb_adapter)
 {
@@ -1761,7 +1761,7 @@ struct dst_state *dst_attach(struct dst_state *state, struct dvb_adapter *dvb_ad
 
 EXPORT_SYMBOL(dst_attach);
 
-static struct dvb_frontend_ops dst_dvbt_ops = {
+static const struct dvb_frontend_ops dst_dvbt_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "DST DVB-T",
@@ -1790,7 +1790,7 @@ static struct dvb_frontend_ops dst_dvbt_ops = {
 	.read_snr = dst_read_snr,
 };
 
-static struct dvb_frontend_ops dst_dvbs_ops = {
+static const struct dvb_frontend_ops dst_dvbs_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "DST DVB-S",
@@ -1819,7 +1819,7 @@ static struct dvb_frontend_ops dst_dvbs_ops = {
 	.set_tone = dst_set_tone,
 };
 
-static struct dvb_frontend_ops dst_dvbc_ops = {
+static const struct dvb_frontend_ops dst_dvbc_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name = "DST DVB-C",
@@ -1848,7 +1848,7 @@ static struct dvb_frontend_ops dst_dvbc_ops = {
 	.read_snr = dst_read_snr,
 };
 
-static struct dvb_frontend_ops dst_atsc_ops = {
+static const struct dvb_frontend_ops dst_atsc_ops = {
 	.delsys = { SYS_ATSC },
 	.info = {
 		.name = "DST ATSC",
diff --git a/drivers/media/pci/pt1/va1j5jf8007s.c b/drivers/media/pci/pt1/va1j5jf8007s.c
index d0e70dc0..249273b 100644
--- a/drivers/media/pci/pt1/va1j5jf8007s.c
+++ b/drivers/media/pci/pt1/va1j5jf8007s.c
@@ -578,7 +578,7 @@ static void va1j5jf8007s_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops va1j5jf8007s_ops = {
+static const struct dvb_frontend_ops va1j5jf8007s_ops = {
 	.delsys = { SYS_ISDBS },
 	.info = {
 		.name = "VA1J5JF8007/VA1J5JF8011 ISDB-S",
diff --git a/drivers/media/pci/pt1/va1j5jf8007t.c b/drivers/media/pci/pt1/va1j5jf8007t.c
index 0268f20..e0766e6 100644
--- a/drivers/media/pci/pt1/va1j5jf8007t.c
+++ b/drivers/media/pci/pt1/va1j5jf8007t.c
@@ -427,7 +427,7 @@ static void va1j5jf8007t_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops va1j5jf8007t_ops = {
+static const struct dvb_frontend_ops va1j5jf8007t_ops = {
 	.delsys = { SYS_ISDBT },
 	.info = {
 		.name = "VA1J5JF8007/VA1J5JF8011 ISDB-T",
diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index 7f0b9d5..dfec237 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -2201,7 +2201,7 @@ static int mt2063_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
 	return 0;
 }
 
-static struct dvb_tuner_ops mt2063_ops = {
+static const struct dvb_tuner_ops mt2063_ops = {
 	.info = {
 		 .name = "MT2063 Silicon Tuner",
 		 .frequency_min = 45000000,
diff --git a/drivers/media/tuners/mt20xx.c b/drivers/media/tuners/mt20xx.c
index 9e03104..52da467 100644
--- a/drivers/media/tuners/mt20xx.c
+++ b/drivers/media/tuners/mt20xx.c
@@ -363,7 +363,7 @@ static int mt2032_set_params(struct dvb_frontend *fe,
 	return ret;
 }
 
-static struct dvb_tuner_ops mt2032_tuner_ops = {
+static const struct dvb_tuner_ops mt2032_tuner_ops = {
 	.set_analog_params = mt2032_set_params,
 	.release           = microtune_release,
 	.get_frequency     = microtune_get_frequency,
@@ -563,7 +563,7 @@ static int mt2050_set_params(struct dvb_frontend *fe,
 	return ret;
 }
 
-static struct dvb_tuner_ops mt2050_tuner_ops = {
+static const struct dvb_tuner_ops mt2050_tuner_ops = {
 	.set_analog_params = mt2050_set_params,
 	.release           = microtune_release,
 	.get_frequency     = microtune_get_frequency,
diff --git a/drivers/media/tuners/mxl5007t.c b/drivers/media/tuners/mxl5007t.c
index f4ae04c..42569c6 100644
--- a/drivers/media/tuners/mxl5007t.c
+++ b/drivers/media/tuners/mxl5007t.c
@@ -794,7 +794,7 @@ static int mxl5007t_release(struct dvb_frontend *fe)
 
 /* ------------------------------------------------------------------------- */
 
-static struct dvb_tuner_ops mxl5007t_tuner_ops = {
+static const struct dvb_tuner_ops mxl5007t_tuner_ops = {
 	.info = {
 		.name = "MaxLinear MxL5007T",
 	},
diff --git a/drivers/media/tuners/tda827x.c b/drivers/media/tuners/tda827x.c
index edcb4a7..5050ce9 100644
--- a/drivers/media/tuners/tda827x.c
+++ b/drivers/media/tuners/tda827x.c
@@ -818,7 +818,7 @@ static int tda827x_initial_sleep(struct dvb_frontend *fe)
 	return fe->ops.tuner_ops.sleep(fe);
 }
 
-static struct dvb_tuner_ops tda827xo_tuner_ops = {
+static const struct dvb_tuner_ops tda827xo_tuner_ops = {
 	.info = {
 		.name = "Philips TDA827X",
 		.frequency_min  =  55000000,
@@ -834,7 +834,7 @@ static struct dvb_tuner_ops tda827xo_tuner_ops = {
 	.get_bandwidth = tda827x_get_bandwidth,
 };
 
-static struct dvb_tuner_ops tda827xa_tuner_ops = {
+static const struct dvb_tuner_ops tda827xa_tuner_ops = {
 	.info = {
 		.name = "Philips TDA827XA",
 		.frequency_min  =  44000000,
diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
index 998e82b..273556d 100644
--- a/drivers/media/tuners/tda8290.c
+++ b/drivers/media/tuners/tda8290.c
@@ -721,7 +721,7 @@ static int tda8295_probe(struct tuner_i2c_props *i2c_props)
 	return -ENODEV;
 }
 
-static struct analog_demod_ops tda8290_ops = {
+static const struct analog_demod_ops tda8290_ops = {
 	.set_params     = tda8290_set_params,
 	.has_signal     = tda8290_has_signal,
 	.standby        = tda8290_standby,
@@ -729,7 +729,7 @@ static struct analog_demod_ops tda8290_ops = {
 	.i2c_gate_ctrl  = tda8290_i2c_bridge,
 };
 
-static struct analog_demod_ops tda8295_ops = {
+static const struct analog_demod_ops tda8295_ops = {
 	.set_params     = tda8295_set_params,
 	.has_signal     = tda8295_has_signal,
 	.standby        = tda8295_standby,
diff --git a/drivers/media/tuners/tda9887.c b/drivers/media/tuners/tda9887.c
index 56be6c2..c0e815f 100644
--- a/drivers/media/tuners/tda9887.c
+++ b/drivers/media/tuners/tda9887.c
@@ -659,7 +659,7 @@ static void tda9887_release(struct dvb_frontend *fe)
 	fe->analog_demod_priv = NULL;
 }
 
-static struct analog_demod_ops tda9887_ops = {
+static const struct analog_demod_ops tda9887_ops = {
 	.info		= {
 		.name	= "tda9887",
 	},
diff --git a/drivers/media/tuners/tea5761.c b/drivers/media/tuners/tea5761.c
index bf78cb9..36b0b1e 100644
--- a/drivers/media/tuners/tea5761.c
+++ b/drivers/media/tuners/tea5761.c
@@ -301,7 +301,7 @@ static int tea5761_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops tea5761_tuner_ops = {
+static const struct dvb_tuner_ops tea5761_tuner_ops = {
 	.info = {
 		.name           = "tea5761", // Philips TEA5761HN FM Radio
 	},
diff --git a/drivers/media/tuners/tea5767.c b/drivers/media/tuners/tea5767.c
index 36e85d8..6d86aa6 100644
--- a/drivers/media/tuners/tea5767.c
+++ b/drivers/media/tuners/tea5767.c
@@ -423,7 +423,7 @@ static int tea5767_set_config (struct dvb_frontend *fe, void *priv_cfg)
 	return 0;
 }
 
-static struct dvb_tuner_ops tea5767_tuner_ops = {
+static const struct dvb_tuner_ops tea5767_tuner_ops = {
 	.info = {
 		.name           = "tea5767", // Philips TEA5767HN FM Radio
 	},
diff --git a/drivers/media/tuners/tuner-simple.c b/drivers/media/tuners/tuner-simple.c
index 8e9ce14..9ba9582 100644
--- a/drivers/media/tuners/tuner-simple.c
+++ b/drivers/media/tuners/tuner-simple.c
@@ -1035,7 +1035,7 @@ static int simple_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 	return 0;
 }
 
-static struct dvb_tuner_ops simple_tuner_ops = {
+static const struct dvb_tuner_ops simple_tuner_ops = {
 	.init              = simple_init,
 	.sleep             = simple_sleep,
 	.set_analog_params = simple_set_params,
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
index 047a32f..639e156 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
@@ -549,7 +549,7 @@ static void mxl111sf_demod_release(struct dvb_frontend *fe)
 	fe->demodulator_priv = NULL;
 }
 
-static struct dvb_frontend_ops mxl111sf_demod_ops = {
+static const struct dvb_frontend_ops mxl111sf_demod_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name               = "MaxLinear MxL111SF DVB-T demodulator",
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
index 7d16252..f141dcc 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
@@ -466,7 +466,7 @@ static int mxl111sf_tuner_release(struct dvb_frontend *fe)
 
 /* ------------------------------------------------------------------------- */
 
-static struct dvb_tuner_ops mxl111sf_tuner_tuner_ops = {
+static const struct dvb_tuner_ops mxl111sf_tuner_tuner_ops = {
 	.info = {
 		.name = "MaxLinear MxL111SF",
 #if 0
diff --git a/drivers/media/usb/dvb-usb/af9005-fe.c b/drivers/media/usb/dvb-usb/af9005-fe.c
index 09db3d0..9862d3e 100644
--- a/drivers/media/usb/dvb-usb/af9005-fe.c
+++ b/drivers/media/usb/dvb-usb/af9005-fe.c
@@ -1430,7 +1430,7 @@ static void af9005_fe_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops af9005_fe_ops;
+static const struct dvb_frontend_ops af9005_fe_ops;
 
 struct dvb_frontend *af9005_fe_attach(struct dvb_usb_device *d)
 {
@@ -1455,7 +1455,7 @@ struct dvb_frontend *af9005_fe_attach(struct dvb_usb_device *d)
 	return NULL;
 }
 
-static struct dvb_frontend_ops af9005_fe_ops = {
+static const struct dvb_frontend_ops af9005_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "AF9005 USB DVB-T",
diff --git a/drivers/media/usb/dvb-usb/cinergyT2-fe.c b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
index b3ec743..7d90dab 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
@@ -303,7 +303,7 @@ static void cinergyt2_fe_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops cinergyt2_fe_ops;
+static const struct dvb_frontend_ops cinergyt2_fe_ops;
 
 struct dvb_frontend *cinergyt2_fe_attach(struct dvb_usb_device *d)
 {
@@ -319,7 +319,7 @@ struct dvb_frontend *cinergyt2_fe_attach(struct dvb_usb_device *d)
 }
 
 
-static struct dvb_frontend_ops cinergyt2_fe_ops = {
+static const struct dvb_frontend_ops cinergyt2_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= DRIVER_NAME,
diff --git a/drivers/media/usb/dvb-usb/dtt200u-fe.c b/drivers/media/usb/dvb-usb/dtt200u-fe.c
index c09332b..db03851 100644
--- a/drivers/media/usb/dvb-usb/dtt200u-fe.c
+++ b/drivers/media/usb/dvb-usb/dtt200u-fe.c
@@ -155,7 +155,7 @@ static void dtt200u_fe_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops dtt200u_fe_ops;
+static const struct dvb_frontend_ops dtt200u_fe_ops;
 
 struct dvb_frontend* dtt200u_fe_attach(struct dvb_usb_device *d)
 {
@@ -178,7 +178,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops dtt200u_fe_ops = {
+static const struct dvb_frontend_ops dtt200u_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "WideView USB DVB-T",
diff --git a/drivers/media/usb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb-usb/friio-fe.c
index 979f05b..0251a4e 100644
--- a/drivers/media/usb/dvb-usb/friio-fe.c
+++ b/drivers/media/usb/dvb-usb/friio-fe.c
@@ -401,7 +401,7 @@ static void jdvbt90502_release(struct dvb_frontend *fe)
 }
 
 
-static struct dvb_frontend_ops jdvbt90502_ops;
+static const struct dvb_frontend_ops jdvbt90502_ops;
 
 struct dvb_frontend *jdvbt90502_attach(struct dvb_usb_device *d)
 {
@@ -432,7 +432,7 @@ error:
 	return NULL;
 }
 
-static struct dvb_frontend_ops jdvbt90502_ops = {
+static const struct dvb_frontend_ops jdvbt90502_ops = {
 	.delsys = { SYS_ISDBT },
 	.info = {
 		.name			= "Comtech JDVBT90502 ISDB-T",
diff --git a/drivers/media/usb/dvb-usb/gp8psk-fe.c b/drivers/media/usb/dvb-usb/gp8psk-fe.c
index db6eb79..59da367 100644
--- a/drivers/media/usb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/usb/dvb-usb/gp8psk-fe.c
@@ -308,7 +308,7 @@ static void gp8psk_fe_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops gp8psk_fe_ops;
+static const struct dvb_frontend_ops gp8psk_fe_ops;
 
 struct dvb_frontend * gp8psk_fe_attach(struct dvb_usb_device *d)
 {
@@ -328,7 +328,7 @@ success:
 }
 
 
-static struct dvb_frontend_ops gp8psk_fe_ops = {
+static const struct dvb_frontend_ops gp8psk_fe_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Genpix DVB-S",
diff --git a/drivers/media/usb/dvb-usb/vp702x-fe.c b/drivers/media/usb/dvb-usb/vp702x-fe.c
index 27398c0..7ff31ba 100644
--- a/drivers/media/usb/dvb-usb/vp702x-fe.c
+++ b/drivers/media/usb/dvb-usb/vp702x-fe.c
@@ -323,7 +323,7 @@ static void vp702x_fe_release(struct dvb_frontend* fe)
 	kfree(st);
 }
 
-static struct dvb_frontend_ops vp702x_fe_ops;
+static const struct dvb_frontend_ops vp702x_fe_ops;
 
 struct dvb_frontend * vp702x_fe_attach(struct dvb_usb_device *d)
 {
@@ -345,7 +345,7 @@ error:
 }
 
 
-static struct dvb_frontend_ops vp702x_fe_ops = {
+static const struct dvb_frontend_ops vp702x_fe_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name           = "Twinhan DST-like frontend (VP7021/VP7020) DVB-S",
diff --git a/drivers/media/usb/dvb-usb/vp7045-fe.c b/drivers/media/usb/dvb-usb/vp7045-fe.c
index 7765602..4520ad9 100644
--- a/drivers/media/usb/dvb-usb/vp7045-fe.c
+++ b/drivers/media/usb/dvb-usb/vp7045-fe.c
@@ -140,7 +140,7 @@ static void vp7045_fe_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops vp7045_fe_ops;
+static const struct dvb_frontend_ops vp7045_fe_ops;
 
 struct dvb_frontend * vp7045_fe_attach(struct dvb_usb_device *d)
 {
@@ -158,7 +158,7 @@ error:
 }
 
 
-static struct dvb_frontend_ops vp7045_fe_ops = {
+static const struct dvb_frontend_ops vp7045_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Twinhan VP7045/46 USB DVB-T",
diff --git a/drivers/media/usb/ttusb-dec/ttusbdecfe.c b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
index 8781335..2d94449 100644
--- a/drivers/media/usb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
@@ -205,7 +205,7 @@ static void ttusbdecfe_release(struct dvb_frontend* fe)
 	kfree(state);
 }
 
-static struct dvb_frontend_ops ttusbdecfe_dvbt_ops;
+static const struct dvb_frontend_ops ttusbdecfe_dvbt_ops;
 
 struct dvb_frontend* ttusbdecfe_dvbt_attach(const struct ttusbdecfe_config* config)
 {
@@ -225,7 +225,7 @@ struct dvb_frontend* ttusbdecfe_dvbt_attach(const struct ttusbdecfe_config* conf
 	return &state->frontend;
 }
 
-static struct dvb_frontend_ops ttusbdecfe_dvbs_ops;
+static const struct dvb_frontend_ops ttusbdecfe_dvbs_ops;
 
 struct dvb_frontend* ttusbdecfe_dvbs_attach(const struct ttusbdecfe_config* config)
 {
@@ -247,7 +247,7 @@ struct dvb_frontend* ttusbdecfe_dvbs_attach(const struct ttusbdecfe_config* conf
 	return &state->frontend;
 }
 
-static struct dvb_frontend_ops ttusbdecfe_dvbt_ops = {
+static const struct dvb_frontend_ops ttusbdecfe_dvbt_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "TechnoTrend/Hauppauge DEC2000-t Frontend",
@@ -270,7 +270,7 @@ static struct dvb_frontend_ops ttusbdecfe_dvbt_ops = {
 	.read_status = ttusbdecfe_dvbt_read_status,
 };
 
-static struct dvb_frontend_ops ttusbdecfe_dvbs_ops = {
+static const struct dvb_frontend_ops ttusbdecfe_dvbs_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "TechnoTrend/Hauppauge DEC3000-s Frontend",

