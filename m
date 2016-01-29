Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42481 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbcA2MMP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 07:12:15 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 13/13] [media] em28xx: add media controller support
Date: Fri, 29 Jan 2016 10:11:03 -0200
Message-Id: <f9e889dcc0611e79f1b21605d1da383ea91dcad0.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the needed bits to make em28xx to create a media
controller graph.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |  55 ++++++-
 drivers/media/usb/em28xx/em28xx-dvb.c   |  10 ++
 drivers/media/usb/em28xx/em28xx-video.c | 271 +++++++++++++++++++++++++++++++-
 drivers/media/usb/em28xx/em28xx.h       |  13 +-
 4 files changed, 339 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index ab0fe0319991..dfc83c716a0b 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3012,6 +3012,48 @@ static void flush_request_modules(struct em28xx *dev)
 	flush_work(&dev->request_module_wk);
 }
 
+static int em28xx_media_device_init(struct em28xx *dev,
+				    struct usb_device *udev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev;
+
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return -ENOMEM;
+
+	mdev->dev = &udev->dev;
+
+	if (!dev->name)
+		strlcpy(mdev->model, "unknown em28xx", sizeof(mdev->model));
+	else
+		strlcpy(mdev->model, dev->name, sizeof(mdev->model));
+	if (udev->serial)
+		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
+	strcpy(mdev->bus_info, udev->devpath);
+	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+	mdev->driver_version = LINUX_VERSION_CODE;
+
+	media_device_init(mdev);
+
+	dev->media_dev = mdev;
+#endif
+	return 0;
+}
+
+static void em28xx_unregister_media_device(struct em28xx *dev)
+{
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (dev->media_dev) {
+		media_device_unregister(dev->media_dev);
+		media_device_cleanup(dev->media_dev);
+		kfree(dev->media_dev);
+		dev->media_dev = NULL;
+	}
+#endif
+}
+
 /*
  * em28xx_release_resources()
  * unregisters the v4l2,i2c and usb devices
@@ -3023,6 +3065,8 @@ static void em28xx_release_resources(struct em28xx *dev)
 
 	mutex_lock(&dev->lock);
 
+	em28xx_unregister_media_device(dev);
+
 	if (dev->def_i2c_bus)
 		em28xx_i2c_unregister(dev, 1);
 	em28xx_i2c_unregister(dev, 0);
@@ -3167,6 +3211,8 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	 */
 	snprintf(dev->name, sizeof(dev->name), "%s #%d", chip_name, dev->devno);
 
+	em28xx_media_device_init(dev, udev);
+
 	if (dev->is_audio_only) {
 		retval = em28xx_audio_setup(dev);
 		if (retval)
@@ -3501,9 +3547,14 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 	request_modules(dev);
 
-	/* Should be the last thing to do, to avoid newer udev's to
-	   open the device before fully initializing it
+	/*
+	 * Do it at the end, to reduce dynamic configuration changes during
+	 * the device init. Yet, as request_modules() can be async, the
+	 * topology will likely change after the load of the em28xx subdrivers.
 	 */
+#ifdef CONFIG_MEDIA_CONTROLLER
+	retval = media_device_register(dev->media_dev);
+#endif
 
 	return 0;
 
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index bf5c24467c65..ea80541d58f0 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -916,6 +916,9 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 		       dev->name, result);
 		goto fail_adapter;
 	}
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	dvb->adapter.mdev = dev->media_dev;
+#endif
 
 	/* Ensure all frontends negotiate bus access */
 	dvb->fe[0]->ops.ts_bus_ctrl = em28xx_dvb_bus_ctrl;
@@ -994,8 +997,15 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 
 	/* register network adapter */
 	dvb_net_init(&dvb->adapter, &dvb->net, &dvb->demux.dmx);
+
+	result = dvb_create_media_graph(&dvb->adapter, false);
+	if (result < 0)
+		goto fail_create_graph;
+
 	return 0;
 
+fail_create_graph:
+	dvb_net_release(&dvb->net);
 fail_fe_conn:
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
 fail_fe_mem:
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 52428b4cce5f..b3dcf990fe9d 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -866,6 +866,253 @@ static void res_free(struct em28xx *dev, enum v4l2_buf_type f_type)
 	em28xx_videodbg("res: put %d\n", res_type);
 }
 
