Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:40194 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbbJBWHp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2015 18:07:45 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	dan.carpenter@oracle.com, tskd08@gmail.com, arnd@arndb.de,
	ruchandani.tina@gmail.com, corbet@lwn.net, k.kozlowski@samsung.com,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	elfring@users.sourceforge.net, Julia.Lawall@lip6.fr,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, johan@oljud.se,
	wsa@the-dreams.de, jcragg@gmail.com, clemens@ladisch.de,
	daniel@zonque.org, gtmkramer@xs4all.nl, misterpib@gmail.com,
	takamichiho@gmail.com, pmatilai@laiskiainen.org,
	vladcatoi@gmail.com, damien@zamaudio.com, normalperson@yhbt.net,
	joe@oampo.co.uk, jussi@sonarnerd.net, calcprogrammer1@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen 17/20] media: au0828 change to register/unregister entity_notify hook
Date: Fri,  2 Oct 2015 16:07:29 -0600
Message-Id: <c8148c1fa875207148b4cc852c912359ad3c1e71.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

au0828 registers entity_notify hook to create media graph for
the device. This handler runs whenvere a new entity gets added
to the media device. It creates necessary links from video, vbi,
and ALSA entities to decoder and links tuner and decoder entities.
As this handler runs as entities get added, it has to maintain
state on the links it already created. New fields are added to
au0828_dev to keep this state information. entity_notify gets
unregistered before media_device unregister.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 178 ++++++++++++++++++---------------
 drivers/media/usb/au0828/au0828.h      |   6 ++
 2 files changed, 102 insertions(+), 82 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 544d304..ade89d9 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -137,6 +137,8 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (dev->media_dev &&
 	    media_devnode_is_registered(&dev->media_dev->devnode)) {
+		media_device_unregister_entity_notify(dev->media_dev,
+						      &dev->entity_notify);
 		media_device_unregister(dev->media_dev);
 		dev->media_dev = NULL;
 	}
@@ -215,52 +217,22 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	au0828_usb_release(dev);
 }
 
-static void au0828_media_device_register(struct au0828_dev *dev,
-					  struct usb_device *udev)
-{
-#ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_device *mdev;
-	int ret;
-
-	mdev = media_device_get_devres(&udev->dev);
-	if (!mdev)
-		return;
-
-	if (!media_devnode_is_registered(&mdev->devnode)) {
-		/* register media device */
-		mdev->dev = &udev->dev;
-
-		if (udev->product)
-			strlcpy(mdev->model, udev->product,
-				sizeof(mdev->model));
-		if (udev->serial)
-			strlcpy(mdev->serial, udev->serial,
-				sizeof(mdev->serial));
-		strcpy(mdev->bus_info, udev->devpath);
-		mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-		ret = media_device_register(mdev);
-		if (ret) {
-			dev_err(&udev->dev,
-				"Couldn't create a media device. Error: %d\n",
-				ret);
-			return;
-		}
-	}
-	dev->media_dev = mdev;
-#endif
-}
-
-
-static int au0828_create_media_graph(struct au0828_dev *dev)
+void au0828_create_media_graph(struct media_entity *new, void *notify_data)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
+	struct au0828_dev *dev = (struct au0828_dev *) notify_data;
 	struct media_device *mdev = dev->media_dev;
 	struct media_entity *entity;
 	struct media_entity *tuner = NULL, *decoder = NULL;
+	struct media_entity *audio_capture = NULL;
 	int i, ret;
 
 	if (!mdev)
-		return 0;
+		return;
+
+	if (dev->tuner_linked && dev->vdev_linked && dev->vbi_linked &&
+	    dev->audio_capture_linked)
+		return;
 
 	media_device_for_each_entity(entity, mdev) {
 		switch (entity->function) {
@@ -270,6 +242,9 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 		case MEDIA_ENT_F_ATV_DECODER:
 			decoder = entity;
 			break;
+		case MEDIA_ENT_F_AUDIO_CAPTURE:
+			audio_capture = entity;
+			break;
 		}
 	}
 
@@ -277,65 +252,111 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 
 	/* Something bad happened! */
 	if (!decoder)
-		return -EINVAL;
+		return;
 
-	if (tuner) {
+	if (tuner && !dev->tuner_linked) {
+		dev->tuner = tuner;
 		ret = media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT,
 					    decoder, 0,
 				            MEDIA_LNK_FL_ENABLED);
-		if (ret)
-			return ret;
+		if (ret == 0)
+			dev->tuner_linked = 1;
 	}
 
