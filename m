Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39693 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756728AbdLPCtS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 21:49:18 -0500
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [RFC 0/5] IR support for A83T - sunxi-ir driver update
Date: Sat, 16 Dec 2017 03:49:09 +0100
Message-Id: <20171216024914.7550-1-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for the sunxi A83T ir module and enhances the sunxi-ir driver.
Right now the base clock frequency for the ir driver is a hard coded define and is set to 8 MHz.
This works for the most common ir receivers. On the Sinovoip Bananapi M3 the ir receiver needs,
a 3 MHz base clock frequency to work without problems with this driver (like in the legacy kernel).

To fix this issue I reworked the driver that this value could be set over the devicetree.

About 37 devices would have a devicetree change if this patch series would be applied.
Therfore I would like to ask you to give me some feedback about the patch series, before I finialize it.


Thanks in advance!

Philipp


Philipp Rossak (5):
  [media] rc: update sunxi-ir driver to get base frequency from
    devicetree
  [media] dt: bindings: Update binding documentation for sunxi IR
    controller
  ARM: dts: sun8i: a83t: Add the ir pin for the A83T
  ARM: dts: sun8i: a83t: Add support for the ir interface
  ARM: dts: sun8i: a83t: bananapi-m3: Enable IR controller

 Documentation/devicetree/bindings/media/sunxi-ir.txt | 14 ++++++++------
 arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts         |  7 +++++++
 arch/arm/boot/dts/sun8i-a83t.dtsi                    | 15 +++++++++++++++
 drivers/media/rc/sunxi-cir.c                         | 20 +++++++++++---------
 4 files changed, 41 insertions(+), 15 deletions(-)

-- 
2.11.0
