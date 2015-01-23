Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60830 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbbAWQvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:40 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Markus Pargmann <mpa@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 11/21] [media] coda: fix width validity check when starting to decode
Date: Fri, 23 Jan 2015 17:51:25 +0100
Message-Id: <1422031895-7740-12-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Pargmann <mpa@pengutronix.de>

Compare rounded up width to fit into bytesperline.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index d81635d..6ecfd29 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1431,9 +1431,10 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 		height = val & CODA7_PICHEIGHT_MASK;
 	}
 
-	if (width > q_data_dst->width || height > q_data_dst->height) {
+	if (width > q_data_dst->bytesperline || height > q_data_dst->height) {
 		v4l2_err(&dev->v4l2_dev, "stream is %dx%d, not %dx%d\n",
-			 width, height, q_data_dst->width, q_data_dst->height);
+			 width, height, q_data_dst->bytesperline,
+			 q_data_dst->height);
 		return -EINVAL;
 	}
 
-- 
2.1.4

