Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36652 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732141AbeGaSna (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 14:43:30 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Shuah Khan <shuah@kernel.org>,
        Pravin Shedge <pravin.shedge4linux@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH RFC 3/4] v4l2-mc: switch it to use the new approach to setup pipelines
Date: Tue, 31 Jul 2018 14:02:12 -0300
Message-Id: <ee44755619458d65a632e32b72d73b98ac7de5bb.1533055990.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533055990.git.mchehab+samsung@kernel.org>
References: <cover.1533055990.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533055990.git.mchehab+samsung@kernel.org>
References: <cover.1533055990.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of relying on a static map for pids, use the new sig_type
"taint" type to setup the pipelines with the same tipe between
different entities.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/v4l2-core/v4l2-mc.c | 87 +++++++++++++++++++++++++------
 1 file changed, 71 insertions(+), 16 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 982bab3530f6..8640f656f9ae 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -19,6 +19,28 @@
 #include <media/v4l2-subdev.h>
 #include <media/videobuf2-core.h>
 
+static int get_pad_index(struct media_entity *entity, bool is_sink,
+			 enum media_pad_signal_type sig_type)
+{
+	int i;
+	bool pad_is_sink;
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
+
 int v4l2_mc_create_media_graph(struct media_device *mdev)
 
 {
@@ -28,7 +50,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	struct media_entity *io_v4l = NULL, *io_vbi = NULL, *io_swradio = NULL;
 	bool is_webcam = false;
 	u32 flags;
-	int ret;
+	int ret, pad_sink, pad_source;
 
 	if (!mdev)
 		return 0;
@@ -97,29 +119,48 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	/* Link the tuner and IF video output pads */
 	if (tuner) {
 		if (if_vid) {
-			ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
-						    if_vid,
-						    IF_VID_DEC_PAD_IF_INPUT,
+			pad_source = get_pad_index(tuner, false, PAD_SIGNAL_RF);
+			pad_sink = get_pad_index(if_vid, true, PAD_SIGNAL_RF);
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
+			pad_source = get_pad_index(if_vid, false,
+						   PAD_SIGNAL_ATV_VIDEO);
+			pad_sink = get_pad_index(decoder, true,
+						 PAD_SIGNAL_ATV_VIDEO);
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
+			pad_source = get_pad_index(tuner, false, PAD_SIGNAL_RF);
+			pad_sink = get_pad_index(decoder, true, PAD_SIGNAL_RF);
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
+			pad_source = get_pad_index(tuner, false,
+						   PAD_SIGNAL_AUDIO);
+			pad_sink = get_pad_index(decoder, true,
+						 PAD_SIGNAL_AUDIO);
+			if (pad_source < 0 || pad_sink < 0)
+				return -EINVAL;
+			ret = media_create_pad_link(tuner, pad_source,
+						    if_aud, pad_sink,
 						    MEDIA_LNK_FL_ENABLED);
 			if (ret)
 				return ret;
@@ -131,7 +172,10 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 
 	/* Create demod to V4L, VBI and SDR radio links */
 	if (io_v4l) {
-		ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
+		pad_source = get_pad_index(tuner, false, PAD_SIGNAL_ATV_VIDEO);
+		if (pad_source < 0)
+			return -EINVAL;
+		ret = media_create_pad_link(decoder, pad_source,
 					io_v4l, 0,
 					MEDIA_LNK_FL_ENABLED);
 		if (ret)
@@ -139,7 +183,10 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	}
 
 	if (io_swradio) {
-		ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
+		pad_source = get_pad_index(tuner, false, PAD_SIGNAL_ATV_VIDEO);
+		if (pad_source < 0)
+			return -EINVAL;
+		ret = media_create_pad_link(decoder, pad_source,
 					io_swradio, 0,
 					MEDIA_LNK_FL_ENABLED);
 		if (ret)
@@ -147,7 +194,10 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	}
 
 	if (io_vbi) {
-		ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
+		pad_source = get_pad_index(tuner, false, PAD_SIGNAL_ATV_VIDEO);
+		if (pad_source < 0)
+			return -EINVAL;
+		ret = media_create_pad_link(decoder, pad_source,
 					    io_vbi, 0,
 					    MEDIA_LNK_FL_ENABLED);
 		if (ret)
@@ -161,13 +211,18 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 		case MEDIA_ENT_F_CONN_RF:
 			if (!tuner)
 				continue;
-
+			pad_source = get_pad_index(tuner, false, PAD_SIGNAL_RF);
+			if (pad_source < 0)
+				return -EINVAL;
 			ret = media_create_pad_link(entity, 0, tuner,
-						    TUNER_PAD_RF_INPUT,
+						    pad_source,
 						    flags);
 			break;
 		case MEDIA_ENT_F_CONN_SVIDEO:
 		case MEDIA_ENT_F_CONN_COMPOSITE:
+			pad_sink = get_pad_index(decoder, true, PAD_SIGNAL_RF);
+			if (pad_sink < 0)
+				return -EINVAL;
 			ret = media_create_pad_link(entity, 0, decoder,
 						    DEMOD_PAD_IF_INPUT,
 						    flags);
-- 
2.17.1
