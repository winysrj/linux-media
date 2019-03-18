Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E87C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBB8C20989
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="qw9XYHjh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfCRObs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 10:31:48 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:59242 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbfCRObs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 10:31:48 -0400
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7D2A51AAC;
        Mon, 18 Mar 2019 15:31:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552919499;
        bh=o3u3eSCf3ji+U5B23jXSmj7kAC5UmwM1WJWCC+52i3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qw9XYHjhm6MLKWIpT+9CIhGcEJxJtEa3rC6ug6A5UueOR/ZBF6ILSolmR4oOuNtFo
         h+rjzj6GH2VFydjxyNUupcgwvRvBQZUqpdS9iONV/q8Ebp7HA6mjmRyPlXwcqIOTWU
         5SCgGz3nw5zeFmJ6qIttiQum3H4uJjiQltxdPOs0=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH v7 14/18] drm: writeback: Add job prepare and cleanup operations
Date:   Mon, 18 Mar 2019 16:31:17 +0200
Message-Id: <20190318143121.29561-15-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
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
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
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
index 40ac19848034..f89641216a44 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -2261,10 +2261,21 @@ EXPORT_SYMBOL(drm_atomic_helper_commit_cleanup_done);
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
index 0aabd401d3ca..8fa77def577f 100644
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
index cfb7be40bed7..8f3602811eb5 100644
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

