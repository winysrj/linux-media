Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50173 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbeK2ADG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 19:03:06 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 1/2] media: v4l2: clarify H.264 loop filter offset controls
Date: Wed, 28 Nov 2018 14:01:21 +0100
Message-Id: <20181128130122.4916-2-p.zabel@pengutronix.de>
In-Reply-To: <20181128130122.4916-1-p.zabel@pengutronix.de>
References: <20181128130122.4916-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The venus and s5p-mfc drivers add the loop filter alpha/beta offset
controls V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA/BETA with a range of
-6 to +6, inclusive. This is exactly the range specified for the slice
header fields slice_alpha_c0_offset_div2 and slice_beta_offset_div2,
which store half the actual filter offsets FilterOffsetA/B.

Clarify that this control contains the halved offsets.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
I assume that the venus and s5p-mfc drivers use the loop filter control
values directly as halved filter offsets, because of the ranges. If this
is not the case, the documentation should be changed to clarify that the
control values correspond to FilterOffsetA/B directly, instead.
---
 Documentation/media/uapi/v4l/extended-controls.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 65a1d873196b..8dff21391c1f 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1110,10 +1110,16 @@ enum v4l2_mpeg_video_h264_loop_filter_mode -
 
 ``V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA (integer)``
     Loop filter alpha coefficient, defined in the H264 standard.
+    This value corresponds to the slice_alpha_c0_offset_div2 slice header
+    field, and should be in the range of -6 to +6, inclusive. The actual alpha
+    offset FilterOffsetA is twice this value.
     Applicable to the H264 encoder.
 
 ``V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA (integer)``
     Loop filter beta coefficient, defined in the H264 standard.
+    This corresponds to the slice_beta_offset_div2 slice header field, and
+    should be in the range of -6 to +6, inclusive. The actual beta offset
+    FilterOffsetB is twice this value.
     Applicable to the H264 encoder.
 
 .. _v4l2-mpeg-video-h264-entropy-mode:
-- 
2.19.1
