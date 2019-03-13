Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF6FC4360F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12B952177E
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:06:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="JF0ZnF0N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfCMAGB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:06:01 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42062 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbfCMAF7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:05:59 -0400
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id EB66433C;
        Wed, 13 Mar 2019 01:05:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552435553;
        bh=3kwtNxhh66XnvzCIFHxRiWXrQ5907zNY7PvbMUM3XXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JF0ZnF0NYNZU0HgZMcgg2JLceqC10TSXAF+4h455j10H8pvUvARBNbqV9SI2lhADp
         lPQmbbqX9dig2AXiZSWQNcFo1lwqbmFYe9t8v69CbV1aDVgSr+DoOSp9wQ0+AZP1Fv
         /DPSJY8XLd1bFuwKm5a8uY3KrniDcJRJ7SMIDZzs=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v6 14/18] drm: writeback: Add job prepare and cleanup operations
Date:   Wed, 13 Mar 2019 02:05:28 +0200
Message-Id: <20190313000532.7087-15-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

As writeback jobs contain a framebuffer, drivers may need to prepare and
cleanup them the same way they can prepare and cleanup framebuffers for
planes. Add two new optional connector helper operations,
.prepare_writeback_job() and .cleanup_writeback_job() to support this.

The job prepare operation is called from
drm_atomic_helper_prepare_planes() to avoid a new atomic commit helper
that would need to be called by all drivers not using
drm_atomic_helper_commit(). The job cleanup operation is called from the
existing drm_writeback_cleanup_job() function, invoked both when
destroying the job as part of a aborted commit, or when the job
completes.

The drm_writeback_job structure is extended with a priv field to let
drivers store per-job data, such as mappings related to the writeback
framebuffer.

For internal plumbing reasons the drm_writeback_job structure needs to
store a back-pointer to the drm_writeback_connector. To avoid pushing
too much writeback-specific knowledge to drm_atomic_uapi.c, create a
drm_writeback_set_fb() function, move the writeback job setup code
there, and set the connector backpointer. The prepare_signaling()
function doesn't need to allocate writeback jobs and can ignore
connectors without a job, as it is called after the writeback jobs are
allocated to store framebuffers, and a writeback fence with a
framebuffer is an invalid configuration that gets rejected by the commit
check.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
Changes since v5:

