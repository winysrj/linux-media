Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:60367 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753423AbcKRXVG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:06 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 10/35] media: ti-vpe: Free vpdma buffers in vpe_release
Date: Fri, 18 Nov 2016 17:20:20 -0600
Message-ID: <20161118232045.24665-11-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
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
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 4b6e8839dd83..f2b90d42b408 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2182,6 +2182,9 @@ static int vpe_release(struct file *file)
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

