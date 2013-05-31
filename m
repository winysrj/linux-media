Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:8197 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3EaMky (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 08:40:54 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MNN002D2XW1Y8Q0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 21:40:53 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, kilyeon.im@samsung.com,
	shaik.ameer@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC v2 01/10] exynos5-fimc-is: Add Exynos5 FIMC-IS device tree
 bindings documentation
Date: Fri, 31 May 2013 18:33:19 +0530
Message-id: <1370005408-10853-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 .../devicetree/bindings/media/exynos5-fimc-is.txt  |   41 ++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-fimc-is.txt

diff --git a/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
new file mode 100644
index 0000000..9fd4646
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
@@ -0,0 +1,41 @@
+Samsung EXYNOS SoC Camera Subsystem
+-----------------------------------
+
+The camera subsystem on Samsung Exynos5 SoC has some changes relative
+to previous SoC versions. Exynos5 has almost similar MIPI-CSIS and
+FIMC-LITE IPs but has a much improved version of FIMC-IS which can
+handle sensor controls and camera post-processing operations. The
+Exynos5 FIMC-IS has a dedicated ARM Cortex A5 processor, many
+post-processing blocks (ISP, DRC, FD, ODC, DIS, 3DNR) and two
+dedicated scalers (SCC and SCP).
+
+fimc-is node
+------------
+
+Required properties:
+
+- compatible        : must be "samsung,exynos5250-fimc-is"
+- reg               : physical base address and size of the memory mapped
+                      registers
+- interrupt-parent  : Parent interrupt controller
+- interrupts        : fimc-is interrupt to the parent combiner
+- clocks            : list of clock specifiers, corresponding to entries in
+                      clock-names property;
+- clock-names       : must contain "isp", "mcu_isp", "isp_div0", "isp_div1",
+                      "isp_divmpwm", "mcu_isp_div0", "mcu_isp_div1" entries,
+                      matching entries in the clocks property.
+
+
+Board specific properties:
+
+- pinctrl-names    : pinctrl names for camera port pinmux control, at least
+		     "default" needs to be specified.
+- pinctrl-0...N	   : pinctrl properties corresponding to pinctrl-names
+
+pmu subnode
+-----------
+
+Required properties:
+ - reg : should contain PMU physical base address and size of the memory
+         mapped registers.
+
-- 
1.7.9.5

