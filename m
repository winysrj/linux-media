Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3997 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaDQKjf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 06:39:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 11/11] saa7134: add saa7134_userptr module option to enable USERPTR
Date: Thu, 17 Apr 2014 12:39:14 +0200
Message-Id: <1397731154-34337-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
References: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If the saa7134 module is loaded with the saa7134_userptr set to 1,
then USERPTR support is enabled. A check in buffer_prepare
verifies that the pointer is page-aligned.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-core.c  |  4 ++++
 drivers/media/pci/saa7134/saa7134-vbi.c   |  4 ++++
 drivers/media/pci/saa7134/saa7134-video.c | 16 +++++++++++++---
 drivers/media/pci/saa7134/saa7134.h       |  1 +
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index f4ea0ec..be19a05 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -69,6 +69,10 @@ module_param_named(no_overlay, saa7134_no_overlay, int, 0444);
 MODULE_PARM_DESC(no_overlay,"allow override overlay default (0 disables, 1 enables)"
 		" [some VIA/SIS chipsets are known to have problem with overlay]");
 
+bool saa7134_userptr;
+module_param(saa7134_userptr, bool, 0644);
+MODULE_PARM_DESC(saa7134_userptr, "enable page-aligned userptr support");
+
 static unsigned int video_nr[] = {[0 ... (SAA7134_MAXBOARDS - 1)] = UNSET };
 static unsigned int vbi_nr[]   = {[0 ... (SAA7134_MAXBOARDS - 1)] = UNSET };
 static unsigned int radio_nr[] = {[0 ... (SAA7134_MAXBOARDS - 1)] = UNSET };
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index 4479af5..c06dbe1 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -122,6 +122,10 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 	unsigned int size;
 	int ret;
 
+	if (dma->sgl->offset) {
+		pr_err("The buffer is not page-aligned\n");
+		return -EINVAL;
+	}
 	size = dev->vbi_hlen * dev->vbi_vlen * 2;
 	if (vb2_plane_size(vb2, 0) < size)
 		return -EINVAL;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index e50c950..828910c 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -878,6 +878,10 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 	unsigned int size;
 	int ret;
 
+	if (dma->sgl->offset) {
+		pr_err("The buffer is not page-aligned\n");
+		return -EINVAL;
+	}
 	size = (dev->width * dev->height * dev->fmt->depth) >> 3;
 	if (vb2_plane_size(vb2, 0) < size)
 		return -EINVAL;
@@ -2055,11 +2059,15 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	q = &dev->video_vbq;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	/*
-	 * Do not add VB2_USERPTR: the saa7134 DMA engine cannot handle
-	 * transfers that do not start at the beginning of a page. A USERPTR
-	 * can start anywhere in a page, so USERPTR support is a no-go.
+	 * Do not add VB2_USERPTR unless explicitly requested: the saa7134 DMA
+	 * engine cannot handle transfers that do not start at the beginning
+	 * of a page. A user-provided pointer can start anywhere in a page, so
+	 * USERPTR support is a no-go unless the application knows about these
+	 * limitations and has special support for this.
 	 */
 	q->io_modes = VB2_MMAP | VB2_READ;
+	if (saa7134_userptr)
+		q->io_modes |= VB2_USERPTR;
 	q->drv_priv = &dev->video_q;
 	q->ops = &vb2_qops;
 	q->gfp_flags = GFP_DMA32;
@@ -2076,6 +2084,8 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
 	/* Don't add VB2_USERPTR, see comment above */
 	q->io_modes = VB2_MMAP | VB2_READ;
+	if (saa7134_userptr)
+		q->io_modes |= VB2_USERPTR;
 	q->drv_priv = &dev->vbi_q;
 	q->ops = &saa7134_vbi_qops;
 	q->gfp_flags = GFP_DMA32;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index f3032a1..c258495 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -714,6 +714,7 @@ static inline bool is_empress(struct file *file)
 extern struct list_head  saa7134_devlist;
 extern struct mutex saa7134_devlist_lock;
 extern int saa7134_no_overlay;
+extern bool saa7134_userptr;
 
 void saa7134_track_gpio(struct saa7134_dev *dev, char *msg);
 void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value);
-- 
1.9.2

