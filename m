Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64341 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753627AbeC1SNU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 14:13:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        stable@vger.kernel.org
Cc: Ricardo Ribalda <ricardo.ribalda@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH for v3.18 02/18] vb2: V4L2_BUF_FLAG_DONE is set after DQBUF
Date: Wed, 28 Mar 2018 15:12:21 -0300
Message-Id: <9afdc5aaed16638f406ea8ee062bdee5504e32a6.1522260310.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522260310.git.mchehab@s-opensource.com>
References: <cover.1522260310.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522260310.git.mchehab@s-opensource.com>
References: <cover.1522260310.git.mchehab@s-opensource.com>
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
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index d5c300150cf4..f0811b7e900d 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2075,6 +2075,11 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 	dprintk(1, "dqbuf of buffer %d, with state %d\n",
 			vb->v4l2_buf.index, vb->state);
 
+	/*
+	 * After calling the VIDIOC_DQBUF V4L2_BUF_FLAG_DONE must be
+	 * cleared.
+	 */
+	b->flags &= ~V4L2_BUF_FLAG_DONE;
 	return 0;
 }
 
-- 
2.14.3
