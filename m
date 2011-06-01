Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41899 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454Ab1FAUTe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 16:19:34 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed,  1 Jun 2011 22:19:22 +0200
Message-Id: <1306959563-7108-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [PATCH] [media] V4L/videobuf2-memops: use pr_debug for debug messages
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Otherwise they clutter the dmesg buffer even on a production kernel.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/media/video/videobuf2-memops.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/videobuf2-memops.c b/drivers/media/video/videobuf2-memops.c
index 5370a3a..1987e1b1 100644
--- a/drivers/media/video/videobuf2-memops.c
+++ b/drivers/media/video/videobuf2-memops.c
@@ -177,7 +177,7 @@ int vb2_mmap_pfn_range(struct vm_area_struct *vma, unsigned long paddr,
 
 	vma->vm_ops->open(vma);
 
-	printk(KERN_DEBUG "%s: mapped paddr 0x%08lx at 0x%08lx, size %ld\n",
+	pr_debug("%s: mapped paddr 0x%08lx at 0x%08lx, size %ld\n",
 			__func__, paddr, vma->vm_start, size);
 
 	return 0;
@@ -195,7 +195,7 @@ static void vb2_common_vm_open(struct vm_area_struct *vma)
 {
 	struct vb2_vmarea_handler *h = vma->vm_private_data;
 
-	printk(KERN_DEBUG "%s: %p, refcount: %d, vma: %08lx-%08lx\n",
+	pr_debug("%s: %p, refcount: %d, vma: %08lx-%08lx\n",
 	       __func__, h, atomic_read(h->refcount), vma->vm_start,
 	       vma->vm_end);
 
@@ -213,7 +213,7 @@ static void vb2_common_vm_close(struct vm_area_struct *vma)
 {
 	struct vb2_vmarea_handler *h = vma->vm_private_data;
 
-	printk(KERN_DEBUG "%s: %p, refcount: %d, vma: %08lx-%08lx\n",
+	pr_debug("%s: %p, refcount: %d, vma: %08lx-%08lx\n",
 	       __func__, h, atomic_read(h->refcount), vma->vm_start,
 	       vma->vm_end);
 
-- 
1.7.5.3

