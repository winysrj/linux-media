Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52188 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbaHERA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 13:00:27 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 13/15] [media] coda: fix coda_s_fmt_vid_out
Date: Tue,  5 Aug 2014 19:00:18 +0200
Message-Id: <1407258020-12078-14-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
References: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <philipp.zabel@gmail.com>

Set the context color space when s_fmt succeeded, not when it failed.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/platform/coda/coda-common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index e84b320..dfecb86 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -504,7 +504,9 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 
 	ret = coda_s_fmt(ctx, f);
 	if (ret)
-		ctx->colorspace = f->fmt.pix.colorspace;
+		return ret;
+
+	ctx->colorspace = f->fmt.pix.colorspace;
 
 	return ret;
 }
-- 
2.0.1

