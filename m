Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44681 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753337AbaJ1XfH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 19:35:07 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v3 1/1] media: Print information on failed link validation
Date: Wed, 29 Oct 2014 01:35:04 +0200
Message-Id: <1414539304-25647-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <3033119.78jigqieeC@avalon>
References: <3033119.78jigqieeC@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The Media controller doesn't tell much to the user in cases such as pipeline
startup failure. The link validation is the most common media graph (or in
V4L2's case, format) related reason for the failure. In more complex
pipelines the reason may not always be obvious to the user, so point them to
look at the right direction.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
since v2:
- Omit printing -EPIPE error code since it's always the same.

 drivers/media/media-entity.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index c404354..584f858 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -280,8 +280,14 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 				continue;
 
 			ret = entity->ops->link_validate(link);
-			if (ret < 0 && ret != -ENOIOCTLCMD)
+			if (ret < 0 && ret != -ENOIOCTLCMD) {
+				dev_dbg(entity->parent->dev,
+					"link validation failed for \"%s\":%u -> \"%s\":%u, error %d\n",
+					entity->name, link->source->index,
+					link->sink->entity->name,
+					link->sink->index, ret);
 				goto error;
+			}
 		}
 
 		/* Either no links or validated links are fine. */
@@ -289,6 +295,10 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 
 		if (!bitmap_full(active, entity->num_pads)) {
 			ret = -EPIPE;
+			dev_dbg(entity->parent->dev,
+				"\"%s\":%u must be connected by an enabled link\n",
+				entity->name,
+				find_first_zero_bit(active, entity->num_pads));
 			goto error;
 		}
 	}
-- 
1.7.10.4

