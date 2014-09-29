Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36070 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaI2GBC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 02:01:02 -0400
Received: by mail-pa0-f41.google.com with SMTP id eu11so1475055pac.0
        for <linux-media@vger.kernel.org>; Sun, 28 Sep 2014 23:01:01 -0700 (PDT)
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH] [media] rc: fix hix5hd2 compile-test issue
Date: Mon, 29 Sep 2014 14:00:16 +0800
Message-Id: <1411970416-13110-1-git-send-email-zhangfei.gao@linaro.org>
In-Reply-To: <1411736250-29252-1-git-send-email-zhangfei.gao@linaro.org>
References: <1411736250-29252-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 4c255791ffd6410f ("asm-generic: io: implement relaxed accessor
macros as conditional wrappers") adds wrappers to asm-generic of
{read,write}{b,w,l,q}_relaxed.

Change CONFIG_PM to CONFIG_PM_SLEEP to solve
warning: 'hix5hd2_ir_suspend' & 'hix5hd2_ir_resume' defined but not used

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/media/rc/ir-hix5hd2.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index c555ca2aed0e..58ec5986274e 100644
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

