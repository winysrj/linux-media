Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:32603 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2JBOaX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 10:30:23 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MB900EV3SA0IC00@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 23:30:22 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MB9005A7S65K790@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 23:30:22 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: [PATCHv9 21/25] v4l: vb2-dma-contig: add reference counting for a
 device from allocator context
Date: Tue, 02 Oct 2012 16:27:32 +0200
Message-id: <1349188056-4886-22-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds taking reference to the device for MMAP buffers.

Such buffers, may be exported using DMABUF mechanism. If the driver that
created a queue is unloaded then the queue is released, the device might be
released too.  However, buffers cannot be released if they are referenced by
DMABUF descriptor(s). The device pointer kept in a buffer must be valid for the
whole buffer's lifetime. Therefore MMAP buffers should take a reference to the
device to avoid risk of dangling pointers.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index b138b5c..b4d287a 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -148,6 +148,7 @@ static void vb2_dc_put(void *buf_priv)
 		kfree(buf->sgt_base);
 	}
 	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
+	put_device(buf->dev);
 	kfree(buf);
 }
 
@@ -161,9 +162,13 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
+	/* prevent the device from release while the buffer is exported */
+	get_device(dev);
+
 	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, GFP_KERNEL);
 	if (!buf->vaddr) {
 		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
+		put_device(dev);
 		kfree(buf);
 		return ERR_PTR(-ENOMEM);
 	}
-- 
1.7.9.5

