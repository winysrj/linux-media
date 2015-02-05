Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:21418 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbbBEFwo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2015 00:52:44 -0500
Date: Thu, 05 Feb 2015 14:52:42 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	linux-kernel@vger.kernel.org
Cc: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com
Subject: [PATCH] [media] v4l: vb2-memops: use vma slab when vma allocation
Message-id: <20150205145242.ebb07029fa8664144d687697@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The slab for vm_area_struct which is vm_area_cachep is already prepared
for the general use. Instead of kmalloc() for the vma copy for userptr,
allocation from vm_area_cachep is more beneficial.

CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-memops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
index 81c1ad8..dd06efa 100644
--- a/drivers/media/v4l2-core/videobuf2-memops.c
+++ b/drivers/media/v4l2-core/videobuf2-memops.c
@@ -37,7 +37,7 @@ struct vm_area_struct *vb2_get_vma(struct vm_area_struct *vma)
 {
 	struct vm_area_struct *vma_copy;
 
-	vma_copy = kmalloc(sizeof(*vma_copy), GFP_KERNEL);
+	vma_copy = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (vma_copy == NULL)
 		return NULL;
 
@@ -75,7 +75,7 @@ void vb2_put_vma(struct vm_area_struct *vma)
 	if (vma->vm_file)
 		fput(vma->vm_file);
 
-	kfree(vma);
+	kmem_cache_free(vm_area_cachep, vma);
 }
 EXPORT_SYMBOL_GPL(vb2_put_vma);
 
-- 
1.7.9.5

