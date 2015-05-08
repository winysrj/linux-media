Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36557 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbbEHBMu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 21:12:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-doc@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [PATCH 05/18] media controller: rename MEDIA_ENT_T_DEVNODE_DVB entities
Date: Thu,  7 May 2015 22:12:27 -0300
Message-Id: <f448ae9a612a6ceb05e0fd669bf252fa90aa278a.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to reflect that the entities are actually the hardware
(or firmware, or in-kernel software), and are not associated
with the DVB API, let's remove DEVNODE_ from the entity names
and use DTV (Digital TV) for the entities.

The frontend is an special case: the frontend devnode actually
talks directly with the DTV demodulator. It may or may not also
talk with the SEC (Satellite Equipment Control) and with the
tuner. For the sake of unifying the nomenclature, let's call it
as MEDIA_ENT_T_DTV_DEMOD, because this component is always
there.

So:

	MEDIA_ENT_T_DEVNODE_DVB_FE    -> MEDIA_ENT_T_DTV_DEMOD
	MEDIA_ENT_T_DEVNODE_DVB_DEMUX -> MEDIA_ENT_T_DTV_DEMUX
	MEDIA_ENT_T_DEVNODE_DVB_DVR   -> MEDIA_ENT_T_DTV_DVR
	MEDIA_ENT_T_DEVNODE_DVB_CA    -> MEDIA_ENT_T_DTV_CA
	MEDIA_ENT_T_DEVNODE_DVB_NET   -> MEDIA_ENT_T_DTV_NET

PS.: we could actually not keep this define:
	#define MEDIA_ENT_T_DEVNODE_DVB_FE MEDIA_ENT_T_DTV_DEMOD

As MEDIA_ENT_T_DEVNODE_DVB_FE symbol will not arrive any Kernel
version (being present only at the 4.1-rc kernels), but keeping
it helps to show that the DVB frontend node is actually associated
with the DTV demodulator. So, keeping it for now helps to better
document. Also, it avoids to break experimental versions of v4l-utils.
So, better to remove this only when we remove the remaining legacy
stuff.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index 759604e3529f..27082b07f4c2 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -195,23 +195,23 @@
 	    <entry>ALSA card</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_FE</constant></entry>
+	    <entry><constant>MEDIA_ENT_T_DTV_DEMOD</constant></entry>
 	    <entry>DVB frontend devnode</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_DEMUX</constant></entry>
+	    <entry><constant>MEDIA_ENT_T_DTV_DEMUX</constant></entry>
 	    <entry>DVB demux devnode</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_DVR</constant></entry>
+	    <entry><constant>MEDIA_ENT_T_DTV_DVR</constant></entry>
 	    <entry>DVB DVR devnode</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_CA</constant></entry>
+	    <entry><constant>MEDIA_ENT_T_DTV_CA</constant></entry>
 	    <entry>DVB CAM devnode</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_NET</constant></entry>
