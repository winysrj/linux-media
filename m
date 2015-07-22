Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:47084 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102AbbGVWnB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 18:43:01 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de,
	sakari.ailus@linux.intel.com, perex@perex.cz, crope@iki.fi,
	arnd@arndb.de, stefanr@s5r6.in-berlin.de,
	ruchandani.tina@gmail.com, chehabrafael@gmail.com,
	dan.carpenter@oracle.com, prabhakar.csengg@gmail.com,
	chris.j.arges@canonical.com, agoode@google.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, daniel@zonque.org, vladcatoi@gmail.com,
	misterpib@gmail.com, damien@zamaudio.com, pmatilai@laiskiainen.org,
	takamichiho@gmail.com, normalperson@yhbt.net,
	bugzilla.frnkcg@spamgourmet.com, joe@oampo.co.uk,
	calcprogrammer1@gmail.com, jussi@sonarnerd.net,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	kgene@kernel.org, hyun.kwon@xilinx.com, michal.simek@xilinx.com,
	soren.brinkmann@xilinx.com, pawel@osciak.com,
	m.szyprowski@samsung.com, gregkh@linuxfoundation.org,
	skd08@gmail.com, nsekhar@ti.com,
	boris.brezillon@free-electrons.com, Julia.Lawall@lip6.fr,
	elfring@users.sourceforge.net, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 18/19] media: au0828 change to use Managed Media Controller API
Date: Wed, 22 Jul 2015 16:42:19 -0600
Message-Id: <08112dc4fdb45c72c23723898c865805ff249f3e.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change au0828 to use Managed Media Controller API to coordinate
creating/deleting media device on parent usb device it shares
with the snd-usb-audio driver. With this change, au0828 uses
media_device_get_devres() to allocate a new media device devres
or return an existing one, if it finds one.

au0828 registers entity_notify hook to create media graph for
the device. It creates necessary links from video, vbi, and
ALSA entities to decoder and links tuner and decoder entities.

Implements enable_source hanlder for other drivers to use to
check for tuner connected to the decoder and activate the link
if tuner is free. In addition, au0828-video will populate decoder
field struct video_device for v4l-core to use it when it invokes
enable_source hanlder. au0828 is changed to use enable_source
hanlder to check for tuner availability from vidioc_g_tuner(),
au0828_v4l2_close(), and queue_setup() prior to changing tuner
settings. If tuner isn't free, return busy condition.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c  | 184 +++++++++++++++++++++++---------
 drivers/media/usb/au0828/au0828-video.c |  72 ++++---------
 drivers/media/usb/au0828/au0828.h       |   5 +
 3 files changed, 155 insertions(+), 106 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 0378a2c..ffdde58 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -20,6 +20,7 @@
  */
 
 #include "au0828.h"
+#include "au8522.h"
 
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -129,12 +130,13 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
 
 static void au0828_unregister_media_device(struct au0828_dev *dev)
 {
-
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (dev->media_dev) {
-		media_device_unregister(dev->media_dev);
-		kfree(dev->media_dev);
-		dev->media_dev = NULL;
+	if (dev->media_dev &&
+	    media_devnode_is_registered(&dev->media_dev->devnode)) {
+		media_device_unregister_entity_notify(dev->media_dev,
+						      &dev->entity_notify);
+			media_device_unregister(dev->media_dev);
+			dev->media_dev = NULL;
 	}
 #endif
 }
@@ -196,53 +198,23 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	au0828_usb_release(dev);
 }
 
-static void au0828_media_device_register(struct au0828_dev *dev,
-					  struct usb_device *udev)
-{
-#ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_device *mdev;
-	int ret;
-
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
-	if (!mdev)
-		return;
-
-	mdev->dev = &udev->dev;
-
-	if (!dev->board.name)
-		strlcpy(mdev->model, "unknown au0828", sizeof(mdev->model));
-	else
-		strlcpy(mdev->model, dev->board.name, sizeof(mdev->model));
-	if (udev->serial)
-		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
-	strcpy(mdev->bus_info, udev->devpath);
-	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	mdev->driver_version = LINUX_VERSION_CODE;
-
-	ret = media_device_register(mdev);
-	if (ret) {
-		pr_err(
-			"Couldn't create a media device. Error: %d\n",
-			ret);
-		kfree(mdev);
-		return;
-	}
-
-	dev->media_dev = mdev;
-#endif
-}
-
-
-static void au0828_create_media_graph(struct au0828_dev *dev)
+void au0828_create_media_graph(struct media_entity *new, void *notify_data)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
+	struct au0828_dev *dev = (struct au0828_dev *) notify_data;
 	struct media_device *mdev = dev->media_dev;
 	struct media_entity *entity;
 	struct media_entity *tuner = NULL, *decoder = NULL;
+	struct media_entity *alsa_capture = NULL;
+	int ret = 0;
 
 	if (!mdev)
 		return;
 
