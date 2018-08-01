Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56484 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389906AbeHARln (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 13:41:43 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pravin Shedge <pravin.shedge4linux@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Shuah Khan <shuah@kernel.org>
Subject: [PATCH 03/13] v4l2-mc: switch it to use the new approach to setup pipelines
Date: Wed,  1 Aug 2018 12:55:05 -0300
Message-Id: <f3a56b9bb4210885f005c96cddf5773c2c4e0cd1.1533138685.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533138685.git.mchehab+samsung@kernel.org>
References: <cover.1533138685.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533138685.git.mchehab+samsung@kernel.org>
References: <cover.1533138685.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of relying on a static map for pids, use the new sig_type
"taint" type to setup the pipelines with the same tipe between
different entities.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/media-entity.c      | 26 +++++++++++
 drivers/media/v4l2-core/v4l2-mc.c | 73 ++++++++++++++++++++++++-------
 include/media/media-entity.h      | 19 ++++++++
 3 files changed, 101 insertions(+), 17 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 3498551e618e..0b1cb3559140 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -662,6 +662,32 @@ static void __media_entity_remove_link(struct media_entity *entity,
 	kfree(link);
 }
 
+int media_get_pad_index(struct media_entity *entity, bool is_sink,
+			enum media_pad_signal_type sig_type)
+{
+	int i;
+	bool pad_is_sink;
+
+	if (!entity)
+		return -EINVAL;
+
+	for (i = 0; i < entity->num_pads; i++) {
+		if (entity->pads[i].flags == MEDIA_PAD_FL_SINK)
+			pad_is_sink = true;
+		else if (entity->pads[i].flags == MEDIA_PAD_FL_SOURCE)
+			pad_is_sink = false;
+		else
+			continue;	/* This is an error! */
+
+		if (pad_is_sink != is_sink)
+			continue;
+		if (entity->pads[i].sig_type == sig_type)
+			return i;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(media_get_pad_index);
+
 int
 media_create_pad_link(struct media_entity *source, u16 source_pad,
 			 struct media_entity *sink, u16 sink_pad, u32 flags)
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 982bab3530f6..1925e1a3b861 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -28,7 +28,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	struct media_entity *io_v4l = NULL, *io_vbi = NULL, *io_swradio = NULL;
 	bool is_webcam = false;
 	u32 flags;
-	int ret;
+	int ret, pad_sink, pad_source;
 
 	if (!mdev)
 		return 0;
@@ -97,29 +97,52 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	/* Link the tuner and IF video output pads */
 	if (tuner) {
 		if (if_vid) {
-			ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
-						    if_vid,
-						    IF_VID_DEC_PAD_IF_INPUT,
+			pad_source = media_get_pad_index(tuner, false,
+							 PAD_SIGNAL_ANALOG);
+			pad_sink = media_get_pad_index(if_vid, true,
+						       PAD_SIGNAL_ANALOG);
+			if (pad_source < 0 || pad_sink < 0)
+				return -EINVAL;
+			ret = media_create_pad_link(tuner, pad_source,
+						    if_vid, pad_sink,
 						    MEDIA_LNK_FL_ENABLED);
 			if (ret)
 				return ret;
-			ret = media_create_pad_link(if_vid, IF_VID_DEC_PAD_OUT,
-						decoder, DEMOD_PAD_IF_INPUT,
+
+			pad_source = media_get_pad_index(if_vid, false,
+							 PAD_SIGNAL_DV);
+			pad_sink = media_get_pad_index(decoder, true,
+						       PAD_SIGNAL_DV);
+			if (pad_source < 0 || pad_sink < 0)
+				return -EINVAL;
+			ret = media_create_pad_link(if_vid, pad_source,
+						decoder, pad_sink,
 						MEDIA_LNK_FL_ENABLED);
 			if (ret)
 				return ret;
 		} else {
-			ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
-						decoder, DEMOD_PAD_IF_INPUT,
+			pad_source = media_get_pad_index(tuner, false,
+							 PAD_SIGNAL_ANALOG);
+			pad_sink = media_get_pad_index(decoder, true,
+						       PAD_SIGNAL_ANALOG);
+			if (pad_source < 0 || pad_sink < 0)
+				return -EINVAL;
+			ret = media_create_pad_link(tuner, pad_source,
+						decoder, pad_sink,
 						MEDIA_LNK_FL_ENABLED);
 			if (ret)
 				return ret;
 		}
 
 		if (if_aud) {
-			ret = media_create_pad_link(tuner, TUNER_PAD_AUD_OUT,
-						    if_aud,
-						    IF_AUD_DEC_PAD_IF_INPUT,
+			pad_source = media_get_pad_index(tuner, false,
+							 PAD_SIGNAL_AUDIO);
+			pad_sink = media_get_pad_index(decoder, true,
+						       PAD_SIGNAL_AUDIO);
+			if (pad_source < 0 || pad_sink < 0)
+				return -EINVAL;
+			ret = media_create_pad_link(tuner, pad_source,
+						    if_aud, pad_sink,
 						    MEDIA_LNK_FL_ENABLED);
 			if (ret)
 				return ret;
@@ -131,7 +154,10 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 
 	/* Create demod to V4L, VBI and SDR radio links */
 	if (io_v4l) {
-		ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
+		pad_source = media_get_pad_index(decoder, false, PAD_SIGNAL_DV);
+		if (pad_source < 0)
+			return -EINVAL;
+		ret = media_create_pad_link(decoder, pad_source,
 					io_v4l, 0,
 					MEDIA_LNK_FL_ENABLED);
 		if (ret)
@@ -139,7 +165,10 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	}
 
 	if (io_swradio) {
-		ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
+		pad_source = media_get_pad_index(decoder, false, PAD_SIGNAL_DV);
+		if (pad_source < 0)
+			return -EINVAL;
+		ret = media_create_pad_link(decoder, pad_source,
 					io_swradio, 0,
 					MEDIA_LNK_FL_ENABLED);
 		if (ret)
@@ -147,7 +176,10 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	}
 
 	if (io_vbi) {
-		ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
+		pad_source = media_get_pad_index(decoder, false, PAD_SIGNAL_DV);
+		if (pad_source < 0)
+			return -EINVAL;
+		ret = media_create_pad_link(decoder, pad_source,
 					    io_vbi, 0,
 					    MEDIA_LNK_FL_ENABLED);
 		if (ret)
@@ -161,15 +193,22 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 		case MEDIA_ENT_F_CONN_RF:
 			if (!tuner)
 				continue;
-
+			pad_source = media_get_pad_index(tuner, false,
+							 PAD_SIGNAL_ANALOG);
+			if (pad_source < 0)
+				return -EINVAL;
 			ret = media_create_pad_link(entity, 0, tuner,
-						    TUNER_PAD_RF_INPUT,
+						    pad_source,
 						    flags);
 			break;
 		case MEDIA_ENT_F_CONN_SVIDEO:
 		case MEDIA_ENT_F_CONN_COMPOSITE:
+			pad_sink = media_get_pad_index(decoder, true,
+						       PAD_SIGNAL_ANALOG);
+			if (pad_sink < 0)
+				return -EINVAL;
 			ret = media_create_pad_link(entity, 0, decoder,
-						    DEMOD_PAD_IF_INPUT,
+						    pad_sink,
 						    flags);
 			break;
 		default:
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 8bfbe6b59fa9..ac8b93e46167 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -675,6 +675,25 @@ static inline void media_entity_cleanup(struct media_entity *entity) {}
 #define media_entity_cleanup(entity) do { } while (false)
 #endif
 
+
+/**
+ * media_get_pad_index() - retrieves a pad index from an entity
+ *
+ * @entity:	entity where the pads belong
+ * @is_sink:	true if the pad is a sink, false if it is a source
+ * @sig_type:	type of signal of the pad to be search
+ *
+ * This helper function finds the first pad index inside an entity that
+ * satisfies both @is_sink and @sig_type conditions.
+ *
+ * Return:
+ *
+ * On success, return the pad number. If the pad was not found or the media
+ * entity is a NULL pointer, return -EINVAL.
+ */
+int media_get_pad_index(struct media_entity *entity, bool is_sink,
+			enum media_pad_signal_type sig_type);
+
 /**
  * media_create_pad_link() - creates a link between two entities.
  *
-- 
2.17.1
