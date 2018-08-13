Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36827 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728818AbeHMMGx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 08:06:53 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: kernel@pengutronix.de, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
        afshin.nasser@gmail.com, linux-media@vger.kernel.org
Subject: [PATCH v2 3/7] [media] v4l2-subdev: add stubs for v4l2_subdev_get_try_*
Date: Mon, 13 Aug 2018 11:25:04 +0200
Message-Id: <20180813092508.1334-4-m.felsch@pengutronix.de>
In-Reply-To: <20180813092508.1334-1-m.felsch@pengutronix.de>
References: <20180813092508.1334-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case of missing CONFIG_VIDEO_V4L2_SUBDEV_API those helpers aren't
available. So each driver have to add ifdefs around those helpers or
add the CONFIG_VIDEO_V4L2_SUBDEV_API as dependcy.

Make these helpers available in case of CONFIG_VIDEO_V4L2_SUBDEV_API
isn't set to avoid ifdefs. This approach is less error prone too.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 include/media/v4l2-subdev.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 9102d6ca566e..ce48f1fcf295 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -912,8 +912,6 @@ struct v4l2_subdev_fh {
 #define to_v4l2_subdev_fh(fh)	\
 	container_of(fh, struct v4l2_subdev_fh, vfh)
 
-#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
-
 /**
  * v4l2_subdev_get_try_format - ancillary routine to call
  *	&struct v4l2_subdev_pad_config->try_fmt
@@ -927,9 +925,13 @@ static inline struct v4l2_mbus_framefmt
 			    struct v4l2_subdev_pad_config *cfg,
 			    unsigned int pad)
 {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &cfg[pad].try_fmt;
+#else
+	return NULL;
+#endif
 }
 
 /**
@@ -945,9 +947,13 @@ static inline struct v4l2_rect
 			  struct v4l2_subdev_pad_config *cfg,
 			  unsigned int pad)
 {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &cfg[pad].try_crop;
+#else
+	return NULL;
+#endif
 }
 
 /**
@@ -963,11 +969,14 @@ static inline struct v4l2_rect
 			     struct v4l2_subdev_pad_config *cfg,
 			     unsigned int pad)
 {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &cfg[pad].try_compose;
-}
+#else
+	return NULL;
 #endif
+}
 
 extern const struct v4l2_file_operations v4l2_subdev_fops;
 
-- 
2.18.0
