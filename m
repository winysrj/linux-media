Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab3CUTja (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 15:39:30 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Thomas Mair <thomas.mair86@googlemail.com>
Subject: [PATCH 1/4] [media] dvb-frontends: use IS_ENABLED
Date: Thu, 21 Mar 2013 16:39:05 -0300
Message-Id: <1363894748-28000-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking everywhere there for 3 symbols, use instead
IS_ENABLED macro.

This replacement was done using this small perl script:

my $data;
$data .= $_ while (<>);
if ($data =~ m/CONFIG_([A-Z\_\d]*)_MODULE/) {
	$data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
	$data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
	$data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
	$data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)\!]+defined\(CONFIG_($f)_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;

	$data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)\)\)*,IS_ENABLED(CONFIG_$f),g;
	$data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)\)\)*,IS_ENABLED(CONFIG_$f),g;
	$data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
	$data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
}
print $data;

Cc: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>
Cc: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Cc: Igor M. Liplianin <liplianin@me.by>
Cc: Thomas Mair <thomas.mair86@googlemail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/a8293.h        | 3 +--
 drivers/media/dvb-frontends/af9013.h       | 3 +--
 drivers/media/dvb-frontends/af9033.h       | 3 +--
 drivers/media/dvb-frontends/atbm8830.h     | 3 +--
 drivers/media/dvb-frontends/au8522.h       | 3 +--
 drivers/media/dvb-frontends/cx22702.h      | 3 +--
 drivers/media/dvb-frontends/cx24113.h      | 3 +--
 drivers/media/dvb-frontends/cx24116.h      | 3 +--
 drivers/media/dvb-frontends/cx24123.h      | 3 +--
 drivers/media/dvb-frontends/cxd2820r.h     | 3 +--
 drivers/media/dvb-frontends/dib3000mc.h    | 3 +--
 drivers/media/dvb-frontends/dib7000m.h     | 3 +--
 drivers/media/dvb-frontends/dib7000p.h     | 3 +--
 drivers/media/dvb-frontends/drxd.h         | 3 +--
 drivers/media/dvb-frontends/drxk.h         | 3 +--
 drivers/media/dvb-frontends/ds3000.h       | 3 +--
 drivers/media/dvb-frontends/dvb_dummy_fe.h | 3 +--
 drivers/media/dvb-frontends/ec100.h        | 3 +--
 drivers/media/dvb-frontends/hd29l2.h       | 3 +--
 drivers/media/dvb-frontends/it913x-fe.h    | 3 +--
 drivers/media/dvb-frontends/ix2505v.h      | 3 +--
 drivers/media/dvb-frontends/lg2160.h       | 3 +--
 drivers/media/dvb-frontends/lgdt3305.h     | 3 +--
 drivers/media/dvb-frontends/lgs8gl5.h      | 3 +--
 drivers/media/dvb-frontends/lgs8gxx.h      | 3 +--
 drivers/media/dvb-frontends/lnbh24.h       | 3 +--
 drivers/media/dvb-frontends/lnbp21.h       | 3 +--
 drivers/media/dvb-frontends/lnbp22.h       | 3 +--
 drivers/media/dvb-frontends/m88rs2000.h    | 3 +--
 drivers/media/dvb-frontends/mb86a20s.h     | 3 +--
 drivers/media/dvb-frontends/rtl2830.h      | 3 +--
 drivers/media/dvb-frontends/rtl2832.h      | 3 +--
 drivers/media/dvb-frontends/s5h1409.h      | 3 +--
 drivers/media/dvb-frontends/s5h1411.h      | 3 +--
 drivers/media/dvb-frontends/s5h1432.h      | 3 +--
 drivers/media/dvb-frontends/s921.h         | 3 +--
 drivers/media/dvb-frontends/si21xx.h       | 3 +--
 drivers/media/dvb-frontends/stb6000.h      | 3 +--
 drivers/media/dvb-frontends/stv0288.h      | 3 +--
 drivers/media/dvb-frontends/stv0367.h      | 3 +--
 drivers/media/dvb-frontends/stv0900.h      | 3 +--
 drivers/media/dvb-frontends/stv6110.h      | 3 +--
 drivers/media/dvb-frontends/tda10048.h     | 3 +--
 drivers/media/dvb-frontends/tda10071.h     | 3 +--
 drivers/media/dvb-frontends/tda18271c2dd.h | 3 +--
 drivers/media/dvb-frontends/ts2020.h       | 3 +--
 drivers/media/dvb-frontends/zl10036.h      | 3 +--
 drivers/media/dvb-frontends/zl10039.h      | 3 +--
 48 files changed, 48 insertions(+), 96 deletions(-)

