Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42805 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab0IVKjL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 06:39:11 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id o8MAdAMP010387
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 22 Sep 2010 05:39:10 -0500
From: x0130808@ti.com
To: linux-media@vger.kernel.org
Cc: Raja Mani <raja_mani@ti.com>, Pramodh AG <pramodh_ag@ti.com>,
	Manjunatha Halli <x0130808@ti.com>
Subject: [RFC/PATCH 7/9] include:linux:videodev2: Define 2 new CIDs for FM RX
Date: Wed, 22 Sep 2010 07:50:00 -0400
Message-Id: <1285156202-28569-8-git-send-email-x0130808@ti.com>
In-Reply-To: <1285156202-28569-7-git-send-email-x0130808@ti.com>
References: <1285156202-28569-1-git-send-email-x0130808@ti.com>
 <1285156202-28569-2-git-send-email-x0130808@ti.com>
 <1285156202-28569-3-git-send-email-x0130808@ti.com>
 <1285156202-28569-4-git-send-email-x0130808@ti.com>
 <1285156202-28569-5-git-send-email-x0130808@ti.com>
 <1285156202-28569-6-git-send-email-x0130808@ti.com>
 <1285156202-28569-7-git-send-email-x0130808@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Raja Mani <raja_mani@ti.com>

Extend V4L2 CID list to support
   1) RSSI Threshold
   2) Alternative Frequency

Signed-off-by: Raja Mani <raja_mani@ti.com>
Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 include/linux/videodev2.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index e9d018d..369987b 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1374,6 +1374,13 @@ enum v4l2_fm_band {
 	V4L2_FM_BAND_OIRT	= 2
 };
 
+#define V4L2_CID_RSSI_THRESHOLD		(V4L2_CID_FM_RX_CLASS_BASE + 2)
+#define V4L2_CID_TUNE_AF                       (V4L2_CID_FM_RX_CLASS_BASE + 3)
+enum v4l2_tune_af {
+       V4L2_FM_AF_OFF          = 0,
+       V4L2_FM_AF_ON           = 1
+};
+
 /*
  *	T U N I N G
  */
-- 
1.5.6.3

