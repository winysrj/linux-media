Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:44714 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbcCJSRw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 13:17:52 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	sakari.ailus@linux.intel.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] media: v4l2-mc add v4l_change_media_source() to invoke change_source
Date: Thu, 10 Mar 2016 11:17:48 -0700
Message-Id: <1457633868-4861-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a common routine to invoke media device change_source handler.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---

Changes since v1:
- Fixed !CONFIG_MEDIA_CONTROLLER compile error for v4l_change_media_source()

 drivers/media/v4l2-core/v4l2-mc.c | 14 ++++++++++++++
 include/media/v4l2-mc.h           | 25 ++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index ae661ac..478b2768 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -217,6 +217,20 @@ void v4l_disable_media_source(struct video_device *vdev)
 }
 EXPORT_SYMBOL_GPL(v4l_disable_media_source);
 
+int v4l_change_media_source(struct video_device *vdev)
+{
+	struct media_device *mdev = vdev->entity.graph_obj.mdev;
+	int ret;
+
+	if (!mdev || !mdev->change_source)
+		return 0;
+	ret = mdev->change_source(&vdev->entity, &vdev->pipe);
+	if (ret)
+		return -EBUSY;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l_change_media_source);
+
 int v4l_vb2q_enable_media_source(struct vb2_queue *q)
 {
 	struct v4l2_fh *fh = q->owner;
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 98a938a..50b9348 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -154,8 +154,26 @@ int v4l_enable_media_source(struct video_device *vdev);
  */
 void v4l_disable_media_source(struct video_device *vdev);
 
+/**
+ * v4l_change_media_source() -	Hold media source for exclusive use
+ *				if free
+ *
+ * @vdev:	pointer to struct video_device
+ *
+ * This interface calls change_source handler to change
+ * the current source it is holding. The change_source
+ * disables the current source and starts pipeline to
+ * the new source. This interface should be used when
+ * user changes source using s_input handler to keep
+ * the previously granted permission for exclusive use
+ * with a new input source.
+ *
+ * Return: returns zero on success or a negative error code.
+ */
+int v4l_change_media_source(struct video_device *vdev);
+
 /*
- * v4l_vb2q_enable_media_tuner -  Hold media source for exclusive use
+ * v4l_vb2q_enable_media_source - Hold media source for exclusive use
  *				  if free.
  * @q - pointer to struct vb2_queue
  *
@@ -219,6 +237,11 @@ static inline int v4l_enable_media_source(struct video_device *vdev)
 	return 0;
 }
 
+static inline int v4l_change_media_source(struct video_device *vdev)
+{
+	return 0;
+}
+
 static inline void v4l_disable_media_source(struct video_device *vdev)
 {
 }
-- 
2.5.0

