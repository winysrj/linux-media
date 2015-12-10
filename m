Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39188 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbLJKcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 05:32:36 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>, Hans Verkuil <hans.verkuil@cisco.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Tommi Franttila <tommi.franttila@intel.com>
Subject: [PATCH] [media] v4l2-core: create MC interfaces for devnodes
Date: Thu, 10 Dec 2015 08:32:21 -0200
Message-Id: <6acbad49047e51a12d6186a6cb563d5d058e5104.1449743222.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 device (and subdevice) nodes should create an interface, if the
Media Controller support is enabled.

Please notice that radio devices should not create an entity, as radio
input/output is either via wires or via ALSA.

PS.: Before this patch, au0828 should remove the media_device earlier.
However, after the core changes, this should be postponed, otherwise
an OOPS occurs. So, fold the au0828 changes on this patch.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---

PS.: I'm adding this patch just after "media-device: remove interfaces and interface links".

It prevents some troubles with DEBUG_KMEMLEAK and KASAN, with makes
them to hang the Kernel during physical device removal (or device driver
removal). Without this, we get this error:

	kasan: GPF could be caused by NULL-ptr deref or user memory accessgeneral protection fault: 0000 [#1] SMP KASAN

 drivers/media/usb/au0828/au0828-core.c |   6 +-
 drivers/media/v4l2-core/v4l2-dev.c     | 111 +++++++++++++++++++++++++++------
 drivers/media/v4l2-core/v4l2-device.c  |  16 ++++-
 include/media/v4l2-dev.h               |   1 +
 4 files changed, 113 insertions(+), 21 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 7f645bcb7463..5f0b210cc797 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -175,8 +175,6 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	*/
 	dev->dev_state = DEV_DISCONNECTED;
 
-	au0828_unregister_media_device(dev);
-
 	au0828_rc_unregister(dev);
 	/* Digital TV */
 	au0828_dvb_unregister(dev);
@@ -190,6 +188,10 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 		au0828_analog_unregister(dev);
 		v4l2_device_disconnect(&dev->v4l2_dev);
 		v4l2_device_put(&dev->v4l2_dev);
+		/*
+		 * No need to call au0828_usb_release() if V4L2 is enabled,
+		 * as this is already called via au0828_usb_v4l2_release()
+		 */
 		return;
 	}
 #endif
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 2297571a0568..077cdc92778c 100644
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
+		if (vdev->entity.type != MEDIA_ENT_T_UNKNOWN)
+			media_device_unregister_entity(&vdev->entity);
+	}
 #endif
 
 	/* Do not call v4l2_device_put if there is no release callback set.
@@ -723,6 +726,91 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			BASE_VIDIOC_PRIVATE);
 }
 
+static int video_register_media_controller(struct video_device *vdev, int type)
+{
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	u32 intf_type;
+	int ret;
+
+	if (!vdev->v4l2_dev->mdev)
+		return 0;
+
+	vdev->entity.type = MEDIA_ENT_T_UNKNOWN;
+
+	switch (type) {
+	case VFL_TYPE_GRABBER:
+		intf_type = MEDIA_INTF_T_V4L_VIDEO;
+		vdev->entity.type = MEDIA_ENT_T_V4L2_VIDEO;
+		break;
+	case VFL_TYPE_VBI:
+		intf_type = MEDIA_INTF_T_V4L_VBI;
+		vdev->entity.type = MEDIA_ENT_T_V4L2_VBI;
+		break;
+	case VFL_TYPE_SDR:
+		intf_type = MEDIA_INTF_T_V4L_SWRADIO;
+		vdev->entity.type = MEDIA_ENT_T_V4L2_SWRADIO;
+		break;
+	case VFL_TYPE_RADIO:
+		intf_type = MEDIA_INTF_T_V4L_RADIO;
+		/*
+		 * Radio doesn't have an entity at the V4L2 side to represent
+		 * radio input or output. Instead, the audio input/output goes
+		 * via either physical wires or ALSA.
+		 */
+		break;
+	case VFL_TYPE_SUBDEV:
+		intf_type = MEDIA_INTF_T_V4L_SUBDEV;
+		/* Entity will be created via v4l2_device_register_subdev() */
+		break;
+	default:
+		return 0;
+	}
+
+	if (vdev->entity.type != MEDIA_ENT_T_UNKNOWN) {
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
+	if (!vdev->intf_devnode) {
+		media_device_unregister_entity(&vdev->entity);
+		return -ENOMEM;
+	}
+
+	if (vdev->entity.type != MEDIA_ENT_T_UNKNOWN) {
+		struct media_link *link;
+
+		link = media_create_intf_link(&vdev->entity,
+					      &vdev->intf_devnode->intf, 0);
+		if (!link) {
+			media_devnode_remove(vdev->intf_devnode);
+			media_device_unregister_entity(&vdev->entity);
+			return -ENOMEM;
+		}
+	}
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
@@ -918,22 +1006,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
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
index 7129e438f29e..3c87307e56f0 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -258,6 +258,17 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 #if defined(CONFIG_MEDIA_CONTROLLER)
 		sd->entity.info.dev.major = VIDEO_MAJOR;
 		sd->entity.info.dev.minor = vdev->minor;
+
+		/* Interface is created by __video_register_device() */
+		if (vdev->v4l2_dev->mdev) {
+			struct media_link *link;
+
+			link = media_create_intf_link(&sd->entity,
+						      &vdev->intf_devnode->intf,
+						      0);
+			if (!link)
+				goto clean_up;
+		}
 #endif
 		sd->devnode = vdev;
 	}
@@ -294,7 +305,10 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	if (v4l2_dev->mdev) {
-		media_entity_remove_links(&sd->entity);
+		/*
+		 * No need to explicitly remove links, as both pads and
+		 * links are removed by the function below, in the right order
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
2.5.0


