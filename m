Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:39384 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933631AbcIALrW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2016 07:47:22 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/3] s5k6a3: Add missing entity function initialization
Date: Thu, 01 Sep 2016 13:47:06 +0200
Message-id: <1472730427-17821-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1472730427-17821-1-git-send-email-s.nawrocki@samsung.com>
References: <1472730427-17821-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Suppresses warning like:
s5p-fimc-md camera: Entity type for entity S5K6A3 13-0010 was not initialized!

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/s5k6a3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
index cbe4711..aa46a14 100644
--- a/drivers/media/i2c/s5k6a3.c
+++ b/drivers/media/i2c/s5k6a3.c
@@ -331,6 +331,7 @@ static int s5k6a3_probe(struct i2c_client *client,
 	sensor->format.width = S5K6A3_DEFAULT_WIDTH;
 	sensor->format.height = S5K6A3_DEFAULT_HEIGHT;
 
+	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_pads_init(&sd->entity, 1, &sensor->pad);
 	if (ret < 0)
-- 
1.9.1

