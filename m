Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24183 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758536Ab1FVSBk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 14:01:40 -0400
Date: Wed, 22 Jun 2011 20:01:16 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 10/18] s5p-fimc: Add media operations in the capture entity
 driver
In-reply-to: <1308765684-10677-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1308765684-10677-11-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1308765684-10677-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add the link_setup handler for the camera capture video node.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   32 +++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 +
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 887a3fc..f9beee8 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -654,6 +654,37 @@ static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
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
@@ -728,6 +759,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	if (ret)
 		goto err_ent;
 
+	vfd->entity.ops = &fimc_media_ops;
 	vfd->ctrl_handler = &ctx->ctrl_handler;
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret) {
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 6ccd446..d264f3f 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -305,6 +305,7 @@ struct fimc_m2m_device {
  * @reqbufs_count: the number of buffers requested in REQBUFS ioctl
  * @input_index: input (camera sensor) index
  * @refcnt: driver's private reference counter
+ * @input: capture input type, grp_id of attached subdev
  */
 struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
@@ -322,6 +323,7 @@ struct fimc_vid_cap {
 	unsigned int			reqbufs_count;
 	int				input_index;
 	int				refcnt;
+	u32				input;
 };
 
 /**
-- 
1.7.5.4

