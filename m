Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:9281 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaIANGF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 09:06:05 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NB8002ZK4E39P30@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Sep 2014 22:06:03 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 1/4] s5p-jpeg: Avoid assigning readl result
Date: Mon, 01 Sep 2014 15:05:49 +0200
Message-id: <1409576752-24729-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoid gcc warning when -Wunused-but-set-variable is enabled.
The readl return value need not to be assigned to any variable
as the reading itself is just a part of a sequence required
for clearing the interrupt flag.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
index 52407d7..e3b8e67 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
@@ -324,11 +324,9 @@ int s5p_jpeg_stream_stat_ok(void __iomem *regs)
 
 void s5p_jpeg_clear_int(void __iomem *regs)
 {
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPGINTST);
+	readl(regs + S5P_JPGINTST);
 	writel(S5P_INT_RELEASE, regs + S5P_JPGCOM);
-	reg = readl(regs + S5P_JPGOPR);
+	readl(regs + S5P_JPGOPR);
 }
 
 unsigned int s5p_jpeg_compressed_size(void __iomem *regs)
-- 
1.7.9.5

