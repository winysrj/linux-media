Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:25362 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3HEM1Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 08:27:24 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Tomasz Figa <t.figa@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Rob Herring <robherring2@gmail.com>,
	Olof Johansson <olof@lixom.net>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 1/2] ARM: Exynos: replace custom MFC reserved memory handling
 with generic code
Date: Mon, 05 Aug 2013 14:26:49 +0200
Message-id: <1375705610-12724-2-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1375705610-12724-1-git-send-email-m.szyprowski@samsung.com>
References: <1375705610-12724-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MFC driver use custom bindings for managing reserved memory. Those bindings
are not really specific to MFC device and no even well discussed. They can
be easily replaced with generic, platform independent code for handling
reserved and contiguous memory.

Two additional child devices for each memory port (AXI master) are
introduced to let one assign some properties to each of them. Later one
can also use them to assign properties related to SYSMMU controllers,
which can be used to manage the limited dma window provided by those
memory ports.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 .../devicetree/bindings/media/s5p-mfc.txt          |   63 +++++++++++++++++---
 arch/arm/boot/dts/exynos4.dtsi                     |   10 +++-
 arch/arm/boot/dts/exynos4210-origen.dts            |   25 +++++++-
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |   25 +++++++-
 arch/arm/boot/dts/exynos4412-origen.dts            |   25 +++++++-
 arch/arm/boot/dts/exynos4412-smdk4412.dts          |   25 +++++++-
 arch/arm/boot/dts/exynos5250-arndale.dts           |   26 +++++++-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   26 +++++++-
 arch/arm/boot/dts/exynos5250.dtsi                  |   10 +++-
 arch/arm/mach-exynos/mach-exynos4-dt.c             |   16 -----
 arch/arm/mach-exynos/mach-exynos5-dt.c             |   17 ------
 arch/arm/plat-samsung/include/plat/mfc.h           |   11 ----
 arch/arm/plat-samsung/s5p-dev-mfc.c                |   32 ----------
 13 files changed, 212 insertions(+), 99 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
index df37b02..d9528d4 100644
--- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
+++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
@@ -6,10 +6,17 @@ The MFC device driver is a v4l2 driver which can encode/decode
 video raw/elementary streams and has support for all popular
 video codecs.
 
+The MFC device is connected to system bus with two memory ports (AXI
+masters) for better performance. Those memory ports are modelled as
+separate child devices, so one can assign some properties to them (like
+memory region for dma buffer allocation or sysmmu controller).
+
 Required properties:
   - compatible : value should be either one among the following
 	(a) "samsung,mfc-v5" for MFC v5 present in Exynos4 SoCs
 	(b) "samsung,mfc-v6" for MFC v6 present in Exynos5 SoCs
+	and additionally "simple-bus" to correctly initialize child
+	devices for memory ports (AXI masters)
 
   - reg : Physical base address of the IP registers and length of memory
 	  mapped region.
@@ -19,31 +26,69 @@ Required properties:
   - clock-names : from common clock binding: must contain "sclk_mfc" and "mfc",
 		  corresponding to entries in the clocks property.
 
-  - samsung,mfc-r : Base address of the first memory bank used by MFC
-		    for DMA contiguous memory allocation and its size.
-
-  - samsung,mfc-l : Base address of the second memory bank used by MFC
-		    for DMA contiguous memory allocation and its size.
-
 Optional properties:
   - samsung,power-domain : power-domain property defined with a phandle
 			   to respective power domain.
 
