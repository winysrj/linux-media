Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37021 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933050AbdBPSIP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 13:08:15 -0500
Received: by mail-wm0-f54.google.com with SMTP id v77so21629357wmv.0
        for <linux-media@vger.kernel.org>; Thu, 16 Feb 2017 10:08:15 -0800 (PST)
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
Subject: [PATCH] media: vpif: use a configurable i2c_adapter_id for vpif display
Date: Thu, 16 Feb 2017 19:08:01 +0100
Message-Id: <1487268481-6127-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vpif display driver uses a static i2c adapter ID of 1 but on the
da850-evm board in DT boot mode the i2c adapter ID is actually 0.

Make the adapter ID configurable like it already is for vpif capture.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Acked-by: Kevin Hilman <khilman@baylibre.com>
---
 arch/arm/mach-davinci/board-da850-evm.c       | 1 +
 drivers/media/platform/davinci/vpif_display.c | 2 +-
 include/media/davinci/vpif_types.h            | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index df3ca38..6f1e129 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1290,6 +1290,7 @@ static struct vpif_display_config da850_vpif_display_config = {
 		.output_count = ARRAY_SIZE(da850_ch0_outputs),
 	},
 	.card_name    = "DA850/OMAP-L138 Video Display",
+	.i2c_adapter_id = 1,
 };
 
 static __init void da850_vpif_init(void)
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 50c3073..7e5cf99 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1287,7 +1287,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	}
 
 	if (!vpif_obj.config->asd_sizes) {
-		i2c_adap = i2c_get_adapter(1);
+		i2c_adap = i2c_get_adapter(vpif_obj.config->i2c_adapter_id);
 		for (i = 0; i < subdev_count; i++) {
 			vpif_obj.sd[i] =
 				v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
index 4282a7d..0c72b46 100644
--- a/include/media/davinci/vpif_types.h
+++ b/include/media/davinci/vpif_types.h
@@ -57,6 +57,7 @@ struct vpif_display_config {
 	int (*set_clock)(int, int);
 	struct vpif_subdev_info *subdevinfo;
 	int subdev_count;
+	int i2c_adapter_id;
 	struct vpif_display_chan_config chan_config[VPIF_DISPLAY_MAX_CHANNELS];
 	const char *card_name;
 	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
-- 
2.9.3
