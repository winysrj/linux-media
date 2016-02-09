Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbcBISA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2016 13:00:27 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Inki Dae <inki.dae@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] au0828: move V4L2-specific code to au0828-core.c
Date: Tue,  9 Feb 2016 15:59:06 -0200
Message-Id: <5b23293902507e588408d2b1a1c3b8928d231a9d.1455040739.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of having lots of #ifdefs inside au0828-core due to
V4L2, move the dependencies to au0828-video.c. That allows
removing all those ifdefs, as au0828-video is only compiled if
CONFIG_VIDEO_AU0828_V4L2.

This fixes the following warnings reported by Kbuild test
with a random config with au0828 enabled, but V4L2 is disabled.

All warnings (new ones prefixed by >>):

   drivers/media/usb/au0828/au0828-core.c: In function 'au0828_usb_probe':
>> drivers/media/usb/au0828/au0828-core.c:463:1: warning: label 'done' defined but not used [-Wunused-label]
    done:
    ^
   drivers/media/usb/au0828/au0828-core.c: At top level:
   drivers/media/usb/au0828/au0828-core.c:250:12: warning: 'au0828_create_media_graph' defined but not used [-Wunused-function]
    static int au0828_create_media_graph(struct au0828_dev *dev)
               ^

Compile-tested only.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c  | 157 ++-----------------------------
 drivers/media/usb/au0828/au0828-video.c | 162 +++++++++++++++++++++++++++++++-
 drivers/media/usb/au0828/au0828.h       |  20 +++-
 3 files changed, 187 insertions(+), 152 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 0a8afbf181c9..f23da7e7984b 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -143,7 +143,7 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 #endif
 }
 
-static void au0828_usb_release(struct au0828_dev *dev)
+void au0828_usb_release(struct au0828_dev *dev)
 {
 	au0828_unregister_media_device(dev);
 
@@ -153,33 +153,6 @@ static void au0828_usb_release(struct au0828_dev *dev)
 	kfree(dev);
 }
 
