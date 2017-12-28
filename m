Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:48194 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752885AbdL1NJX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 08:09:23 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Inki Dae <inki.dae@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH 2/2] media: dvb_vb2: limit reqbufs size to  a sane value
Date: Thu, 28 Dec 2017 11:09:17 -0200
Message-Id: <250e67e6e82643336d047e41780fbb72dc33687d.1514466421.git.mchehab@s-opensource.com>
In-Reply-To: <60dd6554070454d7f76c9d6d65f4ec8fc370b994.1514466421.git.mchehab@s-opensource.com>
References: <60dd6554070454d7f76c9d6d65f4ec8fc370b994.1514466421.git.mchehab@s-opensource.com>
In-Reply-To: <60dd6554070454d7f76c9d6d65f4ec8fc370b994.1514466421.git.mchehab@s-opensource.com>
References: <60dd6554070454d7f76c9d6d65f4ec8fc370b994.1514466421.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is not a good idea to let users to request a very high buffer
size.

So, add an upper limit.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_vb2.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index ccb99cfed2b3..d9fafeeb0d04 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -19,6 +19,8 @@
 #include "dvbdev.h"
 #include "dvb_vb2.h"
 
+#define DVB_V2_MAX_SIZE 	(4096 * 188)
+
 static int vb2_debug;
 module_param(vb2_debug, int, 0644);
 
@@ -330,6 +332,12 @@ int dvb_vb2_reqbufs(struct dvb_vb2_ctx *ctx, struct dmx_requestbuffers *req)
 {
 	int ret;
 
+	/* Adjust size to a sane value */
+	if (req->size > DVB_V2_MAX_SIZE)
+		req->size = DVB_V2_MAX_SIZE;
+
+	/* FIXME: round req->size to a 188 or 204 multiple */
+
 	ctx->buf_siz = req->size;
 	ctx->buf_cnt = req->count;
 	ret = vb2_core_reqbufs(&ctx->vb_q, VB2_MEMORY_MMAP, &req->count);
-- 
2.14.3
