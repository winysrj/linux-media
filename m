Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:4743 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728312AbeKBIiI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 04:38:08 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 14/30] media: entity: Add debug information in graph walk route check
Date: Fri,  2 Nov 2018 00:31:28 +0100
Message-Id: <20181101233144.31507-15-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/media-entity.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index a5bb257d5a68f755..42977634d7102852 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -360,6 +360,9 @@ static void media_graph_walk_iter(struct media_graph *graph)
 	 */
 	if (!media_entity_has_route(pad->entity, pad->index, local->index)) {
 		link_top(graph) = link_top(graph)->next;
+		dev_dbg(pad->graph_obj.mdev->dev,
+			"walk: skipping \"%s\":%u -> %u (no route)\n",
+			pad->entity->name, pad->index, local->index);
 		return;
 	}
 
-- 
2.19.1
