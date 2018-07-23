Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:39964 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388116AbeGWMEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 08:04:46 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v3 20/35] media: camss: csiphy: Unify lane handling
Date: Mon, 23 Jul 2018 14:02:37 +0300
Message-Id: <1532343772-27382-21-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Restructure lane configuration so it is simpler and will allow
similar (although not the same) handling for different hardware
versions.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 .../platform/qcom/camss/camss-csiphy-2ph-1-0.c     | 48 ++++++++++++----------
 drivers/media/platform/qcom/camss/camss-csiphy.c   |  4 +-
 drivers/media/platform/qcom/camss/camss-csiphy.h   |  3 +-
 3 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c b/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
index 7325906..5f499be 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
@@ -86,7 +86,7 @@ static void csiphy_lanes_enable(struct csiphy_device *csiphy,
 {
 	struct csiphy_lanes_cfg *c = &cfg->csi2->lane_cfg;
 	u8 settle_cnt;
-	u8 val;
+	u8 val, l = 0;
 	int i = 0;
 
 	settle_cnt = csiphy_settle_cnt_calc(pixel_clock, bpp, c->num_data,
@@ -104,34 +104,38 @@ static void csiphy_lanes_enable(struct csiphy_device *csiphy,
 	val = cfg->combo_mode << 4;
 	writel_relaxed(val, csiphy->base + CAMSS_CSI_PHY_GLBL_RESET);
 
-	while (lane_mask) {
-		if (lane_mask & 0x1) {
-			writel_relaxed(0x10, csiphy->base +
-				       CAMSS_CSI_PHY_LNn_CFG2(i));
-			writel_relaxed(settle_cnt, csiphy->base +
-				       CAMSS_CSI_PHY_LNn_CFG3(i));
-			writel_relaxed(0x3f, csiphy->base +
-				       CAMSS_CSI_PHY_INTERRUPT_MASKn(i));
-			writel_relaxed(0x3f, csiphy->base +
-				       CAMSS_CSI_PHY_INTERRUPT_CLEARn(i));
-		}
-
-		lane_mask >>= 1;
-		i++;
+	for (i = 0; i <= c->num_data; i++) {
+		if (i == c->num_data)
+			l = c->clk.pos;
+		else
+			l = c->data[i].pos;
+
+		writel_relaxed(0x10, csiphy->base +
+			       CAMSS_CSI_PHY_LNn_CFG2(l));
+		writel_relaxed(settle_cnt, csiphy->base +
+			       CAMSS_CSI_PHY_LNn_CFG3(l));
+		writel_relaxed(0x3f, csiphy->base +
+			       CAMSS_CSI_PHY_INTERRUPT_MASKn(l));
+		writel_relaxed(0x3f, csiphy->base +
+			       CAMSS_CSI_PHY_INTERRUPT_CLEARn(l));
 	}
 }
 
-static void csiphy_lanes_disable(struct csiphy_device *csiphy, u8 lane_mask)
+static void csiphy_lanes_disable(struct csiphy_device *csiphy,
+				 struct csiphy_config *cfg)
 {
+	struct csiphy_lanes_cfg *c = &cfg->csi2->lane_cfg;
+	u8 l = 0;
 	int i = 0;
 
-	while (lane_mask) {
-		if (lane_mask & 0x1)
-			writel_relaxed(0x0, csiphy->base +
-				       CAMSS_CSI_PHY_LNn_CFG2(i));
+	for (i = 0; i <= c->num_data; i++) {
+		if (i == c->num_data)
+			l = c->clk.pos;
+		else
+			l = c->data[i].pos;
 
-		lane_mask >>= 1;
-		i++;
+		writel_relaxed(0x0, csiphy->base +
+			       CAMSS_CSI_PHY_LNn_CFG2(l));
 	}
 
 	writel_relaxed(0x0, csiphy->base + CAMSS_CSI_PHY_GLBL_PWR_CFG);
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
index 14a9a66..99686f9 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
@@ -292,9 +292,7 @@ static int csiphy_stream_on(struct csiphy_device *csiphy)
  */
 static void csiphy_stream_off(struct csiphy_device *csiphy)
 {
-	u8 lane_mask = csiphy_get_lane_mask(&csiphy->cfg.csi2->lane_cfg);
-
-	csiphy->ops->lanes_disable(csiphy, lane_mask);
+	csiphy->ops->lanes_disable(csiphy, &csiphy->cfg);
 }
 
 
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.h b/drivers/media/platform/qcom/camss/camss-csiphy.h
index 8f61b7d..07e5906 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.h
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.h
@@ -51,7 +51,8 @@ struct csiphy_hw_ops {
 	void (*lanes_enable)(struct csiphy_device *csiphy,
 			     struct csiphy_config *cfg,
 			     u32 pixel_clock, u8 bpp, u8 lane_mask);
-	void (*lanes_disable)(struct csiphy_device *csiphy, u8 lane_mask);
+	void (*lanes_disable)(struct csiphy_device *csiphy,
+			      struct csiphy_config *cfg);
 	irqreturn_t (*isr)(int irq, void *dev);
 };
 
-- 
2.7.4