-#ifdef CONFIG_VIDEO_AU0828_V4L2
-
-static void au0828_usb_v4l2_media_release(struct au0828_dev *dev)
-{
-#ifdef CONFIG_MEDIA_CONTROLLER
-	int i;
-
-	for (i = 0; i < AU0828_MAX_INPUT; i++) {
-		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
-			return;
-		media_device_unregister_entity(&dev->input_ent[i]);
-	}
-#endif
-}
-
-static void au0828_usb_v4l2_release(struct v4l2_device *v4l2_dev)
-{
-	struct au0828_dev *dev =
-		container_of(v4l2_dev, struct au0828_dev, v4l2_dev);
-
-	v4l2_ctrl_handler_free(&dev->v4l2_ctrl_hdl);
-	v4l2_device_unregister(&dev->v4l2_dev);
-	au0828_usb_v4l2_media_release(dev);
-	au0828_usb_release(dev);
-}
-#endif
-
 static void au0828_usb_disconnect(struct usb_interface *interface)
 {
 	struct au0828_dev *dev = usb_get_intfdata(interface);
@@ -202,18 +175,13 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	mutex_lock(&dev->mutex);
 	dev->usbdev = NULL;
 	mutex_unlock(&dev->mutex);
-#ifdef CONFIG_VIDEO_AU0828_V4L2
-	if (AUVI_INPUT(0).type != AU0828_VMUX_UNDEFINED) {
-		au0828_analog_unregister(dev);
-		v4l2_device_disconnect(&dev->v4l2_dev);
-		v4l2_device_put(&dev->v4l2_dev);
+	if (au0828_analog_unregister(dev)) {
 		/*
 		 * No need to call au0828_usb_release() if V4L2 is enabled,
 		 * as this is already called via au0828_usb_v4l2_release()
 		 */
 		return;
 	}
-#endif
 	au0828_usb_release(dev);
 }
 
@@ -247,83 +215,6 @@ static int au0828_media_device_init(struct au0828_dev *dev,
 }
 
 
-static int au0828_create_media_graph(struct au0828_dev *dev)
-{
-#ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_device *mdev = dev->media_dev;
-	struct media_entity *entity;
-	struct media_entity *tuner = NULL, *decoder = NULL;
-	int i, ret;
-
-	if (!mdev)
-		return 0;
-
-	media_device_for_each_entity(entity, mdev) {
-		switch (entity->function) {
-		case MEDIA_ENT_F_TUNER:
-			tuner = entity;
-			break;
-		case MEDIA_ENT_F_ATV_DECODER:
-			decoder = entity;
-			break;
-		}
-	}
-
-	/* Analog setup, using tuner as a link */
-
-	/* Something bad happened! */
-	if (!decoder)
-		return -EINVAL;
-
-	if (tuner) {
-		ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
-					    decoder, 0,
-					    MEDIA_LNK_FL_ENABLED);
-		if (ret)
-			return ret;
-	}
-	ret = media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
-				    MEDIA_LNK_FL_ENABLED);
-	if (ret)
-		return ret;
-	ret = media_create_pad_link(decoder, 2, &dev->vbi_dev.entity, 0,
-				    MEDIA_LNK_FL_ENABLED);
-	if (ret)
-		return ret;
-
-	for (i = 0; i < AU0828_MAX_INPUT; i++) {
-		struct media_entity *ent = &dev->input_ent[i];
-
-		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
-			break;
-
-		switch (AUVI_INPUT(i).type) {
-		case AU0828_VMUX_CABLE:
-		case AU0828_VMUX_TELEVISION:
-		case AU0828_VMUX_DVB:
-			if (!tuner)
-				break;
-
-			ret = media_create_pad_link(ent, 0, tuner,
-						    TUNER_PAD_RF_INPUT,
-						    MEDIA_LNK_FL_ENABLED);
-			if (ret)
-				return ret;
-			break;
-		case AU0828_VMUX_COMPOSITE:
-		case AU0828_VMUX_SVIDEO:
-		default: /* AU0828_VMUX_DEBUG */
-			/* FIXME: fix the decoder PAD */
-			ret = media_create_pad_link(ent, 0, decoder, 0, 0);
-			if (ret)
-				return ret;
-			break;
-		}
-	}
-#endif
-	return 0;
-}
-
 static int au0828_usb_probe(struct usb_interface *interface,
 	const struct usb_device_id *id)
 {
@@ -378,32 +269,13 @@ static int au0828_usb_probe(struct usb_interface *interface,
 		return retval;
 	}
 
-#ifdef CONFIG_VIDEO_AU0828_V4L2
-	dev->v4l2_dev.release = au0828_usb_v4l2_release;
-
-	/* Create the v4l2_device */
-#ifdef CONFIG_MEDIA_CONTROLLER
-	dev->v4l2_dev.mdev = dev->media_dev;
-#endif
-	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
+	retval = au0828_v4l2_device_register(interface, dev);
 	if (retval) {
-		pr_err("%s() v4l2_device_register failed\n",
-		       __func__);
+		au0828_usb_v4l2_media_release(dev);
 		mutex_unlock(&dev->lock);
 		kfree(dev);
 		return retval;
 	}
-	/* This control handler will inherit the controls from au8522 */
-	retval = v4l2_ctrl_handler_init(&dev->v4l2_ctrl_hdl, 4);
-	if (retval) {
-		pr_err("%s() v4l2_ctrl_handler_init failed\n",
-		       __func__);
-		mutex_unlock(&dev->lock);
-		kfree(dev);
-		return retval;
-	}
-	dev->v4l2_dev.ctrl_handler = &dev->v4l2_ctrl_hdl;
-#endif
 
 	/* Power Up the bridge */
 	au0828_write(dev, REG_600, 1 << 4);
@@ -417,24 +289,13 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	/* Setup */
 	au0828_card_setup(dev);
 
-#ifdef CONFIG_VIDEO_AU0828_V4L2
 	/* Analog TV */
-	if (AUVI_INPUT(0).type != AU0828_VMUX_UNDEFINED) {
-		retval = au0828_analog_register(dev, interface);
-		if (retval) {
-			pr_err("%s() au0282_dev_register failed to register on V4L2\n",
-			       __func__);
-			goto done;
-		}
-
-		retval = au0828_create_media_graph(dev);
-		if (retval) {
-			pr_err("%s() au0282_dev_register failed to create graph\n",
-			       __func__);
-			goto done;
-		}
+	retval = au0828_analog_register(dev, interface);
+	if (retval) {
+		pr_err("%s() au0282_dev_register failed to register on V4L2\n",
+			__func__);
+		goto done;
 	}
-#endif
 
 	/* Digital TV */
 	retval = au0828_dvb_register(dev);
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 8c54fd21022e..4164302dd8ac 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -638,6 +638,144 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 	return rc;
 }
 
+void au0828_usb_v4l2_media_release(struct au0828_dev *dev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	int i;
+
+	for (i = 0; i < AU0828_MAX_INPUT; i++) {
+		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
+			return;
+		media_device_unregister_entity(&dev->input_ent[i]);
+	}
+#endif
+}
+
+static int au0828_create_media_graph(struct au0828_dev *dev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev = dev->media_dev;
+	struct media_entity *entity;
+	struct media_entity *tuner = NULL, *decoder = NULL;
+	int i, ret;
+
+	if (!mdev)
+		return 0;
+
+	media_device_for_each_entity(entity, mdev) {
+		switch (entity->function) {
+		case MEDIA_ENT_F_TUNER:
+			tuner = entity;
+			break;
+		case MEDIA_ENT_F_ATV_DECODER:
+			decoder = entity;
+			break;
+		}
+	}
+
+	/* Analog setup, using tuner as a link */
+
+	/* Something bad happened! */
+	if (!decoder)
+		return -EINVAL;
+
+	if (tuner) {
+		ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
+					    decoder, 0,
+					    MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+	}
+	ret = media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
+				    MEDIA_LNK_FL_ENABLED);
+	if (ret)
+		return ret;
+	ret = media_create_pad_link(decoder, 2, &dev->vbi_dev.entity, 0,
+				    MEDIA_LNK_FL_ENABLED);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < AU0828_MAX_INPUT; i++) {
+		struct media_entity *ent = &dev->input_ent[i];
+
+		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
+			break;
+
+		switch (AUVI_INPUT(i).type) {
+		case AU0828_VMUX_CABLE:
+		case AU0828_VMUX_TELEVISION:
+		case AU0828_VMUX_DVB:
+			if (!tuner)
+				break;
+
+			ret = media_create_pad_link(ent, 0, tuner,
+						    TUNER_PAD_RF_INPUT,
+						    MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				return ret;
+			break;
+		case AU0828_VMUX_COMPOSITE:
+		case AU0828_VMUX_SVIDEO:
+		default: /* AU0828_VMUX_DEBUG */
+			/* FIXME: fix the decoder PAD */
+			ret = media_create_pad_link(ent, 0, decoder, 0, 0);
+			if (ret)
+				return ret;
+			break;
+		}
+	}
+#endif
+	return 0;
+}
+
+static void au0828_usb_v4l2_release(struct v4l2_device *v4l2_dev)
+{
+	struct au0828_dev *dev =
+		container_of(v4l2_dev, struct au0828_dev, v4l2_dev);
+
+	v4l2_ctrl_handler_free(&dev->v4l2_ctrl_hdl);
+	v4l2_device_unregister(&dev->v4l2_dev);
+	au0828_usb_v4l2_media_release(dev);
+	au0828_usb_release(dev);
+}
+
+int au0828_v4l2_device_register(struct usb_interface *interface,
+				struct au0828_dev *dev)
+{
+	int retval;
+
+	if (AUVI_INPUT(0).type == AU0828_VMUX_UNDEFINED)
+		return 0;
+
+	/* Create the v4l2_device */
+#ifdef CONFIG_MEDIA_CONTROLLER
+	dev->v4l2_dev.mdev = dev->media_dev;
+#endif
+	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
+	if (retval) {
+		pr_err("%s() v4l2_device_register failed\n",
+		       __func__);
+		mutex_unlock(&dev->lock);
+		kfree(dev);
+		return retval;
+	}
+
+	dev->v4l2_dev.release = au0828_usb_v4l2_release;
+
+	/* This control handler will inherit the controls from au8522 */
+	retval = v4l2_ctrl_handler_init(&dev->v4l2_ctrl_hdl, 4);
+	if (retval) {
+		pr_err("%s() v4l2_ctrl_handler_init failed\n",
+		       __func__);
+		mutex_unlock(&dev->lock);
+		kfree(dev);
+		return retval;
+	}
+	dev->v4l2_dev.ctrl_handler = &dev->v4l2_ctrl_hdl;
+
+	return 0;
+}
+
 static int au0828_enable_analog_tuner(struct au0828_dev *dev)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
