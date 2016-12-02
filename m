Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49318 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751388AbcLBEsH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2016 23:48:07 -0500
From: Shailendra Verma <shailendra.v@samsung.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shailendra Verma <shailendra.v@samsung.com>,
        Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: vidushi.koul@samsung.com
Subject: [PATCH] exynos-gsc: Clean up file handle in open() error path.
Date: Fri, 02 Dec 2016 10:15:27 +0530
Message-id: <1480653927-6850-1-git-send-email-shailendra.v@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The File handle is not yet added in the vfd list.So no need to call
v4l2_fh_del(&ctx->fh) if it fails to create control.

Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-m2m.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 9f03b79..5ea97c1 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -664,8 +664,8 @@ static int gsc_m2m_open(struct file *file)
 
 error_ctrls:
 	gsc_ctrls_delete(ctx);
-error_fh:
 	v4l2_fh_del(&ctx->fh);
+error_fh:
 	v4l2_fh_exit(&ctx->fh);
 	kfree(ctx);
 unlock:
-- 
1.7.9.5

