Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2762 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750943AbdLWLGp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Dec 2017 06:06:45 -0500
From: Yisheng Xie <xieyisheng1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC: <ysxie@foxmail.com>, Yisheng Xie <xieyisheng1@huawei.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        <linux-media@vger.kernel.org>
Subject: [PATCH v3 05/27] media: replace devm_ioremap_nocache with devm_ioremap
Date: Sat, 23 Dec 2017 18:57:52 +0800
Message-ID: <1514026672-32818-1-git-send-email-xieyisheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Default ioremap is ioremap_nocache, so devm_ioremap has the same
function with devm_ioremap_nocache, which can just be killed to
save the size of devres.o

This patch is to use use devm_ioremap instead of devm_ioremap_nocache,
which should not have any function change but prepare for killing
devm_ioremap_nocache.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
---
 drivers/media/platform/tegra-cec/tegra_cec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media/platform/tegra-cec/tegra_cec.c
index 807c94c..425728a 100644
--- a/drivers/media/platform/tegra-cec/tegra_cec.c
+++ b/drivers/media/platform/tegra-cec/tegra_cec.c
@@ -371,8 +371,8 @@ static int tegra_cec_probe(struct platform_device *pdev)
 	if (cec->tegra_cec_irq <= 0)
 		return -EBUSY;
 
-	cec->cec_base = devm_ioremap_nocache(&pdev->dev, res->start,
-					     resource_size(res));
+	cec->cec_base = devm_ioremap(&pdev->dev, res->start,
+				     resource_size(res));
 
 	if (!cec->cec_base) {
 		dev_err(&pdev->dev, "Unable to grab IOs for device\n");
-- 
1.8.3.1
