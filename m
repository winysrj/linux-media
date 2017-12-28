Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46950 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753362AbdL1OSW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 09:18:22 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
Subject: [PATCH 1/1] vb2: Enforce VB2_MAX_FRAME in vb2_core_reqbufs better
Date: Thu, 28 Dec 2017 16:18:20 +0200
Message-Id: <20171228141820.28239-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The check for the number of buffers requested against the maximum,
VB2_MAX_FRAME, was performed before checking queue's minimum number of
buffers. Reverse the order, thus ensuring that under no circumstances
num_buffers exceeds VB2_MAX_FRAME here.

Also add a warning of the condition.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index a8589d96ef72..7cade8189bf2 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -696,8 +696,9 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	/*
 	 * Make sure the requested values and current defaults are sane.
 	 */
-	num_buffers = min_t(unsigned int, *count, VB2_MAX_FRAME);
-	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
+	WARN_ON(q->min_buffers_needed > VB2_MAX_FRAME);
+	num_buffers = max_t(unsigned int, *count, q->min_buffers_needed);
+	num_buffers = min_t(unsigned int, num_buffers, VB2_MAX_FRAME);
 	memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
 	q->memory = memory;
 
-- 
2.11.0
