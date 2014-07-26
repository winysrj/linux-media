Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:58442 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaGZOek (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 10:34:40 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so2302825wib.8
        for <linux-media@vger.kernel.org>; Sat, 26 Jul 2014 07:34:39 -0700 (PDT)
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 1/3] [media] coda: fix coda_s_fmt_vid_out
Date: Sat, 26 Jul 2014 16:34:30 +0200
Message-Id: <1406385272-425-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the context color space when s_fmt succeeded, not when it failed.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/platform/coda/coda-common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index dbd04ee..95d0b04 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -530,7 +530,9 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 
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