+	if (dev->tuner_linked && dev->vdev_linked && dev->vbi_linked &&
+		dev->alsa_capture_linked)
+		return;
+
 	media_device_for_each_entity(entity, mdev) {
 		switch (entity->type) {
 		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
@@ -251,6 +223,9 @@ static void au0828_create_media_graph(struct au0828_dev *dev)
 		case MEDIA_ENT_T_V4L2_SUBDEV_DECODER:
 			decoder = entity;
 			break;
+		case MEDIA_ENT_T_DEVNODE_ALSA_CAPTURE:
+			alsa_capture = entity;
+			break;
 		}
 	}
 
@@ -259,15 +234,120 @@ static void au0828_create_media_graph(struct au0828_dev *dev)
 	if (!decoder)
 		return;
 
-	if (tuner)
-		media_entity_create_link(tuner, 0, decoder, 0,
+	if (tuner && !dev->tuner_linked) {
+		ret = media_entity_create_link(tuner, 0, decoder, 0,
 					 MEDIA_LNK_FL_ENABLED);
-	if (dev->vdev.entity.links)
-		media_entity_create_link(decoder, 1, &dev->vdev.entity, 0,
-				 MEDIA_LNK_FL_ENABLED);
-	if (dev->vbi_dev.entity.links)
-		media_entity_create_link(decoder, 2, &dev->vbi_dev.entity, 0,
-				 MEDIA_LNK_FL_ENABLED);
+		if (ret == 0)
+			dev->tuner_linked = 1;
+	}
+	if (dev->vdev.entity.links && !dev->vdev_linked) {
+		ret = media_entity_create_link(decoder, AU8522_PAD_VID_OUT,
+				&dev->vdev.entity, 0, MEDIA_LNK_FL_ENABLED);
+		if (ret == 0)
+			dev->vdev_linked = 1;
+	}
+	if (dev->vbi_dev.entity.links && !dev->vbi_linked) {
+		ret = media_entity_create_link(decoder, AU8522_PAD_VBI_OUT,
+				&dev->vbi_dev.entity, 0, MEDIA_LNK_FL_ENABLED);
+		if (ret == 0)
+			dev->vbi_linked = 1;
+	}
+	if (alsa_capture && !dev->alsa_capture_linked) {
+		ret = media_entity_create_link(decoder, AU8522_PAD_AUDIO_OUT,
+						alsa_capture, 0,
+						MEDIA_LNK_FL_ENABLED);
+		if (ret == 0)
+			dev->alsa_capture_linked = 1;
+	}
+#endif
+}
+
+int au0828_enable_source(struct media_entity *enable_sink)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_entity  *source;
+	struct media_link *link, *found_link = NULL;
+	int i, ret, active_links = 0, n_links = 0;
+
+	for (i = 0; i < enable_sink->num_links; i++) {
+		link = &enable_sink->links[i];
+		if (link->sink->entity == enable_sink) {
+			found_link = link;
+			n_links++;
+			if (link->flags & MEDIA_LNK_FL_ENABLED)
+				active_links++;
+			break;
+		}
+	}
+
+	if (!n_links || active_links == 1 || !found_link)
+		return 0;
+
+	source = found_link->source->entity;
+	for (i = 0; i < source->num_links; i++) {
+		struct media_entity *sink;
+		int flags = 0;
+
+		link = &source->links[i];
+		sink = link->sink->entity;
+
+		if (sink == enable_sink)
+			flags = MEDIA_LNK_FL_ENABLED;
+
+		ret = media_entity_setup_link(link, flags);
+		if (ret) {
+			pr_err(
+				"Change tuner link %s->%s to %s. Error %d\n",
+				source->name, sink->name,
+				flags ? "enabled" : "disabled",
+				ret);
+			return ret;
+		}
+	}
+	return 0;
+#endif
+	return 0;
+}
+
+static void au0828_media_device_register(struct au0828_dev *dev,
+					  struct usb_device *udev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev;
+	int ret;
+
+	mdev = media_device_get_devres(&udev->dev);
+	if (!mdev)
+		return;
+
+	if (!media_devnode_is_registered(&mdev->devnode)) {
+		/* register media device */
+		mdev->dev = &udev->dev;
+		if (udev->product)
+			strlcpy(mdev->model, udev->product,
+				sizeof(mdev->model));
+		if (udev->serial)
+			strlcpy(mdev->serial, udev->serial,
+				sizeof(mdev->serial));
+		strcpy(mdev->bus_info, udev->devpath);
+		mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+		mdev->enable_source = au0828_enable_source;
+		ret = media_device_register(mdev);
+		if (ret) {
+			dev_err(&udev->dev,
+				"Couldn't create a media device. Error: %d\n",
+				ret);
+			return;
+		}
+		/* register entity_notify callback */
+		dev->entity_notify.notify_data = (void *) dev;
+		dev->entity_notify.notify = au0828_create_media_graph;
+		media_device_register_entity_notify(mdev, &dev->entity_notify);
+	}
+	/* If ALSA registered the media device - set enable_source */
+	if (!mdev->enable_source)
+		mdev->enable_source = au0828_enable_source;
+	dev->media_dev = mdev;
 #endif
 }
 
