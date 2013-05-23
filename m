Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46116 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759442Ab3EWOnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 10:43:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 9/9] [media] coda: do not call v4l2_m2m_job_finish from .job_abort
Date: Thu, 23 May 2013 16:43:01 +0200
Message-Id: <1369320181-17933-10-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
References: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If we just declare the job finished here while the CODA is still
running, the call to v4l2_m2m_ctx_release in coda_release, which
is supposed to wait for a running job to finish, will return
immediately and free memory that the CODA is still using.

Just set the 'aborting' flag and let coda_irq_handler deal with it.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index f5d4144..df4ada88 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -821,6 +821,12 @@ static int coda_job_ready(void *m2m_priv)
 		return 0;
 	}
 
+	if (ctx->aborting) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "not ready: aborting\n");
+		return 0;
+	}
+
 	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			"job ready\n");
 	return 1;
@@ -829,14 +835,11 @@ static int coda_job_ready(void *m2m_priv)
 static void coda_job_abort(void *priv)
 {
 	struct coda_ctx *ctx = priv;
-	struct coda_dev *dev = ctx->dev;
 
 	ctx->aborting = 1;
 
 	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 		 "Aborting task\n");
-
-	v4l2_m2m_job_finish(dev->m2m_dev, ctx->m2m_ctx);
 }
 
 static void coda_lock(void *m2m_priv)
-- 
1.8.2.rc2

