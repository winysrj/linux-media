Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:21678 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab3DBQGj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 12:06:39 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: yhwan.joo@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 5/7] exynos4-is: Add Exynos4x12 FIMC-IS device tree binding
 documentation
Date: Tue, 02 Apr 2013 18:03:37 +0200
Message-id: <1364918619-9118-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364918619-9118-1-git-send-email-s.nawrocki@samsung.com>
References: <1364918619-9118-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds DT binding documentaton for the Imaging Subsystem
(camera ISP) found on Samsung Exynos4x12 SoCs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v3:
 - specified order of the interrupts,
 - added a note about image sensor device nodes.

Changes since v2:
 - added missing clocks at the binding documentation;
 - added clocks/clock-names properties to isp-i2c node.
---
 .../devicetree/bindings/media/exynos4-fimc-is.txt  |   49 ++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos4-fimc-is.txt

diff --git a/Documentation/devicetree/bindings/media/exynos4-fimc-is.txt b/Documentation/devicetree/bindings/media/exynos4-fimc-is.txt
new file mode 100644
index 0000000..55c9ad6
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/exynos4-fimc-is.txt
@@ -0,1 +1,49 @@
+Exynos4x12 SoC series Imaging Subsystem (FIMC-IS)
+
+The FIMC-IS is a subsystem for processing image signal from an image sensor.
+The Exynos4x12 SoC series FIMC-IS V1.5 comprises of a dedicated ARM Cortex-A5
+processor, ISP, DRC and FD IP blocks and peripheral devices such as UART, I2C
+and SPI bus controllers, PWM and ADC.
+
+fimc-is node
+------------
+
+Required properties:
+- compatible	: should be "samsung,exynos4212-fimc-is" for Exynos4212 and
+		  Exynos4412 SoCs;
+- reg		: physical base address and length of the registers set;
+- interrupts	: must contain two FIMC-IS interrupts, in order: ISP0, ISP1;
+- clocks	: list of clock specifiers, corresponding to entries in
+		  clock-names property;
+- clock-names	: must contain "ppmuispx", "ppmuispx", "lite0", "lite1"
+		  "mpll", "sysreg", "isp", "drc", "fd", "mcuisp", "uart",
+		  "ispdiv0", "ispdiv1", "mcuispdiv0", "mcuispdiv1", "aclk200",
+		  "div_aclk200", "aclk400mcuisp", "div_aclk400mcuisp" entries,
+		  matching entries in the clocks property.
+pmu subnode
+-----------
+
+Required properties:
+ - reg : must contain PMU physical base address and size of the register set.
+
+The following are the FIMC-IS peripheral device nodes and can be specified
+either standalone or as the fimc-is node child nodes.
+
+i2c-isp (ISP I2C bus controller) nodes
+------------------------------------------
+
+Required properties:
+
+- compatible	: should be "samsung,exynos4212-i2c-isp" for Exynos4212 and
+		  Exynos4412 SoCs;
+- reg		: physical base address and length of the registers set;
+- clocks	: must contain gate clock specifier for this controller;
+- clock-names	: must contain "i2c_isp" entry.
+
+For the above nodes it is required to specify a pinctrl state named "default",
+according to the pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt.
+
+Device tree nodes of the image sensors controlled directly by the FIMC-IS
+firmware must be child nodes of their corresponding ISP I2C bus controller node.
+The data link of these image sensors must be specified using the common video
+interfaces bindings, defined in video-interfaces.txt.
--
1.7.9.5

