Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38512 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752810AbZKIUwK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Nov 2009 15:52:10 -0500
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1N7agS-0002YK-Dn
	for linux-media@vger.kernel.org; Mon, 09 Nov 2009 21:17:52 +0100
Date: Mon, 9 Nov 2009 21:17:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] sh_mobile_ceu_camera: document the scaling and cropping
 algorithm
Message-ID: <Pine.LNX.4.64.0911092117260.4289@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sh_mobile_ceu_camera driver implements an advanced algorithm, combining
scaling and cropping on the client and on the host. Due to its complexity the
algorithm deserves separate documentation.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 Documentation/video4linux/sh_mobile_ceu_camera.txt |  157 ++++++++++++++++++++
 1 files changed, 157 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/video4linux/sh_mobile_ceu_camera.txt

diff --git a/Documentation/video4linux/sh_mobile_ceu_camera.txt b/Documentation/video4linux/sh_mobile_ceu_camera.txt
new file mode 100644
index 0000000..2ae1634
--- /dev/null
+++ b/Documentation/video4linux/sh_mobile_ceu_camera.txt
@@ -0,0 +1,157 @@
+	Cropping and Scaling algorithm, used in the sh_mobile_ceu_camera driver
+	=======================================================================
+
+Terminology
+-----------
+
+sensor scales: horizontal and vertical scales, configured by the sensor driver
+host scales: -"- host driver
+combined scales: sensor_scale * host_scale
+
+
+Generic scaling / cropping scheme
+---------------------------------
+
+-1--
+|
+-2-- -\
+|      --\
+|         --\
++-5-- -\     -- -3--
+|       ---\
+|           --- -4-- -\
+|                      -\
+|                        - -6--
+|
+|                        - -6'-
+|                      -/
+|           --- -4'- -/
+|       ---/
++-5'- -/
+|            -- -3'-
+|         --/
+|      --/
+-2'- -/
+|
+|
+-1'-
+
+Produced by user requests:
+
+S_CROP(left / top = (5) - (1), width / height = (5') - (5))
+S_FMT(width / height = (6') - (6))
+
+Here:
+
+(1) to (1') - whole max width or height
+(1) to (2)  - sensor cropped left or top
+(2) to (2') - sensor cropped width or height
+(3) to (3') - sensor scale
+(3) to (4)  - CEU cropped left or top
+(4) to (4') - CEU cropped width or height
+(5) to (5') - reverse sensor scale applied to CEU cropped width or height
+(2) to (5)  - reverse sensor scale applied to CEU cropped left or top
+(6) to (6') - CEU scale - user window
+
+
+S_FMT
+-----
+
+Do not touch input rectangle - it is already optimal.
+
+1. Calculate current sensor scales:
+
+	scale_s = ((3') - (3)) / ((2') - (2))
+
+2. Calculate "effective" input crop (sensor subwindow) - CEU crop scaled back at
+current sensor scales onto input window - this is user S_CROP:
+
+	width_u = (5') - (5) = ((4') - (4)) * scale_s
+
+3. Calculate new combined scales from "effective" input window to requested user
+window:
+
+	scale_comb = width_u / ((6') - (6))
+
+4. Calculate sensor output window by applying combined scales to real input
+window:
+
+	width_s_out = ((2') - (2)) / scale_comb
+
+5. Apply iterative sensor S_FMT for sensor output window.
+
+	subdev->video_ops->s_fmt(.width = width_s_out)
+
+6. Retrieve sensor output window (g_fmt)
+
+7. Calculate new sensor scales:
+
+	scale_s_new = ((3')_new - (3)_new) / ((2') - (2))
+
+8. Calculate new CEU crop - apply sensor scales to previously calculated
+"effective" crop:
+
+	width_ceu = (4')_new - (4)_new = width_u / scale_s_new
+	left_ceu = (4)_new - (3)_new = ((5) - (2)) / scale_s_new
+
+9. Use CEU cropping to crop to the new window:
+
+	ceu_crop(.width = width_ceu, .left = left_ceu)
+
+10. Use CEU scaling to scale to the requested user window:
+
+	scale_ceu = width_ceu / width
+
+
+S_CROP
+------
+
+If old scale applied to new crop is invalid produce nearest new scale possible
+
+1. Calculate current combined scales.
+
+	scale_comb = (((4') - (4)) / ((6') - (6))) * (((2') - (2)) / ((3') - (3)))
+
+2. Apply iterative sensor S_CROP for new input window.
+
+3. If old combined scales applied to new crop produce an impossible user window,
+adjust scales to produce nearest possible window.
+
+	width_u_out = ((5') - (5)) / scale_comb
+
+	if (width_u_out > max)
+		scale_comb = ((5') - (5)) / max;
+	else if (width_u_out < min)
+		scale_comb = ((5') - (5)) / min;
+
+4. Issue G_CROP to retrieve actual input window.
+
+5. Using actual input window and calculated combined scales calculate sensor
+target output window.
+
+	width_s_out = ((3') - (3)) = ((2') - (2)) / scale_comb
+
+6. Apply iterative S_FMT for new sensor target output window.
+
+7. Issue G_FMT to retrieve the actual sensor output window.
+
+8. Calculate sensor scales.
+
+	scale_s = ((3') - (3)) / ((2') - (2))
+
+9. Calculate sensor output subwindow to be cropped on CEU by applying sensor
+scales to the requested window.
+
+	width_ceu = ((5') - (5)) / scale_s
+
+10. Use CEU cropping for above calculated window.
+
+11. Calculate CEU scales from sensor scales from results of (10) and user window
+from (3)
+
+	scale_ceu = calc_scale(((5') - (5)), &width_u_out)
+
+12. Apply CEU scales.
+
+--
+Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
-- 
1.6.2.4

