Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37407 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932352AbdBVN16 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 08:27:58 -0500
Received: by mail-wm0-f51.google.com with SMTP id v77so1949117wmv.0
        for <linux-media@vger.kernel.org>; Wed, 22 Feb 2017 05:27:57 -0800 (PST)
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Russell King <linux@armlinux.org.uk>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH] media: vpif: request enable-gpios
Date: Wed, 22 Feb 2017 14:27:51 +0100
Message-Id: <1487770071-5157-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change is needed to make vpif capture work on the da850-evm board
where the capture function must be selected on the UI expander.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index b62a399..7dea358 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/gpio/consumer.h>
 
 #include <media/v4l2-ioctl.h>
 
@@ -1433,6 +1434,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
 	struct i2c_adapter *i2c_adap;
+	struct gpio_descs *descs;
 	struct resource *res;
 	int subdev_count;
 	int res_idx = 0;
@@ -1443,6 +1445,11 @@ static __init int vpif_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	descs = devm_gpiod_get_array_optional(&pdev->dev,
+					      "enable", GPIOD_OUT_HIGH);
+	if (IS_ERR(descs))
+		dev_err(&pdev->dev, "Error requesting enable GPIOs\n");
+
 	vpif_dev = &pdev->dev;
 
 	err = initialize_vpif();
-- 
2.9.3
