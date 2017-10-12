Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:46400 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdJLT1b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 15:27:31 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Rob Herring <robh+dt@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch 0/6] ARM: dts/hwmod: Add CAL and VPE nodes 
Date: Thu, 12 Oct 2017 14:27:13 -0500
Message-ID: <20171012192719.15193-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds the needed HWMOD and DTSI nodes
for the CAL and VPE modules.
We also document the VPE DT bindings.

Benoit Parrot (6):
  ARM: dts: DRA72: Add CAL dtsi node
  ARM: DRA7: hwmod: Add CAL nodes
  ARM: OMAP: DRA7xx: Make CAM clock domain SWSUP only
  dt-bindings: media: ti-vpe: Document VPE driver
  ARM: DRA7: hwmod: Add VPE nodes
  ARM: dts: dra7: Add VPE dtsi node

 Documentation/devicetree/bindings/media/ti-vpe.txt | 41 ++++++++++
 arch/arm/boot/dts/dra7.dtsi                        | 26 +++++++
 arch/arm/boot/dts/dra72x.dtsi                      | 31 ++++++++
 arch/arm/mach-omap2/clockdomains7xx_data.c         |  2 +-
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          | 87 ++++++++++++++++++++++
 5 files changed, 186 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/ti-vpe.txt

-- 
2.9.0
