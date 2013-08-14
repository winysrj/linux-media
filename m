Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40597 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3HNEqN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Aug 2013 00:46:13 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, hverkuil@xs4all.nl, swarren@wwwdotorg.org,
	a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v5 02/13] [media] exynos5-fimc-is: Add Exynos5 FIMC-IS device tree bindings documentation
Date: Wed, 14 Aug 2013 10:16:03 +0530
Message-Id: <1376455574-15560-3-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1376455574-15560-1-git-send-email-arun.kk@samsung.com>
References: <1376455574-15560-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch adds the DT binding documentation for Samsung
Exynos5 SoC series imaging subsystem (FIMC-IS).

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 .../devicetree/bindings/media/exynos5-fimc-is.txt  |   47 ++++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-fimc-is.txt

diff --git a/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
new file mode 100644
index 0000000..bfd36df
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
@@ -0,0 +1,47 @@
+Samsung EXYNOS5 SoC series Imaging Subsystem (FIMC-IS)
+------------------------------------------------------
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
+- interrupt-parent  : parent interrupt controller
+- interrupts        : fimc-is interrupt to the parent combiner
+- clocks            : list of clock specifiers, corresponding to entries in
+                      clock-names property;
+- clock-names       : must contain "isp", "mcu_isp", "isp_div0", "isp_div1",
+                      "isp_divmpwm", "mcu_isp_div0", "mcu_isp_div1" entries,
+                      matching entries in the clocks property.
+- pmu               : phandle to the fimc-is pmu node describing the register
+                      base and size for FIMC-IS PMU.
+
+i2c-isp (ISP I2C bus controller) nodes
+------------------------------------------
+
+Required properties:
+
+- compatible	: should be "samsung,exynos4212-i2c-isp" for Exynos4212,
+		  Exynos4412 and Exynos5250 SoCs;
+- reg		: physical base address and length of the registers set;
+- clocks	: must contain gate clock specifier for this controller;
+- clock-names	: must contain "i2c_isp" entry.
+
+For the i2c-isp node, it is required to specify a pinctrl state named "default",
+according to the pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt.
+
+Device tree nodes of the image sensors' controlled directly by the FIMC-IS
+firmware must be child nodes of their corresponding ISP I2C bus controller node.
+The data link of these image sensors must be specified using the common video
+interfaces bindings, defined in video-interfaces.txt.
-- 
1.7.9.5

