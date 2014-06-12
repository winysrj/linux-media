Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33048 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbaFLRGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:46 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 25/26] ARM: dts: Add IPU aliases on i.MX6
Date: Thu, 12 Jun 2014 19:06:39 +0200
Message-Id: <1402592800-2925-26-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/boot/dts/imx6q.dtsi   | 1 +
 arch/arm/boot/dts/imx6qdl.dtsi | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index fb6185f..919a18a 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -14,6 +14,7 @@
 
 / {
 	aliases {
+		ipu1 = &ipu2;
 		spi4 = &ecspi5;
 	};
 
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 84ddc94..27303d6 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -28,6 +28,7 @@
 		i2c0 = &i2c1;
 		i2c1 = &i2c2;
 		i2c2 = &i2c3;
+		ipu0 = &ipu1;
 		mmc0 = &usdhc1;
 		mmc1 = &usdhc2;
 		mmc2 = &usdhc3;
-- 
2.0.0.rc2

