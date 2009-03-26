Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.emlix.com ([193.175.82.87]:56445 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756193AbZCZOgI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 10:36:08 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Chris Zankel <chris@zankel.net>, linux-media@vger.kernel.org,
	Oskar Schirmer <os@emlix.com>
Subject: [patch 3/5] s6000 data port: canonical modes
Date: Thu, 26 Mar 2009 15:36:57 +0100
Message-Id: <1238078219-25904-3-git-send-email-dg@emlix.com>
In-Reply-To: <1238078219-25904-1-git-send-email-dg@emlix.com>
References: <1238078219-25904-1-git-send-email-dg@emlix.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oskar Schirmer <os@emlix.com>

Add optional handling of a list of video modes not directly supported by
the on-chip video engine. Makes use of extended dma capabilities to provide
these modes:

YUV420 and grey mode as well as planar YUV422 and YUV444 with non-aligned
planes

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 drivers/media/video/s6dp/Kconfig |    9 +
 drivers/media/video/s6dp/s6dp.c  |  382 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 388 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/s6dp/Kconfig b/drivers/media/video/s6dp/Kconfig
index 11cc91d..357cfe5 100644
--- a/drivers/media/video/s6dp/Kconfig
+++ b/drivers/media/video/s6dp/Kconfig
@@ -4,3 +4,12 @@ config VIDEO_S6000
 	default n
 	help
 	  Enables the s6000 video driver.
+
+config VIDEO_S6000_CANONICAL
+	tristate "S6000 video canonical modes"
+	depends on VIDEO_S6000
+	default n
+	help
+	  Provides canonical video modes in addition
+	  to the s6 specific ones. You might want these when
+	  standard video software is used with the driver.
diff --git a/drivers/media/video/s6dp/s6dp.c b/drivers/media/video/s6dp/s6dp.c
index 9f349be..68f8e3d 100644
--- a/drivers/media/video/s6dp/s6dp.c
+++ b/drivers/media/video/s6dp/s6dp.c
@@ -60,6 +60,11 @@
 #define CURRENT_BUF_TYPE(pd) ((pd)->ext.egress ? V4L2_BUF_TYPE_VIDEO_OUTPUT \
 					       : V4L2_BUF_TYPE_VIDEO_CAPTURE)
 
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+#define PROCBUFFERS	4
+#define PROCSTEPMAX	3
+#endif
+
 struct s6dp_frame {
 	void *data;
 	dma_addr_t dma_handle;
@@ -67,6 +72,9 @@ struct s6dp_frame {
 	struct list_head list;
 	u32 sequence;
 	u32 flags;
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	unsigned procdidx;
+#endif
 };
 
 struct s6dp {
@@ -122,6 +130,26 @@ struct s6dp {
 	struct s6dp_frame *frames;
 	unsigned nrframes;
 	unsigned nrmapped;
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	struct {
+		u32 dmac;
+		u8 chan;
+		u8 planemask;
+		u8 stepcnt;
+		u8 maxstep;
+		struct list_head queue;
+		void *buffers_vaddr[PROCBUFFERS];
+		dma_addr_t dma_handle[PROCBUFFERS];
+		u32 bufsize;
+		u8 bufget;
+		u8 bufput;
+		u32 bufoff[PROCSTEPMAX];
+		u32 frameoff[PROCSTEPMAX];
+		s32 stepsize[PROCSTEPMAX];
+		u16 stepchunk[PROCSTEPMAX];
+		u16 stepskip[PROCSTEPMAX];
+	} proc;
+#endif
 	struct {
 		u8 is_10bit:1;
 		u8 micron:1;
@@ -164,6 +192,11 @@ static void s6dp_try_fill_dma(struct s6dp *pd)
 	struct list_head *inq;
 	if (pd->cur.state != DP_STATE_ACTIVE)
 		return;
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	if (pd->ext.egress && pd->proc.maxstep)
+		inq = &pd->proc.queue;
+	else
+#endif
 	inq = &pd->idleq;
 	while (!list_empty(inq)) {
 		unsigned chan = pd->port * S6_DP_CHAN_PER_PORT;
@@ -174,10 +207,24 @@ static void s6dp_try_fill_dma(struct s6dp *pd)
 			     && s6dmac_fifo_full(pd->dmac, chan + i))
 				return;
 		f = list_first_entry(inq, struct s6dp_frame, list);
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+		if (pd->proc.maxstep) {
+			if (pd->proc.bufget == pd->proc.bufput)
+				return;
+			f->procdidx = (pd->proc.bufput++) % PROCBUFFERS;
+		} else {
+			f->procdidx = 0;
+		}
+#endif
 		list_del(&f->list);
 		list_add_tail(&f->list, &pd->busyq);
 		do if (pd->cur.chansiz[--i]) {
 			u32 h, b, s, d;
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+			if ((pd->proc.planemask >> i) & 1)
+				b = (u32)pd->proc.dma_handle[f->procdidx];
+			else
+#endif
 				b = (u32)f->dma_handle;
 			b += pd->cur.chanoff[i];
 			h = pd->dataram + S6_DP_CHAN_OFFSET(i);
@@ -195,6 +242,53 @@ static void s6dp_try_fill_dma(struct s6dp *pd)
 	}
 }
 
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+static void s6dp_try_fill_lms(struct s6dp *pd)
+{
+	if (!list_empty(&pd->proc.queue)) {
+		struct s6dp_frame *f;
+		unsigned n = pd->proc.stepcnt;
+		u32 s;
+		int l;
+		s6dmac_set_stride_skip(pd->proc.dmac, pd->proc.chan,
+			pd->proc.stepchunk[n], pd->proc.stepskip[n], 0);
+		f = list_first_entry(&pd->proc.queue, struct s6dp_frame, list);
+		l = pd->proc.stepsize[n];
+		if (l < 0) {
+			l = -l;
+			s = (u32)pd->proc.dma_handle[f->procdidx];
+		} else {
+			s = (u32)f->dma_handle;
+		}
+		s6dmac_put_fifo(pd->proc.dmac, pd->proc.chan,
+			s + pd->proc.bufoff[n],
+			(u32)f->dma_handle + pd->proc.frameoff[n], l);
+		pd->proc.stepcnt += 1;
+	}
+}
+
+static void s6dp_lms_interrupt(struct s6dp *pd)
+{
+	struct s6dp_frame *f;
+	if (pd->cur.state != DP_STATE_ACTIVE)
+		return;
+	if (pd->proc.stepcnt == pd->proc.maxstep) {
+		if (list_empty(&pd->proc.queue)) {
+			printk(DRV_ERR "no buffers available in processing\n");
+			return;
+		}
+		f = list_first_entry(&pd->proc.queue, struct s6dp_frame, list);
+		list_del(&f->list);
+		pd->proc.stepcnt = 0;
+		pd->proc.bufget += 1;
+		list_add_tail(&f->list, &pd->fullq);
+		wake_up_interruptible(&pd->wait);
+	}
+	s6dp_try_fill_lms(pd);
+	s6dp_try_fill_dma(pd);
+}
+#endif
+
 static void s6dp_err_interrupt(struct s6dp *pd)
 {
 	u32 m, r = DP_REG_R(pd, S6_DP_INT_UNMAP_RAW1);
@@ -250,6 +344,10 @@ static void s6dp_tc_interrupt(struct s6dp *pd)
 		u32 newfc, pending, global;
 		struct list_head *outq = &pd->fullq;
 
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+		if (!pd->ext.egress && pd->proc.maxstep)
+			outq = &pd->proc.queue;
+#endif
 		do_gettimeofday(&now);
 		global = readl(S6_REG_GREG1 + S6_GREG1_GLOBAL_TIMER);
 		DP_REG_W(pd, S6_DP_INT_CLEAR, 1 << S6_DP_INT_TERMCNT(pd->port));
@@ -286,6 +384,10 @@ static void s6dp_tc_interrupt(struct s6dp *pd)
 		if (unlikely(list_empty(&pd->busyq)) && pending)
 			printk(DRV_ERR "no repeating frame?\n");
 		s6dp_try_fill_dma(pd);
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+		if (!list_empty(&pd->proc.queue) && !pd->proc.stepcnt)
+			s6dp_try_fill_lms(pd);
+#endif
 		if (!list_empty(&pd->fullq))
 			wake_up_interruptible(&pd->wait);
 	}
@@ -311,6 +413,14 @@ static irqreturn_t s6dp_interrupt(int irq, void *dev_id)
 				s6dp_tc_interrupt(pd);
 				ret = IRQ_HANDLED;
 			}
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+			if (s6dmac_pendcnt_irq(pd->proc.dmac, pd->proc.chan)
+			     && !s6dmac_pending_count(pd->proc.dmac,
+						      pd->proc.chan)) {
+				s6dp_lms_interrupt(pd);
+				ret = IRQ_HANDLED;
+			}
+#endif
 			spin_unlock(&pd->lock);
 		}
 	}
