Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33332 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753581AbaJCVkc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Oct 2014 17:40:32 -0400
Received: from lanttu.localdomain (lanttu.localdomain [192.168.5.64])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id E2C9C60096
	for <linux-media@vger.kernel.org>; Sat,  4 Oct 2014 00:40:29 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] media: Print information on failed link validation
Date: Sat,  4 Oct 2014 00:40:39 +0300
Message-Id: <1412372439-4184-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The Media controller doesn't tell much to the user in cases such as pipeline
startup failure. The link validation is the most common media graph (or in
V4L2's case, format) related reason for the failure. In more complex
pipelines the reason may not always be obvious to the user, so point them to
look at the right direction.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 37c334e..a6cb6b6 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -279,8 +279,14 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
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
@@ -288,6 +294,11 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 
 		if (!bitmap_full(active, entity->num_pads)) {
 			ret = -EPIPE;
+			dev_dbg(entity->parent->dev,
+				"entity %s has pad %u must be connected by an enabled link, error %d\n",
+				entity->name,
+				find_first_zero_bit(active, entity->num_pads),
+				ret);
 			goto error;
 		}
 	}
-- 
1.7.10.4

