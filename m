Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50982 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933342AbaDIQOz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 12:14:55 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Antti Palosaari <crope@iki.fi>, backports@vger.kernel.org
Subject: [PATCH] rtl28xxu: do not hard depend on staging SDR module
Date: Wed,  9 Apr 2014 19:14:29 +0300
Message-Id: <1397060069-12757-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RTL2832 SDR extension module is currently on staging. SDR module
headers were included from staging causing direct dependency staging
directory. As a solution, add needed headers to main driver.
Motivation of that change comes from Luis / driver backports project.

Another issues was a little too heavy looking error log "DVB: Unable
to find symbol rtl2832_sdr_attach()" when staging module was disabled.
Get rid of it too by introducing own version of dvb_attach() macro
without the error text.

Reported-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Cc: backports@vger.kernel.org
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/Makefile   |  1 -
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 48 +++++++++++++++++++++++++++++----
 2 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/Makefile b/drivers/media/usb/dvb-usb-v2/Makefile
index 7407b83..bc38f03 100644
--- a/drivers/media/usb/dvb-usb-v2/Makefile
+++ b/drivers/media/usb/dvb-usb-v2/Makefile
@@ -41,4 +41,3 @@ ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 ccflags-y += -I$(srctree)/drivers/media/tuners
 ccflags-y += -I$(srctree)/drivers/media/common
-ccflags-y += -I$(srctree)/drivers/staging/media/rtl2832u_sdr
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c83c16c..f58a952 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -24,7 +24,6 @@
 
 #include "rtl2830.h"
 #include "rtl2832.h"
-#include "rtl2832_sdr.h"
 
 #include "qt1010.h"
 #include "mt2060.h"
@@ -36,6 +35,45 @@
 #include "tua9001.h"
 #include "r820t.h"
 
+/*
+ * RTL2832_SDR module is in staging. That logic is added in order to avoid any
+ * hard dependency to drivers/staging/ directory as we want compile mainline
+ * driver even whole staging directory is missing.
+ */
+#include <media/v4l2-subdev.h>
+
+#ifdef CONFIG_MEDIA_ATTACH
+#define dvb_attach_sdr(FUNCTION, ARGS...) ({ \
+	void *__r = NULL; \
+	typeof(&FUNCTION) __a = symbol_request(FUNCTION); \
+	if (__a) { \
+		__r = (void *) __a(ARGS); \
+		if (__r == NULL) \
+			symbol_put(FUNCTION); \
+	} \
+	__r; \
+})
+
+#else
+#define dvb_attach_sdr(FUNCTION, ARGS...) ({ \
+	FUNCTION(ARGS); \
+})
+
+#endif
+
+#if IS_ENABLED(CONFIG_DVB_RTL2832_SDR)
+extern struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
+	struct i2c_adapter *i2c, const struct rtl2832_config *cfg,
+	struct v4l2_subdev *sd);
+#else
+static inline struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
+	struct i2c_adapter *i2c, const struct rtl2832_config *cfg,
+	struct v4l2_subdev *sd)
+{
+	return NULL;
+}
+#endif
+
 static int rtl28xxu_disable_rc;
 module_param_named(disable_rc, rtl28xxu_disable_rc, int, 0644);
 MODULE_PARM_DESC(disable_rc, "disable RTL2832U remote controller");
@@ -908,7 +946,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
 
 		/* attach SDR */
-		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
+		dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
 				&rtl28xxu_rtl2832_fc0012_config, NULL);
 		break;
 	case TUNER_RTL2832_FC0013:
@@ -920,7 +958,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
 
 		/* attach SDR */
-		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
+		dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
 				&rtl28xxu_rtl2832_fc0013_config, NULL);
 		break;
 	case TUNER_RTL2832_E4000: {
@@ -951,7 +989,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 			i2c_set_adapdata(i2c_adap_internal, d);
 
 			/* attach SDR */
-			dvb_attach(rtl2832_sdr_attach, adap->fe[0],
+			dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0],
 					i2c_adap_internal,
 					&rtl28xxu_rtl2832_e4000_config, sd);
 		}
@@ -982,7 +1020,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
 
 		/* attach SDR */
-		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
+		dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
 				&rtl28xxu_rtl2832_r820t_config, NULL);
 		break;
 	case TUNER_RTL2832_R828D:
-- 
1.9.0

