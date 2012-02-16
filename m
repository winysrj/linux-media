Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42400 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2BPSYJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 13:24:09 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZI00GKN0G4O3@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 18:24:04 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZI000JG0G33H@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 18:24:04 +0000 (GMT)
Date: Thu, 16 Feb 2012 19:23:57 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 4/6] V4L: Add get/set_frame_config subdev callbacks
In-reply-to: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329416639-19454-5-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add subdev callbacks for setting up parameters of frame on media bus that
are not exposed to user space directly. This is more a stub containing
only parameters needed to setup V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 data
transmision and the associated frame embedded data.

The @length field of struct v4l2_frame_config determines maximum number
of frame samples per frame, excluding embedded non-image data.

@header_length and @footer length determine the size in bytes of data
embedded at frame beginning and end respectively.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/media/v4l2-subdev.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index be74061..bd95f00 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -21,6 +21,7 @@
 #ifndef _V4L2_SUBDEV_H
 #define _V4L2_SUBDEV_H
 
+#include <linux/types.h>
 #include <linux/v4l2-subdev.h>
 #include <media/media-entity.h>
 #include <media/v4l2-common.h>
@@ -45,6 +46,7 @@ struct v4l2_fh;
 struct v4l2_subdev;
 struct v4l2_subdev_fh;
 struct tuner_setup;
+struct v4l2_frame_config;
 
 /* decode_vbi_line */
 struct v4l2_decode_vbi_line {
@@ -476,6 +478,10 @@ struct v4l2_subdev_pad_ops {
 		       struct v4l2_subdev_crop *crop);
 	int (*get_crop)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		       struct v4l2_subdev_crop *crop);
+	int (*set_frame_config)(struct v4l2_subdev *sd, unsigned int pad,
+				struct v4l2_frame_config *fc);
+	int (*get_frame_config)(struct v4l2_subdev *sd, unsigned int pad,
+				struct v4l2_frame_config *fc);
 };
 
 struct v4l2_subdev_ops {
@@ -567,6 +573,18 @@ struct v4l2_subdev_fh {
 #define to_v4l2_subdev_fh(fh)	\
 	container_of(fh, struct v4l2_subdev_fh, vfh)
 
+/**
+ * struct v4l2_frame_config - media bus data frame configuration
+ * @length: maximum number of media bus samples per frame
+ * @header_length: size of embedded data at frame start (header)
+ * @footer_length: size of embedded data at frame end (footer)
+ */
+struct v4l2_frame_config {
+	size_t length;
+	size_t header_length;
+	size_t footer_length;
+};
+
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 static inline struct v4l2_mbus_framefmt *
 v4l2_subdev_get_try_format(struct v4l2_subdev_fh *fh, unsigned int pad)
-- 
1.7.9

