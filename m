Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39606 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbeIDPzP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2018 11:55:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id o37-v6so3568809wrf.6
        for <linux-media@vger.kernel.org>; Tue, 04 Sep 2018 04:30:30 -0700 (PDT)
From: Javier Martinez Canillas <javierm@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media] v4l: allow to register dev nodes for individual v4l2 subdevs
Date: Tue,  4 Sep 2018 13:30:17 +0200
Message-Id: <20180904113018.14428-2-javierm@redhat.com>
In-Reply-To: <20180904113018.14428-1-javierm@redhat.com>
References: <20180904113018.14428-1-javierm@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently there's only a function to register device nodes for all subdevs
of a v4l2 device that are marked with the V4L2_SUBDEV_FL_HAS_DEVNODE flag.

But drivers may want to register device nodes for individual subdevices,
so add a v4l2_device_register_subdev_node() for this purpose.

A use case for this function is for media device drivers to register the
device nodes in the v4l2 async notifier .bound callback instead of doing
a registration for all subdevices in the .complete callback.

Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
---

 drivers/media/v4l2-core/v4l2-device.c | 90 ++++++++++++++++-----------
 include/media/v4l2-device.h           | 10 +++
 2 files changed, 63 insertions(+), 37 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 3940e55c72f1..e5fc51b6604c 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -222,9 +222,59 @@ static void v4l2_device_release_subdev_node(struct video_device *vdev)
 	kfree(vdev);
 }
 
-int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
+int v4l2_device_register_subdev_node(struct v4l2_device *v4l2_dev,
+				     struct v4l2_subdev *sd)
 {
 	struct video_device *vdev;
+	int err;
+
+	if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
+		return -EINVAL;
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+
+	video_set_drvdata(vdev, sd);
+	strlcpy(vdev->name, sd->name, sizeof(vdev->name));
+	vdev->v4l2_dev = v4l2_dev;
+	vdev->fops = &v4l2_subdev_fops;
+	vdev->release = v4l2_device_release_subdev_node;
+	vdev->ctrl_handler = sd->ctrl_handler;
+	err = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
+				      sd->owner);
+	if (err < 0) {
+		kfree(vdev);
+		return err;
+	}
+	sd->devnode = vdev;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	sd->entity.info.dev.major = VIDEO_MAJOR;
+	sd->entity.info.dev.minor = vdev->minor;
+
+	/* Interface is created by __video_register_device() */
+	if (vdev->v4l2_dev->mdev) {
+		struct media_link *link;
+
+		link = media_create_intf_link(&sd->entity,
+					      &vdev->intf_devnode->intf,
+					      MEDIA_LNK_FL_ENABLED |
+					      MEDIA_LNK_FL_IMMUTABLE);
+		if (!link) {
+			err = -ENOMEM;
+			video_unregister_device(sd->devnode);
+			return err;
+		}
+	}
+#endif
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_device_register_subdev_node);
+
+int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
+{
+
 	struct v4l2_subdev *sd;
 	int err;
 
@@ -238,43 +288,9 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 		if (sd->devnode)
 			continue;
 
-		vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-		if (!vdev) {
-			err = -ENOMEM;
-			goto clean_up;
-		}
-
-		video_set_drvdata(vdev, sd);
-		strlcpy(vdev->name, sd->name, sizeof(vdev->name));
-		vdev->v4l2_dev = v4l2_dev;
-		vdev->fops = &v4l2_subdev_fops;
-		vdev->release = v4l2_device_release_subdev_node;
-		vdev->ctrl_handler = sd->ctrl_handler;
-		err = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
-					      sd->owner);
-		if (err < 0) {
-			kfree(vdev);
+		err = v4l2_device_register_subdev_node(v4l2_dev, sd);
+		if (err)
 			goto clean_up;
-		}
-		sd->devnode = vdev;
-#if defined(CONFIG_MEDIA_CONTROLLER)
-		sd->entity.info.dev.major = VIDEO_MAJOR;
-		sd->entity.info.dev.minor = vdev->minor;
-
-		/* Interface is created by __video_register_device() */
-		if (vdev->v4l2_dev->mdev) {
-			struct media_link *link;
-
-			link = media_create_intf_link(&sd->entity,
-						      &vdev->intf_devnode->intf,
-						      MEDIA_LNK_FL_ENABLED |
-						      MEDIA_LNK_FL_IMMUTABLE);
-			if (!link) {
-				err = -ENOMEM;
-				goto clean_up;
-			}
-		}
-#endif
 	}
 	return 0;
 
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index b330e4a08a6b..bf25418a1ad6 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -185,6 +185,16 @@ int __must_check v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
  */
 void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
 
+/**
+ * v4l2_device_register_subdev_node - Registers a device node for a subdev
+ *	of the v4l2 device.
+ *
+ * @v4l2_dev: pointer to struct v4l2_device
+ * @sd: pointer to &struct v4l2_subdev
+ */
+int __must_check v4l2_device_register_subdev_node(struct v4l2_device *v4l2_dev,
+						  struct v4l2_subdev *sd);
+
 /**
  * v4l2_device_register_subdev_nodes - Registers device nodes for all subdevs
  *	of the v4l2 device that are marked with
-- 
2.17.1
