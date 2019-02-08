Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BE1C282CB
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5295E2084D
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbfBHQVr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 11:21:47 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55456 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbfBHQVr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 11:21:47 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 88E6D263995
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 10/10] media: v4l2-mem2mem: Correct return type for mem2mem buffer helpers
Date:   Fri,  8 Feb 2019 13:17:48 -0300
Message-Id: <20190208161748.5862-11-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208161748.5862-1-ezequiel@collabora.com>
References: <20190208161748.5862-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This commit changes the return type of mem2mem buffer handling API.
Namely, these functions:

 v4l2_m2m_next_buf
 v4l2_m2m_last_buf
 v4l2_m2m_buf_remove
 v4l2_m2m_next_src_buf
 v4l2_m2m_next_dst_buf
 v4l2_m2m_last_src_buf
 v4l2_m2m_last_dst_buf
 v4l2_m2m_src_buf_remove
 v4l2_m2m_dst_buf_remove

which currently return void pointer.

In every case, the actual return type is a struct vb2_v4l2_buffer
pointer. Change the return type of the listed functions,
so type checking can be properly used.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c |  6 +++---
 include/media/v4l2-mem2mem.h           | 18 +++++++++---------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 1494d0d5951a..18fd80c96083 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -131,7 +131,7 @@ struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL(v4l2_m2m_get_vq);
 
-void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx)
+struct vb2_v4l2_buffer *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx)
 {
 	struct v4l2_m2m_buffer *b;
 	unsigned long flags;
@@ -149,7 +149,7 @@ void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx)
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_next_buf);
 
-void *v4l2_m2m_last_buf(struct v4l2_m2m_queue_ctx *q_ctx)
+struct vb2_v4l2_buffer *v4l2_m2m_last_buf(struct v4l2_m2m_queue_ctx *q_ctx)
 {
 	struct v4l2_m2m_buffer *b;
 	unsigned long flags;
@@ -167,7 +167,7 @@ void *v4l2_m2m_last_buf(struct v4l2_m2m_queue_ctx *q_ctx)
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_last_buf);
 
-void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx)
+struct vb2_v4l2_buffer *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx)
 {
 	struct v4l2_m2m_buffer *b;
 	unsigned long flags;
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 47c6d9aa0bf4..7344bef0cdba 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -425,7 +425,7 @@ unsigned int v4l2_m2m_num_dst_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
  *
  * @q_ctx: pointer to struct @v4l2_m2m_queue_ctx
  */
-void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx);
+struct vb2_v4l2_buffer *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx);
 
 /**
  * v4l2_m2m_next_src_buf() - return next source buffer from the list of ready
@@ -433,7 +433,7 @@ void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx);
  *
  * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  */
-static inline void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
+static inline struct vb2_v4l2_buffer *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
 {
 	return v4l2_m2m_next_buf(&m2m_ctx->out_q_ctx);
 }
@@ -444,7 +444,7 @@ static inline void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
  *
  * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  */
-static inline void *v4l2_m2m_next_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
+static inline struct vb2_v4l2_buffer *v4l2_m2m_next_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
 {
 	return v4l2_m2m_next_buf(&m2m_ctx->cap_q_ctx);
 }
@@ -454,7 +454,7 @@ static inline void *v4l2_m2m_next_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
  *
  * @q_ctx: pointer to struct @v4l2_m2m_queue_ctx
  */
-void *v4l2_m2m_last_buf(struct v4l2_m2m_queue_ctx *q_ctx);
+struct vb2_v4l2_buffer *v4l2_m2m_last_buf(struct v4l2_m2m_queue_ctx *q_ctx);
 
 /**
  * v4l2_m2m_last_src_buf() - return last destination buffer from the list of
@@ -462,7 +462,7 @@ void *v4l2_m2m_last_buf(struct v4l2_m2m_queue_ctx *q_ctx);
  *
  * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  */
-static inline void *v4l2_m2m_last_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
+static inline struct vb2_v4l2_buffer *v4l2_m2m_last_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
 {
 	return v4l2_m2m_last_buf(&m2m_ctx->out_q_ctx);
 }
@@ -473,7 +473,7 @@ static inline void *v4l2_m2m_last_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
  *
  * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  */
-static inline void *v4l2_m2m_last_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
+static inline struct vb2_v4l2_buffer *v4l2_m2m_last_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
 {
 	return v4l2_m2m_last_buf(&m2m_ctx->cap_q_ctx);
 }
@@ -547,7 +547,7 @@ struct vb2_queue *v4l2_m2m_get_dst_vq(struct v4l2_m2m_ctx *m2m_ctx)
  *
  * @q_ctx: pointer to struct @v4l2_m2m_queue_ctx
  */
-void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx);
+struct vb2_v4l2_buffer *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx);
 
 /**
  * v4l2_m2m_src_buf_remove() - take off a source buffer from the list of ready
@@ -555,7 +555,7 @@ void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx);
  *
  * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  */
-static inline void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
+static inline struct vb2_v4l2_buffer *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
 {
 	return v4l2_m2m_buf_remove(&m2m_ctx->out_q_ctx);
 }
@@ -566,7 +566,7 @@ static inline void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
  *
  * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  */
-static inline void *v4l2_m2m_dst_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
+static inline struct vb2_v4l2_buffer *v4l2_m2m_dst_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
 {
 	return v4l2_m2m_buf_remove(&m2m_ctx->cap_q_ctx);
 }
-- 
2.20.1