@@ -949,13 +1087,23 @@ static struct vb2_ops au0828_video_qops = {
  * au0828_analog_unregister
  * unregister v4l2 devices
  */
-void au0828_analog_unregister(struct au0828_dev *dev)
+int au0828_analog_unregister(struct au0828_dev *dev)
 {
 	dprintk(1, "au0828_analog_unregister called\n");
+
+	/* No analog TV */
+	if (AUVI_INPUT(0).type == AU0828_VMUX_UNDEFINED)
+		return 0;
+
 	mutex_lock(&au0828_sysfs_lock);
 	video_unregister_device(&dev->vdev);
 	video_unregister_device(&dev->vbi_dev);
 	mutex_unlock(&au0828_sysfs_lock);
+
+	v4l2_device_disconnect(&dev->v4l2_dev);
+	v4l2_device_put(&dev->v4l2_dev);
+
+	return 1;
 }
 
 /* This function ensures that video frames continue to be delivered even if
@@ -1871,6 +2019,10 @@ int au0828_analog_register(struct au0828_dev *dev,
 	dprintk(1, "au0828_analog_register called for intf#%d!\n",
 		interface->cur_altsetting->desc.bInterfaceNumber);
 
+	/* No analog TV */
+	if (AUVI_INPUT(0).type == AU0828_VMUX_UNDEFINED)
+		return 0;
+
 	/* set au0828 usb interface0 to as5 */
 	retval = usb_set_interface(dev->usbdev,
 			interface->cur_altsetting->desc.bInterfaceNumber, 5);
@@ -1976,6 +2128,14 @@ int au0828_analog_register(struct au0828_dev *dev,
 		ret = -ENODEV;
 		goto err_reg_vbi_dev;
 	}
+	retval = au0828_create_media_graph(dev);
+	if (retval) {
+		pr_err("%s() au0282_dev_register failed to create graph\n",
+			__func__);
+		ret = -ENODEV;
+		goto err_reg_vbi_dev;
+	}
+
 
 	dprintk(1, "%s completed!\n", __func__);
 
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 8276072bc55a..43f2af731088 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -301,6 +301,7 @@ struct au0828_dev {
 /* au0828-core.c */
 extern u32 au0828_read(struct au0828_dev *dev, u16 reg);
 extern u32 au0828_write(struct au0828_dev *dev, u16 reg, u32 val);
+extern void au0828_usb_release(struct au0828_dev *dev);
 extern int au0828_debug;
 
 /* ----------------------------------------------------------- */
@@ -319,16 +320,29 @@ extern int au0828_i2c_unregister(struct au0828_dev *dev);
 
 /* ----------------------------------------------------------- */
 /* au0828-video.c */
-extern int au0828_analog_register(struct au0828_dev *dev,
-			   struct usb_interface *interface);
-extern void au0828_analog_unregister(struct au0828_dev *dev);
 extern int au0828_start_analog_streaming(struct vb2_queue *vq,
 						unsigned int count);
 extern void au0828_stop_vbi_streaming(struct vb2_queue *vq);
 #ifdef CONFIG_VIDEO_AU0828_V4L2
+extern int au0828_v4l2_device_register(struct usb_interface *interface,
+				      struct au0828_dev *dev);
+
+extern int au0828_analog_register(struct au0828_dev *dev,
+			   struct usb_interface *interface);
+extern int au0828_analog_unregister(struct au0828_dev *dev);
+extern void au0828_usb_v4l2_media_release(struct au0828_dev *dev);
 extern void au0828_v4l2_suspend(struct au0828_dev *dev);
 extern void au0828_v4l2_resume(struct au0828_dev *dev);
 #else
+static inline int au0828_v4l2_device_register(struct usb_interface *interface,
+					      struct au0828_dev *dev)
+{ return 0; };
+static inline au0828_analog_register(struct au0828_dev *dev,
+				     struct usb_interface *interface)
+{ return 0; };
+static inline int au0828_analog_unregister(struct au0828_dev *dev)
+{ return 0; };
+static inline void au0828_usb_v4l2_media_release(struct au0828_dev *dev) { };
 static inline void au0828_v4l2_suspend(struct au0828_dev *dev) { };
 static inline void au0828_v4l2_resume(struct au0828_dev *dev) { };
 #endif
-- 
2.5.0

