Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:34547 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2JDHYl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 03:24:41 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBC00AFWXWZED70@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:39 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBC006I9XWMLU10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:39 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, joshi@samsung.com
Subject: [PATCH v1 03/14] drm: exynos: hdmi: fix interrupt handling
Date: Thu, 04 Oct 2012 21:12:41 +0530
Message-id: <1349365372-21417-4-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
References: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

This patch fixes 'unsigned < 0' check in probe. Moreover it
releases an interrupt at remove.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index b3a802b..3902917 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -64,8 +64,8 @@ struct hdmi_context {
 	struct mutex			hdmi_mutex;
 
 	void __iomem			*regs;
-	unsigned int			external_irq;
-	unsigned int			internal_irq;
+	int				external_irq;
+	int				internal_irq;
 
 	struct i2c_client		*ddc_port;
 	struct i2c_client		*hdmiphy_port;
@@ -2424,6 +2424,7 @@ static int __devexit hdmi_remove(struct platform_device *pdev)
 	pm_runtime_disable(dev);
 
 	free_irq(hdata->internal_irq, hdata);
+	free_irq(hdata->external_irq, hdata);
 
 	hdmi_resources_cleanup(hdata);
 
-- 
1.7.0.4

