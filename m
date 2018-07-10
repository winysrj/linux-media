Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52933 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932910AbeGJICI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:02:08 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pawel Osciak <posciak@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v5 09/22] ARM: dts: sun5i: Use most-qualified system control compatibles
Date: Tue, 10 Jul 2018 10:01:01 +0200
Message-Id: <20180710080114.31469-10-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This switches the sun5i dtsi to use the most qualified compatibles for
the system-control block (previously named SRAM controller) as well as
the SRAM blocks. The sun4i-a10 compatibles are kept since these hardware
blocks are backward-compatible.

The phandle for system control is also updated to reflect the fact that
the controller described is really about system control rather than SRAM
control.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 arch/arm/boot/dts/sun5i.dtsi | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/sun5i.dtsi b/arch/arm/boot/dts/sun5i.dtsi
index 07f2248ed5f8..68711954c293 100644
--- a/arch/arm/boot/dts/sun5i.dtsi
+++ b/arch/arm/boot/dts/sun5i.dtsi
@@ -114,8 +114,9 @@
 		#size-cells = <1>;
 		ranges;
 
-		sram-controller@1c00000 {
-			compatible = "allwinner,sun4i-a10-sram-controller";
+		system-control@1c00000 {
+			compatible = "allwinner,sun5i-a13-system-control",
+				     "allwinner,sun4i-a10-system-control";
 			reg = <0x01c00000 0x30>;
 			#address-cells = <1>;
 			#size-cells = <1>;
@@ -130,7 +131,8 @@
 			};
 
 			emac_sram: sram-section@8000 {
-				compatible = "allwinner,sun4i-a10-sram-a3-a4";
+				compatible = "allwinner,sun5i-a13-sram-a3-a4",
+					     "allwinner,sun4i-a10-sram-a3-a4";
 				reg = <0x8000 0x4000>;
 				status = "disabled";
 			};
@@ -143,7 +145,8 @@
 				ranges = <0 0x00010000 0x1000>;
 
 				otg_sram: sram-section@0 {
-					compatible = "allwinner,sun4i-a10-sram-d";
+					compatible = "allwinner,sun5i-a13-sram-d",
+						     "allwinner,sun4i-a10-sram-d";
 					reg = <0x0000 0x1000>;
 					status = "disabled";
 				};
-- 
2.17.1
