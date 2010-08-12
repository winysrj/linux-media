Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62291 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0HLHmv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 03:42:51 -0400
Date: Thu, 12 Aug 2010 09:41:58 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Pawel Osciak <p.osciak@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] V4L/DVB: unlock on error path
Message-ID: <20100812074158.GH645@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

If we return directly here then we miss out on some mutex_unlock()s

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index b151c7b..1beb226 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -822,7 +822,8 @@ static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	} else {
 		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev,
 			 "Wrong buffer/video queue type (%d)\n", f->type);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto s_fmt_out;
 	}
 
 	pix = &f->fmt.pix;
