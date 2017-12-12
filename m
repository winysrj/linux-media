Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:42141 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbdLLA0l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 19:26:41 -0500
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
Subject: [PATCH v5 1/4] media: dt: bindings: Add binding for NVIDIA Tegra Video Decoder Engine
Date: Tue, 12 Dec 2017 03:26:07 +0300
Message-Id: <155182bb32443b69e457adbd642c12da81b0a241.1513038011.git.digetx@gmail.com>
In-Reply-To: <cover.1513038011.git.digetx@gmail.com>
References: <cover.1513038011.git.digetx@gmail.com>
In-Reply-To: <cover.1513038011.git.digetx@gmail.com>
References: <cover.1513038011.git.digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add binding documentation for the Video Decoder Engine which is found
on NVIDIA Tegra20/30/114/124/132 SoC's.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/media/nvidia,tegra-vde.txt | 55 ++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt

diff --git a/Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt b/Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt
new file mode 100644
index 000000000000..470237ed6fe5
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt
@@ -0,0 +1,55 @@
+NVIDIA Tegra Video Decoder Engine
+
+Required properties:
+- compatible : Must contain one of the following values:
+   - "nvidia,tegra20-vde"
+   - "nvidia,tegra30-vde"
+   - "nvidia,tegra114-vde"
+   - "nvidia,tegra124-vde"
+   - "nvidia,tegra132-vde"
+- reg : Must contain an entry for each entry in reg-names.
+- reg-names : Must include the following entries:
+  - sxe
+  - bsev
+  - mbe
+  - ppe
+  - mce
+  - tfe
+  - ppb
+  - vdma
+  - frameid
+- iram : Must contain phandle to the mmio-sram device node that represents
+         IRAM region used by VDE.
+- interrupts : Must contain an entry for each entry in interrupt-names.
+- interrupt-names : Must include the following entries:
+  - sync-token
+  - bsev
+  - sxe
+- clocks : Must include the following entries:
+  - vde
+- resets : Must include the following entries:
+  - vde
+
+Example:
+
+video-codec@6001a000 {
+	compatible = "nvidia,tegra20-vde";
+	reg = <0x6001a000 0x1000 /* Syntax Engine */
+	       0x6001b000 0x1000 /* Video Bitstream Engine */
+	       0x6001c000  0x100 /* Macroblock Engine */
+	       0x6001c200  0x100 /* Post-processing Engine */
+	       0x6001c400  0x100 /* Motion Compensation Engine */
+	       0x6001c600  0x100 /* Transform Engine */
+	       0x6001c800  0x100 /* Pixel prediction block */
+	       0x6001ca00  0x100 /* Video DMA */
+	       0x6001d800  0x300 /* Video frame controls */>;
+	reg-names = "sxe", "bsev", "mbe", "ppe", "mce",
+		    "tfe", "ppb", "vdma", "frameid";
+	iram = <&vde_pool>; /* IRAM region */
+	interrupts = <GIC_SPI  9 IRQ_TYPE_LEVEL_HIGH>, /* Sync token interrupt */
+		     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>, /* BSE-V interrupt */
+		     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>; /* SXE interrupt */
+	interrupt-names = "sync-token", "bsev", "sxe";
+	clocks = <&tegra_car TEGRA20_CLK_VDE>;
+	resets = <&tegra_car 61>;
+};
-- 
2.15.1
