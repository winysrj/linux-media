Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:52950 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752380AbcKHKL5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 05:11:57 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se
Subject: [PATCH 1/1] media: entity: Swap pads if route is checked from source to sink
Date: Tue,  8 Nov 2016 12:11:15 +0200
Message-Id: <1478599875-27700-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This way the pads are always passed to the has_route() op sink pad first.
Makes sense.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Niklas,

This should make it easier to implement the has_route() op in drivers.

Feel free to merge this to "[PATCH 02/32] media: entity: Add
media_entity_has_route() function" if you like, or add separately after
the second patch.

 drivers/media/media-entity.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 747adcb..520f3f6 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -254,6 +254,10 @@ bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
 	if (!entity->ops || !entity->ops->has_route)
 		return true;
 
+	if (entity->pads[pad0].flags & MEDIA_PAD_FL_SOURCE
+	    && entity->pads[pad1].flags & MEDIA_PAD_FL_SINK)
+		swap(pad0, pad1);
+
 	return entity->ops->has_route(entity, pad0, pad1);
 }
 EXPORT_SYMBOL_GPL(media_entity_has_route);
-- 
2.7.4

