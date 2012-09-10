Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47368 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab2IJPaN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 11:30:13 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4 05/16] media: coda: ignore coda busy status in coda_job_ready
Date: Mon, 10 Sep 2012 17:29:49 +0200
Message-Id: <1347291000-340-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
References: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
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
 drivers/media/platform/coda.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index f4b4a6f..d069787 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -738,12 +738,6 @@ static int coda_job_ready(void *m2m_priv)
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

