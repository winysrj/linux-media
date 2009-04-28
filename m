Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:64011 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbZD1Xvx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 19:51:53 -0400
Received: by ewy24 with SMTP id 24so934016ewy.37
        for <linux-media@vger.kernel.org>; Tue, 28 Apr 2009 16:51:52 -0700 (PDT)
Date: Tue, 28 Apr 2009 19:52:00 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH 3/3 ] big rework of TS for saa7134
Message-ID: <20090428195200.69d103e7@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/S/CKnj62tXPSsrZpWCY7AbO"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/S/CKnj62tXPSsrZpWCY7AbO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all.

1. Add start/stop TS function.
2. Move setup DMA of TS to DMA function.
3. Write support cupture via MMAP
4. Rework startup and finish process, remove simple FSM.

This is patch from our customer. I checked this.

diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Apr 28 07:34:07 2009 +1000
@@ -4205,6 +4205,7 @@
 		/* Igor Kuznetsov <igk@igk.ru> */
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		/* Alexey Osipov <lion-simba@pridelands.ru> */
 		.name           = "Beholder BeholdTV M6",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
@@ -4279,6 +4280,7 @@
 		/* Igor Kuznetsov <igk@igk.ru> */
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		/* Alexey Osipov <lion-simba@pridelands.ru> */
 		.name           = "Beholder BeholdTV M6 Extra",
 		.audio_clock    = 0x00187de7,
 		/* FIXME: Must be PHILIPS_FM1216ME_MK5*/
diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134-core.c
--- a/linux/drivers/media/video/saa7134/saa7134-core.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-core.c	Tue Apr 28 07:34:07 2009 +1000
@@ -380,6 +380,10 @@
 		dprintk("buffer_next %p\n",NULL);
 		saa7134_set_dmabits(dev);
 		del_timer(&q->timeout);
+		
+		if (card_has_mpeg(dev))
+		    if (dev->ts_started)
+			saa7134_ts_stop(dev);
 	}
 }
 
@@ -465,6 +469,17 @@
 		ctrl |= SAA7134_MAIN_CTRL_TE5;
 		irq  |= SAA7134_IRQ1_INTE_RA2_1 |
 			SAA7134_IRQ1_INTE_RA2_0;
+		
+		/* dma: setup channel 5 (= TS) */
+
+		saa_writeb(SAA7134_TS_DMA0, (dev->ts.nr_packets - 1) & 0xff);
+		saa_writeb(SAA7134_TS_DMA1, ((dev->ts.nr_packets - 1) >> 8) & 0xff);
+		/* TSNOPIT=0, TSCOLAP=0 */
+		saa_writeb(SAA7134_TS_DMA2, (((dev->ts.nr_packets - 1) >> 16) & 0x3f) | 0x00);
+		saa_writel(SAA7134_RS_PITCH(5), TS_PACKET_SIZE);
+		saa_writel(SAA7134_RS_CONTROL(5),  SAA7134_RS_CONTROL_BURST_16 |
+						   SAA7134_RS_CONTROL_ME |
+						  (dev->ts.pt_ts.dma >> 12));
 	}
 
 	/* set task conditions + field handling */
diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134-empress.c
--- a/linux/drivers/media/video/saa7134/saa7134-empress.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-empress.c	Tue Apr 28 07:34:07 2009 +1000
@@ -255,6 +255,16 @@
 	return 0;
 }
 
+static int empress_try_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct saa7134_dev *dev = file->private_data;
+
+	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
+	f->fmt.pix.sizeimage    = TS_PACKET_SIZE * dev->ts.nr_packets;
+
+	return 0;
+}
 
 static int empress_reqbufs(struct file *file, void *priv,
 					struct v4l2_requestbuffers *p)
@@ -450,6 +460,7 @@
 static const struct v4l2_ioctl_ops ts_ioctl_ops = {
 	.vidioc_querycap		= empress_querycap,
 	.vidioc_enum_fmt_vid_cap	= empress_enum_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap		= empress_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap		= empress_s_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap		= empress_g_fmt_vid_cap,
 	.vidioc_reqbufs			= empress_reqbufs,
@@ -499,11 +510,8 @@
 
 	if (dev->nosignal) {
 		dprintk("no video signal\n");
-		ts_reset_encoder(dev);
 	} else {
 		dprintk("video signal acquired\n");
-		if (atomic_read(&dev->empress_users))
-			ts_init_encoder(dev);
 	}
 }
 
diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134-ts.c
--- a/linux/drivers/media/video/saa7134/saa7134-ts.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-ts.c	Tue Apr 28 07:34:07 2009 +1000
@@ -65,34 +65,10 @@
 	/* start DMA */
 	saa7134_set_dmabits(dev);
 
-	mod_timer(&dev->ts_q.timeout, jiffies+BUFFER_TIMEOUT);
+	mod_timer(&dev->ts_q.timeout, jiffies+TS_BUFFER_TIMEOUT);
 
-	if (dev->ts_state == SAA7134_TS_BUFF_DONE) {
-		/* Clear TS cache */
-		dev->buff_cnt = 0;
-		saa_writeb(SAA7134_TS_SERIAL1, 0x00);
-		saa_writeb(SAA7134_TS_SERIAL1, 0x03);
-		saa_writeb(SAA7134_TS_SERIAL1, 0x00);
-		saa_writeb(SAA7134_TS_SERIAL1, 0x01);
-
-		/* TS clock non-inverted */
-		saa_writeb(SAA7134_TS_SERIAL1, 0x00);
-
-		/* Start TS stream */
-		switch (saa7134_boards[dev->board].ts_type) {
-		case SAA7134_MPEG_TS_PARALLEL:
-			saa_writeb(SAA7134_TS_SERIAL0, 0x40);
-			saa_writeb(SAA7134_TS_PARALLEL, 0xec);
-			break;
-		case SAA7134_MPEG_TS_SERIAL:
-			saa_writeb(SAA7134_TS_SERIAL0, 0xd8);
-			saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
-			saa_writeb(SAA7134_TS_PARALLEL_SERIAL, 0xbc);
-			saa_writeb(SAA7134_TS_SERIAL1, 0x02);
-			break;
-		}
-
-		dev->ts_state = SAA7134_TS_STARTED;
+	if (!dev->ts_started) {
+		saa7134_ts_start(dev);
 	}
 
 	return 0;
@@ -104,7 +80,6 @@
 	struct saa7134_dev *dev = q->priv_data;
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
 	unsigned int lines, llength, size;
-	u32 control;
 	int err;
 
 	dprintk("buffer_prepare [%p,%s]\n",buf,v4l2_field_names[field]);
@@ -120,8 +95,11 @@
 		saa7134_dma_free(q,buf);
 	}
 
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
+	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {		
+		
 		struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
+		
+		dprintk("buffer_prepare: needs_init\n");
 
 		buf->vb.width  = llength;
 		buf->vb.height = lines;
@@ -137,23 +115,6 @@
 					    saa7134_buffer_startpage(buf));
 		if (err)
 			goto oops;
-	}
-
-	dev->buff_cnt++;
-
-	if (dev->buff_cnt == dev->ts.nr_bufs) {
-		dev->ts_state = SAA7134_TS_BUFF_DONE;
-		/* dma: setup channel 5 (= TS) */
-		control = SAA7134_RS_CONTROL_BURST_16 |
-			SAA7134_RS_CONTROL_ME |
-			(buf->pt->dma >> 12);
-
-		saa_writeb(SAA7134_TS_DMA0, (lines - 1) & 0xff);
-		saa_writeb(SAA7134_TS_DMA1, ((lines - 1) >> 8) & 0xff);
-		/* TSNOPIT=0, TSCOLAP=0 */
-		saa_writeb(SAA7134_TS_DMA2, (((lines - 1) >> 16) & 0x3f) | 0x00);
-		saa_writel(SAA7134_RS_PITCH(5), TS_PACKET_SIZE);
-		saa_writel(SAA7134_RS_CONTROL(5), control);
 	}
 
 	buf->vb.state = VIDEOBUF_PREPARED;
@@ -175,8 +136,7 @@
 	if (0 == *count)
 		*count = dev->ts.nr_bufs;
 	*count = saa7134_buffer_count(*size,*count);
-	dev->buff_cnt = 0;
-	dev->ts_state = SAA7134_TS_STOPPED;
+	
 	return 0;
 }
 
@@ -193,13 +153,13 @@
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
 	struct saa7134_dev *dev = q->priv_data;
 
-	if (dev->ts_state == SAA7134_TS_STARTED) {
-		/* Stop TS transport */
-		saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
-		dev->ts_state = SAA7134_TS_STOPPED;
+	if (dev->ts_started) {
+		saa7134_ts_stop(dev);
 	}
 	saa7134_dma_free(q,buf);
 }
