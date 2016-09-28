Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55725 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754552AbcI1VVK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:21:10 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 10/35] media: ti-vpe: Free vpdma buffers in vpe_release
Date: Wed, 28 Sep 2016 16:21:08 -0500
Message-ID: <20160928212108.26728-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Harinarayan Bhatta <harinarayan@ti.com>

Free vpdma buffers in vpe_release. Otherwise it was generating random
backtrace.

Signed-off-by: Harinarayan Bhatta <harinarayan@ti.com>
Signed-off-by: Somnath Mukherjee <somnath@ti.com>
Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index b66b55322dd4..17451237220c 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2183,6 +2183,9 @@ static int vpe_release(struct file *file)
 	vpdma_free_desc_list(&ctx->desc_list);
 	vpdma_free_desc_buf(&ctx->mmr_adb);
 
+	vpdma_free_desc_buf(&ctx->sc_coeff_v);
+	vpdma_free_desc_buf(&ctx->sc_coeff_h);
+
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	v4l2_ctrl_handler_free(&ctx->hdl);
-- 
2.9.0

