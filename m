Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:35355 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730336AbeKFUT4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 15:19:56 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 4/6] media: rcar-csi2: Add R8A77990 support
Date: Tue,  6 Nov 2018 11:54:25 +0100
Message-Id: <1541501667-28817-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1541501667-28817-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1541501667-28817-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for R-Car E3 R8A77965 to R-Car CSI-2 driver.
Based on the experimental patch from Magnus Damm.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index b0044a0..695686b 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -963,6 +963,11 @@ static const struct rcar_csi2_info rcar_csi2_info_r8a77970 = {
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
@@ -980,6 +985,10 @@ static const struct of_device_id rcar_csi2_of_table[] = {
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
