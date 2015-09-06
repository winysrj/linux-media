Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54613 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbbIFMD4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 08:03:56 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v8 45/55] [media] media: Use a macro to interate between all interfaces
Date: Sun,  6 Sep 2015 09:03:05 -0300
Message-Id: <3d9230b2ced520c413291a5f69ed7ef672920194.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <9e511a1a223c99f489330c29f50d099f58d0c34b.1440902901.git.mchehab@osg.samsung.com>
References: <9e511a1a223c99f489330c29f50d099f58d0c34b.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like we do with entities, use a similar macro for the
interfaces loop.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 6babc688801b..f00f1a5f279c 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -578,9 +578,10 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 	}
 
 	/* Create indirect interface links for FE->tuner, DVR->demux and CA->ca */
-	list_for_each_entry(intf, &mdev->interfaces, list) {
+	media_device_for_each_intf(intf, mdev) {
 		if (intf->type == MEDIA_INTF_T_DVB_CA && ca)
 			media_create_intf_link(ca, intf, 0);
+
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


