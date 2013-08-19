Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:39220 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3HSKzb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 06:55:31 -0400
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, posciak@google.com, arun.kk@samsung.com,
	shaik.ameer@samsung.com
Subject: [PATCH v2 4/5] [media] exynos-mscl: Add DT bindings for M-Scaler driver
Date: Mon, 19 Aug 2013 16:28:51 +0530
Message-Id: <1376909932-23644-5-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com>
References: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the DT binding documentation for the exynos5
based M-Scaler device driver.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 .../devicetree/bindings/media/exynos5-mscl.txt     |   34 ++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-mscl.txt

diff --git a/Documentation/devicetree/bindings/media/exynos5-mscl.txt b/Documentation/devicetree/bindings/media/exynos5-mscl.txt
new file mode 100644
index 0000000..5c9d1b1
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/exynos5-mscl.txt
@@ -0,0 +1,34 @@
+* Samsung Exynos5 M-Scaler device
+
+M-Scaler is used for scaling, blending, color fill and color space
+conversion on EXYNOS5 SoCs.
+
+Required properties:
+- compatible: should be "samsung,exynos5-mscl"
+- reg: should contain M-Scaler physical address location and length.
+- interrupts: should contain M-Scaler interrupt number
+- clocks: should contain the clock number according to CCF
+- clock-names: should be "mscl"
+
+Example:
+
+	mscl_0: mscl@0x12800000 {
+		compatible = "samsung,exynos5-mscl";
+		reg = <0x12800000 0x1000>;
+		interrupts = <0 220 0>;
+		clocks = <&clock 381>;
+		clock-names = "mscl";
+	};
+
+Aliases:
+Each M-Scaler node should have a numbered alias in the aliases node,
+in the form of msclN, N = 0...2. M-Scaler driver uses these aliases
+to retrieve the device IDs using "of_alias_get_id()" call.
+
+Example:
+
+aliases {
+	mscl0 =&mscl_0;
+	mscl1 =&mscl_1;
+	mscl2 =&mscl_2;
+};
-- 
1.7.9.5

