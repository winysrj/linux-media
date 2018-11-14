Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:38514 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731585AbeKOBDL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 20:03:11 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Yong Deng <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>
Subject: [PATCH v2 0/4] media: sun6i: Add support for the H3 CSI controller
Date: Wed, 14 Nov 2018 15:59:30 +0100
Message-Id: <20181114145934.26855-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The H3 and H5 have a CSI controller based on the one previously found
in the A31, that is currently supported by the sun6i-csi driver.

Add the compatibles to the device tree bindings and to the driver to
make it work properly.

This obviously depends on the serie "Initial Allwinner V3s CSI
Support" by Yong Deng.

Let me know what you think,
Maxime

Changes from v1:
  - Rebased on top of latest Yong's series

Maxime Ripard (2):
  dt-bindings: media: sun6i: Add A31 and H3 compatibles
  media: sun6i: Add A31 compatible

Mylène Josserand (2):
  ARM: dts: sun8i: Add the H3/H5 CSI controller
  [DO NOT MERGE] ARM: dts: sun8i: Add CAM500B camera module to the Nano
    Pi M1+

 .../devicetree/bindings/media/sun6i-csi.txt   |  5 +-
 arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts | 85 +++++++++++++++++++
 arch/arm/boot/dts/sunxi-h3-h5.dtsi            | 22 +++++
 .../platform/sunxi/sun6i-csi/sun6i_csi.c      |  1 +
 4 files changed, 112 insertions(+), 1 deletion(-)

-- 
2.19.1
