Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55029 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab0JUTW4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 15:22:56 -0400
Date: Thu, 21 Oct 2010 21:22:43 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/3] V4L/DVB: s5p-fimc: add unlock on error path
Message-ID: <20101021192243.GJ5985@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There was an unlock missing if kzalloc() failed.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 1802701..8335045 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1326,16 +1326,18 @@ static int fimc_m2m_open(struct file *file)
 	 * is already opened.
 	 */
 	if (fimc->vid_cap.refcnt > 0) {
-		mutex_unlock(&fimc->lock);
-		return -EBUSY;
+		err = -EBUSY;
+		goto err_unlock;
 	}
 
 	fimc->m2m.refcnt++;
 	set_bit(ST_OUTDMA_RUN, &fimc->state);
 
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		err = -ENOMEM;
+		goto err_unlock;
+	}
 
 	file->private_data = ctx;
 	ctx->fimc_dev = fimc;
@@ -1355,6 +1357,7 @@ static int fimc_m2m_open(struct file *file)
 		kfree(ctx);
 	}
 
+err_unlock:
 	mutex_unlock(&fimc->lock);
 	return err;
 }
