Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B55BC43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D6342177E
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:05:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="P4SUvEUk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfCMAF6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:05:58 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42062 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbfCMAF5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:05:57 -0400
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6CACC2DF;
        Wed, 13 Mar 2019 01:05:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552435551;
        bh=P+o7SSgDmsfLyf3j3mF4m5gXu7U7r/xmo3CjhgJMII4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4SUvEUk/hFD1Ldzv16ex1rbL3KAntYGJhqWlIZTfouFAHjblXR0NlkakmmgMZw/w
         vsr7DfWO0DV+EHnHf0st5icZ5PygSiBnpAm4nKckD5sZyQoQGE4VROniS5J29yHXGQ
         8i/gPOLGHDI83JUbTeMBb5fE6eGHZBEm5IEqHLao=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v6 12/18] drm: writeback: Cleanup job ownership handling when queuing job
Date:   Wed, 13 Mar 2019 02:05:26 +0200
Message-Id: <20190313000532.7087-13-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The drm_writeback_queue_job() function takes ownership of the passed job
and requires the caller to manually set the connector state
writeback_job pointer to NULL. To simplify drivers and avoid errors
(such as the missing NULL set in the vc4 driver), pass the connector
state pointer to the function instead of the job pointer, and set the
writeback_job pointer to NULL internally.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Brian Starkey <brian.starkey@arm.com>
Acked-by: Eric Anholt <eric@anholt.net>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
---
 drivers/gpu/drm/arm/malidp_mw.c |  3 +--
 drivers/gpu/drm/drm_writeback.c | 15 ++++++++++-----
 drivers/gpu/drm/vc4/vc4_txp.c   |  2 +-
 include/drm/drm_writeback.h     |  2 +-
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/arm/malidp_mw.c b/drivers/gpu/drm/arm/malidp_mw.c
index 041a64dc7167..87627219ce3b 100644
--- a/drivers/gpu/drm/arm/malidp_mw.c
+++ b/drivers/gpu/drm/arm/malidp_mw.c
@@ -252,8 +252,7 @@ void malidp_mw_atomic_commit(struct drm_device *drm,
 				     &mw_state->addrs[0],
 				     mw_state->format);
 
-		drm_writeback_queue_job(mw_conn, conn_state->writeback_job);
-		conn_state->writeback_job = NULL;
+		drm_writeback_queue_job(mw_conn, conn_state);
 		hwdev->hw->enable_memwrite(hwdev, mw_state->addrs,
 					   mw_state->pitches, mw_state->n_planes,
 					   fb->width, fb->height, mw_state->format,
diff --git a/drivers/gpu/drm/drm_writeback.c b/drivers/gpu/drm/drm_writeback.c
index c20e6fe00cb3..338b993d7c9f 100644
--- a/drivers/gpu/drm/drm_writeback.c
+++ b/drivers/gpu/drm/drm_writeback.c
@@ -242,11 +242,12 @@ EXPORT_SYMBOL(drm_writeback_connector_init);
 /**
  * drm_writeback_queue_job - Queue a writeback job for later signalling
  * @wb_connector: The writeback connector to queue a job on
- * @job: The job to queue
+ * @conn_state: The connector state containing the job to queue
  *
- * This function adds a job to the job_queue for a writeback connector. It
- * should be considered to take ownership of the writeback job, and so any other
- * references to the job must be cleared after calling this function.
+ * This function adds the job contained in @conn_state to the job_queue for a
+ * writeback connector. It takes ownership of the writeback job and sets the
+ * @conn_state->writeback_job to NULL, and so no access to the job may be
+ * performed by the caller after this function returns.
  *
  * Drivers must ensure that for a given writeback connector, jobs are queued in
  * exactly the same order as they will be completed by the hardware (and
@@ -258,10 +259,14 @@ EXPORT_SYMBOL(drm_writeback_connector_init);
  * See also: drm_writeback_signal_completion()
  */
 void drm_writeback_queue_job(struct drm_writeback_connector *wb_connector,
-			     struct drm_writeback_job *job)
+			     struct drm_connector_state *conn_state)
 {
+	struct drm_writeback_job *job;
 	unsigned long flags;
 
+	job = conn_state->writeback_job;
+	conn_state->writeback_job = NULL;
+
 	spin_lock_irqsave(&wb_connector->job_lock, flags);
 	list_add_tail(&job->list_entry, &wb_connector->job_queue);
 	spin_unlock_irqrestore(&wb_connector->job_lock, flags);
diff --git a/drivers/gpu/drm/vc4/vc4_txp.c b/drivers/gpu/drm/vc4/vc4_txp.c
index aa279b5b0de7..5dabd91f2d7e 100644
--- a/drivers/gpu/drm/vc4/vc4_txp.c
+++ b/drivers/gpu/drm/vc4/vc4_txp.c
@@ -327,7 +327,7 @@ static void vc4_txp_connector_atomic_commit(struct drm_connector *conn,
 
 	TXP_WRITE(TXP_DST_CTRL, ctrl);
 
-	drm_writeback_queue_job(&txp->connector, conn_state->writeback_job);
+	drm_writeback_queue_job(&txp->connector, conn_state);
 }
 
 static const struct drm_connector_helper_funcs vc4_txp_connector_helper_funcs = {
diff --git a/include/drm/drm_writeback.h b/include/drm/drm_writeback.h
index 23df9d463003..47662c362743 100644
--- a/include/drm/drm_writeback.h
+++ b/include/drm/drm_writeback.h
@@ -123,7 +123,7 @@ int drm_writeback_connector_init(struct drm_device *dev,
 				 const u32 *formats, int n_formats);
 
 void drm_writeback_queue_job(struct drm_writeback_connector *wb_connector,
-			     struct drm_writeback_job *job);
+			     struct drm_connector_state *conn_state);
 
 void drm_writeback_cleanup_job(struct drm_writeback_job *job);
 
-- 
Regards,

Laurent Pinchart

