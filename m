Return-path: <linux-media-owner@vger.kernel.org>
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] vb2: clear V4L2_BUF_FLAG_LAST when filling vb2_buffer
Date: Fri,  8 Dec 2017 15:01:28 +0100
Message-Id: <20171208140128.19740-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_BUF_FLAG_LAST is a signal from the driver to userspace for buffers
on the capture queue. When userspace queues back a capture buffer with
the flag set, we should clear it.

Otherwise, if userspace restarts streaming after EOS, without
reallocating the buffers, mem2mem devices will erroneously signal EOS
prematurely, as soon as the already flagged buffer is dequeued.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 4075314a69893..fac3cd6f901d5 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -434,6 +434,8 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 	} else {
 		/* Zero any output buffer flags as this is a capture buffer */
 		vbuf->flags &= ~V4L2_BUFFER_OUT_FLAGS;
+		/* Zero last flag, this is a signal from driver to userspace */
+		vbuf->flags &= ~V4L2_BUF_FLAG_LAST;
 	}
 
 	return 0;
-- 
2.11.0
