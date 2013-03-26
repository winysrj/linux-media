Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:12601 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862Ab3CZFOf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 01:14:35 -0400
From: Prasanna Kumar <prasanna.ps@samsung.com>
To: linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
	kyungmin.park@samsung.com, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Prasanna Kumar <prasanna.ps@samsung.com>
Subject: [PATCH] [media] s5p-mfc: Change MFC clock reference w.r.t Common Clock
 Framework
Date: Tue, 26 Mar 2013 10:50:51 +0530
Message-id: <1364275251-31394-1-git-send-email-prasanna.ps@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Prasanna Kumar <prasanna.ps@samsung.com>

According to Common Clock framework , modified the method of getting
clock for MFC Block.

Signed-off-by: Prasanna Kumar <prasanna.ps@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 6aa38a5..b8ac8f6 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -50,7 +50,7 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 		goto err_p_ip_clk;
 	}
 
-	pm->clock = clk_get(&dev->plat_dev->dev, dev->variant->mclk_name);
+	pm->clock = clk_get_parent(pm->clock_gate);
 	if (IS_ERR(pm->clock)) {
 		mfc_err("Failed to get MFC clock\n");
 		ret = PTR_ERR(pm->clock);
-- 
1.7.5.4

