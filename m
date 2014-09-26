Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43518 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbaIZNAP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 09:00:15 -0400
Received: by mail-pa0-f41.google.com with SMTP id fa1so4753860pad.0
        for <linux-media@vger.kernel.org>; Fri, 26 Sep 2014 06:00:14 -0700 (PDT)
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: m.chehab@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH] [media] rc: fix hix5hd2 compile-test issue
Date: Fri, 26 Sep 2014 20:57:30 +0800
Message-Id: <1411736250-29252-1-git-send-email-zhangfei.gao@linaro.org>
In-Reply-To: <1411571401-30664-1-git-send-email-zhangfei.gao@linaro.org>
References: <1411571401-30664-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add dependence to solve build error in arch like ia64
error: implicit declaration of function 'readl_relaxed' & 'writel_relaxed'

Change CONFIG_PM to CONFIG_PM_SLEEP to solve
warning: 'hix5hd2_ir_suspend' & 'hix5hd2_ir_resume' defined but not used

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/media/rc/Kconfig      |    2 +-
 drivers/media/rc/ir-hix5hd2.c |    7 +------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 8ce08107a69d..28fb2cb34e8d 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -166,7 +166,7 @@ config IR_ENE
 
 config IR_HIX5HD2
 	tristate "Hisilicon hix5hd2 IR remote control"
-	depends on RC_CORE
+	depends on RC_CORE && ARM
 	help
 	 Say Y here if you want to use hisilicon hix5hd2 remote control.
 	 To compile this driver as a module, choose M here: the module will be
diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index 94967d0e0478..c1d8527ace92 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -16,11 +16,6 @@
 #include <linux/regmap.h>
 #include <media/rc-core.h>
 
-/* Allow the driver to compile on all architectures */
-#ifndef writel_relaxed
-# define writel_relaxed writel
-#endif
-
 #define IR_ENABLE		0x00
 #define IR_CONFIG		0x04
 #define CNT_LEADS		0x08
@@ -294,7 +289,7 @@ static int hix5hd2_ir_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int hix5hd2_ir_suspend(struct device *dev)
 {
 	struct hix5hd2_ir_priv *priv = dev_get_drvdata(dev);
-- 
1.7.9.5

