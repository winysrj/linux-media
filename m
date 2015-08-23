Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58916 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbbHWUSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:10 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v7 40/44] [media] media: Use a macro to interate between all interfaces
Date: Sun, 23 Aug 2015 17:17:57 -0300
Message-Id: <b9c9cbab4cbddfacb2f21a8b1a5ca17934eb8157.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like we do with entities, use a similar macro for the
interfaces loop.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 24fee38730f5..288ab158adad 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -577,7 +577,7 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 	}
 
 	/* Create indirect interface links for tuner and TS out entities */
-	list_for_each_entry(intf, &mdev->interfaces, list) {
+	media_device_for_each_intf(intf, mdev) {
 		if (intf->type == MEDIA_INTF_T_DVB_FE && tuner)
 			media_create_intf_link(tuner, intf, 0);
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 51807efa505b..f23d686aaac6 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -113,6 +113,11 @@ struct media_device *media_device_find_devres(struct device *dev);
 #define media_device_for_each_entity(entity, mdev)			\
 	list_for_each_entry(entity, &(mdev)->entities, list)
 
+/* Iterate over all interfaces. */
+#define media_device_for_each_intf(intf, mdev)			\
+	list_for_each_entry(intf, &(mdev)->interfaces, list)
+
+
 #else
 static inline int media_device_register(struct media_device *mdev)
 {
-- 
2.4.3

