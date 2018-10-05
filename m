Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:39836 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728229AbeJEOqr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 10:46:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tomasz Figa <tfiga@chromium.org>, snawrocki@kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 02/11] v4l2-common.h: put backwards compat defines under #ifndef __KERNEL__
Date: Fri,  5 Oct 2018 09:49:02 +0200
Message-Id: <20181005074911.47574-3-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-1-hverkuil@xs4all.nl>
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This ensures that they won't be used in kernel code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/v4l2-common.h | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/v4l2-common.h b/include/uapi/linux/v4l2-common.h
index 4f7b892377cd..7d21c1634b4d 100644
--- a/include/uapi/linux/v4l2-common.h
+++ b/include/uapi/linux/v4l2-common.h
@@ -79,24 +79,11 @@
 /* Current composing area plus all padding pixels */
 #define V4L2_SEL_TGT_COMPOSE_PADDED	0x0103
 
-/* Backward compatibility target definitions --- to be removed. */
-#define V4L2_SEL_TGT_CROP_ACTIVE	V4L2_SEL_TGT_CROP
-#define V4L2_SEL_TGT_COMPOSE_ACTIVE	V4L2_SEL_TGT_COMPOSE
-#define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL	V4L2_SEL_TGT_CROP
-#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL V4L2_SEL_TGT_COMPOSE
-#define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS	V4L2_SEL_TGT_CROP_BOUNDS
-#define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS V4L2_SEL_TGT_COMPOSE_BOUNDS
-
 /* Selection flags */
 #define V4L2_SEL_FLAG_GE		(1 << 0)
 #define V4L2_SEL_FLAG_LE		(1 << 1)
 #define V4L2_SEL_FLAG_KEEP_CONFIG	(1 << 2)
 
-/* Backward compatibility flag definitions --- to be removed. */
-#define V4L2_SUBDEV_SEL_FLAG_SIZE_GE	V4L2_SEL_FLAG_GE
-#define V4L2_SUBDEV_SEL_FLAG_SIZE_LE	V4L2_SEL_FLAG_LE
-#define V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG V4L2_SEL_FLAG_KEEP_CONFIG
-
 struct v4l2_edid {
 	__u32 pad;
 	__u32 start_block;
@@ -105,4 +92,19 @@ struct v4l2_edid {
 	__u8  *edid;
 };
 
+#ifndef __KERNEL__
+/* Backward compatibility target definitions --- to be removed. */
+#define V4L2_SEL_TGT_CROP_ACTIVE	V4L2_SEL_TGT_CROP
+#define V4L2_SEL_TGT_COMPOSE_ACTIVE	V4L2_SEL_TGT_COMPOSE
+#define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL	V4L2_SEL_TGT_CROP
+#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL V4L2_SEL_TGT_COMPOSE
+#define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS	V4L2_SEL_TGT_CROP_BOUNDS
+#define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS V4L2_SEL_TGT_COMPOSE_BOUNDS
+
+/* Backward compatibility flag definitions --- to be removed. */
+#define V4L2_SUBDEV_SEL_FLAG_SIZE_GE	V4L2_SEL_FLAG_GE
+#define V4L2_SUBDEV_SEL_FLAG_SIZE_LE	V4L2_SEL_FLAG_LE
+#define V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG V4L2_SEL_FLAG_KEEP_CONFIG
+#endif
+
 #endif /* __V4L2_COMMON__ */
-- 
2.18.0