+static void em28xx_v4l2_media_release(struct em28xx *dev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	int i;
+
+	for (i = 0; i < MAX_EM28XX_INPUT; i++) {
+		if (!INPUT(i)->type)
+			return;
+		media_device_unregister_entity(&dev->input_ent[i]);
+	}
+#endif
+}
+
+/*
+ * Media Controller helper functions
+ */
+
+static int em28xx_v4l2_create_media_graph(struct em28xx *dev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+	struct media_device *mdev = dev->media_dev;
+	struct media_entity *entity;
+	struct media_entity *if_vid = NULL, *if_aud = NULL;
+	struct media_entity *tuner = NULL, *decoder = NULL;
+	int i, ret;
+
+	if (!mdev)
+		return 0;
+
+	media_device_for_each_entity(entity, mdev) {
+		switch (entity->function) {
+		case MEDIA_ENT_F_IF_VID_DECODER:
+			if_vid = entity;
+			break;
+		case MEDIA_ENT_F_IF_AUD_DECODER:
+			if_aud = entity;
+			break;
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
+		if (if_vid) {
+			ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
+						    if_vid,
+						    IF_VID_DEC_PAD_IF_INPUT,
+						    MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				return ret;
+			ret = media_create_pad_link(if_vid, IF_VID_DEC_PAD_OUT,
+						decoder, DEMOD_PAD_IF_INPUT,
+						MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				return ret;
+		} else {
+			ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
+						decoder, DEMOD_PAD_IF_INPUT,
+						MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				return ret;
+		}
+
+		if (if_aud) {
+			ret = media_create_pad_link(tuner, TUNER_PAD_AUD_OUT,
+						    if_aud,
+						    IF_AUD_DEC_PAD_IF_INPUT,
+						    MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				return ret;
+		} else {
+			if_aud = tuner;
+		}
+
+	}
+	ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT, &v4l2->vdev.entity, 0,
+				    MEDIA_LNK_FL_ENABLED);
+	if (ret)
+		return ret;
+
+	if (em28xx_vbi_supported(dev)) {
+		ret = media_create_pad_link(decoder, DEMOD_PAD_VBI_OUT, &v4l2->vbi_dev.entity, 0,
+					MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0; i < MAX_EM28XX_INPUT; i++) {
+		struct media_entity *ent = &dev->input_ent[i];
+
+		if (!INPUT(i)->type)
+			break;
+
+		switch (INPUT(i)->type) {
+		case EM28XX_VMUX_COMPOSITE:
+		case EM28XX_VMUX_SVIDEO:
+			ret = media_create_pad_link(ent, 0, decoder,
+						    DEMOD_PAD_IF_INPUT, 0);
+			if (ret)
+				return ret;
+			break;
+		default: /* EM28XX_VMUX_TELEVISION or EM28XX_RADIO */
+			if (!tuner)
+				break;
+
+			ret = media_create_pad_link(ent, 0, tuner,
+						    TUNER_PAD_RF_INPUT,
+						    MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				return ret;
+			break;
+		}
+	}
+#endif
+	return 0;
+}
+
+static int em28xx_enable_analog_tuner(struct em28xx *dev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev = dev->media_dev;
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+	struct media_entity *source;
+	struct media_link *link, *found_link = NULL;
+	int ret, active_links = 0;
+
+	if (!mdev || !v4l2->decoder)
+		return 0;
+
+	/*
+	 * This will find the tuner that is connected into the decoder.
+	 * Technically, this is not 100% correct, as the device may be
+	 * using an analog input instead of the tuner. However, as we can't
+	 * do DVB streaming while the DMA engine is being used for V4L2,
+	 * this should be enough for the actual needs.
+	 */
+	list_for_each_entry(link, &v4l2->decoder->links, list) {
+		if (link->sink->entity == v4l2->decoder) {
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
+	list_for_each_entry(link, &source->links, list) {
+		struct media_entity *sink;
+		int flags = 0;
+
+		sink = link->sink->entity;
+
+		if (sink == v4l2->decoder)
+			flags = MEDIA_LNK_FL_ENABLED;
+
+		ret = media_entity_setup_link(link, flags);
+		if (ret) {
+			pr_err("Couldn't change link %s->%s to %s. Error %d\n",
+			       source->name, sink->name,
+			       flags ? "enabled" : "disabled",
+			       ret);
+			return ret;
+		} else
+			em28xx_videodbg("link %s->%s was %s\n",
+					source->name, sink->name,
+					flags ? "ENABLED" : "disabled");
+	}
+#endif
+	return 0;
+}
+
+static const char * const iname[] = {
+	[EM28XX_VMUX_COMPOSITE]  = "Composite",
+	[EM28XX_VMUX_SVIDEO]     = "S-Video",
+	[EM28XX_VMUX_TELEVISION] = "Television",
+	[EM28XX_RADIO]           = "Radio",
+};
+
+static void em28xx_v4l2_create_entities(struct em28xx *dev)
+{
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+	int ret, i;
+
+	/* Initialize Video, VBI and Radio pads */
+	v4l2->video_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_pads_init(&v4l2->vdev.entity, 1, &v4l2->video_pad);
+	if (ret < 0)
+		pr_err("failed to initialize video media entity!\n");
+
+	if (em28xx_vbi_supported(dev)) {
+		v4l2->vbi_pad.flags = MEDIA_PAD_FL_SINK;
+		ret = media_entity_pads_init(&v4l2->vbi_dev.entity, 1,
+					     &v4l2->vbi_pad);
+		if (ret < 0)
+			pr_err("failed to initialize vbi media entity!\n");
+	}
+
+	/* Create entities for each input connector */
+	for (i = 0; i < MAX_EM28XX_INPUT; i++) {
+		struct media_entity *ent = &dev->input_ent[i];
+
+		if (!INPUT(i)->type)
+			break;
+
+		ent->name = iname[INPUT(i)->type];
+		ent->flags = MEDIA_ENT_FL_CONNECTOR;
+		dev->input_pad[i].flags = MEDIA_PAD_FL_SOURCE;
+
+		switch (INPUT(i)->type) {
+		case EM28XX_VMUX_COMPOSITE:
+			ent->function = MEDIA_ENT_F_CONN_COMPOSITE;
+			break;
+		case EM28XX_VMUX_SVIDEO:
+			ent->function = MEDIA_ENT_F_CONN_SVIDEO;
+			break;
+		default: /* EM28XX_VMUX_TELEVISION or EM28XX_RADIO */
+			ent->function = MEDIA_ENT_F_CONN_RF;
+			break;
+		}
+
+		ret = media_entity_pads_init(ent, 1, &dev->input_pad[i]);
+		if (ret < 0)
+			pr_err("failed to initialize input pad[%d]!\n", i);
+
+		ret = media_device_register_entity(dev->media_dev, ent);
+		if (ret < 0)
+			pr_err("failed to register input entity %d!\n", i);
+	}
+#endif
+}
+
+
 /* ------------------------------------------------------------------
 	Videobuf2 operations
    ------------------------------------------------------------------*/
@@ -883,6 +1130,9 @@ static int queue_setup(struct vb2_queue *vq,
 		return sizes[0] < size ? -EINVAL : 0;
 	*nplanes = 1;
 	sizes[0] = size;
+
+	em28xx_enable_analog_tuner(dev);
+
 	return 0;
 }
 
@@ -1442,13 +1692,6 @@ static int vidioc_s_parm(struct file *file, void *priv,
 					  0, video, s_parm, p);
 }
 
-static const char * const iname[] = {
-	[EM28XX_VMUX_COMPOSITE]	 = "Composite",
-	[EM28XX_VMUX_SVIDEO]	 = "S-Video",
-	[EM28XX_VMUX_TELEVISION] = "Television",
-	[EM28XX_RADIO]		 = "Radio",
-};
-
 static int vidioc_enum_input(struct file *file, void *priv,
 			     struct v4l2_input *i)
 {
@@ -1963,6 +2206,8 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 
 	em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
 
+	em28xx_v4l2_media_release(dev);
+
 	if (video_is_registered(&v4l2->radio_dev)) {
 		em28xx_info("V4L2 device %s deregistered\n",
 			    video_device_node_name(&v4l2->radio_dev));
@@ -2286,6 +2531,9 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	v4l2->dev = dev;
 	dev->v4l2 = v4l2;
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	v4l2->v4l2_dev.mdev = dev->media_dev;
+#endif
 	ret = v4l2_device_register(&dev->udev->dev, &v4l2->v4l2_dev);
 	if (ret < 0) {
 		em28xx_errdev("Call to v4l2_device_register() failed!\n");
@@ -2568,6 +2816,15 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* Save some power by putting tuner to sleep */
 	v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_power, 0);
 
+	/* Init entities at the Media Controller */
+	em28xx_v4l2_create_entities(dev);
+
+	ret = em28xx_v4l2_create_media_graph(dev);
+	if (ret) {
+		em28xx_errdev("failed to create graph\n");
+		goto unregister_dev;
+	}
+
 	/* initialize videobuf2 stuff */
 	em28xx_vb2_setup(dev);
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index b23bf6a64011..267444961775 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -26,7 +26,7 @@
 #ifndef _EM28XX_H
 #define _EM28XX_H
 
-#define EM28XX_VERSION "0.2.1"
+#define EM28XX_VERSION "0.2.2"
 #define DRIVER_DESC    "Empia em28xx device driver"
 
 #include <linux/workqueue.h>
@@ -552,6 +552,11 @@ struct em28xx_v4l2 {
 	bool top_field;
 	int vbi_read;
 	unsigned int field_count;
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_pad video_pad, vbi_pad;
+	struct media_entity *decoder;
+#endif
 };
 
 struct em28xx_audio {
@@ -712,6 +717,12 @@ struct em28xx {
 	/* Snapshot button input device */
 	char snapshot_button_path[30];	/* path of the input dev */
 	struct input_dev *sbutton_input_dev;
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *media_dev;
+	struct media_entity input_ent[MAX_EM28XX_INPUT];
+	struct media_pad input_pad[MAX_EM28XX_INPUT];
+#endif
 };
 
 #define kref_to_dev(d) container_of(d, struct em28xx, ref)
-- 
2.5.0


