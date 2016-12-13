Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941266AbcLMSEJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 13:04:09 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCHv3 RFC 4/4] media: Catch null pipes on pipeline stop
Date: Tue, 13 Dec 2016 17:59:44 +0000
Message-Id: <1481651984-7687-5-git-send-email-kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <1481651984-7687-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1481651984-7687-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media_entity_pipeline_stop() can be called through error paths with a
NULL entity pipe object. In this instance, stopping is a no-op, so
simply return without any action

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---

I've marked this patch as RFC, although if deemed suitable, by all means
integrate it as is.

When testing suspend/resume operations on VSP1, I encountered a segfault on the
WARN_ON(!pipe->streaming_count) line, where 'pipe == NULL'. The simple
protection fix is to return early in this instance, as this patch does however:

A) Does this early return path warrant a WARN() statement itself, to identify
drivers which are incorrectly calling media_entity_pipeline_stop() with an
invalid entity, or would this just be noise ...

and therefore..

B) I also partly assume this patch could simply get NAK'd with a request to go
and dig out the root cause of calling media_entity_pipeline_stop() with an
invalid entity. 

My brief investigation so far here so far shows that it's almost a second order
fault - where the first suspend resume cycle completes but leaves the entity in
an invalid state having followed an error path - and then on a second
suspend/resume - the stop fails with the affected segfault.

If statement A) or B) apply here, please drop this patch from the series, and
don't consider it a blocking issue for the other 3 patches.

Kieran


 drivers/media/media-entity.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index c68239e60487..93c9cbf4bf46 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -508,6 +508,8 @@ void __media_entity_pipeline_stop(struct media_entity *entity)
 	struct media_entity_graph *graph = &entity->pipe->graph;
 	struct media_pipeline *pipe = entity->pipe;
 
+	if (!pipe)
+		return;
 
 	WARN_ON(!pipe->streaming_count);
 	media_entity_graph_walk_start(graph, entity);
-- 
2.7.4

