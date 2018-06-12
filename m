Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39156 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933137AbeFLNX2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 09:23:28 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] mem2mem: Remove excessive try_run call
Date: Tue, 12 Jun 2018 10:22:51 -0300
Message-Id: <20180612132251.28047-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If there is a schedulable job, v4l2_m2m_try_schedule() calls
v4l2_m2m_try_run(). This makes the unconditional v4l2_m2m_try_run()
called by v4l2_m2m_job_finish superfluous. Remove it.

Fixes: 7f98639def42 ("V4L/DVB: add memory-to-memory device helper framework for videobuf")
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index c4f963d96a79..5f9cd5b74cda 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -339,7 +339,6 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 	 * allow more than one job on the job_queue per instance, each has
 	 * to be scheduled separately after the previous one finishes. */
 	v4l2_m2m_try_schedule(m2m_ctx);
-	v4l2_m2m_try_run(m2m_dev);
 }
 EXPORT_SYMBOL(v4l2_m2m_job_finish);
 
-- 
2.17.1
