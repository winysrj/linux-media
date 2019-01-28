Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A08C282CD
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 20:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EE4C21738
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 20:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfA1UzQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 15:55:16 -0500
Received: from mailoutvs60.siol.net ([185.57.226.251]:40881 "EHLO
        mail.siol.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726719AbfA1UzQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 15:55:16 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Zimbra) with ESMTP id 306425208E6;
        Mon, 28 Jan 2019 21:55:13 +0100 (CET)
X-Virus-Scanned: amavisd-new at psrvmta12.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta12.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id jRCSuBCFPMvI; Mon, 28 Jan 2019 21:55:12 +0100 (CET)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Zimbra) with ESMTPS id CF129521814;
        Mon, 28 Jan 2019 21:55:12 +0100 (CET)
Received: from localhost.localdomain (cpe1-8-82.cable.triera.net [213.161.8.82])
        (Authenticated sender: 031275009)
        by mail.siol.net (Zimbra) with ESMTPSA id 0E1D55208E6;
        Mon, 28 Jan 2019 21:55:11 +0100 (CET)
From:   Jernej Skrabec <jernej.skrabec@siol.net>
To:     maxime.ripard@bootlin.com, wens@csie.org
Cc:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH 0/6] H6 Cedrus support
Date:   Mon, 28 Jan 2019 21:54:58 +0100
Message-Id: <20190128205504.11225-1-jernej.skrabec@siol.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch series adds basic support for H6 VPU. VPU itself has some new
features like 10-bit HEVC decoding, support for AFBC output format when
decoding HEVC and IOMMU. However, none of that is currently implemented.

Please take a look.

Best regards,
Jernej

Jernej Skrabec (6):
  dt-bindings: media: cedrus: Add H6 compatible
  media: cedrus: Add a quirk for not setting DMA offset
  media: cedrus: Add support for H6
  dt-bindings: sram: sunxi: Add compatible for the H6 SRAM C1
  arm64: dts: allwinner: h6: Add support for the SRAM C1 section
  arm64: dts: allwinner: h6: Add Video Engine node

 .../devicetree/bindings/media/cedrus.txt      |  1 +
 .../devicetree/bindings/sram/sunxi-sram.txt   |  1 +
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  | 25 +++++++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus.c   |  9 +++++++
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  3 +++
 .../staging/media/sunxi/cedrus/cedrus_hw.c    |  3 ++-
 6 files changed, 41 insertions(+), 1 deletion(-)

--=20
2.20.1

