Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44088 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbaBIItz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:55 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 03/86] rtl2832_sdr: use config struct from rtl2832 module
Date: Sun,  9 Feb 2014 10:48:08 +0200
Message-Id: <1391935771-18670-4-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is absolutely no need to define own configuration struct as
same params are used demod main module. So use existing config.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c          | 5 +----
 drivers/staging/media/rtl2832u_sdr/Makefile      | 1 +
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 4 ++--
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h | 9 ++++-----
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index b398ebf..ec6ab0f 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -735,9 +735,6 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
 	struct rtl2832_config *rtl2832_config;
-	static const struct rtl2832_sdr_config rtl2832_sdr_config = {
-		.i2c_addr = 0x10,
-	};
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
@@ -781,7 +778,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 
 	/* attach SDR */
 	dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
-			&rtl2832_sdr_config);
+			rtl2832_config);
 
 	return 0;
 err:
diff --git a/drivers/staging/media/rtl2832u_sdr/Makefile b/drivers/staging/media/rtl2832u_sdr/Makefile
index 684546776..1009276 100644
--- a/drivers/staging/media/rtl2832u_sdr/Makefile
+++ b/drivers/staging/media/rtl2832u_sdr/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_DVB_RTL2832_SDR) += rtl2832_sdr.o
 
 ccflags-y += -Idrivers/media/dvb-core
+ccflags-y += -Idrivers/media/dvb-frontends
 ccflags-y += -Idrivers/media/usb/dvb-usb-v2
diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 0b110a3..208520e 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -61,7 +61,7 @@ struct rtl2832_sdr_state {
 #define URB_BUF            (1 << 2)
 	unsigned long flags;
 
-	const struct rtl2832_sdr_config *cfg;
+	const struct rtl2832_config *cfg;
 	struct dvb_frontend *fe;
 	struct dvb_usb_device *d;
 	struct i2c_adapter *i2c;
@@ -1004,7 +1004,7 @@ static void rtl2832_sdr_video_release(struct v4l2_device *v)
 }
 
 struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
-		struct i2c_adapter *i2c, const struct rtl2832_sdr_config *cfg)
+		struct i2c_adapter *i2c, const struct rtl2832_config *cfg)
 {
 	int ret;
 	struct rtl2832_sdr_state *s;
diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h
index 69d97c1..0803e45 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h
@@ -33,16 +33,15 @@
 
 #include <linux/kconfig.h>
 
-struct rtl2832_sdr_config {
-	u8 i2c_addr;
-};
+/* for config struct */
+#include "rtl2832.h"
 
 #if IS_ENABLED(CONFIG_DVB_RTL2832_SDR)
 extern struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, const struct rtl2832_sdr_config *cfg);
+	struct i2c_adapter *i2c, const struct rtl2832_config *cfg);
 #else
 static inline struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, const struct rtl2832_sdr_config *cfg)
+	struct i2c_adapter *i2c, const struct rtl2832_config *cfg)
 {
 	dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
-- 
1.8.5.3

