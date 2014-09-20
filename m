Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2579 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbaITMmF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/16] cx88: remove fmt from the buffer struct
Date: Sat, 20 Sep 2014 14:41:36 +0200
Message-Id: <1411216911-7950-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is a duplicate of dev->fmt and can be removed. As a consequence a
lot of tests that check if the format has changed midstream can be
removed as well: the format cannot change midstream, so this is a bogus
check.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-mpeg.c  |   6 +-
 drivers/media/pci/cx88/cx88-video.c | 116 ++++++++++++++----------------------
 drivers/media/pci/cx88/cx88.h       |   1 -
 3 files changed, 46 insertions(+), 77 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 74b7b86..2803b6f 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -229,17 +229,13 @@ static int cx8802_restart_queue(struct cx8802_dev    *dev,
 				dprintk(1,"[%p/%d] restart_queue - first active\n",
 					buf,buf->vb.i);
 
-			} else if (prev->vb.width  == buf->vb.width  &&
-				   prev->vb.height == buf->vb.height &&
-				   prev->fmt       == buf->fmt) {
+			} else {
 				list_move_tail(&buf->vb.queue, &q->active);
 				buf->vb.state = VIDEOBUF_ACTIVE;
 				buf->count    = q->count++;
 				prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 				dprintk(1,"[%p/%d] restart_queue - move to active\n",
 					buf,buf->vb.i);
-			} else {
-				return 0;
 			}
 			prev = buf;
 		}
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index ed8cb90..3075179 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -420,7 +420,7 @@ static int start_video_dma(struct cx8800_dev    *dev,
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH21],
 				buf->bpl, buf->risc.dma);
 	cx88_set_scale(core, buf->vb.width, buf->vb.height, buf->vb.field);
-	cx_write(MO_COLOR_CTRL, buf->fmt->cxformat | ColorFormatGamma);
+	cx_write(MO_COLOR_CTRL, dev->fmt->cxformat | ColorFormatGamma);
 
 	/* reset counter */
 	cx_write(MO_VIDY_GPCNTRL,GP_COUNT_CONTROL_RESET);
@@ -497,17 +497,13 @@ static int restart_video_queue(struct cx8800_dev    *dev,
 			dprintk(2,"[%p/%d] restart_queue - first active\n",
 				buf,buf->vb.i);
 
-		} else if (prev->vb.width  == buf->vb.width  &&
-			   prev->vb.height == buf->vb.height &&
-			   prev->fmt       == buf->fmt) {
+		} else {
 			list_move_tail(&buf->vb.queue, &q->active);
 			buf->vb.state = VIDEOBUF_ACTIVE;
 			buf->count    = q->count++;
 			prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 			dprintk(2,"[%p/%d] restart_queue - move to active\n",
 				buf,buf->vb.i);
-		} else {
-			return 0;
 		}
 		prev = buf;
 	}
@@ -538,7 +534,7 @@ buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	struct cx88_core *core = dev->core;
 	struct cx88_buffer *buf = container_of(vb,struct cx88_buffer,vb);
 	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
-	int rc, init_buffer = 0;
+	int rc;
 
 	BUG_ON(NULL == dev->fmt);
 	if (dev->width  < 48 || dev->width  > norm_maxw(core->tvnorm) ||
@@ -548,59 +544,47 @@ buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	if (0 != buf->vb.baddr  &&  buf->vb.bsize < buf->vb.size)
 		return -EINVAL;
 
-	if (buf->fmt       != dev->fmt    ||
-	    buf->vb.width  != dev->width  ||
-	    buf->vb.height != dev->height ||
-	    buf->vb.field  != field) {
-		buf->fmt       = dev->fmt;
-		buf->vb.width  = dev->width;
-		buf->vb.height = dev->height;
-		buf->vb.field  = field;
-		init_buffer = 1;
-	}
-
+	buf->vb.width  = dev->width;
+	buf->vb.height = dev->height;
+	buf->vb.field  = field;
 	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		init_buffer = 1;
 		if (0 != (rc = videobuf_iolock(q,&buf->vb,NULL)))
 			goto fail;
 	}
 
