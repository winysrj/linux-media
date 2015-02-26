Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:54773 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbbBZQA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 11:00:59 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKD000GKZ5MM400@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Feb 2015 01:00:58 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils PATCH/RFC v5 11/14] mediactl: libv4l2subdev: add
 get_pipeline_entity_by_cid function
Date: Thu, 26 Feb 2015 16:59:21 +0100
Message-id: <1424966364-3647-12-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
References: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a function for obtaining the v4l2 sub-device for which
the v4l2 control related ioctl is predestined.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libv4l2subdev.c |   14 ++++++++++++++
 utils/media-ctl/v4l2subdev.h    |   15 +++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index cc3df1e..379fe64 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -946,3 +946,17 @@ bool v4l2_subdev_has_v4l2_control_redir(struct media_device *media,
 
 	return false;
 }
+
+struct media_entity *v4l2_subdev_get_pipeline_entity_by_cid(struct media_device *media,
+						int cid)
+{
+	struct media_entity *entity = media->pipeline;
+
+	while (entity) {
+		if (v4l2_subdev_has_v4l2_control_redir(media, entity, cid))
+			return entity;
+		entity = entity->next;
+	}
+
+	return NULL;
+}
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 2b48fb5..0f1deca 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -353,4 +353,19 @@ int v4l2_subdev_format_compare(struct v4l2_mbus_framefmt *fmt1,
 bool v4l2_subdev_has_v4l2_control_redir(struct media_device *media,
 	struct media_entity *entity, int ctrl_id);
 
+/**
+ * @brief Get the first pipeline entity supporting the control
+ * @param media - media device.
+ * @param cid - v4l2 control identifier.
+ *
+ * Get the first entity in the media device pipeline,
+ * for which v4l2_control with cid is to be redirected
+ *
+ * @return associated entity if defined, or NULL if the
+ *	   control redirection wasn't defined for any entity
+ *	   in the pipeline
+ */
+struct media_entity *v4l2_subdev_get_pipeline_entity_by_cid(
+	struct media_device *media, int cid);
+
 #endif
-- 
1.7.9.5

