Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:59738 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbeKBIiG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 04:38:06 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 11/30] media: entity: Skip link validation for pads to which there is no route to
Date: Fri,  2 Nov 2018 00:31:25 +0100
Message-Id: <20181101233144.31507-12-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Links are validated along the pipeline which is about to start streaming.
Not all the pads in entities that are traversed along that pipeline are
part of the pipeline, however. Skip the link validation for such pads.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/media-entity.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 4d10bc186e1e7a10..cdf3805dec755ec5 100644
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
2.19.1
