Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:33767 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727229AbeIXRDV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Sep 2018 13:03:21 -0400
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] am335x-boneblack-common.dtsi: add cec support
Message-ID: <c1a57790-ec91-103a-818a-40d7284cc502@xs4all.nl>
Date: Mon, 24 Sep 2018 13:01:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add CEC support to the tda998x.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Note: this relies on this gpio patch series:

https://www.spinics.net/lists/linux-gpio/msg32401.html

and this follow-up gpio patch:

https://www.spinics.net/lists/linux-gpio/msg32551.html

that will appear in 4.20.

Tested with my BeagleBone Black board.

Regards,

	Hans
---
 arch/arm/boot/dts/am335x-boneblack-common.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-boneblack-common.dtsi b/arch/arm/boot/dts/am335x-boneblack-common.dtsi
index 325daae40278..07e6b36d17c4 100644
--- a/arch/arm/boot/dts/am335x-boneblack-common.dtsi
+++ b/arch/arm/boot/dts/am335x-boneblack-common.dtsi
@@ -7,6 +7,7 @@
  */

 #include <dt-bindings/display/tda998x.h>
+#include <dt-bindings/interrupt-controller/irq.h>

 &ldo3_reg {
 	regulator-min-microvolt = <1800000>;
@@ -91,6 +92,8 @@
 	tda19988: tda19988 {
 		compatible = "nxp,tda998x";
 		reg = <0x70>;
+		nxp,calib-gpios = <&gpio1 25 0>;
+		interrupts-extended = <&gpio1 25 IRQ_TYPE_LEVEL_LOW>;

 		pinctrl-names = "default", "off";
 		pinctrl-0 = <&nxp_hdmi_bonelt_pins>;
-- 
2.19.0
