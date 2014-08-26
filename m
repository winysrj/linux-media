Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 19/35] [media] g2d: remove unused var
Date: Tue, 26 Aug 2014 18:54:55 -0300
Message-Id: <1409090111-8290-20-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/s5p-g2d/g2d.c: In function 'job_abort':
drivers/media/platform/s5p-g2d/g2d.c:493:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
  int ret;
      ^

The job_abort function returns void. No sense to get the
returned argument, if this won't be used.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/s5p-g2d/g2d.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 357af1ebaeda..d79e214ce8ce 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -490,14 +490,13 @@ static void job_abort(void *prv)
 {
 	struct g2d_ctx *ctx = prv;
 	struct g2d_dev *dev = ctx->dev;
-	int ret;
 
 	if (dev->curr == NULL) /* No job currently running */
 		return;
 
-	ret = wait_event_timeout(dev->irq_queue,
-		dev->curr == NULL,
-		msecs_to_jiffies(G2D_TIMEOUT));
+	wait_event_timeout(dev->irq_queue,
+			   dev->curr == NULL,
+			   msecs_to_jiffies(G2D_TIMEOUT));
 }
 
 static void device_run(void *prv)
-- 
1.9.3

