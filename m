Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52863 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbbLKVBr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 16:01:47 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Subject: [PATCH] [media] media.h: let be clear that tuners need to use connectors
Date: Fri, 11 Dec 2015 19:01:31 -0200
Message-Id: <16cd172bc9cec7ce438df95c142d2219998e32fe.1449867690.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 core won't be adding connectors to the tuners and other
entities that need them. Let it be clear.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 include/uapi/linux/media.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 86f9753e5c03..cacfceb0d81d 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -74,10 +74,11 @@ struct media_device_info {
 /*
  * Connectors
  */
+/* It is a responsibility of the entity drivers to add connectors and links */
 #define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 21)
 #define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 22)
 #define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 23)
-	/* For internal test signal generators and other debug connectors */
+/* For internal test signal generators and other debug connectors */
 #define MEDIA_ENT_F_CONN_TEST		(MEDIA_ENT_F_BASE + 24)
 
 /*
@@ -105,6 +106,10 @@ struct media_device_info {
 #define MEDIA_ENT_F_FLASH		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 2)
 #define MEDIA_ENT_F_LENS		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 3)
 #define MEDIA_ENT_F_ATV_DECODER		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 4)
+/*
+ * It is a responsibility of the entity drivers to add connectors and links
+ *	for the tuner entities.
+ */
 #define MEDIA_ENT_F_TUNER		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
 
 #define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN	MEDIA_ENT_F_OLD_SUBDEV_BASE
-- 
2.5.0

