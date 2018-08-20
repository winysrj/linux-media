Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:43907 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbeHTNcK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 09:32:10 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, geert@linux-m68k.org,
        horms@verge.net.au
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, damm+renesas@opensource.se,
        ulrich.hecht+renesas@gmail.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [RFT 4/8] media: rcar-csi2: Add R8A77990 support
Date: Mon, 20 Aug 2018 12:16:38 +0200
Message-Id: <1534760202-20114-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1534760202-20114-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1534760202-20114-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for R-Car E3 R8A77965 to R-Car CSI-2 driver.
Based on the experimental patch from Magnus Damm.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

---
The upported BSP patch
https://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas-bsp.git/commit/?id=59d3ad972acdba8b75a14113efbbca7f9c709345
includes a few more things to handle E3:

- E3 supports a single VC: do not write to VCDT2 register
  I feel there is not harm in doing that, but in case I can add that check
- phtw_testin handling:
  it seems to me phtw_testing is handled for all SoCs in the mainline csi-2
  driver, and it is not necessary to add it specifically for E3. Niklas, could
  you maybe check?

Thanks
   j

---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index dc5ae80..f82b668 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -959,6 +959,11 @@ static const struct rcar_csi2_info rcar_csi2_info_r8a77970 = {
 	.confirm_start = rcsi2_confirm_start_v3m_e3,
 };

+static const struct rcar_csi2_info rcar_csi2_info_r8a77990 = {
+	.init_phtw = rcsi2_init_phtw_v3m_e3,
+	.confirm_start = rcsi2_confirm_start_v3m_e3,
+};
+
 static const struct of_device_id rcar_csi2_of_table[] = {
 	{
 		.compatible = "renesas,r8a7795-csi2",
@@ -976,6 +981,10 @@ static const struct of_device_id rcar_csi2_of_table[] = {
 		.compatible = "renesas,r8a77970-csi2",
 		.data = &rcar_csi2_info_r8a77970,
 	},
+	{
+		.compatible = "renesas,r8a77990-csi2",
+		.data = &rcar_csi2_info_r8a77990,
+	},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, rcar_csi2_of_table);
--
2.7.4
