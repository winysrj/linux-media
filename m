Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42823 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387833AbeKPA6q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 19:58:46 -0500
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH 00/15] Cedrus support for the Allwinner H5 and A64 platforms
Date: Thu, 15 Nov 2018 15:49:58 +0100
Message-Id: <20181115145013.3378-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds support for the Allwinner H5 and A64 platforms to the
cedrus stateless video codec driver, with minor fixes to H3 support.

It requires changes to the SRAM driver bindings and driver, to properly
support the H5 and the A64 C1 SRAM section. Because a H5-specific
system-control node is introduced, the dummy syscon node that was shared
between the H3 and H5 is removed in favor of each platform-specific node.
A few fixes are included to ensure that the EMAC clock configuration
register is still accessible through the sunxi SRAM driver (instead of the
dummy syscon node, that was there for this purpose) on the H3 and H5.

Some minor cosmetic fixes are also included regarding the video-codec
addresses in the device-tree.

Paul Kocialkowski (15):
  ARM: dts: sun8i-a33: Remove heading 0 in video-codec unit address
  ARM: dts: sun8i-h3: Remove heading 0 in video-codec unit address
  ARM: dts: sun8i-h3: Fix the system-control register range
  soc: sunxi: sram: Enable EMAC clock access for H3 variant
  dt-bindings: sram: sunxi: Add bindings for the H5 with SRAM C1
  soc: sunxi: sram: Add support for the H5 SoC system control
  arm64: dts: allwinner: h5: Add system-control node with SRAM C1
  ARM/arm64: sunxi: Move H3/H5 syscon label over to soc-specific nodes
  dt-bindings: sram: sunxi: Add compatible for the A64 SRAM C1
  arm64: dts: allwinner: a64: Add support for the SRAM C1 section
  dt-bindings: media: cedrus: Add compatibles for the A64 and H5
  media: cedrus: Add device-tree compatible and variant for H5 support
  media: cedrus: Add device-tree compatible and variant for A64 support
  arm64: dts: allwinner: h5: Add Video Engine and reserved memory node
  arm64: dts: allwinner: a64: Add Video Engine and reserved memory node

 .../devicetree/bindings/media/cedrus.txt      |  2 +
 .../devicetree/bindings/sram/sunxi-sram.txt   |  5 ++
 arch/arm/boot/dts/sun8i-a33.dtsi              |  2 +-
 arch/arm/boot/dts/sun8i-h3.dtsi               |  6 +--
 arch/arm/boot/dts/sunxi-h3-h5.dtsi            |  6 ---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 39 +++++++++++++++
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi  | 47 +++++++++++++++++++
 drivers/soc/sunxi/sunxi_sram.c                | 10 +++-
 drivers/staging/media/sunxi/cedrus/cedrus.c   | 16 +++++++
 9 files changed, 122 insertions(+), 11 deletions(-)

-- 
2.19.1
