Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:56412 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752305AbdJSVhi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 17:37:38 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Vladimir Zapolskiy <vz@mleia.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/5] ARM: dts: tegra20: Add video decoder node
Date: Fri, 20 Oct 2017 00:34:24 +0300
Message-Id: <75e7f97c65443cdf064ce743070255625e5cd5b6.1508448293.git.digetx@gmail.com>
In-Reply-To: <cover.1508448293.git.digetx@gmail.com>
References: <cover.1508448293.git.digetx@gmail.com>
In-Reply-To: <cover.1508448293.git.digetx@gmail.com>
References: <cover.1508448293.git.digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Video Decoder Engine device node.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 arch/arm/boot/dts/tegra20.dtsi | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index aaf32f96f1e8..6b2d7bf5c707 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -15,6 +15,11 @@
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
@@ -257,6 +262,28 @@
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
2.14.2
