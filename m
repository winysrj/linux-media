Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:41525 "EHLO m12-14.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbcGLLbt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 07:31:49 -0400
From: weiyj_lk@163.com
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Matthias Brugger <matthias.bgg@gmail.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH -next] [media] mtk-vcodec: remove .owner field for driver
Date: Tue, 12 Jul 2016 11:31:13 +0000
Message-Id: <1468323073-1655-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove .owner field if calls are used which set it automatically.

Generated by: scripts/coccinelle/api/platform_no_drv_owner.cocci

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
index 9c10cc2..60b0bde 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
@@ -430,7 +430,6 @@ static struct platform_driver mtk_vcodec_enc_driver = {
 	.remove	= mtk_vcodec_enc_remove,
 	.driver	= {
 		.name	= MTK_VCODEC_ENC_NAME,
-		.owner	= THIS_MODULE,
 		.of_match_table = mtk_vcodec_enc_match,
 	},
 };


