Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:50469 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030568AbaLMLxn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 06:53:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/10] videobuf2-vmalloc: fix sparse warning
Date: Sat, 13 Dec 2014 12:52:54 +0100
Message-Id: <1418471580-26510-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix this warning:

drivers/media/v4l2-core/videobuf2-vmalloc.c:98:28: warning: incorrect type in assignment (different address spaces)
drivers/media/v4l2-core/videobuf2-vmalloc.c:158:28: warning: incorrect type in argument 1 (different address spaces)

The warning is correct, but we have no other choice here to forcibly cast.
At least it is now explicit that such a cast is needed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-vmalloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index fba944e..7f6d41b 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -95,7 +95,7 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 		if (vb2_get_contig_userptr(vaddr, size, &vma, &physp))
 			goto fail_pages_array_alloc;
 		buf->vma = vma;
-		buf->vaddr = ioremap_nocache(physp, size);
+		buf->vaddr = (__force void *)ioremap_nocache(physp, size);
 		if (!buf->vaddr)
 			goto fail_pages_array_alloc;
 	} else {
@@ -155,7 +155,7 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
 		kfree(buf->pages);
 	} else {
 		vb2_put_vma(buf->vma);
-		iounmap(buf->vaddr);
+		iounmap((__force void __iomem *)buf->vaddr);
 	}
 	kfree(buf);
 }
-- 
2.1.3

