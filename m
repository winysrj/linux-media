Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33348 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbbGIKKg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2015 06:10:36 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <kamil@wypas.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 09/10] [media] coda: reuse src_bufs in coda_job_ready
Date: Thu,  9 Jul 2015 12:10:20 +0200
Message-Id: <1436436621-12291-9-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
References: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_m2m_num_src_bufs_ready() function is called in multiple places
in coda_cob_ready, and there already is a variable src_bufs that is
assigned to its result. Move it to the beginning and use it everywhere.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index b265edd..267fda7 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -888,14 +888,14 @@ static void coda_pic_run_work(struct work_struct *work)
 static int coda_job_ready(void *m2m_priv)
 {
 	struct coda_ctx *ctx = m2m_priv;
+	int src_bufs = v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx);
 
 	/*
 	 * For both 'P' and 'key' frame cases 1 picture
 	 * and 1 frame are needed. In the decoder case,
 	 * the compressed frame can be in the bitstream.
 	 */
-	if (!v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) &&
-	    ctx->inst_type != CODA_INST_DECODER) {
+	if (!src_bufs && ctx->inst_type != CODA_INST_DECODER) {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "not ready: not enough video buffers.\n");
 		return 0;
@@ -911,9 +911,8 @@ static int coda_job_ready(void *m2m_priv)
 		struct list_head *meta;
 		bool stream_end;
 		int num_metas;
-		int src_bufs;
 
-		if (ctx->hold && !v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx)) {
+		if (ctx->hold && !src_bufs) {
 			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 				 "%d: not ready: on hold for more buffers.\n",
 				 ctx->idx);
@@ -927,8 +926,6 @@ static int coda_job_ready(void *m2m_priv)
 		list_for_each(meta, &ctx->buffer_meta_list)
 			num_metas++;
 
-		src_bufs = v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx);
-
 		if (!stream_end && (num_metas + src_bufs) < 2) {
 			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 				 "%d: not ready: need 2 buffers available (%d, %d)\n",
@@ -937,8 +934,8 @@ static int coda_job_ready(void *m2m_priv)
 		}
 
 
-		if (!v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) &&
-		    !stream_end && (coda_get_bitstream_payload(ctx) < 512)) {
+		if (!src_bufs && !stream_end &&
+		    (coda_get_bitstream_payload(ctx) < 512)) {
 			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 				 "%d: not ready: not enough bitstream data (%d).\n",
 				 ctx->idx, coda_get_bitstream_payload(ctx));
-- 
2.1.4

