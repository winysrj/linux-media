Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:33004 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbZELVFH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 17:05:07 -0400
Subject: Re: [PATCH 3/3 ] big rework of TS for saa7134
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
In-Reply-To: <20090511210107.1eafb364@glory.loctelecom.ru>
References: <20090428195200.69d103e7@glory.loctelecom.ru>
	 <20090511193705.0e06fac8@pedra.chehab.org>
	 <1242082536.11527.4.camel@pc07.localdom.local>
	 <20090511202123.383c8300@glory.loctelecom.ru>
	 <20090511215456.2fe38980@pedra.chehab.org>
	 <20090511210107.1eafb364@glory.loctelecom.ru>
Content-Type: multipart/mixed; boundary="=-VIprhJjtwzox4ZcWbDUt"
Date: Tue, 12 May 2009 23:02:32 +0200
Message-Id: <1242162153.3749.20.camel@pc07.localdom.local>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-VIprhJjtwzox4ZcWbDUt
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Am Montag, den 11.05.2009, 21:01 +1000 schrieb Dmitri Belimov:
> Hi 
> 
> > Em Mon, 11 May 2009 20:21:23 +1000
> > Dmitri Belimov <d.belimov@gmail.com> escreveu:
> > 
> > > > > Cheers,
> > > > > Mauro
> > > > 
> > > > Did you check it is still OK for DVB-T and DVB-S also?
> > > 
> > > No. We tested only with analog TV, capturing from analog TV and
> > > composite input. It support serial and parallel TS from MPEG
> > > encoder to saa7134.
> > 
> > Since the patch touched on saa7134-ts, it is important to check if it
> > will not cause regressions with DVB. Could you please test it?
> 
> Ok. I'll do it with our customers. In my place hasn't any DVB channels.

Dmitry, the patches from your RESEND don't apply anymore, since already
two of your previous patches, still present in this set, are now in
v4l-dvb.

I did apply manually. Also you did not run "make checkpatch" and I tried
to fix a bunch of coding style errors and warnings from it.

Please review the attached version and consider to use it for a RESEND
v2. More testers welcome, also for DVB serial TS and ATSC.

For DVB parallel TS.
Tested-by: Hermann Pitton <hermann-pitton@arcor.de>

Cheers,
Hermann

> With my best regards, Dmitry.
> 
> > Cheers,
> > Mauro

--=-VIprhJjtwzox4ZcWbDUt
Content-Disposition: inline; filename=saa7134_ts_rework_applies_and_checkpatch_fixes.patch
Content-Type: text/x-patch; name=saa7134_ts_rework_applies_and_checkpatch_fixes.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r 8d37e8505664 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon May 11 09:37:41 2009 -0700
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue May 12 21:48:12 2009 +0200
@@ -4495,6 +4495,7 @@
 		/* Igor Kuznetsov <igk@igk.ru> */
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		/* Alexey Osipov <lion-simba@pridelands.ru> */
 		.name           = "Beholder BeholdTV M6",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
@@ -4569,6 +4570,7 @@
 		/* Igor Kuznetsov <igk@igk.ru> */
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		/* Alexey Osipov <lion-simba@pridelands.ru> */
 		.name           = "Beholder BeholdTV M6 Extra",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
diff -r 8d37e8505664 linux/drivers/media/video/saa7134/saa7134-core.c
--- a/linux/drivers/media/video/saa7134/saa7134-core.c	Mon May 11 09:37:41 2009 -0700
+++ b/linux/drivers/media/video/saa7134/saa7134-core.c	Tue May 12 21:48:12 2009 +0200
@@ -380,6 +380,10 @@
 		dprintk("buffer_next %p\n",NULL);
 		saa7134_set_dmabits(dev);
 		del_timer(&q->timeout);
+
+		if (card_has_mpeg(dev))
+			if (dev->ts_started)
+				saa7134_ts_stop(dev);
 	}
 }
 
@@ -465,6 +469,19 @@
 		ctrl |= SAA7134_MAIN_CTRL_TE5;
 		irq  |= SAA7134_IRQ1_INTE_RA2_1 |
 			SAA7134_IRQ1_INTE_RA2_0;
+
+		/* dma: setup channel 5 (= TS) */
+
+		saa_writeb(SAA7134_TS_DMA0, (dev->ts.nr_packets - 1) & 0xff);
+		saa_writeb(SAA7134_TS_DMA1,
+			((dev->ts.nr_packets - 1) >> 8) & 0xff);
+		/* TSNOPIT=0, TSCOLAP=0 */
+		saa_writeb(SAA7134_TS_DMA2,
+			(((dev->ts.nr_packets - 1) >> 16) & 0x3f) | 0x00);
+		saa_writel(SAA7134_RS_PITCH(5), TS_PACKET_SIZE);
+		saa_writel(SAA7134_RS_CONTROL(5), SAA7134_RS_CONTROL_BURST_16 |
+						  SAA7134_RS_CONTROL_ME |
+						  (dev->ts.pt_ts.dma >> 12));
 	}
 
 	/* set task conditions + field handling */
