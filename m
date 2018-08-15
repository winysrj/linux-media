Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:47911 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729329AbeHOQdM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 12:33:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Carlos Palminha <palminha@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/5] videodev2.h: Add new DV flag CAN_DETECT_REDUCED_FPS
Date: Wed, 15 Aug 2018 15:40:53 +0200
Message-Id: <20180815134056.98830-3-hverkuil@xs4all.nl>
In-Reply-To: <20180815134056.98830-1-hverkuil@xs4all.nl>
References: <20180815134056.98830-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jose Abreu <Jose.Abreu@synopsys.com>

Add a new flag to UAPI for DV timings which, whenever set,
indicates that hardware can detect the difference between
regular FPS and 1000/1001 FPS.

This is specific to HDMI receivers. Also, it is only valid
when V4L2_DV_FL_CAN_REDUCE_FPS is set.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Carlos Palminha <palminha@synopsys.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 5d1a3685bea9..622f0479d668 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1400,6 +1400,13 @@ struct v4l2_bt_timings {
  * InfoFrame).
  */
 #define V4L2_DV_FL_HAS_HDMI_VIC			(1 << 8)
+/*
+ * CEA-861 specific: only valid for video receivers.
+ * If set, then HW can detect the difference between regular FPS and
+ * 1000/1001 FPS. Note: This flag is only valid for HDMI VIC codes with
+ * the V4L2_DV_FL_CAN_REDUCE_FPS flag set.
+ */
+#define V4L2_DV_FL_CAN_DETECT_REDUCED_FPS	(1 << 9)
 
 /* A few useful defines to calculate the total blanking and frame sizes */
 #define V4L2_DV_BT_BLANKING_WIDTH(bt) \
-- 
2.18.0
