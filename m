Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36382 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbdAaOj3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 09:39:29 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH] [media] hva-v4l2: hva_dbg_summary() should be static
Date: Tue, 31 Jan 2017 12:02:21 -0200
Message-Id: <e7d2f4aaa82e921a0efb210497327a5f346d3283.1485871339.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by gcc:

drivers/media/platform/sti/hva/hva-v4l2.c:227:6: warning: no previous prototype for 'hva_dbg_summary' [-Wmissing-prototypes]
 void hva_dbg_summary(struct hva_ctx *ctx)
      ^~~~~~~~~~~~~~~

This function is used only internally, so make it static.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/sti/hva/hva-v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
index 052f2feebc86..1c4fc33cbcb5 100644
--- a/drivers/media/platform/sti/hva/hva-v4l2.c
+++ b/drivers/media/platform/sti/hva/hva-v4l2.c
@@ -224,7 +224,7 @@ static int hva_open_encoder(struct hva_ctx *ctx, u32 streamformat,
 	return ret;
 }
 
-void hva_dbg_summary(struct hva_ctx *ctx)
+static void hva_dbg_summary(struct hva_ctx *ctx)
 {
 	struct device *dev = ctx_to_dev(ctx);
 	struct hva_streaminfo *stream = &ctx->streaminfo;
-- 
2.9.3

