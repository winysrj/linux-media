Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:48698 "EHLO arroyo.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754705AbcI1VVI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:21:08 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 09/35] media: ti-vpe: vpe: Return NULL for invalid buffer type
Date: Wed, 28 Sep 2016 16:21:01 -0500
Message-ID: <20160928212101.26682-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

get_q_data can be called with different values for type
e.g. vpe_try_crop calls it with the buffer type which gets passed
from user space

Framework doesn't check wheather its correct type or not
If user space passes wrong type, kernel should not crash.
Return NULL when the passed type is invalid.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 2a4deceea17d..b66b55322dd4 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -420,7 +420,7 @@ static struct vpe_q_data *get_q_data(struct vpe_ctx *ctx,
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 		return &ctx->q_data[Q_DATA_DST];
 	default:
-		BUG();
+		return NULL;
 	}
 	return NULL;
 }
-- 
2.9.0

