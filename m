Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:56250 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758366AbbIVR2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 13:28:07 -0400
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
Subject: [PATCH v3 19/21] media: au0828 implement enable_source and disable_source handlers
Date: Tue, 22 Sep 2015 11:19:38 -0600
Message-Id: <3853ee1a38b4b2989386fff0c745a75cd56ef103.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implements enable_source and disable_source handlers for other
drivers (v4l2-core, dvb-core, and ALSA) to use to check for
tuner connected to the decoder and activate the link if tuner
is free, and deactivate and free the tuner when it is no longer
needed.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 169 +++++++++++++++++++++++++++++++++
 drivers/media/usb/au0828/au0828.h      |   2 +
 2 files changed, 171 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index fcff2e2..ce9d5d4 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -268,6 +268,164 @@ static void au0828_create_media_graph(struct media_entity *new,
 #endif
 }
 
+static int au0828_enable_source(struct media_entity *entity,
+				struct media_pipeline *pipe)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_entity  *source;
+	struct media_entity *sink;
+	struct media_link *link, *found_link = NULL;
+	int i, ret = 0;
+	struct media_device *mdev = entity->parent;
+	struct au0828_dev *dev;
+
+	if (!mdev)
+		return -ENODEV;
+
+	/* for ALSA and Video entities, source is the decoder */
+	mutex_lock(&mdev->graph_mutex);
+
+	dev = mdev->source_priv;
+	if (!dev->tuner || !dev->decoder) {
+		ret = -ENODEV;
+		goto end;
+	}
+
+	/*
+	 * For ALSA and V4L2 entity, find the link to which decoder
+	 * is the sink. Look for an active link between decoder and
+	 * tuner, if one exists, nothing to do. If not, look for any
+	 * active links between tuner and any other entity. If one
+	 * exists, tuner is busy. If tuner is free, setup link and
+	 * start pipeline from source (tuner).
+	 * For DVB FE entity, the source for the link is the tuner.
+	 * Check if tuner is available and setup link and start
+	 * pipeline.
+	*/
+	if (entity->type != MEDIA_ENT_T_DEVNODE_DVB_FE)
+		sink = dev->decoder;
+	else
+		sink = entity;
+
+	/* Is an active link between sink and tuner */
+	if (dev->active_link) {
+		if (dev->active_link->sink->entity == sink &&
+		    dev->active_link->source->entity == dev->tuner) {
+			ret = 0;
+			goto end;
+		} else {
+			ret = -EBUSY;
+			goto end;
+		}
+	}
+
+	for (i = 0; i < sink->num_links; i++) {
+		link = &sink->links[i];
+		/* Used to check just the sink, check source too - works?? */
+		if (link->sink->entity == sink &&
+		    link->source->entity == dev->tuner) {
+			found_link = link;
+			break;
+		}
+	}
+
+	if (!found_link) {
+		ret = -ENODEV;
+		goto end;
+	}
+
+	source = found_link->source->entity;
+	for (i = 0; i < source->num_links; i++) {
+		struct media_entity *find_sink;
+		int flags = 0;
+
+		link = &source->links[i];
+		find_sink = link->sink->entity;
+
+		if (find_sink == sink)
+			flags = MEDIA_LNK_FL_ENABLED;
+
+		ret = __media_entity_setup_link(link, flags);
+		if (ret) {
+			pr_err(
+				"Change tuner link %s->%s to %s. Error %d\n",
+				source->name, find_sink->name,
+				flags ? "enabled" : "disabled",
+				ret);
+			goto end;
+		}
+		/* start pipeline */
+		if (find_sink == sink) {
+			dev->active_link = link;
+			ret = __media_entity_pipeline_start(entity, pipe);
+			if (ret) {
+				pr_err("Start Pipeline: %s->%s Error %d\n",
+					source->name, entity->name, ret);
+				goto end;
+			}
+			/* save link owner to avoid audio deactivating
+			   video owned link from disable_source and
+			   vice versa */
+			dev->active_link_owner = entity;
+			pr_info("Started Pipeline: %s->%s ret %d\n",
+				source->name, entity->name, ret);
+		}
+	}
+end:
+	mutex_unlock(&mdev->graph_mutex);
+	return ret;
+#endif
+	return 0;
+}
+
+static void au0828_disable_source(struct media_entity *entity)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_entity *sink;
+	int ret = 0;
+	struct media_device *mdev = entity->parent;
+	struct au0828_dev *dev;
+
+	if (!mdev)
+		return;
+
+	mutex_lock(&mdev->graph_mutex);
+
+	dev = mdev->source_priv;
+	if (!dev->tuner || !dev->decoder || !dev->active_link) {
+		ret = -ENODEV;
+		goto end;
+	}
+
+	if (entity->type != MEDIA_ENT_T_DEVNODE_DVB_FE)
+		sink = dev->decoder;
+	else
+		sink = entity;
+
+	/* link is active - stop pipeline from source (tuner) */
+	if (dev->active_link && dev->active_link->sink->entity == sink &&
+	    dev->active_link->source->entity == dev->tuner) {
+		/* prevent video from deactivating link when audio
+		   has active pipeline */
+		if (dev->active_link_owner != entity)
+			goto end;
+		__media_entity_pipeline_stop(entity);
+		pr_info("Stopped Pipeline: %s->%s entity %s\n",
+			dev->active_link->source->entity->name,
+			dev->active_link->sink->entity->name,
+			entity->name);
+		ret = __media_entity_setup_link(dev->active_link, 0);
+		if (ret)
+			pr_err("Deactive link Error %d\n", ret);
+		dev->active_link = NULL;
+		dev->active_link_owner = NULL;
+	}
+
+end:
+	mutex_unlock(&mdev->graph_mutex);
+#endif
+}
+
 static void au0828_media_device_register(struct au0828_dev *dev,
 					  struct usb_device *udev)
 {
@@ -291,6 +449,10 @@ static void au0828_media_device_register(struct au0828_dev *dev,
 				sizeof(mdev->serial));
 		strcpy(mdev->bus_info, udev->devpath);
 		mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+		/* Set enable_source and disable_source handlers and data */
+		mdev->source_priv = (void *) dev;
+		mdev->enable_source = au0828_enable_source;
+		mdev->disable_source = au0828_disable_source;
 		ret = media_device_register(mdev);
 		if (ret) {
 			dev_err(&udev->dev,
@@ -303,6 +465,13 @@ static void au0828_media_device_register(struct au0828_dev *dev,
 		dev->entity_notify.notify = au0828_create_media_graph;
 		media_device_register_entity_notify(mdev, &dev->entity_notify);
 	}
+	/* If ALSA registered the media device - set enable_source */
+	if (!mdev->enable_source) {
+		/* Set enable_source and disable_source handlers and data */
+		mdev->source_priv = (void *) dev;
+		mdev->enable_source = au0828_enable_source;
+		mdev->disable_source = au0828_disable_source;
+	}
 	dev->media_dev = mdev;
 #endif
 }
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 08cc7b8..f64dbbb 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -287,6 +287,8 @@ struct au0828_dev {
 	bool vdev_linked;
 	bool vbi_linked;
 	bool alsa_capture_linked;
+	struct media_link *active_link;
+	struct media_entity *active_link_owner;
 #endif
 };
 
-- 
2.1.4

