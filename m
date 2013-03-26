Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:21709 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab3CZSPA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 14:15:00 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 5/7] exynos4-is: Add Exynos4x12 FIMC-IS device tree bindings
 documentation
Date: Tue, 26 Mar 2013 19:14:21 +0100
Message-id: <1364321663-21010-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364321663-21010-1-git-send-email-s.nawrocki@samsung.com>
References: <1364321663-21010-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/media/exynos4-fimc-is.txt  |   45 ++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos4-fimc-is.txt

diff --git a/Documentation/devicetree/bindings/media/exynos4-fimc-is.txt b/Documentation/devicetree/bindings/media/exynos4-fimc-is.txt
new file mode 100644
index 0000000..476eac8
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/exynos4-fimc-is.txt
@@ -0,0 +1,45 @@
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
+
+- compatible	: should be "samsung,exynos4212-fimc-is" for Exynos4212 and
+		  Exynos4412 SoCs;
+- reg		: physical base address and size of the device memory mapped
+		  registers;
+- interrupts	: should contain FIMC-IS interrupts;
+- clocks	: list of clock specifiers, corresponding to entries in
+		  clock-names property;
+- clock-names	: must contain "ppmuispx", "ppmuispx", "flite0", "flite1"
+		  entries, matching entries in the clocks property.
+
+pmu subnode
+-----------
+
+Required properties:
+ - reg	: should contain PMU physical base address and size of the memory
+	  mapped registers, size should be 0x3000.
+
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
+- reg		: physical base address and size of the device memory mapped
+		  registers;
+
+For the above nodes it is required to specify a pinctrl state named "default",
+according to the pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt.
-- 
1.7.9.5

