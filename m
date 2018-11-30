Return-path: <linux-media-owner@vger.kernel.org>
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:50228 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbeK3TQ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 14:16:29 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] media: sun6i: Separate H3 compatible from A31
Date: Fri, 30 Nov 2018 15:58:43 +0800
Message-Id: <20181130075849.16941-1-wens@csie.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSI (camera sensor interface) controller found on the H3 (and H5)
is a reduced version of the one found on the A31. It only has 1 channel,
instead of 4 channels supporting time-multiplexed BT.656 on the A31.
Since the H3 is a reduced version, it cannot "fallback" to a compatible
that implements more features than it supports.

This series separates support for the H3 variant from the A31 variant.

Patches 1 ~ 3 separate H3 CSI from A31 CSI in the bindings, driver, and
device tree, respectively.

Patch 4 adds a pinmux setting for the MCLK (master clock). Some camera
sensors use the master clock from the SoC instead of a standalone
crystal.

Patches 5 and 6 are examples of using a camera sensor with an SBC.
Since the modules are detachable, these changes should not be merged.
They should be implemented as overlays instead.

Please have a look.

In addition, I found that the first frame captured seems to always be
incomplete, with either parts cropped, out of position, or missing
color components.

Regards
ChenYu


Chen-Yu Tsai (6):
  media: dt-bindings: media: sun6i: Separate H3 compatible from A31
  media: sun6i: Add H3 compatible
  ARM: dts: sunxi: h3/h5: Drop A31 fallback compatible for CSI
    controller
  ARM: dts: sunxi: h3-h5: Add pinmux setting for CSI MCLK on PE1
  [DO NOT MERGE] ARM: dts: sunxi: bananapi-m2p: Add HDF5640 camera
    module
  [DO NOT MERGE] ARM: dts: sunxi: libretech-all-h3-cc: Add HDF5640
    camera module

 .../devicetree/bindings/media/sun6i-csi.txt   |  2 +-
 arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi | 87 +++++++++++++++++++
 arch/arm/boot/dts/sunxi-h3-h5.dtsi            |  8 +-
 .../boot/dts/sunxi-libretech-all-h3-cc.dtsi   | 81 +++++++++++++++++
 .../platform/sunxi/sun6i-csi/sun6i_csi.c      |  1 +
 5 files changed, 176 insertions(+), 3 deletions(-)

-- 
2.20.0.rc1
