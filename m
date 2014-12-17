Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbaLQRTJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Dec 2014 12:19:09 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 02/13] pinctrl: sun6i: Add A31s pinctrl support
Date: Wed, 17 Dec 2014 18:18:13 +0100
Message-Id: <1418836704-15689-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The A31s is a stripped down version of the A31, as such it is missing some
pins and some functions on some pins.

The new pinctrl-sun6i-a31s.c this commit adds is a copy of pinctrl-sun6i-a31s.c
with the missing pins and functions removed.

Note there is no a31s specific version of pinctrl-sun6i-a31-r.c, as the
prcm pins are identical between the A31 and the A31s.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Sync i2c3 muxing with v2 of "pinctrl: sun6i: Add some missing functions"
-Add myself to the copyright header
---
 .../bindings/pinctrl/allwinner,sunxi-pinctrl.txt   |   1 +
 drivers/pinctrl/sunxi/Kconfig                      |   4 +
 drivers/pinctrl/sunxi/Makefile                     |   1 +
 drivers/pinctrl/sunxi/pinctrl-sun6i-a31s.c         | 815 +++++++++++++++++++++
 4 files changed, 821 insertions(+)
 create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun6i-a31s.c

diff --git a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
index 93ce12e..fdd8046 100644
--- a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
@@ -11,6 +11,7 @@ Required properties:
   "allwinner,sun5i-a10s-pinctrl"
   "allwinner,sun5i-a13-pinctrl"
   "allwinner,sun6i-a31-pinctrl"
+  "allwinner,sun6i-a31s-pinctrl"
   "allwinner,sun6i-a31-r-pinctrl"
   "allwinner,sun7i-a20-pinctrl"
   "allwinner,sun8i-a23-pinctrl"
diff --git a/drivers/pinctrl/sunxi/Kconfig b/drivers/pinctrl/sunxi/Kconfig
index 230a952..2eb893e 100644
--- a/drivers/pinctrl/sunxi/Kconfig
+++ b/drivers/pinctrl/sunxi/Kconfig
@@ -21,6 +21,10 @@ config PINCTRL_SUN6I_A31
 	def_bool MACH_SUN6I
 	select PINCTRL_SUNXI_COMMON
 
+config PINCTRL_SUN6I_A31S
+	def_bool MACH_SUN6I
+	select PINCTRL_SUNXI_COMMON
+
 config PINCTRL_SUN6I_A31_R
 	def_bool MACH_SUN6I
 	depends on RESET_CONTROLLER
diff --git a/drivers/pinctrl/sunxi/Makefile b/drivers/pinctrl/sunxi/Makefile
index c7d92e4..b796d57 100644
--- a/drivers/pinctrl/sunxi/Makefile
+++ b/drivers/pinctrl/sunxi/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_PINCTRL_SUN4I_A10)		+= pinctrl-sun4i-a10.o
 obj-$(CONFIG_PINCTRL_SUN5I_A10S)	+= pinctrl-sun5i-a10s.o
 obj-$(CONFIG_PINCTRL_SUN5I_A13)		+= pinctrl-sun5i-a13.o
 obj-$(CONFIG_PINCTRL_SUN6I_A31)		+= pinctrl-sun6i-a31.o
+obj-$(CONFIG_PINCTRL_SUN6I_A31S)	+= pinctrl-sun6i-a31s.o
 obj-$(CONFIG_PINCTRL_SUN6I_A31_R)	+= pinctrl-sun6i-a31-r.o
 obj-$(CONFIG_PINCTRL_SUN7I_A20)		+= pinctrl-sun7i-a20.o
 obj-$(CONFIG_PINCTRL_SUN8I_A23)		+= pinctrl-sun8i-a23.o
