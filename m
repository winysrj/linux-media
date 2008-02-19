Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1JCfR9p018060
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 07:41:27 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1JCeoiS010316
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 07:40:50 -0500
Date: Tue, 19 Feb 2008 13:40:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0802191317370.6077@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Convert videobuf-dma-sg to generic DMA API
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

videobuf-dma-sg does not need to depend on PCI. Switch it to using generic 
DMA API, convert all affected drivers, relax Kconfig restriction, improve 
compile-time type checking, fix some Coding Style violations while at it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de

---

I also changed the type of the dev pointer in struct videobuf_queue from 
void* to struct device*, and changed the declaration of 
videobuf_queue_{pci,sg}_init() to explicitly require a struct device*. I 
haven't changed declarations of videobuf_queue_core_init() and 
videobuf_queue_vmalloc_init(), since there the dev pointer is basically 
not used until now, AFAICS, so, I wasn't sure what it was planned for. 
Maybe the _core_ variant could also have a struct device* type, and the 
_vmalloc_ (only used by the virtual vivi.c for now) could drop that 
parameter altogether? And sorry, couldn't help fixing some spaces. If 
possible, just pull it through, would cost me another hour or two to split 
it:-)

Thanks
Guennadi

diff --git a/drivers/media/common/saa7146_vbi.c b/drivers/media/common/saa7146_vbi.c
index bfbd5a8..74e2b56 100644
--- a/drivers/media/common/saa7146_vbi.c
+++ b/drivers/media/common/saa7146_vbi.c
@@ -407,8 +407,8 @@ static int vbi_open(struct saa7146_dev *dev, struct file *file)
 	fh->vbi_fmt.start[1] = 312;
 	fh->vbi_fmt.count[1] = 16;
 
