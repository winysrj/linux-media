Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282FEC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDACD2082B
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:27:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDACD2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbeLEJZQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 04:25:16 -0500
Received: from mail.bootlin.com ([62.4.15.54]:39742 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbeLEJZP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 04:25:15 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id A75BC20A62; Wed,  5 Dec 2018 10:25:13 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id 46A742037D;
        Wed,  5 Dec 2018 10:25:03 +0100 (CET)
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 00/15] Cedrus H5 and A64 support with A33 and H3 updates
Date:   Wed,  5 Dec 2018 10:24:29 +0100
Message-Id: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This series adds support for the Allwinner H5 and A64 platforms to the
cedrus stateless video codec driver, with minor updates to the A33 and
H3 platforms.

It requires changes to the SRAM driver bindings and driver, to properly
support the H5 and the A64 C1 SRAM section. Because a H5-specific
system-control node is introduced, the dummy syscon node that was shared
between the H3 and H5 is removed in favor of each platform-specific node.
A few fixes are included to ensure that the EMAC clock configuration
register is still accessible through the sunxi SRAM driver (instead of the
dummy syscon node, that was there for this purpose) on the H3 and H5.

The reserved memory nodes for the A33 and H3 are also removed in this
series, since they are not actually necessary.

Changes since v1:
* Removed the reserved-memory nodes for the A64 and H5;
* Removed the reserved-memory nodes for the A33 and H3;
* Corrected the SRAM bases and sizes to the best of our knowledge;
* Dropped cosmetic dt changes already included in the sunxi tree.

Paul Kocialkowski (15):
  ARM: dts: sun8i: h3: Fix the system-control register range
  ARM: dts: sun8i: a33: Remove unnecessary reserved memory node
  ARM: dts: sun8i: h3: Remove unnecessary reserved memory node
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
  arm64: dts: allwinner: h5: Add Video Engine node
  arm64: dts: allwinner: a64: Add Video Engine node

 .../devicetree/bindings/media/cedrus.txt      |  2 ++
 .../devicetree/bindings/sram/sunxi-sram.txt   |  5 +++
 arch/arm/boot/dts/sun8i-a33.dtsi              | 15 ---------
 arch/arm/boot/dts/sun8i-h3.dtsi               | 18 ++--------
 arch/arm/boot/dts/sunxi-h3-h5.dtsi            |  6 ----
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 25 ++++++++++++++
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi  | 33 +++++++++++++++++++
 drivers/soc/sunxi/sunxi_sram.c                | 10 +++++-
 drivers/staging/media/sunxi/cedrus/cedrus.c   | 16 +++++++++
 9 files changed, 92 insertions(+), 38 deletions(-)

-- 
2.19.2