@@ -395,6 +505,17 @@ static int s6dp_dma_init(struct video_device *dev)
 		& ~(7 << S6_DP_VIDEO_DMA_CFG_BURST_BITS(pd->port)))
 		| (burstsize << S6_DP_VIDEO_DMA_CFG_BURST_BITS(pd->port)));
 
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	if (pd->proc.maxstep) {
+		n = s6dmac_request_chan(pd->proc.dmac, pd->proc.chan, 1,
+			-1, 1, 1, 0, 0, 0, 7, -1, 1, 0, 1);
+		if (n < 0) {
+			printk(DRV_ERR "error - LMS DMA not available\n");
+			goto errdma;
+		}
+		pd->proc.stepcnt = 0;
+	}
+#endif
 	return 0;
 errdma:
 	while (i > 0) {
@@ -419,6 +540,12 @@ static void s6dp_dma_free(struct video_device *dev)
 		s6dmac_release_chan(pd->dmac,
 				    pd->port * S6_DP_CHAN_PER_PORT + i);
 	} while (++i < n);
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	if (pd->proc.maxstep) {
+		s6dmac_release_chan(pd->proc.dmac, pd->proc.chan);
+		pd->proc.stepcnt = 0;
+	}
+#endif
 }
 
 static int s6dp_setup_stream(struct video_device *dev)
