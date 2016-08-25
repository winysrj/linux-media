Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34161 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757777AbcHYJkE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 05:40:04 -0400
From: Florent Revest <florent.revest@free-electrons.com>
To: linux-media@vger.kernel.org
Cc: florent.revest@free-electrons.com, linux-sunxi@googlegroups.com,
        maxime.ripard@free-electrons.com, posciak@chromium.org,
        hans.verkuil@cisco.com, thomas.petazzoni@free-electrons.com,
        mchehab@kernel.org, linux-kernel@vger.kernel.org, wens@csie.org
Subject: [RFC 01/10] clk: sunxi-ng: Add a couple of A13 clocks
Date: Thu, 25 Aug 2016 11:39:40 +0200
Message-Id: <1472117989-21455-2-git-send-email-florent.revest@free-electrons.com>
In-Reply-To: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
References: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new style driver for the clock control unit in Allwinner A13.

Only AVS and VE are supported since they weren't provided until now and are
needed for "sunxi-cedrus".

Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
---
 .../devicetree/bindings/clock/sunxi-ccu.txt        |  1 +
 arch/arm/boot/dts/sun5i-a13.dtsi                   | 11 +++
 drivers/clk/sunxi-ng/Kconfig                       | 11 +++
 drivers/clk/sunxi-ng/Makefile                      |  1 +
 drivers/clk/sunxi-ng/ccu-sun5i-a13.c               | 80 ++++++++++++++++++++++
 drivers/clk/sunxi-ng/ccu-sun5i-a13.h               | 25 +++++++
 include/dt-bindings/clock/sun5i-a13-ccu.h          | 49 +++++++++++++
 include/dt-bindings/reset/sun5i-a13-ccu.h          | 48 +++++++++++++
 8 files changed, 226 insertions(+)
 create mode 100644 drivers/clk/sunxi-ng/ccu-sun5i-a13.c
 create mode 100644 drivers/clk/sunxi-ng/ccu-sun5i-a13.h
 create mode 100644 include/dt-bindings/clock/sun5i-a13-ccu.h
 create mode 100644 include/dt-bindings/reset/sun5i-a13-ccu.h

diff --git a/Documentation/devicetree/bindings/clock/sunxi-ccu.txt b/Documentation/devicetree/bindings/clock/sunxi-ccu.txt
index cb91507..7bb7a6a 100644
--- a/Documentation/devicetree/bindings/clock/sunxi-ccu.txt
+++ b/Documentation/devicetree/bindings/clock/sunxi-ccu.txt
@@ -4,6 +4,7 @@ Allwinner Clock Control Unit Binding
 Required properties :
 - compatible: must contain one of the following compatible:
 		- "allwinner,sun8i-h3-ccu"
+		- "allwinner,sun5i-a13-ccu"
 
 - reg: Must contain the registers base address and length
 - clocks: phandle to the oscillators feeding the CCU. Two are needed:
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index e012890..2afe05fb 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -46,8 +46,10 @@
 
 #include "sun5i.dtsi"
 
+#include <dt-bindings/clock/sun5i-a13-ccu.h>
 #include <dt-bindings/pinctrl/sun4i-a10.h>
 #include <dt-bindings/thermal/thermal.h>
+#include <dt-bindings/reset/sun5i-a13-ccu.h>
 
 / {
 	interrupt-parent = <&intc>;
@@ -327,6 +329,15 @@
 				};
 			};
 		};
+
+		ccu: clock@01c20000 {
+			compatible = "allwinner,sun5i-a13-ccu";
+			reg = <0x01c20000 0x400>;
+			clocks = <&osc24M>, <&osc32k>;
+			clock-names = "hosc", "losc";
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+		};
 	};
 };
 
