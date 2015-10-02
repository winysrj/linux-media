Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:36544 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbbJBWHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2015 18:07:46 -0400
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
Subject: [PATCH MC Next Gen 18/20] media: au0828 implement enable_source and disable_source handlers
Date: Fri,  2 Oct 2015 16:07:30 -0600
Message-Id: <5f3004783b21f44d93ae0f12ff7f53f1f0c61107.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implements enable_source and disable_source handlers for other
drivers (v4l2-core, dvb-core, and ALSA) to use to check for
tuner connected to the decoder and activate the link if tuner
is free, and deactivate and free the tuner when it is no longer
needed.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 149 ++++++++++++++++++++++++++++++++-
 drivers/media/usb/au0828/au0828.h      |   2 +
 2 files changed, 149 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index ade89d9..7af5d0d 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -256,9 +256,9 @@ void au0828_create_media_graph(struct media_entity *new, void *notify_data)
 
 	if (tuner && !dev->tuner_linked) {
 		dev->tuner = tuner;
+		/* create tuner to decoder link in deactivated state */
 		ret = media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT,
-					    decoder, 0,
-				            MEDIA_LNK_FL_ENABLED);
+					    decoder, 0, 0);
 		if (ret == 0)
 			dev->tuner_linked = 1;
 	}
@@ -319,6 +319,146 @@ void au0828_create_media_graph(struct media_entity *new, void *notify_data)
 #endif
 }
 
+static int au0828_enable_source(struct media_entity *entity,
+				struct media_pipeline *pipe)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_entity  *source;
+	struct media_entity *sink;
+	struct media_link *link, *found_link = NULL;
+	int ret = 0;
+	struct media_device *mdev = entity->graph_obj.mdev;
+	struct au0828_dev *dev;
+
+	if (!mdev)
+		return -ENODEV;
+
+	/* for Audio and Video entities, source is the decoder */
+	mutex_lock(&mdev->graph_mutex);
+
+	dev = mdev->source_priv;
+	if (!dev->tuner || !dev->decoder) {
+		ret = -ENODEV;
+		goto end;
+	}
+
+	/*
+	 * For Audio and V4L2 entity, find the link to which decoder
+	 * is the sink. Look for an active link between decoder and
+	 * tuner, if one exists, nothing to do. If not, look for any
+	 * active links between tuner and any other entity. If one
+	 * exists, tuner is busy. If tuner is free, setup link and
+	 * start pipeline from source (tuner).
+	 * For DVB FE entity, the source for the link is the tuner.
+	 * Check if tuner is available and setup link and start
+	 * pipeline.
+	*/
+	if (entity->function != MEDIA_ENT_F_DTV_DEMOD)
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
+	list_for_each_entry(link, &sink->links, list) {
+		/* Check sink, and source */
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
+	/* activate link between source and sink and start pipeline */
+	source = found_link->source->entity;
+	ret = __media_entity_setup_link(found_link, MEDIA_LNK_FL_ENABLED);
+	if (ret) {
+		pr_err(
+			"Activate tuner link %s->%s. Error %d\n",
+			source->name, sink->name, ret);
+		goto end;
+	}
+
+	ret = __media_entity_pipeline_start(entity, pipe);
+	if (ret) {
+		pr_err("Start Pipeline: %s->%s Error %d\n",
+			source->name, entity->name, ret);
+		ret = __media_entity_setup_link(found_link, 0);
+		pr_err("Deactive link Error %d\n", ret);
+		goto end;
+	}
+	/* save active link and active link owner to avoid audio
+	   deactivating video owned link from disable_source and
+	   vice versa */
+	dev->active_link = found_link;
+	dev->active_link_owner = entity;
+end:
+	mutex_unlock(&mdev->graph_mutex);
+	pr_debug("au0828_enable_source() end %s %d %d\n",
+		entity->name, entity->function, ret);
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
+	struct media_device *mdev = entity->graph_obj.mdev;
+	struct au0828_dev *dev;
+
+	if (!mdev)
+		return;
+
+	mutex_lock(&mdev->graph_mutex);
+	dev = mdev->source_priv;
+	if (!dev->tuner || !dev->decoder || !dev->active_link) {
+		ret = -ENODEV;
+		goto end;
+	}
+
+	if (entity->function != MEDIA_ENT_F_DTV_DEMOD)
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
@@ -355,6 +495,11 @@ static void au0828_media_device_register(struct au0828_dev *dev,
 	dev->entity_notify.notify = au0828_create_media_graph;
 	media_device_register_entity_notify(mdev, &dev->entity_notify);
 
+	/* set enable_source */
+	mdev->source_priv = (void *) dev;
+	mdev->enable_source = au0828_enable_source;
+	mdev->disable_source = au0828_disable_source;
+
 	dev->media_dev = mdev;
 #endif
 }
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 3874906f..2f4d597 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -288,6 +288,8 @@ struct au0828_dev {
 	bool vdev_linked;
 	bool vbi_linked;
 	bool audio_capture_linked;
+	struct media_link *active_link;
+	struct media_entity *active_link_owner;
 #endif
 };
 
-- 
2.1.4