+
+
 
 struct videobuf_queue_ops saa7134_ts_qops = {
 	.buf_setup    = buffer_setup,
@@ -214,7 +174,7 @@
 
 static unsigned int tsbufs = 8;
 module_param(tsbufs, int, 0444);
-MODULE_PARM_DESC(tsbufs,"number of ts buffers, range 2-32");
+MODULE_PARM_DESC(tsbufs,"number of ts buffers for read/write IO, range 2-32");
 
 static unsigned int ts_nr_packets = 64;
 module_param(ts_nr_packets, int, 0444);
@@ -256,10 +216,66 @@
 	dev->ts_q.timeout.data     = (unsigned long)(&dev->ts_q);
 	dev->ts_q.dev              = dev;
 	dev->ts_q.need_two         = 1;
+	dev->ts_started            = 0;
 	saa7134_pgtable_alloc(dev->pci,&dev->ts.pt_ts);
 
 	/* init TS hw */
 	saa7134_ts_init_hw(dev);
+
+	return 0;
+}
+
+/* Function for stop TS */
+int saa7134_ts_stop(struct saa7134_dev *dev)
+{
+	dprintk("TS stop\n");
+	
+	BUG_ON(!dev->ts_started);
+
+	/* Stop TS stream */
+	switch (saa7134_boards[dev->board].ts_type) {
+	case SAA7134_MPEG_TS_PARALLEL:
+		saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
+		dev->ts_started = 0;
+		break;
+	case SAA7134_MPEG_TS_SERIAL:
+		saa_writeb(SAA7134_TS_SERIAL0, 0x40);
+		dev->ts_started = 0;
+		break;
+	}
+	return 0;
+}
+
+/* Function for start TS */
+int saa7134_ts_start(struct saa7134_dev *dev)
+{
+	dprintk("TS start\n");
+	
+	BUG_ON(dev->ts_started);
+
+	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
+	saa_writeb(SAA7134_TS_SERIAL1, 0x03);
+	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
+	saa_writeb(SAA7134_TS_SERIAL1, 0x01);
+
+	/* TS clock non-inverted */
+	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
+
+	/* Start TS stream */
+	switch (saa7134_boards[dev->board].ts_type) {
+	case SAA7134_MPEG_TS_PARALLEL:
+		saa_writeb(SAA7134_TS_SERIAL0, 0x40);
+		saa_writeb(SAA7134_TS_PARALLEL, 0xec);
+		break;
+	case SAA7134_MPEG_TS_SERIAL:
+		saa_writeb(SAA7134_TS_SERIAL0, 0xd8);
+		saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
+		saa_writeb(SAA7134_TS_PARALLEL_SERIAL, 0xbc);
+		saa_writeb(SAA7134_TS_SERIAL1, 0x02);
+		break;
+	}
+
+	dev->ts_started = 1;
 
 	return 0;
 }
diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Apr 28 07:34:07 2009 +1000
@@ -367,6 +367,7 @@
 #define INTERLACE_OFF          2
 
 #define BUFFER_TIMEOUT     msecs_to_jiffies(500)  /* 0.5 seconds */
+#define TS_BUFFER_TIMEOUT  msecs_to_jiffies(1000)  /* 1 second */
 
 struct saa7134_dev;
 struct saa7134_dma;
@@ -487,12 +488,6 @@
 	void                       (*signal_change)(struct saa7134_dev *dev);
 };
 