@@ -855,12 +982,24 @@ static void s6dp_relbufs(struct video_device *dev)
 	INIT_LIST_HEAD(&pd->idleq);
 	INIT_LIST_HEAD(&pd->busyq);
 	INIT_LIST_HEAD(&pd->fullq);
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	INIT_LIST_HEAD(&pd->proc.queue);
+#endif
 	spin_unlock_irqrestore(&pd->lock, flags);
 	for (i = 0; i < pd->nrframes; i++)
 		dma_free_coherent(dev->parent, pd->cur.bufsize,
 				  pd->frames[i].data, pd->frames[i].dma_handle);
 	kfree(pd->frames);
 	pd->nrframes = 0;
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	if (pd->proc.bufsize) {
+		for (i = 0; i < PROCBUFFERS; i++)
+			dma_free_noncoherent(dev->parent, pd->proc.bufsize,
+					     pd->proc.buffers_vaddr[i],
+					     pd->proc.dma_handle[i]);
+		pd->proc.bufsize = 0;
+	}
+#endif
 }
 
 static int s6dp_video_close(struct file *file)
@@ -1068,11 +1207,41 @@ static inline unsigned s6dp_set_hw2buf(struct s6dp *pd, int chan,
 	return 1 << chan;
 }
 
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+static inline int s6dp_set_procbuf(struct s6dp *pd, unsigned count,
+			unsigned srcoff, unsigned trgoff, unsigned size,
+			unsigned srcseek, unsigned trgseek,
+			unsigned srcchunk, unsigned trgchunk)
+{
+	BUG_ON(count >= PROCSTEPMAX);
+	pd->proc.bufoff[count] = srcoff + srcseek;
+	pd->proc.frameoff[count] = trgoff + trgseek;
+	pd->proc.stepsize[count] = size - trgseek;
+	pd->proc.stepchunk[count] = trgchunk;
+	pd->proc.stepskip[count] = srcchunk - trgchunk;
+	return 1;
+}
+
+static inline int s6dp_set_proctmp(struct s6dp *pd, unsigned count,
+			unsigned srcoff, unsigned trgoff, signed size,
+			unsigned srcchunk, unsigned trgchunk)
+{
+	return s6dp_set_procbuf(pd, count, srcoff, trgoff, -size,
+			0, 0, srcchunk, trgchunk);
+}
+#endif
+
 static int s6dp_set_current(struct video_device *dev, u32 fourcc, u32 modenr,
 			int aligned)
 {
 	struct s6dp *pd = video_get_drvdata(dev);
 	u32 uyl, ayl, uyf, ayf, ucl, acl, acf;
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	u32 t, ucf;
+	t = 0;
+	pd->proc.planemask = 0;
+	pd->proc.maxstep = 0;
+#endif
 	pd->cur.fourcc = fourcc;
 	pd->cur.modenr = modenr;
 	pd->cur.aligned = aligned;
@@ -1092,8 +1261,13 @@ static int s6dp_set_current(struct video_device *dev, u32 fourcc, u32 modenr,
 		acl = s6dp_bytealigned(ucl);
 		uyf = s6dp_byteperframe(pd, 0, uyl);
 		ayf = s6dp_byteperframe(pd, 0, ayl);
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+		ucf = s6dp_byteperframe(pd, fourcc == V4L2_PIX_FMT_YUV420,
+				aligned ? acl : ucl);
+#else
 		if (!aligned && ayl != pd->cur.greyperchroma * acl)
 			return -EINVAL;
+#endif
 		acf = s6dp_byteperframe(pd, 0, acl);
 		switch (fourcc) {
 	case V4L2_PIX_FMT_YUV444P:
@@ -1102,6 +1276,20 @@ static int s6dp_set_current(struct video_device *dev, u32 fourcc, u32 modenr,
 			s6dp_set_hw2buf(pd, DP_CB_OFFSET, ayf, acf);
 			s6dp_set_hw2buf(pd, DP_CR_OFFSET, ayf + acf, acf);
 			pd->cur.bufsize = ayf + 2 * acf;
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+		} else {
+			s6dp_set_hw2buf(pd, DP_Y_OFFSET, 0, ayf);
+			s6dp_set_hw2buf(pd, DP_CB_OFFSET, ayf, acf);
+			pd->proc.planemask =
+				s6dp_set_hw2buf(pd, DP_CR_OFFSET, 0, acf);
+			pd->proc.maxstep =
+				s6dp_set_procbuf(pd, 0, 0, 0, uyf + ucf,
+					ayl, uyl, acl, ucl) +
+				s6dp_set_proctmp(pd, 1, 0, uyf + ucf, ucf,
+						acl, ucl);
+			pd->cur.bufsize = uyf + 2 * ucf;
+			t = acf;
+#endif
 		}
 		break;
 	case V4L2_PIX_FMT_YUV422P:
@@ -1110,13 +1298,132 @@ static int s6dp_set_current(struct video_device *dev, u32 fourcc, u32 modenr,
 			s6dp_set_hw2buf(pd, DP_CB_OFFSET, ayf, acf);
 			s6dp_set_hw2buf(pd, DP_CR_OFFSET, ayf + acf, acf);
 			pd->cur.bufsize = ayf + 2 * acf;
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+		} else if (uyl == ayl) {
+			s6dp_set_hw2buf(pd, DP_Y_OFFSET, 0, ayf);
+			s6dp_set_hw2buf(pd, DP_CB_OFFSET, ayf, acf);
+			pd->proc.planemask =
+				s6dp_set_hw2buf(pd, DP_CR_OFFSET, 0, acf);
+			pd->proc.maxstep =
+				s6dp_set_procbuf(pd, 0, ayf, uyf, ucf,
+					acl, ucl, acl, ucl) +
+				s6dp_set_proctmp(pd, 1, 0, uyf + ucf, ucf,
+						acl, ucl);
+			pd->cur.bufsize = uyf + 2 * ucf;
+			t = acf;
+		} else {
+			s6dp_set_hw2buf(pd, DP_Y_OFFSET, 0, ayf);
+			s6dp_set_hw2buf(pd, DP_CB_OFFSET, ayf, acf);
+			pd->proc.planemask =
+				s6dp_set_hw2buf(pd, DP_CR_OFFSET, 0, acf);
+			pd->proc.maxstep =
+				s6dp_set_procbuf(pd, 0, 0, 0, uyf,
+					ayl, uyl, ayl, uyl) +
+				s6dp_set_procbuf(pd, 1, ayf, uyf, ucf,
+					0, 0, acl, ucl) +
+				s6dp_set_proctmp(pd, 2, 0, uyf + ucf, ucf,
+						acl, ucl);
+			pd->cur.bufsize = uyf + 2 * ucf;
+			t = acf;
+#endif
 		}
 		break;
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	case V4L2_PIX_FMT_YUV420:
+		if (aligned || ucl == acl) {
+			s6dp_set_hw2buf(pd, DP_Y_OFFSET, 0, ayf);
+			s6dp_set_hw2buf(pd, DP_CB_OFFSET, ayf, acf);
+			pd->proc.planemask =
+				s6dp_set_hw2buf(pd, DP_CR_OFFSET, 0, acf);
+			pd->proc.maxstep =
+				s6dp_set_procbuf(pd, 0, ayf, ayf, ucf,
+					2*acl, acl, 2*acl, acl) +
+				s6dp_set_proctmp(pd, 1, 0, ayf + ucf, ucf,
+						2*acl, acl);
+			pd->cur.bufsize = ayf + 2 * ucf;
+			t = acf;
+		} else if (uyl == ayl) {
+			s6dp_set_hw2buf(pd, DP_Y_OFFSET, 0, ayf);
+			pd->proc.planemask =
+				s6dp_set_hw2buf(pd, DP_CB_OFFSET, 0, acf) +
+				s6dp_set_hw2buf(pd, DP_CR_OFFSET, acf, acf);
+			pd->proc.maxstep =
+				s6dp_set_proctmp(pd, 0, 0, uyf, 2*ucf,
+						2*acl, ucl);
+			pd->cur.bufsize = uyf + 2 * ucf;
+			t = 2*acf;
+		} else {
+			s6dp_set_hw2buf(pd, DP_Y_OFFSET, 0, ayf);
+			pd->proc.planemask =
+				s6dp_set_hw2buf(pd, DP_CB_OFFSET, 0, acf) +
+				s6dp_set_hw2buf(pd, DP_CR_OFFSET, acf, acf);
+			pd->proc.maxstep =
+				s6dp_set_procbuf(pd, 0, 0, 0, uyf,
+					ayl, uyl, ayl, uyl) +
+				s6dp_set_proctmp(pd, 1, 0, uyf, 2*ucf,
+						2*acl, ucl);
+			pd->cur.bufsize = uyf + 2 * ucf;
+			t = 2*acf;
+		}
+		break;
+	case V4L2_PIX_FMT_GREY:
+		if (aligned || uyl == ayl) {
+			s6dp_set_hw2buf(pd, DP_Y_OFFSET, 0, ayf);
+			pd->proc.planemask =
+				s6dp_set_hw2buf(pd, DP_CB_OFFSET, 0, acf) +
+				s6dp_set_hw2buf(pd, DP_CR_OFFSET, 0, acf);
+			pd->cur.bufsize = ayf;
+			t = acf;
+		} else {
+			s6dp_set_hw2buf(pd, DP_CB_OFFSET, 0, acf);
+			s6dp_set_hw2buf(pd, DP_CR_OFFSET, 0, acf);
+			pd->proc.planemask =
+				s6dp_set_hw2buf(pd, DP_Y_OFFSET, 0, ayf);
+			pd->proc.maxstep =
+				s6dp_set_proctmp(pd, 0, 0, 0, uyf, ayl, uyl);
+			pd->cur.bufsize = uyf;
+			t = ayf;
+		}
+		break;
+#endif
 	default:
 		BUG();
 		}
 	}
 	BUG_ON(pd->cur.bufsize >= (1 << 24));
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	if (pd->proc.bufsize) {
+		int i;
+		for (i = 0; i < PROCBUFFERS; i++)
+			dma_free_noncoherent(dev->parent, pd->proc.bufsize,
+					     pd->proc.buffers_vaddr[i],
+					     pd->proc.dma_handle[i]);
+		pd->proc.bufsize = 0;
+	}
+	if (t) {
+		int i;
+		for (i = 0; i < PROCBUFFERS; i++) {
+			void *p;
+			p = dma_alloc_noncoherent(dev->parent, t,
+						  pd->proc.dma_handle + i,
+						  GFP_KERNEL);
+			if (!p)
+				break;
+			pd->proc.buffers_vaddr[i] = p;
+		}
+		if (i < PROCBUFFERS) {
+			while (i--)
+				dma_free_noncoherent(dev->parent,
+						     pd->proc.bufsize,
+						     pd->proc.buffers_vaddr[i],
+						     pd->proc.dma_handle[i]);
+			return -ENOMEM;
+		}
+		pd->proc.bufsize = t;
+		pd->proc.bufget = PROCBUFFERS;
+		pd->proc.bufput = 0;
+	}
+#endif
 	return 0;
 }
 
