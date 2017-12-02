Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35672 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751850AbdLBMyB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Dec 2017 07:54:01 -0500
Received: by mail-pg0-f65.google.com with SMTP id q20so5662909pgv.2
        for <linux-media@vger.kernel.org>; Sat, 02 Dec 2017 04:54:01 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: tiffany.lin@mediatek.com, andrew-ct.chen@mediatek.com,
        mchehab@kernel.org, matthias.bgg@gmail.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc: trivial@kernel.org, Daniel Axtens <dja@axtens.net>
Subject: [PATCH] [media] vcodec: mediatek: Add MODULE_LICENSE to mtk_vcodec_util.c
Date: Sat,  2 Dec 2017 23:53:37 +1100
Message-Id: <20171202125337.31222-1-dja@axtens.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes the following warning in an allmodconfig build:
WARNING: modpost: missing MODULE_LICENSE() in drivers/media/platform/mtk-vcodec/mtk-vcodec-common.o

This matches the license at the top of the file.

Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
index 46768c056193..572efbbce7a9 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
@@ -115,3 +115,5 @@ struct mtk_vcodec_ctx *mtk_vcodec_get_curr_ctx(struct mtk_vcodec_dev *dev)
 	return ctx;
 }
 EXPORT_SYMBOL(mtk_vcodec_get_curr_ctx);
+
+MODULE_LICENSE("GPL v2");
-- 
2.11.0