-enum saa7134_ts_status {
-	SAA7134_TS_STOPPED,
-	SAA7134_TS_BUFF_DONE,
-	SAA7134_TS_STARTED,
-};
-
 /* global device status */
 struct saa7134_dev {
 	struct list_head           devlist;
@@ -587,8 +582,7 @@
 	/* SAA7134_MPEG_* */
 	struct saa7134_ts          ts;
 	struct saa7134_dmaqueue    ts_q;
-	enum saa7134_ts_status 	   ts_state;
-	unsigned int 		   buff_cnt;
+	int                        ts_started;
 	struct saa7134_mpeg_ops    *mops;
 
 	/* SAA7134_MPEG_EMPRESS only */
@@ -746,6 +740,9 @@
 
 int saa7134_ts_init_hw(struct saa7134_dev *dev);
 
+int saa7134_ts_start(struct saa7134_dev *dev);
+int saa7134_ts_stop(struct saa7134_dev *dev);
+
 /* ----------------------------------------------------------- */
 /* saa7134-vbi.c                                               */
 

Signed-off-by: Alexey Osipov <lion-simba@pridelands.ru>


With my best regards, Dmitry.
--MP_/S/CKnj62tXPSsrZpWCY7AbO
Content-Type: text/x-patch; name=rework_ts.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=rework_ts.patch

diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Apr 28 07:34:07 2009 +1000
@@ -4205,6 +4205,7 @@
 		/* Igor Kuznetsov <igk@igk.ru> */
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		/* Alexey Osipov <lion-simba@pridelands.ru> */
 		.name           = "Beholder BeholdTV M6",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
@@ -4279,6 +4280,7 @@
 		/* Igor Kuznetsov <igk@igk.ru> */
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		/* Alexey Osipov <lion-simba@pridelands.ru> */
 		.name           = "Beholder BeholdTV M6 Extra",
 		.audio_clock    = 0x00187de7,
 		/* FIXME: Must be PHILIPS_FM1216ME_MK5*/
diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134-core.c
--- a/linux/drivers/media/video/saa7134/saa7134-core.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-core.c	Tue Apr 28 07:34:07 2009 +1000
@@ -380,6 +380,10 @@
 		dprintk("buffer_next %p\n",NULL);
 		saa7134_set_dmabits(dev);
 		del_timer(&q->timeout);
+		
+		if (card_has_mpeg(dev))
+		    if (dev->ts_started)
+			saa7134_ts_stop(dev);
 	}
 }
 
@@ -465,6 +469,17 @@
 		ctrl |= SAA7134_MAIN_CTRL_TE5;
 		irq  |= SAA7134_IRQ1_INTE_RA2_1 |
 			SAA7134_IRQ1_INTE_RA2_0;
+		
+		/* dma: setup channel 5 (= TS) */
+
+		saa_writeb(SAA7134_TS_DMA0, (dev->ts.nr_packets - 1) & 0xff);
+		saa_writeb(SAA7134_TS_DMA1, ((dev->ts.nr_packets - 1) >> 8) & 0xff);
+		/* TSNOPIT=0, TSCOLAP=0 */
+		saa_writeb(SAA7134_TS_DMA2, (((dev->ts.nr_packets - 1) >> 16) & 0x3f) | 0x00);
+		saa_writel(SAA7134_RS_PITCH(5), TS_PACKET_SIZE);
+		saa_writel(SAA7134_RS_CONTROL(5),  SAA7134_RS_CONTROL_BURST_16 |
+						   SAA7134_RS_CONTROL_ME |
+						  (dev->ts.pt_ts.dma >> 12));
 	}
 
 	/* set task conditions + field handling */
diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134-empress.c
--- a/linux/drivers/media/video/saa7134/saa7134-empress.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-empress.c	Tue Apr 28 07:34:07 2009 +1000
@@ -255,6 +255,16 @@
 	return 0;
 }
 
+static int empress_try_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct saa7134_dev *dev = file->private_data;
+
+	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
+	f->fmt.pix.sizeimage    = TS_PACKET_SIZE * dev->ts.nr_packets;
+
+	return 0;
+}
 
 static int empress_reqbufs(struct file *file, void *priv,
 					struct v4l2_requestbuffers *p)
@@ -450,6 +460,7 @@
 static const struct v4l2_ioctl_ops ts_ioctl_ops = {
 	.vidioc_querycap		= empress_querycap,
 	.vidioc_enum_fmt_vid_cap	= empress_enum_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap		= empress_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap		= empress_s_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap		= empress_g_fmt_vid_cap,
 	.vidioc_reqbufs			= empress_reqbufs,
@@ -499,11 +510,8 @@
 
 	if (dev->nosignal) {
 		dprintk("no video signal\n");
-		ts_reset_encoder(dev);
 	} else {
 		dprintk("video signal acquired\n");
-		if (atomic_read(&dev->empress_users))
-			ts_init_encoder(dev);
 	}
 }
 
diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134-ts.c
--- a/linux/drivers/media/video/saa7134/saa7134-ts.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-ts.c	Tue Apr 28 07:34:07 2009 +1000
@@ -65,34 +65,10 @@
 	/* start DMA */
 	saa7134_set_dmabits(dev);
 
