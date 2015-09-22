Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:38744 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758373AbbIVR2J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 13:28:09 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	stefanr@s5r6.in-berlin.de, crope@iki.fi, dan.carpenter@oracle.com,
	tskd08@gmail.com, ruchandani.tina@gmail.com, arnd@arndb.de,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	Julia.Lawall@lip6.fr, elfring@users.sourceforge.net,
	ricardo.ribalda@gmail.com, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, misterpib@gmail.com, takamichiho@gmail.com,
	pmatilai@laiskiainen.org, damien@zamaudio.com, daniel@zonque.org,
	vladcatoi@gmail.com, normalperson@yhbt.net, joe@oampo.co.uk,
	bugzilla.frnkcg@spamgourmet.com, jussi@sonarnerd.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 18/21] media: au0828 change to register/unregister entity_notify hook
Date: Tue, 22 Sep 2015 11:19:37 -0600
Message-Id: <97aae533bbc9eaca337b3e326611151cae49c33c.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
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
 drivers/media/usb/au0828/au0828-core.c | 118 +++++++++++++++++++++------------
 drivers/media/usb/au0828/au0828.h      |   6 ++
 2 files changed, 81 insertions(+), 43 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 63e31e2..fcff2e2 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -134,6 +134,8 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (dev->media_dev &&
 	    media_devnode_is_registered(&dev->media_dev->devnode)) {
+		media_device_unregister_entity_notify(dev->media_dev,
+						      &dev->entity_notify);
 		media_device_unregister(dev->media_dev);
 		dev->media_dev = NULL;
 	}
@@ -197,6 +199,75 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	au0828_usb_release(dev);
 }
 
+static void au0828_create_media_graph(struct media_entity *new,
+				      void *notify_data)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct au0828_dev *dev = (struct au0828_dev *) notify_data;
+	struct media_device *mdev = dev->media_dev;
+	struct media_entity *entity, *tuner = NULL, *decoder = NULL;
+	struct media_entity *alsa_capture = NULL;
+	int ret;
+
+	if (!mdev)
+		return;
+
+	if (dev->tuner_linked && dev->vdev_linked && dev->vbi_linked &&
+	    dev->alsa_capture_linked)
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
+		case MEDIA_ENT_T_DEVNODE_ALSA_CAPTURE:
+			alsa_capture = entity;
+			break;
+		}
+	}
+
+	if (!decoder)
+		return;
+
+	/* save tuner for using in enable_source disable_source handlers
+	 * avoid graph walk in those handlers. Note that decoder is
+	 * saved during v4l2_dev registration */
+
+	if (tuner && !dev->tuner_linked) {
+		dev->tuner = tuner;
+		ret = media_entity_create_link(tuner, 0, decoder, 0,
+					       MEDIA_LNK_FL_ENABLED);
+		if (ret == 0)
+			dev->tuner_linked = 1;
+	}
+	if (dev->vdev.entity.parent && !dev->vdev_linked) {
+		ret = media_entity_create_link(decoder, AU8522_PAD_VID_OUT,
+					       &dev->vdev.entity, 0,
+					       MEDIA_LNK_FL_ENABLED);
+		if (ret == 0)
+			dev->vdev_linked = 1;
+	}
+	if (dev->vbi_dev.entity.parent && !dev->vbi_linked) {
+		ret = media_entity_create_link(decoder, AU8522_PAD_VBI_OUT,
+					       &dev->vbi_dev.entity, 0,
+					       MEDIA_LNK_FL_ENABLED);
+		if (ret == 0)
+			dev->vbi_linked = 1;
+	}
+	if (alsa_capture && !dev->alsa_capture_linked) {
+		ret = media_entity_create_link(decoder, AU8522_PAD_AUDIO_OUT,
+					       alsa_capture, 0,
+					       MEDIA_LNK_FL_ENABLED);
+		if (ret == 0)
+			dev->alsa_capture_linked = 1;
+	}
+#endif
+}
+
 static void au0828_media_device_register(struct au0828_dev *dev,
 					  struct usb_device *udev)
 {
@@ -227,52 +298,15 @@ static void au0828_media_device_register(struct au0828_dev *dev,
 				ret);
 			return;
 		}
+		/* register entity_notify callback */
+		dev->entity_notify.notify_data = (void *) dev;
+		dev->entity_notify.notify = au0828_create_media_graph;
+		media_device_register_entity_notify(mdev, &dev->entity_notify);
 	}
 	dev->media_dev = mdev;
 #endif
 }
 
-
-static void au0828_create_media_graph(struct au0828_dev *dev)
-{
-#ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_device *mdev = dev->media_dev;
-	struct media_entity *entity;
-	struct media_entity *tuner = NULL, *decoder = NULL;
-
-	if (!mdev)
-		return;
-
-	media_device_for_each_entity(entity, mdev) {
-		switch (entity->type) {
-		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
-			tuner = entity;
-			break;
-		case MEDIA_ENT_T_V4L2_SUBDEV_DECODER:
-			decoder = entity;
-			break;
-		}
-	}
-
-	/* Analog setup, using tuner as a link */
-
-	if (!decoder)
-		return;
-
-	if (tuner)
-		media_entity_create_link(tuner, 0, decoder, 0,
-					 MEDIA_LNK_FL_ENABLED);
-	if (dev->vdev.entity.parent)
-		media_entity_create_link(decoder, AU8522_PAD_VID_OUT,
-					 &dev->vdev.entity, 0,
-					 MEDIA_LNK_FL_ENABLED);
-	if (dev->vbi_dev.entity.parent)
-		media_entity_create_link(decoder, AU8522_PAD_VBI_OUT,
-					 &dev->vbi_dev.entity, 0,
-					 MEDIA_LNK_FL_ENABLED);
-#endif
-}
-
 static int au0828_usb_probe(struct usb_interface *interface,
 	const struct usb_device_id *id)
 {
@@ -385,8 +419,6 @@ static int au0828_usb_probe(struct usb_interface *interface,
 
 	mutex_unlock(&dev->lock);
 
-	au0828_create_media_graph(dev);
-
 	return retval;
 }
 
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index d3644b3..08cc7b8 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -281,6 +281,12 @@ struct au0828_dev {
 	struct media_device *media_dev;
 	struct media_pad video_pad, vbi_pad;
 	struct media_entity *decoder;
+	struct media_entity *tuner;
+	struct media_entity_notify entity_notify;
+	bool tuner_linked;
+	bool vdev_linked;
+	bool vbi_linked;
+	bool alsa_capture_linked;
 #endif
 };
 
-- 
2.1.4