@@ -383,8 +463,6 @@ static int au0828_usb_probe(struct usb_interface *interface,
 
 	mutex_unlock(&dev->lock);
 
-	au0828_create_media_graph(dev);
-
 	return retval;
 }
 
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 939b2ad..de3140e 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -641,58 +641,10 @@ static int au0828_enable_analog_tuner(struct au0828_dev *dev)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev = dev->media_dev;
-	struct media_entity  *entity, *source;
-	struct media_link *link, *found_link = NULL;
-	int i, ret, active_links = 0;
 
-	if (!mdev || !dev->decoder)
+	if (!mdev || !dev->decoder || !mdev->enable_source)
 		return 0;
-
-	/*
-	 * This will find the tuner that is connected into the decoder.
-	 * Technically, this is not 100% correct, as the device may be
-	 * using an analog input instead of the tuner. However, as we can't
-	 * do DVB streaming while the DMA engine is being used for V4L2,
-	 * this should be enough for the actual needs.
-	 */
-	for (i = 0; i < dev->decoder->num_links; i++) {
-		link = &dev->decoder->links[i];
-		if (link->sink->entity == dev->decoder) {
-			found_link = link;
-			if (link->flags & MEDIA_LNK_FL_ENABLED)
-				active_links++;
-			break;
-		}
-	}
-
-	if (active_links == 1 || !found_link)
-		return 0;
-
-	source = found_link->source->entity;
-	for (i = 0; i < source->num_links; i++) {
-		struct media_entity *sink;
-		int flags = 0;
-
-		link = &source->links[i];
-		sink = link->sink->entity;
-
-		if (sink == entity)
-			flags = MEDIA_LNK_FL_ENABLED;
-
-		ret = media_entity_setup_link(link, flags);
-		if (ret) {
-			pr_err(
-				"Couldn't change link %s->%s to %s. Error %d\n",
-				source->name, sink->name,
-				flags ? "enabled" : "disabled",
-				ret);
-			return ret;
-		} else
-			au0828_isocdbg(
-				"link %s->%s was %s\n",
-				source->name, sink->name,
-				flags ? "ENABLED" : "disabled");
-	}
+	return mdev->enable_source(dev->decoder);
 #endif
 	return 0;
 }
@@ -704,6 +656,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
 	unsigned long img_size = dev->height * dev->bytesperline;
 	unsigned long size;
+	int ret;
 
 	size = fmt ? fmt->fmt.pix.sizeimage : img_size;
 	if (size < img_size)
@@ -712,7 +665,9 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	*nplanes = 1;
 	sizes[0] = size;
 
-	au0828_enable_analog_tuner(dev);
+	ret = au0828_enable_analog_tuner(dev);
+	if (ret)
+		return ret;
 
 	return 0;
 }
@@ -1067,8 +1022,12 @@ static int au0828_v4l2_close(struct file *filp)
 		goto end;
 
 	if (dev->users == 1) {
-		/* Save some power by putting tuner to sleep */
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
+		/* Save some power by putting tuner to sleep, if it is free */
+		/* What happens when radio is using tuner?? */
+		ret = au0828_enable_analog_tuner(dev);
+		if (ret == 0)
+			v4l2_device_call_all(&dev->v4l2_dev, 0, core,
+						s_power, 0);
 		dev->std_set_in_tuner_core = 0;
 
 		/* When close the device, set the usb intf0 into alt0 to free
@@ -1469,10 +1428,15 @@ static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio
 static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
 	struct au0828_dev *dev = video_drvdata(file);
+	int ret;
 
 	if (t->index != 0)
 		return -EINVAL;
 
+	ret = au0828_enable_analog_tuner(dev);
+	if (ret)
+		return ret;
+
 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
 		dev->std_set_in_tuner_core, dev->dev_state);
 
@@ -1884,11 +1848,13 @@ int au0828_analog_register(struct au0828_dev *dev,
 	strcpy(dev->vbi_dev.name, "au0828a vbi");
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
+	dev->vdev.decoder = dev->decoder;
 	dev->video_pad.flags = MEDIA_PAD_FL_SINK;
 	ret = media_entity_init(&dev->vdev.entity, 1, &dev->video_pad, 0);
 	if (ret < 0)
 		pr_err("failed to initialize video media entity!\n");
 
+	dev->vbi_dev.decoder = dev->decoder;
 	dev->vbi_pad.flags = MEDIA_PAD_FL_SINK;
 	ret = media_entity_init(&dev->vbi_dev.entity, 1, &dev->vbi_pad, 0);
 	if (ret < 0)
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index d3644b3..a59ba08 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -281,6 +281,11 @@ struct au0828_dev {
 	struct media_device *media_dev;
 	struct media_pad video_pad, vbi_pad;
 	struct media_entity *decoder;
+	struct media_entity_notify entity_notify;
+	bool tuner_linked;
+	bool vdev_linked;
+	bool vbi_linked;
+	bool alsa_capture_linked;
 #endif
 };
 
-- 
2.1.4

