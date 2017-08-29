Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:59873 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751186AbdH2TJX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 15:09:23 -0400
To: linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] img-ir: Delete an error message for a failed memory
 allocation in img_ir_probe()
Message-ID: <74e8f4f2-9086-2edb-c64b-e88918b9f742@users.sourceforge.net>
Date: Tue, 29 Aug 2017 21:09:16 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 29 Aug 2017 21:04:20 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/img-ir/img-ir-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-core.c b/drivers/media/rc/img-ir/img-ir-core.c
index 03fe080278df..bcbabeeab12a 100644
--- a/drivers/media/rc/img-ir/img-ir-core.c
+++ b/drivers/media/rc/img-ir/img-ir-core.c
@@ -92,10 +92,9 @@ static int img_ir_probe(struct platform_device *pdev)
 
 	/* Private driver data */
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "cannot allocate device data\n");
+	if (!priv)
 		return -ENOMEM;
-	}
+
 	platform_set_drvdata(pdev, priv);
 	priv->dev = &pdev->dev;
 	spin_lock_init(&priv->lock);
-- 
2.14.1
