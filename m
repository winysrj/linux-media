Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:37235 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933291AbcLIQ7Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 11:59:24 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH v2 4/7] [media] coda: add debug output about tiling
Date: Fri,  9 Dec 2016 17:59:00 +0100
Message-Id: <20161209165903.1293-5-m.tretter@pengutronix.de>
In-Reply-To: <20161209165903.1293-1-m.tretter@pengutronix.de>
References: <20161209165903.1293-1-m.tretter@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

In order to make the VDOA work correctly, the CODA must produce frames
in tiled format. Print this information in the debug output.

Also print the color format in fourcc instead of the numeric value.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index e0184194..f739873 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -616,8 +616,10 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f,
 	}
 
 	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
-		f->type, q_data->width, q_data->height, q_data->fourcc);
+		"Setting format for type %d, wxh: %dx%d, fmt: %4.4s %c\n",
+		f->type, q_data->width, q_data->height,
+		(char *)&q_data->fourcc,
+		(ctx->tiled_map_type == GDI_LINEAR_FRAME_MAP) ? 'L' : 'T');
 
 	return 0;
 }
-- 
2.10.2