-	videobuf_queue_pci_init(&fh->vbi_q, &vbi_qops,
-			    dev->pci, &dev->slock,
+	videobuf_queue_sg_init(&fh->vbi_q, &vbi_qops,
+			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VBI_CAPTURE,
 			    V4L2_FIELD_SEQ_TB, // FIXME: does this really work?
 			    sizeof(struct saa7146_buf),
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index 66fdbd0..3cbc6eb 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -1410,8 +1410,8 @@ static int video_open(struct saa7146_dev *dev, struct file *file)
 	sfmt = format_by_fourcc(dev,fh->video_fmt.pixelformat);
 	fh->video_fmt.sizeimage = (fh->video_fmt.width * fh->video_fmt.height * sfmt->depth)/8;
 
-	videobuf_queue_pci_init(&fh->video_q, &video_qops,
-			    dev->pci, &dev->slock,
+	videobuf_queue_sg_init(&fh->video_q, &video_qops,
+			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct saa7146_buf),
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 5404fcc..5e5158e 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -2371,7 +2371,7 @@ static int setup_window(struct bttv_fh *fh, struct bttv *btv,
 	if (check_btres(fh, RESOURCE_OVERLAY)) {
 		struct bttv_buffer *new;
 
-		new = videobuf_pci_alloc(sizeof(*new));
+		new = videobuf_sg_alloc(sizeof(*new));
 		new->crop = btv->crop[!!fh->do_crop].rect;
 		bttv_overlay_risc(btv, &fh->ov, fh->ovfmt, new);
 		retval = bttv_switch_overlay(btv,fh,new);
@@ -2759,7 +2759,7 @@ static int bttv_overlay(struct file *file, void *f, unsigned int on)
 	mutex_lock(&fh->cap.vb_lock);
 	if (on) {
 		fh->ov.tvnorm = btv->tvnorm;
-		new = videobuf_pci_alloc(sizeof(*new));
+		new = videobuf_sg_alloc(sizeof(*new));
 		new->crop = btv->crop[!!fh->do_crop].rect;
 		bttv_overlay_risc(btv, &fh->ov, fh->ovfmt, new);
 	} else {
@@ -2833,7 +2833,7 @@ static int bttv_s_fbuf(struct file *file, void *f,
 		if (check_btres(fh, RESOURCE_OVERLAY)) {
 			struct bttv_buffer *new;
 
-			new = videobuf_pci_alloc(sizeof(*new));
+			new = videobuf_sg_alloc(sizeof(*new));
 			new->crop = btv->crop[!!fh->do_crop].rect;
 			bttv_overlay_risc(btv, &fh->ov, fh->ovfmt, new);
 			retval = bttv_switch_overlay(btv, fh, new);
@@ -3183,7 +3183,7 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
 			/* need to capture a new frame */
 			if (locked_btres(fh->btv,RESOURCE_VIDEO_STREAM))
 				goto err;
-			fh->cap.read_buf = videobuf_pci_alloc(fh->cap.msize);
+			fh->cap.read_buf = videobuf_sg_alloc(fh->cap.msize);
 			if (NULL == fh->cap.read_buf)
 				goto err;
 			fh->cap.read_buf->memory = V4L2_MEMORY_USERPTR;
@@ -3250,14 +3250,14 @@ static int bttv_open(struct inode *inode, struct file *file)
 	fh->ov.setup_ok = 0;
 	v4l2_prio_open(&btv->prio,&fh->prio);
 
-	videobuf_queue_pci_init(&fh->cap, &bttv_video_qops,
-			    btv->c.pci, &btv->s_lock,
+	videobuf_queue_sg_init(&fh->cap, &bttv_video_qops,
+			    &btv->c.pci->dev, &btv->s_lock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct bttv_buffer),
 			    fh);
-	videobuf_queue_pci_init(&fh->vbi, &bttv_vbi_qops,
-			    btv->c.pci, &btv->s_lock,
+	videobuf_queue_sg_init(&fh->vbi, &bttv_vbi_qops,
+			    &btv->c.pci->dev, &btv->s_lock,
 			    V4L2_BUF_TYPE_VBI_CAPTURE,
 			    V4L2_FIELD_SEQ_TB,
 			    sizeof(struct bttv_buffer),
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index ed465c0..6c21779 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -349,7 +349,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
 
 	/* dvb stuff */
 	printk("%s: cx23885 based dvb card\n", dev->name);
-	videobuf_queue_pci_init(&port->dvb.dvbq, &dvb_qops, dev->pci, &port->slock,
+	videobuf_queue_sg_init(&port->dvb.dvbq, &dvb_qops, &dev->pci->dev, &port->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_TOP,
 			    sizeof(struct cx23885_buffer), port);
 	err = dvb_register(port);
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index d3c4d2c..45bf214 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -765,8 +765,8 @@ static int video_open(struct inode *inode, struct file *file)
 	fh->height   = 240;
 	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 
-	videobuf_queue_pci_init(&fh->vidq, &cx23885_video_qops,
-			    dev->pci, &dev->slock,
+	videobuf_queue_sg_init(&fh->vidq, &cx23885_video_qops,
+			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct cx23885_buffer),
diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 316b106..2f5a4a4 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -283,7 +283,7 @@ static int dsp_buffer_free(snd_cx88_card_t *chip)
 	BUG_ON(!chip->dma_size);
 
 	dprintk(2,"Freeing buffer\n");
-	videobuf_pci_dma_unmap(chip->pci, chip->dma_risc);
+	videobuf_sg_dma_unmap(&chip->pci->dev, chip->dma_risc);
 	videobuf_dma_free(chip->dma_risc);
 	btcx_riscmem_free(chip->pci,&chip->buf->risc);
 	kfree(chip->buf);
@@ -385,7 +385,7 @@ static int snd_cx88_hw_params(struct snd_pcm_substream * substream,
 	BUG_ON(!chip->dma_size);
 	BUG_ON(chip->num_periods & (chip->num_periods-1));
 
-	buf = videobuf_pci_alloc(sizeof(*buf));
+	buf = videobuf_sg_alloc(sizeof(*buf));
 	if (NULL == buf)
 		return -ENOMEM;
 
@@ -396,14 +396,14 @@ static int snd_cx88_hw_params(struct snd_pcm_substream * substream,
 	buf->vb.height = chip->num_periods;
 	buf->vb.size   = chip->dma_size;
 
-	dma=videobuf_to_dma(&buf->vb);
+	dma = videobuf_to_dma(&buf->vb);
 	videobuf_dma_init(dma);
 	ret = videobuf_dma_init_kernel(dma, PCI_DMA_FROMDEVICE,
 			(PAGE_ALIGN(buf->vb.size) >> PAGE_SHIFT));
 	if (ret < 0)
 		goto error;
 
-	ret = videobuf_pci_dma_map(chip->pci,dma);
+	ret = videobuf_sg_dma_map(&chip->pci->dev, dma);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index c372690..d582395 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -1087,8 +1087,8 @@ static int mpeg_open(struct inode *inode, struct file *file)
 	file->private_data = fh;
 	fh->dev      = dev;
 
-	videobuf_queue_pci_init(&fh->mpegq, &blackbird_qops,
-			    dev->pci, &dev->slock,
+	videobuf_queue_sg_init(&fh->mpegq, &blackbird_qops,
+			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct cx88_buffer),
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index 7586fe3..fa21666 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -744,8 +744,8 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 
 	/* dvb stuff */
 	printk(KERN_INFO "%s/2: cx2388x based DVB/ATSC card\n", core->name);
-	videobuf_queue_pci_init(&dev->dvb.dvbq, &dvb_qops,
-			    dev->pci, &dev->slock,
+	videobuf_queue_sg_init(&dev->dvb.dvbq, &dvb_qops,
+			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_TOP,
 			    sizeof(struct cx88_buffer),
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 4f79dcd..9a8d61d 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -776,14 +776,14 @@ static int video_open(struct inode *inode, struct file *file)
 	fh->height   = 240;
 	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 
-	videobuf_queue_pci_init(&fh->vidq, &cx8800_video_qops,
-			    dev->pci, &dev->slock,
+	videobuf_queue_sg_init(&fh->vidq, &cx8800_video_qops,
+			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct cx88_buffer),
 			    fh);
-	videobuf_queue_pci_init(&fh->vbiq, &cx8800_vbi_qops,
-			    dev->pci, &dev->slock,
+	videobuf_queue_sg_init(&fh->vbiq, &cx8800_vbi_qops,
+			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VBI_CAPTURE,
 			    V4L2_FIELD_SEQ_TB,
 			    sizeof(struct cx88_buffer),
diff --git a/drivers/media/video/saa7134/saa7134-alsa.c b/drivers/media/video/saa7134/saa7134-alsa.c
index 505bc0a..048081b 100644
--- a/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/drivers/media/video/saa7134/saa7134-alsa.c
@@ -503,7 +503,7 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
 	/* release the old buffer */
 	if (substream->runtime->dma_area) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
-		videobuf_pci_dma_unmap(dev->pci, &dev->dmasound.dma);
+		videobuf_sg_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
 		dsp_buffer_free(dev);
 		substream->runtime->dma_area = NULL;
 	}
@@ -519,12 +519,12 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
 		return err;
 	}
 
-	if (0 != (err = videobuf_pci_dma_map(dev->pci, &dev->dmasound.dma))) {
+	if (0 != (err = videobuf_sg_dma_map(&dev->pci->dev, &dev->dmasound.dma))) {
 		dsp_buffer_free(dev);
 		return err;
 	}
 	if (0 != (err = saa7134_pgtable_alloc(dev->pci,&dev->dmasound.pt))) {
-		videobuf_pci_dma_unmap(dev->pci, &dev->dmasound.dma);
+		videobuf_sg_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
 		dsp_buffer_free(dev);
 		return err;
 	}
@@ -533,7 +533,7 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
 						dev->dmasound.dma.sglen,
 						0))) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
-		videobuf_pci_dma_unmap(dev->pci, &dev->dmasound.dma);
+		videobuf_sg_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
 		dsp_buffer_free(dev);
 		return err;
 	}
@@ -569,7 +569,7 @@ static int snd_card_saa7134_hw_free(struct snd_pcm_substream * substream)
 
 	if (substream->runtime->dma_area) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
-		videobuf_pci_dma_unmap(dev->pci, &dev->dmasound.dma);
+		videobuf_sg_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
 		dsp_buffer_free(dev);
 		substream->runtime->dma_area = NULL;
 	}
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index b55df48..eabc67d 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -899,8 +899,8 @@ static int dvb_init(struct saa7134_dev *dev)
 	dev->ts.nr_bufs    = 32;
 	dev->ts.nr_packets = 32*4;
 	dev->dvb.name = dev->name;
-	videobuf_queue_pci_init(&dev->dvb.dvbq, &saa7134_ts_qops,
-			    dev->pci, &dev->slock,
+	videobuf_queue_sg_init(&dev->dvb.dvbq, &saa7134_ts_qops,
+			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_ALTERNATE,
 			    sizeof(struct saa7134_buf),
diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/video/saa7134/saa7134-empress.c
index 40d4a66..e002be5 100644
--- a/drivers/media/video/saa7134/saa7134-empress.c
+++ b/drivers/media/video/saa7134/saa7134-empress.c
@@ -427,8 +427,8 @@ static int empress_init(struct saa7134_dev *dev)
 	printk(KERN_INFO "%s: registered device video%d [mpeg]\n",
 	       dev->name,dev->empress_dev->minor & 0x1f);
 
-	videobuf_queue_pci_init(&dev->empress_tsq, &saa7134_ts_qops,
-			    dev->pci, &dev->slock,
+	videobuf_queue_sg_init(&dev->empress_tsq, &saa7134_ts_qops,
+			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_ALTERNATE,
 			    sizeof(struct saa7134_buf),
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 5385026..ecc5243 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -1350,14 +1350,14 @@ static int video_open(struct inode *inode, struct file *file)
 	fh->height   = 576;
 	v4l2_prio_open(&dev->prio,&fh->prio);
 
-	videobuf_queue_pci_init(&fh->cap, &video_qops,
-			    dev->pci, &dev->slock,
+	videobuf_queue_sg_init(&fh->cap, &video_qops,
+			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct saa7134_buf),
 			    fh);
-	videobuf_queue_pci_init(&fh->vbi, &saa7134_vbi_qops,
-			    dev->pci, &dev->slock,
+	videobuf_queue_sg_init(&fh->vbi, &saa7134_vbi_qops,
+			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VBI_CAPTURE,
 			    V4L2_FIELD_SEQ_TB,
 			    sizeof(struct saa7134_buf),
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 904e9df..c947525 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -210,7 +210,7 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 
 	/* We must pass NULL as dev pointer, then all pci_* dma operations
 	 * transform to normal dma_* ones. Do we need an irqlock? */
-	videobuf_queue_pci_init(&icf->vb_vidq, ici->vbq_ops, NULL, NULL,
+	videobuf_queue_sg_init(&icf->vb_vidq, ici->vbq_ops, NULL, NULL,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
 				ici->msize, icd);
 
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 7008afa..f69a91f 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -1,5 +1,5 @@
 /*
- * helper functions for PCI DMA video4linux capture buffers
+ * helper functions for SG DMA video4linux capture buffers
  *
  * The functions expect the hardware being able to scatter gatter
  * (i.e. the buffers are not linear in physical memory, but fragmented
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 
-#include <linux/pci.h>
+#include <linux/dma-mapping.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <linux/scatterlist.h>
@@ -42,7 +42,7 @@
 static int debug;
 module_param(debug, int, 0644);
 
-MODULE_DESCRIPTION("helper module to manage video4linux pci dma sg buffers");
+MODULE_DESCRIPTION("helper module to manage video4linux dma sg buffers");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
 MODULE_LICENSE("GPL");
 
@@ -119,10 +119,10 @@ videobuf_pages_to_sg(struct page **pages, int nr_pages, int offset)
 
 struct videobuf_dmabuf *videobuf_to_dma (struct videobuf_buffer *buf)
 {
-	struct videbuf_pci_sg_memory *mem=buf->priv;
-	BUG_ON (!mem);
+	struct videobuf_dma_sg_memory *mem = buf->priv;
+	BUG_ON(!mem);
 
-	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
+	MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
 
 	return &mem->dma;
 }
@@ -141,9 +141,14 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 
 	dma->direction = direction;
 	switch (dma->direction) {
-	case PCI_DMA_FROMDEVICE: rw = READ;  break;
-	case PCI_DMA_TODEVICE:   rw = WRITE; break;
-	default:                 BUG();
+	case DMA_FROM_DEVICE:
+		rw = READ;
+		break;
+	case DMA_TO_DEVICE:
+		rw = WRITE;
+		break;
+	default:
+		BUG();
 	}
 
 	first = (data          & PAGE_MASK) >> PAGE_SHIFT;
@@ -216,10 +221,8 @@ int videobuf_dma_init_overlay(struct videobuf_dmabuf *dma, int direction,
 	return 0;
 }
 
-int videobuf_dma_map(struct videobuf_queue* q,struct videobuf_dmabuf *dma)
+int videobuf_dma_map(struct videobuf_queue* q, struct videobuf_dmabuf *dma)
 {
-	void                   *dev=q->dev;
-
 	MAGIC_CHECK(dma->magic,MAGIC_DMABUF);
 	BUG_ON(0 == dma->nr_pages);
 
@@ -245,7 +248,7 @@ int videobuf_dma_map(struct videobuf_queue* q,struct videobuf_dmabuf *dma)
 		return -ENOMEM;
 	}
 	if (!dma->bus_addr) {
-		dma->sglen = pci_map_sg(dev,dma->sglist,
+		dma->sglen = dma_map_sg(q->dev, dma->sglist,
 					dma->nr_pages, dma->direction);
 		if (0 == dma->sglen) {
 			printk(KERN_WARNING
@@ -259,26 +262,22 @@ int videobuf_dma_map(struct videobuf_queue* q,struct videobuf_dmabuf *dma)
 	return 0;
 }
 
-int videobuf_dma_sync(struct videobuf_queue *q,struct videobuf_dmabuf *dma)
+int videobuf_dma_sync(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
 {
-	void                   *dev=q->dev;
-
-	MAGIC_CHECK(dma->magic,MAGIC_DMABUF);
+	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
 	BUG_ON(!dma->sglen);
 
-	pci_dma_sync_sg_for_cpu (dev,dma->sglist,dma->nr_pages,dma->direction);
+	dma_sync_sg_for_cpu(q->dev, dma->sglist, dma->nr_pages, dma->direction);
 	return 0;
 }
 
-int videobuf_dma_unmap(struct videobuf_queue* q,struct videobuf_dmabuf *dma)
+int videobuf_dma_unmap(struct videobuf_queue* q, struct videobuf_dmabuf *dma)
 {
-	void                   *dev=q->dev;
-
-	MAGIC_CHECK(dma->magic,MAGIC_DMABUF);
+	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
 	if (!dma->sglen)
 		return 0;
 
-	pci_unmap_sg (dev,dma->sglist,dma->nr_pages,dma->direction);
+	dma_unmap_sg(q->dev, dma->sglist, dma->nr_pages, dma->direction);
 
 	kfree(dma->sglist);
 	dma->sglist = NULL;
@@ -306,28 +305,28 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
 	if (dma->bus_addr) {
 		dma->bus_addr = 0;
 	}
-	dma->direction = PCI_DMA_NONE;
+	dma->direction = DMA_NONE;
 	return 0;
 }
 
 /* --------------------------------------------------------------------- */
 
-int videobuf_pci_dma_map(struct pci_dev *pci,struct videobuf_dmabuf *dma)
+int videobuf_sg_dma_map(struct device *dev, struct videobuf_dmabuf *dma)
 {
 	struct videobuf_queue q;
 
-	q.dev=pci;
+	q.dev = dev;
 
-	return (videobuf_dma_map(&q,dma));
+	return videobuf_dma_map(&q, dma);
 }
 
-int videobuf_pci_dma_unmap(struct pci_dev *pci,struct videobuf_dmabuf *dma)
+int videobuf_sg_dma_unmap(struct device *dev, struct videobuf_dmabuf *dma)
 {
 	struct videobuf_queue q;
 
-	q.dev=pci;
+	q.dev = dev;
 
-	return (videobuf_dma_unmap(&q,dma));
+	return videobuf_dma_unmap(&q, dma);
 }
 
 /* --------------------------------------------------------------------- */
@@ -347,7 +346,7 @@ videobuf_vm_close(struct vm_area_struct *vma)
 {
 	struct videobuf_mapping *map = vma->vm_private_data;
 	struct videobuf_queue *q = map->q;
-	struct videbuf_pci_sg_memory *mem;
+	struct videobuf_dma_sg_memory *mem;
 	int i;
 
 	dprintk(2,"vm_close %p [count=%d,vma=%08lx-%08lx]\n",map,
@@ -409,18 +408,18 @@ static struct vm_operations_struct videobuf_vm_ops =
 };
 
 /* ---------------------------------------------------------------------
- * PCI handlers for the generic methods
+ * SG handlers for the generic methods
  */
 
 /* Allocated area consists on 3 parts:
 	struct video_buffer
 	struct <driver>_buffer (cx88_buffer, saa7134_buf, ...)
-	struct videobuf_pci_sg_memory
+	struct videobuf_dma_sg_memory
  */
 
 static void *__videobuf_alloc(size_t size)
 {
-	struct videbuf_pci_sg_memory *mem;
+	struct videobuf_dma_sg_memory *mem;
 	struct videobuf_buffer *vb;
 
 	vb = kzalloc(size+sizeof(*mem),GFP_KERNEL);
@@ -443,10 +442,10 @@ static int __videobuf_iolock (struct videobuf_queue* q,
 {
 	int err,pages;
 	dma_addr_t bus;
-	struct videbuf_pci_sg_memory *mem=vb->priv;
+	struct videobuf_dma_sg_memory *mem = vb->priv;
 	BUG_ON(!mem);
 
-	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
+	MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
 
 	switch (vb->memory) {
 	case V4L2_MEMORY_MMAP:
@@ -455,14 +454,14 @@ static int __videobuf_iolock (struct videobuf_queue* q,
 			/* no userspace addr -- kernel bounce buffer */
 			pages = PAGE_ALIGN(vb->size) >> PAGE_SHIFT;
 			err = videobuf_dma_init_kernel( &mem->dma,
-							PCI_DMA_FROMDEVICE,
+							DMA_FROM_DEVICE,
 							pages );
 			if (0 != err)
 				return err;
 		} else if (vb->memory == V4L2_MEMORY_USERPTR) {
 			/* dma directly to userspace */
 			err = videobuf_dma_init_user( &mem->dma,
-						      PCI_DMA_FROMDEVICE,
+						      DMA_FROM_DEVICE,
 						      vb->baddr,vb->bsize );
 			if (0 != err)
 				return err;
@@ -473,7 +472,7 @@ static int __videobuf_iolock (struct videobuf_queue* q,
 			locking inversion, so don't take it here */
 
 			err = videobuf_dma_init_user_locked(&mem->dma,
-						      PCI_DMA_FROMDEVICE,
+						      DMA_FROM_DEVICE,
 						      vb->baddr, vb->bsize);
 			if (0 != err)
 				return err;
@@ -490,7 +489,7 @@ static int __videobuf_iolock (struct videobuf_queue* q,
 		 */
 		bus   = (dma_addr_t)(unsigned long)fbuf->base + vb->boff;
 		pages = PAGE_ALIGN(vb->size) >> PAGE_SHIFT;
-		err = videobuf_dma_init_overlay(&mem->dma,PCI_DMA_FROMDEVICE,
+		err = videobuf_dma_init_overlay(&mem->dma, DMA_FROM_DEVICE,
 						bus, pages);
 		if (0 != err)
 			return err;
@@ -498,7 +497,7 @@ static int __videobuf_iolock (struct videobuf_queue* q,
 	default:
 		BUG();
 	}
-	err = videobuf_dma_map(q,&mem->dma);
+	err = videobuf_dma_map(q, &mem->dma);
 	if (0 != err)
 		return err;
 
@@ -508,8 +507,8 @@ static int __videobuf_iolock (struct videobuf_queue* q,
 static int __videobuf_sync(struct videobuf_queue *q,
 			   struct videobuf_buffer *buf)
 {
-	struct videbuf_pci_sg_memory *mem=buf->priv;
-	BUG_ON (!mem);
+	struct videobuf_dma_sg_memory *mem = buf->priv;
+	BUG_ON(!mem);
 	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
 
 	return	videobuf_dma_sync(q,&mem->dma);
@@ -532,7 +531,7 @@ static int __videobuf_mmap_free(struct videobuf_queue *q)
 static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 			 struct vm_area_struct *vma)
 {
-	struct videbuf_pci_sg_memory *mem;
+	struct videobuf_dma_sg_memory *mem;
 	struct videobuf_mapping *map;
 	unsigned int first,last,size,i;
 	int retval;
@@ -552,7 +551,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 		if (NULL == q->bufs[first])
 			continue;
 		mem=q->bufs[first]->priv;
-		BUG_ON (!mem);
+		BUG_ON(!mem);
 		MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
 
 		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory)
@@ -615,8 +614,8 @@ static int __videobuf_copy_to_user ( struct videobuf_queue *q,
 				char __user *data, size_t count,
 				int nonblocking )
 {
-	struct videbuf_pci_sg_memory *mem=q->read_buf->priv;
-	BUG_ON (!mem);
+	struct videobuf_dma_sg_memory *mem = q->read_buf->priv;
+	BUG_ON(!mem);
 	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
 
 	/* copy to userspace */
@@ -634,8 +633,8 @@ static int __videobuf_copy_stream ( struct videobuf_queue *q,
 				int vbihack, int nonblocking )
 {
 	unsigned int  *fc;
-	struct videbuf_pci_sg_memory *mem=q->read_buf->priv;
-	BUG_ON (!mem);
+	struct videobuf_dma_sg_memory *mem = q->read_buf->priv;
+	BUG_ON(!mem);
 	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
 
 	if (vbihack) {
@@ -658,7 +657,7 @@ static int __videobuf_copy_stream ( struct videobuf_queue *q,
 	return count;
 }
 
-static struct videobuf_qtype_ops pci_ops = {
+static struct videobuf_qtype_ops sg_ops = {
 	.magic        = MAGIC_QTYPE_OPS,
 
 	.alloc        = __videobuf_alloc,
@@ -670,21 +669,21 @@ static struct videobuf_qtype_ops pci_ops = {
 	.copy_stream  = __videobuf_copy_stream,
 };
 
-void *videobuf_pci_alloc (size_t size)
+void *videobuf_sg_alloc(size_t size)
 {
 	struct videobuf_queue q;
 
 	/* Required to make generic handler to call __videobuf_alloc */
-	q.int_ops=&pci_ops;
+	q.int_ops = &sg_ops;
 
-	q.msize=size;
+	q.msize = size;
 
-	return videobuf_alloc (&q);
+	return videobuf_alloc(&q);
 }
 
-void videobuf_queue_pci_init(struct videobuf_queue* q,
+void videobuf_queue_sg_init(struct videobuf_queue* q,
 			 struct videobuf_queue_ops *ops,
-			 void *dev,
+			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
 			 enum v4l2_field field,
@@ -692,7 +691,7 @@ void videobuf_queue_pci_init(struct videobuf_queue* q,
 			 void *priv)
 {
 	videobuf_queue_core_init(q, ops, dev, irqlock, type, field, msize,
-				 priv, &pci_ops);
+				 priv, &sg_ops);
 }
 
 /* --------------------------------------------------------------------- */
@@ -709,11 +708,11 @@ EXPORT_SYMBOL_GPL(videobuf_dma_sync);
 EXPORT_SYMBOL_GPL(videobuf_dma_unmap);
 EXPORT_SYMBOL_GPL(videobuf_dma_free);
 
-EXPORT_SYMBOL_GPL(videobuf_pci_dma_map);
-EXPORT_SYMBOL_GPL(videobuf_pci_dma_unmap);
-EXPORT_SYMBOL_GPL(videobuf_pci_alloc);
+EXPORT_SYMBOL_GPL(videobuf_sg_dma_map);
+EXPORT_SYMBOL_GPL(videobuf_sg_dma_unmap);
+EXPORT_SYMBOL_GPL(videobuf_sg_alloc);
 
-EXPORT_SYMBOL_GPL(videobuf_queue_pci_init);
+EXPORT_SYMBOL_GPL(videobuf_queue_sg_init);
 
 /*
  * Local variables:
diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
index 3de3c89..4a2508d 100644
--- a/drivers/media/video/videobuf-vmalloc.c
+++ b/drivers/media/video/videobuf-vmalloc.c
@@ -102,7 +102,7 @@ static struct vm_operations_struct videobuf_vm_ops =
 /* Allocated area consists on 3 parts:
 	struct video_buffer
 	struct <driver>_buffer (cx88_buffer, saa7134_buf, ...)
-	struct videobuf_pci_sg_memory
+	struct videobuf_dma_sg_memory
  */
 
 static void *__videobuf_alloc(size_t size)
diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
index 9903394..2fc03aa 100644
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -149,32 +149,32 @@ struct videobuf_qtype_ops {
 };
 
 struct videobuf_queue {
-	struct mutex               vb_lock;
-	spinlock_t                 *irqlock;
-	void			   *dev; /* on pci, points to struct pci_dev */
-
-	enum v4l2_buf_type         type;
-	unsigned int               inputs; /* for V4L2_BUF_FLAG_INPUT */
-	unsigned int               msize;
-	enum v4l2_field            field;
-	enum v4l2_field            last;   /* for field=V4L2_FIELD_ALTERNATE */
+	struct mutex		   vb_lock;
+	spinlock_t		   *irqlock;
+	struct device		   *dev;
+
+	enum v4l2_buf_type	   type;
+	unsigned int		   inputs; /* for V4L2_BUF_FLAG_INPUT */
+	unsigned int		   msize;
+	enum v4l2_field		   field;
+	enum v4l2_field		   last;   /* for field=V4L2_FIELD_ALTERNATE */
 	struct videobuf_buffer     *bufs[VIDEO_MAX_FRAME];
 	struct videobuf_queue_ops  *ops;
 	struct videobuf_qtype_ops  *int_ops;
 
-	unsigned int               streaming:1;
-	unsigned int               reading:1;
+	unsigned int		   streaming:1;
+	unsigned int		   reading:1;
 	unsigned int		   is_mmapped:1;
 
 	/* capture via mmap() + ioctl(QBUF/DQBUF) */
-	struct list_head           stream;
+	struct list_head	   stream;
 
 	/* capture via read() */
-	unsigned int               read_off;
-	struct videobuf_buffer     *read_buf;
+	unsigned int		   read_off;
+	struct videobuf_buffer	   *read_buf;
 
 	/* driver private data */
-	void                       *priv_data;
+	void			   *priv_data;
 };
 
 int videobuf_waiton(struct videobuf_buffer *vb, int non_blocking, int intr);
diff --git a/include/media/videobuf-dma-sg.h b/include/media/videobuf-dma-sg.h
index 3810503..cfc8409 100644
--- a/include/media/videobuf-dma-sg.h
+++ b/include/media/videobuf-dma-sg.h
@@ -1,5 +1,5 @@
 /*
- * helper functions for PCI DMA video4linux capture buffers
+ * helper functions for SG DMA video4linux capture buffers
  *
  * The functions expect the hardware being able to scatter gatter
  * (i.e. the buffers are not linear in physical memory, but fragmented
@@ -81,7 +81,7 @@ struct videobuf_dmabuf {
 	int                 direction;
 };
 
-struct videbuf_pci_sg_memory
+struct videobuf_dma_sg_memory
 {
 	u32                 magic;
 
@@ -103,11 +103,11 @@ int videobuf_dma_sync(struct videobuf_queue* q,struct videobuf_dmabuf *dma);
 int videobuf_dma_unmap(struct videobuf_queue* q,struct videobuf_dmabuf *dma);
 struct videobuf_dmabuf *videobuf_to_dma (struct videobuf_buffer *buf);
 
-void *videobuf_pci_alloc (size_t size);
+void *videobuf_sg_alloc(size_t size);
 
-void videobuf_queue_pci_init(struct videobuf_queue* q,
+void videobuf_queue_sg_init(struct videobuf_queue* q,
 			 struct videobuf_queue_ops *ops,
-			 void *dev,
+			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
 			 enum v4l2_field field,
@@ -117,6 +117,6 @@ void videobuf_queue_pci_init(struct videobuf_queue* q,
 	/*FIXME: these variants are used only on *-alsa code, where videobuf is
 	 * used without queue
 	 */
-int videobuf_pci_dma_map(struct pci_dev *pci,struct videobuf_dmabuf *dma);
-int videobuf_pci_dma_unmap(struct pci_dev *pci,struct videobuf_dmabuf *dma);
+int videobuf_sg_dma_map(struct device *dev, struct videobuf_dmabuf *dma);
+int videobuf_sg_dma_unmap(struct device *dev, struct videobuf_dmabuf *dma);
 
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index a865045..b9b38d9 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -160,7 +160,7 @@ config VIDEOBUF_GEN
 	tristate
 
 config VIDEOBUF_DMA_SG
-	depends on PCI || ARCH_PXA
+	depends on HAS_DMA
 	select VIDEOBUF_GEN
 	tristate
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
