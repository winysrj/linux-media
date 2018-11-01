Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:47273 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728296AbeKBIiI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 04:38:08 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 13/30] media: entity: Add only connected pads to the pipeline
Date: Fri,  2 Nov 2018 00:31:27 +0100
Message-Id: <20181101233144.31507-14-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

A single entity may contain multiple pipelines. Only add pads that were
connected to the pad through which the entity was reached to the pipeline.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/media-entity.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index cdf3805dec755ec5..a5bb257d5a68f755 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -460,15 +460,13 @@ __must_check int __media_pipeline_start(struct media_pad *pad,
 
 	while ((pad = media_graph_walk_next(graph))) {
 		struct media_entity *entity = pad->entity;
-		unsigned int i;
+		struct media_pad *iter;
 		bool skip_validation = pad->pipe;
 
 		DECLARE_BITMAP(active, MEDIA_ENTITY_MAX_PADS);
 		DECLARE_BITMAP(has_no_links, MEDIA_ENTITY_MAX_PADS);
 
-		for (i = 0; i < entity->num_pads; i++) {
-			struct media_pad *iter = &entity->pads[i];
-
+		media_entity_for_routed_pads(pad, iter) {
 			if (iter->pipe && WARN_ON(iter->pipe != pipe))
 				ret = -EBUSY;
 			else
@@ -553,12 +551,9 @@ __must_check int __media_pipeline_start(struct media_pad *pad,
 	media_graph_walk_start(graph, pad_err);
 
 	while ((pad_err = media_graph_walk_next(graph))) {
-		struct media_entity *entity_err = pad_err->entity;
-		unsigned int i;
-
-		for (i = 0; i < entity_err->num_pads; i++) {
-			struct media_pad *iter = &entity_err->pads[i];
+		struct media_pad *iter;
 
+		media_entity_for_routed_pads(pad_err, iter) {
 			/* Sanity check for negative stream_count */
 			if (!WARN_ON_ONCE(iter->stream_count <= 0)) {
 				--iter->stream_count;
@@ -611,12 +606,9 @@ void __media_pipeline_stop(struct media_pad *pad)
 	media_graph_walk_start(graph, pad);
 
 	while ((pad = media_graph_walk_next(graph))) {
-		struct media_entity *entity = pad->entity;
-		unsigned int i;
-
-		for (i = 0; i < entity->num_pads; i++) {
-			struct media_pad *iter = &entity->pads[i];
+		struct media_pad *iter;
 
+		media_entity_for_routed_pads(pad, iter) {
 			/* Sanity check for negative stream_count */
 			if (!WARN_ON_ONCE(iter->stream_count <= 0)) {
 				iter->stream_count--;
-- 
2.19.1
