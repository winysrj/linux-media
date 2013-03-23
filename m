Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab3CWMfV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 08:35:21 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2NCZLcM019027
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 23 Mar 2013 08:35:21 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 1/4] [media] dvb-frontends: use IS_ENABLED
Date: Sat, 23 Mar 2013 09:35:08 -0300
Message-Id: <1364042111-24708-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking everywhere there for 3 symbols, use instead
IS_ENABLED macro.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/a8293.h        | 5 +++--
 drivers/media/dvb-frontends/af9013.h       | 4 ++--
 drivers/media/dvb-frontends/af9033.h       | 5 +++--
 drivers/media/dvb-frontends/atbm8830.h     | 4 ++--
 drivers/media/dvb-frontends/au8522.h       | 4 ++--
 drivers/media/dvb-frontends/cx22702.h      | 4 ++--
 drivers/media/dvb-frontends/cx24113.h      | 5 +++--
 drivers/media/dvb-frontends/cx24116.h      | 4 ++--
 drivers/media/dvb-frontends/cx24123.h      | 4 ++--
 drivers/media/dvb-frontends/cxd2820r.h     | 4 ++--
 drivers/media/dvb-frontends/dib3000mc.h    | 5 +++--
 drivers/media/dvb-frontends/dib7000m.h     | 5 +++--
 drivers/media/dvb-frontends/dib7000p.h     | 5 +++--
 drivers/media/dvb-frontends/drxd.h         | 4 ++--
 drivers/media/dvb-frontends/drxk.h         | 4 ++--
 drivers/media/dvb-frontends/ds3000.h       | 4 ++--
 drivers/media/dvb-frontends/dvb_dummy_fe.h | 4 ++--
 drivers/media/dvb-frontends/ec100.h        | 4 ++--
 drivers/media/dvb-frontends/hd29l2.h       | 4 ++--
 drivers/media/dvb-frontends/it913x-fe.h    | 4 ++--
 drivers/media/dvb-frontends/ix2505v.h      | 4 ++--
 drivers/media/dvb-frontends/lg2160.h       | 4 ++--
 drivers/media/dvb-frontends/lgdt3305.h     | 4 ++--
 drivers/media/dvb-frontends/lgs8gl5.h      | 4 ++--
 drivers/media/dvb-frontends/lgs8gxx.h      | 4 ++--
 drivers/media/dvb-frontends/lnbh24.h       | 5 +++--
 drivers/media/dvb-frontends/lnbp21.h       | 5 +++--
 drivers/media/dvb-frontends/lnbp22.h       | 5 +++--
 drivers/media/dvb-frontends/m88rs2000.h    | 4 ++--
 drivers/media/dvb-frontends/mb86a20s.h     | 4 ++--
 drivers/media/dvb-frontends/rtl2830.h      | 4 ++--
 drivers/media/dvb-frontends/rtl2832.h      | 4 ++--
 drivers/media/dvb-frontends/s5h1409.h      | 4 ++--
 drivers/media/dvb-frontends/s5h1411.h      | 4 ++--
 drivers/media/dvb-frontends/s5h1432.h      | 4 ++--
 drivers/media/dvb-frontends/s921.h         | 4 ++--
 drivers/media/dvb-frontends/si21xx.h       | 4 ++--
 drivers/media/dvb-frontends/stb6000.h      | 4 ++--
 drivers/media/dvb-frontends/stv0288.h      | 4 ++--
 drivers/media/dvb-frontends/stv0367.h      | 4 ++--
 drivers/media/dvb-frontends/stv0900.h      | 4 ++--
 drivers/media/dvb-frontends/stv6110.h      | 4 ++--
 drivers/media/dvb-frontends/tda10048.h     | 4 ++--
 drivers/media/dvb-frontends/tda10071.h     | 4 ++--
 drivers/media/dvb-frontends/tda18271c2dd.h | 6 ++++--
 drivers/media/dvb-frontends/ts2020.h       | 4 ++--
 drivers/media/dvb-frontends/zl10036.h      | 4 ++--
 drivers/media/dvb-frontends/zl10039.h      | 5 +++--
 48 files changed, 108 insertions(+), 96 deletions(-)

diff --git a/drivers/media/dvb-frontends/a8293.h b/drivers/media/dvb-frontends/a8293.h
index ed29e55..b6ef642 100644
--- a/drivers/media/dvb-frontends/a8293.h
+++ b/drivers/media/dvb-frontends/a8293.h
@@ -21,12 +21,13 @@
 #ifndef A8293_H
 #define A8293_H
 
+#include <linux/kconfig.h>
+
 struct a8293_config {
 	u8 i2c_addr;
 };
 
-#if defined(CONFIG_DVB_A8293) || \
-	(defined(CONFIG_DVB_A8293_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_A8293)
 extern struct dvb_frontend *a8293_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c, const struct a8293_config *cfg);
 #else
diff --git a/drivers/media/dvb-frontends/af9013.h b/drivers/media/dvb-frontends/af9013.h
index dc837d9..09273b2 100644
--- a/drivers/media/dvb-frontends/af9013.h
+++ b/drivers/media/dvb-frontends/af9013.h
@@ -25,6 +25,7 @@
 #ifndef AF9013_H
 #define AF9013_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 /* AF9013/5 GPIOs (mostly guessed)
