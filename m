Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40635 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbaIXMl6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 08:41:58 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/4] [media] s5p_mfc_opr_v6: remove address space removal warnings
Date: Wed, 24 Sep 2014 09:41:42 -0300
Message-Id: <1c554a0b25c8802e2d58bdc711548ebad52af28d.1411562226.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411562226.git.mchehab@osg.samsung.com>
References: <cover.1411562226.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411562226.git.mchehab@osg.samsung.com>
References: <cover.1411562226.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch still has 3 warnings for s5p_mfc_opr_v6:

drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:2028:18: warning: cast removes address space of expression
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:2034:18: warning: cast removes address space of expression
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:2040:18: warning: cast removes address space of expression

Remove them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index ed3d20f12184..e38d78f21726 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -2019,25 +2019,25 @@ static int s5p_mfc_get_mvc_view_id_v6(struct s5p_mfc_dev *dev)
 static unsigned int s5p_mfc_get_pic_type_top_v6(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v6(ctx,
-		(unsigned int) ctx->dev->mfc_regs->d_ret_picture_tag_top);
+		(__force unsigned int) ctx->dev->mfc_regs->d_ret_picture_tag_top);
 }
 
 static unsigned int s5p_mfc_get_pic_type_bot_v6(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v6(ctx,
-		(unsigned int) ctx->dev->mfc_regs->d_ret_picture_tag_bot);
+		(__force unsigned int) ctx->dev->mfc_regs->d_ret_picture_tag_bot);
 }
 
 static unsigned int s5p_mfc_get_crop_info_h_v6(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v6(ctx,
-		(unsigned int) ctx->dev->mfc_regs->d_display_crop_info1);
+		(__force unsigned int) ctx->dev->mfc_regs->d_display_crop_info1);
 }
 
 static unsigned int s5p_mfc_get_crop_info_v_v6(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v6(ctx,
-		(unsigned int) ctx->dev->mfc_regs->d_display_crop_info2);
+		(__force unsigned int) ctx->dev->mfc_regs->d_display_crop_info2);
 }
 
 static struct s5p_mfc_regs mfc_regs;
-- 
1.9.3

