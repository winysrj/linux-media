Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:44358 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932888AbdLSDlg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 22:41:36 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20171219034134epoutp01c36e0ff836b527973b90e2e5b919454e~BlRtVSHYG2864228642epoutp014
        for <linux-media@vger.kernel.org>; Tue, 19 Dec 2017 03:41:34 +0000 (GMT)
From: Satendra Singh Thakur <satendra.t@samsung.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org,
        satendra.t@samsung.com, madhur.verma@samsung.com,
        hemanshu.s@samsung.com, sst2005@gmail.com
Subject: [PATCH] [VB2-CORE] Fixed bug about unnecessary calls to queue
 cancel and free
Date: Tue, 19 Dec 2017 09:11:04 +0530
Message-Id: <1513654864-27272-1-git-send-email-satendra.t@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20171219034133epcas5p27ff462d877ce8bf3a54b87061f3d832b@epcas5p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-When the func vb2_core_reqbufs is called first time after
 vb2_core_queue_init, the condition q->memory != memory
 always gets satisfied since q->memory = 0 in
 vb2_core_queue_init.
-After the condition is true,
 unnecessary calls to __vb2_queue_cancel and
 __vb2_queue_free are done
-In such case, *count is non-zero, q->num_buffers is zero
 and q->memory is 0 which is not equal to  memory field
 *count=N, q->num_buffers=0, q->memory != memory

Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index a8589d9..b1140d5 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -662,7 +662,8 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		return -EBUSY;
 	}
 
-	if (*count == 0 || q->num_buffers != 0 || q->memory != memory) {
+	if (*count == 0 || q->num_buffers != 0 ||
+		(q->memory && q->memory != memory)) {
 		/*
 		 * We already have buffers allocated, so first check if they
 		 * are not in use and can be freed.
-- 
2.7.4
