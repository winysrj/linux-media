Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54786 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbdL2NiC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 08:38:02 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Inki Dae <inki.dae@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH 1/4] media: dvb_vb2: use strlcpy instead of strncpy
Date: Fri, 29 Dec 2017 08:37:53 -0500
Message-Id: <e73f9f68799400b6cb4087115e279d290437990f.1514554610.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514554610.git.mchehab@s-opensource.com>
References: <cover.1514554610.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514554610.git.mchehab@s-opensource.com>
References: <cover.1514554610.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using strncpy(), use strlcpy(), in order to
ensure that a \0 char will be added at the end of the
string.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_vb2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index 61c6ca4e87d5..889abf9becd8 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -194,7 +194,7 @@ int dvb_vb2_init(struct dvb_vb2_ctx *ctx, const char *name, int nonblocking)
 	spin_lock_init(&ctx->slock);
 	INIT_LIST_HEAD(&ctx->dvb_q);
 
-	strncpy(ctx->name, name, DVB_VB2_NAME_MAX);
+	strlcpy(ctx->name, name, DVB_VB2_NAME_MAX);
 	ctx->nonblocking = nonblocking;
 	ctx->state = DVB_VB2_STATE_INIT;
 
-- 
2.14.3
