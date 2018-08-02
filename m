Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50002 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731848AbeHBVxS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 17:53:18 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 5/6] media: Add controls for jpeg quantization tables
Date: Thu,  2 Aug 2018 17:00:09 -0300
Message-Id: <20180802200010.24365-6-ezequiel@collabora.com>
In-Reply-To: <20180802200010.24365-1-ezequiel@collabora.com>
References: <20180802200010.24365-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shunqian Zheng <zhengsq@rock-chips.com>

Add V4L2_CID_JPEG_LUMA/CHROMA_QUANTIZATION controls to allow userspace
configure the JPEG quantization tables.

Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst | 9 +++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c               | 4 ++++
 include/uapi/linux/v4l2-controls.h                 | 3 +++
 3 files changed, 16 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 9f7312bf3365..80e26f81900b 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -3354,6 +3354,15 @@ JPEG Control IDs
     Specify which JPEG markers are included in compressed stream. This
     control is valid only for encoders.
 
+.. _jpeg-quant-tables-control:
+
+``V4L2_CID_JPEG_LUMA_QUANTIZATION (__u8 matrix)``
+    Sets the luma quantization table to be used for encoding
+    or decoding a V4L2_PIX_FMT_JPEG_RAW format buffer. This table is
+    expected to be in JPEG zigzag order, as per the JPEG specification.
+
+``V4L2_CID_JPEG_CHROMA_QUANTIZATION (__u8 matrix)``
+    Sets the chroma quantization table.
 
 
 .. flat-table::
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 599c1cbff3b9..5c62c3101851 100644
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
@@ -1284,6 +1286,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
 	case V4L2_CID_DETECT_MD_REGION_GRID:
+	case V4L2_CID_JPEG_LUMA_QUANTIZATION:
+	case V4L2_CID_JPEG_CHROMA_QUANTIZATION:
 		*type = V4L2_CTRL_TYPE_U8;
 		break;
 	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:
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
