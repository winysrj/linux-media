Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbaLQRT2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Dec 2014 12:19:28 -0500
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
Subject: [PATCH v2 13/13] ARM: dts: sun6i: Add dts file for CSQ CS908 board
Date: Wed, 17 Dec 2014 18:18:24 +0100
Message-Id: <1418836704-15689-14-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSQ CS908 is an A31s based top-set box, with 1G RAM, 8G NAND,
rtl8188etv usb wifi, 2 USB A receptacles (1 connected through the OTG
controller), ethernet, 3.5 mm jack with a/v out and hdmi out.

Note it has no sdcard slot and therefore can only be fel booted.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/arm/boot/dts/Makefile             |   3 +-
 arch/arm/boot/dts/sun6i-a31s-cs908.dts | 109 +++++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/sun6i-a31s-cs908.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index bc58ac3..28506ab 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -459,7 +459,8 @@ dtb-$(CONFIG_MACH_SUN6I) += \
 	sun6i-a31-app4-evb1.dtb \
 	sun6i-a31-colombus.dtb \
 	sun6i-a31-hummingbird.dtb \
-	sun6i-a31-m9.dtb
+	sun6i-a31-m9.dtb \
+	sun6i-a31s-cs908.dtb
 dtb-$(CONFIG_MACH_SUN7I) += \
 	sun7i-a20-bananapi.dtb \
 	sun7i-a20-cubieboard2.dtb \
diff --git a/arch/arm/boot/dts/sun6i-a31s-cs908.dts b/arch/arm/boot/dts/sun6i-a31s-cs908.dts
new file mode 100644
index 0000000..48d3a70
--- /dev/null
+++ b/arch/arm/boot/dts/sun6i-a31s-cs908.dts
@@ -0,0 +1,109 @@
+/*
+ * Copyright 2014 Hans de Goede <hdegoede@redhat.com>
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This library is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This library is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ *     You should have received a copy of the GNU General Public
+ *     License along with this library; if not, write to the Free
+ *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
+ *     MA 02110-1301 USA
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
+/dts-v1/;
+/include/ "sun6i-a31s.dtsi"
+
+/ {
+	model = "CSQ CS908 top set box";
+	compatible = "csq,cs908", "allwinner,sun6i-a31s";
+
+	chosen {
+		bootargs = "earlyprintk console=ttyS0,115200";
+	};
+
+	soc@01c00000 {
+		usbphy: phy@01c19400 {
+			status = "okay";
+		};
+
+		ehci0: usb@01c1a000 {
+			status = "okay";
+		};
+
+		ehci1: usb@01c1b000 {
+			status = "okay";
+		};
+
+		ohci1: usb@01c1b400 {
+			status = "okay";
+		};
+
+		pio: pinctrl@01c20800 {
+			usb1_vbus_pin_csq908: usb1_vbus_pin@0 {
+				allwinner,pins = "PC27";
+				allwinner,function = "gpio_out";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+		};
+
+		uart0: serial@01c28000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart0_pins_a>;
+			status = "okay";
+		};
+
+		gmac: ethernet@01c30000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&gmac_pins_mii_a>;
+			phy = <&phy1>;
+			phy-mode = "mii";
+			status = "okay";
+
+			phy1: ethernet-phy@1 {
+				reg = <1>;
+			};
+		};
+
+		ir@01f02000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&ir_pins_a>;
+			status = "okay";
+		};
+	};
+};
-- 
2.1.0

