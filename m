Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50958 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaCSHNl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Mar 2014 03:13:41 -0400
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: s.nawrocki@samsung.com, m.chehab@samsung.com,
	b.zolnierkie@samsung.com, t.figa@samsung.com, k.debski@samsung.com,
	arun.kk@samsung.com, shaik.ameer@samsung.com
Subject: [PATCH v6 1/4] [media] exynos-scaler: Add DT bindings for SCALER driver
Date: Wed, 19 Mar 2014 12:43:13 +0530
Message-Id: <1395213196-25972-2-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1395213196-25972-1-git-send-email-shaik.ameer@samsung.com>
References: <1395213196-25972-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the DT binding documentation for the Exynos5420/5410
based SCALER device driver.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 .../devicetree/bindings/media/exynos5-scaler.txt   |   24 ++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-scaler.txt

diff --git a/Documentation/devicetree/bindings/media/exynos5-scaler.txt b/Documentation/devicetree/bindings/media/exynos5-scaler.txt
new file mode 100644
index 0000000..e1dd465
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/exynos5-scaler.txt
@@ -0,0 +1,24 @@
+* Samsung Exynos5 SCALER device
+
+SCALER is used for scaling, blending, color fill and color space
+conversion on EXYNOS[5420/5410] SoCs.
+
+Required properties:
+- compatible: should be "samsung,exynos5420-scaler" or
+			"samsung,exynos5410-scaler"
+- reg: should contain SCALER physical address location and length
+- interrupts: should contain SCALER interrupt specifier
+- clocks: should contain the SCALER clock phandle and specifier pair for
+		each clock listed in clock-names property, according to
+		the common clock bindings
+- clock-names: should contain exactly one entry
+		- "scaler" - IP bus clock
+
+Example:
+	scaler_0: scaler@12800000 {
+		compatible = "samsung,exynos5420-scaler";
+		reg = <0x12800000 0x1000>;
+		interrupts = <0 220 0>;
+		clocks = <&clock 381>;
+		clock-names = "scaler";
+	};
-- 
1.7.9.5

