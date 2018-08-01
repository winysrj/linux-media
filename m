Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43114 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbeHAWzK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 18:55:10 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Shunqian Zheng <zhengsq@rock-chips.com>
Subject: [PATCH 2/3] media: Add controls for jpeg quantization tables
Date: Wed,  1 Aug 2018 18:07:13 -0300
Message-Id: <20180801210714.1620-3-ezequiel@collabora.com>
In-Reply-To: <20180801210714.1620-1-ezequiel@collabora.com>
References: <20180801210714.1620-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shunqian Zheng <zhengsq@rock-chips.com>

Add V4L2_CID_JPEG_LUMA/CHROMA_QUANTIZATION controls to allow userspace
configure the JPEG quantization tables.

Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 4 ++++
 include/uapi/linux/v4l2-controls.h   | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index d29e45516eb7..b06adba2c486 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -980,6 +980,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_JPEG_RESTART_INTERVAL:	return "Restart Interval";
 	case V4L2_CID_JPEG_COMPRESSION_QUALITY:	return "Compression Quality";
 	case V4L2_CID_JPEG_ACTIVE_MARKER:	return "Active Markers";
+	case V4L2_CID_JPEG_LUMA_QUANTIZATION:	return "Luminance Quantization Matrix";
+	case V4L2_CID_JPEG_CHROMA_QUANTIZATION:	return "Chrominance Quantization Matrix";
 
 	/* Image source controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
@@ -1263,6 +1265,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
 	case V4L2_CID_DETECT_MD_REGION_GRID:
+	case V4L2_CID_JPEG_LUMA_QUANTIZATION:
+	case V4L2_CID_JPEG_CHROMA_QUANTIZATION:
 		*type = V4L2_CTRL_TYPE_U8;
 		break;
 	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 8d473c979b61..b731fd7bc899 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -971,6 +971,9 @@ enum v4l2_jpeg_chroma_subsampling {
 #define	V4L2_JPEG_ACTIVE_MARKER_DQT		(1 << 17)
 #define	V4L2_JPEG_ACTIVE_MARKER_DHT		(1 << 18)
 
+#define V4L2_CID_JPEG_LUMA_QUANTIZATION		(V4L2_CID_JPEG_CLASS_BASE + 5)
+#define V4L2_CID_JPEG_CHROMA_QUANTIZATION	(V4L2_CID_JPEG_CLASS_BASE + 6)
+
 
 /* Image source controls */
 #define V4L2_CID_IMAGE_SOURCE_CLASS_BASE	(V4L2_CTRL_CLASS_IMAGE_SOURCE | 0x900)
-- 
2.18.0.rc2
