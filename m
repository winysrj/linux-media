Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:33732 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752652AbcKSAcL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 19:32:11 -0500
Received: by mail-pf0-f169.google.com with SMTP id d2so56765256pfd.0
        for <linux-media@vger.kernel.org>; Fri, 18 Nov 2016 16:32:10 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: devicetree@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?q?Bartosz=20Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>
Subject: [PATCH 1/4] [media] davinci: add support for DT init
Date: Fri, 18 Nov 2016 16:32:05 -0800
Message-Id: <20161119003208.10550-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add basic support for initialization via DT.

Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/media/platform/davinci/vpif.c         |  9 +++++++++
 drivers/media/platform/davinci/vpif_capture.c | 14 ++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 0380cf2e5775..077e328e0281 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -464,8 +464,17 @@ static const struct dev_pm_ops vpif_pm = {
 #define vpif_pm_ops NULL
 #endif
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id vpif_of_match[] = {
+	{ .compatible = "ti,vpif", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, vpif_of_match);
+#endif
+
 static struct platform_driver vpif_driver = {
 	.driver = {
+		.of_match_table = of_match_ptr(vpif_of_match),
 		.name	= "vpif",
 		.pm	= vpif_pm_ops,
 	},
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 5104cc0ee40e..79cef74e164f 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1435,6 +1435,11 @@ static __init int vpif_probe(struct platform_device *pdev)
 	int res_idx = 0;
 	int i, err;
 
+	if (!pdev->dev.platform_data) {
+		dev_warn(&pdev->dev, "Missing platform data.  Giving up.\n");
+		return -EINVAL;
+	}
+
 	vpif_dev = &pdev->dev;
 
 	err = initialize_vpif();
@@ -1618,8 +1623,17 @@ static int vpif_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id vpif_capture_of_match[] = {
+	{ .compatible = "ti,vpif-capture", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, vpif_capture_of_match);
+#endif
+
 static __refdata struct platform_driver vpif_driver = {
 	.driver	= {
+		.of_match_table = of_match_ptr(vpif_capture_of_match),
 		.name	= VPIF_DRIVER_NAME,
 		.pm	= &vpif_pm_ops,
 	},
-- 
2.9.3

