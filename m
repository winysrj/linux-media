Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42806 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab0IVKjL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 06:39:11 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id o8MAdBa0010390
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 22 Sep 2010 05:39:11 -0500
From: x0130808@ti.com
To: linux-media@vger.kernel.org
Cc: Raja Mani <raja_mani@ti.com>, Pramodh AG <pramodh_ag@ti.com>,
	Manjunatha Halli <x0130808@ti.com>
Subject: [RFC/PATCH 8/9] Documentation:DocBook:v4l: Update the controls.xml
Date: Wed, 22 Sep 2010 07:50:01 -0400
Message-Id: <1285156202-28569-9-git-send-email-x0130808@ti.com>
In-Reply-To: <1285156202-28569-8-git-send-email-x0130808@ti.com>
References: <1285156202-28569-1-git-send-email-x0130808@ti.com>
 <1285156202-28569-2-git-send-email-x0130808@ti.com>
 <1285156202-28569-3-git-send-email-x0130808@ti.com>
 <1285156202-28569-4-git-send-email-x0130808@ti.com>
 <1285156202-28569-5-git-send-email-x0130808@ti.com>
 <1285156202-28569-6-git-send-email-x0130808@ti.com>
 <1285156202-28569-7-git-send-email-x0130808@ti.com>
 <1285156202-28569-8-git-send-email-x0130808@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Raja Mani <raja_mani@ti.com>

Added entries for following 2 new CID's which are added for TI FM driver:
- V4L2_CID_RSSI_THRESHOLD
- V4L2_CID_TUNE_AF

Signed-off-by: Raja Mani <raja_mani@ti.com>
Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 Documentation/DocBook/v4l/controls.xml |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
index 8408caa..e074f73 100644
--- a/Documentation/DocBook/v4l/controls.xml
+++ b/Documentation/DocBook/v4l/controls.xml
@@ -132,6 +132,18 @@ consumption state.</entry>
 	    <entry>Loudness mode (bass boost).</entry>
 	  </row>
 	  <row>
+           <entry><constant>V4L2_CID_RSSI_THRESHOLD</constant></entry>
+           <entry>integer</entry>
+           <entry>Set RSSI threshold level. Change the default threshold
+level used to select valid frequencies during vidioc_s_hw_freq_seek.</entry>
+         </row>
+         <row>
+           <entry><constant>V4L2_CID_TUNE_AF</constant></entry>
+           <entry>integer</entry>
+           <entry>Set Alternative Frequency mode. Enable or disable
+alternative frequency mode.</entry>
+         </row>
+         <row>
 	    <entry><constant>V4L2_CID_BLACK_LEVEL</constant></entry>
 	    <entry>integer</entry>
 	    <entry>Another name for brightness (not a synonym of
-- 
1.5.6.3

