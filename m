Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3321 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbaCQMyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 08:54:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH for v3.15 2/5] vb2: use IS_ERR_OR_NULL() instead of IS_ERR() in __qbuf_dmabuf
Date: Mon, 17 Mar 2014 13:54:20 +0100
Message-Id: <1395060863-42211-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1395060863-42211-1-git-send-email-hverkuil@xs4all.nl>
References: <1395060863-42211-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In __qbuf_dmabuf the result of the memop call attach_dmabuf() is checked by
IS_ERR() instead of IS_ERR_OR_NULL(). Since the a NULL pointer makes no sense
and in other places in videobuf2-core the IS_ERR_OR_NULL macro is always used,
I've changed the IS_ERR to IS_ERR_OR_NULL to remain consistent.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f9059bb..03d3130 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1403,10 +1403,10 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		/* Acquire each plane's memory */
 		mem_priv = call_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
 			dbuf, planes[plane].length, write);
-		if (IS_ERR(mem_priv)) {
+		if (IS_ERR_OR_NULL(mem_priv)) {
 			dprintk(1, "qbuf: failed to attach dmabuf\n");
 			fail_memop(vb, attach_dmabuf);
-			ret = PTR_ERR(mem_priv);
+			ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
 			dma_buf_put(dbuf);
 			goto err;
 		}
-- 
1.9.0

