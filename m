Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:35685 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932192AbcLGSaa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2016 13:30:30 -0500
Received: by mail-pg0-f44.google.com with SMTP id p66so164614557pga.2
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2016 10:30:30 -0800 (PST)
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
Subject: [PATCH v6 2/5] [media] davinci: vpif_capture: remove hard-coded I2C adapter id
Date: Wed,  7 Dec 2016 10:30:22 -0800
Message-Id: <20161207183025.20684-3-khilman@baylibre.com>
In-Reply-To: <20161207183025.20684-1-khilman@baylibre.com>
References: <20161207183025.20684-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove hard-coded I2C adapter in favor of getting the
ID from platform_data.

Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 5 ++++-
 include/media/davinci/vpif_types.h            | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 20c4344ed118..c24049acd40a 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1486,7 +1486,10 @@ static __init int vpif_probe(struct platform_device *pdev)
 	}
 
 	if (!vpif_obj.config->asd_sizes) {
-		i2c_adap = i2c_get_adapter(1);
+		int i2c_id = vpif_obj.config->i2c_adapter_id;
+
+		i2c_adap = i2c_get_adapter(i2c_id);
+		WARN_ON(!i2c_adap);
 		for (i = 0; i < subdev_count; i++) {
 			subdevdata = &vpif_obj.config->subdev_info[i];
 			vpif_obj.sd[i] =
diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
index 3cb1704a0650..4282a7db99d4 100644
--- a/include/media/davinci/vpif_types.h
+++ b/include/media/davinci/vpif_types.h
@@ -82,6 +82,7 @@ struct vpif_capture_config {
 	struct vpif_capture_chan_config chan_config[VPIF_CAPTURE_MAX_CHANNELS];
 	struct vpif_subdev_info *subdev_info;
 	int subdev_count;
+	int i2c_adapter_id;
 	const char *card_name;
 	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
 	int *asd_sizes;		/* 0-terminated array of asd group sizes */
-- 
2.9.3

