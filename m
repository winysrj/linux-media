Return-path: <mchehab@localhost>
Received: from bear.ext.ti.com ([192.94.94.41]:38813 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab0IBOqX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Sep 2010 10:46:23 -0400
From: raja_mani@ti.com
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	mchehab@infradead.org
Cc: matti.j.aaltonen@nokia.com, Raja Mani <raja_mani@ti.com>,
	Pramodh AG <pramodh_ag@ti.com>
Subject: [RFC/PATCH 2/8] include:linux:videodev2: Define new CIDs for FM RX ctls
Date: Thu,  2 Sep 2010 11:57:54 -0400
Message-Id: <1283443080-30644-3-git-send-email-raja_mani@ti.com>
In-Reply-To: <1283443080-30644-2-git-send-email-raja_mani@ti.com>
References: <1283443080-30644-1-git-send-email-raja_mani@ti.com>
 <1283443080-30644-2-git-send-email-raja_mani@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

From: Raja Mani <raja_mani@ti.com>

Extend V4L2 CID list to support
   1) FM RX Tuner controls
   2) FM band
   3) RSSI Threshold
   4) Alternative Frequency

Signed-off-by: Raja Mani <raja_mani@ti.com>
Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
---
 include/linux/videodev2.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 7c99acf..2798137 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -964,6 +964,7 @@ struct v4l2_writeback_ioctl_data {
 #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression controls */
 #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
 #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
+#define V4L2_CTRL_CLASS_FM_RX 0x009c0000	/* FM Tuner control class */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1362,6 +1363,23 @@ enum v4l2_preemphasis {
 #define V4L2_CID_TUNE_POWER_LEVEL		(V4L2_CID_FM_TX_CLASS_BASE + 113)
 #define V4L2_CID_TUNE_ANTENNA_CAPACITOR		(V4L2_CID_FM_TX_CLASS_BASE + 114)
 
+/* FM Tuner class control IDs */
+#define V4L2_CID_FM_RX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_RX | 0x900)
+#define V4L2_CID_FM_RX_CLASS			(V4L2_CTRL_CLASS_FM_RX | 1)
+
+#define V4L2_CID_FM_BAND			(V4L2_CID_FM_RX_CLASS_BASE + 1)
+enum v4l2_fm_band {
+	V4L2_FM_BAND_OTHER	= 0,
+	V4L2_FM_BAND_JAPAN	= 1,
+	V4L2_FM_BAND_OIRT	= 2
+};
+#define V4L2_CID_RSSI_THRESHOLD			(V4L2_CID_FM_RX_CLASS_BASE + 2)
+#define V4L2_CID_TUNE_AF			(V4L2_CID_FM_RX_CLASS_BASE + 3)
+enum v4l2_tune_af {
+	V4L2_FM_AF_OFF		= 0,
+	V4L2_FM_AF_ON		= 1
+};
+
 /*
  *	T U N I N G
  */
-- 
1.5.6.3

