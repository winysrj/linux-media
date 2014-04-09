Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39817 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933741AbaDIWFS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 18:05:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Antti Palosaari <crope@iki.fi>, backports@vger.kernel.org
Subject: [PATCHv3 1/2] rtl28xxu: do not hard depend on staging SDR module
Date: Thu, 10 Apr 2014 01:05:06 +0300
Message-Id: <1397081107-2249-2-git-send-email-crope@iki.fi>
In-Reply-To: <1397081107-2249-1-git-send-email-crope@iki.fi>
References: <1397081107-2249-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RTL2832 SDR extension module is currently on staging. SDR module
headers were included from staging causing direct dependency staging
directory. As a solution, add needed headers to main driver.
Motivation of that change comes from Luis / driver backports project.

Reported-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Cc: backports@vger.kernel.org
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/Makefile   |  1 -
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 21 ++++++++++++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

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
index c83c16c..8d7c5f2 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -24,7 +24,6 @@
 
 #include "rtl2830.h"
 #include "rtl2832.h"
-#include "rtl2832_sdr.h"
 
 #include "qt1010.h"
 #include "mt2060.h"
@@ -36,6 +35,26 @@
 #include "tua9001.h"
 #include "r820t.h"
 
+/*
+ * RTL2832_SDR module is in staging. That logic is added in order to avoid any
+ * hard dependency to drivers/staging/ directory as we want compile mainline
+ * driver even whole staging directory is missing.
+ */
+#include <media/v4l2-subdev.h>
+
+#if IS_ENABLED(CONFIG_DVB_RTL2832_SDR)
+struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
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
-- 
1.9.0

