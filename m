Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:37386 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751192AbdCNTGf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:06:35 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3 04/27] media: entity: Swap pads if route is checked from source to sink
Date: Tue, 14 Mar 2017 20:02:45 +0100
Message-Id: <20170314190308.25790-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

This way the pads are always passed to the has_route() op sink pad first.
Makes sense.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/media-entity.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index ccd991d2d3450ab3..f0386ddd7c92cc4e 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -256,6 +256,10 @@ bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
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
2.12.0
