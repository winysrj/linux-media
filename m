Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:54126 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbdJSJbf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 05:31:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jacob chen <jacob2.chen@rock-chips.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Hans Verkuil <hansverk@cisco.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rockchip/rga: annotate PM functions as __maybe_unused
Date: Thu, 19 Oct 2017 11:30:34 +0200
Message-Id: <20171019093044.531871-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The newly added driver has incorrect #ifdef annotations on its
PM functions, leading to a harmless compile-time warning when
CONFIG_PM is disabled:

drivers/media/platform/rockchip/rga/rga.c:760:13: error: 'rga_disable_clocks' defined but not used [-Werror=unused-function]
 static void rga_disable_clocks(struct rockchip_rga *rga)
             ^~~~~~~~~~~~~~~~~~
drivers/media/platform/rockchip/rga/rga.c:728:12: error: 'rga_enable_clocks' defined but not used [-Werror=unused-function]

This removes the #ifdef and marks the functions as __maybe_unused,
so gcc can silently drop all the unused code.

Fixes: f7e7b48e6d79 ("[media] rockchip/rga: v4l2 m2m support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/rockchip/rga/rga.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index e7d1b34baf1c..89296de9cf4a 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -960,8 +960,7 @@ static int rga_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int rga_runtime_suspend(struct device *dev)
+static int __maybe_unused rga_runtime_suspend(struct device *dev)
 {
 	struct rockchip_rga *rga = dev_get_drvdata(dev);
 
@@ -970,13 +969,12 @@ static int rga_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int rga_runtime_resume(struct device *dev)
+static int __maybe_unused rga_runtime_resume(struct device *dev)
 {
 	struct rockchip_rga *rga = dev_get_drvdata(dev);
 
 	return rga_enable_clocks(rga);
 }
-#endif
 
 static const struct dev_pm_ops rga_pm = {
 	SET_RUNTIME_PM_OPS(rga_runtime_suspend,
-- 
2.9.0
