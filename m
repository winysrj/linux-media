Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:45639 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933642AbcJLOqn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:46:43 -0400
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OEX01FZBV7FY8A0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Oct 2016 23:35:39 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v4l-utils v7 3/7] mediactl: Add media_entity_get_backlinks()
Date: Wed, 12 Oct 2016 16:35:18 +0200
Message-id: <1476282922-11544-4-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new graph helper useful for discovering video pipeline.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libmediactl.c | 21 +++++++++++++++++++++
 utils/media-ctl/mediactl.h    | 15 +++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 91ed003..155b65f 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -36,6 +36,7 @@
 #include <unistd.h>
 
 #include <linux/media.h>
+#include <linux/kdev_t.h>
 #include <linux/videodev2.h>
 
 #include "mediactl.h"
@@ -172,6 +173,26 @@ const struct media_entity_desc *media_entity_get_info(struct media_entity *entit
 	return &entity->info;
 }
 
+int media_entity_get_backlinks(struct media_entity *entity,
+				struct media_link **backlinks,
+				unsigned int *num_backlinks)
+{
+	unsigned int num_bklinks = 0;
+	int i;
+
+	if (entity == NULL || backlinks == NULL || num_backlinks == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < entity->num_links; ++i)
+		if ((entity->links[i].flags & MEDIA_LNK_FL_ENABLED) &&
+		    (entity->links[i].sink->entity == entity))
+			backlinks[num_bklinks++] = &entity->links[i];
+
+	*num_backlinks = num_bklinks;
+
+	return 0;
+}
+
 /* -----------------------------------------------------------------------------
  * Open/close
  */
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index 336cbf9..b1f33cd 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -434,6 +434,20 @@ int media_parse_setup_link(struct media_device *media,
 int media_parse_setup_links(struct media_device *media, const char *p);
 
 /**
+ * @brief Get entity's enabled backlinks
+ * @param entity - media entity.
+ * @param backlinks - array of pointers to matching backlinks.
+ * @param num_backlinks - number of matching backlinks.
+ *
+ * Get links that are connected to the entity sink pads.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_entity_get_backlinks(struct media_entity *entity,
+				struct media_link **backlinks,
+				unsigned int *num_backlinks);
+
+/**
  * @brief Get v4l2_subdev for the entity
  * @param entity - media entity
  *
@@ -443,4 +457,5 @@ int media_parse_setup_links(struct media_device *media, const char *p);
  */
 struct v4l2_subdev *media_entity_get_v4l2_subdev(struct media_entity *entity);
 
+
 #endif
-- 
1.9.1

