Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3012 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbaDQKjf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 06:39:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 09/11] saa7134: move saa7134_pgtable to saa7134_dmaqueue
Date: Thu, 17 Apr 2014 12:39:12 +0200
Message-Id: <1397731154-34337-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
References: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

All dmaqueue's use saa7134_pgtable, so move it into struct saa7134_dmaqueue.
The videobuf_queue priv_data field now points to the dmaqueue struct.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-dvb.c     |  2 +-
 drivers/media/pci/saa7134/saa7134-empress.c |  2 +-
 drivers/media/pci/saa7134/saa7134-ts.c      | 21 ++++++++++++---------
 drivers/media/pci/saa7134/saa7134-vbi.c     | 14 ++++++++------
 drivers/media/pci/saa7134/saa7134-video.c   | 26 ++++++++++++++------------
 drivers/media/pci/saa7134/saa7134.h         |  7 +------
 6 files changed, 37 insertions(+), 35 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index 8b55e6d..eb48b1f 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -1237,7 +1237,7 @@ static int dvb_init(struct saa7134_dev *dev)
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_ALTERNATE,
 			    sizeof(struct saa7134_buf),
-			    dev, NULL);
+			    &dev->ts_q, NULL);
 
 	switch (dev->board) {
 	case SAA7134_BOARD_PINNACLE_300I_DVBT_PAL:
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 7d4d390..c44a7fb 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -359,7 +359,7 @@ static int empress_init(struct saa7134_dev *dev)
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_ALTERNATE,
 			    sizeof(struct saa7134_buf),
-			    dev, NULL);
+			    &dev->ts_q, NULL);
 
 	empress_signal_update(&dev->empress_workqueue);
 	return 0;
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 240d280..8ac4fda 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -75,7 +75,8 @@ static int buffer_activate(struct saa7134_dev *dev,
 static int buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 		enum v4l2_field field)
 {
-	struct saa7134_dev *dev = q->priv_data;
+	struct saa7134_dmaqueue *dmaq = q->priv_data;
+	struct saa7134_dev *dev = dmaq->dev;
 	struct saa7134_buf *buf = container_of(vb, struct saa7134_buf, vb);
 	unsigned int lines, llength, size;
 	int err;
@@ -102,12 +103,11 @@ static int buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 		buf->vb.width  = llength;
 		buf->vb.height = lines;
 		buf->vb.size   = size;
-		buf->pt        = &dev->ts.pt_ts;
 
 		err = videobuf_iolock(q,&buf->vb,NULL);
 		if (err)
 			goto oops;
-		err = saa7134_pgtable_build(dev->pci,buf->pt,
+		err = saa7134_pgtable_build(dev->pci, &dmaq->pt,
 					    dma->sglist,
 					    dma->sglen,
 					    saa7134_buffer_startpage(buf));
@@ -128,7 +128,8 @@ static int buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 static int
 buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 {
-	struct saa7134_dev *dev = q->priv_data;
+	struct saa7134_dmaqueue *dmaq = q->priv_data;
+	struct saa7134_dev *dev = dmaq->dev;
 
 	*size = TS_PACKET_SIZE * dev->ts.nr_packets;
 	if (0 == *count)
@@ -140,7 +141,8 @@ buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 
 static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
 {
-	struct saa7134_dev *dev = q->priv_data;
+	struct saa7134_dmaqueue *dmaq = q->priv_data;
+	struct saa7134_dev *dev = dmaq->dev;
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
 
 	saa7134_buffer_queue(dev,&dev->ts_q,buf);
@@ -149,7 +151,8 @@ static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
 static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
 {
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
-	struct saa7134_dev *dev = q->priv_data;
+	struct saa7134_dmaqueue *dmaq = q->priv_data;
+	struct saa7134_dev *dev = dmaq->dev;
 
 	if (dev->ts_started)
 		saa7134_ts_stop(dev);
@@ -213,7 +216,7 @@ int saa7134_ts_init1(struct saa7134_dev *dev)
 	dev->ts_q.dev              = dev;
 	dev->ts_q.need_two         = 1;
 	dev->ts_started            = 0;
-	saa7134_pgtable_alloc(dev->pci, &dev->ts.pt_ts);
+	saa7134_pgtable_alloc(dev->pci, &dev->ts_q.pt);
 
 	/* init TS hw */
 	saa7134_ts_init_hw(dev);
@@ -259,7 +262,7 @@ int saa7134_ts_start(struct saa7134_dev *dev)
 	saa_writel(SAA7134_RS_PITCH(5), TS_PACKET_SIZE);
 	saa_writel(SAA7134_RS_CONTROL(5), SAA7134_RS_CONTROL_BURST_16 |
 					  SAA7134_RS_CONTROL_ME |
-					  (dev->ts.pt_ts.dma >> 12));
+					  (dev->ts_q.pt.dma >> 12));
 
 	/* reset hardware TS buffers */
 	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
@@ -293,7 +296,7 @@ int saa7134_ts_start(struct saa7134_dev *dev)
 
 int saa7134_ts_fini(struct saa7134_dev *dev)
 {
-	saa7134_pgtable_free(dev->pci, &dev->ts.pt_ts);
+	saa7134_pgtable_free(dev->pci, &dev->ts_q.pt);
 	return 0;
 }
 
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index 7f28563..4954a54 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -96,7 +96,7 @@ static int buffer_activate(struct saa7134_dev *dev,
 	base    = saa7134_buffer_base(buf);
 	control = SAA7134_RS_CONTROL_BURST_16 |
 		SAA7134_RS_CONTROL_ME |
-		(buf->pt->dma >> 12);
+		(dev->vbi_q.pt.dma >> 12);
 	saa_writel(SAA7134_RS_BA1(2), base);
 	saa_writel(SAA7134_RS_BA2(2), base + dev->vbi_hlen * dev->vbi_vlen);
 	saa_writel(SAA7134_RS_PITCH(2), dev->vbi_hlen);
@@ -117,7 +117,8 @@ static int buffer_prepare(struct videobuf_queue *q,
 			  struct videobuf_buffer *vb,
 			  enum v4l2_field field)
 {
-	struct saa7134_dev *dev = q->priv_data;
+	struct saa7134_dmaqueue *dmaq = q->priv_data;
+	struct saa7134_dev *dev = dmaq->dev;
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
 	unsigned int size;
 	int err;
@@ -135,12 +136,11 @@ static int buffer_prepare(struct videobuf_queue *q,
 		buf->vb.width  = dev->vbi_hlen;
 		buf->vb.height = dev->vbi_vlen;
 		buf->vb.size   = size;
-		buf->pt        = &dev->pt_vbi;
 
 		err = videobuf_iolock(q,&buf->vb,NULL);
 		if (err)
 			goto oops;
-		err = saa7134_pgtable_build(dev->pci,buf->pt,
+		err = saa7134_pgtable_build(dev->pci, &dmaq->pt,
 					    dma->sglist,
 					    dma->sglen,
 					    saa7134_buffer_startpage(buf));
@@ -160,7 +160,8 @@ static int buffer_prepare(struct videobuf_queue *q,
 static int
 buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 {
-	struct saa7134_dev *dev = q->priv_data;
+	struct saa7134_dmaqueue *dmaq = q->priv_data;
+	struct saa7134_dev *dev = dmaq->dev;
 
 	dev->vbi_vlen = dev->tvnorm->vbi_v_stop_0 - dev->tvnorm->vbi_v_start_0 + 1;
 	if (dev->vbi_vlen > VBI_LINE_COUNT)
@@ -175,7 +176,8 @@ buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 
 static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
 {
-	struct saa7134_dev *dev = q->priv_data;
+	struct saa7134_dmaqueue *dmaq = q->priv_data;
+	struct saa7134_dev *dev = dmaq->dev;
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
 
 	saa7134_buffer_queue(dev,&dev->vbi_q,buf);
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 9eb5564..0e48b98 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -840,7 +840,7 @@ static int buffer_activate(struct saa7134_dev *dev,
 		bpl = (buf->vb.width * dev->fmt->depth) / 8;
 	control = SAA7134_RS_CONTROL_BURST_16 |
 		SAA7134_RS_CONTROL_ME |
-		(buf->pt->dma >> 12);
+		(dev->video_q.pt.dma >> 12);
 	if (dev->fmt->bswap)
 		control |= SAA7134_RS_CONTROL_BSWAP;
 	if (dev->fmt->wswap)
@@ -899,7 +899,8 @@ static int buffer_prepare(struct videobuf_queue *q,
 			  struct videobuf_buffer *vb,
 			  enum v4l2_field field)
 {
-	struct saa7134_dev *dev = q->priv_data;
+	struct saa7134_dmaqueue *dmaq = q->priv_data;
+	struct saa7134_dev *dev = dmaq->dev;
 	struct saa7134_buf *buf = container_of(vb, struct saa7134_buf, vb);
 	unsigned int size;
 	int err;
@@ -935,13 +936,12 @@ static int buffer_prepare(struct videobuf_queue *q,
 		buf->vb.height = dev->height;
 		buf->vb.size   = size;
 		buf->vb.field  = field;
-		buf->pt        = &dev->pt_cap;
 		dev->video_q.curr = NULL;
 
 		err = videobuf_iolock(q,&buf->vb,&dev->ovbuf);
 		if (err)
 			goto oops;
-		err = saa7134_pgtable_build(dev->pci,buf->pt,
+		err = saa7134_pgtable_build(dev->pci, &dmaq->pt,
 					    dma->sglist,
 					    dma->sglen,
 					    saa7134_buffer_startpage(buf));
@@ -960,7 +960,8 @@ static int buffer_prepare(struct videobuf_queue *q,
 static int
 buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 {
-	struct saa7134_dev *dev = q->priv_data;
+	struct saa7134_dmaqueue *dmaq = q->priv_data;
+	struct saa7134_dev *dev = dmaq->dev;
 
 	*size = dev->fmt->depth * dev->width * dev->height >> 3;
 	if (0 == *count)
@@ -971,7 +972,8 @@ buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 
 static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
 {
-	struct saa7134_dev *dev = q->priv_data;
+	struct saa7134_dmaqueue *dmaq = q->priv_data;
+	struct saa7134_dev *dev = dmaq->dev;
 	struct saa7134_buf *buf = container_of(vb, struct saa7134_buf, vb);
 
 	saa7134_buffer_queue(dev, &dev->video_q, buf);
@@ -2252,15 +2254,15 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct saa7134_buf),
-			    dev, NULL);
+			    &dev->video_q, NULL);
 	videobuf_queue_sg_init(&dev->vbi_vbq, &saa7134_vbi_qops,
 			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VBI_CAPTURE,
 			    V4L2_FIELD_SEQ_TB,
 			    sizeof(struct saa7134_buf),
-			    dev, NULL);
-	saa7134_pgtable_alloc(dev->pci, &dev->pt_cap);
-	saa7134_pgtable_alloc(dev->pci, &dev->pt_vbi);
+			    &dev->vbi_q, NULL);
+	saa7134_pgtable_alloc(dev->pci, &dev->video_q.pt);
+	saa7134_pgtable_alloc(dev->pci, &dev->vbi_q.pt);
 
 	return 0;
 }
@@ -2268,8 +2270,8 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 void saa7134_video_fini(struct saa7134_dev *dev)
 {
 	/* free stuff */
-	saa7134_pgtable_free(dev->pci, &dev->pt_cap);
-	saa7134_pgtable_free(dev->pci, &dev->pt_vbi);
+	saa7134_pgtable_free(dev->pci, &dev->video_q.pt);
+	saa7134_pgtable_free(dev->pci, &dev->vbi_q.pt);
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	if (card_has_radio(dev))
 		v4l2_ctrl_handler_free(&dev->radio_ctrl_handler);
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 0c325e5..dcdaf87 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -460,9 +460,6 @@ struct saa7134_buf {
 	int (*activate)(struct saa7134_dev *dev,
 			struct saa7134_buf *buf,
 			struct saa7134_buf *next);
-
-	/* page tables */
-	struct saa7134_pgtable  *pt;
 };
 
 struct saa7134_dmaqueue {
@@ -471,6 +468,7 @@ struct saa7134_dmaqueue {
 	struct list_head           queue;
 	struct timer_list          timeout;
 	unsigned int               need_two;
+	struct saa7134_pgtable     pt;
 };
 
 /* video filehandle status */
@@ -517,7 +515,6 @@ struct saa7134_dmasound {
 /* ts/mpeg status */
 struct saa7134_ts {
 	/* TS capture */
-	struct saa7134_pgtable     pt_ts;
 	int                        nr_packets;
 	int                        nr_bufs;
 };
@@ -590,10 +587,8 @@ struct saa7134_dev {
 
 	/* video+ts+vbi capture */
 	struct saa7134_dmaqueue    video_q;
-	struct saa7134_pgtable     pt_cap;
 	struct videobuf_queue      video_vbq;
 	struct saa7134_dmaqueue    vbi_q;
-	struct saa7134_pgtable     pt_vbi;
 	struct videobuf_queue      vbi_vbq;
 	unsigned int               video_fieldcount;
 	unsigned int               vbi_fieldcount;
-- 
1.9.2

