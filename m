Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:36241 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbcBKXma (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 18:42:30 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com,
	tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com,
	corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com,
	stefanr@s5r6.in-berlin.de, inki.dae@samsung.com,
	jh1009.sung@samsung.com, elfring@users.sourceforge.net,
	prabhakar.csengg@gmail.com, sw0312.kim@samsung.com,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com,
	ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com,
	dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org,
	gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk,
	linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com,
	nenggun.kim@samsung.com, j.anaszewski@samsung.com,
	geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 19/22] media: au0828 add enable, disable source handlers
Date: Thu, 11 Feb 2016 16:41:35 -0700
Message-Id: <996f9857c037a8b6408f11fbff3aa96a2ddb1429.1455233156.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add enable_source and disable_source handlers.
The enable source handler is called from
v4l2-core, dvb-core, and ALSA drivers to check
if the shared media source is free. The disable
source handler is called to release the shared
media source.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 202 +++++++++++++++++++++++++++++++++
 drivers/media/usb/au0828/au0828.h      |   5 +
 2 files changed, 207 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 4c90f28..bcae077 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -282,6 +282,7 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 		return -EINVAL;
 
 	if (tuner) {
+		dev->tuner = tuner;
 		/* create tuner to decoder link in deactivated state */
 		ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
 					    decoder, 0, 0);
@@ -373,6 +374,203 @@ void au0828_media_graph_notify(struct media_entity *new, void *notify_data)
 #endif
 }
 
