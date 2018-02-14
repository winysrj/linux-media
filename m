Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:47787 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967493AbeBNLwl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 06:52:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH for v4.4 02/14] vb2: V4L2_BUF_FLAG_DONE is set after DQBUF
Date: Wed, 14 Feb 2018 12:52:28 +0100
Message-Id: <20180214115240.27650-3-hverkuil@xs4all.nl>
In-Reply-To: <20180214115240.27650-1-hverkuil@xs4all.nl>
References: <20180214115240.27650-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ricardo Ribalda <ricardo.ribalda@gmail.com>

commit 3171cc2b4eb9831ab4df1d80d0410a945b8bc84e upstream.

According to the doc, V4L2_BUF_FLAG_DONE is cleared after DQBUF:

V4L2_BUF_FLAG_DONE 0x00000004  ... After calling the VIDIOC_QBUF or
VIDIOC_DQBUF it is always cleared ...

Unfortunately, it seems that videobuf2 keeps it set after DQBUF. This
can be tested with vivid and dev_debug:

[257604.338082] video1: VIDIOC_DQBUF: 71:33:25.00260479 index=3,
type=vid-cap, flags=0x00002004, field=none, sequence=163,
memory=userptr, bytesused=460800, offset/userptr=0x344b000,
length=460800

This patch forces FLAG_DONE to 0 after calling DQBUF.

Reported-by: Dimitrios Katsaros <patcherwork@gmail.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 6c441be8f893..bf23234d957e 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -593,6 +593,12 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
 			b->flags & V4L2_BUF_FLAG_LAST)
 		q->last_buffer_dequeued = true;
 
+	/*
+	 *  After calling the VIDIOC_DQBUF V4L2_BUF_FLAG_DONE must be
+	 *  cleared.
+	 */
+	b->flags &= ~V4L2_BUF_FLAG_DONE;
+
 	return ret;
 }
 
-- 
2.15.1
