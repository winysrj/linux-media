Return-path: <linux-media-owner@vger.kernel.org>
Received: from mslow2.mail.gandi.net ([217.70.178.242]:53396 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751481AbeDZTFO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 15:05:14 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: geert@linux-m68k.org, horms@verge.net.au, robh+dt@kernel.org,
        mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2]
Date: Thu, 26 Apr 2018 20:24:41 +0200
Message-Id: <1524767083-19862-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   this small series add R-Mobile A1 R8A7740 to the list of CEU supported
SoCs, and adds the CEU node to r8a7740.dtsi.

All the information on CEU clocks, power domains and memory regions have been
deducted from the now-deleted board file:
arch/arm/mach-shmobile/board-armadillo800eva.c

Thanks
   j

v1 -> v2:
- Enlarge the memory range as suggested by Simon
- Fix power domain, as reported by Simon
- s/Enable/[Describe|Add] in commit message

Jacopo Mondi (2):
  dt-bindings: media: renesas-ceu: Add R-Mobile R8A7740
  ARM: dts: r8a7740: Add CEU0

 Documentation/devicetree/bindings/media/renesas,ceu.txt |  7 ++++---
 arch/arm/boot/dts/r8a7740.dtsi                          | 10 ++++++++++
 drivers/media/platform/renesas-ceu.c                    |  1 +
 3 files changed, 15 insertions(+), 3 deletions(-)

--
2.7.4