-	mod_timer(&dev->ts_q.timeout, jiffies+BUFFER_TIMEOUT);
+	mod_timer(&dev->ts_q.timeout, jiffies+TS_BUFFER_TIMEOUT);
 
-	if (dev->ts_state == SAA7134_TS_BUFF_DONE) {
-		/* Clear TS cache */
-		dev->buff_cnt = 0;
-		saa_writeb(SAA7134_TS_SERIAL1, 0x00);
-		saa_writeb(SAA7134_TS_SERIAL1, 0x03);
-		saa_writeb(SAA7134_TS_SERIAL1, 0x00);
-		saa_writeb(SAA7134_TS_SERIAL1, 0x01);
-
-		/* TS clock non-inverted */
-		saa_writeb(SAA7134_TS_SERIAL1, 0x00);
-
-		/* Start TS stream */
-		switch (saa7134_boards[dev->board].ts_type) {
-		case SAA7134_MPEG_TS_PARALLEL:
-			saa_writeb(SAA7134_TS_SERIAL0, 0x40);
-			saa_writeb(SAA7134_TS_PARALLEL, 0xec);
-			break;
-		case SAA7134_MPEG_TS_SERIAL:
-			saa_writeb(SAA7134_TS_SERIAL0, 0xd8);
-			saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
-			saa_writeb(SAA7134_TS_PARALLEL_SERIAL, 0xbc);
-			saa_writeb(SAA7134_TS_SERIAL1, 0x02);
-			break;
-		}
-
-		dev->ts_state = SAA7134_TS_STARTED;
+	if (!dev->ts_started) {
+		saa7134_ts_start(dev);
 	}
 
 	return 0;
@@ -104,7 +80,6 @@
 	struct saa7134_dev *dev = q->priv_data;
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
 	unsigned int lines, llength, size;
-	u32 control;
 	int err;
 
 	dprintk("buffer_prepare [%p,%s]\n",buf,v4l2_field_names[field]);
@@ -120,8 +95,11 @@
 		saa7134_dma_free(q,buf);
 	}
 
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
+	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {		
+		
 		struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
+		
+		dprintk("buffer_prepare: needs_init\n");
 
 		buf->vb.width  = llength;
 		buf->vb.height = lines;
@@ -137,23 +115,6 @@
 					    saa7134_buffer_startpage(buf));
 		if (err)
 			goto oops;
-	}
-
-	dev->buff_cnt++;
-
-	if (dev->buff_cnt == dev->ts.nr_bufs) {
-		dev->ts_state = SAA7134_TS_BUFF_DONE;
-		/* dma: setup channel 5 (= TS) */
-		control = SAA7134_RS_CONTROL_BURST_16 |
-			SAA7134_RS_CONTROL_ME |
-			(buf->pt->dma >> 12);
-
-		saa_writeb(SAA7134_TS_DMA0, (lines - 1) & 0xff);
-		saa_writeb(SAA7134_TS_DMA1, ((lines - 1) >> 8) & 0xff);
-		/* TSNOPIT=0, TSCOLAP=0 */
-		saa_writeb(SAA7134_TS_DMA2, (((lines - 1) >> 16) & 0x3f) | 0x00);
-		saa_writel(SAA7134_RS_PITCH(5), TS_PACKET_SIZE);
-		saa_writel(SAA7134_RS_CONTROL(5), control);
 	}
 
 	buf->vb.state = VIDEOBUF_PREPARED;
@@ -175,8 +136,7 @@
 	if (0 == *count)
 		*count = dev->ts.nr_bufs;
 	*count = saa7134_buffer_count(*size,*count);
-	dev->buff_cnt = 0;
-	dev->ts_state = SAA7134_TS_STOPPED;
+	
 	return 0;
 }
 
@@ -193,13 +153,13 @@
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
 	struct saa7134_dev *dev = q->priv_data;
 
-	if (dev->ts_state == SAA7134_TS_STARTED) {
-		/* Stop TS transport */
-		saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
-		dev->ts_state = SAA7134_TS_STOPPED;
+	if (dev->ts_started) {
+		saa7134_ts_stop(dev);
 	}
 	saa7134_dma_free(q,buf);
 }
