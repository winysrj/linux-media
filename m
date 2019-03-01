Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC46C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 14:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4651C218B0
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 14:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387898AbfCAOaC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:30:02 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:3431 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727052AbfCAOaC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 09:30:02 -0500
X-IronPort-AV: E=Sophos;i="5.58,427,1544454000"; 
   d="scan'208";a="9020272"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 01 Mar 2019 23:29:59 +0900
Received: from be1yocto.ree.adwin.renesas.com (unknown [172.29.43.62])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 28CBC4010DEA;
        Fri,  1 Mar 2019 23:29:55 +0900 (JST)
From:   Biju Das <biju.das@bp.renesas.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Biju Das <biju.das@bp.renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: [PATCH RESEND v2 2/2] media: dt-bindings: media: rcar_vin: Add r8a774a1 support
Date:   Fri,  1 Mar 2019 14:24:13 +0000
Message-Id: <1551450253-63390-2-git-send-email-biju.das@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1551450253-63390-1-git-send-email-biju.das@bp.renesas.com>
References: <1551450253-63390-1-git-send-email-biju.das@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Document RZ/G2M (R8A774A1) SoC bindings.

The RZ/G2M SoC is similar to R-Car M3-W (R8A7796).

Signed-off-by: Biju Das <biju.das@bp.renesas.com>
Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Rob Herring <robh@kernel.org>
---
V1-->V2
  * No change
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 224a461..aa217b0 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -13,6 +13,7 @@ on Gen3 and RZ/G2 platforms to a CSI-2 receiver.
    - "renesas,vin-r8a7743" for the R8A7743 device
    - "renesas,vin-r8a7744" for the R8A7744 device
    - "renesas,vin-r8a7745" for the R8A7745 device
+   - "renesas,vin-r8a774a1" for the R8A774A1 device
    - "renesas,vin-r8a774c0" for the R8A774C0 device
    - "renesas,vin-r8a7778" for the R8A7778 device
    - "renesas,vin-r8a7779" for the R8A7779 device
-- 
2.7.4

