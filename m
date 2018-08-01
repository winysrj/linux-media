Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36094 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387833AbeHALc7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 07:32:59 -0400
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v7 0/4] IR support for A83T
Date: Wed,  1 Aug 2018 11:47:57 +0200
Message-Id: <20180801094801.26627-1-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for the sunxi A83T ir module and enhances 
the sunxi-ir driver. Right now the base clock frequency for the ir driver
is a hard coded define and is set to 8 MHz.
This works for the most common ir receivers. On the Sinovoip Bananapi M3 
the ir receiver needs, a 3 MHz base clock frequency to work without
problems with this driver.

This patch series adds support for an optinal property that makes it able
to override the default base clock frequency and enables the ir interface 
on the a83t and the Bananapi M3.

changes since v6:
* update Acked-by
* add missing a83t compatile on patch 2

changes since v5:
* removed already merged patches
* adapt patch 2 to be applyable to current rc-1

changes since v4:
* rename cir pin from cir_pins to r_cir_pin
* drop unit-address from r_cir_pin
* add a83t compatible to the cir node
* move muxing options to dtsi
* rename cir label and reorder it in the bananpim3.dts file

changes since v3:
* collecting all acks & reviewd by
* fixed typos

changes since v2:
* reorder cir pin (alphabetical)
* fix typo in documentation

changes since v1:
* fix typos, reword Documentation
* initialize 'b_clk_freq' to 'SUNXI_IR_BASE_CLK' & remove if statement
* change dev_info() to dev_dbg()
* change naming to cir* in dts/dtsi
* Added acked Ackedi-by to related patch
* use whole memory block instead of registers needed + fix for h3/h5

changes since rfc:
* The property is now optinal. If the property is not available in 
  the dtb the driver uses the default base clock frequency.
* the driver prints out the the selected base clock frequency.
* changed devicetree property from base-clk-frequency to clock-frequency

Regards,
Philipp


Philipp Rossak (4):
  ARM: dts: sun8i: a83t: Add the cir pin for the A83T
  ARM: dts: sun8i: a83t: Add support for the cir interface
  ARM: dts: sun8i: a83t: bananapi-m3: Enable IR controller
  ARM: dts: sun8i: h3-h5: ir register size should be the whole memory
    block

 arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts |  5 +++++
 arch/arm/boot/dts/sun8i-a83t.dtsi            | 18 ++++++++++++++++++
 arch/arm/boot/dts/sunxi-h3-h5.dtsi           |  2 +-
 3 files changed, 24 insertions(+), 1 deletion(-)

-- 
2.11.0
