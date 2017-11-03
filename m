Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:62160 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750883AbdKCJyu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Nov 2017 05:54:50 -0400
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Derek Robson <robsonde@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Simran Singhal <singhalsimran0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] staging/media/davinci_vpfe: Use common error handling code in
 vpfe_attach_irq()
Message-ID: <47780e02-1fcd-dfc7-c7d7-65d32f6652e4@users.sourceforge.net>
Date: Fri, 3 Nov 2017 10:54:38 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 3 Nov 2017 10:45:31 +0100

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index bffe2153b910..80297d2df31d 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -309,8 +309,7 @@ static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
 	if (ret < 0) {
 		v4l2_err(&vpfe_dev->v4l2_dev,
 			"Error: requesting VINT1 interrupt\n");
-		free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
-		return ret;
+		goto free_irq;
 	}
 
 	ret = request_irq(vpfe_dev->imp_dma_irq, vpfe_imp_dma_isr,
@@ -319,11 +318,14 @@ static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
 		v4l2_err(&vpfe_dev->v4l2_dev,
 			 "Error: requesting IMP IRQ interrupt\n");
 		free_irq(vpfe_dev->ccdc_irq1, vpfe_dev);
-		free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
-		return ret;
+		goto free_irq;
 	}
 
 	return 0;
+
+free_irq:
+	free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
+	return ret;
 }
 
 /*
-- 
2.15.0
