Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB9CC10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 15:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E5CE20851
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 15:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388326AbfCAPv0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 10:51:26 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:10997 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728331AbfCAPv0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 10:51:26 -0500
X-IronPort-AV: E=Sophos;i="5.58,428,1544454000"; 
   d="scan'208";a="9229675"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 02 Mar 2019 00:51:25 +0900
Received: from be1yocto.ree.adwin.renesas.com (unknown [172.29.43.62])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 146AC400A914;
        Sat,  2 Mar 2019 00:51:22 +0900 (JST)
From:   Biju Das <biju.das@bp.renesas.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Biju Das <biju.das@bp.renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: [PATCH RESEND V2 2/4] media: rcar-csi2: Enable support for r8a774a1
Date:   Fri,  1 Mar 2019 15:45:34 +0000
Message-Id: <1551455136-45574-3-git-send-email-biju.das@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1551455136-45574-1-git-send-email-biju.das@bp.renesas.com>
References: <1551455136-45574-1-git-send-email-biju.das@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the MIPI CSI-2 driver support for RZ/G2M(r8a774a1) SoC.
The CSI-2 module of RZ/G2M is similar to R-Car M3-W.

Signed-off-by: Biju Das <biju.das@bp.renesas.com>
Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
---
V1-->V2
  * No change
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index f64528d..a438ec2 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -986,6 +986,10 @@ static const struct rcar_csi2_info rcar_csi2_info_r8a77990 = {
 
 static const struct of_device_id rcar_csi2_of_table[] = {
 	{
+		.compatible = "renesas,r8a774a1-csi2",
+		.data = &rcar_csi2_info_r8a7796,
+	},
+	{
 		.compatible = "renesas,r8a774c0-csi2",
 		.data = &rcar_csi2_info_r8a77990,
 	},
-- 
2.7.4

