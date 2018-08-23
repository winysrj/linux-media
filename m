Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:12212 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730670AbeHWQ5v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 12:57:51 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 09/30] media: entity: Swap pads if route is checked from source to sink
Date: Thu, 23 Aug 2018 15:25:23 +0200
Message-Id: <20180823132544.521-10-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

This way the pads are always passed to the has_route() op sink pad first.
Makes sense.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 2e5958732a9735cf..88c8b838b78b39aa 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -249,6 +249,10 @@ bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
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
2.18.0
