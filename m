Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:8171 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728127AbeIJTc0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 15:32:26 -0400
From: Biju Das <biju.das@bp.renesas.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Biju Das <biju.das@bp.renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: [PATCH 0/5] Add VIN support to RZ/G2M
Date: Mon, 10 Sep 2018 15:31:13 +0100
Message-Id: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series aims to add VIN support for RZ/G2M SoC.
RZ/G2M SoC is similar to R-Car Gen3 M3-W SoC.

This patchset is based on media_tree git and 
renesas-devel-20180906-v4.19-rc2.

Biju Das (5):
  media: dt-bindings: media: rcar-csi2: Add r8a774a1 support
  media: rcar-csi2: Enable support for r8a774a1
  media: dt-bindings: media: rcar_vin: Add r8a774a1 support
  media: rcar-vin: Enable support for r8a774a1
  arm64: dts: renesas: r8a774a1: Add VIN and CSI-2 nodes

 .../devicetree/bindings/media/rcar_vin.txt         |   5 +-
 .../bindings/media/renesas,rcar-csi2.txt           |   5 +-
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi          | 367 +++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-core.c        |   4 +
 drivers/media/platform/rcar-vin/rcar-csi2.c        |   4 +
 5 files changed, 381 insertions(+), 4 deletions(-)

-- 
2.7.4
