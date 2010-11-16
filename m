Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2616 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab0KPV4p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 16:56:45 -0500
Message-Id: <4c405011c984f5c41e8acf9eb3b03b9c51d3e18c.1289944160.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1289944159.git.hverkuil@xs4all.nl>
References: <cover.1289944159.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 16 Nov 2010 22:56:41 +0100
Subject: [RFCv2 PATCH 12/15] sh_vou: convert to unlocked_ioctl.
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/sh_vou.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/sh_vou.c b/drivers/media/video/sh_vou.c
index 0f49061..858b2f8 100644
--- a/drivers/media/video/sh_vou.c
+++ b/drivers/media/video/sh_vou.c
@@ -75,6 +75,7 @@ struct sh_vou_device {
 	int pix_idx;
 	struct videobuf_buffer *active;
 	enum sh_vou_status status;
+	struct mutex fop_lock;
 };
 
 struct sh_vou_file {
@@ -235,7 +236,7 @@ static void free_buffer(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 	vb->state = VIDEOBUF_NEEDS_INIT;
 }
 
-/* Locking: caller holds vq->vb_lock mutex */
+/* Locking: caller holds fop_lock mutex */
 static int sh_vou_buf_setup(struct videobuf_queue *vq, unsigned int *count,
 			    unsigned int *size)
 {
@@ -257,7 +258,7 @@ static int sh_vou_buf_setup(struct videobuf_queue *vq, unsigned int *count,
 	return 0;
 }
 
-/* Locking: caller holds vq->vb_lock mutex */
+/* Locking: caller holds fop_lock mutex */
 static int sh_vou_buf_prepare(struct videobuf_queue *vq,
 			      struct videobuf_buffer *vb,
 			      enum v4l2_field field)
@@ -306,7 +307,7 @@ static int sh_vou_buf_prepare(struct videobuf_queue *vq,
 	return 0;
 }
 
-/* Locking: caller holds vq->vb_lock mutex and vq->irqlock spinlock */
+/* Locking: caller holds fop_lock mutex and vq->irqlock spinlock */
 static void sh_vou_buf_queue(struct videobuf_queue *vq,
 			     struct videobuf_buffer *vb)
 {
@@ -1190,7 +1191,7 @@ static int sh_vou_open(struct file *file)
 				       V4L2_BUF_TYPE_VIDEO_OUTPUT,
 				       V4L2_FIELD_NONE,
 				       sizeof(struct videobuf_buffer), vdev,
-				       NULL);
+				       &vou_dev->fop_lock);
 
 	return 0;
 }
@@ -1292,7 +1293,7 @@ static const struct v4l2_file_operations sh_vou_fops = {
 	.owner		= THIS_MODULE,
 	.open		= sh_vou_open,
 	.release	= sh_vou_release,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.mmap		= sh_vou_mmap,
 	.poll		= sh_vou_poll,
 };
@@ -1331,6 +1332,7 @@ static int __devinit sh_vou_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&vou_dev->queue);
 	spin_lock_init(&vou_dev->lock);
+	mutex_init(&vou_dev->fop_lock);
 	atomic_set(&vou_dev->use_count, 0);
 	vou_dev->pdata = vou_pdata;
 	vou_dev->status = SH_VOU_IDLE;
@@ -1388,6 +1390,7 @@ static int __devinit sh_vou_probe(struct platform_device *pdev)
 		vdev->tvnorms |= V4L2_STD_PAL;
 	vdev->v4l2_dev = &vou_dev->v4l2_dev;
 	vdev->release = video_device_release;
+	vdev->lock = &vou_dev->fop_lock;
 
 	vou_dev->vdev = vdev;
 	video_set_drvdata(vdev, vou_dev);
-- 
1.7.0.4

