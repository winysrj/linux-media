Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:57909 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754831AbcJLOye (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:54:34 -0400
Subject: [PATCH 15/34] [media] DaVinci-VPFE-Capture: Improve another size
 determination in vpfe_probe()
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <df0e9ae2-91fe-868c-5897-ebd4ab21f5c1@users.sourceforge.net>
Date: Wed, 12 Oct 2016 16:53:28 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 10:24:57 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpfe_capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 23142f0..4db3212 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1850,7 +1850,7 @@ static int vpfe_probe(struct platform_device *pdev)
 	}
 
 	/* Allocate memory for ccdc configuration */
-	ccdc_cfg = kmalloc(sizeof(struct ccdc_config), GFP_KERNEL);
+	ccdc_cfg = kmalloc(sizeof(*ccdc_cfg), GFP_KERNEL);
 	if (!ccdc_cfg)
 		goto probe_free_dev_mem;
 
-- 
2.10.1

