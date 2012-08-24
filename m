Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49310 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759655Ab2HXQSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 12:18:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 05/12] media: coda: ignore coda busy status in coda_job_ready
Date: Fri, 24 Aug 2012 18:17:51 +0200
Message-Id: <1345825078-3688-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
References: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

job_ready is supposed to signal whether a context is ready to be
added to the job queue, not whether the CODA is ready to run it
immediately.
Calling v4l2_m2m_job_finish at the end of coda_irq_handler already
guarantees that the coda is ready when v4l2-mem2mem eventually tries
to run the next queued job.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/video/coda.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/video/coda.c b/drivers/media/video/coda.c
index b531c25..d46a282 100644
--- a/drivers/media/video/coda.c
+++ b/drivers/media/video/coda.c
@@ -746,12 +746,6 @@ static int coda_job_ready(void *m2m_priv)
 		return 0;
 	}
 
-	if (coda_isbusy(ctx->dev)) {
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			 "not ready: coda is still busy.\n");
-		return 0;
-	}
-
 	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			"job ready\n");
 	return 1;
-- 
1.7.10.4

