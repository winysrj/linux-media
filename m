Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1321 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153AbbBLNmj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2015 08:42:39 -0500
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id D132B20093
	for <linux-media@vger.kernel.org>; Thu, 12 Feb 2015 15:42:36 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] media: Correctly notify about the failed pipeline validation
Date: Thu, 12 Feb 2015 15:43:11 +0200
Message-Id: <1423748591-19402-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On the place of the source entity name, the sink entity name was printed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index defe4ac..d894481 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -283,9 +283,9 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 			if (ret < 0 && ret != -ENOIOCTLCMD) {
 				dev_dbg(entity->parent->dev,
 					"link validation failed for \"%s\":%u -> \"%s\":%u, error %d\n",
-					entity->name, link->source->index,
-					link->sink->entity->name,
-					link->sink->index, ret);
+					link->source->entity->name,
+					link->source->index,
+					entity->name, link->sink->index, ret);
 				goto error;
 			}
 		}
-- 
2.1.0.231.g7484e3b

