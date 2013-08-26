Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:23814 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab3HZPrX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Aug 2013 11:47:23 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MS5009TAAIXBQ20@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Aug 2013 00:47:21 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, m.chehab@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] vb2: Allow queuing OUTPUT buffers with zeroed 'bytesused'
Date: Mon, 26 Aug 2013 17:47:09 +0200
Message-id: <1377532029-12777-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modify the bytesused/data_offset check to not fail if both bytesused
and data_offset is set to 0. This should minimize possible issues in
existing applications which worked before we enforced the plane lengths
for output buffers checks introduced in commit 8023ed09cb278004a2
"videobuf2-core: Verify planes lengths for output buffers"

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 594c75e..de0e87f 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -353,7 +353,9 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 			if (b->m.planes[plane].bytesused > length)
 				return -EINVAL;
-			if (b->m.planes[plane].data_offset >=
+
+			if (b->m.planes[plane].data_offset > 0 &&
+			    b->m.planes[plane].data_offset >=
 			    b->m.planes[plane].bytesused)
 				return -EINVAL;
 		}
-- 
1.7.9.5

