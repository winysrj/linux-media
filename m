Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34550 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaFVKse (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jun 2014 06:48:34 -0400
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id s5MAmXFw016229
	for <linux-media@vger.kernel.org>; Sun, 22 Jun 2014 05:48:33 -0500
Received: from DLEE71.ent.ti.com (dlee71.ent.ti.com [157.170.170.114])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id s5MAmXYl002198
	for <linux-media@vger.kernel.org>; Sun, 22 Jun 2014 05:48:33 -0500
From: Nikhil Devshatwar <nikhil.nd@ti.com>
To: <linux-media@vger.kernel.org>
CC: Nikhil Devshatwar <nikhil.nd@ti.com>
Subject: [[PATCH]] vb2: verify data_offset only if nonzero bytesused
Date: Sun, 22 Jun 2014 16:17:45 +0530
Message-ID: <1403434065-22994-1-git-send-email-nikhil.nd@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

verify_planes would fail if the user space fills up the data_offset field
and bytesused is left as zero. Correct this.

Checking for data_offset > bytesused is not correct as it might fail some of
the valid use cases. e.g. when working with SEQ_TB buffers, for bottom field,
data_offset can be high but it can have less bytesused.

The real check should be to verify that all the bytesused after data_offset
fit withing the length of the plane.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7c4489c..9a0ccb6 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -587,12 +587,9 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			       ? b->m.planes[plane].length
 			       : vb->v4l2_planes[plane].length;
 
-			if (b->m.planes[plane].bytesused > length)
-				return -EINVAL;
-
-			if (b->m.planes[plane].data_offset > 0 &&
-			    b->m.planes[plane].data_offset >=
-			    b->m.planes[plane].bytesused)
+			if (b->m.planes[plane].bytesused > 0 &&
+			    b->m.planes[plane].data_offset +
+			    b->m.planes[plane].bytesused > length)
 				return -EINVAL;
 		}
 	} else {
-- 
1.7.9.5

