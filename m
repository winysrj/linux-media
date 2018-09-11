Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:6684 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbeIKQh0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 12:37:26 -0400
From: Johan Fjeldtvedt <johfjeld@cisco.com>
To: linux-media@vger.kernel.org
Cc: hansverk@cisco.com, Johan Fjeldtvedt <johfjeld@cisco.com>
Subject: [PATCH] vb2: check for sane values from queue_setup
Date: Tue, 11 Sep 2018 13:28:57 +0200
Message-Id: <20180911112857.22783-1-johfjeld@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warn when driver sets 0 number of planes or 0 as plane sizes.
---
 drivers/media/common/videobuf2/videobuf2-core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index f32ec7342ef0..d3bc94477e6b 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -662,6 +662,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	unsigned int num_buffers, allocated_buffers, num_planes = 0;
 	unsigned plane_sizes[VB2_MAX_PLANES] = { };
 	int ret;
+	int i;
 
 	if (q->streaming) {
 		dprintk(1, "streaming active\n");
@@ -718,6 +719,13 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	if (ret)
 		return ret;
 
+	/* Check that driver has set sane values */
+	WARN_ON(num_buffers == 0);
+
+	for (i = 0; i < num_buffers; i++) {
+		WARN_ON(plane_sizes[i] == 0);
+	}
+
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers =
 		__vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
-- 
2.17.1
