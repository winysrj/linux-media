Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:25540 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbaE0N1x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 May 2014 09:27:53 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] media: Set entity->links NULL in cleanup
Date: Tue, 27 May 2014 16:27:49 +0300
Message-Id: <1401197269-18773-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calling media_entity_cleanup() on a cleaned-up entity would result into
double free of the entity->links pointer and likely memory corruption as
well. Setting entity->links as NULL right after the kfree() avoids this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 37c334e..c404354 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -83,6 +83,7 @@ void
 media_entity_cleanup(struct media_entity *entity)
 {
 	kfree(entity->links);
+	entity->links = NULL;
 }
 EXPORT_SYMBOL_GPL(media_entity_cleanup);
 
-- 
1.8.3.2

