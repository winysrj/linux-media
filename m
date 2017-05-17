Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway20.websitewelcome.com ([192.185.53.25]:14206 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750944AbdEQVm1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 17:42:27 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 55823400D85C5
        for <linux-media@vger.kernel.org>; Wed, 17 May 2017 16:19:01 -0500 (CDT)
Date: Wed, 17 May 2017 16:19:00 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] media: platform: coda: remove variable self assignment
Message-ID: <20170517211900.GA29832@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove variable self assignment.

Addresses-Coverity-ID: 1408817
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/platform/coda/coda-common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index d523e99..a6699d8 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -612,7 +612,6 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
 
 	/* The h.264 decoder only returns complete 16x16 macroblocks */
 	if (codec && codec->src_fourcc == V4L2_PIX_FMT_H264) {
-		f->fmt.pix.width = f->fmt.pix.width;
 		f->fmt.pix.height = round_up(f->fmt.pix.height, 16);
 		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 16);
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
-- 
2.5.0