+
+
 
 struct videobuf_queue_ops saa7134_ts_qops = {
 	.buf_setup    = buffer_setup,
@@ -214,7 +174,7 @@
 
 static unsigned int tsbufs = 8;
 module_param(tsbufs, int, 0444);
-MODULE_PARM_DESC(tsbufs,"number of ts buffers, range 2-32");
+MODULE_PARM_DESC(tsbufs,"number of ts buffers for read/write IO, range 2-32");
 
 static unsigned int ts_nr_packets = 64;
 module_param(ts_nr_packets, int, 0444);
@@ -256,10 +216,66 @@
 	dev->ts_q.timeout.data     = (unsigned long)(&dev->ts_q);
 	dev->ts_q.dev              = dev;
 	dev->ts_q.need_two         = 1;
+	dev->ts_started            = 0;
 	saa7134_pgtable_alloc(dev->pci,&dev->ts.pt_ts);
 
 	/* init TS hw */
 	saa7134_ts_init_hw(dev);
+
+	return 0;
+}
+
+/* Function for stop TS */
+int saa7134_ts_stop(struct saa7134_dev *dev)
+{
+	dprintk("TS stop\n");
+	
+	BUG_ON(!dev->ts_started);
+
+	/* Stop TS stream */
+	switch (saa7134_boards[dev->board].ts_type) {
+	case SAA7134_MPEG_TS_PARALLEL:
+		saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
+		dev->ts_started = 0;
+		break;
+	case SAA7134_MPEG_TS_SERIAL:
+		saa_writeb(SAA7134_TS_SERIAL0, 0x40);
+		dev->ts_started = 0;
+		break;
+	}
+	return 0;
+}
+
+/* Function for start TS */
+int saa7134_ts_start(struct saa7134_dev *dev)
+{
+	dprintk("TS start\n");
+	
+	BUG_ON(dev->ts_started);
+
+	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
+	saa_writeb(SAA7134_TS_SERIAL1, 0x03);
+	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
+	saa_writeb(SAA7134_TS_SERIAL1, 0x01);
+
+	/* TS clock non-inverted */
+	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
+
+	/* Start TS stream */
+	switch (saa7134_boards[dev->board].ts_type) {
+	case SAA7134_MPEG_TS_PARALLEL:
+		saa_writeb(SAA7134_TS_SERIAL0, 0x40);
+		saa_writeb(SAA7134_TS_PARALLEL, 0xec);
+		break;
+	case SAA7134_MPEG_TS_SERIAL:
+		saa_writeb(SAA7134_TS_SERIAL0, 0xd8);
+		saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
+		saa_writeb(SAA7134_TS_PARALLEL_SERIAL, 0xbc);
+		saa_writeb(SAA7134_TS_SERIAL1, 0x02);
+		break;
+	}
+
+	dev->ts_started = 1;
 
 	return 0;
 }
diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Apr 28 07:34:07 2009 +1000
@@ -367,6 +367,7 @@
 #define INTERLACE_OFF          2
 
 #define BUFFER_TIMEOUT     msecs_to_jiffies(500)  /* 0.5 seconds */
+#define TS_BUFFER_TIMEOUT  msecs_to_jiffies(1000)  /* 1 second */
 
 struct saa7134_dev;
 struct saa7134_dma;
@@ -487,12 +488,6 @@
 	void                       (*signal_change)(struct saa7134_dev *dev);
 };
 
-enum saa7134_ts_status {
-	SAA7134_TS_STOPPED,
-	SAA7134_TS_BUFF_DONE,
-	SAA7134_TS_STARTED,
-};
-
 /* global device status */
 struct saa7134_dev {
 	struct list_head           devlist;
@@ -587,8 +582,7 @@
 	/* SAA7134_MPEG_* */
 	struct saa7134_ts          ts;
 	struct saa7134_dmaqueue    ts_q;
-	enum saa7134_ts_status 	   ts_state;
-	unsigned int 		   buff_cnt;
+	int                        ts_started;
 	struct saa7134_mpeg_ops    *mops;
 
 	/* SAA7134_MPEG_EMPRESS only */
@@ -746,6 +740,9 @@
 
 int saa7134_ts_init_hw(struct saa7134_dev *dev);
 
+int saa7134_ts_start(struct saa7134_dev *dev);
+int saa7134_ts_stop(struct saa7134_dev *dev);
+
 /* ----------------------------------------------------------- */
 /* saa7134-vbi.c                                               */
 

Signed-off-by: Alexey Osipov <lion-simba@pridelands.ru>

--MP_/S/CKnj62tXPSsrZpWCY7AbO--
