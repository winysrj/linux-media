Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35749 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758914AbcAUI33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2016 03:29:29 -0500
From: Michal Hocko <mhocko@kernel.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH] [media] zoran: do not use kmalloc for memory mapped to userspace
Date: Thu, 21 Jan 2016 09:29:18 +0100
Message-Id: <1453364958-29983-1-git-send-email-mhocko@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michal Hocko <mhocko@suse.com>

mmapping kmalloced memory is dangerous for two reasons. First the memory
is not guaranteed to be page aligned and secondly and more imporatantly
the allocates size _has_ to be in page units otherwise we grant an
access to an unrelated memory. This is has security implications of
course.

zoran_mmap calls remap_pfn_range on fbuffer_phys which is allocated by
kmalloc which alone is worrying. Yet the buffer size (buffer_size) is
calculated by mmap_mode_raw, map_mode_jpg resp. zoran_v4l2_calc_bufsize
which caps the resulting size to jpg_bufsize which is 512B so we expose
a full slab page with an unrelated content via mmap.

Fix the issue by using __get_free_pages/free_pages instead of
kmalloc/kfree and also use __GFP_ZERO to make sure the buffer is zeroed
out before it is exported to prevent from information leak.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
Hi,
I am sending this offlist for the review because this has security
implications and I am not sure how you handle such issues. I do not own
the HW so I haven't tested this so please be careful and give it a deep
review. The issue has been pointed out by Sebastian Frias (CCed) who
was asking for a similar pattern used in an out of tree driver [1].

I do not have any active exploit for the issue nor I am sure whether
this can be exploited in the real life. Small sized slab caches (<=512)
are used quite heavily so there is a theoretical chance of having
something interesting in the same page though.

[1] http://lkml.kernel.org/r/5667128B.3080704@sigmadesigns.com

 drivers/media/pci/zoran/zoran_driver.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 80caa70c6360..e71af08c4972 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -227,8 +227,8 @@ static int v4l_fbuffer_alloc(struct zoran_fh *fh)
 				ZR_DEVNAME(zr), __func__, i);
 
 		//udelay(20);
-		mem = kmalloc(fh->buffers.buffer_size,
-			      GFP_KERNEL | __GFP_NOWARN);
+		mem = (unsigned char *)__get_free_pages(GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN,
+				get_order(fh->buffers.buffer_size));
 		if (!mem) {
 			dprintk(1,
 				KERN_ERR
@@ -272,7 +272,8 @@ static void v4l_fbuffer_free(struct zoran_fh *fh)
 		for (off = 0; off < fh->buffers.buffer_size;
 		     off += PAGE_SIZE)
 			ClearPageReserved(virt_to_page(mem + off));
-		kfree(fh->buffers.buffer[i].v4l.fbuffer);
+		free_pages((unsigned long)fh->buffers.buffer[i].v4l.fbuffer,
+				get_order(fh->buffers.buffer_size));
 		fh->buffers.buffer[i].v4l.fbuffer = NULL;
 	}
 
@@ -335,7 +336,8 @@ static int jpg_fbuffer_alloc(struct zoran_fh *fh)
 		fh->buffers.buffer[i].jpg.frag_tab_bus = virt_to_bus(mem);
 
 		if (fh->buffers.need_contiguous) {
-			mem = kmalloc(fh->buffers.buffer_size, GFP_KERNEL);
+			mem = (void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
+					get_order(fh->buffers.buffer_size));
 			if (mem == NULL) {
 				dprintk(1,
 					KERN_ERR
@@ -407,7 +409,8 @@ static void jpg_fbuffer_free(struct zoran_fh *fh)
 				mem = bus_to_virt(le32_to_cpu(frag_tab));
 				for (off = 0; off < fh->buffers.buffer_size; off += PAGE_SIZE)
 					ClearPageReserved(virt_to_page(mem + off));
-				kfree(mem);
+				free_pages((unsigned long)mem,
+						get_order(fh->buffers.buffer_size));
 				buffer->jpg.frag_tab[0] = 0;
 				buffer->jpg.frag_tab[1] = 0;
 			}
-- 
2.6.2

