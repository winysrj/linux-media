Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:62577 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935118AbdKPSW7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 13:22:59 -0500
From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc: Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [PATCH v2 0/4] Add VIN support to r8a774[35]
Date: Thu, 16 Nov 2017 18:22:47 +0000
Message-Id: <1510856571-30281-1-git-send-email-fabrizio.castro@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this series documents VIN related dt-bindings for r8a774[35], adds VIN[012]
nodes to the r8a7743 SoC dtsi and adds VIN[01] nodes to the r8a7745 SoC dtsi.

Best regards,

Fabrizio Castro (4):
  dt-bindings: media: rcar_vin: Reverse SoC part number list
  dt-bindings: media: rcar_vin: add device tree support for r8a774[35]
  ARM: dts: r8a7743: add VIN dt support
  ARM: dts: r8a7745: add VIN dt support

 .../devicetree/bindings/media/rcar_vin.txt         | 19 +++++++-----
 arch/arm/boot/dts/r8a7743.dtsi                     | 36 ++++++++++++++++++++++
 arch/arm/boot/dts/r8a7745.dtsi                     | 24 +++++++++++++++
 3 files changed, 71 insertions(+), 8 deletions(-)

-- 
2.7.4
