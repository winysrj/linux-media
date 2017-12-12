Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:32833 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbdLLA0p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 19:26:45 -0500
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Vladimir Zapolskiy <vz@mleia.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 4/4] ARM: dts: tegra20: Add video decoder node
Date: Tue, 12 Dec 2017 03:26:10 +0300
Message-Id: <e80456489c7802e768883ded842e7818158168c4.1513038011.git.digetx@gmail.com>
In-Reply-To: <cover.1513038011.git.digetx@gmail.com>
References: <cover.1513038011.git.digetx@gmail.com>
In-Reply-To: <cover.1513038011.git.digetx@gmail.com>
References: <cover.1513038011.git.digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Video Decoder Engine device node.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 arch/arm/boot/dts/tegra20.dtsi | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 36909df653c3..864a95872b8d 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -16,6 +16,11 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0 0x40000000 0x40000>;
+
+		vde_pool: vde {
+			reg = <0x400 0x3fc00>;
+			pool;
+		};
 	};
 
 	host1x@50000000 {
@@ -258,6 +263,28 @@
 		*/
 	};
 
+	vde@6001a000 {
+		compatible = "nvidia,tegra20-vde";
+		reg = <0x6001a000 0x1000   /* Syntax Engine */
+		       0x6001b000 0x1000   /* Video Bitstream Engine */
+		       0x6001c000  0x100   /* Macroblock Engine */
+		       0x6001c200  0x100   /* Post-processing Engine */
+		       0x6001c400  0x100   /* Motion Compensation Engine */
+		       0x6001c600  0x100   /* Transform Engine */
+		       0x6001c800  0x100   /* Pixel prediction block */
+		       0x6001ca00  0x100   /* Video DMA */
+		       0x6001d800  0x300>; /* Video frame controls */
+		reg-names = "sxe", "bsev", "mbe", "ppe", "mce",
+			    "tfe", "ppb", "vdma", "frameid";
+		iram = <&vde_pool>; /* IRAM region */
+		interrupts = <GIC_SPI  9 IRQ_TYPE_LEVEL_HIGH>, /* Sync token interrupt */
+			     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>, /* BSE-V interrupt */
+			     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>; /* SXE interrupt */
+		interrupt-names = "sync-token", "bsev", "sxe";
+		clocks = <&tegra_car TEGRA20_CLK_VDE>;
+		resets = <&tegra_car 61>;
+	};
+
 	apbmisc@70000800 {
 		compatible = "nvidia,tegra20-apbmisc";
 		reg = <0x70000800 0x64   /* Chip revision */
-- 
2.15.1