-	if (dev->vdev.entity.graph_obj.mdev) {
+	if (dev->vdev.entity.graph_obj.mdev && !dev->vdev_linked) {
 		ret = media_create_pad_link(decoder, AU8522_PAD_VID_OUT,
 					    &dev->vdev.entity, 0,
 					    MEDIA_LNK_FL_ENABLED);
-		if (ret)
-			return ret;
+		if (ret == 0)
+			dev->vdev_linked = 1;
 	}
-	if (dev->vbi_dev.entity.graph_obj.mdev) {
+
+	if (dev->vbi_dev.entity.graph_obj.mdev && !dev->vbi_linked) {
 		ret = media_create_pad_link(decoder, AU8522_PAD_VBI_OUT,
 					    &dev->vbi_dev.entity, 0,
 					    MEDIA_LNK_FL_ENABLED);
-		if (ret)
-			return ret;
-	}
+		if (ret == 0)
+			dev->vbi_linked = 1;
 
-	for (i = 0; i < AU0828_MAX_INPUT; i++) {
-		struct media_entity *ent = &dev->input_ent[i];
+		/* Input entities are registered before vbi entity */
+		for (i = 0; i < AU0828_MAX_INPUT; i++) {
+			struct media_entity *ent = &dev->input_ent[i];
 
-		if (!ent->graph_obj.mdev)
-			continue;
+			if (!ent->graph_obj.mdev)
+				continue;
 
-		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
-			break;
+			if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
+				break;
 
-		switch(AUVI_INPUT(i).type) {
-		case AU0828_VMUX_CABLE:
-		case AU0828_VMUX_TELEVISION:
-		case AU0828_VMUX_DVB:
-			if (!tuner)
+			switch (AUVI_INPUT(i).type) {
+			case AU0828_VMUX_CABLE:
+			case AU0828_VMUX_TELEVISION:
+			case AU0828_VMUX_DVB:
+				if (!tuner)
+					break;
+
+				media_create_pad_link(ent, 0, tuner,
+						      TUNER_PAD_RF_INPUT,
+						      MEDIA_LNK_FL_ENABLED);
+				break;
+			case AU0828_VMUX_COMPOSITE:
+			case AU0828_VMUX_SVIDEO:
+			default: /* AU0828_VMUX_DEBUG */
+				/* FIXME: fix the decoder PAD */
+				media_create_pad_link(ent, 0, decoder, 0, 0);
 				break;
+			}
+		}
+	}
 
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
+	if (audio_capture && !dev->audio_capture_linked) {
+		ret = media_create_pad_link(decoder, AU8522_PAD_AUDIO_OUT,
+					    audio_capture, 0,
+					    MEDIA_LNK_FL_ENABLED);
+		if (ret == 0)
+			dev->audio_capture_linked = 1;
+	}
+#endif
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
+
+		if (udev->product)
+			strlcpy(mdev->model, udev->product,
+				sizeof(mdev->model));
+		if (udev->serial)
+			strlcpy(mdev->serial, udev->serial,
+				sizeof(mdev->serial));
+		strcpy(mdev->bus_info, udev->devpath);
+		mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+		ret = media_device_register(mdev);
+		if (ret) {
+			dev_err(&udev->dev,
+				"Couldn't create a media device. Error: %d\n",
+				ret);
+			return;
 		}
 	}
+	/* register entity_notify callback */
+	dev->entity_notify.notify_data = (void *) dev;
+	dev->entity_notify.notify = au0828_create_media_graph;
+	media_device_register_entity_notify(mdev, &dev->entity_notify);
+
+	dev->media_dev = mdev;
 #endif
-	return 0;
 }
 
 static int au0828_usb_probe(struct usb_interface *interface,
@@ -450,13 +471,6 @@ static int au0828_usb_probe(struct usb_interface *interface,
 
 	mutex_unlock(&dev->lock);
 
-	retval = au0828_create_media_graph(dev);
-	if (retval) {
-		pr_err("%s() au0282_dev_register failed to create graph\n",
-		       __func__);
-		au0828_usb_disconnect(interface);
-	}
-
 	return retval;
 }
 
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index b7940c5..3874906f 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -282,6 +282,12 @@ struct au0828_dev {
 	struct media_entity *decoder;
 	struct media_entity input_ent[AU0828_MAX_INPUT];
 	struct media_pad input_pad[AU0828_MAX_INPUT];
+	struct media_entity_notify entity_notify;
+	struct media_entity *tuner;
+	bool tuner_linked;
+	bool vdev_linked;
+	bool vbi_linked;
+	bool audio_capture_linked;
 #endif
 };
 
-- 
2.1.4