+static int au0828_enable_source(struct media_entity *entity,
+				struct media_pipeline *pipe)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_entity  *source, *find_source;
+	struct media_entity *sink;
+	struct media_link *link, *found_link = NULL;
+	int ret = 0;
+	struct media_device *mdev = entity->graph_obj.mdev;
+	struct au0828_dev *dev;
+
+	if (!mdev)
+		return -ENODEV;
+
+	mutex_lock(&mdev->graph_mutex);
+
+	dev = mdev->source_priv;
+
+	/*
+	 * For Audio and V4L2 entity, find the link to which decoder
+	 * is the sink. Look for an active link between decoder and
+	 * source (tuner/s-video/Composite), if one exists, nothing
+	 * to do. If not, look for any  active links between source
+	 * and any other entity. If one exists, source is busy. If
+	 * source is free, setup link and start pipeline from source.
+	 * For DVB FE entity, the source for the link is the tuner.
+	 * Check if tuner is available and setup link and start
+	 * pipeline.
+	*/
+	if (entity->function == MEDIA_ENT_F_DTV_DEMOD) {
+		sink = entity;
+		find_source = dev->tuner;
+	} else {
+		/* Analog isn't configured or register failed */
+		if (!dev->decoder) {
+			ret = -ENODEV;
+			goto end;
+		}
+
+		sink = dev->decoder;
+
+		/*
+		 * Default input is tuner and default input_type
+		 * is AU0828_VMUX_TELEVISION.
+		 * FIXME:
+		 * There is a problem when s_input is called to
+		 * change the default input. s_input will try to
+		 * enable_source before attempting to change the
+		 * input on the device, and will end up enabling
+		 * default source which is tuner.
+		 *
+		 * Additional logic is necessary in au0828
+		 * to detect that the input has changed and
+		 * enable the right source.
+		*/
+
+		if (dev->input_type == AU0828_VMUX_TELEVISION)
+			find_source = dev->tuner;
+		else if (dev->input_type == AU0828_VMUX_SVIDEO ||
+			 dev->input_type == AU0828_VMUX_COMPOSITE)
+			find_source = &dev->input_ent[dev->input_type];
+		else {
+			/* unknown input - let user select input */
+			ret = 0;
+			goto end;
+		}
+	}
+
+	/* Is an active link between sink and source */
+	if (dev->active_link) {
+		/*
+		 * If DVB is using the tuner and calling entity is
+		 * audio/video, the following check will be false,
+		 * since sink is different. Result is Busy.
+		 */
+		if (dev->active_link->sink->entity == sink &&
+		    dev->active_link->source->entity == find_source) {
+			/*
+			 * Either ALSA or Video own tuner. sink is
+			 * the same for both. Prevent Video stepping
+			 * on ALSA when ALSA owns the source.
+			*/
+			if (dev->active_link_owner != entity &&
+			    dev->active_link_owner->function ==
+						MEDIA_ENT_F_AUDIO_CAPTURE) {
+				pr_debug("ALSA has the tuner\n");
+				ret = -EBUSY;
+				goto end;
+			}
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
+		    link->source->entity == find_source) {
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
+		pr_err("Activate tuner link %s->%s. Error %d\n",
+			source->name, sink->name, ret);
+		goto end;
+	}
+
+	ret = __media_entity_pipeline_start(entity, pipe);
+	if (ret) {
+		pr_err("Start Pipeline: %s->%s Error %d\n",
+			source->name, entity->name, ret);
+		ret = __media_entity_setup_link(found_link, 0);
+		pr_err("Deactivate link Error %d\n", ret);
+		goto end;
+	}
+	/*
+	 * save active link and active link owner to avoid audio
+	 * deactivating video owned link from disable_source and
+	 * vice versa
+	*/
+	dev->active_link = found_link;
+	dev->active_link_owner = entity;
+	dev->active_source = source;
+	dev->active_sink = sink;
+
+	pr_debug("Enabled Source: %s->%s->%s Ret %d\n",
+		 dev->active_source->name, dev->active_sink->name,
+		 dev->active_link_owner->name, ret);
+end:
+	mutex_unlock(&mdev->graph_mutex);
+	pr_debug("au0828_enable_source() end %s %d %d\n",
+		 entity->name, entity->function, ret);
+	return ret;
+#endif
+	return 0;
+}
+
+static void au0828_disable_source(struct media_entity *entity)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	int ret = 0;
+	struct media_device *mdev = entity->graph_obj.mdev;
+	struct au0828_dev *dev;
+
+	if (!mdev)
+		return;
+
+	mutex_lock(&mdev->graph_mutex);
+	dev = mdev->source_priv;
+
+	if (!dev->active_link) {
+		ret = -ENODEV;
+		goto end;
+	}
+
+	/* link is active - stop pipeline from source (tuner) */
+	if (dev->active_link->sink->entity == dev->active_sink &&
+	    dev->active_link->source->entity == dev->active_source) {
+		/*
+		 * prevent video from deactivating link when audio
+		 * has active pipeline
+		*/
+		if (dev->active_link_owner != entity)
+			goto end;
+		__media_entity_pipeline_stop(entity);
+		ret = __media_entity_setup_link(dev->active_link, 0);
+		if (ret)
+			pr_err("Deactivate link Error %d\n", ret);
+
+		pr_debug("Disabled Source: %s->%s->%s Ret %d\n",
+			 dev->active_source->name, dev->active_sink->name,
+			 dev->active_link_owner->name, ret);
+
+		dev->active_link = NULL;
+		dev->active_link_owner = NULL;
+		dev->active_source = NULL;
+		dev->active_sink = NULL;
+	}
+
+end:
+	mutex_unlock(&mdev->graph_mutex);
+#endif
+}
+
 static int au0828_media_device_register(struct au0828_dev *dev,
 					struct usb_device *udev)
 {
@@ -403,6 +601,10 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 			ret);
 		return ret;
 	}
+	/* set enable_source */
+	dev->media_dev->source_priv = (void *) dev;
+	dev->media_dev->enable_source = au0828_enable_source;
+	dev->media_dev->disable_source = au0828_disable_source;
 #endif
 	return 0;
 }
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 54379ec..66f2ec3 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -284,6 +284,11 @@ struct au0828_dev {
 	struct media_entity input_ent[AU0828_MAX_INPUT];
 	struct media_pad input_pad[AU0828_MAX_INPUT];
 	struct media_entity_notify entity_notify;
+	struct media_entity *tuner;
+	struct media_link *active_link;
+	struct media_entity *active_link_owner;
+	struct media_entity *active_source;
+	struct media_entity *active_sink;
 #endif
 };
 
-- 
2.5.0