diff --git a/drivers/pinctrl/sunxi/pinctrl-sun6i-a31s.c b/drivers/pinctrl/sunxi/pinctrl-sun6i-a31s.c
new file mode 100644
index 0000000..9b5a91f
--- /dev/null
+++ b/drivers/pinctrl/sunxi/pinctrl-sun6i-a31s.c
@@ -0,0 +1,815 @@
+/*
+ * Allwinner A31s SoCs pinctrl driver.
+ *
+ * Copyright (C) 2014 Hans de Goede <hdegoede@redhat.com>
+ *
+ * Based on pinctrl-sun6i-a31.c, which is:
+ * Copyright (C) 2014 Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/pinctrl/pinctrl.h>
+
+#include "pinctrl-sunxi.h"
+
+static const struct sunxi_desc_pin sun6i_a31s_pins[] = {
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 0),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* TXD0 */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* DTR */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 0)),	/* PA_EINT0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 1),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* TXD1 */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* DSR */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 1)),	/* PA_EINT1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 2),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* TXD2 */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* DCD */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 2)),	/* PA_EINT2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 3),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* TXD3 */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* RING */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 3)),	/* PA_EINT3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 4),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* TXD4 */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* TX */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 4)),	/* PA_EINT4 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 5),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* TXD5 */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* RX */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 5)),	/* PA_EINT5 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 6),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* TXD6 */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* RTS */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 6)),	/* PA_EINT6 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 7),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* TXD7 */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* CTS */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 7)),	/* PA_EINT7 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 8),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* TXCLK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 8)),	/* PA_EINT8 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 9),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* TXEN */
+		  SUNXI_FUNCTION(0x4, "mmc3"),		/* CMD */
+		  SUNXI_FUNCTION(0x5, "mmc2"),		/* CMD */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 9)),	/* PA_EINT9 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 10),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* GTXCLK */
+		  SUNXI_FUNCTION(0x4, "mmc3"),		/* CLK */
+		  SUNXI_FUNCTION(0x5, "mmc2"),		/* CLK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 10)),	/* PA_EINT10 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 11),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* RXD0 */
+		  SUNXI_FUNCTION(0x4, "mmc3"),		/* D0 */
+		  SUNXI_FUNCTION(0x5, "mmc2"),		/* D0 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 11)),	/* PA_EINT11 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 12),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* RXD1 */
+		  SUNXI_FUNCTION(0x4, "mmc3"),		/* D1 */
+		  SUNXI_FUNCTION(0x5, "mmc2"),		/* D1 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 12)),	/* PA_EINT12 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 13),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* RXD2 */
+		  SUNXI_FUNCTION(0x4, "mmc3"),		/* D2 */
+		  SUNXI_FUNCTION(0x5, "mmc2"),		/* D2 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 13)),	/* PA_EINT13 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 14),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* RXD3 */
+		  SUNXI_FUNCTION(0x4, "mmc3"),		/* D3 */
+		  SUNXI_FUNCTION(0x5, "mmc2"),		/* D3 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 14)),	/* PA_EINT14 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 15),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* RXD4 */
+		  SUNXI_FUNCTION(0x4, "clk_out_a"),
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 15)),	/* PA_EINT15 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 16),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* RXD5 */
+		  SUNXI_FUNCTION(0x4, "dmic"),		/* CLK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 16)),	/* PA_EINT16 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 17),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* RXD6 */
+		  SUNXI_FUNCTION(0x4, "dmic"),		/* DIN */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 17)),	/* PA_EINT17 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 18),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* RXD7 */
+		  SUNXI_FUNCTION(0x4, "clk_out_b"),
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 18)),	/* PA_EINT18 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 19),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* RXDV */
+		  SUNXI_FUNCTION(0x4, "pwm3"),		/* Positive */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 19)),	/* PA_EINT19 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 20),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* RXCLK */
+		  SUNXI_FUNCTION(0x4, "pwm3"),		/* Negative */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 20)),	/* PA_EINT20 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 21),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* TXERR */
+		  SUNXI_FUNCTION(0x4, "spi3"),		/* CS0 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 21)),	/* PA_EINT21 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 22),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* RXERR */
+		  SUNXI_FUNCTION(0x4, "spi3"),		/* CLK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 22)),	/* PA_EINT22 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 23),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* COL */
+		  SUNXI_FUNCTION(0x4, "spi3"),		/* MOSI */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 23)),	/* PA_EINT23 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 24),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* CRS */
+		  SUNXI_FUNCTION(0x4, "spi3"),		/* MISO */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 24)),	/* PA_EINT24 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 25),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* CLKIN */
+		  SUNXI_FUNCTION(0x4, "spi3"),		/* CS1 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 25)),	/* PA_EINT25 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 26),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* MDC */
+		  SUNXI_FUNCTION(0x4, "clk_out_c"),
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 26)),	/* PA_EINT26 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(A, 27),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "gmac"),		/* MDIO */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 27)),	/* PA_EINT27 */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 0),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2s0"),		/* MCLK */
+		  SUNXI_FUNCTION(0x3, "uart3"),		/* CTS */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 1, 0)),	/* PB_EINT0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 1),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2s0"),		/* BCLK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 1, 1)),	/* PB_EINT1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 2),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2s0"),		/* LRCK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 1, 2)),	/* PB_EINT2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 3),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2s0"),		/* DO0 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 1, 3)),	/* PB_EINT3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 4),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2s0"),		/* DO1 */
+		  SUNXI_FUNCTION(0x3, "uart3"),		/* RTS */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 1, 4)),	/* PB_EINT4 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 5),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2s0"),		/* DO2 */
+		  SUNXI_FUNCTION(0x3, "uart3"),		/* TX */
+		  SUNXI_FUNCTION(0x4, "i2c3"),		/* SCK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 1, 5)),	/* PB_EINT5 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 6),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2s0"),		/* DO3 */
+		  SUNXI_FUNCTION(0x3, "uart3"),		/* RX */
+		  SUNXI_FUNCTION(0x4, "i2c3"),		/* SDA */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 1, 6)),	/* PB_EINT6 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(B, 7),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x3, "i2s0"),		/* DI */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 1, 7)),	/* PB_EINT7 */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 0),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* WE */
+		  SUNXI_FUNCTION(0x3, "spi0")),		/* MOSI */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 1),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* ALE */
+		  SUNXI_FUNCTION(0x3, "spi0")),		/* MISO */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 2),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* CLE */
+		  SUNXI_FUNCTION(0x3, "spi0")),		/* CLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 3),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0")),	/* CE1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 4),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0")),	/* CE0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 5),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0")),	/* RE */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 6),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* RB0 */
+		  SUNXI_FUNCTION(0x3, "mmc2"),		/* CMD */
+		  SUNXI_FUNCTION(0x4, "mmc3")),		/* CMD */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 7),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* RB1 */
+		  SUNXI_FUNCTION(0x3, "mmc2"),		/* CLK */
+		  SUNXI_FUNCTION(0x4, "mmc3")),		/* CLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 8),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ0 */
+		  SUNXI_FUNCTION(0x3, "mmc2"),		/* D0 */
+		  SUNXI_FUNCTION(0x4, "mmc3")),		/* D0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 9),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ1 */
+		  SUNXI_FUNCTION(0x3, "mmc2"),		/* D1 */
+		  SUNXI_FUNCTION(0x4, "mmc3")),		/* D1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 10),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ2 */
+		  SUNXI_FUNCTION(0x3, "mmc2"),		/* D2 */
+		  SUNXI_FUNCTION(0x4, "mmc3")),		/* D2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 11),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ3 */
+		  SUNXI_FUNCTION(0x3, "mmc2"),		/* D3 */
+		  SUNXI_FUNCTION(0x4, "mmc3")),		/* D3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 12),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ4 */
+		  SUNXI_FUNCTION(0x3, "mmc2"),		/* D4 */
+		  SUNXI_FUNCTION(0x4, "mmc3")),		/* D4 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 13),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ5 */
+		  SUNXI_FUNCTION(0x3, "mmc2"),		/* D5 */
+		  SUNXI_FUNCTION(0x4, "mmc3")),		/* D5 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 14),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ6 */
+		  SUNXI_FUNCTION(0x3, "mmc2"),		/* D6 */
+		  SUNXI_FUNCTION(0x4, "mmc3")),		/* D6 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 15),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ7 */
+		  SUNXI_FUNCTION(0x3, "mmc2"),		/* D7 */
+		  SUNXI_FUNCTION(0x4, "mmc3")),		/* D7 */
+	/* Hole in pin numbering ! */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 24),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQS */
+		  SUNXI_FUNCTION(0x3, "mmc2"),		/* RST */
+		  SUNXI_FUNCTION(0x4, "mmc3")),		/* RST */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 25),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0")),	/* CE2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 26),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0")),	/* CE3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 27),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x3, "spi0")),		/* CS0 */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 0),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D0 */
+		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VP0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 1),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D1 */
+		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VN0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 2),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D2 */
+		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VP1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 3),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D3 */
+		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VN1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 4),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D4 */
+		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VP2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 5),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D5 */
+		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VN2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 6),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D6 */
+		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VPC */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 7),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D7 */
+		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VNC */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 8),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D8 */
+		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VP3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 9),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D9 */
+		  SUNXI_FUNCTION(0x3, "lvds0")),	/* VN3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 10),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D10 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 11),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D11 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 12),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D12 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 13),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D13 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 14),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D14 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 15),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D15 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 16),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D16 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 17),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D17 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 18),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D18 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 19),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D19 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 20),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D20 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 21),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D21 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 22),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D22 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 23),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D23 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 24),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* CLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 25),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* DE */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 26),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* HSYNC */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 27),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* VSYNC */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 0),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* PCLK */
+		  SUNXI_FUNCTION(0x3, "ts"),		/* CLK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 0)),	/* PE_EINT0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 1),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* MCLK */
+		  SUNXI_FUNCTION(0x3, "ts"),		/* ERR */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 1)),	/* PE_EINT1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 2),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* HSYNC */
+		  SUNXI_FUNCTION(0x3, "ts"),		/* SYNC */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 2)),	/* PE_EINT2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 3),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* VSYNC */
+		  SUNXI_FUNCTION(0x3, "ts"),		/* DVLD */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 3)),	/* PE_EINT3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 4),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* D0 */
+		  SUNXI_FUNCTION(0x3, "uart5"),		/* TX */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 4)),	/* PE_EINT4 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 5),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* D1 */
+		  SUNXI_FUNCTION(0x3, "uart5"),		/* RX */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 5)),	/* PE_EINT5 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 6),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* D2 */
+		  SUNXI_FUNCTION(0x3, "uart5"),		/* RTS */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 6)),	/* PE_EINT6 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 7),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* D3 */
+		  SUNXI_FUNCTION(0x3, "uart5"),		/* CTS */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 7)),	/* PE_EINT7 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 8),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* D4 */
+		  SUNXI_FUNCTION(0x3, "ts"),		/* D0 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 8)),	/* PE_EINT8 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 9),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* D5 */
+		  SUNXI_FUNCTION(0x3, "ts"),		/* D1 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 9)),	/* PE_EINT9 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 10),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* D6 */
+		  SUNXI_FUNCTION(0x3, "ts"),		/* D2 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 10)),	/* PE_EINT10 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 11),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* D7 */
+		  SUNXI_FUNCTION(0x3, "ts"),		/* D3 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 11)),	/* PE_EINT11 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 12),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* D8 */
+		  SUNXI_FUNCTION(0x3, "ts"),		/* D4 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 12)),	/* PE_EINT12 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 13),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* D9 */
+		  SUNXI_FUNCTION(0x3, "ts"),		/* D5 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 13)),	/* PE_EINT13 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 14),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* D10 */
+		  SUNXI_FUNCTION(0x3, "ts"),		/* D6 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 14)),	/* PE_EINT14 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(E, 15),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "csi"),		/* D11 */
+		  SUNXI_FUNCTION(0x3, "ts"),		/* D7 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 2, 15)),	/* PE_EINT15 */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(F, 0),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc0"),		/* D1 */
+		  SUNXI_FUNCTION(0x4, "jtag")),		/* MS1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(F, 1),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc0"),		/* D0 */
+		  SUNXI_FUNCTION(0x4, "jtag")),		/* DI1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(F, 2),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc0"),		/* CLK */
+		  SUNXI_FUNCTION(0x4, "uart0")),	/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(F, 3),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc0"),		/* CMD */
+		  SUNXI_FUNCTION(0x4, "jtag")),		/* DO1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(F, 4),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc0"),		/* D3 */
+		  SUNXI_FUNCTION(0x4, "uart0")),	/* RX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(F, 5),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc0"),		/* D2 */
+		  SUNXI_FUNCTION(0x4, "jtag")),		/* CK1 */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 0),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc1"),		/* CLK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 0)),	/* PG_EINT0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 1),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc1"),		/* CMD */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 1)),	/* PG_EINT1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 2),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc1"),		/* D0 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 2)),	/* PG_EINT2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 3),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc1"),		/* D1 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 3)),	/* PG_EINT3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 4),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc1"),		/* D2 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 4)),	/* PG_EINT4 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 5),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc1"),		/* D3 */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 5)),	/* PG_EINT5 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 6),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "uart2"),		/* TX */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 6)),	/* PG_EINT6 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 7),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "uart2"),		/* RX */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 7)),	/* PG_EINT7 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 8),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "uart2"),		/* RTS */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 8)),	/* PG_EINT8 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 9),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "uart2"),		/* CTS */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 9)),	/* PG_EINT9 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 10),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2c3"),		/* SCK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 10)),	/* PG_EINT10 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 11),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2c3"),		/* SDA */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 11)),	/* PG_EINT11 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 12),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi1"),		/* CS1 */
+		  SUNXI_FUNCTION(0x3, "i2s1"),		/* MCLK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 12)),	/* PG_EINT12 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 13),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi1"),		/* CS0 */
+		  SUNXI_FUNCTION(0x3, "i2s1"),		/* BCLK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 13)),	/* PG_EINT13 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 14),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi1"),		/* CLK */
+		  SUNXI_FUNCTION(0x3, "i2s1"),		/* LRCK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 14)),	/* PG_EINT14 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 15),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi1"),		/* MOSI */
+		  SUNXI_FUNCTION(0x3, "i2s1"),		/* DIN */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 15)),	/* PG_EINT15 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 16),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi1"),		/* MISO */
+		  SUNXI_FUNCTION(0x3, "i2s1"),		/* DOUT */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 16)),	/* PG_EINT16 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 17),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "uart4"),		/* TX */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 17)),	/* PG_EINT17 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(G, 18),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "uart4"),		/* RX */
+		  SUNXI_FUNCTION_IRQ_BANK(0x6, 3, 18)),	/* PG_EINT18 */
+	/* Hole, note H starts at pin 9 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 9),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi2"),		/* CS0 */
+		  SUNXI_FUNCTION(0x3, "jtag"),		/* MS0 */
+		  SUNXI_FUNCTION(0x4, "pwm1")),		/* Positive */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 10),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi2"),		/* CLK */
+		  SUNXI_FUNCTION(0x3, "jtag"),		/* CK0 */
+		  SUNXI_FUNCTION(0x4, "pwm1")),		/* Negative */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 11),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi2"),		/* MOSI */
+		  SUNXI_FUNCTION(0x3, "jtag"),		/* DO0 */
+		  SUNXI_FUNCTION(0x4, "pwm2")),		/* Positive */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 12),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi2"),		/* MISO */
+		  SUNXI_FUNCTION(0x3, "jtag"),		/* DI0 */
+		  SUNXI_FUNCTION(0x4, "pwm2")),		/* Negative */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 13),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "pwm0")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 14),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2c0")),		/* SCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 15),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2c0")),		/* SDA */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 16),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2c1")),		/* SCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 17),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2c1")),		/* SDA */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 18),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2c2")),		/* SCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 19),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2c2")),		/* SDA */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 20),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "uart0")),	/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 21),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "uart0")),	/* RX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 22),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 23),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 24),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 25),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 26),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 27),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 28),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out")),
+};
+
+static const struct sunxi_pinctrl_desc sun6i_a31s_pinctrl_data = {
+	.pins = sun6i_a31s_pins,
+	.npins = ARRAY_SIZE(sun6i_a31s_pins),
+	.irq_banks = 4,
+};
+
+static int sun6i_a31s_pinctrl_probe(struct platform_device *pdev)
+{
+	return sunxi_pinctrl_init(pdev,
+				  &sun6i_a31s_pinctrl_data);
+}
+
+static struct of_device_id sun6i_a31s_pinctrl_match[] = {
+	{ .compatible = "allwinner,sun6i-a31s-pinctrl", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, sun6i_a31s_pinctrl_match);
+
+static struct platform_driver sun6i_a31s_pinctrl_driver = {
+	.probe	= sun6i_a31s_pinctrl_probe,
+	.driver	= {
+		.name		= "sun6i-a31s-pinctrl",
+		.owner		= THIS_MODULE,
+		.of_match_table	= sun6i_a31s_pinctrl_match,
+	},
+};
+module_platform_driver(sun6i_a31s_pinctrl_driver);
+
+MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
+MODULE_DESCRIPTION("Allwinner A31s pinctrl driver");
+MODULE_LICENSE("GPL");
-- 
2.1.0

