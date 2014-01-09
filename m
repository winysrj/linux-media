Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41800 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaAID3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 22:29:09 -0500
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: s.nawrocki@samsung.com, posciak@google.com, hverkuil@xs4all.nl,
	shaik.ameer@samsung.com, m.chehab@samsung.com
Subject: [PATCH v5 4/4] [media] exynos-scaler: Add DT bindings for SCALER driver
Date: Thu,  9 Jan 2014 08:58:14 +0530
Message-Id: <1389238094-19386-5-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1389238094-19386-1-git-send-email-shaik.ameer@samsung.com>
References: <1389238094-19386-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the DT binding documentation for the
Exynos5420/5410 based SCALER device driver.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 .../devicetree/bindings/media/exynos5-scaler.txt   |   22 ++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-scaler.txt

diff --git a/Documentation/devicetree/bindings/media/exynos5-scaler.txt b/Documentation/devicetree/bindings/media/exynos5-scaler.txt
new file mode 100644
index 0000000..9328e7d
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
+- reg: should contain SCALER physical address location and length
+- interrupts: should contain SCALER interrupt number
+- clocks: should contain the SCALER clock specifier, from the
+			common clock bindings
+- clock-names: should be "scaler"
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

