Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:52468 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbaDKLti (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 07:49:38 -0400
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Cc: t.figa@samsung.com, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, robh+dt@kernel.org, arnd@arndb.de,
	gregkh@linuxfoundation.org, grant.likely@linaro.org,
	kgene.kim@samsung.com, rdunlap@infradead.org, ben-linux@fluff.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/2] arm: dts: trats2: add SiI9234 node
Date: Fri, 11 Apr 2014 13:48:30 +0200
Message-id: <1397216910-15904-3-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1397216910-15904-1-git-send-email-t.stanislaws@samsung.com>
References: <1397216910-15904-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds configuration of SiI9234 bridge to Trats2 board.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts |   43 +++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 9583563d..65fd1d4 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -680,4 +680,47 @@
 		pulldown-ohm = <100000>; /* 100K */
 		io-channels = <&adc 2>;  /* Battery temperature */
 	};
+
+	vsil: voltage-regulator-vsil {
+	        compatible = "regulator-fixed";
+		regulator-name = "HDMI_5V";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		gpio = <&gpl0 4 0>;
+		enable-active-high;
+		vin-supply = <&buck7_reg>;
+	};
+
+	i2c-mhl {
+		compatible = "i2c-gpio";
+		gpios = <&gpf0 4 0 &gpf0 6 0>;
+		i2c-gpio,delay-us = <100>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		pinctrl-0 = <&i2c_mhl_bus>;
+		pinctrl-names = "default";
+		status = "okay";
+
+		sii9234: sii9234@39 {
+			compatible = "sil,sii9234";
+			vcc-supply = <&vsil>;
+			gpio-reset = <&gpf3 4 0>;
+			gpio-int = <&gpf3 5 0>;
+			reg = <0x39>;
+		};
+	};
+};
+
+&pinctrl_0 {
+	mhl_int: mhl-int {
+		samsung,pins = "gpf3-5";
+		samsung,pin-pud = <0>;
+	};
+	i2c_mhl_bus: i2c-mhl-bus {
+		samsung,pins = "gpf0-4", "gpf0-6";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <1>;
+		samsung,pin-drv = <0>;
+	};
 };
-- 
1.7.9.5