diff --git a/drivers/clk/sunxi-ng/Kconfig b/drivers/clk/sunxi-ng/Kconfig
index 2afcbd3..8faba4e 100644
--- a/drivers/clk/sunxi-ng/Kconfig
+++ b/drivers/clk/sunxi-ng/Kconfig
@@ -51,6 +51,17 @@ config SUNXI_CCU_MP
 
 # SoC Drivers
 
+config SUN5I_A13_CCU
+	bool "Support for the Allwinner A13 CCU"
+	select SUNXI_CCU_DIV
+	select SUNXI_CCU_NK
+	select SUNXI_CCU_NKM
+	select SUNXI_CCU_NKMP
+	select SUNXI_CCU_NM
+	select SUNXI_CCU_MP
+	select SUNXI_CCU_PHASE
+	default ARCH_SUN5I
+
 config SUN8I_H3_CCU
 	bool "Support for the Allwinner H3 CCU"
 	select SUNXI_CCU_DIV
diff --git a/drivers/clk/sunxi-ng/Makefile b/drivers/clk/sunxi-ng/Makefile
index 633ce64..1710745 100644
--- a/drivers/clk/sunxi-ng/Makefile
+++ b/drivers/clk/sunxi-ng/Makefile
@@ -17,4 +17,5 @@ obj-$(CONFIG_SUNXI_CCU_NM)	+= ccu_nm.o
 obj-$(CONFIG_SUNXI_CCU_MP)	+= ccu_mp.o
 
 # SoC support
+obj-$(CONFIG_SUN5I_A13_CCU)	+= ccu-sun5i-a13.o
 obj-$(CONFIG_SUN8I_H3_CCU)	+= ccu-sun8i-h3.o
