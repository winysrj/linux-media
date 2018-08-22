Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48134 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727251AbeHVUZ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 16:25:59 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v3 6/7] media: Add controls for JPEG quantization tables
Date: Wed, 22 Aug 2018 13:59:36 -0300
Message-Id: <20180822165937.8700-7-ezequiel@collabora.com>
In-Reply-To: <20180822165937.8700-1-ezequiel@collabora.com>
References: <20180822165937.8700-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shunqian Zheng <zhengsq@rock-chips.com>

Add V4L2_CID_JPEG_LUMA/CHROMA_QUANTIZATION controls to allow userspace
configure the JPEG quantization tables.

Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst | 13 +++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c               | 13 +++++++++++++
 include/uapi/linux/v4l2-controls.h                 |  3 +++
 3 files changed, 29 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 9f7312bf3365..1189750a022c 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -3354,6 +3354,19 @@ JPEG Control IDs
     Specify which JPEG markers are included in compressed stream. This
     control is valid only for encoders.
 
+.. _jpeg-quant-tables-control:
+
+``V4L2_CID_JPEG_LUMA_QUANTIZATION (__u8 matrix)``
+    Sets the luma quantization table to be used for encoding
+    or decoding a V4L2_PIX_FMT_JPEG_RAW format buffer. This table is
+    a 8x8-byte matrix, and it's expected to be in JPEG zigzag order,
+    as per the JPEG specification.
+
+``V4L2_CID_JPEG_CHROMA_QUANTIZATION (__u8 matrix)``
+    Sets the chroma quantization table to be used for encoding
+    or decoding a V4L2_PIX_FMT_JPEG_RAW format buffer. This table is
+    a 8x8-byte matrix, and it's expected to be in JPEG zigzag order,
+    as per the JPEG specification.
 
 
 .. flat-table::
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 6ab15f4a0fea..677af8069bfc 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -999,6 +999,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_JPEG_RESTART_INTERVAL:	return "Restart Interval";
 	case V4L2_CID_JPEG_COMPRESSION_QUALITY:	return "Compression Quality";
 	case V4L2_CID_JPEG_ACTIVE_MARKER:	return "Active Markers";
+	case V4L2_CID_JPEG_LUMA_QUANTIZATION:	return "Luminance Quantization Matrix";
+	case V4L2_CID_JPEG_CHROMA_QUANTIZATION:	return "Chrominance Quantization Matrix";
 
 	/* Image source controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
@@ -1286,6 +1288,17 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DETECT_MD_REGION_GRID:
 		*type = V4L2_CTRL_TYPE_U8;
 		break;
+	case V4L2_CID_JPEG_LUMA_QUANTIZATION:
+	case V4L2_CID_JPEG_CHROMA_QUANTIZATION:
+		*min = *def = 0;
+		*max = 0xff;
+		*step = 1;
+		*type = V4L2_CTRL_TYPE_U8;
+		if (dims) {
+			memset(dims, 0, V4L2_CTRL_MAX_DIMS * sizeof(dims[0]));
+			dims[0] = dims[1] = 8;
+		}
+		break;
 	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:
 		*type = V4L2_CTRL_TYPE_U16;
 		break;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index e4ee10ee917d..a466acf40625 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -987,6 +987,9 @@ enum v4l2_jpeg_chroma_subsampling {
 #define	V4L2_JPEG_ACTIVE_MARKER_DQT		(1 << 17)
 #define	V4L2_JPEG_ACTIVE_MARKER_DHT		(1 << 18)
 
+#define V4L2_CID_JPEG_LUMA_QUANTIZATION		(V4L2_CID_JPEG_CLASS_BASE + 5)
+#define V4L2_CID_JPEG_CHROMA_QUANTIZATION	(V4L2_CID_JPEG_CLASS_BASE + 6)
+
 
 /* Image source controls */
 #define V4L2_CID_IMAGE_SOURCE_CLASS_BASE	(V4L2_CTRL_CLASS_IMAGE_SOURCE | 0x900)
-- 
2.18.0
