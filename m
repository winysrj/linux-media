Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54749 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbeKHWZg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 17:25:36 -0500
Received: by mail-wm1-f65.google.com with SMTP id r63-v6so1140312wma.4
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2018 04:50:14 -0800 (PST)
From: Neil Armstrong <narmstrong@baylibre.com>
To: Yasunari.Takiguchi@sony.com
Cc: Neil Armstrong <narmstrong@baylibre.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] media: cxd2880-spi: Add optional vcc regulator
Date: Thu,  8 Nov 2018 13:50:09 +0100
Message-Id: <1541681410-8187-2-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1541681410-8187-1-git-send-email-narmstrong@baylibre.com>
References: <1541681410-8187-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds an optional VCC regulator to the driver probe function to
make sure power is enabled to the module before starting attaching to
the device.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 drivers/media/spi/cxd2880-spi.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/spi/cxd2880-spi.c b/drivers/media/spi/cxd2880-spi.c
index c437309..d5c433e 100644
--- a/drivers/media/spi/cxd2880-spi.c
+++ b/drivers/media/spi/cxd2880-spi.c
@@ -10,6 +10,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
 
 #include <linux/spi/spi.h>
+#include <linux/regulator/consumer.h>
 #include <linux/ktime.h>
 
 #include <media/dvb_demux.h>
@@ -51,6 +52,7 @@ struct cxd2880_dvb_spi {
 	struct mutex spi_mutex; /* For SPI access exclusive control */
 	int feed_count;
 	int all_pid_feed_count;
+	struct regulator *vcc_supply;
 	u8 *ts_buf;
 	struct cxd2880_pid_filter_config filter_config;
 };
@@ -518,6 +520,17 @@ cxd2880_spi_probe(struct spi_device *spi)
 	if (!dvb_spi)
 		return -ENOMEM;
 
+	dvb_spi->vcc_supply = devm_regulator_get_optional(&spi->dev, "vcc");
+	if (IS_ERR(dvb_spi->vcc_supply)) {
+		if (PTR_ERR(dvb_spi->vcc_supply) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		dvb_spi->vcc_supply = NULL;
+	} else {
+		ret = regulator_enable(dvb_spi->vcc_supply);
+		if (ret)
+			return ret;
+	}
+
 	dvb_spi->spi = spi;
 	mutex_init(&dvb_spi->spi_mutex);
 	dev_set_drvdata(&spi->dev, dvb_spi);
@@ -631,6 +644,9 @@ cxd2880_spi_remove(struct spi_device *spi)
 	dvb_frontend_detach(&dvb_spi->dvb_fe);
 	dvb_unregister_adapter(&dvb_spi->adapter);
 
+	if (dvb_spi->vcc_supply)
+		regulator_disable(dvb_spi->vcc_supply);
+
 	kfree(dvb_spi);
 	pr_info("cxd2880_spi remove ok.\n");
 
-- 
2.7.4
