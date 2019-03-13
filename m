Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79445C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 498B1217F4
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:06:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="eSTi5iob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfCMAGA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:06:00 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42054 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbfCMAF6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:05:58 -0400
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 252B59E5;
        Wed, 13 Mar 2019 01:05:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552435552;
        bh=yfE2KNDjlDPMKSnmLmFhTXuTqMzrzTxl0sL5vZ/jyhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSTi5iobdBYXlQPvAzWvNNSDcHkYW+IVxssml9IXNqKfj8UGRY1N7FhNG4iPi9W/N
         9DHxl9cgSCIrllyjXxgj4t1FlfXoQzXne9X97MdvNrjkEykiLjCEsUmZwA4/01hTGl
         dNRrkNtFsMuMjc2Jw/QTLaGuwYdWtB4prGUoOpDA=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v6 13/18] drm: writeback: Fix leak of writeback job
Date:   Wed, 13 Mar 2019 02:05:27 +0200
Message-Id: <20190313000532.7087-14-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Writeback jobs are allocated when the WRITEBACK_FB_ID is set, and
deleted when the jobs complete. This results in both a memory leak of
the job and a leak of the framebuffer if the atomic commit returns
before the job is queued for processing, for instance if the atomic
check fails or if the commit runs in test-only mode.

Fix this by implementing the drm_writeback_cleanup_job() function and
calling it from __drm_atomic_helper_connector_destroy_state(). As
writeback jobs are removed from the state when they're queued for
processing, any job left in the state when the state gets destroyed
needs to be cleaned up.

The existing declaration of the drm_writeback_cleanup_job() function
without an implementation hints that this problem was considered, but
never addressed.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Brian Starkey <brian.starkey@arm.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
---
Changes since v5:

- Export drm_writeback_cleanup_job()
---
 drivers/gpu/drm/drm_atomic_state_helper.c |  4 ++++
 drivers/gpu/drm/drm_writeback.c           | 14 +++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_state_helper.c b/drivers/gpu/drm/drm_atomic_state_helper.c
index 4985384e51f6..59ffb6b9c745 100644
--- a/drivers/gpu/drm/drm_atomic_state_helper.c
+++ b/drivers/gpu/drm/drm_atomic_state_helper.c
@@ -30,6 +30,7 @@
 #include <drm/drm_connector.h>
 #include <drm/drm_atomic.h>
 #include <drm/drm_device.h>
+#include <drm/drm_writeback.h>
 
 #include <linux/slab.h>
 #include <linux/dma-fence.h>
@@ -412,6 +413,9 @@ __drm_atomic_helper_connector_destroy_state(struct drm_connector_state *state)
 
 	if (state->commit)
 		drm_crtc_commit_put(state->commit);
+
+	if (state->writeback_job)
+		drm_writeback_cleanup_job(state->writeback_job);
 }
 EXPORT_SYMBOL(__drm_atomic_helper_connector_destroy_state);
 
diff --git a/drivers/gpu/drm/drm_writeback.c b/drivers/gpu/drm/drm_writeback.c
index 338b993d7c9f..1b497d3530b5 100644
--- a/drivers/gpu/drm/drm_writeback.c
+++ b/drivers/gpu/drm/drm_writeback.c
@@ -273,6 +273,15 @@ void drm_writeback_queue_job(struct drm_writeback_connector *wb_connector,
 }
 EXPORT_SYMBOL(drm_writeback_queue_job);
 
+void drm_writeback_cleanup_job(struct drm_writeback_job *job)
+{
+	if (job->fb)
+		drm_framebuffer_put(job->fb);
+
+	kfree(job);
+}
+EXPORT_SYMBOL(drm_writeback_cleanup_job);
+
 /*
  * @cleanup_work: deferred cleanup of a writeback job
  *
@@ -285,10 +294,9 @@ static void cleanup_work(struct work_struct *work)
 	struct drm_writeback_job *job = container_of(work,
 						     struct drm_writeback_job,
 						     cleanup_work);
-	drm_framebuffer_put(job->fb);
-	kfree(job);
-}
 
+	drm_writeback_cleanup_job(job);
+}
 
 /**
  * drm_writeback_signal_completion - Signal the completion of a writeback job
-- 
Regards,

Laurent Pinchart

