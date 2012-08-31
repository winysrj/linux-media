Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52705 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2HaNSQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Aug 2012 09:18:16 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <p.osciak@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/2] media v4l2-mem2mem: fix src/out and dst/cap num_rdy
Date: Fri, 31 Aug 2012 15:18:04 +0200
Message-Id: <1346419084-10879-3-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1346419084-10879-1-git-send-email-s.hauer@pengutronix.de>
References: <1346419084-10879-1-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

src bufs belong to out queue, dst bufs belong to in queue. Currently
this is not a real problem since all users currently need exactly one
input and one output buffer.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 include/media/v4l2-mem2mem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 16ac473..131cc4a 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -140,7 +140,7 @@ void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb);
 static inline
 unsigned int v4l2_m2m_num_src_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
 {
-	return m2m_ctx->cap_q_ctx.num_rdy;
+	return m2m_ctx->out_q_ctx.num_rdy;
 }
 
 /**
@@ -150,7 +150,7 @@ unsigned int v4l2_m2m_num_src_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
 static inline
 unsigned int v4l2_m2m_num_dst_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
 {
-	return m2m_ctx->out_q_ctx.num_rdy;
+	return m2m_ctx->cap_q_ctx.num_rdy;
 }
 
 void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx);
-- 
1.7.10.4

