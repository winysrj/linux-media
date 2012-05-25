Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19391 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758474Ab2EYTxI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:53:08 -0400
Date: Fri, 25 May 2012 21:52:43 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 04/13] devicetree: Add common video devices bindings
 documentation
In-reply-to: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Message-id: <1337975573-27117-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <4FBFE1EC.9060209@samsung.com>
 <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/devicetree/bindings/video/video.txt |   10 ++++++++++
 1 file changed, 10 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/video.txt

diff --git a/Documentation/devicetree/bindings/video/video.txt b/Documentation/devicetree/bindings/video/video.txt
new file mode 100644
index 0000000..9f6a637
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/video.txt
@@ -0,0 +1,10 @@
+Common properties of video data source devices (image sensor, video encoders, etc.)
+
+Video bus types
+---------------
+
+- video-bus-type : must be one of:
+
+    - itu-601   : parallel bus with HSYNC and VSYNC - ITU-R BT.601;
+    - itu-656   : parallel bus with embedded synchronization - ITU-R BT.656;
+    - mipi-csi2 : MIPI-CSI2 serial bus;
-- 
1.7.10

