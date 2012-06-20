Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:63355 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab2FTGMS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 02:12:18 -0400
Received: by vcbfl13 with SMTP id fl13so643854vcb.1
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2012 23:12:17 -0700 (PDT)
Date: Tue, 19 Jun 2012 23:12:16 -0700
From: Dima Zavin <dmitriyz@google.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCHv7 03/15] v4l: vb2: add support for shared buffer
 (dma_buf)
Message-ID: <20120620061216.GA19245@google.com>
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com>
 <1339681069-8483-4-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339681069-8483-4-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tomasz,

I've encountered an issue with this patch when userspace does several
stream_on/stream_off cycles. When the user tries to qbuf a buffer
after doing stream_off, we trigger the "dmabuf already pinned" warning
since we didn't unmap the buffer as dqbuf was never called.

The below patch adds calls to unmap in queue_cancel, but my feeling is that we
probably should be calling detach too (i.e. put_dmabuf).

Thoughts?

--Dima

Subject: [PATCH] v4l: vb2: unmap dmabufs on STREAM_OFF event

Currently, if the user issues a STREAM_OFF request and then
tries to re-enqueue buffers, it will trigger a warning in
the vb2 allocators as the buffer would still be mapped
from before STREAM_OFF was called. The current expectation
is that buffers will be unmapped in dqbuf, but that will never
be called on the mapped buffers after a STREAM_OFF event.

Cc: Sumit Semwal <sumit.semwal@ti.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Dima Zavin <dima@android.com>
---
 drivers/media/video/videobuf2-core.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index b431dc6..e2a8f12 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1592,8 +1592,26 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	/*
 	 * Reinitialize all buffers for next use.
 	 */
-	for (i = 0; i < q->num_buffers; ++i)
-		q->bufs[i]->state = VB2_BUF_STATE_DEQUEUED;
+	for (i = 0; i < q->num_buffers; ++i) {
+		struct vb2_buffer *vb = q->bufs[i];
+		int plane;
+
+		vb->state = VB2_BUF_STATE_DEQUEUED;
+
+		if (q->memory != V4L2_MEMORY_DMABUF)
+			continue;
+
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			struct vb2_plane *p = &vb->planes[plane];
+
+			if (!p->mem_priv)
+				continue;
+			if (p->dbuf_mapped) {
+				call_memop(q, unmap_dmabuf, p->mem_priv);
+				p->dbuf_mapped = 0;
+			}
+		}
+	}
 }
 
 /**
-- 
1.7.7.3

