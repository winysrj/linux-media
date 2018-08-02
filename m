Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50304 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729763AbeHBWlv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 18:41:51 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        paul.kocialkowski@bootlin.com, maxime.ripard@bootlin.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v4 1/6] mem2mem: Require capture and output mutexes to match
Date: Thu,  2 Aug 2018 17:48:45 -0300
Message-Id: <20180802204850.31633-2-ezequiel@collabora.com>
In-Reply-To: <20180802204850.31633-1-ezequiel@collabora.com>
References: <20180802204850.31633-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, all the mem2mem driver either use a single mutex
to lock the capture and output videobuf2 queues, or don't
set any mutex.

This means the mutexes match, and so the mem2mem framework
is able to set the m2m context lock.

Enforce this by making it mandatory for drivers to set
the same capture and output mutex, or not set any mutex at all.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 0a93c5b173c2..b7005894292c 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -887,12 +887,14 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
 	if (ret)
 		goto err;
 	/*
-	 * If both queues use same mutex assign it as the common buffer
-	 * queues lock to the m2m context. This lock is used in the
-	 * v4l2_m2m_ioctl_* helpers.
+	 * Both queues should use same the mutex to lock the m2m context.
+	 * This lock is used in some v4l2_m2m_* helpers.
 	 */
-	if (out_q_ctx->q.lock == cap_q_ctx->q.lock)
-		m2m_ctx->q_lock = out_q_ctx->q.lock;
+	if (WARN_ON(out_q_ctx->q.lock != cap_q_ctx->q.lock)) {
+		ret = -EINVAL;
+		goto err;
+	}
+	m2m_ctx->q_lock = out_q_ctx->q.lock;
 
 	return m2m_ctx;
 err:
-- 
2.18.0
