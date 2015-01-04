Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:16906 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbADJDl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Jan 2015 04:03:41 -0500
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
Subject: [PATCH v2 5/8] ARM: at91: dts: sama5d3: change name of pinctrl_isi_{power,reset}
Date: Sun, 4 Jan 2015 17:02:30 +0800
Message-ID: <1420362153-500-6-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1420362153-500-1-git-send-email-josh.wu@atmel.com>
References: <1420362153-500-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For sama5d3xmb board, the pins: pinctrl_isi_{power,reset} is used to
power-down or reset camera sensor.
So we should let camera sensor instead of ISI to configure the pins.

This patch will change pinctrl name from pinctrl_isi_{power,reset} to
pinctrl_sensor_{power,reset}. And remove these two pinctrl from ISI's
DT node. We will add these two pinctrl to sensor's DT node.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
v1 -> v2:
  1. only do things that mentioned in commit message.

 arch/arm/boot/dts/sama5d3xmb.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
index 6af1cba..db47f8b 100644
--- a/arch/arm/boot/dts/sama5d3xmb.dtsi
+++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
@@ -61,7 +61,7 @@
 
 			isi: isi@f0034000 {
 				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_isi_data_0_7 &pinctrl_isi_pck_as_mck &pinctrl_isi_power &pinctrl_isi_reset>;
+				pinctrl-0 = <&pinctrl_isi_data_0_7 &pinctrl_isi_pck_as_mck>;
 			};
 
 			mmc1: mmc@f8000000 {
@@ -122,12 +122,12 @@
 							<AT91_PIOD 31 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PD31 periph B ISI_MCK */
 					};
 
-					pinctrl_isi_reset: isi_reset-0 {
+					pinctrl_sensor_reset: sensor_reset-0 {
 						atmel,pins =
 							<AT91_PIOE 24 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;   /* PE24 gpio */
 					};
 
-					pinctrl_isi_power: isi_power-0 {
+					pinctrl_sensor_power: sensor_power-0 {
 						atmel,pins =
 							<AT91_PIOE 29 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>; /* PE29 gpio */
 					};
-- 
1.9.1

