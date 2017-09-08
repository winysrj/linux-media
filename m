Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:56461 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932214AbdIHUwO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 16:52:14 -0400
Subject: [PATCH 1/3] [media] s5p-mfc: Delete an error message for a failed
 memory allocation in s5p_mfc_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <482a6c92-a85e-0bcd-edf7-3c2f63ea74c5@users.sourceforge.net>
Message-ID: <ff8f7dcd-c3e8-2a12-c0db-997b514f5d94@users.sourceforge.net>
Date: Fri, 8 Sep 2017 22:51:35 +0200
MIME-Version: 1.0
In-Reply-To: <482a6c92-a85e-0bcd-edf7-3c2f63ea74c5@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 8 Sep 2017 22:25:17 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 1afde5021ca6..8af45d53846f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1270,10 +1270,8 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 
 	pr_debug("%s++\n", __func__);
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		dev_err(&pdev->dev, "Not enough memory for MFC device\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	spin_lock_init(&dev->irqlock);
 	spin_lock_init(&dev->condlock);
-- 
2.14.1
