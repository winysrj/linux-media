Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab3CWMfW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 08:35:22 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2NCZLTW008566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 23 Mar 2013 08:35:22 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 2/4] [media] tuners: use IS_ENABLED
Date: Sat, 23 Mar 2013 09:35:09 -0300
Message-Id: <1364042111-24708-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1364042111-24708-1-git-send-email-mchehab@redhat.com>
References: <1364042111-24708-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking everywhere there for 3 symbols, use instead
IS_ENABLED macro.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/e4000.h    | 4 ++--
 drivers/media/tuners/fc0011.h   | 4 ++--
 drivers/media/tuners/fc0012.h   | 4 ++--
 drivers/media/tuners/fc0013.h   | 4 ++--
 drivers/media/tuners/fc2580.h   | 4 ++--
 drivers/media/tuners/max2165.h  | 5 +++--
 drivers/media/tuners/mc44s803.h | 5 +++--
 drivers/media/tuners/mxl5005s.h | 5 +++--
 drivers/media/tuners/tda18212.h | 4 ++--
 drivers/media/tuners/tda18218.h | 4 ++--
 drivers/media/tuners/tua9001.h  | 4 ++--
 drivers/media/tuners/xc5000.h   | 4 ++--
 12 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/media/tuners/e4000.h b/drivers/media/tuners/e4000.h
index 71b1935..3783a0b 100644
--- a/drivers/media/tuners/e4000.h
+++ b/drivers/media/tuners/e4000.h
@@ -21,6 +21,7 @@
 #ifndef E4000_H
 #define E4000_H
 
+#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
 struct e4000_config {
@@ -36,8 +37,7 @@ struct e4000_config {
 	u32 clock;
 };
 
-#if defined(CONFIG_MEDIA_TUNER_E4000) || \
-	(defined(CONFIG_MEDIA_TUNER_E4000_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_E4000)
 extern struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
 		struct i2c_adapter *i2c, const struct e4000_config *cfg);
 #else
diff --git a/drivers/media/tuners/fc0011.h b/drivers/media/tuners/fc0011.h
index 0ee581f..43ec893 100644
--- a/drivers/media/tuners/fc0011.h
+++ b/drivers/media/tuners/fc0011.h
@@ -1,6 +1,7 @@
 #ifndef LINUX_FC0011_H_
 #define LINUX_FC0011_H_
 
+#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
 
@@ -22,8 +23,7 @@ enum fc0011_fe_callback_commands {
 	FC0011_FE_CALLBACK_RESET,
 };
 
-#if defined(CONFIG_MEDIA_TUNER_FC0011) ||\
-    defined(CONFIG_MEDIA_TUNER_FC0011_MODULE)
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_FC0011)
 struct dvb_frontend *fc0011_attach(struct dvb_frontend *fe,
 				   struct i2c_adapter *i2c,
 				   const struct fc0011_config *config);
diff --git a/drivers/media/tuners/fc0012.h b/drivers/media/tuners/fc0012.h
index 54508fc..1d08057 100644
--- a/drivers/media/tuners/fc0012.h
+++ b/drivers/media/tuners/fc0012.h
@@ -21,6 +21,7 @@
 #ifndef _FC0012_H_
 #define _FC0012_H_
 
+#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 #include "fc001x-common.h"
 
@@ -48,8 +49,7 @@ struct fc0012_config {
 	bool clock_out;
 };
 
-#if defined(CONFIG_MEDIA_TUNER_FC0012) || \
-	(defined(CONFIG_MEDIA_TUNER_FC0012_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_FC0012)
 extern struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
 					struct i2c_adapter *i2c,
 					const struct fc0012_config *cfg);
diff --git a/drivers/media/tuners/fc0013.h b/drivers/media/tuners/fc0013.h
index 594efd6..d65d5b3 100644
--- a/drivers/media/tuners/fc0013.h
+++ b/drivers/media/tuners/fc0013.h
@@ -22,11 +22,11 @@
 #ifndef _FC0013_H_
 #define _FC0013_H_
 
+#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 #include "fc001x-common.h"
 
