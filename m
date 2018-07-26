Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:52478 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731729AbeGZX4C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 19:56:02 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] rcar-csi2: update stream start for V3M
Date: Fri, 27 Jul 2018 00:36:57 +0200
Message-Id: <20180726223657.26340-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Latest errata document updates the start procedure for V3M. This change
in addition to adhering to the datasheet update fixes capture on early
revisions of V3M.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

---

Hi Hans, Mauro and Sakari

I know this is late for v4.19 but if possible can it be considered? It 
fixes a real issue on R-Car V3M boards. I'm sorry for the late 
submission, the errata document accesses unfortunate did not align with 
the release schedule.

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index daef72d410a3425d..dc5ae8025832ab6e 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -339,6 +339,7 @@ enum rcar_csi2_pads {
 
 struct rcar_csi2_info {
 	int (*init_phtw)(struct rcar_csi2 *priv, unsigned int mbps);
+	int (*confirm_start)(struct rcar_csi2 *priv);
 	const struct rcsi2_mbps_reg *hsfreqrange;
 	unsigned int csi0clkfreqrange;
 	bool clear_ulps;
@@ -545,6 +546,13 @@ static int rcsi2_start(struct rcar_csi2 *priv)
 	if (ret)
 		return ret;
 
+	/* Confirm start */
+	if (priv->info->confirm_start) {
+		ret = priv->info->confirm_start(priv);
+		if (ret)
+			return ret;
+	}
+
 	/* Clear Ultra Low Power interrupt. */
 	if (priv->info->clear_ulps)
 		rcsi2_write(priv, INTSTATE_REG,
@@ -880,6 +888,11 @@ static int rcsi2_init_phtw_h3_v3h_m3n(struct rcar_csi2 *priv, unsigned int mbps)
 }
 
 static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int mbps)
+{
+	return rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
+}
+
+static int rcsi2_confirm_start_v3m_e3(struct rcar_csi2 *priv)
 {
 	static const struct phtw_value step1[] = {
 		{ .data = 0xed, .code = 0x34 },
@@ -890,12 +903,6 @@ static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int mbps)
 		{ /* sentinel */ },
 	};
 
-	int ret;
-
-	ret = rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
-	if (ret)
-		return ret;
-
 	return rcsi2_phtw_write_array(priv, step1);
 }
 
@@ -949,6 +956,7 @@ static const struct rcar_csi2_info rcar_csi2_info_r8a77965 = {
 
 static const struct rcar_csi2_info rcar_csi2_info_r8a77970 = {
 	.init_phtw = rcsi2_init_phtw_v3m_e3,
+	.confirm_start = rcsi2_confirm_start_v3m_e3,
 };
 
 static const struct of_device_id rcar_csi2_of_table[] = {
-- 
2.18.0
