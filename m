Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.hosts.co.uk ([85.233.160.19]:12440 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935086AbdKQWwa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 17:52:30 -0500
From: Ian Jamison <ian.dev@arkver.com>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] media: imx: Remove incorrect check for queue state in start_streaming
Date: Fri, 17 Nov 2017 18:23:14 +0000
Message-Id: <37124a40f1388b0b0a2f2226661280962f23102d.1510942589.git.ian.dev@arkver.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is possible to call STREAMON without the minimum number of
buffers queued. In this case the vb2_queue state will be set to
streaming but the start_streaming vb2_op will not be called.
Later when enough buffers are queued, start_streaming will
be called but vb2_is_streaming will already return true.

Signed-off-by: Ian Jamison <ian.dev@arkver.com>
---
 drivers/staging/media/imx/imx-media-capture.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index ddab4c249da2..34b492c2419c 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -449,9 +449,6 @@ static int capture_start_streaming(struct vb2_queue *vq, unsigned int count)
 	unsigned long flags;
 	int ret;
 
-	if (vb2_is_streaming(vq))
-		return 0;
-
 	ret = imx_media_pipeline_set_stream(priv->md, &priv->src_sd->entity,
 					    true);
 	if (ret) {
-- 
2.15.0
