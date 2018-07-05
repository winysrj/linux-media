Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43712 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753213AbeGER2c (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 13:28:32 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Subject: [PATCH 1/3] media: Add JPEG_RAW format
Date: Thu,  5 Jul 2018 14:28:17 -0300
Message-Id: <20180705172819.5588-2-ezequiel@collabora.com>
In-Reply-To: <20180705172819.5588-1-ezequiel@collabora.com>
References: <20180705172819.5588-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shunqian Zheng <zhengsq@rock-chips.com>

Add V4L2_PIX_FMT_JPEG_RAW format that does not contain
JPEG header in the output frame.

Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
---
 Documentation/media/uapi/v4l/pixfmt-compressed.rst | 5 +++++
 drivers/media/v4l2-core/v4l2-ioctl.c               | 1 +
 include/uapi/linux/videodev2.h                     | 1 +
 3 files changed, 7 insertions(+)

diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index abec03937bb3..ebfc3cb7399c 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -23,6 +23,11 @@ Compressed Formats
       - 'JPEG'
       - TBD. See also :ref:`VIDIOC_G_JPEGCOMP <VIDIOC_G_JPEGCOMP>`,
 	:ref:`VIDIOC_S_JPEGCOMP <VIDIOC_G_JPEGCOMP>`.
+    * .. _V4L2-PIX-FMT-JPEG-RAW:
+
+      - ``V4L2_PIX_FMT_JPEG_RAW``
+      - 'Raw JPEG'
+      - JPEG without any headers.
     * .. _V4L2-PIX-FMT-MPEG:
 
       - ``V4L2_PIX_FMT_MPEG``
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index dd210067151f..9f0c76ec7c2c 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1259,6 +1259,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		/* Max description length mask:	descr = "0123456789012345678901234567890" */
 		case V4L2_PIX_FMT_MJPEG:	descr = "Motion-JPEG"; break;
 		case V4L2_PIX_FMT_JPEG:		descr = "JFIF JPEG"; break;
+		case V4L2_PIX_FMT_JPEG_RAW:	descr = "Raw JPEG"; break;
 		case V4L2_PIX_FMT_DV:		descr = "1394"; break;
 		case V4L2_PIX_FMT_MPEG:		descr = "MPEG-1/2/4"; break;
 		case V4L2_PIX_FMT_H264:		descr = "H.264"; break;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 600877be5c22..934e91af1b40 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -621,6 +621,7 @@ struct v4l2_pix_format {
 /* compressed formats */
 #define V4L2_PIX_FMT_MJPEG    v4l2_fourcc('M', 'J', 'P', 'G') /* Motion-JPEG   */
 #define V4L2_PIX_FMT_JPEG     v4l2_fourcc('J', 'P', 'E', 'G') /* JFIF JPEG     */
+#define V4L2_PIX_FMT_JPEG_RAW v4l2_fourcc('J', 'P', 'G', 'R') /* JFIF JPEG RAW without headers */
 #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /* 1394          */
 #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4 Multiplexed */
 #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
-- 
2.18.0.rc2
