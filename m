Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52954 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbcFTTLx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:11:53 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 06/24] media: Add video statistics computation functions
Date: Mon, 20 Jun 2016 22:10:24 +0300
Message-Id: <1466449842-29502-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video statistics function describes entities such as video histogram
engines or 3A statistics engines.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/DocBook/media/v4l/media-types.xml | 9 +++++++++
 include/uapi/linux/media.h                      | 1 +
 2 files changed, 10 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
index 60fe841f8846..95aa1f9c836a 100644
--- a/Documentation/DocBook/media/v4l/media-types.xml
+++ b/Documentation/DocBook/media/v4l/media-types.xml
@@ -176,6 +176,15 @@
 		   skipping are considered as scaling.
 	    </entry>
 	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_STATISTICS</constant></entry>
+	    <entry>Video statistics computation (histogram, 3A, ...). An entity
+		   capable of statistics computation must have one sink pad and
+		   one source pad. It computes statistics over the frames
+		   received on its sink pad and outputs the statistics data on
+		   its source pad.
+	    </entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 3136686c4bd0..7acf0f634f70 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -102,6 +102,7 @@ struct media_device_info {
 #define MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV	(MEDIA_ENT_F_BASE + 0x4003)
 #define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
 #define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
+#define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
 
 /*
  * Connectors
-- 
Regards,

Laurent Pinchart

