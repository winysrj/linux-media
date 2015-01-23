Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60808 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbbAWQvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 08/21] [media] coda: properly clear f_cap in coda_s_fmt_vid_out
Date: Fri, 23 Jan 2015 17:51:22 +0100
Message-Id: <1422031895-7740-9-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Properly zero the structure on the stack before using it.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index af8a4d6..7a6cb08 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -674,6 +674,7 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 
 	ctx->colorspace = f->fmt.pix.colorspace;
 
+	memset(&f_cap, 0, sizeof(f_cap));
 	f_cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	coda_g_fmt(file, priv, &f_cap);
 	f_cap.fmt.pix.width = f->fmt.pix.width;
-- 
2.1.4