diff --git a/drivers/clk/sunxi-ng/ccu-sun5i-a13.c b/drivers/clk/sunxi-ng/ccu-sun5i-a13.c
new file mode 100644
index 0000000..7f1da20
--- /dev/null
+++ b/drivers/clk/sunxi-ng/ccu-sun5i-a13.c
@@ -0,0 +1,80 @@
+/*
+ * Copyright (c) 2016 Maxime Ripard. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/of_address.h>
+
+#include "ccu_common.h"
+#include "ccu_reset.h"
+
+#include "ccu_div.h"
+#include "ccu_gate.h"
+#include "ccu_mp.h"
+#include "ccu_mult.h"
+#include "ccu_nk.h"
+#include "ccu_nkm.h"
+#include "ccu_nkmp.h"
+#include "ccu_nm.h"
+#include "ccu_phase.h"
+
+#include "ccu-sun5i-a13.h"
+
+static SUNXI_CCU_GATE(ve_clk, "ve", "pll4",
+		      0x13c, BIT(31), CLK_SET_RATE_PARENT);
+
+static SUNXI_CCU_GATE(avs_clk,	"avs",	"osc24M",
+		      0x144, BIT(31), 0);
+
+static struct ccu_common *sun5i_a13_ccu_clks[] = {
+	&ve_clk.common,
+	&avs_clk.common,
+};
+
+static struct clk_hw_onecell_data sun5i_a13_hw_clks = {
+	.hws	= {
+		[CLK_VE]		= &ve_clk.common.hw,
+		[CLK_AVS]		= &avs_clk.common.hw,
+	},
+	.num	= CLK_NUMBER,
+};
+
+static struct ccu_reset_map sun5i_a13_ccu_resets[] = {
+	[RST_VE]		=  { 0x13c, BIT(0) },
+};
+
+static const struct sunxi_ccu_desc sun5i_a13_ccu_desc = {
+	.ccu_clks	= sun5i_a13_ccu_clks,
+	.num_ccu_clks	= ARRAY_SIZE(sun5i_a13_ccu_clks),
+
+	.hw_clks	= &sun5i_a13_hw_clks,
+
+	.resets		= sun5i_a13_ccu_resets,
+	.num_resets	= ARRAY_SIZE(sun5i_a13_ccu_resets),
+};
+
+static void __init sun5i_a13_ccu_setup(struct device_node *node)
+{
+	void __iomem *reg;
+
+	reg = of_iomap(node, 0);
+	if (IS_ERR(reg)) {
+		pr_err("%s: Could not map the clock registers\n",
+		       of_node_full_name(node));
+		return;
+	}
+
+	sunxi_ccu_probe(node, reg, &sun5i_a13_ccu_desc);
+}
+
+CLK_OF_DECLARE(sun5i_A13_ccu, "allwinner,sun5i-a13-ccu",
+	       sun5i_a13_ccu_setup);
diff --git a/drivers/clk/sunxi-ng/ccu-sun5i-a13.h b/drivers/clk/sunxi-ng/ccu-sun5i-a13.h
new file mode 100644
index 0000000..a52af0b
--- /dev/null
+++ b/drivers/clk/sunxi-ng/ccu-sun5i-a13.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright 2016 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _CCU_SUN5I_A13_H_
+#define _CCU_SUN5I_A13_H_
+
+#include <dt-bindings/clock/sun5i-a13-ccu.h>
+#include <dt-bindings/reset/sun5i-a13-ccu.h>
+
+#define CLK_NUMBER		2
+
+#endif /* _CCU_SUN5I_A13_H_ */
diff --git a/include/dt-bindings/clock/sun5i-a13-ccu.h b/include/dt-bindings/clock/sun5i-a13-ccu.h
new file mode 100644
index 0000000..1218338
--- /dev/null
+++ b/include/dt-bindings/clock/sun5i-a13-ccu.h
@@ -0,0 +1,49 @@
+/*
+ * Copyright (C) 2016 Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This file is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This file is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ * Or, alternatively,
+ *
+ *  b) Permission is hereby granted, free of charge, to any person
+ *     obtaining a copy of this software and associated documentation
+ *     files (the "Software"), to deal in the Software without
+ *     restriction, including without limitation the rights to use,
+ *     copy, modify, merge, publish, distribute, sublicense, and/or
+ *     sell copies of the Software, and to permit persons to whom the
+ *     Software is furnished to do so, subject to the following
+ *     conditions:
+ *
+ *     The above copyright notice and this permission notice shall be
+ *     included in all copies or substantial portions of the Software.
+ *
+ *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
+ *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+ *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
+ *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ *     OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef _DT_BINDINGS_CLK_SUN8I_a13_H_
+#define _DT_BINDINGS_CLK_SUN8I_a13_H_
+
+#define CLK_VE			0
+#define CLK_AVS			1
+
+#endif /* _DT_BINDINGS_CLK_SUN8I_A13_H_ */
diff --git a/include/dt-bindings/reset/sun5i-a13-ccu.h b/include/dt-bindings/reset/sun5i-a13-ccu.h
new file mode 100644
index 0000000..f20b4f6
--- /dev/null
+++ b/include/dt-bindings/reset/sun5i-a13-ccu.h
@@ -0,0 +1,48 @@
+/*
+ * Copyright (C) 2016 Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This file is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This file is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ * Or, alternatively,
+ *
+ *  b) Permission is hereby granted, free of charge, to any person
+ *     obtaining a copy of this software and associated documentation
+ *     files (the "Software"), to deal in the Software without
+ *     restriction, including without limitation the rights to use,
+ *     copy, modify, merge, publish, distribute, sublicense, and/or
+ *     sell copies of the Software, and to permit persons to whom the
+ *     Software is furnished to do so, subject to the following
+ *     conditions:
+ *
+ *     The above copyright notice and this permission notice shall be
+ *     included in all copies or substantial portions of the Software.
+ *
+ *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
+ *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+ *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
+ *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ *     OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef _DT_BINDINGS_RST_SUN5I_A13_H_
+#define _DT_BINDINGS_RST_SUN5I_A13_H_
+
+#define RST_VE			0
+
+#endif /* _DT_BINDINGS_RST_SUN5I_A13_H_ */
-- 
2.7.4

