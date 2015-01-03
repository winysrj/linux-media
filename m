Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46666 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbbACOtZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Jan 2015 09:49:25 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 3/9] dvb core: add support for media controller at dvbdev
Date: Sat,  3 Jan 2015 12:49:05 -0200
Message-Id: <df3a472288618854cd5ca6b59a4e747164638f3e.1420294938.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420294938.git.mchehab@osg.samsung.com>
References: <cover.1420294938.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420294938.git.mchehab@osg.samsung.com>
References: <cover.1420294938.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide a way to register media controller device nodes
at the DVB core.

Please notice that the dvbdev callers also require changes
for the devices to be registered via the media controller.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 983db75de350..28e9d53d0979 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -180,6 +180,58 @@ skip:
 	return -ENFILE;
 }
 
+static void dvb_register_media_device(struct dvb_device *dvbdev,
+				      int type, int minor)
+{
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	int ret;
+
+	if (!dvbdev->mdev)
+		return;
+
+	dvbdev->entity = kzalloc(sizeof(*dvbdev->entity), GFP_KERNEL);
+	if (!dvbdev->entity)
+		return;
+
+	dvbdev->entity->info.dvb.major = DVB_MAJOR;
+	dvbdev->entity->info.dvb.minor = minor;
+	dvbdev->entity->name = dvbdev->name;
+	switch(type) {
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
+	ret = media_device_register_entity(dvbdev->mdev, dvbdev->entity);
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
@@ -258,10 +310,11 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
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
@@ -278,6 +331,13 @@ void dvb_unregister_device(struct dvb_device *dvbdev)
 
 	device_destroy(dvb_class, MKDEV(DVB_MAJOR, dvbdev->minor));
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
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
index f96b28e7fc95..f58dfef46984 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -27,6 +27,7 @@
 #include <linux/poll.h>
 #include <linux/fs.h>
 #include <linux/list.h>
+#include <media/media-device.h>
 
 #define DVB_MAJOR 212
 
@@ -92,6 +93,15 @@ struct dvb_device {
 	/* don't really need those !? -- FIXME: use video_usercopy  */
 	int (*kernel_ioctl)(struct file *file, unsigned int cmd, void *arg);
 
+	/* Needed for media controller register/unregister */
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device *mdev;
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

