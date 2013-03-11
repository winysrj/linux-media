Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45908 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3CKTpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:45:34 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 6/8] fimc-is: Add Exynos4x12 FIMC-IS device tree bindings
 documentation
Date: Mon, 11 Mar 2013 20:44:50 +0100
Message-id: <1363031092-29950-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com>
References: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/media/exynos4-fimc-is.txt  |   41 ++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos4-fimc-is.txt

diff --git a/Documentation/devicetree/bindings/media/exynos4-fimc-is.txt b/Documentation/devicetree/bindings/media/exynos4-fimc-is.txt
new file mode 100644
index 0000000..ef994d1
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/exynos4-fimc-is.txt
@@ -0,0 +1,41 @@
+Exynos4x12 SoC series Imaging Subsystem (FIMC-IS)
+
+The FIMC-IS is an subsystem for processing image signal from an image sensor.
+The Exynos4x12 SoC series FIMC-IS V1.5 comprises of a dedicated ARM Cortex-A5
+processor, ISP, DRC and FD IP blocks and peripheral IPs such as I2C, SPI, UART
+bus controllers, Multi-PWM and ADC.
+
+fimc-is node
+------------
+
+Required properties:
+
+- compatible : should be "samsung,exynos4212-fimc-is" for Exynos4212 and
+	       Exynos4412 SoCs;
+- reg	     : physical base address and size of the device memory mapped
+	       registers;
+- interrupts : should contain FIMC-IS interrupts;
+
+The following are the FIMC-IS peripheral device nodes and can be specified
+either standalone or as fimc-is child nodes.
+
+pmu subnode
+-----------
+
+Required properties:
+ - reg	: should contain PMU physical base address of the memory mapped
+          registers and size, the value of size should be 0x3000.
+
+
+i2c-isp (ISP I2C bus controller) nodes
+------------------------------------------
+
+Required properties:
+
+- compatible : should be "samsung,exynos4212-i2c-isp" for Exynos4212 and
+	       Exynos4412 SoCs;
+- reg	     : physical base address and size of the device memory mapped
+	       registers;
+
+For the above nodes it is required to specify a pinctrl state named "default",
+according to the pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt.
-- 
1.7.9.5

