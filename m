Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42806 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1IZGmH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 02:42:07 -0400
From: Archit Taneja <archit@ti.com>
To: <hvaibhav@ti.com>
CC: <tomi.valkeinen@ti.com>, <linux-omap@vger.kernel.org>,
	<sumit.semwal@ti.com>, <linux-media@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v2 1/5] OMAP_VOUT: Fix check in reqbuf for buf_size allocation
Date: Mon, 26 Sep 2011 12:12:06 +0530
Message-ID: <1317019330-4090-2-git-send-email-archit@ti.com>
In-Reply-To: <1317019330-4090-1-git-send-email-archit@ti.com>
References: <1317019330-4090-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The commit 383e4f69879d11c86ebdd38b3356f6d0690fb4cc makes reqbuf prevent
requesting a larger size buffer than what is allocated at kernel boot during
omap_vout_probe.

The requested size is compared with vout->buffer_size, this isn't correct as
vout->buffer_size is later set to the size requested in reqbuf. When the video
device is opened the next time, this check will prevent us to allocate a buffer
which is larger than what we requested the last time.

Don't use vout->buffer_size, always check with the parameters video1_bufsize
or video2_bufsize.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/video/omap/omap_vout.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index d9e64f3..16ebff6 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -664,10 +664,14 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 	u32 phy_addr = 0, virt_addr = 0;
 	struct omap_vout_device *vout = q->priv_data;
 	struct omapvideo_info *ovid = &vout->vid_info;
+	int vid_max_buf_size;
 
 	if (!vout)
 		return -EINVAL;
 
+	vid_max_buf_size = vout->vid == OMAP_VIDEO1 ? video1_bufsize :
+		video2_bufsize;
+
 	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != q->type)
 		return -EINVAL;
 
@@ -690,7 +694,7 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 		video1_numbuffers : video2_numbuffers;
 
 	/* Check the size of the buffer */
-	if (*size > vout->buffer_size) {
+	if (*size > vid_max_buf_size) {
 		v4l2_err(&vout->vid_dev->v4l2_dev,
 				"buffer allocation mismatch [%u] [%u]\n",
 				*size, vout->buffer_size);
@@ -865,6 +869,8 @@ static int omap_vout_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long size = (vma->vm_end - vma->vm_start);
 	struct omap_vout_device *vout = file->private_data;
 	struct videobuf_queue *q = &vout->vbq;
+	int vid_max_buf_size = vout->vid == OMAP_VIDEO1 ? video1_bufsize :
+		video2_bufsize;
 
 	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev,
 			" %s pgoff=0x%lx, start=0x%lx, end=0x%lx\n", __func__,
@@ -887,7 +893,7 @@ static int omap_vout_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 	/* Check the size of the buffer */
-	if (size > vout->buffer_size) {
+	if (size > vid_max_buf_size) {
 		v4l2_err(&vout->vid_dev->v4l2_dev,
 				"insufficient memory [%lu] [%u]\n",
 				size, vout->buffer_size);
-- 
1.7.1

