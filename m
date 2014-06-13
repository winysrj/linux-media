Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44491 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbaFMQJL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:11 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 19/30] [media] v4l2-mem2mem: export v4l2_m2m_try_schedule
Date: Fri, 13 Jun 2014 18:08:45 +0200
Message-Id: <1402675736-15379-20-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michael Olbrich <m.olbrich@pengutronix.de>

Some drivers might allow to decode remaining frames from an internal ringbuffer
after a decoder stop command. Allow those to call v4l2_m2m_try_schedule
directly.

Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 3 ++-
 include/media/v4l2-mem2mem.h           | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 178ce96..5f5c175 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -208,7 +208,7 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
  * An example of the above could be an instance that requires more than one
  * src/dst buffer per transaction.
  */
-static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
+void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 {
 	struct v4l2_m2m_dev *m2m_dev;
 	unsigned long flags_job, flags_out, flags_cap;
@@ -274,6 +274,7 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 
 	v4l2_m2m_try_run(m2m_dev);
 }
+EXPORT_SYMBOL(v4l2_m2m_try_schedule);
 
 /**
  * v4l2_m2m_cancel_job() - cancel pending jobs for the context
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 12ea5a6..c5f3914 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -95,6 +95,8 @@ void *v4l2_m2m_get_curr_priv(struct v4l2_m2m_dev *m2m_dev);
 struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
 				       enum v4l2_buf_type type);
 
+void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx);
+
 void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 			 struct v4l2_m2m_ctx *m2m_ctx);
 
-- 
2.0.0.rc2

