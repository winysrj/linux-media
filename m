Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:42594 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3HZPsn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Aug 2013 11:48:43 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MS500KG3AL55060@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Aug 2013 00:48:41 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, m.chehab@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] vb2: Add debug print for the output buffer planes lengths
 checks
Date: Mon, 26 Aug 2013 17:47:53 +0200
Message-id: <1377532073-12864-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add debug print so it's easier to find any errors resulting from
the planes' configuration checks added in commit 8023ed09cb278004a2
"videobuf2-core: Verify planes lengths for output buffers".

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index de0e87f..6bffc96 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1205,8 +1205,11 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	int ret;
 
 	ret = __verify_length(vb, b);
-	if (ret < 0)
+	if (ret < 0) {
+		dprintk(1, "%s(): plane parameters verification failed: %d\n",
+			__func__, ret);
 		return ret;
+	}
 
 	switch (q->memory) {
 	case V4L2_MEMORY_MMAP:
-- 
1.7.9.5

