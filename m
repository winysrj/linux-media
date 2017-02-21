Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:40182 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750951AbdBUINX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 03:13:23 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH] [media] st-delta: mjpeg: fix static checker warning
Date: Tue, 21 Feb 2017 09:12:52 +0100
Message-ID: <1487664772-19798-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialize 'data_offset' local variable to 0.

drivers/media/platform/sti/delta/delta-mjpeg-dec.c:415 delta_mjpeg_decode()
error: uninitialized symbol 'data_offset'.

Fixes: 433ff5b4a29b: "[media] st-delta: add mjpeg support"
Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/sti/delta/delta-mjpeg-dec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/delta/delta-mjpeg-dec.c b/drivers/media/platform/sti/delta/delta-mjpeg-dec.c
index e79bdc6..84ea43c 100644
--- a/drivers/media/platform/sti/delta/delta-mjpeg-dec.c
+++ b/drivers/media/platform/sti/delta/delta-mjpeg-dec.c
@@ -375,7 +375,7 @@ static int delta_mjpeg_decode(struct delta_ctx *pctx, struct delta_au *pau)
 	struct delta_mjpeg_ctx *ctx = to_ctx(pctx);
 	int ret;
 	struct delta_au au = *pau;
-	unsigned int data_offset;
+	unsigned int data_offset = 0;
 	struct mjpeg_header *header = &ctx->header_struct;
 
 	if (!ctx->header) {
-- 
1.9.1
