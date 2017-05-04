Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.176]:11202 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751894AbdEDWFh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 18:05:37 -0400
Received: from cm2.websitewelcome.com (cm2.websitewelcome.com [192.185.178.13])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 83B76400C3407
        for <linux-media@vger.kernel.org>; Thu,  4 May 2017 16:42:04 -0500 (CDT)
Date: Thu, 4 May 2017 16:42:00 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] media: platform: s3c-camif: fix function prototype
Message-ID: <20170504214200.GA22855@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170504145004.Horde.gvFfFeEbpRydR4Pody_ABxy@gator4166.hostgator.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix function prototype so the position of arguments camif->colorfx_cb and
camif->colorfx_cr match the order of the parameters when calling
camif_hw_set_effect() function.

Addresses-Coverity-ID: 1248800
Addresses-Coverity-ID: 1269141
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/platform/s3c-camif/camif-regs.c | 2 +-
 drivers/media/platform/s3c-camif/camif-regs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-regs.c b/drivers/media/platform/s3c-camif/camif-regs.c
index 812fb3a..d70ffef 100644
--- a/drivers/media/platform/s3c-camif/camif-regs.c
+++ b/drivers/media/platform/s3c-camif/camif-regs.c
@@ -58,7 +58,7 @@ void camif_hw_set_test_pattern(struct camif_dev *camif, unsigned int pattern)
 }
 
 void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
-			unsigned int cr, unsigned int cb)
+			unsigned int cb, unsigned int cr)
 {
 	static const struct v4l2_control colorfx[] = {
 		{ V4L2_COLORFX_NONE,		CIIMGEFF_FIN_BYPASS },
diff --git a/drivers/media/platform/s3c-camif/camif-regs.h b/drivers/media/platform/s3c-camif/camif-regs.h
index 5ad36c1..dfb49a5 100644
--- a/drivers/media/platform/s3c-camif/camif-regs.h
+++ b/drivers/media/platform/s3c-camif/camif-regs.h
@@ -255,7 +255,7 @@ void camif_hw_set_output_dma(struct camif_vp *vp);
 void camif_hw_set_target_format(struct camif_vp *vp);
 void camif_hw_set_test_pattern(struct camif_dev *camif, unsigned int pattern);
 void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
-			unsigned int cr, unsigned int cb);
+			unsigned int cb, unsigned int cr);
 void camif_hw_set_output_addr(struct camif_vp *vp, struct camif_addr *paddr,
 			      int index);
 void camif_hw_dump_regs(struct camif_dev *camif, const char *label);
-- 
2.5.0
