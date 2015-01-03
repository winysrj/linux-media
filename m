Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbbACUJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Jan 2015 15:09:51 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/7] dvbdev: represent frontend with two pads
Date: Sat,  3 Jan 2015 18:09:37 -0200
Message-Id: <dab96e93bd54e796152558512aea7d4dd3a3444a.1420315245.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420315245.git.mchehab@osg.samsung.com>
References: <cover.1420315245.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420315245.git.mchehab@osg.samsung.com>
References: <cover.1420315245.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While on some devices the tuner is bound inside the frontend,
other devices use a separate subdevice for it.

So, in order to be more generic, better to map it with two
pads.

That will allows to use the media controller to lock the tuner
between the DVB and the V4L2 sub-drivers, on hybrid devices.

While here, change the logic to use pad 0 as sink for devices
with both sink and source pads.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 202c15582fa3..f7294d2ef816 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -200,6 +200,7 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 	switch(type) {
 	case DVB_DEVICE_CA:
 	case DVB_DEVICE_DEMUX:
+	case DVB_DEVICE_FRONTEND:
 		npads = 2;
 		break;
 	case DVB_DEVICE_NET:
@@ -221,12 +222,13 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 	switch(type) {
 	case DVB_DEVICE_FRONTEND:
 		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_FE;
-		dvbdev->pads[0].flags = MEDIA_PAD_FL_SOURCE;
+		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
+		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
 		break;
 	case DVB_DEVICE_DEMUX:
 		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_DEMUX;
-		dvbdev->pads[0].flags = MEDIA_PAD_FL_SOURCE;
-		dvbdev->pads[1].flags = MEDIA_PAD_FL_SINK;
+		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
+		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
 		break;
 	case DVB_DEVICE_DVR:
 		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_DVR;
@@ -234,8 +236,8 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 		break;
 	case DVB_DEVICE_CA:
 		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_CA;
-		dvbdev->pads[0].flags = MEDIA_PAD_FL_SOURCE;
-		dvbdev->pads[1].flags = MEDIA_PAD_FL_SINK;
+		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
+		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
 		break;
 	case DVB_DEVICE_NET:
 		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_NET;
-- 
2.1.0

