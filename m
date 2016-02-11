Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:35115 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337AbcBKO3D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 09:29:03 -0500
To: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.5] media.h: increase the spacing between function
 ranges
Message-ID: <56BC9AA7.3040102@xs4all.nl>
Date: Thu, 11 Feb 2016 15:28:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each function range is quite narrow and especially for connectors this
will pose a problem. Increase the function ranges while we still can and
move the connector range to the end so that range is practically limitless.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/media.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index c9eb42a..a300a33 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -72,21 +72,11 @@ struct media_device_info {
 #define MEDIA_ENT_F_DTV_NET_DECAP	(MEDIA_ENT_F_BASE + 4)

 /*
- * Connectors
- */
-/* It is a responsibility of the entity drivers to add connectors and links */
-#define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 21)
-#define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 22)
-#define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 23)
-/* For internal test signal generators and other debug connectors */
-#define MEDIA_ENT_F_CONN_TEST		(MEDIA_ENT_F_BASE + 24)
-
-/*
  * I/O entities
  */
-#define MEDIA_ENT_F_IO_DTV  		(MEDIA_ENT_F_BASE + 31)
-#define MEDIA_ENT_F_IO_VBI  		(MEDIA_ENT_F_BASE + 32)
-#define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 33)
+#define MEDIA_ENT_F_IO_DTV		(MEDIA_ENT_F_BASE + 1001)
+#define MEDIA_ENT_F_IO_VBI		(MEDIA_ENT_F_BASE + 1002)
+#define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 1003)

 /*
  * Analog TV IF-PLL decoders
@@ -94,8 +84,18 @@ struct media_device_info {
  * It is a responsibility of the master/bridge drivers to create links
  * for MEDIA_ENT_F_IF_VID_DECODER and MEDIA_ENT_F_IF_AUD_DECODER.
  */
-#define MEDIA_ENT_F_IF_VID_DECODER	(MEDIA_ENT_F_BASE + 41)
-#define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 42)
+#define MEDIA_ENT_F_IF_VID_DECODER	(MEDIA_ENT_F_BASE + 2001)
+#define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 2002)
+
+/*
+ * Connectors
+ */
+/* It is a responsibility of the entity drivers to add connectors and links */
+#define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 10001)
+#define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 10002)
+#define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)
+/* For internal test signal generators and other debug connectors */
+#define MEDIA_ENT_F_CONN_TEST		(MEDIA_ENT_F_BASE + 10004)

 /*
  * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and
-- 
2.7.0

