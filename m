Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36602 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932192AbcLGSad (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2016 13:30:33 -0500
Received: by mail-pf0-f175.google.com with SMTP id 189so78662838pfz.3
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2016 10:30:33 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Cc: Sekhar Nori <nsekhar@ti.com>, Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?q?Bartosz=20Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 5/5] [media] davinci: VPIF: add basic support for DT init
Date: Wed,  7 Dec 2016 10:30:25 -0800
Message-Id: <20161207183025.20684-6-khilman@baylibre.com>
In-Reply-To: <20161207183025.20684-1-khilman@baylibre.com>
References: <20161207183025.20684-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add basic support for initialization via DT

Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/media/platform/davinci/vpif.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index f50148dcba64..1b02a6363f77 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -467,8 +467,17 @@ static const struct dev_pm_ops vpif_pm = {
 #define vpif_pm_ops NULL
 #endif
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id vpif_of_match[] = {
+	{ .compatible = "ti,da850-vpif", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, vpif_of_match);
+#endif
+
 static struct platform_driver vpif_driver = {
 	.driver = {
+		.of_match_table = of_match_ptr(vpif_of_match),
 		.name	= VPIF_DRIVER_NAME,
 		.pm	= vpif_pm_ops,
 	},
-- 
2.9.3

