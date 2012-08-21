Return-path: <linux-media-owner@vger.kernel.org>
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:26626
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942Ab2HUGrx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 02:47:53 -0400
From: Richard Zhao <richard.zhao@freescale.com>
To: <linux-media@vger.kernel.org>
CC: <mchehab@infradead.org>, <s.nawrocki@samsung.com>,
	<p.zabel@pengutronix.de>, <javier.martin@vista-silicon.com>,
	<hans.verkuil@cisco.com>, <nfleischmann@de.adit-jv.com>,
	Richard Zhao <richard.zhao@freescale.com>
Subject: [PATCH] media: coda: remove duplicated call of fh_to_ctx in vidioc_s_fmt_vid_out
Date: Tue, 21 Aug 2012 14:47:42 +0800
Message-ID: <1345531662-16990-1-git-send-email-richard.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
---
 drivers/media/platform/coda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 6908514..69ff0d3 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -501,7 +501,7 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 	if (ret)
 		return ret;
 
-	ret = vidioc_s_fmt(fh_to_ctx(priv), f);
+	ret = vidioc_s_fmt(ctx, f);
 	if (ret)
 		ctx->colorspace = f->fmt.pix.colorspace;
 
-- 
1.7.9.5


