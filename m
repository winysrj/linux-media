Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2329 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbaITMmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 16/16] cx88: fix VBI support
Date: Sat, 20 Sep 2014 14:41:51 +0200
Message-Id: <1411216911-7950-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now works with both NTSC and PAL. Tested with CC/XDS for NTSC and
teletext/WSS for PAL. The start lines were wrong, the WSS signal
wasn't captured and there was no difference between NTSC and PAL
w.r.t. the count[] values so NTSC returned way too many lines.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-vbi.c | 28 ++++++++++++++++++++--------
 drivers/media/pci/cx88/cx88.h     |  3 ++-
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 042f545..6ab6e27 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -23,20 +23,22 @@ int cx8800_vbi_fmt (struct file *file, void *priv,
 	f->fmt.vbi.samples_per_line = VBI_LINE_LENGTH;
 	f->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
 	f->fmt.vbi.offset = 244;
-	f->fmt.vbi.count[0] = VBI_LINE_COUNT;
-	f->fmt.vbi.count[1] = VBI_LINE_COUNT;
 
 	if (dev->core->tvnorm & V4L2_STD_525_60) {
 		/* ntsc */
 		f->fmt.vbi.sampling_rate = 28636363;
 		f->fmt.vbi.start[0] = 10;
 		f->fmt.vbi.start[1] = 273;
+		f->fmt.vbi.count[0] = VBI_LINE_NTSC_COUNT;
+		f->fmt.vbi.count[1] = VBI_LINE_NTSC_COUNT;
 
 	} else if (dev->core->tvnorm & V4L2_STD_625_50) {
 		/* pal */
 		f->fmt.vbi.sampling_rate = 35468950;
-		f->fmt.vbi.start[0] = 7 -1;
-		f->fmt.vbi.start[1] = 319 -1;
+		f->fmt.vbi.start[0] = V4L2_VBI_ITU_625_F1_START + 5;
+		f->fmt.vbi.start[1] = V4L2_VBI_ITU_625_F2_START + 5;
+		f->fmt.vbi.count[0] = VBI_LINE_PAL_COUNT;
+		f->fmt.vbi.count[1] = VBI_LINE_PAL_COUNT;
 	}
 	return 0;
 }
@@ -111,8 +113,13 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct cx8800_dev *dev = q->drv_priv;
+
 	*num_planes = 1;
-	sizes[0] = VBI_LINE_COUNT * VBI_LINE_LENGTH * 2;
+	if (dev->core->tvnorm & V4L2_STD_525_60)
+		sizes[0] = VBI_LINE_NTSC_COUNT * VBI_LINE_LENGTH * 2;
+	else
+		sizes[0] = VBI_LINE_PAL_COUNT * VBI_LINE_LENGTH * 2;
 	return 0;
 }
 
@@ -122,10 +129,15 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
+	unsigned int lines;
 	unsigned int size;
 	int rc;
 
-	size = VBI_LINE_COUNT * VBI_LINE_LENGTH * 2;
+	if (dev->core->tvnorm & V4L2_STD_525_60)
+		lines = VBI_LINE_NTSC_COUNT;
+	else
+		lines = VBI_LINE_PAL_COUNT;
+	size = lines * VBI_LINE_LENGTH * 2;
 	if (vb2_plane_size(vb, 0) < size)
 		return -EINVAL;
 	vb2_set_plane_payload(vb, 0, size);
@@ -135,9 +147,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EIO;
 
 	cx88_risc_buffer(dev->pci, &buf->risc, sgt->sgl,
-			 0, VBI_LINE_LENGTH * VBI_LINE_COUNT,
+			 0, VBI_LINE_LENGTH * lines,
 			 VBI_LINE_LENGTH, 0,
-			 VBI_LINE_COUNT);
+			 lines);
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 2fa4aa9..3b0ae75 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -61,7 +61,8 @@
 #define FORMAT_FLAGS_PACKED       0x01
 #define FORMAT_FLAGS_PLANAR       0x02
 
-#define VBI_LINE_COUNT              17
+#define VBI_LINE_PAL_COUNT              18
+#define VBI_LINE_NTSC_COUNT             12
 #define VBI_LINE_LENGTH           2048
 
 #define AUD_RDS_LINES		     4
-- 
2.1.0

