Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57373 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbcDFNz2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2016 09:55:28 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] [media] media: Improve documentation for link_setup/link_modify
Date: Wed,  6 Apr 2016 06:55:25 -0700
Message-Id: <f34de3fbb419ded00e16fd9c0538313e01cd0b2c.1459950922.git.mchehab@osg.samsung.com>
In-Reply-To: <cf3f7fec1241c22f49cbe8205c2b1129eb4bb3d7.1459950922.git.mchehab@osg.samsung.com>
References: <cf3f7fec1241c22f49cbe8205c2b1129eb4bb3d7.1459950922.git.mchehab@osg.samsung.com>
In-Reply-To: <cf3f7fec1241c22f49cbe8205c2b1129eb4bb3d7.1459950922.git.mchehab@osg.samsung.com>
References: <cf3f7fec1241c22f49cbe8205c2b1129eb4bb3d7.1459950922.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those callbacks are called with the media_device.graph_mutex hold.

Add a note about that, as the code called by those notifiers should
not be touching in the mutex.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/media-device.h | 3 ++-
 include/media/media-entity.h | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index b21ef244ad3e..44563ec17d45 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -311,7 +311,8 @@ struct media_entity_notify {
  * @enable_source: Enable Source Handler function pointer
  * @disable_source: Disable Source Handler function pointer
  *
- * @link_notify: Link state change notification callback
+ * @link_notify: Link state change notification callback. This callback is
+ * Called with the graph_mutex hold.
  *
  * This structure represents an abstract high-level media device. It allows easy
  * access to entities and provides basic media device-level support. The
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 6dc9e4e8cbd4..0b16ebe36db7 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -179,6 +179,9 @@ struct media_pad {
  * @link_validate:	Return whether a link is valid from the entity point of
  *			view. The media_entity_pipeline_start() function
  *			validates all links by calling this operation. Optional.
+ *
+ * Note: Those ioctls should not touch the struct media_device.@graph_mutex
+ * field, as they're called with it already hold.
  */
 struct media_entity_operations {
 	int (*link_setup)(struct media_entity *entity,
-- 
2.5.5

