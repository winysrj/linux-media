Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:59136 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751639AbdIGUWW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Sep 2017 16:22:22 -0400
To: adi-buildroot-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] blackfin: Delete an error message for a failed memory
 allocation in ppi_create_instance()
Message-ID: <3f472947-091e-3e96-b278-093ca287b5a2@users.sourceforge.net>
Date: Thu, 7 Sep 2017 22:22:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 7 Sep 2017 22:14:43 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/blackfin/ppi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/blackfin/ppi.c b/drivers/media/platform/blackfin/ppi.c
index 37169054b828..478eb2f7d723 100644
--- a/drivers/media/platform/blackfin/ppi.c
+++ b/drivers/media/platform/blackfin/ppi.c
@@ -338,7 +338,6 @@ struct ppi_if *ppi_create_instance(struct platform_device *pdev,
 	ppi = kzalloc(sizeof(*ppi), GFP_KERNEL);
 	if (!ppi) {
 		peripheral_free_list(info->pin_req);
-		dev_err(&pdev->dev, "unable to allocate memory for ppi handle\n");
 		return NULL;
 	}
 	ppi->ops = &ppi_ops;
-- 
2.14.1
