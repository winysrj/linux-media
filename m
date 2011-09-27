Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56475 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1I0RFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 13:05:53 -0400
Date: Tue, 27 Sep 2011 19:05:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v5] V4L: dynamically allocate video_device nodes in subdevices
In-Reply-To: <201109131952.08202.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1109271902450.7004@axis700.grange>
References: <Pine.LNX.4.64.1109091701060.915@axis700.grange>
 <201109131116.35408.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1109131318450.17902@axis700.grange>
 <201109131952.08202.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently only very few drivers actually use video_device nodes, embedded
in struct v4l2_subdev. Allocate these nodes dynamically for those drivers
to save memory for the rest.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---

v5: replace kzalloc() with video_device_alloc() and kfree() with 
video_device_release(), no changes otherwise. I hope, I'm entitled to keep 
the tested- and acked-by's;-)

 drivers/media/video/v4l2-device.c |   36 +++++++++++++++++++++++++++++++-----
 include/media/v4l2-subdev.h       |    4 ++--
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index c72856c..93c0350 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -21,6 +21,7 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #if defined(CONFIG_SPI)
 #include <linux/spi/spi.h>
 #endif
@@ -191,6 +192,13 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 }
 EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
 
+static void v4l2_device_release_subdev_node(struct video_device *vdev)
+{
+	struct v4l2_subdev *sd = video_get_drvdata(vdev);
+	sd->devnode = NULL;
+	video_device_release(vdev);
+}
+
 int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 {
 	struct video_device *vdev;
@@ -204,22 +212,40 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
 			continue;
 
-		vdev = &sd->devnode;
+		vdev = video_device_alloc();
+		if (!vdev) {
+			err = -ENOMEM;
+			goto clean_up;
+		}
+
+		video_set_drvdata(vdev, sd);
 		strlcpy(vdev->name, sd->name, sizeof(vdev->name));
 		vdev->v4l2_dev = v4l2_dev;
 		vdev->fops = &v4l2_subdev_fops;
-		vdev->release = video_device_release_empty;
+		vdev->release = v4l2_device_release_subdev_node;
 		vdev->ctrl_handler = sd->ctrl_handler;
 		err = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
 					      sd->owner);
-		if (err < 0)
-			return err;
+		if (err < 0) {
+			video_device_release(vdev);
+			goto clean_up;
+		}
 #if defined(CONFIG_MEDIA_CONTROLLER)
 		sd->entity.v4l.major = VIDEO_MAJOR;
 		sd->entity.v4l.minor = vdev->minor;
 #endif
+		sd->devnode = vdev;
 	}
 	return 0;
+
+clean_up:
+	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
+		if (!sd->devnode)
+			break;
+		video_unregister_device(sd->devnode);
+	}
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(v4l2_device_register_subdev_nodes);
 
@@ -245,7 +271,7 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 	if (v4l2_dev->mdev)
 		media_device_unregister_entity(&sd->entity);
 #endif
-	video_unregister_device(&sd->devnode);
+	video_unregister_device(sd->devnode);
 	module_put(sd->owner);
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 257da1a..5dd049a 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -534,13 +534,13 @@ struct v4l2_subdev {
 	void *dev_priv;
 	void *host_priv;
 	/* subdev device node */
-	struct video_device devnode;
+	struct video_device *devnode;
 };
 
 #define media_entity_to_v4l2_subdev(ent) \
 	container_of(ent, struct v4l2_subdev, entity)
 #define vdev_to_v4l2_subdev(vdev) \
-	container_of(vdev, struct v4l2_subdev, devnode)
+	video_get_drvdata(vdev)
 
 /*
  * Used for storing subdev information per file handle
-- 
1.7.2.5

