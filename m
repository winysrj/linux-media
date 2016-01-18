Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:39931 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbcARQTA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 11:19:00 -0500
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O1500UJKPBNT420@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2016 01:18:59 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hverkuil@xs4all.nl,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 12/15] mediactl: libv4l2subdev: add get_pipeline_entity_by_cid
 function
Date: Mon, 18 Jan 2016 17:17:37 +0100
Message-id: <1453133860-21571-13-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
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
index 9d48ac1..14e9423 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -1052,3 +1052,17 @@ bool v4l2_subdev_has_v4l2_control_redir(struct media_device *media,
 
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
index be2d82e..607ec50 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -394,4 +394,19 @@ enum v4l2_subdev_fmt_mismatch v4l2_subdev_format_compare(
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

