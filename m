Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:48129 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756659AbdCULtw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 07:49:52 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] [media] videodev2.h: Add new DV flag CAN_DETECT_REDUCED_FPS
Date: Tue, 21 Mar 2017 11:49:16 +0000
Message-Id: <8553b8aba19aa8d5266d215967791f6797e2c107.1490095965.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490095965.git.joabreu@synopsys.com>
References: <cover.1490095965.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490095965.git.joabreu@synopsys.com>
References: <cover.1490095965.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new flag to UAPI for DV timings which, whenever set,
indicates that hardware can detect the difference between
regular FPS and 1000/1001 FPS.

This is specific to HDMI receivers. Also, it is only valid
when V4L2_DV_FL_CAN_REDUCE_FPS is set.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Carlos Palminha <palminha@synopsys.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/uapi/linux/videodev2.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 45184a2..dd7b426 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1371,6 +1371,13 @@ struct v4l2_bt_timings {
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
1.9.1
