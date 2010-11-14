Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3948 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab0KNOg5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 09:36:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: sh_vou: proposed patch to convert to unlocked_ioctl
Date: Sun, 14 Nov 2010 15:36:56 +0100
Cc: linux-media@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011141536.56781.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

Below is my proposed patch to convert sh_vou to unlocked_ioctl. It uses the
V4L2 core locking method.

I didn't see any synchronization mechanisms other than the implicit BKL in
this driver, so using the core locking method seemed the right thing to do
here.

Regards,

	Hans

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
Hans Verkuil - video4linux developer - sponsored by Cisco