-	if (init_buffer) {
-		buf->bpl = buf->vb.width * buf->fmt->depth >> 3;
-		switch (buf->vb.field) {
-		case V4L2_FIELD_TOP:
-			cx88_risc_buffer(dev->pci, &buf->risc,
-					 dma->sglist, 0, UNSET,
-					 buf->bpl, 0, buf->vb.height);
-			break;
-		case V4L2_FIELD_BOTTOM:
-			cx88_risc_buffer(dev->pci, &buf->risc,
-					 dma->sglist, UNSET, 0,
-					 buf->bpl, 0, buf->vb.height);
-			break;
-		case V4L2_FIELD_INTERLACED:
-			cx88_risc_buffer(dev->pci, &buf->risc,
-					 dma->sglist, 0, buf->bpl,
-					 buf->bpl, buf->bpl,
-					 buf->vb.height >> 1);
-			break;
-		case V4L2_FIELD_SEQ_TB:
-			cx88_risc_buffer(dev->pci, &buf->risc,
-					 dma->sglist,
-					 0, buf->bpl * (buf->vb.height >> 1),
-					 buf->bpl, 0,
-					 buf->vb.height >> 1);
-			break;
-		case V4L2_FIELD_SEQ_BT:
-			cx88_risc_buffer(dev->pci, &buf->risc,
-					 dma->sglist,
-					 buf->bpl * (buf->vb.height >> 1), 0,
-					 buf->bpl, 0,
-					 buf->vb.height >> 1);
-			break;
-		default:
-			BUG();
-		}
+	buf->bpl = buf->vb.width * dev->fmt->depth >> 3;
+	switch (buf->vb.field) {
+	case V4L2_FIELD_TOP:
+		cx88_risc_buffer(dev->pci, &buf->risc,
+				 dma->sglist, 0, UNSET,
+				 buf->bpl, 0, buf->vb.height);
+		break;
+	case V4L2_FIELD_BOTTOM:
+		cx88_risc_buffer(dev->pci, &buf->risc,
+				 dma->sglist, UNSET, 0,
+				 buf->bpl, 0, buf->vb.height);
+		break;
+	case V4L2_FIELD_SEQ_TB:
+		cx88_risc_buffer(dev->pci, &buf->risc,
+				 dma->sglist,
+				 0, buf->bpl * (buf->vb.height >> 1),
+				 buf->bpl, 0,
+				 buf->vb.height >> 1);
+		break;
+	case V4L2_FIELD_SEQ_BT:
+		cx88_risc_buffer(dev->pci, &buf->risc,
+				 dma->sglist,
+				 buf->bpl * (buf->vb.height >> 1), 0,
+				 buf->bpl, 0,
+				 buf->vb.height >> 1);
+		break;
+	case V4L2_FIELD_INTERLACED:
+	default:
+		cx88_risc_buffer(dev->pci, &buf->risc,
+				 dma->sglist, 0, buf->bpl,
+				 buf->bpl, buf->bpl,
+				 buf->vb.height >> 1);
+		break;
 	}
 	dprintk(2,"[%p/%d] buffer_prepare - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
 		buf, buf->vb.i,
@@ -646,22 +630,12 @@ buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 
 	} else {
 		prev = list_entry(q->active.prev, struct cx88_buffer, vb.queue);
-		if (prev->vb.width  == buf->vb.width  &&
-		    prev->vb.height == buf->vb.height &&
-		    prev->fmt       == buf->fmt) {
-			list_add_tail(&buf->vb.queue,&q->active);
-			buf->vb.state = VIDEOBUF_ACTIVE;
-			buf->count    = q->count++;
-			prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-			dprintk(2,"[%p/%d] buffer_queue - append to active\n",
-				buf, buf->vb.i);
-
-		} else {
-			list_add_tail(&buf->vb.queue,&q->queued);
-			buf->vb.state = VIDEOBUF_QUEUED;
-			dprintk(2,"[%p/%d] buffer_queue - first queued\n",
-				buf, buf->vb.i);
-		}
+		list_add_tail(&buf->vb.queue, &q->active);
+		buf->vb.state = VIDEOBUF_ACTIVE;
+		buf->count    = q->count++;
+		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
+		dprintk(2, "[%p/%d] buffer_queue - append to active\n",
+			buf, buf->vb.i);
 	}
 }
 
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 28893a6..ddc7991 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -319,7 +319,6 @@ struct cx88_buffer {
 	/* cx88 specific */
 	unsigned int           bpl;
 	struct btcx_riscmem    risc;
-	const struct cx8800_fmt *fmt;
 	u32                    count;
 };
 
-- 
2.1.0