+	    <entry><constant>MEDIA_ENT_T_DTV_NET</constant></entry>
 	    <entry>DVB network devnode</entry>
 	  </row>
 	  <row>
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 13bb57f0457f..39846077045e 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -221,26 +221,26 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 
 	switch (type) {
 	case DVB_DEVICE_FRONTEND:
-		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_FE;
+		dvbdev->entity->type = MEDIA_ENT_T_DTV_DEMOD;
 		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
 		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
 		break;
 	case DVB_DEVICE_DEMUX:
-		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_DEMUX;
+		dvbdev->entity->type = MEDIA_ENT_T_DTV_DEMUX;
 		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
 		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
 		break;
 	case DVB_DEVICE_DVR:
-		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_DVR;
+		dvbdev->entity->type = MEDIA_ENT_T_DTV_DVR;
 		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
 		break;
 	case DVB_DEVICE_CA:
-		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_CA;
+		dvbdev->entity->type = MEDIA_ENT_T_DTV_CA;
 		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
 		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
 		break;
 	case DVB_DEVICE_NET:
-		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_NET;
+		dvbdev->entity->type = MEDIA_ENT_T_DTV_NET;
 		break;
 	default:
 		kfree(dvbdev->entity);
@@ -396,16 +396,16 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
 			tuner = entity;
 			break;
-		case MEDIA_ENT_T_DEVNODE_DVB_FE:
+		case MEDIA_ENT_T_DTV_DEMOD:
 			fe = entity;
 			break;
-		case MEDIA_ENT_T_DEVNODE_DVB_DEMUX:
+		case MEDIA_ENT_T_DTV_DEMUX:
 			demux = entity;
 			break;
-		case MEDIA_ENT_T_DEVNODE_DVB_DVR:
+		case MEDIA_ENT_T_DTV_DVR:
 			dvr = entity;
 			break;
-		case MEDIA_ENT_T_DEVNODE_DVB_CA:
+		case MEDIA_ENT_T_DTV_CA:
 			ca = entity;
 			break;
 		}
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 2e465ba087ba..0de9912411c5 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -45,11 +45,11 @@ struct media_device_info {
 /* Used values for media_entity_desc::type */
 
 #define MEDIA_ENT_T_AV_DMA		(((1 << 16)) + 1)
-#define MEDIA_ENT_T_DEVNODE_DVB_FE	(MEDIA_ENT_T_AV_DMA + 3)
-#define MEDIA_ENT_T_DEVNODE_DVB_DEMUX	(MEDIA_ENT_T_AV_DMA + 4)
-#define MEDIA_ENT_T_DEVNODE_DVB_DVR	(MEDIA_ENT_T_AV_DMA + 5)
-#define MEDIA_ENT_T_DEVNODE_DVB_CA	(MEDIA_ENT_T_AV_DMA + 6)
-#define MEDIA_ENT_T_DEVNODE_DVB_NET	(MEDIA_ENT_T_AV_DMA + 7)
+#define MEDIA_ENT_T_DTV_DEMOD	(MEDIA_ENT_T_AV_DMA + 3)
+#define MEDIA_ENT_T_DTV_DEMUX	(MEDIA_ENT_T_AV_DMA + 4)
+#define MEDIA_ENT_T_DTV_DVR	(MEDIA_ENT_T_AV_DMA + 5)
+#define MEDIA_ENT_T_DTV_CA	(MEDIA_ENT_T_AV_DMA + 6)
+#define MEDIA_ENT_T_DTV_NET	(MEDIA_ENT_T_AV_DMA + 7)
 
 #define MEDIA_ENT_T_CAM_SENSOR	((2 << 16) + 1)
 #define MEDIA_ENT_T_CAM_FLASH	(MEDIA_ENT_T_CAM_SENSOR + 1)
@@ -76,7 +76,13 @@ struct media_device_info {
 #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
 #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
 
-#define MEDIA_ENT_T_DEVNODE_DVB		MEDIA_ENT_T_DEVNODE_DVB_FE
+#define MEDIA_ENT_T_DEVNODE_DVB		MEDIA_ENT_T_DTV_DEMOD
+#define MEDIA_ENT_T_DEVNODE_DVB_FE	MEDIA_ENT_T_DTV_DEMOD
+#define MEDIA_ENT_T_DEVNODE_DVB_DEMUX	MEDIA_ENT_T_DTV_DEMUX
+#define MEDIA_ENT_T_DEVNODE_DVB_DVR	MEDIA_ENT_T_DTV_DVR
+#define MEDIA_ENT_T_DEVNODE_DVB_CA	MEDIA_ENT_T_DTV_CA
+#define MEDIA_ENT_T_DEVNODE_DVB_NET	MEDIA_ENT_T_DTV_NET
+
 #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	MEDIA_ENT_T_CAM_SENSOR
 #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	MEDIA_ENT_T_CAM_FLASH
 #define MEDIA_ENT_T_V4L2_SUBDEV_LENS	MEDIA_ENT_T_CAM_LENS
-- 
2.1.0

