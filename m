Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:39384 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933481AbcIALrY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2016 07:47:24 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/3] s5c73m3: Fix entity function assignment for the OIF subdev
Date: Thu, 01 Sep 2016 13:47:07 +0200
Message-id: <1472730427-17821-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1472730427-17821-1-git-send-email-s.nawrocki@samsung.com>
References: <1472730427-17821-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Suppresses warnings like:
s5p-fimc-md camera: Entity type for entity S5C73M3-OIF was not initialized!

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 08af58f..3844853 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1706,7 +1706,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 	state->oif_pads[OIF_ISP_PAD].flags = MEDIA_PAD_FL_SINK;
 	state->oif_pads[OIF_JPEG_PAD].flags = MEDIA_PAD_FL_SINK;
 	state->oif_pads[OIF_SOURCE_PAD].flags = MEDIA_PAD_FL_SOURCE;
-	oif_sd->entity.function = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
+	oif_sd->entity.function = MEDIA_ENT_F_PROC_VIDEO_SCALER;
 
 	ret = media_entity_pads_init(&oif_sd->entity, OIF_NUM_PADS,
 							state->oif_pads);
-- 
1.9.1

