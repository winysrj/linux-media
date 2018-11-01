Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:58244 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728230AbeKBIiE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 04:38:04 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 09/30] media: entity: Swap pads if route is checked from source to sink
Date: Fri,  2 Nov 2018 00:31:23 +0100
Message-Id: <20181101233144.31507-10-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

This way the pads are always passed to the has_route() op sink pad first.
Makes sense.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/media-entity.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 3c0e7425c8983b45..33f00e35ccd92c6f 100644
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
2.19.1