+Two child nodes must be defined for MFC device. Their names must be
+following: "memport-r" and "memport-l" ("right" and "left"). Required
+properties:
+  - compatible : value should be "samsung,memport"
+  - dma-memory-region : optional property with a phandle to respective memory
+			region (see devicetree/bindings/memory.txt), if no region
+			is defined, sysmmu controller must be used for managing
+			limited dma window of each memory port.
+
+
 Example:
 SoC specific DT entry:
 
 mfc: codec@13400000 {
-	compatible = "samsung,mfc-v5";
+	compatible = "samsung,mfc-v5", "simple-bus";
 	reg = <0x13400000 0x10000>;
 	interrupts = <0 94 0>;
 	samsung,power-domain = <&pd_mfc>;
 	clocks = <&clock 170>, <&clock 273>;
 	clock-names = "sclk_mfc", "mfc";
+	status = "disabled";
+
+	mfc_r: memport-r {
+		compatible = "samsung,memport";
+	};
+
+	mfc_l: memport-l {
+		compatible = "samsung,memport";
+	};
 };
 
 Board specific DT entry:
 
+memory {
+	/* ... */
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		mfc_l_mem: mfc_l_region@43000000 {
+			compatible = "contiguous-memory-region", "reserved-memory-region";
+			reg = <0x43000000 0x1000000>;
+		};
+
+		mfc_r_mem: mfc_r_region@52000000 {
+			compatible = "contiguous-memory-region", "reserved-memory-region";
+			reg = <0x52000000 0x1000000>;
+		};
+	};
+};
+
 codec@13400000 {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	status = "okay";
+
+	memport-r {
+		dma-memory-region = <&mfc_r_mem>;
+	};
+
+	memport-l {
+		dma-memory-region = <&mfc_l_mem>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 3f94fe8..599637f 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -156,13 +156,21 @@
 	};
 
 	mfc: codec@13400000 {
-		compatible = "samsung,mfc-v5";
+		compatible = "samsung,mfc-v5", "simple-bus";
 		reg = <0x13400000 0x10000>;
 		interrupts = <0 94 0>;
 		samsung,power-domain = <&pd_mfc>;
 		clocks = <&clock 170>, <&clock 273>;
 		clock-names = "sclk_mfc", "mfc";
 		status = "disabled";
+
+		mfc_r: memport-r {
+			compatible = "samsung,memport";
+		};
+
+		mfc_l: memport-l {
+			compatible = "samsung,memport";
+		};
 	};
 
 	serial@13800000 {
diff --git a/arch/arm/boot/dts/exynos4210-origen.dts b/arch/arm/boot/dts/exynos4210-origen.dts
index 382d8c7..e80fe8a 100644
--- a/arch/arm/boot/dts/exynos4210-origen.dts
+++ b/arch/arm/boot/dts/exynos4210-origen.dts
@@ -26,6 +26,21 @@
 		       0x50000000 0x10000000
 		       0x60000000 0x10000000
 		       0x70000000 0x10000000>;
+
+		reserved-memory {
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			mfc_l_mem: mfc_l_region@43000000 {
+				compatible = "contiguous-memory-region", "reserved-memory-region";
+				reg = <0x43000000 0x1000000>;
+			};
+
+			mfc_r_mem: mfc_r_region@51000000 {
+				compatible = "contiguous-memory-region", "reserved-memory-region";
+				reg = <0x51000000 0x1000000>;
+			};
+		};
 	};
 
 	chosen {
@@ -66,9 +81,15 @@
 	};
 
 	codec@13400000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
 		status = "okay";
+
+		memport-r {
+			dma-memory-region = <&mfc_r_mem>;
+		};
+
+		memport-l {
+			dma-memory-region = <&mfc_l_mem>;
+		};
 	};
 
 	serial@13800000 {
diff --git a/arch/arm/boot/dts/exynos4210-smdkv310.dts b/arch/arm/boot/dts/exynos4210-smdkv310.dts
index 9c01b71..07adb56 100644
--- a/arch/arm/boot/dts/exynos4210-smdkv310.dts
+++ b/arch/arm/boot/dts/exynos4210-smdkv310.dts
@@ -23,6 +23,21 @@
 
 	memory {
 		reg = <0x40000000 0x80000000>;
+
+		reserved-memory {
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			mfc_l_mem: mfc_l_region@43000000 {
+				compatible = "contiguous-memory-region", "reserved-memory-region";
+				reg = <0x43000000 0x1000000>;
+			};
+
+			mfc_r_mem: mfc_r_region@51000000 {
+				compatible = "contiguous-memory-region", "reserved-memory-region";
+				reg = <0x51000000 0x1000000>;
+			};
+		};
 	};
 
 	chosen {
@@ -41,9 +56,15 @@
 	};
 
 	codec@13400000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
 		status = "okay";
+
+		memport-r {
+			dma-memory-region = <&mfc_r_mem>;
+		};
+
+		memport-l {
+			dma-memory-region = <&mfc_l_mem>;
+		};
 	};
 
 	serial@13800000 {
diff --git a/arch/arm/boot/dts/exynos4412-origen.dts b/arch/arm/boot/dts/exynos4412-origen.dts
index 7993641..1421070 100644
--- a/arch/arm/boot/dts/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/exynos4412-origen.dts
@@ -21,6 +21,21 @@
 
 	memory {
 		reg = <0x40000000 0x40000000>;
+
+		reserved-memory {
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			mfc_l_mem: mfc_l_region@43000000 {
+				compatible = "contiguous-memory-region", "reserved-memory-region";
+				reg = <0x43000000 0x1000000>;
+			};
+
+			mfc_r_mem: mfc_r_region@51000000 {
+				compatible = "contiguous-memory-region", "reserved-memory-region";
+				reg = <0x51000000 0x1000000>;
+			};
+		};
 	};
 
 	chosen {
@@ -133,9 +148,15 @@
 	};
 
 	codec@13400000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
 		status = "okay";
+
+		memport-r {
+			dma-memory-region = <&mfc_r_mem>;
+		};
+
+		memport-l {
+			dma-memory-region = <&mfc_l_mem>;
+		};
 	};
 
 	fimd@11c00000 {
diff --git a/arch/arm/boot/dts/exynos4412-smdk4412.dts b/arch/arm/boot/dts/exynos4412-smdk4412.dts
index ad316a1..08a3735 100644
--- a/arch/arm/boot/dts/exynos4412-smdk4412.dts
+++ b/arch/arm/boot/dts/exynos4412-smdk4412.dts
@@ -21,6 +21,21 @@
 
 	memory {
 		reg = <0x40000000 0x40000000>;
+
+		reserved-memory {
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			mfc_l_mem: mfc_l_region@43000000 {
+				compatible = "contiguous-memory-region", "reserved-memory-region";
+				reg = <0x43000000 0x1000000>;
+			};
+
+			mfc_r_mem: mfc_r_region@51000000 {
+				compatible = "contiguous-memory-region", "reserved-memory-region";
+				reg = <0x51000000 0x1000000>;
+			};
+		};
 	};
 
 	chosen {
@@ -126,9 +141,15 @@
 	};
 
 	codec@13400000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
 		status = "okay";
+
+		memport-r {
+			dma-memory-region = <&mfc_r_mem>;
+		};
+
+		memport-l {
+			dma-memory-region = <&mfc_l_mem>;
+		};
 	};
 
 	serial@13800000 {
diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index abc7272..ba4a533 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -18,6 +18,21 @@
 
 	memory {
 		reg = <0x40000000 0x80000000>;
+
+		reserved-memory {
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			mfc_l_mem: mfc_l_region@43000000 {
+				compatible = "contiguous-memory-region", "reserved-memory-region";
+				reg = <0x43000000 0x1000000>;
+			};
+
+			mfc_r_mem: mfc_r_region@51000000 {
+				compatible = "contiguous-memory-region", "reserved-memory-region";
+				reg = <0x51000000 0x1000000>;
+			};
+		};
 	};
 
 	chosen {
@@ -25,8 +40,15 @@
 	};
 
 	codec@11000000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
+		status = "okay";
+
+		memport-r {
+			dma-memory-region = <&mfc_r_mem>;
+		};
+
+		memport-l {
+			dma-memory-region = <&mfc_l_mem>;
+		};
 	};
 
 	i2c@12C60000 {
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 49f18c2..daed15e 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -21,6 +21,21 @@
 
 	memory {
 		reg = <0x40000000 0x80000000>;
+
+		reserved-memory {
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			mfc_l_mem: mfc_l_region@43000000 {
+				compatible = "contiguous-memory-region", "reserved-memory-region";
+				reg = <0x43000000 0x1000000>;
+			};
+
+			mfc_r_mem: mfc_r_region@51000000 {
+				compatible = "contiguous-memory-region", "reserved-memory-region";
+				reg = <0x51000000 0x1000000>;
+			};
+		};
 	};
 
 	chosen {
@@ -223,8 +238,15 @@
 	};
 
 	codec@11000000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
+		status = "okay";
+
+		memport-r {
+			dma-memory-region = <&mfc_r_mem>;
+		};
+
+		memport-l {
+			dma-memory-region = <&mfc_l_mem>;
+		};
 	};
 
 	i2s0: i2s@03830000 {
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index ef57277..6011518 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -164,10 +164,18 @@
 	};
 
 	codec@11000000 {
-		compatible = "samsung,mfc-v6";
+		compatible = "samsung,mfc-v6", "simple-bus";
 		reg = <0x11000000 0x10000>;
 		interrupts = <0 96 0>;
 		samsung,power-domain = <&pd_mfc>;
+
+		mfc_r: memport-r {
+			compatible = "samsung,memport";
+		};
+
+		mfc_l: memport-l {
+			compatible = "samsung,memport";
+		};
 	};
 
 	rtc {
diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
index 0099c6c..0b6da39 100644
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
@@ -13,13 +13,10 @@
 
 #include <linux/kernel.h>
 #include <linux/of_platform.h>
-#include <linux/of_fdt.h>
 #include <linux/serial_core.h>
-#include <linux/memblock.h>
 #include <linux/clocksource.h>
 
 #include <asm/mach/arch.h>
-#include <plat/mfc.h>
 
 #include "common.h"
 
@@ -35,18 +32,6 @@ static char const *exynos4_dt_compat[] __initdata = {
 	NULL
 };
 
-static void __init exynos4_reserve(void)
-{
-#ifdef CONFIG_S5P_DEV_MFC
-	struct s5p_mfc_dt_meminfo mfc_mem;
-
-	/* Reserve memory for MFC only if it's available */
-	mfc_mem.compatible = "samsung,mfc-v5";
-	if (of_scan_flat_dt(s5p_fdt_find_mfc_mem, &mfc_mem))
-		s5p_mfc_reserve_mem(mfc_mem.roff, mfc_mem.rsize, mfc_mem.loff,
-				mfc_mem.lsize);
-#endif
-}
 DT_MACHINE_START(EXYNOS4210_DT, "Samsung Exynos4 (Flattened Device Tree)")
 	/* Maintainer: Thomas Abraham <thomas.abraham@linaro.org> */
 	.smp		= smp_ops(exynos_smp_ops),
@@ -57,5 +42,4 @@ DT_MACHINE_START(EXYNOS4210_DT, "Samsung Exynos4 (Flattened Device Tree)")
 	.init_time	= exynos_init_time,
 	.dt_compat	= exynos4_dt_compat,
 	.restart        = exynos4_restart,
-	.reserve	= exynos4_reserve,
 MACHINE_END
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index f874b77..b5b0571 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -10,16 +10,13 @@
 */
 
 #include <linux/of_platform.h>
-#include <linux/of_fdt.h>
 #include <linux/memblock.h>
-#include <linux/io.h>
 #include <linux/clocksource.h>
 
 #include <asm/mach/arch.h>
 #include <mach/regs-pmu.h>
 
 #include <plat/cpu.h>
-#include <plat/mfc.h>
 
 #include "common.h"
 
@@ -57,19 +54,6 @@ static char const *exynos5_dt_compat[] __initdata = {
 	NULL
 };
 
-static void __init exynos5_reserve(void)
-{
-#ifdef CONFIG_S5P_DEV_MFC
-	struct s5p_mfc_dt_meminfo mfc_mem;
-
-	/* Reserve memory for MFC only if it's available */
-	mfc_mem.compatible = "samsung,mfc-v6";
-	if (of_scan_flat_dt(s5p_fdt_find_mfc_mem, &mfc_mem))
-		s5p_mfc_reserve_mem(mfc_mem.roff, mfc_mem.rsize, mfc_mem.loff,
-				mfc_mem.lsize);
-#endif
-}
-
 DT_MACHINE_START(EXYNOS5_DT, "SAMSUNG EXYNOS5 (Flattened Device Tree)")
 	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
 	.smp		= smp_ops(exynos_smp_ops),
@@ -79,5 +63,4 @@ DT_MACHINE_START(EXYNOS5_DT, "SAMSUNG EXYNOS5 (Flattened Device Tree)")
 	.init_time	= exynos_init_time,
 	.dt_compat	= exynos5_dt_compat,
 	.restart        = exynos5_restart,
-	.reserve	= exynos5_reserve,
 MACHINE_END
diff --git a/arch/arm/plat-samsung/include/plat/mfc.h b/arch/arm/plat-samsung/include/plat/mfc.h
index e6d7c42..ac13227 100644
--- a/arch/arm/plat-samsung/include/plat/mfc.h
+++ b/arch/arm/plat-samsung/include/plat/mfc.h
@@ -10,14 +10,6 @@
 #ifndef __PLAT_SAMSUNG_MFC_H
 #define __PLAT_SAMSUNG_MFC_H __FILE__
 
-struct s5p_mfc_dt_meminfo {
-	unsigned long	loff;
-	unsigned long	lsize;
-	unsigned long	roff;
-	unsigned long	rsize;
-	char		*compatible;
-};
-
 /**
  * s5p_mfc_reserve_mem - function to early reserve memory for MFC driver
  * @rbase:	base address for MFC 'right' memory interface
@@ -32,7 +24,4 @@ struct s5p_mfc_dt_meminfo {
 void __init s5p_mfc_reserve_mem(phys_addr_t rbase, unsigned int rsize,
 				phys_addr_t lbase, unsigned int lsize);
 
-int __init s5p_fdt_find_mfc_mem(unsigned long node, const char *uname,
-				int depth, void *data);
-
 #endif /* __PLAT_SAMSUNG_MFC_H */
diff --git a/arch/arm/plat-samsung/s5p-dev-mfc.c b/arch/arm/plat-samsung/s5p-dev-mfc.c
index ad51f85..f83be72 100644
--- a/arch/arm/plat-samsung/s5p-dev-mfc.c
+++ b/arch/arm/plat-samsung/s5p-dev-mfc.c
@@ -120,35 +120,3 @@ static int __init s5p_mfc_memory_init(void)
 }
 device_initcall(s5p_mfc_memory_init);
 #endif
-
-#ifdef CONFIG_OF
-int __init s5p_fdt_find_mfc_mem(unsigned long node, const char *uname,
-				int depth, void *data)
-{
-	__be32 *prop;
-	unsigned long len;
-	struct s5p_mfc_dt_meminfo *mfc_mem = data;
-
-	if (!data)
-		return 0;
-
-	if (!of_flat_dt_is_compatible(node, mfc_mem->compatible))
-		return 0;
-
-	prop = of_get_flat_dt_prop(node, "samsung,mfc-l", &len);
-	if (!prop || (len != 2 * sizeof(unsigned long)))
-		return 0;
-
-	mfc_mem->loff = be32_to_cpu(prop[0]);
-	mfc_mem->lsize = be32_to_cpu(prop[1]);
-
-	prop = of_get_flat_dt_prop(node, "samsung,mfc-r", &len);
-	if (!prop || (len != 2 * sizeof(unsigned long)))
-		return 0;
-
-	mfc_mem->roff = be32_to_cpu(prop[0]);
-	mfc_mem->rsize = be32_to_cpu(prop[1]);
-
-	return 1;
-}
-#endif
-- 
1.7.9.5

