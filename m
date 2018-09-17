Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:33008 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbeIQOBq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 10:01:46 -0400
From: Johan Fjeldtvedt <johfjeld@cisco.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <johfjeld@cisco.com>
Subject: [PATCH v5] vb2: check for sane values from queue_setup
Date: Mon, 17 Sep 2018 10:36:47 +0200
Message-Id: <20180917083647.6236-1-johfjeld@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warn and return error from the reqbufs ioctl when driver sets 0 number
of planes or 0 as plane sizes, as these values don't make any sense.
Checking this here stops obviously wrong values from propagating
further and causing various problems that are hard to trace back to
either of these values being 0.

Signed-off-by: Johan Fjeldtvedt <johfjeld@cisco.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index f32ec7342ef0..14cedf42e907 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -661,6 +661,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 {
 	unsigned int num_buffers, allocated_buffers, num_planes = 0;
 	unsigned plane_sizes[VB2_MAX_PLANES] = { };
+	unsigned int i;
 	int ret;
 
 	if (q->streaming) {
@@ -718,6 +719,14 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	if (ret)
 		return ret;
 
+	/* Check that driver has set sane values */
+	if (WARN_ON(!num_planes))
+		return -EINVAL;
+
+	for (i = 0; i < num_planes; i++)
+		if (WARN_ON(!plane_sizes[i]))
+			return -EINVAL;
+
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers =
 		__vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
-- 
2.17.1
