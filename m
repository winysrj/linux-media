Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:16654 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbADJCm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Jan 2015 04:02:42 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <devicetree@vger.kernel.org>, <nicolas.ferre@atmel.com>
CC: <grant.likely@linaro.org>, <galak@codeaurora.org>,
	<rob@landley.net>, <robh+dt@kernel.org>,
	<ijc+devicetree@hellion.org.uk>, <pawel.moll@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <voice.shen@atmel.com>,
	<laurent.pinchart@ideasonboard.com>,
	<alexandre.belloni@free-electrons.com>, <plagnioj@jcrosoft.com>,
	<boris.brezillon@free-electrons.com>,
	<linux-media@vger.kernel.org>, <g.liakhovetski@gmx.de>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v2 2/8] ARM: at91: dts: sama5d3: split isi pinctrl
Date: Sun, 4 Jan 2015 17:02:27 +0800
Message-ID: <1420362153-500-3-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1420362153-500-1-git-send-email-josh.wu@atmel.com>
References: <1420362153-500-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bo Shen <voice.shen@atmel.com>

As the ISI has 12 data lines, however we only use 8 data lines with
sensor module. So, split the data line into two groups which make
it can be choosed depends on the hardware design.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 arch/arm/boot/dts/sama5d3.dtsi    | 11 ++++++++---
 arch/arm/boot/dts/sama5d3xmb.dtsi |  2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 61746ef..595609f 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -547,7 +547,7 @@
 				};
 
 				isi {
-					pinctrl_isi: isi-0 {
+					pinctrl_isi_data_0_7: isi-0-data-0-7 {
 						atmel,pins =
 							<AT91_PIOA 16 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA16 periph C ISI_D0, conflicts with LCDDAT16 */
 							 AT91_PIOA 17 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA17 periph C ISI_D1, conflicts with LCDDAT17 */
@@ -559,10 +559,15 @@
 							 AT91_PIOA 23 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA23 periph C ISI_D7, conflicts with LCDDAT23, PWML1 */
 							 AT91_PIOC 30 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC30 periph C ISI_PCK, conflicts with UTXD0 */
 							 AT91_PIOA 31 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA31 periph C ISI_HSYNC, conflicts with TWCK0, UTXD1 */
-							 AT91_PIOA 30 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA30 periph C ISI_VSYNC, conflicts with TWD0, URXD1 */
-							 AT91_PIOC 29 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC29 periph C ISI_PD8, conflicts with URXD0, PWMFI2 */
+							 AT91_PIOA 30 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PA30 periph C ISI_VSYNC, conflicts with TWD0, URXD1 */
+					};
+
+					pinctrl_isi_data_8_9: isi-0-data-8-9 {
+						atmel,pins =
+							<AT91_PIOC 29 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC29 periph C ISI_PD8, conflicts with URXD0, PWMFI2 */
 							 AT91_PIOC 28 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PC28 periph C ISI_PD9, conflicts with SPI1_NPCS3, PWMFI0 */
 					};
+
 					pinctrl_isi_pck_as_mck: isi_pck_as_mck-0 {
 						atmel,pins =
 							<AT91_PIOD 31 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PD31 periph B ISI_MCK */
diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
index 49c10d3..2530541 100644
--- a/arch/arm/boot/dts/sama5d3xmb.dtsi
+++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
@@ -61,7 +61,7 @@
 
 			isi: isi@f0034000 {
 				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_isi &pinctrl_isi_pck_as_mck &pinctrl_isi_power &pinctrl_isi_reset>;
+				pinctrl-0 = <&pinctrl_isi_data_0_7 &pinctrl_isi_pck_as_mck &pinctrl_isi_power &pinctrl_isi_reset>;
 			};
 
 			mmc1: mmc@f8000000 {
-- 
1.9.1

