Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:56010 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729928AbeHMRd1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 13:33:27 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 12/14] ARM: tegra: Add BSEV clock and reset for VDE on Tegra20
Date: Mon, 13 Aug 2018 16:50:25 +0200
Message-Id: <20180813145027.16346-13-thierry.reding@gmail.com>
In-Reply-To: <20180813145027.16346-1-thierry.reding@gmail.com>
References: <20180813145027.16346-1-thierry.reding@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Thierry Reding <treding@nvidia.com>

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/boot/dts/tegra20.dtsi | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 15b73bd377f0..abb5738a0705 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -287,9 +287,13 @@
 			     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>, /* BSE-V interrupt */
 			     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>; /* SXE interrupt */
 		interrupt-names = "sync-token", "bsev", "sxe";
-		clocks = <&tegra_car TEGRA20_CLK_VDE>;
-		reset-names = "vde", "mc";
-		resets = <&tegra_car 61>, <&mc TEGRA20_MC_RESET_VDE>;
+		clocks = <&tegra_car TEGRA20_CLK_VDE>,
+			 <&tegra_car TEGRA20_CLK_BSEV>;
+		clock-names = "vde", "bsev";
+		resets = <&tegra_car 61>,
+			 <&tegra_car 63>,
+			 <&mc TEGRA20_MC_RESET_VDE>;
+		reset-names = "vde", "bsev", "mc";
 	};
 
 	apbmisc@70000800 {
-- 
2.17.0