diff -r 8d37e8505664 linux/drivers/media/video/saa7134/saa7134-empress.c
--- a/linux/drivers/media/video/saa7134/saa7134-empress.c	Mon May 11 09:37:41 2009 -0700
+++ b/linux/drivers/media/video/saa7134/saa7134-empress.c	Tue May 12 21:48:12 2009 +0200
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
diff -r 8d37e8505664 linux/drivers/media/video/saa7134/saa7134-ts.c
--- a/linux/drivers/media/video/saa7134/saa7134-ts.c	Mon May 11 09:37:41 2009 -0700
+++ b/linux/drivers/media/video/saa7134/saa7134-ts.c	Tue May 12 21:48:12 2009 +0200
@@ -67,33 +67,8 @@
 
 	mod_timer(&dev->ts_q.timeout, jiffies+TS_BUFFER_TIMEOUT);
 
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
-	}
+	if (!dev->ts_started)
+		saa7134_ts_start(dev);
 
 	return 0;
 }
@@ -104,7 +79,6 @@
 	struct saa7134_dev *dev = q->priv_data;
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
 	unsigned int lines, llength, size;
-	u32 control;
 	int err;
 
 	dprintk("buffer_prepare [%p,%s]\n",buf,v4l2_field_names[field]);
@@ -121,8 +95,11 @@
 	}
 
 	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
+
 		struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
 
+		dprintk("buffer_prepare: needs_init\n");
+
 		buf->vb.width  = llength;
 		buf->vb.height = lines;
 		buf->vb.size   = size;
@@ -139,23 +116,6 @@
 			goto oops;
 	}
 
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
-	}
-
 	buf->vb.state = VIDEOBUF_PREPARED;
 	buf->activate = buffer_activate;
 	buf->vb.field = field;
@@ -175,8 +135,7 @@
 	if (0 == *count)
 		*count = dev->ts.nr_bufs;
 	*count = saa7134_buffer_count(*size,*count);
-	dev->buff_cnt = 0;
-	dev->ts_state = SAA7134_TS_STOPPED;
+
 	return 0;
 }
 
@@ -193,11 +152,9 @@
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
 	struct saa7134_dev *dev = q->priv_data;
 
-	if (dev->ts_state == SAA7134_TS_STARTED) {
-		/* Stop TS transport */
-		saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
-		dev->ts_state = SAA7134_TS_STOPPED;
-	}
+	if (dev->ts_started)
+		saa7134_ts_stop(dev);
+
 	saa7134_dma_free(q,buf);
 }
 
@@ -214,7 +171,7 @@
 
 static unsigned int tsbufs = 8;
 module_param(tsbufs, int, 0444);
-MODULE_PARM_DESC(tsbufs,"number of ts buffers, range 2-32");
+MODULE_PARM_DESC(tsbufs, "number of ts buffers for read/write IO, range 2-32");
 
 static unsigned int ts_nr_packets = 64;
 module_param(ts_nr_packets, int, 0444);
@@ -256,6 +213,7 @@
 	dev->ts_q.timeout.data     = (unsigned long)(&dev->ts_q);
 	dev->ts_q.dev              = dev;
 	dev->ts_q.need_two         = 1;
+	dev->ts_started            = 0;
 	saa7134_pgtable_alloc(dev->pci,&dev->ts.pt_ts);
 
 	/* init TS hw */
@@ -264,13 +222,67 @@
 	return 0;
 }
 
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
+
+	return 0;
+}
+
 int saa7134_ts_fini(struct saa7134_dev *dev)
 {
 	saa7134_pgtable_free(dev->pci,&dev->ts.pt_ts);
 	return 0;
 }
 
-
 void saa7134_irq_ts_done(struct saa7134_dev *dev, unsigned long status)
 {
 	enum v4l2_field field;
diff -r 8d37e8505664 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Mon May 11 09:37:41 2009 -0700
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue May 12 21:48:12 2009 +0200
@@ -498,12 +498,6 @@
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
@@ -598,8 +592,7 @@
 	/* SAA7134_MPEG_* */
 	struct saa7134_ts          ts;
 	struct saa7134_dmaqueue    ts_q;
-	enum saa7134_ts_status 	   ts_state;
-	unsigned int 		   buff_cnt;
+	int                        ts_started;
 	struct saa7134_mpeg_ops    *mops;
 
 	/* SAA7134_MPEG_EMPRESS only */
@@ -757,6 +750,9 @@
 
 int saa7134_ts_init_hw(struct saa7134_dev *dev);
 
+int saa7134_ts_start(struct saa7134_dev *dev);
+int saa7134_ts_stop(struct saa7134_dev *dev);
+
 /* ----------------------------------------------------------- */
 /* saa7134-vbi.c                                               */
 

--=-VIprhJjtwzox4ZcWbDUt--

