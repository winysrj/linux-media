Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43724 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3ILNGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 09:06:23 -0400
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, posciak@google.com, inki.dae@samsung.com,
	hverkuil@xs4all.nl, shaik.ameer@samsung.com
Subject: [PATCH v3 4/4] [media] exynos-scaler: Add DT bindings for SCALER driver
Date: Thu, 12 Sep 2013 18:39:31 +0530
Message-Id: <1378991371-24428-5-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1378991371-24428-1-git-send-email-shaik.ameer@samsung.com>
References: <1378991371-24428-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the DT binding documentation for the
Exynos5420/5410 based SCALER device driver.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 .../devicetree/bindings/media/exynos5-scaler.txt   |   22 ++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-scaler.txt

diff --git a/Documentation/devicetree/bindings/media/exynos5-scaler.txt b/Documentation/devicetree/bindings/media/exynos5-scaler.txt
new file mode 100644
index 0000000..f620baf
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/exynos5-scaler.txt
@@ -0,0 +1,22 @@
+* Samsung Exynos5 SCALER device
+
+SCALER is used for scaling, blending, color fill and color space
+conversion on EXYNOS[5420/5410] SoCs.
+
+Required properties:
+- compatible: should be "samsung,exynos5420-scaler" or
+			"samsung,exynos5410-scaler"
+- reg: should contain SCALER physical address location and length.
+- interrupts: should contain SCALER interrupt number
+- clocks: should contain the SCALER clock specifier, from the
+			common clock bindings
+- clock-names: should be "scaler"
+
+Example:
+	scaler_0: scaler@0x12800000 {
+		compatible = "samsung,exynos5420-scaler";
+		reg = <0x12800000 0x1000>;
+		interrupts = <0 220 0>;
+		clocks = <&clock 381>;
+		clock-names = "scaler";
+	};
-- 
1.7.9.5