@@ -102,8 +103,7 @@ struct af9013_config {
 	u8 gpio[4];
 };
 
-#if defined(CONFIG_DVB_AF9013) || \
-	(defined(CONFIG_DVB_AF9013_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_AF9013)
 extern struct dvb_frontend *af9013_attach(const struct af9013_config *config,
 	struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/af9033.h b/drivers/media/dvb-frontends/af9033.h
index 53fd304..c286e8f 100644
--- a/drivers/media/dvb-frontends/af9033.h
+++ b/drivers/media/dvb-frontends/af9033.h
@@ -22,6 +22,8 @@
 #ifndef AF9033_H
 #define AF9033_H
 
+#include <linux/kconfig.h>
+
 struct af9033_config {
 	/*
 	 * I2C address
@@ -76,8 +78,7 @@ struct af9033_config {
 };
 
 
-#if defined(CONFIG_DVB_AF9033) || \
-	(defined(CONFIG_DVB_AF9033_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_AF9033)
 extern struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/atbm8830.h b/drivers/media/dvb-frontends/atbm8830.h
index 0242733..8e0ac98 100644
--- a/drivers/media/dvb-frontends/atbm8830.h
+++ b/drivers/media/dvb-frontends/atbm8830.h
@@ -22,6 +22,7 @@
 #ifndef __ATBM8830_H__
 #define __ATBM8830_H__
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
@@ -60,8 +61,7 @@ struct atbm8830_config {
 	u8 agc_hold_loop;
 };
 
-#if defined(CONFIG_DVB_ATBM8830) || \
-	(defined(CONFIG_DVB_ATBM8830_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_ATBM8830)
 extern struct dvb_frontend *atbm8830_attach(const struct atbm8830_config *config,
 		struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/au8522.h b/drivers/media/dvb-frontends/au8522.h
index 565dcf3..f2111e0 100644
--- a/drivers/media/dvb-frontends/au8522.h
+++ b/drivers/media/dvb-frontends/au8522.h
@@ -22,6 +22,7 @@
 #ifndef __AU8522_H__
 #define __AU8522_H__
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 enum au8522_if_freq {
@@ -60,8 +61,7 @@ struct au8522_config {
 	enum au8522_if_freq qam_if;
 };
 
-#if defined(CONFIG_DVB_AU8522) || 				\
-	    (defined(CONFIG_DVB_AU8522_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_AU8522)
 extern struct dvb_frontend *au8522_attach(const struct au8522_config *config,
 					  struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/cx22702.h b/drivers/media/dvb-frontends/cx22702.h
index f154e1f..0b1a6c2 100644
--- a/drivers/media/dvb-frontends/cx22702.h
+++ b/drivers/media/dvb-frontends/cx22702.h
@@ -28,6 +28,7 @@
 #ifndef CX22702_H
 #define CX22702_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct cx22702_config {
@@ -40,8 +41,7 @@ struct cx22702_config {
 	u8 output_mode;
 };
 
-#if defined(CONFIG_DVB_CX22702) || (defined(CONFIG_DVB_CX22702_MODULE) \
-	&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_CX22702)
 extern struct dvb_frontend *cx22702_attach(
 	const struct cx22702_config *config,
 	struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/cx24113.h b/drivers/media/dvb-frontends/cx24113.h
index 01eb7b9..782711b 100644
--- a/drivers/media/dvb-frontends/cx24113.h
+++ b/drivers/media/dvb-frontends/cx24113.h
@@ -22,6 +22,8 @@
 #ifndef CX24113_H
 #define CX24113_H
 
+#include <linux/kconfig.h>
+
 struct dvb_frontend;
 
 struct cx24113_config {
@@ -30,8 +32,7 @@ struct cx24113_config {
 	u32 xtal_khz;
 };
 
-#if defined(CONFIG_DVB_TUNER_CX24113) || \
-	(defined(CONFIG_DVB_TUNER_CX24113_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TUNER_CX24113)
 extern struct dvb_frontend *cx24113_attach(struct dvb_frontend *,
 	const struct cx24113_config *config, struct i2c_adapter *i2c);
 
diff --git a/drivers/media/dvb-frontends/cx24116.h b/drivers/media/dvb-frontends/cx24116.h
index 7d90ab9..2ec84fa 100644
--- a/drivers/media/dvb-frontends/cx24116.h
+++ b/drivers/media/dvb-frontends/cx24116.h
@@ -21,6 +21,7 @@
 #ifndef CX24116_H
 #define CX24116_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct cx24116_config {
@@ -40,8 +41,7 @@ struct cx24116_config {
 	u16 i2c_wr_max;
 };
 
-#if defined(CONFIG_DVB_CX24116) || \
-	(defined(CONFIG_DVB_CX24116_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_CX24116)
 extern struct dvb_frontend *cx24116_attach(
 	const struct cx24116_config *config,
 	struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/cx24123.h b/drivers/media/dvb-frontends/cx24123.h
index 51ae866..102e70d 100644
--- a/drivers/media/dvb-frontends/cx24123.h
+++ b/drivers/media/dvb-frontends/cx24123.h
@@ -21,6 +21,7 @@
 #ifndef CX24123_H
 #define CX24123_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct cx24123_config {
@@ -38,8 +39,7 @@ struct cx24123_config {
 	void (*agc_callback) (struct dvb_frontend *);
 };
 
-#if defined(CONFIG_DVB_CX24123) || (defined(CONFIG_DVB_CX24123_MODULE) \
-	&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_CX24123)
 extern struct dvb_frontend *cx24123_attach(const struct cx24123_config *config,
 					   struct i2c_adapter *i2c);
 extern struct i2c_adapter *cx24123_get_tuner_i2c_adapter(struct dvb_frontend *);
diff --git a/drivers/media/dvb-frontends/cxd2820r.h b/drivers/media/dvb-frontends/cxd2820r.h
index 6acc21c..82b3d93 100644
--- a/drivers/media/dvb-frontends/cxd2820r.h
+++ b/drivers/media/dvb-frontends/cxd2820r.h
@@ -22,6 +22,7 @@
 #ifndef CXD2820R_H
 #define CXD2820R_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 #define CXD2820R_GPIO_D (0 << 0) /* disable */
@@ -65,8 +66,7 @@ struct cxd2820r_config {
 };
 
 
-#if defined(CONFIG_DVB_CXD2820R) || \
-	(defined(CONFIG_DVB_CXD2820R_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_CXD2820R)
 extern struct dvb_frontend *cxd2820r_attach(
 	const struct cxd2820r_config *config,
 	struct i2c_adapter *i2c,
diff --git a/drivers/media/dvb-frontends/dib3000mc.h b/drivers/media/dvb-frontends/dib3000mc.h
index d75ffad..129d142 100644
--- a/drivers/media/dvb-frontends/dib3000mc.h
+++ b/drivers/media/dvb-frontends/dib3000mc.h
@@ -13,6 +13,8 @@
 #ifndef DIB3000MC_H
 #define DIB3000MC_H
 
+#include <linux/kconfig.h>
+
 #include "dibx000_common.h"
 
 struct dib3000mc_config {
@@ -39,8 +41,7 @@ struct dib3000mc_config {
 #define DEFAULT_DIB3000MC_I2C_ADDRESS 16
 #define DEFAULT_DIB3000P_I2C_ADDRESS  24
 
-#if defined(CONFIG_DVB_DIB3000MC) || (defined(CONFIG_DVB_DIB3000MC_MODULE) && \
-				      defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DIB3000MC)
 extern struct dvb_frontend *dib3000mc_attach(struct i2c_adapter *i2c_adap,
 					     u8 i2c_addr,
 					     struct dib3000mc_config *cfg);
diff --git a/drivers/media/dvb-frontends/dib7000m.h b/drivers/media/dvb-frontends/dib7000m.h
index 81fcf22..b585413 100644
--- a/drivers/media/dvb-frontends/dib7000m.h
+++ b/drivers/media/dvb-frontends/dib7000m.h
@@ -1,6 +1,8 @@
 #ifndef DIB7000M_H
 #define DIB7000M_H
 
+#include <linux/kconfig.h>
+
 #include "dibx000_common.h"
 
 struct dib7000m_config {
@@ -38,8 +40,7 @@ struct dib7000m_config {
 
 #define DEFAULT_DIB7000M_I2C_ADDRESS 18
 
-#if defined(CONFIG_DVB_DIB7000M) || (defined(CONFIG_DVB_DIB7000M_MODULE) && \
-				     defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DIB7000M)
 extern struct dvb_frontend *dib7000m_attach(struct i2c_adapter *i2c_adap,
 					    u8 i2c_addr,
 					    struct dib7000m_config *cfg);
diff --git a/drivers/media/dvb-frontends/dib7000p.h b/drivers/media/dvb-frontends/dib7000p.h
index b61b03a..cf5e779 100644
--- a/drivers/media/dvb-frontends/dib7000p.h
+++ b/drivers/media/dvb-frontends/dib7000p.h
@@ -1,6 +1,8 @@
 #ifndef DIB7000P_H
 #define DIB7000P_H
 
+#include <linux/kconfig.h>
+
 #include "dibx000_common.h"
 
 struct dib7000p_config {
@@ -44,8 +46,7 @@ struct dib7000p_config {
 
 #define DEFAULT_DIB7000P_I2C_ADDRESS 18
 
-#if defined(CONFIG_DVB_DIB7000P) || (defined(CONFIG_DVB_DIB7000P_MODULE) && \
-					defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DIB7000P)
 extern struct dvb_frontend *dib7000p_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg);
 extern struct i2c_adapter *dib7000p_get_i2c_master(struct dvb_frontend *, enum dibx000_i2c_interface, int);
 extern int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib7000p_config cfg[]);
diff --git a/drivers/media/dvb-frontends/drxd.h b/drivers/media/dvb-frontends/drxd.h
index 216c8c3..5f1d6b5 100644
--- a/drivers/media/dvb-frontends/drxd.h
+++ b/drivers/media/dvb-frontends/drxd.h
@@ -24,6 +24,7 @@
 #ifndef _DRXD_H_
 #define _DRXD_H_
 
+#include <linux/kconfig.h>
 #include <linux/types.h>
 #include <linux/i2c.h>
 
@@ -51,8 +52,7 @@ struct drxd_config {
 	 s16(*osc_deviation) (void *priv, s16 dev, int flag);
 };
 
-#if defined(CONFIG_DVB_DRXD) || \
-			(defined(CONFIG_DVB_DRXD_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DRXD)
 extern
 struct dvb_frontend *drxd_attach(const struct drxd_config *config,
 				 void *priv, struct i2c_adapter *i2c,
diff --git a/drivers/media/dvb-frontends/drxk.h b/drivers/media/dvb-frontends/drxk.h
index 94fecfb..e666718 100644
--- a/drivers/media/dvb-frontends/drxk.h
+++ b/drivers/media/dvb-frontends/drxk.h
@@ -1,6 +1,7 @@
 #ifndef _DRXK_H_
 #define _DRXK_H_
 
+#include <linux/kconfig.h>
 #include <linux/types.h>
 #include <linux/i2c.h>
 
@@ -52,8 +53,7 @@ struct drxk_config {
 	int		 qam_demod_parameter_count;
 };
 
-#if defined(CONFIG_DVB_DRXK) || (defined(CONFIG_DVB_DRXK_MODULE) \
-        && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DRXK)
 extern struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 					struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/ds3000.h b/drivers/media/dvb-frontends/ds3000.h
index 478ad66..f9c21fb 100644
--- a/drivers/media/dvb-frontends/ds3000.h
+++ b/drivers/media/dvb-frontends/ds3000.h
@@ -22,6 +22,7 @@
 #ifndef DS3000_H
 #define DS3000_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct ds3000_config {
@@ -34,8 +35,7 @@ struct ds3000_config {
 	void (*set_lock_led)(struct dvb_frontend *fe, int offon);
 };
 
-#if defined(CONFIG_DVB_DS3000) || \
-			(defined(CONFIG_DVB_DS3000_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DS3000)
 extern struct dvb_frontend *ds3000_attach(const struct ds3000_config *config,
 					struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/dvb_dummy_fe.h b/drivers/media/dvb-frontends/dvb_dummy_fe.h
index 1fcb987..0cbf961 100644
--- a/drivers/media/dvb-frontends/dvb_dummy_fe.h
+++ b/drivers/media/dvb-frontends/dvb_dummy_fe.h
@@ -22,11 +22,11 @@
 #ifndef DVB_DUMMY_FE_H
 #define DVB_DUMMY_FE_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
-#if defined(CONFIG_DVB_DUMMY_FE) || (defined(CONFIG_DVB_DUMMY_FE_MODULE) && \
-defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DUMMY_FE)
 extern struct dvb_frontend* dvb_dummy_fe_ofdm_attach(void);
 extern struct dvb_frontend* dvb_dummy_fe_qpsk_attach(void);
 extern struct dvb_frontend* dvb_dummy_fe_qam_attach(void);
diff --git a/drivers/media/dvb-frontends/ec100.h b/drivers/media/dvb-frontends/ec100.h
index b847971..3755840 100644
--- a/drivers/media/dvb-frontends/ec100.h
+++ b/drivers/media/dvb-frontends/ec100.h
@@ -22,6 +22,7 @@
 #ifndef EC100_H
 #define EC100_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct ec100_config {
@@ -30,8 +31,7 @@ struct ec100_config {
 };
 
 
-#if defined(CONFIG_DVB_EC100) || \
-	(defined(CONFIG_DVB_EC100_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_EC100)
 extern struct dvb_frontend *ec100_attach(const struct ec100_config *config,
 	struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/hd29l2.h b/drivers/media/dvb-frontends/hd29l2.h
index 4ad00d7..05cd130 100644
--- a/drivers/media/dvb-frontends/hd29l2.h
+++ b/drivers/media/dvb-frontends/hd29l2.h
@@ -23,6 +23,7 @@
 #ifndef HD29L2_H
 #define HD29L2_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct hd29l2_config {
@@ -50,8 +51,7 @@ struct hd29l2_config {
 };
 
 
-#if defined(CONFIG_DVB_HD29L2) || \
-	(defined(CONFIG_DVB_HD29L2_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_HD29L2)
 extern struct dvb_frontend *hd29l2_attach(const struct hd29l2_config *config,
 	struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/it913x-fe.h b/drivers/media/dvb-frontends/it913x-fe.h
index 07fa459..df0ad42 100644
--- a/drivers/media/dvb-frontends/it913x-fe.h
+++ b/drivers/media/dvb-frontends/it913x-fe.h
@@ -21,6 +21,7 @@
 #ifndef IT913X_FE_H
 #define IT913X_FE_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
@@ -38,8 +39,7 @@ struct ite_config {
 	u8 read_slevel;
 };
 
-#if defined(CONFIG_DVB_IT913X_FE) || (defined(CONFIG_DVB_IT913X_FE_MODULE) && \
-defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_IT913X_FE)
 extern struct dvb_frontend *it913x_fe_attach(struct i2c_adapter *i2c_adap,
 			u8 i2c_addr, struct ite_config *config);
 #else
diff --git a/drivers/media/dvb-frontends/ix2505v.h b/drivers/media/dvb-frontends/ix2505v.h
index 67e89d6..1a735a7 100644
--- a/drivers/media/dvb-frontends/ix2505v.h
+++ b/drivers/media/dvb-frontends/ix2505v.h
@@ -20,6 +20,7 @@
 #ifndef DVB_IX2505V_H
 #define DVB_IX2505V_H
 
+#include <linux/kconfig.h>
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
@@ -48,8 +49,7 @@ struct ix2505v_config {
 
 };
 
-#if defined(CONFIG_DVB_IX2505V) || \
-	(defined(CONFIG_DVB_IX2505V_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_IX2505V)
 extern struct dvb_frontend *ix2505v_attach(struct dvb_frontend *fe,
 	const struct ix2505v_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/lg2160.h b/drivers/media/dvb-frontends/lg2160.h
index 9e2c0f4..a5f0368 100644
--- a/drivers/media/dvb-frontends/lg2160.h
+++ b/drivers/media/dvb-frontends/lg2160.h
@@ -22,6 +22,7 @@
 #ifndef _LG2160_H_
 #define _LG2160_H_
 
+#include <linux/kconfig.h>
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
@@ -66,8 +67,7 @@ struct lg2160_config {
 	enum lg_chip_type lg_chip;
 };
 
-#if defined(CONFIG_DVB_LG2160) || (defined(CONFIG_DVB_LG2160_MODULE) && \
-				     defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LG2160)
 extern
 struct dvb_frontend *lg2160_attach(const struct lg2160_config *config,
 				     struct i2c_adapter *i2c_adap);
diff --git a/drivers/media/dvb-frontends/lgdt3305.h b/drivers/media/dvb-frontends/lgdt3305.h
index 02172ec..d9ab556 100644
--- a/drivers/media/dvb-frontends/lgdt3305.h
+++ b/drivers/media/dvb-frontends/lgdt3305.h
@@ -22,6 +22,7 @@
 #ifndef _LGDT3305_H_
 #define _LGDT3305_H_
 
+#include <linux/kconfig.h>
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
@@ -73,8 +74,7 @@ struct lgdt3305_config {
 	enum lgdt_demod_chip_type demod_chip;
 };
 
-#if defined(CONFIG_DVB_LGDT3305) || (defined(CONFIG_DVB_LGDT3305_MODULE) && \
-				     defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LGDT3305)
 extern
 struct dvb_frontend *lgdt3305_attach(const struct lgdt3305_config *config,
 				     struct i2c_adapter *i2c_adap);
diff --git a/drivers/media/dvb-frontends/lgs8gl5.h b/drivers/media/dvb-frontends/lgs8gl5.h
index d1417678..c2da596 100644
--- a/drivers/media/dvb-frontends/lgs8gl5.h
+++ b/drivers/media/dvb-frontends/lgs8gl5.h
@@ -23,6 +23,7 @@
 #ifndef LGS8GL5_H
 #define LGS8GL5_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct lgs8gl5_config {
@@ -30,8 +31,7 @@ struct lgs8gl5_config {
 	u8 demod_address;
 };
 
-#if defined(CONFIG_DVB_LGS8GL5) || \
-	(defined(CONFIG_DVB_LGS8GL5_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LGS8GL5)
 extern struct dvb_frontend *lgs8gl5_attach(
 	const struct lgs8gl5_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/lgs8gxx.h b/drivers/media/dvb-frontends/lgs8gxx.h
index 33c3c5e..dadb78b 100644
--- a/drivers/media/dvb-frontends/lgs8gxx.h
+++ b/drivers/media/dvb-frontends/lgs8gxx.h
@@ -26,6 +26,7 @@
 #ifndef __LGS8GXX_H__
 #define __LGS8GXX_H__
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
@@ -79,8 +80,7 @@ struct lgs8gxx_config {
 	u8 tuner_address;
 };
 
-#if defined(CONFIG_DVB_LGS8GXX) || \
-	(defined(CONFIG_DVB_LGS8GXX_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LGS8GXX)
 extern struct dvb_frontend *lgs8gxx_attach(const struct lgs8gxx_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/lnbh24.h b/drivers/media/dvb-frontends/lnbh24.h
index c059b16..b327a4f 100644
--- a/drivers/media/dvb-frontends/lnbh24.h
+++ b/drivers/media/dvb-frontends/lnbh24.h
@@ -23,6 +23,8 @@
 #ifndef _LNBH24_H
 #define _LNBH24_H
 
+#include <linux/kconfig.h>
+
 /* system register bits */
 #define LNBH24_OLF	0x01
 #define LNBH24_OTF	0x02
@@ -35,8 +37,7 @@
 
 #include <linux/dvb/frontend.h>
 
-#if defined(CONFIG_DVB_LNBP21) || (defined(CONFIG_DVB_LNBP21_MODULE) \
-							&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LNBP21)
 /* override_set and override_clear control which
    system register bits (above) to always set & clear */
 extern struct dvb_frontend *lnbh24_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/lnbp21.h b/drivers/media/dvb-frontends/lnbp21.h
index fcdf1c6..dbcbcc2 100644
--- a/drivers/media/dvb-frontends/lnbp21.h
+++ b/drivers/media/dvb-frontends/lnbp21.h
@@ -27,6 +27,8 @@
 #ifndef _LNBP21_H
 #define _LNBP21_H
 
+#include <linux/kconfig.h>
+
 /* system register bits */
 /* [RO] 0=OK; 1=over current limit flag */
 #define LNBP21_OLF	0x01
@@ -55,8 +57,7 @@
 
 #include <linux/dvb/frontend.h>
 
-#if defined(CONFIG_DVB_LNBP21) || (defined(CONFIG_DVB_LNBP21_MODULE) \
-							&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LNBP21)
 /* override_set and override_clear control which
  system register bits (above) to always set & clear */
 extern struct dvb_frontend *lnbp21_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/lnbp22.h b/drivers/media/dvb-frontends/lnbp22.h
index 63e2dec..63861b3 100644
--- a/drivers/media/dvb-frontends/lnbp22.h
+++ b/drivers/media/dvb-frontends/lnbp22.h
@@ -28,6 +28,8 @@
 #ifndef _LNBP22_H
 #define _LNBP22_H
 
+#include <linux/kconfig.h>
+
 /* Enable */
 #define LNBP22_EN	  0x10
 /* Voltage selection */
@@ -37,8 +39,7 @@
 
 #include <linux/dvb/frontend.h>
 
-#if defined(CONFIG_DVB_LNBP22) || \
-		(defined(CONFIG_DVB_LNBP22_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LNBP22)
 /*
  * override_set and override_clear control which system register bits (above)
  * to always set & clear
diff --git a/drivers/media/dvb-frontends/m88rs2000.h b/drivers/media/dvb-frontends/m88rs2000.h
index 5a8023e..14ce31e 100644
--- a/drivers/media/dvb-frontends/m88rs2000.h
+++ b/drivers/media/dvb-frontends/m88rs2000.h
@@ -20,6 +20,7 @@
 #ifndef M88RS2000_H
 #define M88RS2000_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
@@ -40,8 +41,7 @@ enum {
 	CALL_IS_READ,
 };
 
-#if defined(CONFIG_DVB_M88RS2000) || (defined(CONFIG_DVB_M88RS2000_MODULE) && \
-							defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_M88RS2000)
 extern struct dvb_frontend *m88rs2000_attach(
 	const struct m88rs2000_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/mb86a20s.h b/drivers/media/dvb-frontends/mb86a20s.h
index 1a7dea2..6627a39 100644
--- a/drivers/media/dvb-frontends/mb86a20s.h
+++ b/drivers/media/dvb-frontends/mb86a20s.h
@@ -16,6 +16,7 @@
 #ifndef MB86A20S_H
 #define MB86A20S_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 /**
@@ -33,8 +34,7 @@ struct mb86a20s_config {
 	bool	is_serial;
 };
 
-#if defined(CONFIG_DVB_MB86A20S) || (defined(CONFIG_DVB_MB86A20S_MODULE) \
-	&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_MB86A20S)
 extern struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 					   struct i2c_adapter *i2c);
 extern struct i2c_adapter *mb86a20s_get_tuner_i2c_adapter(struct dvb_frontend *);
diff --git a/drivers/media/dvb-frontends/rtl2830.h b/drivers/media/dvb-frontends/rtl2830.h
index f4349a1..3313847 100644
--- a/drivers/media/dvb-frontends/rtl2830.h
+++ b/drivers/media/dvb-frontends/rtl2830.h
@@ -21,6 +21,7 @@
 #ifndef RTL2830_H
 #define RTL2830_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct rtl2830_config {
@@ -59,8 +60,7 @@ struct rtl2830_config {
 	u8 agc_targ_val;
 };
 
-#if defined(CONFIG_DVB_RTL2830) || \
-	(defined(CONFIG_DVB_RTL2830_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_RTL2830)
 extern struct dvb_frontend *rtl2830_attach(
 	const struct rtl2830_config *config,
 	struct i2c_adapter *i2c
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index 785a466..fefba0e 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -21,6 +21,7 @@
 #ifndef RTL2832_H
 #define RTL2832_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct rtl2832_config {
@@ -54,8 +55,7 @@ struct rtl2832_config {
 	u8 tuner;
 };
 
-#if defined(CONFIG_DVB_RTL2832) || \
-	(defined(CONFIG_DVB_RTL2832_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_RTL2832)
 extern struct dvb_frontend *rtl2832_attach(
 	const struct rtl2832_config *cfg,
 	struct i2c_adapter *i2c
diff --git a/drivers/media/dvb-frontends/s5h1409.h b/drivers/media/dvb-frontends/s5h1409.h
index 91f2ebd..63b1e0a 100644
--- a/drivers/media/dvb-frontends/s5h1409.h
+++ b/drivers/media/dvb-frontends/s5h1409.h
@@ -22,6 +22,7 @@
 #ifndef __S5H1409_H__
 #define __S5H1409_H__
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct s5h1409_config {
@@ -66,8 +67,7 @@ struct s5h1409_config {
 	u8 hvr1600_opt;
 };
 
-#if defined(CONFIG_DVB_S5H1409) || (defined(CONFIG_DVB_S5H1409_MODULE) \
-	&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_S5H1409)
 extern struct dvb_frontend *s5h1409_attach(const struct s5h1409_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/s5h1411.h b/drivers/media/dvb-frontends/s5h1411.h
index 45ec0f8..e4f5687 100644
--- a/drivers/media/dvb-frontends/s5h1411.h
+++ b/drivers/media/dvb-frontends/s5h1411.h
@@ -22,6 +22,7 @@
 #ifndef __S5H1411_H__
 #define __S5H1411_H__
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 #define S5H1411_I2C_TOP_ADDR (0x32 >> 1)
@@ -68,8 +69,7 @@ struct s5h1411_config {
 	u8 status_mode;
 };
 
-#if defined(CONFIG_DVB_S5H1411) || \
-	(defined(CONFIG_DVB_S5H1411_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_S5H1411)
 extern struct dvb_frontend *s5h1411_attach(const struct s5h1411_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/s5h1432.h b/drivers/media/dvb-frontends/s5h1432.h
index b57438c..70917dd 100644
--- a/drivers/media/dvb-frontends/s5h1432.h
+++ b/drivers/media/dvb-frontends/s5h1432.h
@@ -22,6 +22,7 @@
 #ifndef __S5H1432_H__
 #define __S5H1432_H__
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 #define S5H1432_I2C_TOP_ADDR (0x02 >> 1)
@@ -74,8 +75,7 @@ struct s5h1432_config {
 	u8 status_mode;
 };
 
-#if defined(CONFIG_DVB_S5H1432) || \
-	(defined(CONFIG_DVB_S5H1432_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_S5H1432)
 extern struct dvb_frontend *s5h1432_attach(const struct s5h1432_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/s921.h b/drivers/media/dvb-frontends/s921.h
index f220d82..8d5e2a6 100644
--- a/drivers/media/dvb-frontends/s921.h
+++ b/drivers/media/dvb-frontends/s921.h
@@ -17,6 +17,7 @@
 #ifndef S921_H
 #define S921_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct s921_config {
@@ -24,8 +25,7 @@ struct s921_config {
 	u8 demod_address;
 };
 
-#if defined(CONFIG_DVB_S921) || (defined(CONFIG_DVB_S921_MODULE) \
-	&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_S921)
 extern struct dvb_frontend *s921_attach(const struct s921_config *config,
 					   struct i2c_adapter *i2c);
 extern struct i2c_adapter *s921_get_tuner_i2c_adapter(struct dvb_frontend *);
diff --git a/drivers/media/dvb-frontends/si21xx.h b/drivers/media/dvb-frontends/si21xx.h
index 141b5b8..1509fed 100644
--- a/drivers/media/dvb-frontends/si21xx.h
+++ b/drivers/media/dvb-frontends/si21xx.h
@@ -1,6 +1,7 @@
 #ifndef SI21XX_H
 #define SI21XX_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
@@ -12,8 +13,7 @@ struct si21xx_config {
 	int min_delay_ms;
 };
 
-#if defined(CONFIG_DVB_SI21XX) || \
-		(defined(CONFIG_DVB_SI21XX_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_SI21XX)
 extern struct dvb_frontend *si21xx_attach(const struct si21xx_config *config,
 						struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/stb6000.h b/drivers/media/dvb-frontends/stb6000.h
index 7be479c..a768189 100644
--- a/drivers/media/dvb-frontends/stb6000.h
+++ b/drivers/media/dvb-frontends/stb6000.h
@@ -23,6 +23,7 @@
 #ifndef __DVB_STB6000_H__
 #define __DVB_STB6000_H__
 
+#include <linux/kconfig.h>
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
@@ -34,8 +35,7 @@
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
index f2b53db..a0bd931 100644
--- a/drivers/media/dvb-frontends/stv0288.h
+++ b/drivers/media/dvb-frontends/stv0288.h
@@ -27,6 +27,7 @@
 #ifndef STV0288_H
 #define STV0288_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
@@ -42,8 +43,7 @@ struct stv0288_config {
 	int (*set_ts_params)(struct dvb_frontend *fe, int is_punctured);
 };
 
-#if defined(CONFIG_DVB_STV0288) || (defined(CONFIG_DVB_STV0288_MODULE) && \
-							defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STV0288)
 extern struct dvb_frontend *stv0288_attach(const struct stv0288_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/stv0367.h b/drivers/media/dvb-frontends/stv0367.h
index 93cc4a5..ea80b34 100644
--- a/drivers/media/dvb-frontends/stv0367.h
+++ b/drivers/media/dvb-frontends/stv0367.h
@@ -26,6 +26,7 @@
 #ifndef STV0367_H
 #define STV0367_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
@@ -38,8 +39,7 @@ struct stv0367_config {
 	int clk_pol;
 };
 
-#if defined(CONFIG_DVB_STV0367) || (defined(CONFIG_DVB_STV0367_MODULE) \
-							&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STV0367)
 extern struct
 dvb_frontend *stv0367ter_attach(const struct stv0367_config *config,
 					struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/stv0900.h b/drivers/media/dvb-frontends/stv0900.h
index 91c7ee8..e2a6dc6 100644
--- a/drivers/media/dvb-frontends/stv0900.h
+++ b/drivers/media/dvb-frontends/stv0900.h
@@ -26,6 +26,7 @@
 #ifndef STV0900_H
 #define STV0900_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
@@ -57,8 +58,7 @@ struct stv0900_config {
 	void (*set_lock_led)(struct dvb_frontend *fe, int offon);
 };
 
-#if defined(CONFIG_DVB_STV0900) || (defined(CONFIG_DVB_STV0900_MODULE) \
-							&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STV0900)
 extern struct dvb_frontend *stv0900_attach(const struct stv0900_config *config,
 					struct i2c_adapter *i2c, int demod);
 #else
diff --git a/drivers/media/dvb-frontends/stv6110.h b/drivers/media/dvb-frontends/stv6110.h
index fe71bba..8fa07e6 100644
--- a/drivers/media/dvb-frontends/stv6110.h
+++ b/drivers/media/dvb-frontends/stv6110.h
@@ -25,6 +25,7 @@
 #ifndef __DVB_STV6110_H__
 #define __DVB_STV6110_H__
 
+#include <linux/kconfig.h>
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
@@ -45,8 +46,7 @@ struct stv6110_config {
 	u8 clk_div;	/* divisor value for the output clock */
 };
 
-#if defined(CONFIG_DVB_STV6110) || (defined(CONFIG_DVB_STV6110_MODULE) \
-							&& defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STV6110)
 extern struct dvb_frontend *stv6110_attach(struct dvb_frontend *fe,
 					const struct stv6110_config *config,
 					struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/tda10048.h b/drivers/media/dvb-frontends/tda10048.h
index fb2ef5a..5e7bf4e 100644
--- a/drivers/media/dvb-frontends/tda10048.h
+++ b/drivers/media/dvb-frontends/tda10048.h
@@ -22,6 +22,7 @@
 #ifndef TDA10048_H
 #define TDA10048_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include <linux/firmware.h>
 
@@ -72,8 +73,7 @@ struct tda10048_config {
 	u8 pll_n;
 };
 
-#if defined(CONFIG_DVB_TDA10048) || \
-	(defined(CONFIG_DVB_TDA10048_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TDA10048)
 extern struct dvb_frontend *tda10048_attach(
 	const struct tda10048_config *config,
 	struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/tda10071.h b/drivers/media/dvb-frontends/tda10071.h
index bff1c38..f9542f6 100644
--- a/drivers/media/dvb-frontends/tda10071.h
+++ b/drivers/media/dvb-frontends/tda10071.h
@@ -21,6 +21,7 @@
 #ifndef TDA10071_H
 #define TDA10071_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct tda10071_config {
@@ -71,8 +72,7 @@ struct tda10071_config {
 };
 
 
-#if defined(CONFIG_DVB_TDA10071) || \
-	(defined(CONFIG_DVB_TDA10071_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TDA10071)
 extern struct dvb_frontend *tda10071_attach(
 	const struct tda10071_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/tda18271c2dd.h b/drivers/media/dvb-frontends/tda18271c2dd.h
index 1389c74..dd84f7b 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.h
+++ b/drivers/media/dvb-frontends/tda18271c2dd.h
@@ -1,7 +1,9 @@
 #ifndef _TDA18271C2DD_H_
 #define _TDA18271C2DD_H_
-#if defined(CONFIG_DVB_TDA18271C2DD) || (defined(CONFIG_DVB_TDA18271C2DD_MODULE) \
-        && defined(MODULE))
+
+#include <linux/kconfig.h>
+
+#if IS_ENABLED(CONFIG_DVB_TDA18271C2DD)
 struct dvb_frontend *tda18271c2dd_attach(struct dvb_frontend *fe,
 					 struct i2c_adapter *i2c, u8 adr);
 #else
diff --git a/drivers/media/dvb-frontends/ts2020.h b/drivers/media/dvb-frontends/ts2020.h
index c7e64af..5bcb9a7 100644
--- a/drivers/media/dvb-frontends/ts2020.h
+++ b/drivers/media/dvb-frontends/ts2020.h
@@ -22,6 +22,7 @@
 #ifndef TS2020_H
 #define TS2020_H
 
+#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct ts2020_config {
@@ -29,8 +30,7 @@ struct ts2020_config {
 	u8 clk_out_div;
 };
 
-#if defined(CONFIG_DVB_TS2020) || \
-	(defined(CONFIG_DVB_TS2020_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TS2020)
 
 extern struct dvb_frontend *ts2020_attach(
 	struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/zl10036.h b/drivers/media/dvb-frontends/zl10036.h
index d84b8f8..5f1e821 100644
--- a/drivers/media/dvb-frontends/zl10036.h
+++ b/drivers/media/dvb-frontends/zl10036.h
@@ -21,6 +21,7 @@
 #ifndef DVB_ZL10036_H
 #define DVB_ZL10036_H
 
+#include <linux/kconfig.h>
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
@@ -37,8 +38,7 @@ struct zl10036_config {
 	int rf_loop_enable;
 };
 
-#if defined(CONFIG_DVB_ZL10036) || \
-	(defined(CONFIG_DVB_ZL10036_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_ZL10036)
 extern struct dvb_frontend *zl10036_attach(struct dvb_frontend *fe,
 	const struct zl10036_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/zl10039.h b/drivers/media/dvb-frontends/zl10039.h
index 5eee7ea..750b9bc 100644
--- a/drivers/media/dvb-frontends/zl10039.h
+++ b/drivers/media/dvb-frontends/zl10039.h
@@ -22,8 +22,9 @@
 #ifndef ZL10039_H
 #define ZL10039_H
 
-#if defined(CONFIG_DVB_ZL10039) || (defined(CONFIG_DVB_ZL10039_MODULE) \
-	    && defined(MODULE))
+#include <linux/kconfig.h>
+
+#if IS_ENABLED(CONFIG_DVB_ZL10039)
 struct dvb_frontend *zl10039_attach(struct dvb_frontend *fe,
 					u8 i2c_addr,
 					struct i2c_adapter *i2c);
-- 
1.8.1.4

