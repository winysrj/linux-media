Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:61495 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754075AbdIDUKJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 16:10:09 -0400
Subject: [PATCH 4/6] [media] atmel-isi: Delete an error message for a failed
 memory allocation in two functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Songjun Wu <songjun.wu@microchip.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <88d0739c-fdc1-9d7d-fe53-b7c2eeed1849@users.sourceforge.net>
Message-ID: <7eb22d47-956e-5712-33a5-d50aaf8684ec@users.sourceforge.net>
Date: Mon, 4 Sep 2017 22:10:01 +0200
MIME-Version: 1.0
In-Reply-To: <88d0739c-fdc1-9d7d-fe53-b7c2eeed1849@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 4 Sep 2017 21:21:25 +0200

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/atmel/atmel-isi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index 891fa2505efa..154e9c39b64f 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -1041,7 +1041,5 @@ static int isi_formats_init(struct atmel_isi *isi)
-	if (!isi->user_formats) {
-		dev_err(isi->dev, "could not allocate memory\n");
+	if (!isi->user_formats)
 		return -ENOMEM;
-	}
 
 	memcpy(isi->user_formats, isi_fmts,
 	       num_fmts * sizeof(struct isi_format *));
@@ -1179,7 +1177,5 @@ static int atmel_isi_probe(struct platform_device *pdev)
-	if (!isi) {
-		dev_err(&pdev->dev, "Can't allocate interface!\n");
+	if (!isi)
 		return -ENOMEM;
-	}
 
 	isi->pclk = devm_clk_get(&pdev->dev, "isi_clk");
 	if (IS_ERR(isi->pclk))
-- 
2.14.1
