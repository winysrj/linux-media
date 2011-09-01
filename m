Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26841 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab1IAPaa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 11:30:30 -0400
Date: Thu, 01 Sep 2011 17:30:13 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 09/19 v4] s5p-fimc: Add media operations in the capture entity
 driver
In-reply-to: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mchehab@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1314891023-14227-10-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the link_setup handler for the camera capture video node.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   32 +++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 +
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 0c237a7..95996fb 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -669,6 +669,37 @@ static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 	.vidioc_g_input			= fimc_cap_g_input,
 };
 
+/* Media operations */
+static int fimc_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote, u32 flags)
+{
+	struct video_device *vd = media_entity_to_video_device(entity);
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(remote->entity);
+	struct fimc_dev *fimc = video_get_drvdata(vd);
+
+	if (WARN_ON(fimc == NULL))
+		return 0;
+
+	dbg("%s --> %s, flags: 0x%x. input: 0x%x",
+	    local->entity->name, remote->entity->name, flags,
+	    fimc->vid_cap.input);
+
+	if (flags & MEDIA_LNK_FL_ENABLED) {
+		if (fimc->vid_cap.input != 0)
+			return -EBUSY;
+		fimc->vid_cap.input = sd->grp_id;
+		return 0;
+	}
+
+	fimc->vid_cap.input = 0;
+	return 0;
+}
+
+static const struct media_entity_operations fimc_media_ops = {
+	.link_setup = fimc_link_setup,
+};
+
 /* fimc->lock must be already initialized */
 int fimc_register_capture_device(struct fimc_dev *fimc,
 				 struct v4l2_device *v4l2_dev)
@@ -743,6 +774,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	if (ret)
 		goto err_ent;
 
+	vfd->entity.ops = &fimc_media_ops;
 	vfd->ctrl_handler = &ctx->ctrl_handler;
 	return 0;
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 1825e33..87a89f1 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -305,6 +305,7 @@ struct fimc_m2m_device {
  * @reqbufs_count: the number of buffers requested in REQBUFS ioctl
  * @input_index: input (camera sensor) index
  * @refcnt: driver's private reference counter
+ * @input: capture input type, grp_id of the attached subdev
  * @user_subdev_api: true if subdevs are not configured by the host driver
  */
 struct fimc_vid_cap {
@@ -323,6 +324,7 @@ struct fimc_vid_cap {
 	unsigned int			reqbufs_count;
 	int				input_index;
 	int				refcnt;
+	u32				input;
 	bool				user_subdev_api;
 };
 
-- 
1.7.6

