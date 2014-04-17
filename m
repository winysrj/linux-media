Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4236 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaDQKje (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 06:39:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 05/11] saa7134: store VBI hlen/vlen globally
Date: Thu, 17 Apr 2014 12:39:08 +0200
Message-Id: <1397731154-34337-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
References: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't calculate this for every buffer, store it globally instead.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-vbi.c | 38 +++++++++++++++------------------
 drivers/media/pci/saa7134/saa7134.h     |  1 +
 2 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index e044539..7f28563 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -67,10 +67,10 @@ static void task_init(struct saa7134_dev *dev, struct saa7134_buf *buf,
 	saa_writeb(SAA7134_VBI_PHASE_OFFSET_LUMA(task),   0x00);
 	saa_writeb(SAA7134_VBI_PHASE_OFFSET_CHROMA(task), 0x00);
 
-	saa_writeb(SAA7134_VBI_H_LEN1(task), buf->vb.width   & 0xff);
-	saa_writeb(SAA7134_VBI_H_LEN2(task), buf->vb.width   >> 8);
-	saa_writeb(SAA7134_VBI_V_LEN1(task), buf->vb.height  & 0xff);
-	saa_writeb(SAA7134_VBI_V_LEN2(task), buf->vb.height  >> 8);
+	saa_writeb(SAA7134_VBI_H_LEN1(task), dev->vbi_hlen & 0xff);
+	saa_writeb(SAA7134_VBI_H_LEN2(task), dev->vbi_hlen >> 8);
+	saa_writeb(SAA7134_VBI_V_LEN1(task), dev->vbi_vlen & 0xff);
+	saa_writeb(SAA7134_VBI_V_LEN2(task), dev->vbi_vlen >> 8);
 
 	saa_andorb(SAA7134_DATA_PATH(task), 0xc0, 0x00);
 }
@@ -98,12 +98,12 @@ static int buffer_activate(struct saa7134_dev *dev,
 		SAA7134_RS_CONTROL_ME |
 		(buf->pt->dma >> 12);
 	saa_writel(SAA7134_RS_BA1(2), base);
-	saa_writel(SAA7134_RS_BA2(2), base + buf->vb.size / 2);
-	saa_writel(SAA7134_RS_PITCH(2), buf->vb.width);
+	saa_writel(SAA7134_RS_BA2(2), base + dev->vbi_hlen * dev->vbi_vlen);
+	saa_writel(SAA7134_RS_PITCH(2), dev->vbi_hlen);
 	saa_writel(SAA7134_RS_CONTROL(2), control);
 	saa_writel(SAA7134_RS_BA1(3), base);
-	saa_writel(SAA7134_RS_BA2(3), base + buf->vb.size / 2);
-	saa_writel(SAA7134_RS_PITCH(3), buf->vb.width);
+	saa_writel(SAA7134_RS_BA2(3), base + dev->vbi_hlen * dev->vbi_vlen);
+	saa_writel(SAA7134_RS_PITCH(3), dev->vbi_hlen);
 	saa_writel(SAA7134_RS_CONTROL(3), control);
 
 	/* start DMA */
@@ -119,15 +119,10 @@ static int buffer_prepare(struct videobuf_queue *q,
 {
 	struct saa7134_dev *dev = q->priv_data;
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
-	struct saa7134_tvnorm *norm = dev->tvnorm;
-	unsigned int lines, llength, size;
+	unsigned int size;
 	int err;
 
-	lines   = norm->vbi_v_stop_0 - norm->vbi_v_start_0 +1;
-	if (lines > VBI_LINE_COUNT)
-		lines = VBI_LINE_COUNT;
-	llength = VBI_LINE_LENGTH;
-	size = lines * llength * 2;
+	size = dev->vbi_hlen * dev->vbi_vlen * 2;
 	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
 		return -EINVAL;
 
@@ -137,8 +132,8 @@ static int buffer_prepare(struct videobuf_queue *q,
 	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
 		struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
 
-		buf->vb.width  = llength;
-		buf->vb.height = lines;
+		buf->vb.width  = dev->vbi_hlen;
+		buf->vb.height = dev->vbi_vlen;
 		buf->vb.size   = size;
 		buf->pt        = &dev->pt_vbi;
 
@@ -166,11 +161,12 @@ static int
 buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 {
 	struct saa7134_dev *dev = q->priv_data;
-	int llength,lines;
 
-	lines   = dev->tvnorm->vbi_v_stop_0 - dev->tvnorm->vbi_v_start_0 +1;
-	llength = VBI_LINE_LENGTH;
-	*size = lines * llength * 2;
+	dev->vbi_vlen = dev->tvnorm->vbi_v_stop_0 - dev->tvnorm->vbi_v_start_0 + 1;
+	if (dev->vbi_vlen > VBI_LINE_COUNT)
+		dev->vbi_vlen = VBI_LINE_COUNT;
+	dev->vbi_hlen = VBI_LINE_LENGTH;
+	*size = dev->vbi_hlen * dev->vbi_vlen * 2;
 	if (0 == *count)
 		*count = vbibufs;
 	*count = saa7134_buffer_count(*size,*count);
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 419f5f8..907568e 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -600,6 +600,7 @@ struct saa7134_dev {
 	unsigned int               vbi_fieldcount;
 	struct saa7134_format      *fmt;
 	unsigned int               width, height;
+	unsigned int               vbi_hlen, vbi_vlen;
 	struct pm_qos_request	   qos_request;
 
 	/* various v4l controls */
-- 
1.9.2

