Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:38075 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbbBUSkh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 13:40:37 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	adi-buildroot-devel@lists.sourceforge.net
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 06/15] media: blackfin: bfin_capture: use vb2_fop_mmap/poll
Date: Sat, 21 Feb 2015 18:39:52 +0000
Message-Id: <1424544001-19045-7-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

No need to reinvent the wheel. Just use the already existing
functions provided by vb2.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 28 +++-----------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index be0d0a2b..ee0e848 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -244,18 +244,6 @@ static int bcap_release(struct file *file)
 	return 0;
 }
 
-static int bcap_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct bcap_device *bcap_dev = video_drvdata(file);
-	int ret;
-
-	if (mutex_lock_interruptible(&bcap_dev->mutex))
-		return -ERESTARTSYS;
-	ret = vb2_mmap(&bcap_dev->buffer_queue, vma);
-	mutex_unlock(&bcap_dev->mutex);
-	return ret;
-}
-
 #ifndef CONFIG_MMU
 static unsigned long bcap_get_unmapped_area(struct file *file,
 					    unsigned long addr,
@@ -273,17 +261,6 @@ static unsigned long bcap_get_unmapped_area(struct file *file,
 }
 #endif
 
-static unsigned int bcap_poll(struct file *file, poll_table *wait)
-{
-	struct bcap_device *bcap_dev = video_drvdata(file);
-	unsigned int res;
-
-	mutex_lock(&bcap_dev->mutex);
-	res = vb2_poll(&bcap_dev->buffer_queue, file, wait);
-	mutex_unlock(&bcap_dev->mutex);
-	return res;
-}
-
 static int bcap_queue_setup(struct vb2_queue *vq,
 				const struct v4l2_format *fmt,
 				unsigned int *nbuffers, unsigned int *nplanes,
@@ -896,11 +873,11 @@ static struct v4l2_file_operations bcap_fops = {
 	.open = bcap_open,
 	.release = bcap_release,
 	.unlocked_ioctl = video_ioctl2,
-	.mmap = bcap_mmap,
+	.mmap = vb2_fop_mmap,
 #ifndef CONFIG_MMU
 	.get_unmapped_area = bcap_get_unmapped_area,
 #endif
-	.poll = bcap_poll
+	.poll = vb2_fop_poll
 };
 
 static int bcap_probe(struct platform_device *pdev)
@@ -997,6 +974,7 @@ static int bcap_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&bcap_dev->dma_queue);
 
 	vfd->lock = &bcap_dev->mutex;
+	vfd->queue = q;
 
 	/* register video device */
 	ret = video_register_device(bcap_dev->video_dev, VFL_TYPE_GRABBER, -1);
-- 
2.1.0

