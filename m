Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:49562 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754201AbdBGNDG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 08:03:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] zd1301: fix building interface driver without demodulator
Date: Tue,  7 Feb 2017 14:01:41 +0100
Message-Id: <20170207130202.521074-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the USB driver is enabled but the demodulator is not, we get a link error:

ERROR: "zd1301_demod_get_dvb_frontend" [drivers/media/usb/dvb-usb-v2/zd1301.ko] undefined!
ERROR: "zd1301_demod_get_i2c_adapter" [drivers/media/usb/dvb-usb-v2/zd1301.ko] undefined!

Such a configuration obviously makes no sense, but we should not fail
the build.  This tries to mimic what we have for other drivers by turning
the build failure into a runtime failure.

Alternatively we could use an unconditional 'select' or 'depends on' to enforce
a sane configuration.

Fixes: 47d65372b3b6 ("[media] zd1301_demod: ZyDAS ZD1301 DVB-T demodulator driver")
Fixes: 992b39872b80 ("[media] zd1301: ZyDAS ZD1301 DVB USB interface driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/dvb-frontends/zd1301_demod.h | 18 ++++++++++++++++++
 drivers/media/usb/dvb-usb-v2/zd1301.c      |  4 ++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/media/dvb-frontends/zd1301_demod.h b/drivers/media/dvb-frontends/zd1301_demod.h
index 78a3122e4942..ceb2e05e873c 100644
--- a/drivers/media/dvb-frontends/zd1301_demod.h
+++ b/drivers/media/dvb-frontends/zd1301_demod.h
@@ -34,6 +34,7 @@ struct zd1301_demod_platform_data {
 	int (*reg_write)(void *, u16, u8);
 };
 
+#if IS_REACHABLE(CONFIG_DVB_ZD1301_DEMOD)
 /**
  * zd1301_demod_get_dvb_frontend() - Get pointer to DVB frontend
  * @pdev: Pointer to platform device
@@ -52,4 +53,21 @@ struct dvb_frontend *zd1301_demod_get_dvb_frontend(struct platform_device *);
 
 struct i2c_adapter *zd1301_demod_get_i2c_adapter(struct platform_device *);
 
+#else
+
+static inline struct dvb_frontend *zd1301_demod_get_dvb_frontend(struct platform_device *dev)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+
+	return NULL;
+}
+static inline struct i2c_adapter *zd1301_demod_get_i2c_adapter(struct platform_device *dev)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+
+	return NULL;
+}
+
+#endif
+
 #endif /* ZD1301_DEMOD_H */
diff --git a/drivers/media/usb/dvb-usb-v2/zd1301.c b/drivers/media/usb/dvb-usb-v2/zd1301.c
index 563e50c6a327..d1eb4b7bc051 100644
--- a/drivers/media/usb/dvb-usb-v2/zd1301.c
+++ b/drivers/media/usb/dvb-usb-v2/zd1301.c
@@ -168,6 +168,10 @@ static int zd1301_frontend_attach(struct dvb_usb_adapter *adap)
 
 	adapter = zd1301_demod_get_i2c_adapter(pdev);
 	frontend = zd1301_demod_get_dvb_frontend(pdev);
+	if (!adapter || !frontend) {
+		ret = -ENODEV;
+		goto err_module_put_demod;
+	}
 
 	/* Add I2C tuner */
 	dev->mt2060_pdata.i2c_write_max = 9;
-- 
2.9.0

