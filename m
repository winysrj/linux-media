Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:35146 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbbESCHi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 22:07:38 -0400
Received: by qkai132 with SMTP id i132so799171qka.2
        for <linux-media@vger.kernel.org>; Mon, 18 May 2015 19:07:37 -0700 (PDT)
From: =?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
Subject: [PATCH] au0828: Add support for media controller
Date: Mon, 18 May 2015 23:07:22 -0300
Message-Id: <1432001242-4678-1-git-send-email-chehabrafael@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for analog and dvb tv using media controller

Signed-off-by: Rafael Lourenço de Lima Chehab <chehabrafael@gmail.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c |  17 +++++
 drivers/media/dvb-frontends/au8522_priv.h    |  12 +++
 drivers/media/media-entity.c                 |   1 +
 drivers/media/usb/au0828/au0828-cards.c      |   2 -
 drivers/media/usb/au0828/au0828-core.c       | 105 +++++++++++++++++++++++++++
 drivers/media/usb/au0828/au0828-dvb.c        |  10 +++
 drivers/media/usb/au0828/au0828-video.c      |  83 +++++++++++++++++++++
 drivers/media/usb/au0828/au0828.h            |   6 ++
 8 files changed, 234 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 33aa9410b624..24990db7ba38 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -731,6 +731,9 @@ static int au8522_probe(struct i2c_client *client,
 	struct v4l2_subdev *sd;
 	int instance;
 	struct au8522_config *demod_config;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	int ret;
+#endif
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter,
@@ -767,6 +770,20 @@ static int au8522_probe(struct i2c_client *client,
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &au8522_ops);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+
+	state->pads[AU8522_PAD_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[AU8522_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[AU8522_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
+
+	ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
+				state->pads, 0);
+	if (ret < 0) {
+		v4l_info(client, "failed to initialize media entity!\n");
+		return ret;
+	}
+#endif
 
 	hdl = &state->hdl;
 	v4l2_ctrl_handler_init(hdl, 4);
diff --git a/drivers/media/dvb-frontends/au8522_priv.h b/drivers/media/dvb-frontends/au8522_priv.h
index b8aca1c84786..ed6eb2675508 100644
--- a/drivers/media/dvb-frontends/au8522_priv.h
+++ b/drivers/media/dvb-frontends/au8522_priv.h
@@ -39,6 +39,14 @@
 #define AU8522_DIGITAL_MODE 1
 #define AU8522_SUSPEND_MODE 2
 
+enum au8522_media_pads {
+	AU8522_PAD_INPUT,
+	AU8522_PAD_VID_OUT,
+	AU8522_PAD_VBI_OUT,
+
+	AU8522_NUM_PADS
+};
+
 struct au8522_state {
 	struct i2c_client *c;
 	struct i2c_adapter *i2c;
@@ -68,6 +76,10 @@ struct au8522_state {
 	u32 id;
 	u32 rev;
 	struct v4l2_ctrl_handler hdl;
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_pad pads[AU8522_NUM_PADS];
+#endif
 };
 
 /* These are routines shared by both the VSB/QAM demodulator and the analog
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 4d8e01c7b1b2..f51484097f8b 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -443,6 +443,7 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
 
 	BUG_ON(source == NULL || sink == NULL);
 	BUG_ON(source_pad >= source->num_pads);
+printk("sink pad: %d/%d\n", sink_pad, sink->num_pads);
 	BUG_ON(sink_pad >= sink->num_pads);
 
 	link = media_entity_add_link(source);
diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index edc27355f271..6b469e8c4c6e 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -195,8 +195,6 @@ void au0828_card_setup(struct au0828_dev *dev)
 
 	dprintk(1, "%s()\n", __func__);
 
-	dev->board = au0828_boards[dev->boardnr];
-
 	if (dev->i2c_rc == 0) {
 		dev->i2c_client.addr = 0xa0 >> 1;
 		tveeprom_read(&dev->i2c_client, eeprom, sizeof(eeprom));
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 082ae6ba492f..06d7778c489a 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -127,8 +127,23 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
 	return status;
 }
 
+static void au0828_unregister_media_device(struct au0828_dev *dev)
+{
+printk("au0828: Iniciating media-device unregister\n");
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (dev->media_dev) {
+		media_device_unregister(dev->media_dev);
+		kfree(dev->media_dev);
+		dev->media_dev = NULL;
+	}
+#endif
+}
+
 static void au0828_usb_release(struct au0828_dev *dev)
 {
+	au0828_unregister_media_device(dev);
+
 	/* I2C */
 	au0828_i2c_unregister(dev);
 
@@ -161,6 +176,8 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	*/
 	dev->dev_state = DEV_DISCONNECTED;
 
+	au0828_unregister_media_device(dev);
+
 	au0828_rc_unregister(dev);
 	/* Digital TV */
 	au0828_dvb_unregister(dev);
@@ -180,6 +197,85 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	au0828_usb_release(dev);
 }
 
+static void au0828_media_device_register(struct au0828_dev *dev,
+					  struct usb_device *udev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev;
+	int ret;
+
+printk("au0828:Iniciating media-device register\n");
+
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return;
+
+	mdev->dev = &udev->dev;
+
+	if (!dev->board.name)
+		strlcpy(mdev->model, "unknown au0828", sizeof(mdev->model));
+	else
+		strlcpy(mdev->model, dev->board.name, sizeof(mdev->model));
+	if (udev->serial)
+		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
+	strcpy(mdev->bus_info, udev->devpath);
+	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+	mdev->driver_version = LINUX_VERSION_CODE;
+
+	ret = media_device_register(mdev);
+	if (ret) {
+		pr_err(
+			"Couldn't create a media device. Error: %d\n",
+			ret);
+		kfree(mdev);
+		return;
+	}
+
+	dev->media_dev = mdev;
+#endif
+}
+
+
+static void au0828_create_media_graph(struct au0828_dev *dev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev = dev->media_dev;
+	struct media_entity *entity;
+	struct media_entity *tuner = NULL, *decoder = NULL;
+
+printk("au0828:Iniciating media-device graph creation\n");
+
+	if (!mdev)
+		return;
+
+	media_device_for_each_entity(entity, mdev) {
+		switch (entity->type) {
+		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
+			tuner = entity;
+			break;
+		case MEDIA_ENT_T_V4L2_SUBDEV_DECODER:
+			decoder = entity;
+			break;
+		}
+	}
+
+	/* Analog setup, using tuner as a link */
+
+	if (!decoder)
+		return;
+
+	if (tuner)
+		media_entity_create_link(tuner, 0, decoder, 0,
+					 MEDIA_LNK_FL_ENABLED);
+	if (dev->vdev.entity.links)
+		media_entity_create_link(decoder, 1, &dev->vdev.entity, 0,
+				 MEDIA_LNK_FL_ENABLED);
+	if (dev->vbi_dev.entity.links)
+		media_entity_create_link(decoder, 2, &dev->vbi_dev.entity, 0,
+				 MEDIA_LNK_FL_ENABLED);
+#endif
+}
+
 static int au0828_usb_probe(struct usb_interface *interface,
 	const struct usb_device_id *id)
 {
@@ -222,11 +318,18 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	mutex_init(&dev->dvb.lock);
 	dev->usbdev = usbdev;
 	dev->boardnr = id->driver_info;
+	dev->board = au0828_boards[dev->boardnr];
+
+	/* Register the media controller */
+	au0828_media_device_register(dev, usbdev);
 
 #ifdef CONFIG_VIDEO_AU0828_V4L2
 	dev->v4l2_dev.release = au0828_usb_v4l2_release;
 
 	/* Create the v4l2_device */
+#ifdef CONFIG_MEDIA_CONTROLLER
+	dev->v4l2_dev.mdev = dev->media_dev;
+#endif
 	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
 		pr_err("%s() v4l2_device_register failed\n",
@@ -285,6 +388,8 @@ static int au0828_usb_probe(struct usb_interface *interface,
 
 	mutex_unlock(&dev->lock);
 
+	au0828_create_media_graph(dev);
+
 	return retval;
 }
 
diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index c267d76f5b3c..c01772c4f9f0 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -415,6 +415,11 @@ static int dvb_register(struct au0828_dev *dev)
 		       result);
 		goto fail_adapter;
 	}
+
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	dvb->adapter.mdev = dev->media_dev;
+#endif
+
 	dvb->adapter.priv = dev;
 
 	/* register frontend */
@@ -480,6 +485,11 @@ static int dvb_register(struct au0828_dev *dev)
 
 	dvb->start_count = 0;
 	dvb->stop_count = 0;
+
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	dvb_create_media_graph(&dvb->adapter);
+#endif
+
 	return 0;
 
 fail_fe_conn:
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 1a362a041ab3..4ebe13673adf 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -637,6 +637,75 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 	return rc;
 }
 
+static int au0828_enable_analog_tuner(struct au0828_dev *dev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev = dev->media_dev;
+	struct media_entity  *entity, *decoder = NULL, *source;
+	struct media_link *link, *found_link = NULL;
+	int i, ret, active_links = 0;
+
+	if (!mdev)
+		return 0;
+
+	/*
+	 * This will find the tuner that is connected into the decoder.
+	 * Technically, this is not 100% correct, as the device may be
+	 * using an analog input instead of the tuner. However, as we can't
+	 * do DVB streaming while the DMA engine is being used for V4L2,
+	 * this should be enough for the actual needs.
+	 */
+	media_device_for_each_entity(entity, mdev) {
+		if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_DECODER) {
+			decoder = entity;
+			break;
+		}
+	}
+	if (!decoder)
+		return 0;
+
+	for (i = 0; i < decoder->num_links; i++) {
+		link = &decoder->links[i];
+		if (link->sink->entity == decoder) {
+			found_link = link;
+			if (link->flags & MEDIA_LNK_FL_ENABLED)
+				active_links++;
+			break;
+		}
+	}
+
+	if (active_links == 1 || !found_link)
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
+		if (sink == entity)
+			flags = MEDIA_LNK_FL_ENABLED;
+
+		ret = media_entity_setup_link(link, flags);
+		if (ret) {
+			pr_err(
+				"Couldn't change link %s->%s to %s. Error %d\n",
+				source->name, sink->name,
+				flags ? "enabled" : "disabled",
+				ret);
+			return ret;
+		} else
+			au0828_isocdbg(
+				"link %s->%s was %s\n",
+				source->name, sink->name,
+				flags ? "ENABLED" : "disabled");
+	}
+#endif
+	return 0;
+}
+
 static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
