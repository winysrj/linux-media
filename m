Return-path: <linux-media-owner@vger.kernel.org>
Received: from bran.ispras.ru ([83.149.199.196]:23792 "EHLO smtp.ispras.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728626AbeHFSAr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Aug 2018 14:00:47 -0400
From: Anton Vasilyev <vasilyev@ispras.ru>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Anton Vasilyev <vasilyev@ispras.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH v2 2/2] media: davinci: vpif_display: remove duplicate check
Date: Mon,  6 Aug 2018 18:50:25 +0300
Message-Id: <20180806155025.8912-2-vasilyev@ispras.ru>
In-Reply-To: <20180806155025.8912-1-vasilyev@ispras.ru>
References: <20180806155025.8912-1-vasilyev@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch removes the duplicate platform_data check from vpif_probe().

Fixes: 4a5f8ae50b66 ("[media] davinci: vpif_capture: get subdevs from DT when available")

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
---
v2: divided the original patch into two and made stylistic fixes based
on the Prabhakar's rewiev.
---
 drivers/media/platform/davinci/vpif_display.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index d9e578ac79c2..f000fc492ef9 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1255,11 +1255,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (!pdev->dev.platform_data) {
-		dev_warn(&pdev->dev, "Missing platform data.  Giving up.\n");
-		return -EINVAL;
-	}
-
 	vpif_dev = &pdev->dev;
 	err = initialize_vpif();
 
-- 
2.18.0
