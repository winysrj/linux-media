Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.hosts.co.uk ([85.233.160.19]:29028 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751308AbdLASxx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 13:53:53 -0500
From: Ian Jamison <ian.dev@arkver.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2] media: imx: Remove incorrect check for queue state in start/stop_streaming
Date: Fri,  1 Dec 2017 18:53:50 +0000
Message-Id: <ac504a93b483b40a8b2f9087af8c6d25672c7d6c.1512154062.git.ian.dev@arkver.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is possible to call STREAMON without the minimum number of
buffers queued. In this case the vb2_queue state will be set to
streaming but the start_streaming vb2_op will not be called.
Later when enough buffers are queued, start_streaming will
be called but vb2_is_streaming will already return true.

Also removed the queue state check in stop_streaming since it's
not valid there either.

Signed-off-by: Ian Jamison <ian.dev@arkver.com>
---
Since v1:
    Remove check in capture_stop_streaming as recommended by Hans.

 drivers/staging/media/imx/imx-media-capture.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index ea145bafb880..7b6763802db8 100644
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
@@ -480,9 +477,6 @@ static void capture_stop_streaming(struct vb2_queue *vq)
 	unsigned long flags;
 	int ret;
 
-	if (!vb2_is_streaming(vq))
-		return;
-
 	spin_lock_irqsave(&priv->q_lock, flags);
 	priv->stop = true;
 	spin_unlock_irqrestore(&priv->q_lock, flags);
-- 
2.15.0
