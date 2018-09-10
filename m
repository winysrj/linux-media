Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:52670 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728684AbeIJTcc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 15:32:32 -0400
From: Biju Das <biju.das@bp.renesas.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Biju Das <biju.das@bp.renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: [PATCH 2/5] media: rcar-csi2: Enable support for r8a774a1
Date: Mon, 10 Sep 2018 15:31:15 +0100
Message-Id: <1536589878-26218-3-git-send-email-biju.das@bp.renesas.com>
In-Reply-To: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the MIPI CSI-2 driver support for RZ/G2M(r8a774a1) SoC.
The CSI-2 module of RZ/G2M is similar to R-Car M3-W.

Signed-off-by: Biju Das <biju.das@bp.renesas.com>
Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index daef72d..65c7efb 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -953,6 +953,10 @@ static const struct rcar_csi2_info rcar_csi2_info_r8a77970 = {
 
 static const struct of_device_id rcar_csi2_of_table[] = {
 	{
+		.compatible = "renesas,r8a774a1-csi2",
+		.data = &rcar_csi2_info_r8a7796,
+	},
+	{
 		.compatible = "renesas,r8a7795-csi2",
 		.data = &rcar_csi2_info_r8a7795,
 	},
-- 
2.7.4
