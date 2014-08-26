Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbaHZVzU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:20 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 27/35] [media] s5p-jpeg: Get rid of a warning
Date: Tue, 26 Aug 2014 18:55:03 -0300
Message-Id: <1409090111-8290-28-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c: In function 's5p_jpeg_clear_int':
drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c:327:16: warning: variable 'reg' set but not used [-Wunused-but-set-variable]
  unsigned long reg;
                ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
index 52407d790726..0d37bed088df 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
@@ -326,7 +326,7 @@ void s5p_jpeg_clear_int(void __iomem *regs)
 {
 	unsigned long reg;
 
-	reg = readl(regs + S5P_JPGINTST);
+	readl(regs + S5P_JPGINTST);
 	writel(S5P_INT_RELEASE, regs + S5P_JPGCOM);
 	reg = readl(regs + S5P_JPGOPR);
 }
-- 
1.9.3