@@ -1434,6 +1741,14 @@ const static struct {
 	{	V4L2_PIX_FMT_YUV422P,
 		"YUV 4:2:2 planar",
 	},
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	{	V4L2_PIX_FMT_YUV420,
+		"YUV 4:2:0 planar",
+	},
+	{	V4L2_PIX_FMT_GREY,
+		"GREY",
+	},
+#endif
 };
 
 static int s6v4l_enum_fmt_cap(struct file *file, void *priv,
@@ -1515,6 +1830,9 @@ static int s6v4l_try_fmt(struct file *file, void *priv,
 	struct video_device *dev = file->private_data;
 	struct s6dp *pd = video_get_drvdata(dev);
 	int cwidth, cheight, cbytesperline, aligned = 1;
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	u32 reqfourcc = f->fmt.pix.pixelformat;
+#endif
 	if (!pd->link || !pd->link->s_fmt || !pd->link->g_mode)
 		return 0;
 
@@ -1533,6 +1851,23 @@ static int s6v4l_try_fmt(struct file *file, void *priv,
 	}
 	if (f->fmt.pix.field == V4L2_FIELD_ALTERNATE)
 		f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	switch (f->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_YUV422P:
+		switch (reqfourcc) {
+		case V4L2_PIX_FMT_YUV420:
+		case V4L2_PIX_FMT_GREY:
+			f->fmt.pix.pixelformat = reqfourcc;
+		}
+		break;
+	case V4L2_PIX_FMT_YUV444P:
+		switch (reqfourcc) {
+		case V4L2_PIX_FMT_GREY:
+			f->fmt.pix.pixelformat = reqfourcc;
+		}
+	}
+	aligned = f->fmt.pix.priv & 1;
+#endif
 	cheight = f->fmt.pix.height;
 	switch (f->fmt.pix.pixelformat) {
 	case V4L2_PIX_FMT_YUV444P:
@@ -1579,6 +1914,10 @@ static int s6v4l_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	f->fmt.pix.height = pd->cur.height;
 	f->fmt.pix.pixelformat = pd->cur.fourcc;
 	f->fmt.pix.bytesperline = s6dp_bytealigned(f->fmt.pix.width);
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	if (!pd->cur.aligned)
+		f->fmt.pix.bytesperline = f->fmt.pix.width;
+#endif
 	f->fmt.pix.priv = pd->cur.aligned;
 	f->fmt.pix.sizeimage = pd->cur.bufsize;
 	return 0;
@@ -1764,7 +2103,8 @@ static const struct v4l2_ioctl_ops output_v4l_ioctl_ops = {
 
 static int probe_one(struct platform_device *pdev, int irq,
 		     struct video_device **devs, struct s6dp_link *link,
-		     void __iomem *dpbase, void __iomem *dmac, u32 physbase)
+		     void __iomem *dpbase, void __iomem *dmac, u32 physbase,
+		     void __iomem *procdmac, int instance)
 {
 	struct video_device *dev;
 	struct s6dp *pd;
@@ -1794,6 +2134,10 @@ static int probe_one(struct platform_device *pdev, int irq,
 	pd->irq = irq;
 	pd->dp = dpbase;
 	pd->dmac = (u32)dmac;
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	pd->proc.dmac = DMA_MASK_DMAC((u32)procdmac);
+	pd->proc.chan = DMA_INDEX_CHNL((u32)procdmac) + instance;
+#endif
 	for (index = 0; !(link->port_mask & (1 << index)); index++)
 		;
 	if (link->port_mask != (1 << index)) {
@@ -1809,6 +2153,9 @@ static int probe_one(struct platform_device *pdev, int irq,
 	INIT_LIST_HEAD(&pd->idleq);
 	INIT_LIST_HEAD(&pd->busyq);
 	INIT_LIST_HEAD(&pd->fullq);
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	INIT_LIST_HEAD(&pd->proc.queue);
+#endif
 	init_waitqueue_head(&pd->wait);
 	spin_lock_init(&pd->lock);
 	if (video_register_device_index(dev, VFL_TYPE_GRABBER, link->minor,
@@ -1835,8 +2182,11 @@ static int __devinit s6dp_probe(struct platform_device *pdev)
 	unsigned in_use;
 	struct video_device **devs;
 	struct s6dp_link *links;
-	void __iomem *dpbase, *dmacbase;
+	void __iomem *dpbase, *dmacbase, *procdmacbase = 0;
 	struct resource *res, *regs, *dmac;
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	struct resource *procdmac;
+#endif
 	if (!pdev->dev.platform_data) {
 		printk(DRV_ERR "no platform data given\n");
 		return -EINVAL;
@@ -1884,6 +2234,25 @@ static int __devinit s6dp_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto err_free_dmac;
 	}
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	res = platform_get_resource(pdev, IORESOURCE_DMA, 1);
+	if (!res) {
+		ret = -EINVAL;
+		goto err_unmap_dmac;
+	}
+	procdmac = request_mem_region(res->start, res->end - res->start + 1,
+				      pdev->name);
+	if (!procdmac) {
+		ret = -EBUSY;
+		goto err_unmap_dmac;
+	}
+	procdmacbase = ioremap_nocache(procdmac->start,
+				       procdmac->end - procdmac->start + 1);
+	if (!procdmacbase) {
+		ret = -ENOMEM;
+		goto err_free_procdmac;
+	}
+#endif
 	i = 0;
 	in_use = 0;
 	for (links = pdev->dev.platform_data; links->port_mask; links++) {
@@ -1892,7 +2261,7 @@ static int __devinit s6dp_probe(struct platform_device *pdev)
 			continue;
 		}
 		ret = probe_one(pdev, irq, &devs[i], links, dpbase, dmacbase,
-				regs->start);
+				regs->start, procdmacbase, i);
 		if (ret)
 			goto err_free_devs;
 		in_use |= links->port_mask;
@@ -1910,6 +2279,13 @@ err_free_devs:
 			video_device_release(devs[i]);
 		}
 	}
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	iounmap(procdmacbase);
+err_free_procdmac:
+	release_mem_region(procdmac->start,
+			   procdmac->end - procdmac->start + 1);
+err_unmap_dmac:
+#endif
 	iounmap(dmacbase);
 err_free_dmac:
 	release_mem_region(dmac->start, dmac->end - dmac->start + 1);
-- 
1.6.2.107.ge47ee

