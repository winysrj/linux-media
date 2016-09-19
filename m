Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:42439 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751414AbcISGeu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 02:34:50 -0400
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
CC: <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Subject: [PATCH 2/2] media: mtk-mdp: fix build error
Date: Mon, 19 Sep 2016 14:34:43 +0800
Message-ID: <1474266883-51155-3-git-send-email-minghsiu.tsai@mediatek.com>
In-Reply-To: <1474266883-51155-1-git-send-email-minghsiu.tsai@mediatek.com>
References: <1474266883-51155-1-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix build error without CONFIG_PM_RUNTIME
and CONFIG_PM_SLEEP

Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
---
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
index b0c421e..f4424064 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
@@ -233,7 +233,7 @@ static int mtk_mdp_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#ifdef CONFIG_PM
 static int mtk_mdp_pm_suspend(struct device *dev)
 {
 	struct mtk_mdp_dev *mdp = dev_get_drvdata(dev);
@@ -251,7 +251,7 @@ static int mtk_mdp_pm_resume(struct device *dev)
 
 	return 0;
 }
-#endif /* CONFIG_PM_RUNTIME || CONFIG_PM_SLEEP */
+#endif /* CONFIG_PM */
 
 #ifdef CONFIG_PM_SLEEP
 static int mtk_mdp_suspend(struct device *dev)
-- 
1.7.9.5

