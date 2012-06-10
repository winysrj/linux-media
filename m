Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3022 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab2FJK0R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 27/32] vivi: embed struct video_device instead of allocating it.
Date: Sun, 10 Jun 2012 12:25:49 +0200
Message-Id: <9b33e257c9f308801652f90514a330388d214c34.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 8dd5ae6..1e4da5e 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -188,6 +188,7 @@ struct vivi_dev {
 	struct list_head           vivi_devlist;
 	struct v4l2_device 	   v4l2_dev;
 	struct v4l2_ctrl_handler   ctrl_handler;
+	struct video_device	   vdev;
 
 	/* controls */
 	struct v4l2_ctrl	   *brightness;
@@ -213,9 +214,6 @@ struct vivi_dev {
 	spinlock_t                 slock;
 	struct mutex		   mutex;
 
-	/* various device info */
-	struct video_device        *vfd;
-
 	struct vivi_dmaqueue       vidq;
 
 	/* Several counters */
@@ -1080,7 +1078,6 @@ static int vidioc_enum_input(struct file *file, void *priv,
 		return -EINVAL;
 
 	inp->type = V4L2_INPUT_TYPE_CAMERA;
-	inp->std = V4L2_STD_525_60;
 	sprintf(inp->name, "Camera %u", inp->index);
 	return 0;
 }
@@ -1327,7 +1324,7 @@ static struct video_device vivi_template = {
 	.name		= "vivi",
 	.fops           = &vivi_fops,
 	.ioctl_ops 	= &vivi_ioctl_ops,
-	.release	= video_device_release,
+	.release	= video_device_release_empty,
 };
 
 /* -----------------------------------------------------------------
@@ -1345,8 +1342,8 @@ static int vivi_release(void)
 		dev = list_entry(list, struct vivi_dev, vivi_devlist);
 
 		v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
-			video_device_node_name(dev->vfd));
-		video_unregister_device(dev->vfd);
+			video_device_node_name(&dev->vdev));
+		video_unregister_device(&dev->vdev);
 		v4l2_device_unregister(&dev->v4l2_dev);
 		v4l2_ctrl_handler_free(&dev->ctrl_handler);
 		kfree(dev);
@@ -1431,11 +1428,7 @@ static int __init vivi_create_instance(int inst)
 	INIT_LIST_HEAD(&dev->vidq.active);
 	init_waitqueue_head(&dev->vidq.wq);
 
-	ret = -ENOMEM;
-	vfd = video_device_alloc();
-	if (!vfd)
-		goto unreg_dev;
-
+	vfd = &dev->vdev;
 	*vfd = vivi_template;
 	vfd->debug = debug;
 	vfd->v4l2_dev = &dev->v4l2_dev;
@@ -1446,12 +1439,11 @@ static int __init vivi_create_instance(int inst)
 	 * all fops and v4l2 ioctls.
 	 */
 	vfd->lock = &dev->mutex;
+	video_set_drvdata(vfd, dev);
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, video_nr);
 	if (ret < 0)
-		goto rel_vdev;
-
-	video_set_drvdata(vfd, dev);
+		goto unreg_dev;
 
 	/* Now that everything is fine, let's add it to device list */
 	list_add_tail(&dev->vivi_devlist, &vivi_devlist);
@@ -1459,13 +1451,10 @@ static int __init vivi_create_instance(int inst)
 	if (video_nr != -1)
 		video_nr++;
 
-	dev->vfd = vfd;
 	v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
 		  video_device_node_name(vfd));
 	return 0;
 
-rel_vdev:
-	video_device_release(vfd);
 unreg_dev:
 	v4l2_ctrl_handler_free(hdl);
 	v4l2_device_unregister(&dev->v4l2_dev);
-- 
1.7.10

