Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42946 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbcB2Cjo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2016 21:39:44 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH] media: Add video processing entity functions
Date: Mon, 29 Feb 2016 04:39:49 +0200
Message-ID: <5562155.eCcBVavsh3@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add composer, format converter and scaler functions, as well as generic
video processing to be used when no other processing function is
applicable.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/media-types.xml | 17 +++++++++++++++++
 include/uapi/linux/media.h                      |  8 ++++++++
 2 files changed, 25 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
index 8b4fa39cf611..8859a5de7a30 100644
--- a/Documentation/DocBook/media/v4l/media-types.xml
+++ b/Documentation/DocBook/media/v4l/media-types.xml
@@ -109,6 +109,23 @@
 		   decoder.
 	    </entry>
 	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_GENERIC</constant></entry>
+	    <entry>Generic video processing, when no other processing function
+		   is applicable.
+	    </entry>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_COMPOSER</constant></entry>
+	    <entry>Video composer (blender)</entry>
+	  </row>
+	  </row>
+	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_CONVERTER</constant></entry>
+	    <entry>Video format converter</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_SCALER</constant></entry>
+	    <entry>Video scaler</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 6aac2f035a5d..998023ca43ae 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -88,6 +88,14 @@ struct media_device_info {
 #define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 2002)
 
 /*
+ * Processing entities
+ */
+#define MEDIA_ENT_F_PROC_VIDEO_GENERIC		(MEDIA_ENT_F_BASE + 3001)
+#define MEDIA_ENT_F_PROC_VIDEO_COMPOSER		(MEDIA_ENT_F_BASE + 3002)
+#define MEDIA_ENT_F_PROC_VIDEO_CONVERTER	(MEDIA_ENT_F_BASE + 3003)
+#define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 3004)
+
+/*
  * Connectors
  */
 /* It is a responsibility of the entity drivers to add connectors and links */
-- 
Regards,

Laurent Pinchart

