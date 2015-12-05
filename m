Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55017 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbbLECM7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 21:12:59 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 01/32] v4l: vsp1: Change the type of the rwpf field in struct vsp1_video
Date: Sat,  5 Dec 2015 04:12:35 +0200
Message-Id: <1449281586-25726-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rwpf field contains a pointer to the rpf or wpf associated with the
video node. Instead of storing it as a vsp1_entity, store the
corresponding vsp1_rwpf pointer to allow accessing the vsp1_rwpf fields
directly.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c   | 2 +-
 drivers/media/platform/vsp1/vsp1_video.c | 4 ++--
 drivers/media/platform/vsp1/vsp1_video.h | 5 +++--
 drivers/media/platform/vsp1/vsp1_wpf.c   | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index cd5248a9a271..b57373a57dc6 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -271,7 +271,7 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 	video->vsp1 = vsp1;
 	video->ops = &rpf_vdev_ops;
 
-	ret = vsp1_video_init(video, &rpf->entity);
+	ret = vsp1_video_init(video, rpf);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 5ce88e1f5d71..698cc8aecfbe 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -1190,7 +1190,7 @@ static struct v4l2_file_operations vsp1_video_fops = {
  * Initialization and Cleanup
  */
 
-int vsp1_video_init(struct vsp1_video *video, struct vsp1_entity *rwpf)
+int vsp1_video_init(struct vsp1_video *video, struct vsp1_rwpf *rwpf)
 {
 	const char *direction;
 	int ret;
@@ -1245,7 +1245,7 @@ int vsp1_video_init(struct vsp1_video *video, struct vsp1_entity *rwpf)
 	video->video.v4l2_dev = &video->vsp1->v4l2_dev;
 	video->video.fops = &vsp1_video_fops;
 	snprintf(video->video.name, sizeof(video->video.name), "%s %s",
-		 rwpf->subdev.name, direction);
+		 rwpf->entity.subdev.name, direction);
 	video->video.vfl_type = VFL_TYPE_GRABBER;
 	video->video.release = video_device_release_empty;
 	video->video.ioctl_ops = &vsp1_video_ioctl_ops;
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index a929aa81cdbf..c1d9771c55ed 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -20,6 +20,7 @@
 #include <media/media-entity.h>
 #include <media/videobuf2-v4l2.h>
 
+struct vsp1_rwpf;
 struct vsp1_video;
 
 /*
@@ -113,7 +114,7 @@ struct vsp1_video_operations {
 
 struct vsp1_video {
 	struct vsp1_device *vsp1;
-	struct vsp1_entity *rwpf;
+	struct vsp1_rwpf *rwpf;
 
 	const struct vsp1_video_operations *ops;
 
@@ -140,7 +141,7 @@ static inline struct vsp1_video *to_vsp1_video(struct video_device *vdev)
 	return container_of(vdev, struct vsp1_video, video);
 }
 
-int vsp1_video_init(struct vsp1_video *video, struct vsp1_entity *rwpf);
+int vsp1_video_init(struct vsp1_video *video, struct vsp1_rwpf *rwpf);
 void vsp1_video_cleanup(struct vsp1_video *video);
 
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe);
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 95b62f4f77e7..9ba5feee50de 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -271,7 +271,7 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	video->vsp1 = vsp1;
 	video->ops = &wpf_vdev_ops;
 
-	ret = vsp1_video_init(video, &wpf->entity);
+	ret = vsp1_video_init(video, wpf);
 	if (ret < 0)
 		goto error;
 
-- 
2.4.10

