Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF277C10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 15:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9952620850
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 15:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388007AbfCAPvV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 10:51:21 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:10997 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728300AbfCAPvV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 10:51:21 -0500
X-IronPort-AV: E=Sophos;i="5.58,428,1544454000"; 
   d="scan'208";a="9229664"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 02 Mar 2019 00:51:19 +0900
Received: from be1yocto.ree.adwin.renesas.com (unknown [172.29.43.62])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 663FA400A914;
        Sat,  2 Mar 2019 00:51:16 +0900 (JST)
From:   Biju Das <biju.das@bp.renesas.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Biju Das <biju.das@bp.renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: [PATCH RESEND V2 0/4] Add VIN support to RZ/G2M
Date:   Fri,  1 Mar 2019 15:45:32 +0000
Message-Id: <1551455136-45574-1-git-send-email-biju.das@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch series aims to add VIN support for RZ/G2M SoC.
RZ/G2M SoC is similar to R-Car Gen3 M3-W SoC.

This patchset is based on media_tree git

V1-->V2
  *Rebased and resent. Not sending patch5 in this patch series since it is
   present in media tree commit 0c85e78fb1d3742c 
   ("arm64: dts: renesas: r8a774a1: Add VIN and CSI-2 nodes") 
 
V1:
   https://www.spinics.net/lists/devicetree/msg247956.html

Biju Das (4):
  media: dt-bindings: media: rcar-csi2: Add r8a774a1 support
  media: rcar-csi2: Enable support for r8a774a1
  media: dt-bindings: media: rcar_vin: Add r8a774a1 support
  media: rcar-vin: Enable support for r8a774a1

 Documentation/devicetree/bindings/media/rcar_vin.txt          | 1 +
 Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 1 +
 drivers/media/platform/rcar-vin/rcar-core.c                   | 4 ++++
 drivers/media/platform/rcar-vin/rcar-csi2.c                   | 4 ++++
 4 files changed, 10 insertions(+)

-- 
2.7.4

