Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43921 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbZJTIOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:14:52 -0400
Message-Id: <20091020011215.243408842@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:16 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC/PATCH 06/14] v4l-mc: Remove subdev v4l2_dev field
References: <20091020011210.623421213@ideasonboard.com>
Content-Disposition: inline; filename=v4l-mc-remove-subdev-v4l2-dev-field.diff
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A pointer to the v4l2_device is stored in the v4l2_entity structure that
v4l2_subdev derives from. There is no need to hold an extra copy of the
pointer.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc/linux/include/media/v4l2-subdev.h
===================================================================
--- v4l-dvb-mc.orig/linux/include/media/v4l2-subdev.h
+++ v4l-dvb-mc/linux/include/media/v4l2-subdev.h
@@ -261,7 +261,6 @@ struct v4l2_subdev {
 	struct v4l2_entity entity;
 	struct module *owner;
 	u32 flags;
-	struct v4l2_device *v4l2_dev;
 	const struct v4l2_subdev_ops *ops;
 	/* name must be unique */
 	char name[V4L2_SUBDEV_NAME_SIZE];
@@ -290,7 +289,6 @@ static inline void v4l2_subdev_init(stru
 	sd->entity.subtype = V4L2_SUBDEV_TYPE_MISC;
 	sd->entity.name = sd->name;
 	sd->ops = ops;
-	sd->v4l2_dev = NULL;
 	sd->flags = 0;
 	sd->name[0] = '\0';
 	sd->grp_id = 0;
@@ -308,7 +306,7 @@ static inline void v4l2_subdev_init(stru
 
 /* Send a notification to v4l2_device. */
 #define v4l2_subdev_notify(sd, notification, arg)			   \
-	((!(sd) || !(sd)->v4l2_dev || !(sd)->v4l2_dev->notify) ? -ENODEV : \
-	 (sd)->v4l2_dev->notify((sd), (notification), (arg)))
+	((!(sd) || !(sd)->entity.parent || !(sd)->entity.parent->notify) ? \
+	  -ENODEV : (sd)->entity.parent->notify((sd), (notification), (arg)))
 
 #endif
Index: v4l-dvb-mc/linux/drivers/media/video/bt819.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/bt819.c
+++ v4l-dvb-mc/linux/drivers/media/video/bt819.c
@@ -256,7 +256,7 @@ static int bt819_s_std(struct v4l2_subde
 
 	v4l2_dbg(1, debug, sd, "set norm %llx\n", (unsigned long long)std);
 
-	if (sd->v4l2_dev == NULL || sd->v4l2_dev->notify == NULL)
+	if (sd->entity.parent == NULL || sd->entity.parent->notify == NULL)
 		v4l2_err(sd, "no notify found!\n");
 
 	if (std & V4L2_STD_NTSC) {
@@ -308,7 +308,7 @@ static int bt819_s_routing(struct v4l2_s
 	if (input < 0 || input > 7)
 		return -EINVAL;
 
-	if (sd->v4l2_dev == NULL || sd->v4l2_dev->notify == NULL)
+	if (sd->entity.parent == NULL || sd->entity.parent->notify == NULL)
 		v4l2_err(sd, "no notify found!\n");
 
 	if (decoder->input != input) {
Index: v4l-dvb-mc/linux/drivers/media/video/v4l2-device.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/v4l2-device.c
+++ v4l-dvb-mc/linux/drivers/media/video/v4l2-device.c
@@ -333,10 +333,10 @@ int v4l2_device_register_subdev(struct v
 	if (v4l2_dev == NULL || sd == NULL || !sd->name[0])
 		return -EINVAL;
 	/* Warn if we apparently re-register a subdev */
-	WARN_ON(sd->v4l2_dev != NULL);
+	WARN_ON(sd->entity.parent != NULL);
 	if (!try_module_get(sd->owner))
 		return -ENODEV;
-	sd->v4l2_dev = v4l2_dev;
+	sd->entity.parent = v4l2_dev;
 	spin_lock(&v4l2_dev->lock);
 	sd->entity.id = v4l2_dev->subdev_id++;
 	list_add_tail(&sd->entity.list, &v4l2_dev->subdevs);
@@ -348,12 +348,12 @@ EXPORT_SYMBOL_GPL(v4l2_device_register_s
 void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 {
 	/* return if it isn't registered */
-	if (sd == NULL || sd->v4l2_dev == NULL)
+	if (sd == NULL || sd->entity.parent == NULL)
 		return;
-	spin_lock(&sd->v4l2_dev->lock);
+	spin_lock(&sd->entity.parent->lock);
 	list_del(&sd->entity.list);
-	spin_unlock(&sd->v4l2_dev->lock);
-	sd->v4l2_dev = NULL;
+	spin_unlock(&sd->entity.parent->lock);
+	sd->entity.parent = NULL;
 	module_put(sd->owner);
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
Index: v4l-dvb-mc/linux/drivers/media/video/zoran/zoran_card.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/zoran/zoran_card.c
+++ v4l-dvb-mc/linux/drivers/media/video/zoran/zoran_card.c
@@ -1196,7 +1196,7 @@ zoran_setup_videocodec (struct zoran *zr
 
 static void zoran_subdev_notify(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 {
-	struct zoran *zr = to_zoran(sd->v4l2_dev);
+	struct zoran *zr = to_zoran(sd->entity.parent);
 
 	/* Bt819 needs to reset its FIFO buffer using #FRST pin and
 	   LML33 card uses GPIO(7) for that. */


