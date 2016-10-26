Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:34298 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754069AbcJZI4I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 04:56:08 -0400
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [RFC PATCH v2 9/9] drm: mali-dp: Add writeback out-fence support
Date: Wed, 26 Oct 2016 09:55:08 +0100
Message-Id: <1477472108-27222-10-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
References: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If userspace has asked for an out-fence for the writeback, we add a
fence to malidp_mw_job, to be signaled when the writeback job has
completed.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 drivers/gpu/drm/arm/malidp_hw.c |    5 ++++-
 drivers/gpu/drm/arm/malidp_mw.c |   18 +++++++++++++++++-
 drivers/gpu/drm/arm/malidp_mw.h |    3 +++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/arm/malidp_hw.c b/drivers/gpu/drm/arm/malidp_hw.c
index 1689547..3032226 100644
--- a/drivers/gpu/drm/arm/malidp_hw.c
+++ b/drivers/gpu/drm/arm/malidp_hw.c
@@ -707,8 +707,11 @@ static irqreturn_t malidp_se_irq(int irq, void *arg)
 		unsigned long irqflags;
 		/*
 		 * We can't unreference the framebuffer here, so we queue it
-		 * up on our threaded handler.
+		 * up on our threaded handler. However, signal the fence
+		 * as soon as possible
 		 */
+		malidp_mw_job_signal(drm, malidp->current_mw, 0);
+
 		spin_lock_irqsave(&malidp->mw_lock, irqflags);
 		list_add_tail(&malidp->current_mw->list,
 			      &malidp->finished_mw_jobs);
diff --git a/drivers/gpu/drm/arm/malidp_mw.c b/drivers/gpu/drm/arm/malidp_mw.c
index 69e423c..05880b1 100644
--- a/drivers/gpu/drm/arm/malidp_mw.c
+++ b/drivers/gpu/drm/arm/malidp_mw.c
@@ -34,11 +34,24 @@ struct malidp_mw_connector_state {
 	u8 n_planes;
 };
 
+void malidp_mw_job_signal(struct drm_device *drm,
+			  struct malidp_mw_job *job, int status)
+{
+	DRM_DEV_DEBUG_DRIVER(drm->dev, "MW job signal %p\n", job);
+
+	if (!job->fence)
+		return;
+
+	job->fence->status = status;
+	fence_signal(job->fence);
+}
+
 void malidp_mw_job_cleanup(struct drm_device *drm,
 				  struct malidp_mw_job *job)
 {
 	DRM_DEV_DEBUG_DRIVER(drm->dev, "MW job cleanup %p\n", job);
 	drm_framebuffer_unreference(job->fb);
+	fence_put(job->fence);
 	kfree(job);
 }
 
@@ -107,8 +120,10 @@ static void malidp_mw_connector_destroy_state(struct drm_connector *connector,
 	struct malidp_mw_connector_state *mw_state = to_mw_state(state);
 
 	__drm_atomic_helper_connector_destroy_state(&mw_state->base);
-	if (mw_state->job)
+	if (mw_state->job) {
+		malidp_mw_job_signal(connector->dev, mw_state->job, -EPIPE);
 		malidp_mw_job_cleanup(connector->dev, mw_state->job);
+	}
 	kfree(mw_state);
 }
 
@@ -177,6 +192,7 @@ malidp_mw_encoder_atomic_check(struct drm_encoder *encoder,
 	/* We can take ownership of the framebuffer reference in the job. */
 	mw_state->job->fb = conn_state->fb;
 	conn_state->fb = NULL;
+	mw_state->job->fence = fence_get(conn_state->out_fence);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/arm/malidp_mw.h b/drivers/gpu/drm/arm/malidp_mw.h
index db7b2b0..5d0bd1d 100644
--- a/drivers/gpu/drm/arm/malidp_mw.h
+++ b/drivers/gpu/drm/arm/malidp_mw.h
@@ -15,11 +15,14 @@
 struct malidp_mw_job {
 	struct list_head list;
 	struct drm_framebuffer *fb;
+	struct fence *fence;
 };
 
 int malidp_mw_connector_init(struct drm_device *drm);
 void malidp_mw_atomic_commit(struct drm_device *drm,
 			     struct drm_atomic_state *old_state);
+void malidp_mw_job_signal(struct drm_device *drm,
+			  struct malidp_mw_job *job, int status);
 void malidp_mw_job_cleanup(struct drm_device *drm,
 				  struct malidp_mw_job *job);
 #endif
-- 
1.7.9.5

