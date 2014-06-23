Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49161 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbaFWJrY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 05:47:24 -0400
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id s5N9lOGH028322
	for <linux-media@vger.kernel.org>; Mon, 23 Jun 2014 04:47:24 -0500
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id s5N9lOeX011559
	for <linux-media@vger.kernel.org>; Mon, 23 Jun 2014 04:47:24 -0500
From: Nikhil Devshatwar <nikhil.nd@ti.com>
To: <linux-media@vger.kernel.org>
CC: Nikhil Devshatwar <nikhil.nd@ti.com>
Subject: [PATCH v2] media: vb2: verify data_offset only if nonzero bytesused
Date: Mon, 23 Jun 2014 15:15:50 +0530
Message-ID: <1403516750-22084-1-git-send-email-nikhil.nd@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

verify_length would fail if the user space fills up the data_offset field
and bytesused is left as zero. Correct this.

If bytesused is not populated, it means bytesused is same as length.
Checking data offset >= bytesused makes sense only if bytesused is valid.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7c4489c..369a155 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -590,7 +590,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			if (b->m.planes[plane].bytesused > length)
 				return -EINVAL;
 
-			if (b->m.planes[plane].data_offset > 0 &&
+			if (b->m.planes[plane].bytesused > 0 &&
 			    b->m.planes[plane].data_offset >=
 			    b->m.planes[plane].bytesused)
 				return -EINVAL;
-- 
1.7.9.5

