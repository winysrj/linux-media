Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60055 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbbD3OIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 17/22] saa7134-ts: use pr_fmt() at the debug macro
Date: Thu, 30 Apr 2015 11:08:37 -0300
Message-Id: <b5256a58a3e1c559f3ba44f96c307ddde3410235.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

instead of using dev->name, let's use pr_fmt() like on the
other parts of saa7134. Also, rename the debug macro to
ts_dbg() to match the namespace for the debug macros.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 8a2938c34d32..5d7c4afac8e6 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -35,8 +35,8 @@ static unsigned int ts_debug;
 module_param(ts_debug, int, 0644);
 MODULE_PARM_DESC(ts_debug,"enable debug messages [ts]");
 
-#define dprintk(fmt, arg...)	if (ts_debug) \
-	printk(KERN_DEBUG "%s/ts: " fmt, dev->name , ## arg)
+#define ts_dbg(fmt, arg...)	if (ts_debug) \
+	printk(KERN_DEBUG pr_fmt("ts: " fmt), ## arg)
 
 /* ------------------------------------------------------------------ */
 static int buffer_activate(struct saa7134_dev *dev,
@@ -44,7 +44,7 @@ static int buffer_activate(struct saa7134_dev *dev,
 			   struct saa7134_buf *next)
 {
 
-	dprintk("buffer_activate [%p]",buf);
+	ts_dbg("buffer_activate [%p]",buf);
 	buf->top_seen = 0;
 
 	if (!dev->ts_started)
@@ -53,12 +53,12 @@ static int buffer_activate(struct saa7134_dev *dev,
 	if (NULL == next)
 		next = buf;
 	if (V4L2_FIELD_TOP == dev->ts_field) {
-		dprintk("- [top]     buf=%p next=%p\n",buf,next);
+		ts_dbg("- [top]     buf=%p next=%p\n",buf,next);
 		saa_writel(SAA7134_RS_BA1(5),saa7134_buffer_base(buf));
 		saa_writel(SAA7134_RS_BA2(5),saa7134_buffer_base(next));
 		dev->ts_field = V4L2_FIELD_BOTTOM;
 	} else {
-		dprintk("- [bottom]  buf=%p next=%p\n",buf,next);
+		ts_dbg("- [bottom]  buf=%p next=%p\n",buf,next);
 		saa_writel(SAA7134_RS_BA1(5),saa7134_buffer_base(next));
 		saa_writel(SAA7134_RS_BA2(5),saa7134_buffer_base(buf));
 		dev->ts_field = V4L2_FIELD_TOP;
@@ -95,7 +95,7 @@ int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2)
 	struct sg_table *dma = vb2_dma_sg_plane_desc(vb2, 0);
 	unsigned int lines, llength, size;
 
-	dprintk("buffer_prepare [%p]\n", buf);
+	ts_dbg("buffer_prepare [%p]\n", buf);
 
 	llength = TS_PACKET_SIZE;
 	lines = dev->ts.nr_packets;
@@ -239,7 +239,7 @@ int saa7134_ts_init1(struct saa7134_dev *dev)
 /* Function for stop TS */
 int saa7134_ts_stop(struct saa7134_dev *dev)
 {
-	dprintk("TS stop\n");
+	ts_dbg("TS stop\n");
 
 	if (!dev->ts_started)
 		return 0;
@@ -261,7 +261,7 @@ int saa7134_ts_stop(struct saa7134_dev *dev)
 /* Function for start TS */
 int saa7134_ts_start(struct saa7134_dev *dev)
 {
-	dprintk("TS start\n");
+	ts_dbg("TS start\n");
 
 	if (WARN_ON(dev->ts_started))
 		return 0;
-- 
2.1.0

