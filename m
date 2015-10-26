Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44990 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751603AbbJZXDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 19:03:49 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [PATCH 01/19] media: Enforce single entity->pipe in a pipeline
Date: Tue, 27 Oct 2015 01:01:32 +0200
Message-Id: <1445900510-1398-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If a different entity->pipe in a pipeline was encountered, a warning was
issued but the execution continued as if nothing had happened. Return an
error instead right there.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 66b8db0..d11f440 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -431,7 +431,12 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		DECLARE_BITMAP(has_no_links, MEDIA_ENTITY_MAX_PADS);
 
 		entity->stream_count++;
-		WARN_ON(entity->pipe && entity->pipe != pipe);
+
+		if (WARN_ON(entity->pipe && entity->pipe != pipe)) {
+			ret = -EBUSY;
+			goto error;
+		}
+
 		entity->pipe = pipe;
 
 		/* Already streaming --- no need to check. */
-- 
2.1.4

