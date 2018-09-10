Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:31344 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728520AbeIJTch (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 15:32:37 -0400
From: Biju Das <biju.das@bp.renesas.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Biju Das <biju.das@bp.renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: [PATCH 4/5] media: rcar-vin: Enable support for r8a774a1
Date: Mon, 10 Sep 2018 15:31:17 +0100
Message-Id: <1536589878-26218-5-git-send-email-biju.das@bp.renesas.com>
In-Reply-To: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the SoC specific information for RZ/G2M(r8a774a1) SoC.
The VIN module of RZ/G2M is similar to R-Car M3-W.

Signed-off-by: Biju Das <biju.das@bp.renesas.com>
Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index d3072e1..c0c84d1 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -995,6 +995,10 @@ static const struct rvin_info rcar_info_r8a77970 = {
 
 static const struct of_device_id rvin_of_id_table[] = {
 	{
+		.compatible = "renesas,vin-r8a774a1",
+		.data = &rcar_info_r8a7796,
+	},
+	{
 		.compatible = "renesas,vin-r8a7778",
 		.data = &rcar_info_m1,
 	},
-- 
2.7.4
