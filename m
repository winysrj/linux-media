Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4681 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaDQKjd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 06:39:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 06/11] saa7134: remove fmt from saa7134_buf
Date: Thu, 17 Apr 2014 12:39:09 +0200
Message-Id: <1397731154-34337-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
References: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is already available from saa7134_dev.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-core.c  |  3 +--
 drivers/media/pci/saa7134/saa7134-video.c | 24 +++++++++++-------------
 drivers/media/pci/saa7134/saa7134.h       |  1 -
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 2495a9d..f6cfbb4 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -392,8 +392,7 @@ int saa7134_set_dmabits(struct saa7134_dev *dev)
 	}
 
 	/* video capture -- dma 1+2 (planar modes) */
-	if (dev->video_q.curr &&
-	    dev->video_q.curr->fmt->planar) {
+	if (dev->video_q.curr && dev->fmt->planar) {
 		ctrl |= SAA7134_MAIN_CTRL_TE4 |
 			SAA7134_MAIN_CTRL_TE5;
 	}
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index edf9ec3..f331501 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -826,24 +826,24 @@ static int buffer_activate(struct saa7134_dev *dev,
 
 	set_size(dev, TASK_A, buf->vb.width, buf->vb.height,
 		 V4L2_FIELD_HAS_BOTH(buf->vb.field));
-	if (buf->fmt->yuv)
+	if (dev->fmt->yuv)
 		saa_andorb(SAA7134_DATA_PATH(TASK_A), 0x3f, 0x03);
 	else
 		saa_andorb(SAA7134_DATA_PATH(TASK_A), 0x3f, 0x01);
-	saa_writeb(SAA7134_OFMT_VIDEO_A, buf->fmt->pm);
+	saa_writeb(SAA7134_OFMT_VIDEO_A, dev->fmt->pm);
 
 	/* DMA: setup channel 0 (= Video Task A0) */
 	base  = saa7134_buffer_base(buf);
-	if (buf->fmt->planar)
+	if (dev->fmt->planar)
 		bpl = buf->vb.width;
 	else
-		bpl = (buf->vb.width * buf->fmt->depth) / 8;
+		bpl = (buf->vb.width * dev->fmt->depth) / 8;
 	control = SAA7134_RS_CONTROL_BURST_16 |
 		SAA7134_RS_CONTROL_ME |
 		(buf->pt->dma >> 12);
-	if (buf->fmt->bswap)
+	if (dev->fmt->bswap)
 		control |= SAA7134_RS_CONTROL_BSWAP;
-	if (buf->fmt->wswap)
+	if (dev->fmt->wswap)
 		control |= SAA7134_RS_CONTROL_WSWAP;
 	if (V4L2_FIELD_HAS_BOTH(buf->vb.field)) {
 		/* interlaced */
@@ -858,13 +858,13 @@ static int buffer_activate(struct saa7134_dev *dev,
 	}
 	saa_writel(SAA7134_RS_CONTROL(0),control);
 
-	if (buf->fmt->planar) {
+	if (dev->fmt->planar) {
 		/* DMA: setup channel 4+5 (= planar task A) */
-		bpl_uv   = bpl >> buf->fmt->hshift;
-		lines_uv = buf->vb.height >> buf->fmt->vshift;
+		bpl_uv   = bpl >> dev->fmt->hshift;
+		lines_uv = buf->vb.height >> dev->fmt->vshift;
 		base2    = base + bpl * buf->vb.height;
 		base3    = base2 + bpl_uv * lines_uv;
-		if (buf->fmt->uvswap)
+		if (dev->fmt->uvswap)
 			tmp = base2, base2 = base3, base3 = tmp;
 		dprintk("uv: bpl=%ld lines=%ld base2/3=%ld/%ld\n",
 			bpl_uv,lines_uv,base2,base3);
@@ -924,8 +924,7 @@ static int buffer_prepare(struct videobuf_queue *q,
 	if (buf->vb.width  != dev->width  ||
 	    buf->vb.height != dev->height ||
 	    buf->vb.size   != size       ||
-	    buf->vb.field  != field      ||
-	    buf->fmt       != dev->fmt) {
+	    buf->vb.field  != field) {
 		saa7134_dma_free(q,buf);
 	}
 
@@ -936,7 +935,6 @@ static int buffer_prepare(struct videobuf_queue *q,
 		buf->vb.height = dev->height;
 		buf->vb.size   = size;
 		buf->vb.field  = field;
-		buf->fmt       = dev->fmt;
 		buf->pt        = &dev->pt_cap;
 		dev->video_q.curr = NULL;
 
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 907568e..d2ee545 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -456,7 +456,6 @@ struct saa7134_buf {
 	struct videobuf_buffer vb;
 
 	/* saa7134 specific */
-	struct saa7134_format   *fmt;
 	unsigned int            top_seen;
 	int (*activate)(struct saa7134_dev *dev,
 			struct saa7134_buf *buf,
-- 
1.9.2

