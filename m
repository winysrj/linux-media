Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:42560 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbcA3UKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2016 15:10:55 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: Media Controller fix to not let stream_count go negative
Date: Sat, 30 Jan 2016 13:10:52 -0700
Message-Id: <1454184652-2427-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change media_entity_pipeline_stop() to not decrement
stream_count of an inactive media pipeline. Doing so,
results in preventing starting the pipeline.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-entity.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index e89d85a..f2e4360 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -452,9 +452,12 @@ error:
 	media_entity_graph_walk_start(graph, entity_err);
 
 	while ((entity_err = media_entity_graph_walk_next(graph))) {
-		entity_err->stream_count--;
-		if (entity_err->stream_count == 0)
-			entity_err->pipe = NULL;
+		/* don't let the stream_count go negative */
+		if (entity->stream_count > 0) {
+			entity_err->stream_count--;
+			if (entity_err->stream_count == 0)
+				entity_err->pipe = NULL;
+		}
 
 		/*
 		 * We haven't increased stream_count further than this
@@ -486,9 +489,12 @@ void media_entity_pipeline_stop(struct media_entity *entity)
 	media_entity_graph_walk_start(graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(graph))) {
-		entity->stream_count--;
-		if (entity->stream_count == 0)
-			entity->pipe = NULL;
+		/* don't let the stream_count go negative */
+		if (entity->stream_count > 0) {
+			entity->stream_count--;
+			if (entity->stream_count == 0)
+				entity->pipe = NULL;
+		}
 	}
 
 	if (!--pipe->streaming_count)
-- 
2.5.0