diff --git a/drivers/media/dvb-frontends/a8293.h b/drivers/media/dvb-frontends/a8293.h
index ed29e55..e6d4a83 100644
--- a/drivers/media/dvb-frontends/a8293.h
+++ b/drivers/media/dvb-frontends/a8293.h
@@ -25,8 +25,7 @@ struct a8293_config {
 	u8 i2c_addr;
 };
 
-#if defined(CONFIG_DVB_A8293) || \
-	(defined(CONFIG_DVB_A8293_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_A8293)
 extern struct dvb_frontend *a8293_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c, const struct a8293_config *cfg);
 #else
diff --git a/drivers/media/dvb-frontends/af9013.h b/drivers/media/dvb-frontends/af9013.h
index dc837d9..ddd1c47 100644
--- a/drivers/media/dvb-frontends/af9013.h
+++ b/drivers/media/dvb-frontends/af9013.h
@@ -102,8 +102,7 @@ struct af9013_config {
 	u8 gpio[4];
 };
 
-#if defined(CONFIG_DVB_AF9013) || \
-	(defined(CONFIG_DVB_AF9013_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_AF9013)
 extern struct dvb_frontend *af9013_attach(const struct af9013_config *config,
 	struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/af9033.h b/drivers/media/dvb-frontends/af9033.h
index 82bd8c1..08577b4 100644
--- a/drivers/media/dvb-frontends/af9033.h
+++ b/drivers/media/dvb-frontends/af9033.h
@@ -61,8 +61,7 @@ struct af9033_config {
 };
 
 
-#if defined(CONFIG_DVB_AF9033) || \
-	(defined(CONFIG_DVB_AF9033_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_AF9033)
 extern struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/atbm8830.h b/drivers/media/dvb-frontends/atbm8830.h
index 0242733..ca323cf 100644
--- a/drivers/media/dvb-frontends/atbm8830.h
+++ b/drivers/media/dvb-frontends/atbm8830.h
@@ -60,8 +60,7 @@ struct atbm8830_config {
 	u8 agc_hold_loop;
 };
 
-#if defined(CONFIG_DVB_ATBM8830) || \
-	(defined(CONFIG_DVB_ATBM8830_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_ATBM8830)
 extern struct dvb_frontend *atbm8830_attach(const struct atbm8830_config *config,
 		struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/au8522.h b/drivers/media/dvb-frontends/au8522.h
index 565dcf3..3c76120 100644
--- a/drivers/media/dvb-frontends/au8522.h
+++ b/drivers/media/dvb-frontends/au8522.h
@@ -60,8 +60,7 @@ struct au8522_config {
 	enum au8522_if_freq qam_if;
 };
 
-#if defined(CONFIG_DVB_AU8522) || 				\
-	    (defined(CONFIG_DVB_AU8522_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_AU8522)
 extern struct dvb_frontend *au8522_attach(const struct au8522_config *config,
 					  struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/cx22702.h b/drivers/media/dvb-frontends/cx22702.h
index f154e1f..197c105 100644
--- a/drivers/media/dvb-frontends/cx22702.h
+++ b/drivers/media/dvb-frontends/cx22702.h
@@ -40,8 +40,7 @@ struct cx22702_config {
 	u8 output_mode;
 };
 
-#if defined(CONFIG_DVB_CX22702) || (defined(CONFIG_DVB_CX22702_MODULE) \
-	&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_CX22702)
 extern struct dvb_frontend *cx22702_attach(
 	const struct cx22702_config *config,
 	struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/cx24113.h b/drivers/media/dvb-frontends/cx24113.h
index 01eb7b9..49841a5 100644
--- a/drivers/media/dvb-frontends/cx24113.h
+++ b/drivers/media/dvb-frontends/cx24113.h
@@ -30,8 +30,7 @@ struct cx24113_config {
 	u32 xtal_khz;
 };
 
-#if defined(CONFIG_DVB_TUNER_CX24113) || \
-	(defined(CONFIG_DVB_TUNER_CX24113_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TUNER_CX24113)
 extern struct dvb_frontend *cx24113_attach(struct dvb_frontend *,
 	const struct cx24113_config *config, struct i2c_adapter *i2c);
 
diff --git a/drivers/media/dvb-frontends/cx24116.h b/drivers/media/dvb-frontends/cx24116.h
index 7d90ab9..7d101bd 100644
--- a/drivers/media/dvb-frontends/cx24116.h
+++ b/drivers/media/dvb-frontends/cx24116.h
@@ -40,8 +40,7 @@ struct cx24116_config {
 	u16 i2c_wr_max;
 };
 
-#if defined(CONFIG_DVB_CX24116) || \
-	(defined(CONFIG_DVB_CX24116_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_CX24116)
 extern struct dvb_frontend *cx24116_attach(
 	const struct cx24116_config *config,
 	struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/cx24123.h b/drivers/media/dvb-frontends/cx24123.h
index 51ae866..d2c8379 100644
--- a/drivers/media/dvb-frontends/cx24123.h
+++ b/drivers/media/dvb-frontends/cx24123.h
@@ -38,8 +38,7 @@ struct cx24123_config {
 	void (*agc_callback) (struct dvb_frontend *);
 };
 
-#if defined(CONFIG_DVB_CX24123) || (defined(CONFIG_DVB_CX24123_MODULE) \
-	&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_CX24123)
 extern struct dvb_frontend *cx24123_attach(const struct cx24123_config *config,
 					   struct i2c_adapter *i2c);
 extern struct i2c_adapter *cx24123_get_tuner_i2c_adapter(struct dvb_frontend *);
diff --git a/drivers/media/dvb-frontends/cxd2820r.h b/drivers/media/dvb-frontends/cxd2820r.h
index 6acc21c..f09e557 100644
--- a/drivers/media/dvb-frontends/cxd2820r.h
+++ b/drivers/media/dvb-frontends/cxd2820r.h
@@ -65,8 +65,7 @@ struct cxd2820r_config {
 };
 
 
-#if defined(CONFIG_DVB_CXD2820R) || \
-	(defined(CONFIG_DVB_CXD2820R_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_CXD2820R)
 extern struct dvb_frontend *cxd2820r_attach(
 	const struct cxd2820r_config *config,
 	struct i2c_adapter *i2c,
diff --git a/drivers/media/dvb-frontends/dib3000mc.h b/drivers/media/dvb-frontends/dib3000mc.h
index d75ffad..177c39d 100644
--- a/drivers/media/dvb-frontends/dib3000mc.h
+++ b/drivers/media/dvb-frontends/dib3000mc.h
@@ -39,8 +39,7 @@ struct dib3000mc_config {
 #define DEFAULT_DIB3000MC_I2C_ADDRESS 16
 #define DEFAULT_DIB3000P_I2C_ADDRESS  24
 
-#if defined(CONFIG_DVB_DIB3000MC) || (defined(CONFIG_DVB_DIB3000MC_MODULE) && \
-				      defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DIB3000MC)
 extern struct dvb_frontend *dib3000mc_attach(struct i2c_adapter *i2c_adap,
 					     u8 i2c_addr,
 					     struct dib3000mc_config *cfg);
diff --git a/drivers/media/dvb-frontends/dib7000m.h b/drivers/media/dvb-frontends/dib7000m.h
index 81fcf22..1cd6707 100644
--- a/drivers/media/dvb-frontends/dib7000m.h
+++ b/drivers/media/dvb-frontends/dib7000m.h
@@ -38,8 +38,7 @@ struct dib7000m_config {
 
 #define DEFAULT_DIB7000M_I2C_ADDRESS 18
 
-#if defined(CONFIG_DVB_DIB7000M) || (defined(CONFIG_DVB_DIB7000M_MODULE) && \
-				     defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DIB7000M)
 extern struct dvb_frontend *dib7000m_attach(struct i2c_adapter *i2c_adap,
 					    u8 i2c_addr,
 					    struct dib7000m_config *cfg);
diff --git a/drivers/media/dvb-frontends/dib7000p.h b/drivers/media/dvb-frontends/dib7000p.h
index b61b03a..0ada7b2 100644
--- a/drivers/media/dvb-frontends/dib7000p.h
+++ b/drivers/media/dvb-frontends/dib7000p.h
@@ -44,8 +44,7 @@ struct dib7000p_config {
 
 #define DEFAULT_DIB7000P_I2C_ADDRESS 18
 
-#if defined(CONFIG_DVB_DIB7000P) || (defined(CONFIG_DVB_DIB7000P_MODULE) && \
-					defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DIB7000P)
 extern struct dvb_frontend *dib7000p_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg);
 extern struct i2c_adapter *dib7000p_get_i2c_master(struct dvb_frontend *, enum dibx000_i2c_interface, int);
 extern int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib7000p_config cfg[]);
diff --git a/drivers/media/dvb-frontends/drxd.h b/drivers/media/dvb-frontends/drxd.h
index 216c8c3..f7ec3ab 100644
--- a/drivers/media/dvb-frontends/drxd.h
+++ b/drivers/media/dvb-frontends/drxd.h
@@ -51,8 +51,7 @@ struct drxd_config {
 	 s16(*osc_deviation) (void *priv, s16 dev, int flag);
 };
 
-#if defined(CONFIG_DVB_DRXD) || \
-			(defined(CONFIG_DVB_DRXD_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DRXD)
 extern
 struct dvb_frontend *drxd_attach(const struct drxd_config *config,
 				 void *priv, struct i2c_adapter *i2c,
diff --git a/drivers/media/dvb-frontends/drxk.h b/drivers/media/dvb-frontends/drxk.h
index 94fecfb..bebdfa0 100644
--- a/drivers/media/dvb-frontends/drxk.h
+++ b/drivers/media/dvb-frontends/drxk.h
@@ -52,8 +52,7 @@ struct drxk_config {
 	int		 qam_demod_parameter_count;
 };
 
-#if defined(CONFIG_DVB_DRXK) || (defined(CONFIG_DVB_DRXK_MODULE) \
-        && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DRXK)
 extern struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 					struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/ds3000.h b/drivers/media/dvb-frontends/ds3000.h
index 478ad66..9a23913 100644
--- a/drivers/media/dvb-frontends/ds3000.h
+++ b/drivers/media/dvb-frontends/ds3000.h
@@ -34,8 +34,7 @@ struct ds3000_config {
 	void (*set_lock_led)(struct dvb_frontend *fe, int offon);
 };
 
-#if defined(CONFIG_DVB_DS3000) || \
-			(defined(CONFIG_DVB_DS3000_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DS3000)
 extern struct dvb_frontend *ds3000_attach(const struct ds3000_config *config,
 					struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/dvb_dummy_fe.h b/drivers/media/dvb-frontends/dvb_dummy_fe.h
index 1fcb987..df979d0 100644
--- a/drivers/media/dvb-frontends/dvb_dummy_fe.h
+++ b/drivers/media/dvb-frontends/dvb_dummy_fe.h
@@ -25,8 +25,7 @@
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
-#if defined(CONFIG_DVB_DUMMY_FE) || (defined(CONFIG_DVB_DUMMY_FE_MODULE) && \
-defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DUMMY_FE)
 extern struct dvb_frontend* dvb_dummy_fe_ofdm_attach(void);
 extern struct dvb_frontend* dvb_dummy_fe_qpsk_attach(void);
 extern struct dvb_frontend* dvb_dummy_fe_qam_attach(void);
diff --git a/drivers/media/dvb-frontends/ec100.h b/drivers/media/dvb-frontends/ec100.h
index b847971..170d043 100644
--- a/drivers/media/dvb-frontends/ec100.h
+++ b/drivers/media/dvb-frontends/ec100.h
@@ -30,8 +30,7 @@ struct ec100_config {
 };
 
 
-#if defined(CONFIG_DVB_EC100) || \
-	(defined(CONFIG_DVB_EC100_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_EC100)
 extern struct dvb_frontend *ec100_attach(const struct ec100_config *config,
 	struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/hd29l2.h b/drivers/media/dvb-frontends/hd29l2.h
index 4ad00d7..7b6ec7e 100644
--- a/drivers/media/dvb-frontends/hd29l2.h
+++ b/drivers/media/dvb-frontends/hd29l2.h
@@ -50,8 +50,7 @@ struct hd29l2_config {
 };
 
 
-#if defined(CONFIG_DVB_HD29L2) || \
-	(defined(CONFIG_DVB_HD29L2_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_HD29L2)
 extern struct dvb_frontend *hd29l2_attach(const struct hd29l2_config *config,
 	struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/it913x-fe.h b/drivers/media/dvb-frontends/it913x-fe.h
index 07fa459..6011760 100644
--- a/drivers/media/dvb-frontends/it913x-fe.h
+++ b/drivers/media/dvb-frontends/it913x-fe.h
@@ -38,8 +38,7 @@ struct ite_config {
 	u8 read_slevel;
 };
 
-#if defined(CONFIG_DVB_IT913X_FE) || (defined(CONFIG_DVB_IT913X_FE_MODULE) && \
-defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_IT913X_FE)
 extern struct dvb_frontend *it913x_fe_attach(struct i2c_adapter *i2c_adap,
 			u8 i2c_addr, struct ite_config *config);
 #else
diff --git a/drivers/media/dvb-frontends/ix2505v.h b/drivers/media/dvb-frontends/ix2505v.h
index 67e89d6..3904b40 100644
--- a/drivers/media/dvb-frontends/ix2505v.h
+++ b/drivers/media/dvb-frontends/ix2505v.h
@@ -48,8 +48,7 @@ struct ix2505v_config {
 
 };
 
-#if defined(CONFIG_DVB_IX2505V) || \
-	(defined(CONFIG_DVB_IX2505V_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_IX2505V)
 extern struct dvb_frontend *ix2505v_attach(struct dvb_frontend *fe,
 	const struct ix2505v_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/lg2160.h b/drivers/media/dvb-frontends/lg2160.h
index 9e2c0f4..f5ded9f 100644
--- a/drivers/media/dvb-frontends/lg2160.h
+++ b/drivers/media/dvb-frontends/lg2160.h
@@ -66,8 +66,7 @@ struct lg2160_config {
 	enum lg_chip_type lg_chip;
 };
 
-#if defined(CONFIG_DVB_LG2160) || (defined(CONFIG_DVB_LG2160_MODULE) && \
-				     defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LG2160)
 extern
 struct dvb_frontend *lg2160_attach(const struct lg2160_config *config,
 				     struct i2c_adapter *i2c_adap);
diff --git a/drivers/media/dvb-frontends/lgdt3305.h b/drivers/media/dvb-frontends/lgdt3305.h
index 02172ec..960db97 100644
--- a/drivers/media/dvb-frontends/lgdt3305.h
+++ b/drivers/media/dvb-frontends/lgdt3305.h
@@ -73,8 +73,7 @@ struct lgdt3305_config {
 	enum lgdt_demod_chip_type demod_chip;
 };
 
-#if defined(CONFIG_DVB_LGDT3305) || (defined(CONFIG_DVB_LGDT3305_MODULE) && \
-				     defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LGDT3305)
 extern
 struct dvb_frontend *lgdt3305_attach(const struct lgdt3305_config *config,
 				     struct i2c_adapter *i2c_adap);
diff --git a/drivers/media/dvb-frontends/lgs8gl5.h b/drivers/media/dvb-frontends/lgs8gl5.h
index d1417678..20033e9 100644
--- a/drivers/media/dvb-frontends/lgs8gl5.h
+++ b/drivers/media/dvb-frontends/lgs8gl5.h
@@ -30,8 +30,7 @@ struct lgs8gl5_config {
 	u8 demod_address;
 };
 
-#if defined(CONFIG_DVB_LGS8GL5) || \
-	(defined(CONFIG_DVB_LGS8GL5_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LGS8GL5)
 extern struct dvb_frontend *lgs8gl5_attach(
 	const struct lgs8gl5_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/lgs8gxx.h b/drivers/media/dvb-frontends/lgs8gxx.h
index 33c3c5e..35945df 100644
--- a/drivers/media/dvb-frontends/lgs8gxx.h
+++ b/drivers/media/dvb-frontends/lgs8gxx.h
@@ -79,8 +79,7 @@ struct lgs8gxx_config {
 	u8 tuner_address;
 };
 
-#if defined(CONFIG_DVB_LGS8GXX) || \
-	(defined(CONFIG_DVB_LGS8GXX_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LGS8GXX)
 extern struct dvb_frontend *lgs8gxx_attach(const struct lgs8gxx_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/lnbh24.h b/drivers/media/dvb-frontends/lnbh24.h
index c059b16..c87268a 100644
--- a/drivers/media/dvb-frontends/lnbh24.h
+++ b/drivers/media/dvb-frontends/lnbh24.h
@@ -35,8 +35,7 @@
 
 #include <linux/dvb/frontend.h>
 
-#if defined(CONFIG_DVB_LNBP21) || (defined(CONFIG_DVB_LNBP21_MODULE) \
-							&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LNBP21)
 /* override_set and override_clear control which
    system register bits (above) to always set & clear */
 extern struct dvb_frontend *lnbh24_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/lnbp21.h b/drivers/media/dvb-frontends/lnbp21.h
index fcdf1c6..399eeef 100644
--- a/drivers/media/dvb-frontends/lnbp21.h
+++ b/drivers/media/dvb-frontends/lnbp21.h
@@ -55,8 +55,7 @@
 
 #include <linux/dvb/frontend.h>
 
-#if defined(CONFIG_DVB_LNBP21) || (defined(CONFIG_DVB_LNBP21_MODULE) \
-							&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LNBP21)
 /* override_set and override_clear control which
  system register bits (above) to always set & clear */
 extern struct dvb_frontend *lnbp21_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/lnbp22.h b/drivers/media/dvb-frontends/lnbp22.h
index 63e2dec..2109bd9 100644
--- a/drivers/media/dvb-frontends/lnbp22.h
+++ b/drivers/media/dvb-frontends/lnbp22.h
@@ -37,8 +37,7 @@
 
 #include <linux/dvb/frontend.h>
 
-#if defined(CONFIG_DVB_LNBP22) || \
-		(defined(CONFIG_DVB_LNBP22_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LNBP22)
 /*
  * override_set and override_clear control which system register bits (above)
  * to always set & clear
diff --git a/drivers/media/dvb-frontends/m88rs2000.h b/drivers/media/dvb-frontends/m88rs2000.h
index 5a8023e..937ff13 100644
--- a/drivers/media/dvb-frontends/m88rs2000.h
+++ b/drivers/media/dvb-frontends/m88rs2000.h
@@ -40,8 +40,7 @@ enum {
 	CALL_IS_READ,
 };
 
-#if defined(CONFIG_DVB_M88RS2000) || (defined(CONFIG_DVB_M88RS2000_MODULE) && \
-							defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_M88RS2000)
 extern struct dvb_frontend *m88rs2000_attach(
 	const struct m88rs2000_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/mb86a20s.h b/drivers/media/dvb-frontends/mb86a20s.h
index 1a7dea2..87bc7fb 100644
--- a/drivers/media/dvb-frontends/mb86a20s.h
+++ b/drivers/media/dvb-frontends/mb86a20s.h
@@ -33,8 +33,7 @@ struct mb86a20s_config {
 	bool	is_serial;
 };
 
-#if defined(CONFIG_DVB_MB86A20S) || (defined(CONFIG_DVB_MB86A20S_MODULE) \
-	&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_MB86A20S)
 extern struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 					   struct i2c_adapter *i2c);
 extern struct i2c_adapter *mb86a20s_get_tuner_i2c_adapter(struct dvb_frontend *);
diff --git a/drivers/media/dvb-frontends/rtl2830.h b/drivers/media/dvb-frontends/rtl2830.h
index f4349a1..afad0ae 100644
--- a/drivers/media/dvb-frontends/rtl2830.h
+++ b/drivers/media/dvb-frontends/rtl2830.h
@@ -59,8 +59,7 @@ struct rtl2830_config {
 	u8 agc_targ_val;
 };
 
-#if defined(CONFIG_DVB_RTL2830) || \
-	(defined(CONFIG_DVB_RTL2830_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_RTL2830)
 extern struct dvb_frontend *rtl2830_attach(
 	const struct rtl2830_config *config,
 	struct i2c_adapter *i2c
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index 785a466..a3a609b 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -54,8 +54,7 @@ struct rtl2832_config {
 	u8 tuner;
 };
 
-#if defined(CONFIG_DVB_RTL2832) || \
-	(defined(CONFIG_DVB_RTL2832_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_RTL2832)
 extern struct dvb_frontend *rtl2832_attach(
 	const struct rtl2832_config *cfg,
 	struct i2c_adapter *i2c
diff --git a/drivers/media/dvb-frontends/s5h1409.h b/drivers/media/dvb-frontends/s5h1409.h
index 91f2ebd..f6148db 100644
--- a/drivers/media/dvb-frontends/s5h1409.h
+++ b/drivers/media/dvb-frontends/s5h1409.h
@@ -66,8 +66,7 @@ struct s5h1409_config {
 	u8 hvr1600_opt;
 };
 
-#if defined(CONFIG_DVB_S5H1409) || (defined(CONFIG_DVB_S5H1409_MODULE) \
-	&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_S5H1409)
 extern struct dvb_frontend *s5h1409_attach(const struct s5h1409_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/s5h1411.h b/drivers/media/dvb-frontends/s5h1411.h
index 45ec0f8..dc41301 100644
--- a/drivers/media/dvb-frontends/s5h1411.h
+++ b/drivers/media/dvb-frontends/s5h1411.h
@@ -68,8 +68,7 @@ struct s5h1411_config {
 	u8 status_mode;
 };
 
-#if defined(CONFIG_DVB_S5H1411) || \
-	(defined(CONFIG_DVB_S5H1411_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_S5H1411)
 extern struct dvb_frontend *s5h1411_attach(const struct s5h1411_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/s5h1432.h b/drivers/media/dvb-frontends/s5h1432.h
index b57438c..24c4acf 100644
--- a/drivers/media/dvb-frontends/s5h1432.h
+++ b/drivers/media/dvb-frontends/s5h1432.h
@@ -74,8 +74,7 @@ struct s5h1432_config {
 	u8 status_mode;
 };
 
-#if defined(CONFIG_DVB_S5H1432) || \
-	(defined(CONFIG_DVB_S5H1432_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_S5H1432)
 extern struct dvb_frontend *s5h1432_attach(const struct s5h1432_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/s921.h b/drivers/media/dvb-frontends/s921.h
index f220d82..ab714ad 100644
--- a/drivers/media/dvb-frontends/s921.h
+++ b/drivers/media/dvb-frontends/s921.h
@@ -24,8 +24,7 @@ struct s921_config {
 	u8 demod_address;
 };
 
-#if defined(CONFIG_DVB_S921) || (defined(CONFIG_DVB_S921_MODULE) \
-	&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_S921)
 extern struct dvb_frontend *s921_attach(const struct s921_config *config,
 					   struct i2c_adapter *i2c);
 extern struct i2c_adapter *s921_get_tuner_i2c_adapter(struct dvb_frontend *);
diff --git a/drivers/media/dvb-frontends/si21xx.h b/drivers/media/dvb-frontends/si21xx.h
index 141b5b8..3debdcf 100644
--- a/drivers/media/dvb-frontends/si21xx.h
+++ b/drivers/media/dvb-frontends/si21xx.h
@@ -12,8 +12,7 @@ struct si21xx_config {
 	int min_delay_ms;
 };
 
-#if defined(CONFIG_DVB_SI21XX) || \
-		(defined(CONFIG_DVB_SI21XX_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_SI21XX)
 extern struct dvb_frontend *si21xx_attach(const struct si21xx_config *config,
 						struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/stb6000.h b/drivers/media/dvb-frontends/stb6000.h
index 7be479c..d2bf53a 100644
--- a/drivers/media/dvb-frontends/stb6000.h
+++ b/drivers/media/dvb-frontends/stb6000.h
@@ -34,8 +34,7 @@
  * @param i2c i2c adapter to use.
  * @return FE pointer on success, NULL on failure.
  */
-#if defined(CONFIG_DVB_STB6000) || (defined(CONFIG_DVB_STB6000_MODULE) \
-							&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STB6000)
 extern struct dvb_frontend *stb6000_attach(struct dvb_frontend *fe, int addr,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/stv0288.h b/drivers/media/dvb-frontends/stv0288.h
index f2b53db..35d5733 100644
--- a/drivers/media/dvb-frontends/stv0288.h
+++ b/drivers/media/dvb-frontends/stv0288.h
@@ -42,8 +42,7 @@ struct stv0288_config {
 	int (*set_ts_params)(struct dvb_frontend *fe, int is_punctured);
 };
 
-#if defined(CONFIG_DVB_STV0288) || (defined(CONFIG_DVB_STV0288_MODULE) && \
-							defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STV0288)
 extern struct dvb_frontend *stv0288_attach(const struct stv0288_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/stv0367.h b/drivers/media/dvb-frontends/stv0367.h
index 93cc4a5..b34bd7d 100644
--- a/drivers/media/dvb-frontends/stv0367.h
+++ b/drivers/media/dvb-frontends/stv0367.h
@@ -38,8 +38,7 @@ struct stv0367_config {
 	int clk_pol;
 };
 
-#if defined(CONFIG_DVB_STV0367) || (defined(CONFIG_DVB_STV0367_MODULE) \
-							&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STV0367)
 extern struct
 dvb_frontend *stv0367ter_attach(const struct stv0367_config *config,
 					struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/stv0900.h b/drivers/media/dvb-frontends/stv0900.h
index 91c7ee8..0ad06f8 100644
--- a/drivers/media/dvb-frontends/stv0900.h
+++ b/drivers/media/dvb-frontends/stv0900.h
@@ -57,8 +57,7 @@ struct stv0900_config {
 	void (*set_lock_led)(struct dvb_frontend *fe, int offon);
 };
 
-#if defined(CONFIG_DVB_STV0900) || (defined(CONFIG_DVB_STV0900_MODULE) \
-							&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STV0900)
 extern struct dvb_frontend *stv0900_attach(const struct stv0900_config *config,
 					struct i2c_adapter *i2c, int demod);
 #else
diff --git a/drivers/media/dvb-frontends/stv6110.h b/drivers/media/dvb-frontends/stv6110.h
index fe71bba..7dc887e 100644
--- a/drivers/media/dvb-frontends/stv6110.h
+++ b/drivers/media/dvb-frontends/stv6110.h
@@ -45,8 +45,7 @@ struct stv6110_config {
 	u8 clk_div;	/* divisor value for the output clock */
 };
 
-#if defined(CONFIG_DVB_STV6110) || (defined(CONFIG_DVB_STV6110_MODULE) \
-							&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STV6110)
 extern struct dvb_frontend *stv6110_attach(struct dvb_frontend *fe,
 					const struct stv6110_config *config,
 					struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/tda10048.h b/drivers/media/dvb-frontends/tda10048.h
index fb2ef5a..2b4ad99 100644
--- a/drivers/media/dvb-frontends/tda10048.h
+++ b/drivers/media/dvb-frontends/tda10048.h
@@ -72,8 +72,7 @@ struct tda10048_config {
 	u8 pll_n;
 };
 
-#if defined(CONFIG_DVB_TDA10048) || \
-	(defined(CONFIG_DVB_TDA10048_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TDA10048)
 extern struct dvb_frontend *tda10048_attach(
 	const struct tda10048_config *config,
 	struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/tda10071.h b/drivers/media/dvb-frontends/tda10071.h
index bff1c38..8a527ac 100644
--- a/drivers/media/dvb-frontends/tda10071.h
+++ b/drivers/media/dvb-frontends/tda10071.h
@@ -71,8 +71,7 @@ struct tda10071_config {
 };
 
 
-#if defined(CONFIG_DVB_TDA10071) || \
-	(defined(CONFIG_DVB_TDA10071_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TDA10071)
 extern struct dvb_frontend *tda10071_attach(
 	const struct tda10071_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/tda18271c2dd.h b/drivers/media/dvb-frontends/tda18271c2dd.h
index 1389c74..6224c91 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.h
+++ b/drivers/media/dvb-frontends/tda18271c2dd.h
@@ -1,7 +1,6 @@
 #ifndef _TDA18271C2DD_H_
 #define _TDA18271C2DD_H_
-#if defined(CONFIG_DVB_TDA18271C2DD) || (defined(CONFIG_DVB_TDA18271C2DD_MODULE) \
-        && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TDA18271C2DD)
 struct dvb_frontend *tda18271c2dd_attach(struct dvb_frontend *fe,
 					 struct i2c_adapter *i2c, u8 adr);
 #else
diff --git a/drivers/media/dvb-frontends/ts2020.h b/drivers/media/dvb-frontends/ts2020.h
index c7e64af..863d8d4 100644
--- a/drivers/media/dvb-frontends/ts2020.h
+++ b/drivers/media/dvb-frontends/ts2020.h
@@ -29,8 +29,7 @@ struct ts2020_config {
 	u8 clk_out_div;
 };
 
-#if defined(CONFIG_DVB_TS2020) || \
-	(defined(CONFIG_DVB_TS2020_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TS2020)
 
 extern struct dvb_frontend *ts2020_attach(
 	struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/zl10036.h b/drivers/media/dvb-frontends/zl10036.h
index d84b8f8..a313cdc 100644
--- a/drivers/media/dvb-frontends/zl10036.h
+++ b/drivers/media/dvb-frontends/zl10036.h
@@ -37,8 +37,7 @@ struct zl10036_config {
 	int rf_loop_enable;
 };
 
-#if defined(CONFIG_DVB_ZL10036) || \
-	(defined(CONFIG_DVB_ZL10036_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_ZL10036)
 extern struct dvb_frontend *zl10036_attach(struct dvb_frontend *fe,
 	const struct zl10036_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/zl10039.h b/drivers/media/dvb-frontends/zl10039.h
index 5eee7ea..7ee5489 100644
--- a/drivers/media/dvb-frontends/zl10039.h
+++ b/drivers/media/dvb-frontends/zl10039.h
@@ -22,8 +22,7 @@
 #ifndef ZL10039_H
 #define ZL10039_H
 
-#if defined(CONFIG_DVB_ZL10039) || (defined(CONFIG_DVB_ZL10039_MODULE) \
-	    && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_ZL10039)
 struct dvb_frontend *zl10039_attach(struct dvb_frontend *fe,
 					u8 i2c_addr,
 					struct i2c_adapter *i2c);
-- 
1.8.1.4

