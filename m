Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34721 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751428AbeETNtR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 May 2018 09:49:17 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>
Cc: linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] ARM: dts: tegra30: Add Memory Client reset to VDE
Date: Sun, 20 May 2018 16:48:46 +0300
Message-Id: <20180520134846.31046-3-digetx@gmail.com>
In-Reply-To: <20180520134846.31046-1-digetx@gmail.com>
References: <20180520134846.31046-1-digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hook up Memory Client reset of the Video Decoder to the decoders DT node.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 arch/arm/boot/dts/tegra30.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 09087b9c5e26..3300ff976053 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -404,7 +404,8 @@
 			     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>; /* SXE interrupt */
 		interrupt-names = "sync-token", "bsev", "sxe";
 		clocks = <&tegra_car TEGRA30_CLK_VDE>;
-		resets = <&tegra_car 61>;
+		reset-names = "vde", "mc";
+		resets = <&tegra_car 61>, <&mc TEGRA30_MC_RESET_VDE>;
 	};
 
 	apbmisc@70000800 {
@@ -712,6 +713,7 @@
 		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
 
 		#iommu-cells = <1>;
+		#reset-cells = <1>;
 	};
 
 	fuse@7000f800 {
-- 
2.17.0
