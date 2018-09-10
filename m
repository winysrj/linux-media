Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58198 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728375AbeIJUQp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 16:16:45 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 2/2] vicodec: Drop unused job_abort()
Date: Mon, 10 Sep 2018 12:21:54 -0300
Message-Id: <20180910152154.14291-2-ezequiel@collabora.com>
In-Reply-To: <20180910152154.14291-1-ezequiel@collabora.com>
References: <20180910152154.14291-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vicodec does not use the aborting field. In fact, this driver
can't really cancel any work, since it performs all the work
in device_run().

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index bbc48fcaa563..8d455c42163e 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -112,8 +112,6 @@ struct vicodec_ctx {
 
 	struct v4l2_ctrl_handler hdl;
 
-	/* Abort requested by m2m */
-	int			aborting;
 	struct vb2_v4l2_buffer *last_src_buf;
 	struct vb2_v4l2_buffer *last_dst_buf;
 
@@ -376,14 +374,6 @@ static int job_ready(void *priv)
 	return 1;
 }
 
-static void job_abort(void *priv)
-{
-	struct vicodec_ctx *ctx = priv;
-
-	/* Will cancel the transaction in the next interrupt handler */
-	ctx->aborting = 1;
-}
-
 /*
  * video ioctls
  */
@@ -1268,7 +1258,6 @@ static const struct video_device vicodec_videodev = {
 
 static const struct v4l2_m2m_ops m2m_ops = {
 	.device_run	= device_run,
-	.job_abort	= job_abort,
 	.job_ready	= job_ready,
 };
 
-- 
2.19.0.rc2
