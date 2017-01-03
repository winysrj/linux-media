Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757376AbdACNMf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Jan 2017 08:12:35 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: sakari.ailus@iki.fi, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH] media: entity: Catch unbalanced media_pipeline_stop calls
Date: Tue,  3 Jan 2017 13:12:11 +0000
Message-Id: <1483449131-18075-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers must not perform unbalanced calls to stop the entity pipeline,
however if they do they will fault in the core media code, as the
entity->pipe will be set as NULL. We handle this gracefully in the core
with a WARN for the developer.

Replace the erroneous check on zero streaming counts, with a check on
NULL pipe elements instead, as this is the symptom of unbalanced
media_pipeline_stop calls.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/media-entity.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index caa13e6f09f5..cb1fb2c17f85 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -534,8 +534,13 @@ void __media_pipeline_stop(struct media_entity *entity)
 	struct media_graph *graph = &entity->pipe->graph;
 	struct media_pipeline *pipe = entity->pipe;
 
+	/*
+	 * If the following check fails, the driver has performed an
+	 * unbalanced call to media_pipeline_stop()
+	 */
+	if (WARN_ON(!pipe))
+		return;
 
-	WARN_ON(!pipe->streaming_count);
 	media_graph_walk_start(graph, entity);
 
 	while ((entity = media_graph_walk_next(graph))) {
-- 
2.7.4

