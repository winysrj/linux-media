Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53426 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbeIQXBP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 19:01:15 -0400
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
Subject: [PATCH v6 5/6] media: Add controls for JPEG quantization tables
Date: Mon, 17 Sep 2018 14:30:20 -0300
Message-Id: <20180917173022.9338-6-ezequiel@collabora.com>
In-Reply-To: <20180917173022.9338-1-ezequiel@collabora.com>
References: <20180917173022.9338-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shunqian Zheng <zhengsq@rock-chips.com>

Add V4L2_CID_JPEG_QUANTIZATION compound control to allow userspace
configure the JPEG quantization tables.

Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../media/uapi/v4l/extended-controls.rst      | 25 +++++++++++++++++++
 .../media/videodev2.h.rst.exceptions          |  1 +
 drivers/media/v4l2-core/v4l2-ctrls.c          |  8 ++++++
 include/uapi/linux/v4l2-controls.h            | 10 ++++++++
 include/uapi/linux/videodev2.h                |  1 +
 5 files changed, 45 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 65a1d873196b..6effae175be1 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -3530,7 +3530,32 @@ JPEG Control IDs
     Specify which JPEG markers are included in compressed stream. This
     control is valid only for encoders.
 
+.. _jpeg-quant-tables-control:
 
+``V4L2_CID_JPEG_QUANTIZATION (struct)``
+    Specifies the luma and chroma quantization matrices for encoding
+    or decoding a V4L2_PIX_FMT_JPEG_RAW format buffer.
+    This control supports 8-bit quantization coefficients, for
+    the baseline profile, as specified by :ref:`itu-t81`.
+    Coefficients must be set in JPEG zigzag scan order.
+
+
+.. c:type:: struct v4l2_ctrl_jpeg_quantization
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_ctrl_jpeg_quantization
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u8
+      - ``luma_quantization_matrix[64]``
+      - Sets the luma quantization table.
+
+    * - __u8
+      - ``chroma_quantization_matrix[64]``
+      - Sets the chroma quantization table.
 
 .. flat-table::
     :header-rows:  0
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index 1c043d552313..fbdd827e4229 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -131,6 +131,7 @@ replace symbol V4L2_CTRL_TYPE_U32 :c:type:`v4l2_ctrl_type`
 replace symbol V4L2_CTRL_TYPE_U8 :c:type:`v4l2_ctrl_type`
 replace symbol V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS :c:type:`v4l2_ctrl_type`
 replace symbol V4L2_CTRL_TYPE_MPEG2_QUANTIZATION :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_JPEG_QUANTIZATION :c:type:`v4l2_ctrl_type`
 
 # V4L2 capability defines
 replace define V4L2_CAP_VIDEO_CAPTURE device-capabilities
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index dfdc31edb1dd..7b913a461b2e 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1001,6 +1001,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_JPEG_RESTART_INTERVAL:	return "Restart Interval";
 	case V4L2_CID_JPEG_COMPRESSION_QUALITY:	return "Compression Quality";
 	case V4L2_CID_JPEG_ACTIVE_MARKER:	return "Active Markers";
+	case V4L2_CID_JPEG_QUANTIZATION:	return "JPEG Quantization Tables";
 
 	/* Image source controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
@@ -1288,6 +1289,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DETECT_MD_REGION_GRID:
 		*type = V4L2_CTRL_TYPE_U8;
 		break;
+	case V4L2_CID_JPEG_QUANTIZATION:
+		*type = V4L2_CTRL_TYPE_JPEG_QUANTIZATION;
+		break;
 	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:
 		*type = V4L2_CTRL_TYPE_U16;
 		break;
@@ -1667,6 +1671,7 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 		return 0;
 
 	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
+	case V4L2_CTRL_TYPE_JPEG_QUANTIZATION:
 		return 0;
 
 	default:
@@ -2249,6 +2254,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
 		elem_size = sizeof(struct v4l2_ctrl_mpeg2_quantization);
 		break;
+	case V4L2_CTRL_TYPE_JPEG_QUANTIZATION:
+		elem_size = sizeof(struct v4l2_ctrl_jpeg_quantization);
+		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
 			elem_size = sizeof(s32);
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 51b095898f4b..5a8bdb732cfe 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -990,6 +990,16 @@ enum v4l2_jpeg_chroma_subsampling {
 #define	V4L2_JPEG_ACTIVE_MARKER_DQT		(1 << 17)
 #define	V4L2_JPEG_ACTIVE_MARKER_DHT		(1 << 18)
 
+#define V4L2_CID_JPEG_QUANTIZATION		(V4L2_CID_JPEG_CLASS_BASE + 5)
+struct v4l2_ctrl_jpeg_quantization {
+	/* ITU-T.81 specifies two quantization coefficient precisions:
+	 * 8-bit for baseline profile,
+	 * 8-bit or 16-bit for extended profile.
+	 * This control only supports the former, for the baseline profile.
+	 */
+	__u8	luma_quantization_matrix[64];
+	__u8	chroma_quantization_matrix[64];
+};
 
 /* Image source controls */
 #define V4L2_CID_IMAGE_SOURCE_CLASS_BASE	(V4L2_CTRL_CLASS_IMAGE_SOURCE | 0x900)
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 4c979886e8b2..8481a8ea8262 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1661,6 +1661,7 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_U32	     = 0x0102,
 	V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS = 0x0103,
 	V4L2_CTRL_TYPE_MPEG2_QUANTIZATION = 0x0104,
+	V4L2_CTRL_TYPE_JPEG_QUANTIZATION = 0x0105,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
2.19.0.rc2
