Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:55285 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752821AbcJZJpm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 05:45:42 -0400
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
Subject: [PATCH] [media] media: mtk-mdp: mark PM functions as __maybe_unused
Date: Wed, 26 Oct 2016 11:43:43 +0200
Message-Id: <20161026094411.785911-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A previous patch tried to fix a build error, but introduced another
warning:

drivers/media/platform/mtk-mdp/mtk_mdp_core.c:71:13: error: ‘mtk_mdp_clock_off’ defined but not used [-Werror=unused-function]
drivers/media/platform/mtk-mdp/mtk_mdp_core.c:62:13: error: ‘mtk_mdp_clock_on’ defined but not used [-Werror=unused-function]

This marks all the PM functions as __maybe_unused and removes
the #ifdef around them, as that will always do the right thing.

Fixes: 1b06fcf56aa6 ("[media] media: mtk-mdp: fix build error")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
index 40a229d8a1f5..d4c740263457 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
@@ -233,8 +233,7 @@ static int mtk_mdp_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int mtk_mdp_pm_suspend(struct device *dev)
+static int __maybe_unused mtk_mdp_pm_suspend(struct device *dev)
 {
 	struct mtk_mdp_dev *mdp = dev_get_drvdata(dev);
 
@@ -243,7 +242,7 @@ static int mtk_mdp_pm_suspend(struct device *dev)
 	return 0;
 }
 
-static int mtk_mdp_pm_resume(struct device *dev)
+static int __maybe_unused mtk_mdp_pm_resume(struct device *dev)
 {
 	struct mtk_mdp_dev *mdp = dev_get_drvdata(dev);
 
@@ -251,10 +250,8 @@ static int mtk_mdp_pm_resume(struct device *dev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
 
-#ifdef CONFIG_PM_SLEEP
-static int mtk_mdp_suspend(struct device *dev)
+static int __maybe_unused mtk_mdp_suspend(struct device *dev)
 {
 	if (pm_runtime_suspended(dev))
 		return 0;
@@ -262,14 +259,13 @@ static int mtk_mdp_suspend(struct device *dev)
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

