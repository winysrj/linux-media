Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:53686 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbcDWLEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2016 07:04:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCHv4 05/13] media/pci: convert drivers to use the new vb2_queue dev field
Date: Sat, 23 Apr 2016 13:03:41 +0200
Message-Id: <1461409429-24995-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461409429-24995-1-git-send-email-hverkuil@xs4all.nl>
References: <1461409429-24995-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Stop using alloc_ctx and just fill in the device pointer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Federico Vaga <federico.vaga@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/cobalt/cobalt-driver.c          |  9 ---------
 drivers/media/pci/cobalt/cobalt-driver.h          |  1 -
 drivers/media/pci/cobalt/cobalt-v4l2.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-417.c           |  1 -
 drivers/media/pci/cx23885/cx23885-core.c          | 10 +---------
 drivers/media/pci/cx23885/cx23885-dvb.c           |  2 +-
 drivers/media/pci/cx23885/cx23885-vbi.c           |  1 -
 drivers/media/pci/cx23885/cx23885-video.c         |  3 ++-
 drivers/media/pci/cx23885/cx23885.h               |  1 -
 drivers/media/pci/cx25821/cx25821-core.c          | 10 +---------
 drivers/media/pci/cx25821/cx25821-video.c         |  3 +--
 drivers/media/pci/cx25821/cx25821.h               |  1 -
 drivers/media/pci/cx88/cx88-blackbird.c           |  2 +-
 drivers/media/pci/cx88/cx88-dvb.c                 |  2 +-
 drivers/media/pci/cx88/cx88-mpeg.c                | 10 +---------
 drivers/media/pci/cx88/cx88-vbi.c                 |  1 -
 drivers/media/pci/cx88/cx88-video.c               | 11 ++---------
 drivers/media/pci/cx88/cx88.h                     |  2 --
 drivers/media/pci/dt3155/dt3155.c                 | 13 ++-----------
 drivers/media/pci/dt3155/dt3155.h                 |  2 --
 drivers/media/pci/saa7134/saa7134-core.c          | 22 +++++++---------------
 drivers/media/pci/saa7134/saa7134-ts.c            |  1 -
 drivers/media/pci/saa7134/saa7134-vbi.c           |  1 -
 drivers/media/pci/saa7134/saa7134-video.c         |  3 ++-
 drivers/media/pci/saa7134/saa7134.h               |  1 -
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c    | 11 +----------
 drivers/media/pci/solo6x10/solo6x10-v4l2.c        | 10 +---------
 drivers/media/pci/solo6x10/solo6x10.h             |  2 --
 drivers/media/pci/sta2x11/sta2x11_vip.c           | 18 ++----------------
 drivers/media/pci/tw68/tw68-core.c                | 15 +++------------
 drivers/media/pci/tw68/tw68-video.c               |  2 +-
 drivers/media/pci/tw68/tw68.h                     |  1 -
 drivers/staging/media/tw686x-kh/tw686x-kh-video.c | 10 +---------
 drivers/staging/media/tw686x-kh/tw686x-kh.h       |  1 -
 34 files changed, 32 insertions(+), 153 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 8d6f04f..1aaa2b0 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -691,17 +691,10 @@ static int cobalt_probe(struct pci_dev *pci_dev,
 	cobalt->pci_dev = pci_dev;
 	cobalt->instance = i;
 
-	cobalt->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
-	if (IS_ERR(cobalt->alloc_ctx)) {
-		kfree(cobalt);
-		return -ENOMEM;
-	}
-
 	retval = v4l2_device_register(&pci_dev->dev, &cobalt->v4l2_dev);
 	if (retval) {
 		pr_err("cobalt: v4l2_device_register of card %d failed\n",
 				cobalt->instance);
-		vb2_dma_sg_cleanup_ctx(cobalt->alloc_ctx);
 		kfree(cobalt);
 		return retval;
 	}
@@ -782,7 +775,6 @@ err:
 	cobalt_err("error %d on initialization\n", retval);
 
 	v4l2_device_unregister(&cobalt->v4l2_dev);
-	vb2_dma_sg_cleanup_ctx(cobalt->alloc_ctx);
 	kfree(cobalt);
 	return retval;
 }
@@ -818,7 +810,6 @@ static void cobalt_remove(struct pci_dev *pci_dev)
 	cobalt_info("removed cobalt card\n");
 
 	v4l2_device_unregister(v4l2_dev);
-	vb2_dma_sg_cleanup_ctx(cobalt->alloc_ctx);
 	kfree(cobalt);
 }
 
diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index b2f08e4..ed00dc9 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -262,7 +262,6 @@ struct cobalt {
 	int instance;
 	struct pci_dev *pci_dev;
 	struct v4l2_device v4l2_dev;
-	void *alloc_ctx;
 
 	void __iomem *bar0, *bar1;
 
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index c0ba458..6c19cdf 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -54,7 +54,6 @@ static int cobalt_queue_setup(struct vb2_queue *q,
 		*num_buffers = 3;
 	if (*num_buffers > NR_BUFS)
 		*num_buffers = NR_BUFS;
-	alloc_ctxs[0] = s->cobalt->alloc_ctx;
 	if (*num_planes)
 		return sizes[0] < size ? -EINVAL : 0;
 	*num_planes = 1;
@@ -1224,6 +1223,7 @@ static int cobalt_node_register(struct cobalt *cobalt, int node)
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->min_buffers_needed = 2;
 	q->lock = &s->lock;
+	q->dev = &cobalt->pci_dev->dev;
 	vdev->queue = q;
 
 	video_set_drvdata(vdev, s);
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index bd33387..0174d08 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1148,7 +1148,6 @@ static int queue_setup(struct vb2_queue *q,
 	dev->ts1.ts_packet_count = mpeglines;
 	*num_planes = 1;
 	sizes[0] = mpeglinesize * mpeglines;
-	alloc_ctxs[0] = dev->alloc_ctx;
 	*num_buffers = mpegbufs;
 	return 0;
 }
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 813c217..c86b109 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -2005,14 +2005,9 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	err = pci_set_dma_mask(pci_dev, 0xffffffff);
 	if (err) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
-		goto fail_context;
+		goto fail_ctrl;
 	}
 
-	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		err = PTR_ERR(dev->alloc_ctx);
-		goto fail_context;
-	}
 	err = request_irq(pci_dev->irq, cx23885_irq,
 			  IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
@@ -2041,8 +2036,6 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	return 0;
 
 fail_irq:
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
-fail_context:
 	cx23885_dev_unregister(dev);
 fail_ctrl:
 	v4l2_ctrl_handler_free(hdl);
@@ -2068,7 +2061,6 @@ static void cx23885_finidev(struct pci_dev *pci_dev)
 	pci_disable_device(pci_dev);
 
 	cx23885_dev_unregister(dev);
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	v4l2_device_unregister(v4l2_dev);
 	kfree(dev);
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index f041b69..6ad07f5 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -102,7 +102,6 @@ static int queue_setup(struct vb2_queue *q,
 	port->ts_packet_count = 32;
 	*num_planes = 1;
 	sizes[0] = port->ts_packet_size * port->ts_packet_count;
-	alloc_ctxs[0] = port->dev->alloc_ctx;
 	*num_buffers = 32;
 	return 0;
 }
@@ -2397,6 +2396,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
 		q->mem_ops = &vb2_dma_sg_memops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->lock = &dev->lock;
+		q->dev = &dev->pci->dev;
 
 		err = vb2_queue_init(q);
 		if (err < 0)
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index 39750eb..2de9485 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -131,7 +131,6 @@ static int queue_setup(struct vb2_queue *q,
 		lines = VBI_NTSC_LINE_COUNT;
 	*num_planes = 1;
 	sizes[0] = lines * VBI_LINE_LENGTH * 2;
-	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index e1d7d08..3ff86d6 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -341,7 +341,6 @@ static int queue_setup(struct vb2_queue *q,
 
 	*num_planes = 1;
 	sizes[0] = (dev->fmt->depth * dev->width * dev->height) >> 3;
-	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 
@@ -1268,6 +1267,7 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	q->mem_ops = &vb2_dma_sg_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &dev->lock;
+	q->dev = &dev->pci->dev;
 
 	err = vb2_queue_init(q);
 	if (err < 0)
@@ -1284,6 +1284,7 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	q->mem_ops = &vb2_dma_sg_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &dev->lock;
+	q->dev = &dev->pci->dev;
 
 	err = vb2_queue_init(q);
 	if (err < 0)
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index b1a5409..a25b641 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -430,7 +430,6 @@ struct cx23885_dev {
 	struct vb2_queue           vb2_vidq;
 	struct cx23885_dmaqueue    vbiq;
 	struct vb2_queue           vb2_vbiq;
-	void			   *alloc_ctx;
 
 	spinlock_t                 slock;
 
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 0042803..9a5f912 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -1301,15 +1301,10 @@ static int cx25821_initdev(struct pci_dev *pci_dev,
 
 		goto fail_unregister_device;
 	}
-	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		err = PTR_ERR(dev->alloc_ctx);
-		goto fail_unregister_pci;
-	}
 
 	err = cx25821_dev_setup(dev);
 	if (err)
-		goto fail_free_ctx;
+		goto fail_unregister_pci;
 
 	/* print pci info */
 	pci_read_config_byte(pci_dev, PCI_CLASS_REVISION, &dev->pci_rev);
@@ -1340,8 +1335,6 @@ fail_irq:
 	pr_info("cx25821_initdev() can't get IRQ !\n");
 	cx25821_dev_unregister(dev);
 
-fail_free_ctx:
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 fail_unregister_pci:
 	pci_disable_device(pci_dev);
 fail_unregister_device:
@@ -1365,7 +1358,6 @@ static void cx25821_finidev(struct pci_dev *pci_dev)
 		free_irq(pci_dev->irq, dev);
 
 	cx25821_dev_unregister(dev);
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	v4l2_device_unregister(v4l2_dev);
 	kfree(dev);
 }
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index c48bba9..45fc23e 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -148,8 +148,6 @@ static int cx25821_queue_setup(struct vb2_queue *q,
 	struct cx25821_channel *chan = q->drv_priv;
 	unsigned size = (chan->fmt->depth * chan->width * chan->height) >> 3;
 
-	alloc_ctxs[0] = chan->dev->alloc_ctx;
-
 	if (*num_planes)
 		return sizes[0] < size ? -EINVAL : 0;
 
@@ -759,6 +757,7 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		q->mem_ops = &vb2_dma_sg_memops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->lock = &dev->lock;
+		q->dev = &dev->pci->dev;
 
 		if (!is_output) {
 			err = vb2_queue_init(q);
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index a513b68..35c7375 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -249,7 +249,6 @@ struct cx25821_dev {
 	int hwrevision;
 	/* used by cx25821-alsa */
 	struct snd_card *card;
-	void *alloc_ctx;
 
 	u32 clk_freq;
 
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 3233d45..7c026c1c 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -647,7 +647,6 @@ static int queue_setup(struct vb2_queue *q,
 	dev->ts_packet_size  = 188 * 4;
 	dev->ts_packet_count  = 32;
 	sizes[0] = dev->ts_packet_size * dev->ts_packet_count;
-	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 
@@ -1183,6 +1182,7 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	q->mem_ops = &vb2_dma_sg_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &core->lock;
+	q->dev = &dev->pci->dev;
 
 	err = vb2_queue_init(q);
 	if (err < 0)
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 851d2a9..4d91d16 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -92,7 +92,6 @@ static int queue_setup(struct vb2_queue *q,
 	dev->ts_packet_size  = 188 * 4;
 	dev->ts_packet_count = dvb_buf_tscnt;
 	sizes[0] = dev->ts_packet_size * dev->ts_packet_count;
-	alloc_ctxs[0] = dev->alloc_ctx;
 	*num_buffers = dvb_buf_tscnt;
 	return 0;
 }
@@ -1793,6 +1792,7 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 		q->mem_ops = &vb2_dma_sg_memops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->lock = &core->lock;
+		q->dev = &dev->pci->dev;
 
 		err = vb2_queue_init(q);
 		if (err < 0)
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index f34c229..245357a 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -726,11 +726,6 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 	if (NULL == dev)
 		goto fail_core;
 	dev->pci = pci_dev;
-	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		err = PTR_ERR(dev->alloc_ctx);
-		goto fail_dev;
-	}
 	dev->core = core;
 
 	/* Maintain a reference so cx88-video can query the 8802 device. */
@@ -738,7 +733,7 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 
 	err = cx8802_init_common(dev);
 	if (err != 0)
-		goto fail_free;
+		goto fail_dev;
 
 	INIT_LIST_HEAD(&dev->drvlist);
 	mutex_lock(&cx8802_mutex);
@@ -749,8 +744,6 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 	request_modules(dev);
 	return 0;
 
- fail_free:
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
  fail_dev:
 	kfree(dev);
  fail_core:
@@ -798,7 +791,6 @@ static void cx8802_remove(struct pci_dev *pci_dev)
 	/* common */
 	cx8802_fini_common(dev);
 	cx88_core_put(dev->core,dev->pci);
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	kfree(dev);
 }
 
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index ccc646d..2479f7d 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -118,7 +118,6 @@ static int queue_setup(struct vb2_queue *q,
 		sizes[0] = VBI_LINE_NTSC_COUNT * VBI_LINE_LENGTH * 2;
 	else
 		sizes[0] = VBI_LINE_PAL_COUNT * VBI_LINE_LENGTH * 2;
-	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 5f331df..9764d6f 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -438,7 +438,6 @@ static int queue_setup(struct vb2_queue *q,
 
 	*num_planes = 1;
 	sizes[0] = (dev->fmt->depth * core->width * core->height) >> 3;
-	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 
@@ -1319,12 +1318,6 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n",core->name);
 		goto fail_core;
 	}
-	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		err = PTR_ERR(dev->alloc_ctx);
-		goto fail_core;
-	}
-
 
 	/* initialize driver struct */
 	spin_lock_init(&dev->slock);
@@ -1445,6 +1438,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	q->mem_ops = &vb2_dma_sg_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &core->lock;
+	q->dev = &dev->pci->dev;
 
 	err = vb2_queue_init(q);
 	if (err < 0)
@@ -1461,6 +1455,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	q->mem_ops = &vb2_dma_sg_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &core->lock;
+	q->dev = &dev->pci->dev;
 
 	err = vb2_queue_init(q);
 	if (err < 0)
@@ -1530,7 +1525,6 @@ fail_unreg:
 	free_irq(pci_dev->irq, dev);
 	mutex_unlock(&core->lock);
 fail_core:
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	core->v4ldev = NULL;
 	cx88_core_put(core,dev->pci);
 fail_free:
@@ -1564,7 +1558,6 @@ static void cx8800_finidev(struct pci_dev *pci_dev)
 
 	/* free memory */
 	cx88_core_put(core,dev->pci);
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	kfree(dev);
 }
 
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 78f817e..ecd4b7b 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -485,7 +485,6 @@ struct cx8800_dev {
 	/* pci i/o */
 	struct pci_dev             *pci;
 	unsigned char              pci_rev,pci_lat;
-	void			   *alloc_ctx;
 
 	const struct cx8800_fmt    *fmt;
 
@@ -549,7 +548,6 @@ struct cx8802_dev {
 	/* pci i/o */
 	struct pci_dev             *pci;
 	unsigned char              pci_rev,pci_lat;
-	void			   *alloc_ctx;
 
 	/* dma queues */
 	struct cx88_dmaqueue       mpegq;
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index 568c0c8..ec8f58a 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -141,7 +141,6 @@ dt3155_queue_setup(struct vb2_queue *vq,
 
 	if (vq->num_buffers + *nbuffers < 2)
 		*nbuffers = 2 - vq->num_buffers;
-	alloc_ctxs[0] = pd->alloc_ctx;
 	if (*num_planes)
 		return sizes[0] < size ? -EINVAL : 0;
 	*num_planes = 1;
@@ -544,21 +543,16 @@ static int dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pd->vidq.min_buffers_needed = 2;
 	pd->vidq.gfp_flags = GFP_DMA32;
 	pd->vidq.lock = &pd->mux; /* for locking v4l2_file_operations */
+	pd->vidq.dev = &pdev->dev;
 	pd->vdev.queue = &pd->vidq;
 	err = vb2_queue_init(&pd->vidq);
 	if (err < 0)
 		goto err_v4l2_dev_unreg;
-	pd->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(pd->alloc_ctx)) {
-		dev_err(&pdev->dev, "Can't allocate buffer context");
-		err = PTR_ERR(pd->alloc_ctx);
-		goto err_v4l2_dev_unreg;
-	}
 	spin_lock_init(&pd->lock);
 	pd->config = ACQ_MODE_EVEN;
 	err = pci_enable_device(pdev);
 	if (err)
-		goto err_free_ctx;
+		goto err_v4l2_dev_unreg;
 	err = pci_request_region(pdev, 0, pci_name(pdev));
 	if (err)
 		goto err_pci_disable;
@@ -588,8 +582,6 @@ err_free_reg:
 	pci_release_region(pdev, 0);
 err_pci_disable:
 	pci_disable_device(pdev);
-err_free_ctx:
-	vb2_dma_contig_cleanup_ctx(pd->alloc_ctx);
 err_v4l2_dev_unreg:
 	v4l2_device_unregister(&pd->v4l2_dev);
 	return err;
@@ -608,7 +600,6 @@ static void dt3155_remove(struct pci_dev *pdev)
 	pci_iounmap(pdev, pd->regs);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
-	vb2_dma_contig_cleanup_ctx(pd->alloc_ctx);
 }
 
 static const struct pci_device_id pci_ids[] = {
diff --git a/drivers/media/pci/dt3155/dt3155.h b/drivers/media/pci/dt3155/dt3155.h
index b3531e0..39442e5 100644
--- a/drivers/media/pci/dt3155/dt3155.h
+++ b/drivers/media/pci/dt3155/dt3155.h
@@ -161,7 +161,6 @@
  * @vdev:		video_device structure
  * @pdev:		pointer to pci_dev structure
  * @vidq:		vb2_queue structure
- * @alloc_ctx:		dma_contig allocation context
  * @curr_buf:		pointer to curren buffer
  * @mux:		mutex to protect the instance
  * @dmaq:		queue for dma buffers
@@ -181,7 +180,6 @@ struct dt3155_priv {
 	struct video_device vdev;
 	struct pci_dev *pdev;
 	struct vb2_queue vidq;
-	struct vb2_alloc_ctx *alloc_ctx;
 	struct vb2_v4l2_buffer *curr_buf;
 	struct mutex mux;
 	struct list_head dmaq;
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index c0e1780..ffb66a9 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -1164,18 +1164,13 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	saa7134_board_init1(dev);
 	saa7134_hwinit1(dev);
 
-	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		err = PTR_ERR(dev->alloc_ctx);
-		goto fail3;
-	}
 	/* get irq */
 	err = request_irq(pci_dev->irq, saa7134_irq,
 			  IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
 		pr_err("%s: can't get IRQ %d\n",
 		       dev->name,pci_dev->irq);
-		goto fail4;
+		goto fail3;
 	}
 
 	/* wait a bit, register i2c bus */
@@ -1233,7 +1228,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	if (err < 0) {
 		pr_info("%s: can't register video device\n",
 		       dev->name);
-		goto fail5;
+		goto fail4;
 	}
 	pr_info("%s: registered device %s [v4l2]\n",
 	       dev->name, video_device_node_name(dev->video_dev));
@@ -1246,7 +1241,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	err = video_register_device(dev->vbi_dev,VFL_TYPE_VBI,
 				    vbi_nr[dev->nr]);
 	if (err < 0)
-		goto fail5;
+		goto fail4;
 	pr_info("%s: registered device %s\n",
 	       dev->name, video_device_node_name(dev->vbi_dev));
 
@@ -1257,7 +1252,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 		err = video_register_device(dev->radio_dev,VFL_TYPE_RADIO,
 					    radio_nr[dev->nr]);
 		if (err < 0)
-			goto fail5;
+			goto fail4;
 		pr_info("%s: registered device %s\n",
 		       dev->name, video_device_node_name(dev->radio_dev));
 	}
@@ -1268,7 +1263,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	err = v4l2_mc_create_media_graph(dev->media_dev);
 	if (err) {
 		pr_err("failed to create media graph\n");
-		goto fail5;
+		goto fail4;
 	}
 #endif
 	/* everything worked */
@@ -1287,17 +1282,15 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	err = media_device_register(dev->media_dev);
 	if (err)
-		goto fail5;
+		goto fail4;
 #endif
 
 	return 0;
 
- fail5:
+ fail4:
 	saa7134_unregister_video(dev);
 	saa7134_i2c_unregister(dev);
 	free_irq(pci_dev->irq, dev);
- fail4:
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
  fail3:
 	saa7134_hwfini(dev);
 	iounmap(dev->lmmio);
@@ -1367,7 +1360,6 @@ static void saa7134_finidev(struct pci_dev *pci_dev)
 
 	/* release resources */
 	free_irq(pci_dev->irq, dev);
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	iounmap(dev->lmmio);
 	release_mem_region(pci_resource_start(pci_dev,0),
 			   pci_resource_len(pci_dev,0));
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 0584a2a..8c68a93 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -131,7 +131,6 @@ int saa7134_ts_queue_setup(struct vb2_queue *q,
 		*nbuffers = 3;
 	*nplanes = 1;
 	sizes[0] = size;
-	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(saa7134_ts_queue_setup);
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index e76da37..e9bffb3 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -155,7 +155,6 @@ static int queue_setup(struct vb2_queue *q,
 	*nbuffers = saa7134_buffer_count(size, *nbuffers);
 	*nplanes = 1;
 	sizes[0] = size;
-	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index ffa3954..965ade7 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -980,7 +980,6 @@ static int queue_setup(struct vb2_queue *q,
 	*nbuffers = saa7134_buffer_count(size, *nbuffers);
 	*nplanes = 1;
 	sizes[0] = size;
-	alloc_ctxs[0] = dev->alloc_ctx;
 
 	saa7134_enable_analog_tuner(dev);
 
@@ -2173,6 +2172,7 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	q->buf_struct_size = sizeof(struct saa7134_buf);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &dev->lock;
+	q->dev = &dev->pci->dev;
 	ret = vb2_queue_init(q);
 	if (ret)
 		return ret;
@@ -2191,6 +2191,7 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	q->buf_struct_size = sizeof(struct saa7134_buf);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &dev->lock;
+	q->dev = &dev->pci->dev;
 	ret = vb2_queue_init(q);
 	if (ret)
 		return ret;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 69a9bbf..41c0158 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -610,7 +610,6 @@ struct saa7134_dev {
 
 
 	/* video+ts+vbi capture */
-	void			   *alloc_ctx;
 	struct saa7134_dmaqueue    video_q;
 	struct vb2_queue           video_vbq;
 	struct saa7134_dmaqueue    vbi_q;
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 67a14c4..f48ef33 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -666,10 +666,7 @@ static int solo_enc_queue_setup(struct vb2_queue *q,
 				unsigned int *num_planes, unsigned int sizes[],
 				void *alloc_ctxs[])
 {
-	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(q);
-
 	sizes[0] = FRAME_BUF_SIZE;
-	alloc_ctxs[0] = solo_enc->alloc_ctx;
 	*num_planes = 1;
 
 	if (*num_buffers < MIN_VID_BUFFERS)
@@ -1239,11 +1236,6 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 		return ERR_PTR(-ENOMEM);
 
 	hdl = &solo_enc->hdl;
-	solo_enc->alloc_ctx = vb2_dma_sg_init_ctx(&solo_dev->pdev->dev);
-	if (IS_ERR(solo_enc->alloc_ctx)) {
-		ret = PTR_ERR(solo_enc->alloc_ctx);
-		goto hdl_free;
-	}
 	v4l2_ctrl_handler_init(hdl, 10);
 	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
 			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
@@ -1299,6 +1291,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	solo_enc->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	solo_enc->vidq.buf_struct_size = sizeof(struct solo_vb2_buf);
 	solo_enc->vidq.lock = &solo_enc->lock;
+	solo_enc->vidq.dev = &solo_dev->pdev->dev;
 	ret = vb2_queue_init(&solo_enc->vidq);
 	if (ret)
 		goto hdl_free;
@@ -1347,7 +1340,6 @@ pci_free:
 			solo_enc->desc_items, solo_enc->desc_dma);
 hdl_free:
 	v4l2_ctrl_handler_free(hdl);
-	vb2_dma_sg_cleanup_ctx(solo_enc->alloc_ctx);
 	kfree(solo_enc);
 	return ERR_PTR(ret);
 }
@@ -1362,7 +1354,6 @@ static void solo_enc_free(struct solo_enc_dev *solo_enc)
 			solo_enc->desc_items, solo_enc->desc_dma);
 	video_unregister_device(solo_enc->vfd);
 	v4l2_ctrl_handler_free(&solo_enc->hdl);
-	vb2_dma_sg_cleanup_ctx(solo_enc->alloc_ctx);
 	kfree(solo_enc);
 }
 
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 721ff53..56affad 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -320,7 +320,6 @@ static int solo_queue_setup(struct vb2_queue *q,
 	struct solo_dev *solo_dev = vb2_get_drv_priv(q);
 
 	sizes[0] = solo_image_size(solo_dev);
-	alloc_ctxs[0] = solo_dev->alloc_ctx;
 	*num_planes = 1;
 
 	if (*num_buffers < MIN_VID_BUFFERS)
@@ -681,16 +680,11 @@ int solo_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
 	solo_dev->vidq.gfp_flags = __GFP_DMA32 | __GFP_KSWAPD_RECLAIM;
 	solo_dev->vidq.buf_struct_size = sizeof(struct solo_vb2_buf);
 	solo_dev->vidq.lock = &solo_dev->lock;
+	solo_dev->vidq.dev = &solo_dev->pdev->dev;
 	ret = vb2_queue_init(&solo_dev->vidq);
 	if (ret < 0)
 		goto fail;
 
-	solo_dev->alloc_ctx = vb2_dma_contig_init_ctx(&solo_dev->pdev->dev);
-	if (IS_ERR(solo_dev->alloc_ctx)) {
-		dev_err(&solo_dev->pdev->dev, "Can't allocate buffer context");
-		return PTR_ERR(solo_dev->alloc_ctx);
-	}
-
 	/* Cycle all the channels and clear */
 	for (i = 0; i < solo_dev->nr_chans; i++) {
 		solo_v4l2_set_ch(solo_dev, i);
@@ -718,7 +712,6 @@ int solo_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
 
 fail:
 	video_device_release(solo_dev->vfd);
-	vb2_dma_contig_cleanup_ctx(solo_dev->alloc_ctx);
 	v4l2_ctrl_handler_free(&solo_dev->disp_hdl);
 	solo_dev->vfd = NULL;
 	return ret;
@@ -730,7 +723,6 @@ void solo_v4l2_exit(struct solo_dev *solo_dev)
 		return;
 
 	video_unregister_device(solo_dev->vfd);
-	vb2_dma_contig_cleanup_ctx(solo_dev->alloc_ctx);
 	v4l2_ctrl_handler_free(&solo_dev->disp_hdl);
 	solo_dev->vfd = NULL;
 }
diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
index 4ab6586..5bd4987 100644
--- a/drivers/media/pci/solo6x10/solo6x10.h
+++ b/drivers/media/pci/solo6x10/solo6x10.h
@@ -178,7 +178,6 @@ struct solo_enc_dev {
 	u32			sequence;
 	struct vb2_queue	vidq;
 	struct list_head	vidq_active;
-	void			*alloc_ctx;
 	int			desc_count;
 	int			desc_nelts;
 	struct solo_p2m_desc	*desc_items;
@@ -269,7 +268,6 @@ struct solo_dev {
 
 	/* Buffer handling */
 	struct vb2_queue	vidq;
-	struct vb2_alloc_ctx	*alloc_ctx;
 	u32			sequence;
 	struct task_struct      *kthread;
 	struct mutex		lock;
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 753411c..7f201c3 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -111,7 +111,6 @@ static inline struct vip_buffer *to_vip_buffer(struct vb2_v4l2_buffer *vb2)
  * @input: input line for video signal ( 0 or 1 )
  * @disabled: Device is in power down state
  * @slock: for excluse acces of registers
- * @alloc_ctx: context for videobuf2
  * @vb_vidq: queue maintained by videobuf2 layer
  * @buffer_list: list of buffer in use
  * @sequence: sequence number of acquired buffer
@@ -141,7 +140,6 @@ struct sta2x11_vip {
 	int disabled;
 	spinlock_t slock;
 
-	struct vb2_alloc_ctx *alloc_ctx;
 	struct vb2_queue vb_vidq;
 	struct list_head buffer_list;
 	unsigned int sequence;
@@ -276,7 +274,6 @@ static int queue_setup(struct vb2_queue *vq,
 
 	*nplanes = 1;
 	sizes[0] = vip->format.sizeimage;
-	alloc_ctxs[0] = vip->alloc_ctx;
 
 	vip->sequence = 0;
 	vip->active = NULL;
@@ -869,25 +866,15 @@ static int sta2x11_vip_init_buffer(struct sta2x11_vip *vip)
 	vip->vb_vidq.ops = &vip_video_qops;
 	vip->vb_vidq.mem_ops = &vb2_dma_contig_memops;
 	vip->vb_vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	vip->vb_vidq.dev = &vip->pdev->dev;
 	err = vb2_queue_init(&vip->vb_vidq);
 	if (err)
 		return err;
 	INIT_LIST_HEAD(&vip->buffer_list);
 	spin_lock_init(&vip->lock);
-
-
-	vip->alloc_ctx = vb2_dma_contig_init_ctx(&vip->pdev->dev);
-	if (IS_ERR(vip->alloc_ctx)) {
-		v4l2_err(&vip->v4l2_dev, "Can't allocate buffer context");
-		return PTR_ERR(vip->alloc_ctx);
-	}
-
 	return 0;
 }
-static void sta2x11_vip_release_buffer(struct sta2x11_vip *vip)
-{
-	vb2_dma_contig_cleanup_ctx(vip->alloc_ctx);
-}
+
 static int sta2x11_vip_init_controls(struct sta2x11_vip *vip)
 {
 	/*
@@ -1128,7 +1115,6 @@ vrelease:
 	video_unregister_device(&vip->video_dev);
 	free_irq(pdev->irq, vip);
 release_buf:
-	sta2x11_vip_release_buffer(vip);
 	pci_disable_msi(pdev);
 unmap:
 	vb2_queue_release(&vip->vb_vidq);
diff --git a/drivers/media/pci/tw68/tw68-core.c b/drivers/media/pci/tw68/tw68-core.c
index 4e77618..8474528 100644
--- a/drivers/media/pci/tw68/tw68-core.c
+++ b/drivers/media/pci/tw68/tw68-core.c
@@ -305,19 +305,13 @@ static int tw68_initdev(struct pci_dev *pci_dev,
 	/* Then do any initialisation wanted before interrupts are on */
 	tw68_hw_init1(dev);
 
-	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		err = PTR_ERR(dev->alloc_ctx);
-		goto fail3;
-	}
-
 	/* get irq */
 	err = devm_request_irq(&pci_dev->dev, pci_dev->irq, tw68_irq,
 			  IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
 		pr_err("%s: can't get IRQ %d\n",
 		       dev->name, pci_dev->irq);
-		goto fail4;
+		goto fail3;
 	}
 
 	/*
@@ -331,7 +325,7 @@ static int tw68_initdev(struct pci_dev *pci_dev,
 	if (err < 0) {
 		pr_err("%s: can't register video device\n",
 		       dev->name);
-		goto fail5;
+		goto fail4;
 	}
 	tw_setl(TW68_INTMASK, dev->pci_irqmask);
 
@@ -340,10 +334,8 @@ static int tw68_initdev(struct pci_dev *pci_dev,
 
 	return 0;
 
-fail5:
-	video_unregister_device(&dev->vdev);
 fail4:
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
+	video_unregister_device(&dev->vdev);
 fail3:
 	iounmap(dev->lmmio);
 fail2:
@@ -367,7 +359,6 @@ static void tw68_finidev(struct pci_dev *pci_dev)
 	/* unregister */
 	video_unregister_device(&dev->vdev);
 	v4l2_ctrl_handler_free(&dev->hdl);
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 
 	/* release resources */
 	iounmap(dev->lmmio);
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 07116a8..c675f9a 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -388,7 +388,6 @@ static int tw68_queue_setup(struct vb2_queue *q,
 		tot_bufs = 2;
 	tot_bufs = tw68_buffer_count(size, tot_bufs);
 	*num_buffers = tot_bufs - q->num_buffers;
-	alloc_ctxs[0] = dev->alloc_ctx;
 	/*
 	 * We allow create_bufs, but only if the sizeimage is >= as the
 	 * current sizeimage. The tw68_buffer_count calculation becomes quite
@@ -983,6 +982,7 @@ int tw68_video_init2(struct tw68_dev *dev, int video_nr)
 	dev->vidq.buf_struct_size = sizeof(struct tw68_buf);
 	dev->vidq.lock = &dev->lock;
 	dev->vidq.min_buffers_needed = 2;
+	dev->vidq.dev = &dev->pci->dev;
 	ret = vb2_queue_init(&dev->vidq);
 	if (ret)
 		return ret;
diff --git a/drivers/media/pci/tw68/tw68.h b/drivers/media/pci/tw68/tw68.h
index 6c7dcb3..5585c7e 100644
--- a/drivers/media/pci/tw68/tw68.h
+++ b/drivers/media/pci/tw68/tw68.h
@@ -165,7 +165,6 @@ struct tw68_dev {
 	unsigned		field;
 	struct vb2_queue	vidq;
 	struct list_head	active;
-	void			*alloc_ctx;
 
 	/* various v4l controls */
 	const struct tw68_tvnorm *tvnorm;	/* video */
diff --git a/drivers/staging/media/tw686x-kh/tw686x-kh-video.c b/drivers/staging/media/tw686x-kh/tw686x-kh-video.c
index 6ecb504..4e2ef9d 100644
--- a/drivers/staging/media/tw686x-kh/tw686x-kh-video.c
+++ b/drivers/staging/media/tw686x-kh/tw686x-kh-video.c
@@ -135,7 +135,6 @@ static int tw686x_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 	struct tw686x_video_channel *vc = vb2_get_drv_priv(vq);
 	unsigned int size = vc->width * vc->height * vc->format->depth / 8;
 
-	alloc_ctxs[0] = vc->alloc_ctx;
 	if (*nbuffers < 2)
 		*nbuffers = 2;
 
@@ -645,7 +644,6 @@ void tw686x_kh_video_free(struct tw686x_dev *dev)
 		v4l2_ctrl_handler_free(&vc->ctrl_handler);
 		if (vc->device)
 			video_unregister_device(vc->device);
-		vb2_dma_sg_cleanup_ctx(vc->alloc_ctx);
 		for (n = 0; n < 2; n++) {
 			struct dma_desc *descs = &vc->sg_tables[n];
 
@@ -750,13 +748,6 @@ int tw686x_kh_video_init(struct tw686x_dev *dev)
 			goto error;
 		}
 
-		vc->alloc_ctx = vb2_dma_sg_init_ctx(&dev->pci_dev->dev);
-		if (IS_ERR(vc->alloc_ctx)) {
-			pr_warn("Unable to initialize DMA scatter-gather context\n");
-			err = PTR_ERR(vc->alloc_ctx);
-			goto error;
-		}
-
 		vc->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		vc->vidq.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 		vc->vidq.drv_priv = vc;
@@ -766,6 +757,7 @@ int tw686x_kh_video_init(struct tw686x_dev *dev)
 		vc->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		vc->vidq.min_buffers_needed = 2;
 		vc->vidq.lock = &vc->vb_mutex;
+		vc->vidq.dev = &dev->pci_dev->dev;
 		vc->vidq.gfp_flags = GFP_DMA32;
 
 		err = vb2_queue_init(&vc->vidq);
diff --git a/drivers/staging/media/tw686x-kh/tw686x-kh.h b/drivers/staging/media/tw686x-kh/tw686x-kh.h
index dc25796..6284a90 100644
--- a/drivers/staging/media/tw686x-kh/tw686x-kh.h
+++ b/drivers/staging/media/tw686x-kh/tw686x-kh.h
@@ -56,7 +56,6 @@ struct tw686x_video_channel {
 	struct video_device *device;
 	struct dma_desc sg_tables[2];
 	struct tw686x_vb2_buf *curr_bufs[2];
-	void *alloc_ctx;
 	struct vdma_desc *sg_descs[2];
 
 	struct v4l2_ctrl_handler ctrl_handler;
-- 
2.8.0.rc3