- Export drm_writeback_prepare_job()
- Check for .prepare_writeback_job() in drm_writeback_prepare_job()
---
 drivers/gpu/drm/drm_atomic_helper.c      | 11 ++++++
 drivers/gpu/drm/drm_atomic_uapi.c        | 31 +++++------------
 drivers/gpu/drm/drm_writeback.c          | 44 ++++++++++++++++++++++++
 include/drm/drm_modeset_helper_vtables.h |  7 ++++
 include/drm/drm_writeback.h              | 28 ++++++++++++++-
 5 files changed, 97 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 6fe2303fccd9..70a4886c6e65 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -2245,10 +2245,21 @@ EXPORT_SYMBOL(drm_atomic_helper_commit_cleanup_done);
 int drm_atomic_helper_prepare_planes(struct drm_device *dev,
 				     struct drm_atomic_state *state)
 {
+	struct drm_connector *connector;
+	struct drm_connector_state *new_conn_state;
 	struct drm_plane *plane;
 	struct drm_plane_state *new_plane_state;
 	int ret, i, j;
 
+	for_each_new_connector_in_state(state, connector, new_conn_state, i) {
+		if (!new_conn_state->writeback_job)
+			continue;
+
+		ret = drm_writeback_prepare_job(new_conn_state->writeback_job);
+		if (ret < 0)
+			return ret;
+	}
+
 	for_each_new_plane_in_state(state, plane, new_plane_state, i) {
 		const struct drm_plane_helper_funcs *funcs;
 
diff --git a/drivers/gpu/drm/drm_atomic_uapi.c b/drivers/gpu/drm/drm_atomic_uapi.c
index c40889888a16..e802152a01ad 100644
--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -647,28 +647,15 @@ drm_atomic_plane_get_property(struct drm_plane *plane,
 	return 0;
 }
 
-static struct drm_writeback_job *
-drm_atomic_get_writeback_job(struct drm_connector_state *conn_state)
-{
-	WARN_ON(conn_state->connector->connector_type != DRM_MODE_CONNECTOR_WRITEBACK);
-
-	if (!conn_state->writeback_job)
-		conn_state->writeback_job =
-			kzalloc(sizeof(*conn_state->writeback_job), GFP_KERNEL);
-
-	return conn_state->writeback_job;
-}
-
 static int drm_atomic_set_writeback_fb_for_connector(
 		struct drm_connector_state *conn_state,
 		struct drm_framebuffer *fb)
 {
-	struct drm_writeback_job *job =
-		drm_atomic_get_writeback_job(conn_state);
-	if (!job)
-		return -ENOMEM;
+	int ret;
 
-	drm_framebuffer_assign(&job->fb, fb);
+	ret = drm_writeback_set_fb(conn_state, fb);
+	if (ret < 0)
+		return ret;
 
 	if (fb)
 		DRM_DEBUG_ATOMIC("Set [FB:%d] for connector state %p\n",
@@ -1158,19 +1145,17 @@ static int prepare_signaling(struct drm_device *dev,
 
 	for_each_new_connector_in_state(state, conn, conn_state, i) {
 		struct drm_writeback_connector *wb_conn;
-		struct drm_writeback_job *job;
 		struct drm_out_fence_state *f;
 		struct dma_fence *fence;
 		s32 __user *fence_ptr;
 
+		if (!conn_state->writeback_job)
+			continue;
+
 		fence_ptr = get_out_fence_for_connector(state, conn);
 		if (!fence_ptr)
 			continue;
 
-		job = drm_atomic_get_writeback_job(conn_state);
-		if (!job)
-			return -ENOMEM;
-
 		f = krealloc(*fence_state, sizeof(**fence_state) *
 			     (*num_fences + 1), GFP_KERNEL);
 		if (!f)
@@ -1192,7 +1177,7 @@ static int prepare_signaling(struct drm_device *dev,
 			return ret;
 		}
 
-		job->out_fence = fence;
+		conn_state->writeback_job->out_fence = fence;
 	}
 
 	/*
diff --git a/drivers/gpu/drm/drm_writeback.c b/drivers/gpu/drm/drm_writeback.c
index 1b497d3530b5..79ac014701c8 100644
--- a/drivers/gpu/drm/drm_writeback.c
+++ b/drivers/gpu/drm/drm_writeback.c
@@ -239,6 +239,43 @@ int drm_writeback_connector_init(struct drm_device *dev,
 }
 EXPORT_SYMBOL(drm_writeback_connector_init);
 
+int drm_writeback_set_fb(struct drm_connector_state *conn_state,
+			 struct drm_framebuffer *fb)
+{
+	WARN_ON(conn_state->connector->connector_type != DRM_MODE_CONNECTOR_WRITEBACK);
+
+	if (!conn_state->writeback_job) {
+		conn_state->writeback_job =
+			kzalloc(sizeof(*conn_state->writeback_job), GFP_KERNEL);
+		if (!conn_state->writeback_job)
+			return -ENOMEM;
+
+		conn_state->writeback_job->connector =
+			drm_connector_to_writeback(conn_state->connector);
+	}
+
+	drm_framebuffer_assign(&conn_state->writeback_job->fb, fb);
+	return 0;
+}
+
+int drm_writeback_prepare_job(struct drm_writeback_job *job)
+{
+	struct drm_writeback_connector *connector = job->connector;
+	const struct drm_connector_helper_funcs *funcs =
+		connector->base.helper_private;
+	int ret;
+
+	if (funcs->prepare_writeback_job) {
+		ret = funcs->prepare_writeback_job(connector, job);
+		if (ret < 0)
+			return ret;
+	}
+
+	job->prepared = true;
+	return 0;
+}
+EXPORT_SYMBOL(drm_writeback_prepare_job);
+
 /**
  * drm_writeback_queue_job - Queue a writeback job for later signalling
  * @wb_connector: The writeback connector to queue a job on
@@ -275,6 +312,13 @@ EXPORT_SYMBOL(drm_writeback_queue_job);
 
 void drm_writeback_cleanup_job(struct drm_writeback_job *job)
 {
+	struct drm_writeback_connector *connector = job->connector;
+	const struct drm_connector_helper_funcs *funcs =
+		connector->base.helper_private;
+
+	if (job->prepared && funcs->cleanup_writeback_job)
+		funcs->cleanup_writeback_job(connector, job);
+
 	if (job->fb)
 		drm_framebuffer_put(job->fb);
 
diff --git a/include/drm/drm_modeset_helper_vtables.h b/include/drm/drm_modeset_helper_vtables.h
index 61142aa0ab23..73d03fe66799 100644
--- a/include/drm/drm_modeset_helper_vtables.h
+++ b/include/drm/drm_modeset_helper_vtables.h
@@ -49,6 +49,8 @@
  */
 
 enum mode_set_atomic;
+struct drm_writeback_connector;
+struct drm_writeback_job;
 
 /**
  * struct drm_crtc_helper_funcs - helper operations for CRTCs
@@ -989,6 +991,11 @@ struct drm_connector_helper_funcs {
 	 */
 	void (*atomic_commit)(struct drm_connector *connector,
 			      struct drm_connector_state *state);
+
+	int (*prepare_writeback_job)(struct drm_writeback_connector *connector,
+				     struct drm_writeback_job *job);
+	void (*cleanup_writeback_job)(struct drm_writeback_connector *connector,
+				      struct drm_writeback_job *job);
 };
 
 /**
diff --git a/include/drm/drm_writeback.h b/include/drm/drm_writeback.h
index 47662c362743..777c14c847f0 100644
--- a/include/drm/drm_writeback.h
+++ b/include/drm/drm_writeback.h
@@ -79,6 +79,20 @@ struct drm_writeback_connector {
 };
 
 struct drm_writeback_job {
+	/**
+	 * @connector:
+	 *
+	 * Back-pointer to the writeback connector associated with the job
+	 */
+	struct drm_writeback_connector *connector;
+
+	/**
+	 * @prepared:
+	 *
+	 * Set when the job has been prepared with drm_writeback_prepare_job()
+	 */
+	bool prepared;
+
 	/**
 	 * @cleanup_work:
 	 *
@@ -98,7 +112,7 @@ struct drm_writeback_job {
 	 * @fb:
 	 *
 	 * Framebuffer to be written to by the writeback connector. Do not set
-	 * directly, use drm_atomic_set_writeback_fb_for_connector()
+	 * directly, use drm_writeback_set_fb()
 	 */
 	struct drm_framebuffer *fb;
 
@@ -108,6 +122,13 @@ struct drm_writeback_job {
 	 * Fence which will signal once the writeback has completed
 	 */
 	struct dma_fence *out_fence;
+
+	/**
+	 * @priv:
+	 *
+	 * Driver-private data
+	 */
+	void *priv;
 };
 
 static inline struct drm_writeback_connector *
@@ -122,6 +143,11 @@ int drm_writeback_connector_init(struct drm_device *dev,
 				 const struct drm_encoder_helper_funcs *enc_helper_funcs,
 				 const u32 *formats, int n_formats);
 
+int drm_writeback_set_fb(struct drm_connector_state *conn_state,
+			 struct drm_framebuffer *fb);
+
+int drm_writeback_prepare_job(struct drm_writeback_job *job);
+
 void drm_writeback_queue_job(struct drm_writeback_connector *wb_connector,
 			     struct drm_connector_state *conn_state);
 
-- 
Regards,

Laurent Pinchart

