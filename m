Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n03LKI4p022537
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 16:20:18 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n03LK3TJ010085
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 16:20:04 -0500
Date: Sat, 3 Jan 2009 22:20:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0901032216190.15363@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Switch remaining clear_user_page users over to
	clear_user_highpage
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Not all architectures provide clear_user_page(), but clear_user_highpage() 
is available everywhere at least via the compatibility inline function.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
Is this the "trivial patch" that's required for these two drivers?

diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index bc6d5ab..da1790e 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -388,8 +388,7 @@ videobuf_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	page = alloc_page(GFP_USER | __GFP_DMA32);
 	if (!page)
 		return VM_FAULT_OOM;
-	clear_user_page(page_address(page), (unsigned long)vmf->virtual_address,
-			page);
+	clear_user_highpage(page, (unsigned long)vmf->virtual_address);
 	vmf->page = page;
 	return 0;
 }
diff --git a/drivers/staging/go7007/go7007-v4l2.c b/drivers/staging/go7007/go7007-v4l2.c
index 94e1141..77c9265 100644
--- a/drivers/staging/go7007/go7007-v4l2.c
+++ b/drivers/staging/go7007/go7007-v4l2.c
@@ -1371,8 +1371,7 @@ static int go7007_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	page = alloc_page(GFP_USER | __GFP_DMA32);
 	if (!page)
 		return VM_FAULT_OOM;
-	clear_user_page(page_address(page), (unsigned long)vmf->virtual_address,
-			page);
+	clear_user_highpage(page, (unsigned long)vmf->virtual_address);
 	vmf->page = page;
 	return 0;
 }

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
