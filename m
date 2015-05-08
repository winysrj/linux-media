Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbbEHBMy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 21:12:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Olli Salonen <olli.salonen@iki.fi>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH 07/18] media controller: rename the tuner entity
Date: Thu,  7 May 2015 22:12:29 -0300
Message-Id: <6d88ece22cbbbaa72bbddb8b152b0d62728d6129.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Finally, let's rename the tuner entity. inside the media subsystem,
a tuner can be used by AM/FM radio, SDR radio, analog TV and digital TV.
It could even be used on other subsystems, like network, for wireless
devices.

So, it is not constricted to V4L2 API, or to a subdev.

Let's then rename it as:
	MEDIA_ENT_T_V4L2_SUBDEV_TUNER -> MEDIA_ENT_T_TUNER

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index 9b3861058f0d..5c7f366bb1f4 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -241,7 +241,7 @@
 	    signals.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_TUNER</constant></entry>
+	    <entry><constant>MEDIA_ENT_T_TUNER</constant></entry>
 	    <entry>TV and/or radio tuner</entry>
 	  </row>
 	</tbody>
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 39846077045e..d6a096495035 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -393,7 +393,7 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 
 	media_device_for_each_entity(entity, mdev) {
 		switch (entity->type) {
-		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
+		case MEDIA_ENT_T_TUNER:
 			tuner = entity;
 			break;
 		case MEDIA_ENT_T_DTV_DEMOD:
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index a756f74f0adc..2a7331e3c4a0 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1213,7 +1213,7 @@ static void cx231xx_create_media_graph(struct cx231xx *dev)
 
 	media_device_for_each_entity(entity, mdev) {
 		switch (entity->type) {
-		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
+		case MEDIA_ENT_T_TUNER:
 			tuner = entity;
 			break;
 		case MEDIA_ENT_T_ATV_DECODER:
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index abdcffabcb59..ecf4e8a543b3 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -696,7 +696,7 @@ static int tuner_probe(struct i2c_client *client,
 register_client:
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	t->pad.flags = MEDIA_PAD_FL_SOURCE;
-	t->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_TUNER;
+	t->sd.entity.type = MEDIA_ENT_T_TUNER;
 	t->sd.entity.name = t->name;
 
 	ret = media_entity_init(&t->sd.entity, 1, &t->pad, 0);
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 9b3d80e765f0..6acc4be1378c 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -57,7 +57,7 @@ struct media_device_info {
 
 #define MEDIA_ENT_T_ATV_DECODER	(MEDIA_ENT_T_CAM_SENSOR + 3)
 
-#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_CAM_SENSOR + 4)
+#define MEDIA_ENT_T_TUNER	(MEDIA_ENT_T_CAM_SENSOR + 4)
 
 #if 1
 /*
@@ -88,6 +88,8 @@ struct media_device_info {
 #define MEDIA_ENT_T_V4L2_SUBDEV_LENS	MEDIA_ENT_T_CAM_LENS
 
 #define MEDIA_ENT_T_V4L2_SUBDEV_DECODER MEDIA_ENT_T_ATV_DECODER
+
+#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	MEDIA_ENT_T_TUNER
 #endif
 
 /* Used bitmasks for media_entity_desc::flags */
-- 
2.1.0

