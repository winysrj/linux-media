Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58917 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbbHWUSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:10 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v7 38/44] [media] media: report if a pad is sink or source at debug msg
Date: Sun, 23 Aug 2015 17:17:55 -0300
Message-Id: <fb5caac45339367ed0b0f51373ad080fcfc104d2.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes, it is important to see if the created pad is
sink or source. Add info to track that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index ad0827bf0982..24fee38730f5 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -527,8 +527,8 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 	struct media_entity *entity, *tuner = NULL, *demod = NULL;
 	struct media_entity *demux = NULL, *ca = NULL;
 	struct media_interface *intf;
-	unsigned demux_pad = 1;
-	unsigned dvr_pad = 1;
+	unsigned demux_pad = 0;
+	unsigned dvr_pad = 0;
 
 	if (!mdev)
 		return;
@@ -560,15 +560,19 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 
 	/* Create demux links for each ringbuffer/pad */
 	if (demux) {
-		if (entity->type == MEDIA_ENT_T_DVB_TSOUT) {
-			if (!strncmp(entity->name, DVR_TSOUT,
-				     sizeof(DVR_TSOUT)))
-				media_create_pad_link(demux, ++dvr_pad,
-						      entity, 0, 0);
-			if (!strncmp(entity->name, DEMUX_TSOUT,
-				     sizeof(DEMUX_TSOUT)))
-				media_create_pad_link(demux, ++demux_pad,
-						      entity, 0, 0);
+		media_device_for_each_entity(entity, mdev) {
+			if (entity->type == MEDIA_ENT_T_DVB_TSOUT) {
+				if (!strncmp(entity->name, DVR_TSOUT,
+					strlen(DVR_TSOUT)))
+					media_create_pad_link(demux,
+							      ++dvr_pad,
+							entity, 0, 0);
+				if (!strncmp(entity->name, DEMUX_TSOUT,
+					strlen(DEMUX_TSOUT)))
+					media_create_pad_link(demux,
+							      ++demux_pad,
+							entity, 0, 0);
+			}
 		}
 	}
 
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 05976c891c17..d30650e3562e 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -121,8 +121,11 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 		struct media_pad *pad = gobj_to_pad(gobj);
 
 		dev_dbg(gobj->mdev->dev,
-			"%s: id 0x%08x pad#%d: '%s':%d\n",
-			event_name, gobj->id, media_localid(gobj),
+			"%s: id 0x%08x %s%spad#%d: '%s':%d\n",
+			event_name, gobj->id,
+			pad->flags & MEDIA_PAD_FL_SINK   ? "  sink " : "",
+			pad->flags & MEDIA_PAD_FL_SOURCE ? "source " : "",
+			media_localid(gobj),
 			pad->entity->name, pad->index);
 		break;
 	}
-- 
2.4.3

