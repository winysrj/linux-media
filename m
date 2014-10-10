Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35102 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaJJGyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 02:54:24 -0400
Received: by mail-pa0-f47.google.com with SMTP id rd3so1174992pab.20
        for <linux-media@vger.kernel.org>; Thu, 09 Oct 2014 23:54:24 -0700 (PDT)
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH] [media] ir-hix5hd2 fix build warning
Date: Fri, 10 Oct 2014 14:53:47 +0800
Message-Id: <1412924027-18997-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change CONFIG_PM to CONFIG_PM_SLEEP to solve
warning: 'hix5hd2_ir_suspend' & 'hix5hd2_ir_resume' defined but not used

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/media/rc/ir-hix5hd2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index c555ca2aed0e..455d1b53c9db 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -294,7 +294,7 @@ static int hix5hd2_ir_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int hix5hd2_ir_suspend(struct device *dev)
 {
 	struct hix5hd2_ir_priv *priv = dev_get_drvdata(dev);
-- 
1.7.9.5

