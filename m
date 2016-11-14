Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47985 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753481AbcKNOJr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 09:09:47 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH] s5p-mfc: Fix clock management in s5p_mfc_release function
Date: Mon, 14 Nov 2016 15:09:26 +0100
Message-id: <1479132566-477-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20161114140941eucas1p259a5ef794e4349614f6212cc251b6995@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clock control indirectly requires access to MFC device, so call it only
if we are sure that the device exists in s5p_mfc_release function.
s5p_mfc_remove() calls s5p_mfc_final_pm(), which releases all PM related
resources, including clocks, so any call to clocks related functions
is not valid after s5p_mfc_final_pm().

Fixes: d695c12 ("[media] media: s5p-mfc fix invalid memory access from
s5p_mfc_release()")

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 0c8a4616e827..a0a29194ccd1 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -940,10 +940,11 @@ static int s5p_mfc_release(struct file *file)
 	mfc_debug_enter();
 	if (dev)
 		mutex_lock(&dev->mfc_mutex);
-	s5p_mfc_clock_on();
 	vb2_queue_release(&ctx->vq_src);
 	vb2_queue_release(&ctx->vq_dst);
 	if (dev) {
+		s5p_mfc_clock_on();
+
 		/* Mark context as idle */
 		clear_work_bit_irqsave(ctx);
 		/*
@@ -965,9 +966,9 @@ static int s5p_mfc_release(struct file *file)
 			if (s5p_mfc_power_off() < 0)
 				mfc_err("Power off failed\n");
 		}
+		mfc_debug(2, "Shutting down clock\n");
+		s5p_mfc_clock_off();
 	}
-	mfc_debug(2, "Shutting down clock\n");
-	s5p_mfc_clock_off();
 	if (dev)
 		dev->ctx[ctx->num] = NULL;
 	s5p_mfc_dec_ctrls_delete(ctx);
-- 
1.9.1

