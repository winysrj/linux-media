Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:45613 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbdKTG0h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 01:26:37 -0500
From: Jesse Chan <jc@linux.com>
Cc: Jesse Chan <jc@linux.com>, Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: mtk-vcodec: add missing MODULE_LICENSE/DESCRIPTION
Date: Sun, 19 Nov 2017 22:26:07 -0800
Message-Id: <20171120062607.124734-1-jc@linux.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jesse Chan <jc@linux.com>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
index 113b2097f061..d8212d759067 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
@@ -51,3 +51,6 @@ int mtk_vcodec_wait_for_done_ctx(struct mtk_vcodec_ctx  *ctx, int command,
 	return status;
 }
 EXPORT_SYMBOL(mtk_vcodec_wait_for_done_ctx);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Mediatek video codec driver");
-- 
2.14.1
