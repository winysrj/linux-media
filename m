Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:50427 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3J3DPO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Oct 2013 23:15:14 -0400
Received: by mail-bk0-f53.google.com with SMTP id w11so242798bkz.26
        for <linux-media@vger.kernel.org>; Tue, 29 Oct 2013 20:15:13 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 11:15:13 +0800
Message-ID: <CAPgLHd-YSAP+236AfZTXT3Cg_opQ+t=+nUHL+CVhXnkeA=zcBw@mail.gmail.com>
Subject: [PATCH -next] [media] v4l: ti-vpe: fix return value check in vpe_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: m.chehab@samsung.com, grant.likely@linaro.org,
	rob.herring@calxeda.com, archit@ti.com, hans.verkuil@cisco.com,
	k.debski@samsung.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function devm_kzalloc() and devm_ioremap()
returns NULL pointer not ERR_PTR(). The IS_ERR() test in the return
value check should be replaced with NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/ti-vpe/vpe.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 4e58069..90cf369 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1942,8 +1942,8 @@ static int vpe_probe(struct platform_device *pdev)
 	int ret, irq, func;
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
-	if (IS_ERR(dev))
-		return PTR_ERR(dev);
+	if (!dev)
+		return -ENOMEM;
 
 	spin_lock_init(&dev->lock);
 
@@ -1962,8 +1962,8 @@ static int vpe_probe(struct platform_device *pdev)
 	 * registers based on the sub block base addresses
 	 */
 	dev->base = devm_ioremap(&pdev->dev, res->start, SZ_32K);
-	if (IS_ERR(dev->base)) {
-		ret = PTR_ERR(dev->base);
+	if (!dev->base) {
+		ret = -ENOMEM;
 		goto v4l2_dev_unreg;
 	}
 

