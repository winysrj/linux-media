Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.228]:34398 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751126AbdFBDnp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 23:43:45 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id DF68740105349
        for <linux-media@vger.kernel.org>; Thu,  1 Jun 2017 22:43:42 -0500 (CDT)
Date: Thu, 1 Jun 2017 22:43:41 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] media: platform: s3c-camif: fix arguments position in
 function call
Message-ID: <20170602034341.GA5349@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da5c5727-628d-1887-368c-970d5308ee72@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Here is another patch in case you decide that it is
better to apply this one.

Thanks
--
Gustavo A. R. Silva


==========

Fix the position of the arguments in function call.

Addresses-Coverity-ID: 1248800
Addresses-Coverity-ID: 1269141
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/platform/s3c-camif/camif-capture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 1b30be72..25c7a7d 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -80,7 +80,7 @@ static int s3c_camif_hw_init(struct camif_dev *camif, struct camif_vp *vp)
 	camif_hw_set_test_pattern(camif, camif->test_pattern);
 	if (variant->has_img_effect)
 		camif_hw_set_effect(camif, camif->colorfx,
-				camif->colorfx_cb, camif->colorfx_cr);
+				camif->colorfx_cr, camif->colorfx_cb);
 	if (variant->ip_revision == S3C6410_CAMIF_IP_REV)
 		camif_hw_set_input_path(vp);
 	camif_cfg_video_path(vp);
@@ -364,7 +364,7 @@ irqreturn_t s3c_camif_irq_handler(int irq, void *priv)
 		camif_hw_set_test_pattern(camif, camif->test_pattern);
 		if (camif->variant->has_img_effect)
 			camif_hw_set_effect(camif, camif->colorfx,
-				    camif->colorfx_cb, camif->colorfx_cr);
+				    camif->colorfx_cr, camif->colorfx_cb);
 		vp->state &= ~ST_VP_CONFIG;
 	}
 unlock:
-- 
2.5.0
