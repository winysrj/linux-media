Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:46400 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933974AbeFVPeE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:34:04 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 13/32] media: camss: vfe: Do not disable CAMIF when clearing its status
Date: Fri, 22 Jun 2018 18:33:22 +0300
Message-Id: <1529681621-9682-14-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
References: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use "no change" value when clearing CAMIF status and make sure
this is done before configuring the new command.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-vfe.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 77167f1..15a1a01 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -156,6 +156,7 @@
 #define VFE_0_CAMIF_CMD				0x2f4
 #define VFE_0_CAMIF_CMD_DISABLE_FRAME_BOUNDARY	0
 #define VFE_0_CAMIF_CMD_ENABLE_FRAME_BOUNDARY	1
+#define VFE_0_CAMIF_CMD_NO_CHANGE		3
 #define VFE_0_CAMIF_CMD_CLEAR_CAMIF_STATUS	(1 << 2)
 #define VFE_0_CAMIF_CFG				0x2f8
 #define VFE_0_CAMIF_CFG_VFE_OUTPUT_EN		(1 << 6)
@@ -1021,8 +1022,10 @@ static void vfe_set_camif_cfg(struct vfe_device *vfe, struct vfe_line *line)
 
 static void vfe_set_camif_cmd(struct vfe_device *vfe, u32 cmd)
 {
-	writel_relaxed(VFE_0_CAMIF_CMD_CLEAR_CAMIF_STATUS,
+	writel_relaxed(VFE_0_CAMIF_CMD_CLEAR_CAMIF_STATUS |
+		       VFE_0_CAMIF_CMD_NO_CHANGE,
 		       vfe->base + VFE_0_CAMIF_CMD);
+	wmb();
 
 	writel_relaxed(cmd, vfe->base + VFE_0_CAMIF_CMD);
 }
-- 
2.7.4
