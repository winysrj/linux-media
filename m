Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:45669 "EHLO
        relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934499AbdKPMLj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 07:11:39 -0500
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
Subject: [PATCH 0/2] Add VIN support to r8a7743
Date: Thu, 16 Nov 2017 12:11:28 +0000
Message-Id: <1510834290-25434-1-git-send-email-fabrizio.castro@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this series documents VIN related dt-bindings for r8a774[35], and adds VIN[012]
nodes to the r8a7743 SoC dtsi.

Best regards,

Fabrizio Castro (2):
  dt-bindings: media: rcar_vin: add device tree support for r8a774[35]
  ARM: dts: r8a7743: add VIN dt support

 .../devicetree/bindings/media/rcar_vin.txt         |  5 ++-
 arch/arm/boot/dts/r8a7743.dtsi                     | 36 ++++++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

-- 
2.7.4
