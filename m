Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:52888 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752502AbcKRQSE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 11:18:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Houlong Wei <houlong.wei@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] [media] mtk-mdp: mark PM functions as __maybe_unused
Date: Fri, 18 Nov 2016 17:16:06 +0100
Message-Id: <20161118161621.798004-3-arnd@arndb.de>
In-Reply-To: <20161118161621.798004-1-arnd@arndb.de>
References: <20161118161621.798004-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver still produces a warning when CONFIG_PM is disabled, an
earlier fix only partially solved this:

media/platform/mtk-mdp/mtk_mdp_core.c:72:13: error: 'mtk_mdp_clock_off' defined but not used [-Werror=unused-function]
media/platform/mtk-mdp/mtk_mdp_core.c:63:13: error: 'mtk_mdp_clock_on' defined but not used [-Werror=unused-function]

This removes the incorrect #ifdef again and instead marks the PM
functions as __maybe_unused, which reliably shuts up the warning.

Fixes: 1b06fcf56aa6 ("[media] media: mtk-mdp: fix build error")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
index 51f2b50e406f..9e4eb7dcc424 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
@@ -234,8 +234,7 @@ static int mtk_mdp_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int mtk_mdp_pm_suspend(struct device *dev)
+static int __maybe_unused mtk_mdp_pm_suspend(struct device *dev)
 {
 	struct mtk_mdp_dev *mdp = dev_get_drvdata(dev);
 
@@ -244,7 +243,7 @@ static int mtk_mdp_pm_suspend(struct device *dev)
 	return 0;
 }
 
-static int mtk_mdp_pm_resume(struct device *dev)
+static int __maybe_unused mtk_mdp_pm_resume(struct device *dev)
 {
 	struct mtk_mdp_dev *mdp = dev_get_drvdata(dev);
 
@@ -252,10 +251,8 @@ static int mtk_mdp_pm_resume(struct device *dev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
 
-#ifdef CONFIG_PM_SLEEP
-static int mtk_mdp_suspend(struct device *dev)
+static int __maybe_unused mtk_mdp_suspend(struct device *dev)
 {
 	if (pm_runtime_suspended(dev))
 		return 0;
@@ -263,14 +260,13 @@ static int mtk_mdp_suspend(struct device *dev)
 	return mtk_mdp_pm_suspend(dev);
 }
 
-static int mtk_mdp_resume(struct device *dev)
+static int __maybe_unused mtk_mdp_resume(struct device *dev)
 {
 	if (pm_runtime_suspended(dev))
 		return 0;
 
 	return mtk_mdp_pm_resume(dev);
 }
-#endif /* CONFIG_PM_SLEEP */
 
 static const struct dev_pm_ops mtk_mdp_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(mtk_mdp_suspend, mtk_mdp_resume)
-- 
2.9.0

