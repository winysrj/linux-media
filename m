Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45610 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab2JJPBk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 11:01:40 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBO00M2TN2FXZ20@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Oct 2012 00:01:38 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBO002YDME0EC70@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Oct 2012 00:01:38 +0900 (KST)
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
Subject: [PATCHv10 21/26] v4l: vb2-dma-contig: add reference counting for a
 device from allocator context
Date: Wed, 10 Oct 2012 16:46:40 +0200
Message-id: <1349880405-26049-22-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
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
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index b138b5c..2d661fd 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -148,6 +148,7 @@ static void vb2_dc_put(void *buf_priv)
 		kfree(buf->sgt_base);
 	}
 	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
+	put_device(buf->dev);
 	kfree(buf);
 }
 
@@ -168,6 +169,9 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 		return ERR_PTR(-ENOMEM);
 	}
 
+	/* prevent the device from release while the buffer is exported */
+	get_device(dev);
+
 	buf->dev = dev;
 	buf->size = size;
 
-- 
1.7.9.5

