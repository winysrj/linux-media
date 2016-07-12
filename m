Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:60672 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417AbcGLLDa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 07:03:30 -0400
From: weiyj_lk@163.com
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH -next] [media] mtk-vcodec: remove redundant dev_err call in mtk_vcodec_probe()
Date: Tue, 12 Jul 2016 11:02:59 +0000
Message-Id: <1468321379-16133-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

There is a error message within devm_ioremap_resource
already, so remove the dev_err call to avoid redundant
error message.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
index 9c10cc2..b33a931 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
@@ -279,8 +279,6 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
 		}
 		dev->reg_base[i] = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR((__force void *)dev->reg_base[i])) {
-			dev_err(&pdev->dev,
-				"devm_ioremap_resource %d failed.", i);
 			ret = PTR_ERR((__force void *)dev->reg_base[i]);
 			goto err_res;
 		}


