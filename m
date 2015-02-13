Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49415 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbbBMW6U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:20 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv4 08/25] [media] dvbdev: add support for media controller
Date: Fri, 13 Feb 2015 20:57:51 -0200
Message-Id: <461d43d93727a9349b64140fcbdd1cb7412b7855.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide a way to register media controller device nodes
at the DVB core.

Please notice that the dvbdev callers also require changes
for the devices to be registered via the media controller.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 49cd30870e0d..3ef0f90b128f 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -87,13 +87,21 @@ config MEDIA_RC_SUPPORT
 
 config MEDIA_CONTROLLER
 	bool "Media Controller API"
-	depends on MEDIA_CAMERA_SUPPORT
+	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
 	---help---
 	  Enable the media controller API used to query media devices internal
 	  topology and configure it dynamically.
 
 	  This API is mostly used by camera interfaces in embedded platforms.
 
+config MEDIA_CONTROLLER_DVB
+	bool "Enable Media controller for DVB"
+	depends on MEDIA_CONTROLLER
+	---help---
+	  Enable the media controller API support for DVB.
+
+	  This is currently experimental.
+
 #
 # Video4Linux support
 #	Only enables if one of the V4L2 types (ATV, webcam, radio) is selected
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 983db75de350..f98fd3b29afe 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -180,6 +180,59 @@ skip:
 	return -ENFILE;
 }
 
+static void dvb_register_media_device(struct dvb_device *dvbdev,
+				      int type, int minor)
+{
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	int ret;
+
+	if (!dvbdev->adapter->mdev)
+		return;
+
+	dvbdev->entity = kzalloc(sizeof(*dvbdev->entity), GFP_KERNEL);
+	if (!dvbdev->entity)
+		return;
+
+	dvbdev->entity->info.dev.major = DVB_MAJOR;
+	dvbdev->entity->info.dev.minor = minor;
+	dvbdev->entity->name = dvbdev->name;
+	switch (type) {
+	case DVB_DEVICE_FRONTEND:
+		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_FE;
+		break;
+	case DVB_DEVICE_DEMUX:
+		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_DEMUX;
+		break;
+	case DVB_DEVICE_DVR:
+		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_DVR;
+		break;
+	case DVB_DEVICE_CA:
+		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_CA;
+		break;
+	case DVB_DEVICE_NET:
+		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_NET;
+		break;
+	default:
+		kfree(dvbdev->entity);
+		dvbdev->entity = NULL;
+		return;
+	}
+
+	ret = media_device_register_entity(dvbdev->adapter->mdev,
+					   dvbdev->entity);
+	if (ret < 0) {
+		printk(KERN_ERR
+			"%s: media_device_register_entity failed for %s\n",
+			__func__, dvbdev->entity->name);
+		kfree(dvbdev->entity);
+		dvbdev->entity = NULL;
+		return;
+	}
+
+	printk(KERN_DEBUG "%s: media device '%s' registered.\n",
+		__func__, dvbdev->entity->name);
+#endif
+}
 
 int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 			const struct dvb_device *template, void *priv, int type)
@@ -258,10 +311,11 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 		       __func__, adap->num, dnames[type], id, PTR_ERR(clsdev));
 		return PTR_ERR(clsdev);
 	}
-
 	dprintk(KERN_DEBUG "DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
 		adap->num, dnames[type], id, minor, minor);
 
+	dvb_register_media_device(dvbdev, type, minor);
+
 	return 0;
 }
 EXPORT_SYMBOL(dvb_register_device);
@@ -278,6 +332,13 @@ void dvb_unregister_device(struct dvb_device *dvbdev)
 
 	device_destroy(dvb_class, MKDEV(DVB_MAJOR, dvbdev->minor));
 
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	if (dvbdev->entity) {
+		media_device_unregister_entity(dvbdev->entity);
+		kfree(dvbdev->entity);
+	}
+#endif
+
 	list_del (&dvbdev->list_head);
 	kfree (dvbdev->fops);
 	kfree (dvbdev);
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index f96b28e7fc95..485d8e660aea 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -27,6 +27,7 @@
 #include <linux/poll.h>
 #include <linux/fs.h>
 #include <linux/list.h>
+#include <media/media-device.h>
 
 #define DVB_MAJOR 212
 
@@ -71,6 +72,10 @@ struct dvb_adapter {
 	int mfe_shared;			/* indicates mutually exclusive frontends */
 	struct dvb_device *mfe_dvbdev;	/* frontend device in use */
 	struct mutex mfe_lock;		/* access lock for thread creation */
+
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	struct media_device *mdev;
+#endif
 };
 
 
@@ -92,6 +97,14 @@ struct dvb_device {
 	/* don't really need those !? -- FIXME: use video_usercopy  */
 	int (*kernel_ioctl)(struct file *file, unsigned int cmd, void *arg);
 
+	/* Needed for media controller register/unregister */
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	const char *name;
+
+	/* Filled inside dvbdev.c */
+	struct media_entity *entity;
+#endif
+
 	void *priv;
 };
 
-- 
2.1.0

