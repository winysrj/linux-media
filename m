Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:49234 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbbLSPYJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Dec 2015 10:24:09 -0500
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] gsc-m2m: Use an unsigned data type for a variable
Message-ID: <5675765F.9020002@users.sourceforge.net>
Date: Sat, 19 Dec 2015 16:23:11 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 19 Dec 2015 15:28:37 +0100

The data type "int" was used by the variable "ret" in the
gsc_m2m_poll() function despite of the aspect that the type "unsigned int"
will usually be needed for the return value from a call of the
v4l2_m2m_poll() function.
Improve this implementation detail by addition of the type modifier then.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/exynos-gsc/gsc-m2m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index d82e717..f2c091c 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -701,7 +701,7 @@ static unsigned int gsc_m2m_poll(struct file *file,
 {
 	struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
 	struct gsc_dev *gsc = ctx->gsc_dev;
-	int ret;
+	unsigned int ret;
 
 	if (mutex_lock_interruptible(&gsc->lock))
 		return -ERESTARTSYS;
-- 
2.6.3

