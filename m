Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45530 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbbCDNzi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 08:55:38 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKO004GGXJH1RA0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Mar 2015 13:59:41 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 2/2] media: s5p-mfc: fix broken pointer cast on 64bit arch
Date: Wed, 04 Mar 2015 14:55:22 +0100
Message-id: <1425477322-5162-3-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1425477322-5162-1-git-send-email-m.szyprowski@samsung.com>
References: <1425477322-5162-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unsigned int cannot be used to store casted pointer on 64bit
architecture, so correct such casts to properly use unsigned long
variables.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index de2b8c6..22dfb3e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -302,7 +302,7 @@ struct s5p_mfc_hw_ops {
 	void (*write_info)(struct s5p_mfc_ctx *ctx, unsigned int data,
 			unsigned int ofs);
 	unsigned int (*read_info)(struct s5p_mfc_ctx *ctx,
-			unsigned int ofs);
+			unsigned long ofs);
 	int (*get_dspl_y_adr)(struct s5p_mfc_dev *dev);
 	int (*get_dec_y_adr)(struct s5p_mfc_dev *dev);
 	int (*get_dspl_status)(struct s5p_mfc_dev *dev);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 0c4fcf2..a605b2e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -268,7 +268,7 @@ static void s5p_mfc_write_info_v5(struct s5p_mfc_ctx *ctx, unsigned int data,
 }
 
 static unsigned int s5p_mfc_read_info_v5(struct s5p_mfc_ctx *ctx,
-				unsigned int ofs)
+				unsigned long ofs)
 {
 	rmb();
 	return readl((volatile void __iomem *)(ctx->shm.virt + ofs));
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index d826c58..6e0346c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1857,12 +1857,12 @@ static void s5p_mfc_write_info_v6(struct s5p_mfc_ctx *ctx, unsigned int data,
 }
 
 static unsigned int
-s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned int ofs)
+s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned long ofs)
 {
 	int ret;
 
 	s5p_mfc_clock_on();
-	ret = readl((volatile void __iomem *)((unsigned long)ofs));
+	ret = readl((volatile void __iomem *)ofs);
 	s5p_mfc_clock_off();
 
 	return ret;
-- 
1.9.2

