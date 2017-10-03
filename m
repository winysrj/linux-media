Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:52532 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751188AbdJCVxw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Oct 2017 17:53:52 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ARM: dts: tegra20: Add video decoder node
Date: Wed,  4 Oct 2017 00:51:54 +0300
Message-Id: <5221e5ea893321d6655cdb136dea3e9294ff8a5d.1507063619.git.digetx@gmail.com>
In-Reply-To: <cover.1507063619.git.digetx@gmail.com>
References: <cover.1507063619.git.digetx@gmail.com>
In-Reply-To: <cover.1507063619.git.digetx@gmail.com>
References: <cover.1507063619.git.digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a device node for the video decoder engine found on Tegra20.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 arch/arm/boot/dts/tegra20.dtsi | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 7c85f97f72ea..1b5d54b6c0cb 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -249,6 +249,23 @@
 		*/
 	};
 
+	vde@6001a000 {
+		compatible = "nvidia,tegra20-vde";
+		reg = <0x6001a000 0x3D00    /* VDE registers */
+		       0x40000400 0x3FC00>; /* IRAM region */
+		reg-names = "regs", "iram";
+		interrupts = <GIC_SPI  8 IRQ_TYPE_LEVEL_HIGH>, /* UCQ error interrupt */
+			     <GIC_SPI  9 IRQ_TYPE_LEVEL_HIGH>, /* Sync token interrupt */
+			     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>, /* BSE-V interrupt */
+			     <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>, /* BSE-A interrupt */
+			     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>; /* SXE interrupt */
+		interrupt-names = "ucq-error", "sync-token", "bsev", "bsea", "sxe";
+		clocks = <&tegra_car TEGRA20_CLK_VDE>;
+		clock-names = "vde";
+		resets = <&tegra_car 61>;
+		reset-names = "vde";
+	};
+
 	apbmisc@70000800 {
 		compatible = "nvidia,tegra20-apbmisc";
 		reg = <0x70000800 0x64   /* Chip revision */
-- 
2.14.1
