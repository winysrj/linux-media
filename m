Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:12251 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730726AbeHWQ5x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 12:57:53 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 11/30] media: entity: Skip link validation for pads to which there is no route to
Date: Thu, 23 Aug 2018 15:25:25 +0200
Message-Id: <20180823132544.521-12-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Links are validated along the pipeline which is about to start streaming.
Not all the pads in entities that are traversed along that pipeline are
part of the pipeline, however. Skip the link validation for such pads.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 12d9fc9ee02f38f2..0395d58b2e233d88 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -493,6 +493,11 @@ __must_check int __media_pipeline_start(struct media_pad *pad,
 			struct media_pad *other_pad = link->sink->entity == entity
 				? link->sink : link->source;
 
+			/* Ignore pads to which there is no route. */
+			if (!media_entity_has_route(entity, pad->index,
+						    other_pad->index))
+				continue;
+
 			/* Mark that a pad is connected by a link. */
 			bitmap_clear(has_no_links, other_pad->index, 1);
 
-- 
2.18.0
