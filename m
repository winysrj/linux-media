Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48433 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbbH3DHu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v8 53/55] [media] v4l2-core: create MC interfaces for devnodes
Date: Sun, 30 Aug 2015 00:07:04 -0300
Message-Id: <51ba7f932951fb758e42c9cd93467b71668a8533.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 device (and subdevice) nodes should create an
interface, if the Media Controller support is enabled.

Please notice that radio devices should not create an
entity, as radio input/output is either via wires or
via ALSA.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 44b330589787..427a5a32b3de 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -194,9 +194,12 @@ static void v4l2_device_release(struct device *cd)
 	mutex_unlock(&videodev_lock);
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	if (v4l2_dev->mdev &&
-	    vdev->vfl_type != VFL_TYPE_SUBDEV)
-		media_device_unregister_entity(&vdev->entity);
+	if (v4l2_dev->mdev) {
+		/* Remove interfaces and interface links */
+		media_devnode_remove(vdev->intf_devnode);
+		if (vdev->vfl_type != VFL_TYPE_SUBDEV)
+			media_device_unregister_entity(&vdev->entity);
+	}
 #endif
 
 	/* Do not call v4l2_device_put if there is no release callback set.
@@ -713,6 +716,85 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			BASE_VIDIOC_PRIVATE);
 }
 
+
+static int video_register_media_controller(struct video_device *vdev, int type)
+{
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	u32 entity_type = MEDIA_ENT_T_UNKNOWN;
+	u32 intf_type;
+	int ret;
+	bool create_entity = true;
+
+	if (!vdev->v4l2_dev->mdev)
+		return 0;
+
+	switch (type) {
+	case VFL_TYPE_GRABBER:
+		intf_type = MEDIA_INTF_T_V4L_VIDEO;
+		entity_type = MEDIA_ENT_T_V4L2_VIDEO;
+		break;
+	case VFL_TYPE_VBI:
+		intf_type = MEDIA_INTF_T_V4L_VBI;
+		entity_type = MEDIA_ENT_T_V4L2_VBI;
+		break;
+	case VFL_TYPE_SDR:
+		intf_type = MEDIA_INTF_T_V4L_SWRADIO;
+		entity_type = MEDIA_ENT_T_V4L2_SWRADIO;
+		break;
+	case VFL_TYPE_RADIO:
+		intf_type = MEDIA_INTF_T_V4L_RADIO;
+		/*
+		 * Radio doesn't have an entity at the V4L2 side to represent
+		 * radio input or output. Instead, the audio input/output goes
+		 * via either physical wires or ALSA.
+		 */
+		create_entity = false;
+		break;
+	case VFL_TYPE_SUBDEV:
+		intf_type = MEDIA_INTF_T_V4L_SUBDEV;
+		/* Entity will be created via v4l2_device_register_subdev() */
+		create_entity = false;
+		break;
+	default:
+		return 0;
+	}
+
+	if (create_entity) {
+		vdev->entity.type = entity_type;
+		vdev->entity.name = vdev->name;
+
+		/* Needed just for backward compatibility with legacy MC API */
+		vdev->entity.info.dev.major = VIDEO_MAJOR;
+		vdev->entity.info.dev.minor = vdev->minor;
+
+		ret = media_device_register_entity(vdev->v4l2_dev->mdev,
+						   &vdev->entity);
+		if (ret < 0) {
+			printk(KERN_WARNING
+				"%s: media_device_register_entity failed\n",
+				__func__);
+			return ret;
+		}
+	}
+
+	vdev->intf_devnode = media_devnode_create(vdev->v4l2_dev->mdev,
+						  intf_type,
+						  0, VIDEO_MAJOR,
+						  vdev->minor,
+						  GFP_KERNEL);
+	if (!vdev->intf_devnode)
+		return -ENOMEM;
+
+	if (create_entity)
+		media_create_intf_link(&vdev->entity,
+				       &vdev->intf_devnode->intf, 0);
+
+	/* FIXME: how to create the other interface links? */
+
+#endif
+	return 0;
+}
+
 /**
  *	__video_register_device - register video4linux devices
  *	@vdev: video device structure we want to register
@@ -908,22 +990,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	/* Increase v4l2_device refcount */
 	v4l2_device_get(vdev->v4l2_dev);
 
-#if defined(CONFIG_MEDIA_CONTROLLER)
 	/* Part 5: Register the entity. */
-	if (vdev->v4l2_dev->mdev &&
-	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
-		vdev->entity.type = MEDIA_ENT_T_V4L2_VIDEO;
-		vdev->entity.name = vdev->name;
-		vdev->entity.info.dev.major = VIDEO_MAJOR;
-		vdev->entity.info.dev.minor = vdev->minor;
-		ret = media_device_register_entity(vdev->v4l2_dev->mdev,
-			&vdev->entity);
-		if (ret < 0)
-			printk(KERN_WARNING
-			       "%s: media_device_register_entity failed\n",
-			       __func__);
-	}
-#endif
+	ret = video_register_media_controller(vdev, type);
+
 	/* Part 6: Activate this minor. The char device can now be used. */
 	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
 
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 5b0a30b9252b..17ec73b1796e 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -249,6 +249,11 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 #if defined(CONFIG_MEDIA_CONTROLLER)
 		sd->entity.info.dev.major = VIDEO_MAJOR;
 		sd->entity.info.dev.minor = vdev->minor;
+
+		/* Interface is created by __video_register_device() */
+		if (vdev->v4l2_dev->mdev)
+			media_create_intf_link(&sd->entity,
+					       &vdev->intf_devnode->intf, 0);
 #endif
 		sd->devnode = vdev;
 	}
@@ -285,7 +290,10 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	if (v4l2_dev->mdev) {
-		media_entity_remove_links(&sd->entity);
+		/*
+		 * No need to explicitly remove links, as both pads and
+		 * links are removed by the function below, at the right order
+		 */
 		media_device_unregister_entity(&sd->entity);
 	}
 #endif
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index acbcd2f5fe7f..eeabf20e87a6 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -86,6 +86,7 @@ struct video_device
 {
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_entity entity;
+	struct media_intf_devnode *intf_devnode;
 #endif
 	/* device ops */
 	const struct v4l2_file_operations *fops;
-- 
2.4.3

