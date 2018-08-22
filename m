Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48104 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727251AbeHVUZz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 16:25:55 -0400
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
Subject: [PATCH v3 5/7] media: Add JPEG_RAW format
Date: Wed, 22 Aug 2018 13:59:35 -0300
Message-Id: <20180822165937.8700-6-ezequiel@collabora.com>
In-Reply-To: <20180822165937.8700-1-ezequiel@collabora.com>
References: <20180822165937.8700-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shunqian Zheng <zhengsq@rock-chips.com>

Add V4L2_PIX_FMT_JPEG_RAW format that does not contain
JPEG header in the output frame.

Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 Documentation/media/uapi/v4l/pixfmt-compressed.rst | 9 +++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c               | 1 +
 include/uapi/linux/videodev2.h                     | 1 +
 3 files changed, 11 insertions(+)

diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index d382e7a5c38e..4dffe40097f2 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -23,6 +23,15 @@ Compressed Formats
       - 'JPEG'
       - TBD. See also :ref:`VIDIOC_G_JPEGCOMP <VIDIOC_G_JPEGCOMP>`,
 	:ref:`VIDIOC_S_JPEGCOMP <VIDIOC_G_JPEGCOMP>`.
+    * .. _V4L2-PIX-FMT-JPEG-RAW:
+
+      - ``V4L2_PIX_FMT_JPEG_RAW``
+      - 'Raw JPEG'
+      - Raw JPEG bitstream, containing a compressed payload. This format
+        contains an image scan, i.e. without any metadata or headers.
+        The user is expected to set the needed metadata such as
+        quantization and entropy encoding tables, via ``V4L2_CID_JPEG``
+        controls, see :ref:`jpeg-control-id`.
     * .. _V4L2-PIX-FMT-MPEG:
 
       - ``V4L2_PIX_FMT_MPEG``
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 54afc9c7ee6e..0dcd95f4bdf1 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1301,6 +1301,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		/* Max description length mask:	descr = "0123456789012345678901234567890" */
 		case V4L2_PIX_FMT_MJPEG:	descr = "Motion-JPEG"; break;
 		case V4L2_PIX_FMT_JPEG:		descr = "JFIF JPEG"; break;
+		case V4L2_PIX_FMT_JPEG_RAW:	descr = "Raw JPEG"; break;
 		case V4L2_PIX_FMT_DV:		descr = "1394"; break;
 		case V4L2_PIX_FMT_MPEG:		descr = "MPEG-1/2/4"; break;
 		case V4L2_PIX_FMT_H264:		descr = "H.264"; break;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 5d1a3685bea9..f271048c89c4 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -627,6 +627,7 @@ struct v4l2_pix_format {
 /* compressed formats */
 #define V4L2_PIX_FMT_MJPEG    v4l2_fourcc('M', 'J', 'P', 'G') /* Motion-JPEG   */
 #define V4L2_PIX_FMT_JPEG     v4l2_fourcc('J', 'P', 'E', 'G') /* JFIF JPEG     */
+#define V4L2_PIX_FMT_JPEG_RAW v4l2_fourcc('J', 'P', 'G', 'R') /* JFIF JPEG RAW without headers */
 #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /* 1394          */
 #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4 Multiplexed */
 #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
-- 
2.18.0
