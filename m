Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3999 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2F1Gsy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:48:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 28/33] vivi: embed struct video_device instead of allocating it.
Date: Thu, 28 Jun 2012 08:48:22 +0200
Message-Id: <6fb98d94dfa53cc81e25ea6ecf20342b741ed376.1340865818.git.hans.verkuil@cisco.com>
In-Reply-To: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index e00efcf..1e4da5e 100644
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
@@ -1326,7 +1324,7 @@ static struct video_device vivi_template = {
 	.name		= "vivi",
 	.fops           = &vivi_fops,
 	.ioctl_ops 	= &vivi_ioctl_ops,
-	.release	= video_device_release,
+	.release	= video_device_release_empty,
 };
 
 /* -----------------------------------------------------------------
@@ -1344,8 +1342,8 @@ static int vivi_release(void)
 		dev = list_entry(list, struct vivi_dev, vivi_devlist);
 
 		v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
-			video_device_node_name(dev->vfd));
-		video_unregister_device(dev->vfd);
+			video_device_node_name(&dev->vdev));
+		video_unregister_device(&dev->vdev);
 		v4l2_device_unregister(&dev->v4l2_dev);
 		v4l2_ctrl_handler_free(&dev->ctrl_handler);
 		kfree(dev);
@@ -1430,11 +1428,7 @@ static int __init vivi_create_instance(int inst)
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
@@ -1445,12 +1439,11 @@ static int __init vivi_create_instance(int inst)
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
@@ -1458,13 +1451,10 @@ static int __init vivi_create_instance(int inst)
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

