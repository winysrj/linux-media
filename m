Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43875 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbbCHOlW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 10:41:22 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: adi-buildroot-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 16/17] media: blackfin: bfin_capture: drop bcap_get_unmapped_area()
Date: Sun,  8 Mar 2015 14:40:52 +0000
Message-Id: <1425825653-14768-17-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch drops bcap_get_unmapped_area() and uses
vb2_fop_get_unmapped_area() helper provided by the vb2 core.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 306798e..d390f7c 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -196,23 +196,6 @@ static void bcap_free_sensor_formats(struct bcap_device *bcap_dev)
 	bcap_dev->sensor_formats = NULL;
 }
 
-#ifndef CONFIG_MMU
-static unsigned long bcap_get_unmapped_area(struct file *file,
-					    unsigned long addr,
-					    unsigned long len,
-					    unsigned long pgoff,
-					    unsigned long flags)
-{
-	struct bcap_device *bcap_dev = video_drvdata(file);
-
-	return vb2_get_unmapped_area(&bcap_dev->buffer_queue,
-				     addr,
-				     len,
-				     pgoff,
-				     flags);
-}
-#endif
-
 static int bcap_queue_setup(struct vb2_queue *vq,
 				const struct v4l2_format *fmt,
 				unsigned int *nbuffers, unsigned int *nplanes,
@@ -783,7 +766,7 @@ static struct v4l2_file_operations bcap_fops = {
 	.unlocked_ioctl = video_ioctl2,
 	.mmap = vb2_fop_mmap,
 #ifndef CONFIG_MMU
-	.get_unmapped_area = bcap_get_unmapped_area,
+	.get_unmapped_area = vb2_fop_get_unmapped_area,
 #endif
 	.poll = vb2_fop_poll
 };
-- 
2.1.0