@@ -652,6 +721,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	*nplanes = 1;
 	sizes[0] = size;
 
+	au0828_enable_analog_tuner(dev);
+
 	return 0;
 }
 
@@ -1821,6 +1892,18 @@ int au0828_analog_register(struct au0828_dev *dev,
 	dev->vbi_dev.queue->lock = &dev->vb_vbi_queue_lock;
 	strcpy(dev->vbi_dev.name, "au0828a vbi");
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	dev->video_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_init(&dev->vdev.entity, 1, &dev->video_pad, 0);
+	if (ret < 0)
+		pr_err("failed to initialize video media entity!\n");
+
+	dev->vbi_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_init(&dev->vbi_dev.entity, 1, &dev->vbi_pad, 0);
+	if (ret < 0)
+		pr_err("failed to initialize vbi media entity!\n");
+#endif
+
 	/* initialize videobuf2 stuff */
 	retval = au0828_vb2_setup(dev);
 	if (retval != 0) {
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 3b480005ce3b..7e6a3bbc68ab 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -32,6 +32,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
+#include <media/media-device.h>
 
 /* DVB */
 #include "demux.h"
@@ -275,6 +276,11 @@ struct au0828_dev {
 	/* Preallocated transfer digital transfer buffers */
 
 	char *dig_transfer_buffer[URB_COUNT];
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *media_dev;
+	struct media_pad video_pad, vbi_pad;
+#endif
 };
 
 
-- 
2.1.0