-#if defined(CONFIG_MEDIA_TUNER_FC0013) || \
-	(defined(CONFIG_MEDIA_TUNER_FC0013_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_FC0013)
 extern struct dvb_frontend *fc0013_attach(struct dvb_frontend *fe,
 					struct i2c_adapter *i2c,
 					u8 i2c_address, int dual_master,
diff --git a/drivers/media/tuners/fc2580.h b/drivers/media/tuners/fc2580.h
index 222601e..9c43c1c 100644
--- a/drivers/media/tuners/fc2580.h
+++ b/drivers/media/tuners/fc2580.h
@@ -21,6 +21,7 @@
 #ifndef FC2580_H
 #define FC2580_H
 
+#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
 struct fc2580_config {
@@ -36,8 +37,7 @@ struct fc2580_config {
 	u32 clock;
 };
 
-#if defined(CONFIG_MEDIA_TUNER_FC2580) || \
-	(defined(CONFIG_MEDIA_TUNER_FC2580_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_FC2580)
 extern struct dvb_frontend *fc2580_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c, const struct fc2580_config *cfg);
 #else
diff --git a/drivers/media/tuners/max2165.h b/drivers/media/tuners/max2165.h
index c063c36..26e1dc6 100644
--- a/drivers/media/tuners/max2165.h
+++ b/drivers/media/tuners/max2165.h
@@ -22,6 +22,8 @@
 #ifndef __MAX2165_H__
 #define __MAX2165_H__
 
+#include <linux/kconfig.h>
+
 struct dvb_frontend;
 struct i2c_adapter;
 
@@ -30,8 +32,7 @@ struct max2165_config {
 	u8 osc_clk; /* in MHz, selectable values: 4,16,18,20,22,24,26,28 */
 };
 
-#if defined(CONFIG_MEDIA_TUNER_MAX2165) || \
-    (defined(CONFIG_MEDIA_TUNER_MAX2165_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_MAX2165)
 extern struct dvb_frontend *max2165_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c,
 	struct max2165_config *cfg);
diff --git a/drivers/media/tuners/mc44s803.h b/drivers/media/tuners/mc44s803.h
index 34f3892..9aae50a 100644
--- a/drivers/media/tuners/mc44s803.h
+++ b/drivers/media/tuners/mc44s803.h
@@ -22,6 +22,8 @@
 #ifndef MC44S803_H
 #define MC44S803_H
 
+#include <linux/kconfig.h>
+
 struct dvb_frontend;
 struct i2c_adapter;
 
@@ -30,8 +32,7 @@ struct mc44s803_config {
 	u8 dig_out;
 };
 
-#if defined(CONFIG_MEDIA_TUNER_MC44S803) || \
-    (defined(CONFIG_MEDIA_TUNER_MC44S803_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_MC44S803)
 extern struct dvb_frontend *mc44s803_attach(struct dvb_frontend *fe,
 	 struct i2c_adapter *i2c, struct mc44s803_config *cfg);
 #else
diff --git a/drivers/media/tuners/mxl5005s.h b/drivers/media/tuners/mxl5005s.h
index fc8a1ff..ae8db88 100644
--- a/drivers/media/tuners/mxl5005s.h
+++ b/drivers/media/tuners/mxl5005s.h
@@ -23,6 +23,8 @@
 #ifndef __MXL5005S_H
 #define __MXL5005S_H
 
+#include <linux/kconfig.h>
+
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
@@ -116,8 +118,7 @@ struct mxl5005s_config {
 	u8 AgcMasterByte;
 };
 
-#if defined(CONFIG_MEDIA_TUNER_MXL5005S) || \
-	(defined(CONFIG_MEDIA_TUNER_MXL5005S_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_MXL5005S)
 extern struct dvb_frontend *mxl5005s_attach(struct dvb_frontend *fe,
 					    struct i2c_adapter *i2c,
 					    struct mxl5005s_config *config);
diff --git a/drivers/media/tuners/tda18212.h b/drivers/media/tuners/tda18212.h
index 9bd5da4..7e0d503 100644
--- a/drivers/media/tuners/tda18212.h
+++ b/drivers/media/tuners/tda18212.h
@@ -21,6 +21,7 @@
 #ifndef TDA18212_H
 #define TDA18212_H
 
+#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
 struct tda18212_config {
@@ -36,8 +37,7 @@ struct tda18212_config {
 	u16 if_dvbc;
 };
 
-#if defined(CONFIG_MEDIA_TUNER_TDA18212) || \
-	(defined(CONFIG_MEDIA_TUNER_TDA18212_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA18212)
 extern struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c, struct tda18212_config *cfg);
 #else
diff --git a/drivers/media/tuners/tda18218.h b/drivers/media/tuners/tda18218.h
index b4180d1..366410e 100644
--- a/drivers/media/tuners/tda18218.h
+++ b/drivers/media/tuners/tda18218.h
@@ -21,6 +21,7 @@
 #ifndef TDA18218_H
 #define TDA18218_H
 
+#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
 struct tda18218_config {
@@ -29,8 +30,7 @@ struct tda18218_config {
 	u8 loop_through:1;
 };
 
-#if defined(CONFIG_MEDIA_TUNER_TDA18218) || \
-	(defined(CONFIG_MEDIA_TUNER_TDA18218_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA18218)
 extern struct dvb_frontend *tda18218_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c, struct tda18218_config *cfg);
 #else
diff --git a/drivers/media/tuners/tua9001.h b/drivers/media/tuners/tua9001.h
index cf5b815..26358da 100644
--- a/drivers/media/tuners/tua9001.h
+++ b/drivers/media/tuners/tua9001.h
@@ -21,6 +21,7 @@
 #ifndef TUA9001_H
 #define TUA9001_H
 
+#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
 struct tua9001_config {
@@ -50,8 +51,7 @@ struct tua9001_config {
 #define TUA9001_CMD_RESETN  1
 #define TUA9001_CMD_RXEN    2
 
-#if defined(CONFIG_MEDIA_TUNER_TUA9001) || \
-	(defined(CONFIG_MEDIA_TUNER_TUA9001_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_TUA9001)
 extern struct dvb_frontend *tua9001_attach(struct dvb_frontend *fe,
 		struct i2c_adapter *i2c, struct tua9001_config *cfg);
 #else
diff --git a/drivers/media/tuners/xc5000.h b/drivers/media/tuners/xc5000.h
index b1a5474..7245cae 100644
--- a/drivers/media/tuners/xc5000.h
+++ b/drivers/media/tuners/xc5000.h
@@ -22,6 +22,7 @@
 #ifndef __XC5000_H__
 #define __XC5000_H__
 
+#include <linux/kconfig.h>
 #include <linux/firmware.h>
 
 struct dvb_frontend;
@@ -56,8 +57,7 @@ struct xc5000_config {
  * it's passed back to a bridge during tuner_callback().
  */
 
-#if defined(CONFIG_MEDIA_TUNER_XC5000) || \
-    (defined(CONFIG_MEDIA_TUNER_XC5000_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_XC5000)
 extern struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
 					  struct i2c_adapter *i2c,
 					  const struct xc5000_config *cfg);
-- 
1.8.1.4

