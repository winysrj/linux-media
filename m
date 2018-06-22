Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:46413 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933942AbeFVPeD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:34:03 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 07/32] media: camss: csiphy: Ensure clock mux config is done before the rest
Date: Fri, 22 Jun 2018 18:33:16 +0300
Message-Id: <1529681621-9682-8-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
References: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a write memory barier after clock mux config and before the rest
of the csiphy config.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-csiphy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
index b37e691..2a9adcd 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
@@ -364,6 +364,7 @@ static int csiphy_stream_on(struct csiphy_device *csiphy)
 		val |= cfg->csid_id;
 	}
 	writel_relaxed(val, csiphy->base_clk_mux);
+	wmb();
 
 	writel_relaxed(0x1, csiphy->base +
 		       CAMSS_CSI_PHY_GLBL_T_INIT_CFG0);
-- 
2.7.4
