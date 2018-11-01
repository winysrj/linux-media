Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:13784 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728296AbeKBIiJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 04:38:09 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 15/30] media: entity: Look for indirect routes
Date: Fri,  2 Nov 2018 00:31:29 +0100
Message-Id: <20181101233144.31507-16-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Two pads are considered having an active route for the purpose of
has_route() if an indirect active route can be found between the two pads.
An simple example of this is that a source pad has an active route to
another source pad if both of the pads have an active route to the same
sink pad.

Make media_entity_has_route() return true in that case, and do not rely on
drivers performing this by themselves.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/media-entity.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 42977634d7102852..e45fc2549017615a 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -240,6 +240,9 @@ EXPORT_SYMBOL_GPL(media_entity_pads_init);
 bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
 			    unsigned int pad1)
 {
+	unsigned int i;
+	bool has_route;
+
 	if (pad0 >= entity->num_pads || pad1 >= entity->num_pads)
 		return false;
 
@@ -253,7 +256,34 @@ bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
 	    && entity->pads[pad1].flags & MEDIA_PAD_FL_SINK)
 		swap(pad0, pad1);
 
-	return entity->ops->has_route(entity, pad0, pad1);
+	has_route = entity->ops->has_route(entity, pad0, pad1);
+	/* A direct route is returned immediately */
+	if (has_route ||
+	    (entity->pads[pad0].flags & MEDIA_PAD_FL_SINK &&
+	     entity->pads[pad1].flags & MEDIA_PAD_FL_SOURCE))
+		return true;
+
+	/* Look for indirect routes */
+	for (i = 0; i < entity->num_pads; i++) {
+		if (i == pad0 || i == pad1)
+			continue;
+
+		/*
+		 * There are no direct routes between same types of
+		 * pads, so skip checking this route
+		 */
+		if (!((entity->pads[pad0].flags ^ entity->pads[i].flags) &
+		      (MEDIA_PAD_FL_SOURCE | MEDIA_PAD_FL_SINK)))
+			continue;
+
+		/* Is there an indirect route? */
+		if (entity->ops->has_route(entity, i, pad0) &&
+		    entity->ops->has_route(entity, i, pad1))
+			return true;
+	}
+
+	return false;
+
 }
 EXPORT_SYMBOL_GPL(media_entity_has_route);
 
-- 
2.19.1
